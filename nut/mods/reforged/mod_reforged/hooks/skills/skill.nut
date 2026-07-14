::Reforged.HooksMod.hook("scripts/skills/skill", function ( q )
{
	q.m.__RF_SkillCount <- 0;
	q.m.__RF_LastTargetID <- 0;
	q.m.__RF_LastAttackerID <- 0;
	q.RF_isNewSkillUseOrEntity <- {
		function RF_isNewSkillUseOrEntity( _entity, _isAttacker = false )
		{
			local id = _entity == null ? 0 : _entity.getID();

			if (::Const.SkillCounter == this.m.__RF_SkillCount && id == (_isAttacker ? this.m.__RF_LastAttackerID : this.m.__RF_LastTargetID))
			{
				return false;
			}

			this.m.__RF_SkillCount = ::Const.SkillCounter;

			if (_isAttacker)
			{
				this.m.__RF_LastAttackerID = id;
			}
			else
			{
				this.m.__RF_LastTargetID = id;
			}

			return true;
		}

	}.RF_isNewSkillUseOrEntity;
	q.onSkillsUpdated <- {
		function onSkillsUpdated()
		{
		}

	}.onSkillsUpdated;
	q.isDuelistValid <- {
		function isDuelistValid()
		{
			return this.isAttack() && !this.isRanged() && !this.isAOE() && this.getBaseValue("MaxRange") == 1;
		}

	}.isDuelistValid;
	q.getHitFactors = function ( __original )
	{
		return {
			function getHitFactors( _targetTile )
			{
				local ret = __original(_targetTile);

				for( local index = ret.len() - 1; index >= 0; index-- )
				{
					switch(ret[index].text)
					{
					case "Immune to stun":
					case "Immune to being rooted":
					case "Immune to being disarmed":
					case "Immune to being knocked back or hooked":
						ret[index].icon = "ui/tooltips/warning.png";
						break;

					case "Fast Adaption":
					case "Armed with shield":
					case "Riposte":
					case "Resistance against ranged weapons":
					case "Resistance against piercing attacks":
					case "Nighttime":
					case "On bad terrain":
					case "Target on bad terrain":
						ret.remove(index);
						break;

					case "Too close":
					case this.getName():
						if (this.m.HitChanceBonus == 0)
						{
							break;
						}

						if (this.m.HitChanceBonus < 0)
						{
							ret[index].text = ::MSU.Text.colorNegative(this.m.HitChanceBonus + "% ") + ret[index].text;
						}
						else
						{
							ret[index].text = ::MSU.Text.colorPositive(this.m.HitChanceBonus + "% ") + ret[index].text;
						}

						break;

					case "Height disadvantage":
						ret[index].text = ::MSU.Text.colorNegative(::Const.Combat.LevelDifferenceToHitMalus * (_targetTile.Level - this.m.Container.getActor().getTile().Level) + "% ") + "高度劣势";
						break;

					case "Height advantage":
						ret[index].text = ::MSU.Text.colorPositive(::Const.Combat.LevelDifferenceToHitBonus + "% ") + "高度优势";
						break;

					case "Surrounded":
						if (_targetTile.IsOccupiedByActor)
						{
							local bonus = this.getContainer().getActor().getSurroundedBonus(_targetTile.getEntity());

							if (bonus > 0)
							{
								ret[index].text = ::MSU.Text.colorPositive(bonus + "%") + "被围攻";
							}
						}

						break;
					}
				}

				if (!this.m.IsShieldRelevant && _targetTile.IsOccupiedByActor && _targetTile.getEntity().isArmedWithShield())
				{
					local shield = _targetTile.getEntity().getItems().getItemAtSlot(::Const.ItemSlot.Offhand);
					local bonus = this.isRanged() ? shield.getRangedDefenseBonus() : shield.getMeleeDefenseBonus();

					if (bonus > 0)
					{
						ret.push({
							icon = "ui/tooltips/positive.png",
							text = ::MSU.Text.colorPositive(bonus + "%") + "无视盾牌"
						});
					}
				}

				if (this.isAttack() && _targetTile.IsOccupiedByActor)
				{
					local target = _targetTile.getEntity();

					if (!target.getCurrentProperties().IsImmuneToHeadshots && (!::MSU.isIn("IsHeadless", target.m, true) || !target.m.IsHeadless))
					{
						local p = this.getContainer().buildPropertiesForUse(this, target);
						local headshotChance = p.getHitchance(::Const.BodyPart.Head);

						if (headshotChance <= 0)
						{
							ret.push({
								icon = "ui/icons/chance_to_hit_head.png",
								text = this.format("无法取得头部命中")
							});
						}
						else
						{
							local headshotDamageMult = target.getCurrentProperties().IsImmuneToCriticals ? 1.0 : p.DamageAgainstMult[::Const.BodyPart.Head];
							ret.push({
								icon = "ui/icons/chance_to_hit_head.png",
								text = this.format("有%s概率命中头部，造成%s倍伤害", ::MSU.Text.colorizeValue(headshotChance, {
									AddPercent = true
								}), ::MSU.Text.colorizeMultWithText(headshotDamageMult))
							});
						}
					}
				}

				return ret;
			}

		}.getHitFactors;
	};
	q.isTargeted = function ()
	{
		return {
			function isTargeted()
			{
				if (this.m.IsTargeted)
				{
					return true;
				}

				if (::Reforged.Mod.ModSettings.getSetting("ConfirmSkillUse").getValue())
				{
					return !::Reforged.Mod.Keybinds.isKeybindPressed("ConfirmSkillUseKeybind");
				}

				return ::Reforged.Mod.Keybinds.isKeybindPressed("ConfirmSkillUseKeybind");
			}

		}.isTargeted;
	};
});
::Reforged.HooksMod.hookTree("scripts/skills/skill", function ( q )
{
	if (q.contains("create"))
	{
		q.create = function ( __original )
		{
			return {
				function create()
				{
					__original();

					if (this.m.Icon == this.m.IconDisabled || this.m.IconDisabled == "")
					{
						this.m.IconDisabled = ::String.replace(this.m.Icon, ".png", "_sw.png");
					}

					if (!this.m.IsTargeted)
					{
						this.m.MinRange = 0;
						this.m.MaxRange = 0;
					}
				}

			}.create;
		};
	}

	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();

				if (::Tactical.isActive() && this.isActive() && !this.m.IsTargeted)
				{
					ret.push({
						id = 100,
						type = "hint",
						icon = "ui/icons/rf_mouse_left_button_ctrl.png",
						text = this.format("按住%s来%s", ::Reforged.Mod.ModSettings.getSetting("ConfirmSkillUseKeybind").getValue(), ::Reforged.Mod.ModSettings.getSetting("ConfirmSkillUse").getValue() ? "立即使用技能" : "预览技能效果")
					});
				}

				return ret;
			}

		}.getTooltip;
	};
	q.onVerifyTarget = function ( __original )
	{
		return {
			function onVerifyTarget( _userTile, _targetTile )
			{
				return this.m.IsTargeted ? __original(_userTile, _targetTile) : _userTile.isSameTileAs(_targetTile);
			}

		}.onVerifyTarget;
	};
});
