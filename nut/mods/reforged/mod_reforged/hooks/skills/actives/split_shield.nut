::Reforged.HooksMod.hook("scripts/skills/actives/split_shield", function ( q )
{
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.skill.getDefaultUtilityTooltip();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/shield_damage.png",
					text = "对目标施加" + ::MSU.Text.colorDamage(this.getContainer().getActor().getMainhandItem().getShieldDamage()) + "点伤害"
				});
				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("对目标施加" + ::MSU.Text.colorDamage(this.RF_getFatigueDamage()) + "点[疲劳|Concept.Fatigue]")
				});

				if (this.getMaxRange() > 1)
				{
					ret.push({
						id = 8,
						type = "text",
						icon = "ui/icons/vision.png",
						text = "攻击范围为" + ::MSU.Text.colorPositive(this.m.MaxRange) + "格"
					});
				}

				return ret;
			}

		}.getTooltip;
	};
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Name = "砸击盾牌";
				this.m.Description = "特意瞄准对手盾牌的攻击。只能对持有盾牌的对手使用。一定会命中，破坏盾牌的同时，还会加速对手疲劳。。";
			}

		}.create;
	};
	q.onUse = function ()
	{
		return {
			function onUse( _user, _targetTile )
			{
				local targetEntity = _targetTile.getEntity();
				local shield = targetEntity.getOffhandItem();

				if (shield != null)
				{
					this.spawnAttackEffect(_targetTile, ::Const.Tactical.AttackEffectSplitShield);
					local damage = _user.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand).getShieldDamage();
					local conditionBefore = shield.getCondition();
					shield.applyShieldDamage(damage);

					if (shield.getCondition() == 0)
					{
						if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
						{
							::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + "使出砸击盾牌，摧毁了" + ::Const.UI.getColorizedEntityName(_targetTile.getEntity()) + "的盾牌");
						}
					}
					else
					{
						if (this.m.SoundOnHit.len() != 0)
						{
							::Sound.play(this.m.SoundOnHit[::Math.rand(0, this.m.SoundOnHit.len() - 1)], ::Const.Sound.Volume.Skill, _targetTile.getEntity().getPos());
						}

						if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
						{
							::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + "使出砸击盾牌，对" + ::Const.UI.getColorizedEntityName(_targetTile.getEntity()) + "的盾牌造成了[b]" + (conditionBefore - shield.getCondition()) + "[/b]点伤害");
						}
					}

					if (!::Tactical.getNavigator().isTravelling(_targetTile.getEntity()))
					{
						::Tactical.getShaker().shake(_targetTile.getEntity(), _user.getTile(), 2, ::Const.Combat.ShakeEffectSplitShieldColor, ::Const.Combat.ShakeEffectSplitShieldHighlight, ::Const.Combat.ShakeEffectSplitShieldFactor, 1.0, [
							"shield_icon"
						], 1.0);
					}

					_user.getSkills().onTargetHit(this, targetEntity, ::Const.BodyPart.Body, 0, 0);
					local targetProperties = targetEntity.getCurrentProperties();
					local fatigueDamage = this.RF_getFatigueDamage() * targetProperties.FatigueEffectMult;

					if (fatigueDamage != 0)
					{
						targetEntity.setFatigue(::Math.min(targetEntity.getFatigueMax(), ::Math.round(targetEntity.getFatigue() + fatigueDamage * targetProperties.FatigueReceivedPerHitMult * targetProperties.FatigueLossOnAnyAttackMult)));
					}
				}

				return true;
			}

		}.onUse;
	};
	q.RF_getFatigueDamage <- {
		function RF_getFatigueDamage()
		{
			return ::MSU.isNull(this.getItem()) ? this.getContainer().getActor().getMainhandItem().getShieldDamage() : this.getItem().getShieldDamage();
		}

	}.RF_getFatigueDamage;
});
