this.rf_flaming_arrows_skill <- ::inherit("scripts/skills/actives/aimed_shot", {
	m = {
		TargetTile = null,
		RangeModifier = -1
	},
	function create()
	{
		this.aimed_shot.create();
		this.m.ID = "actives.rf_flaming_arrows";
		this.m.Name = "燃烧箭";
		this.m.Description = "一支绑着可燃物，会造成额外燃烧伤害，点燃目标地格，射起来有些别扭的箭。";
		this.m.Icon = "skills/rf_flaming_arrows_skill.png";
		this.m.IconDisabled = "skills/rf_flaming_arrows_skill_sw.png";
		this.m.Overlay = "rf_flaming_arrows_skill";
		this.m.ProjectileType = ::Const.ProjectileType.FlamingArrow;
		this.m.InjuriesOnBody = ::Const.Injury.BurningAndPiercingBody;
		this.m.InjuriesOnHead = ::Const.Injury.BurningAndPiercingHead;
		this.m.AdditionalAccuracy = 0;
		this.m.AdditionalHitChance = -4;
	}

	function getTooltip()
	{
		local ret = this.getRangedTooltip(this.getDefaultTooltip());
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("会触发一次目标和接邻敌人的负面[士气检定|Concept.MoraleCheck]")
		});
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("命中目标后，点燃该地格" + ::MSU.Text.colorNegative(2) + " [轮|Concept.Round]")
		});
		local ammo = this.getAmmo();

		if (ammo > 0)
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/icons/ammo.png",
				text = "剩余" + ::MSU.Text.colorPositive(ammo) + "支箭"
			});
		}
		else
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::MSU.Text.colorNegative("需要装备非空箭袋")
			});
		}

		if (this.getContainer().getActor().isEngagedInMelee())
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("角色[陷入近战|Concept.ZoneOfControl]，无法使用"))
			});
		}

		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.aimed_shot.onAfterUpdate(_properties);
		this.m.MaxRange += this.m.RangeModifier;
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		this.aimed_shot.onBeforeTargetHit(_skill, _targetEntity, _hitInfo);

		if (_skill == this)
		{
			this.m.TargetTile = _targetEntity.getTile();
		}
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		this.aimed_shot.onTargetHit(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);

		if (this.m.TargetTile == null || _skill != this)
		{
			return;
		}

		if (_targetEntity.isAlive() && !_targetEntity.isDying() && _targetEntity.getMoraleState() != ::Const.MoraleState.Ignore)
		{
			_targetEntity.checkMorale(-1, ::Const.Morale.OnHitBaseDifficulty * (1.0 - _targetEntity.getHitpoints() / _targetEntity.getHitpointsMax()));
		}

		for( local i = 0; i < 6; i++ )
		{
			if (this.m.TargetTile.hasNextTile(i))
			{
				local nextTile = this.m.TargetTile.getNextTile(i);

				if (nextTile.IsOccupiedByActor)
				{
					local enemy = nextTile.getEntity();

					if (!enemy.isAlliedWith(this.getContainer().getActor()) && enemy.getMoraleState() != ::Const.MoraleState.Ignore)
					{
						enemy.checkMorale(-1, ::Const.Morale.OnHitBaseDifficulty * (1.0 - enemy.getHitpoints() / enemy.getHitpointsMax()));
					}
				}
			}
		}

		::Time.scheduleEvent(::TimeUnit.Real, 50, this.onApply.bindenv(this), {
			Skill = this,
			User = this.getContainer().getActor(),
			TargetTile = this.m.TargetTile
		});
	}

	function onApply( _data )
	{
		::Tactical.State.spawnFireOnTile(_data.TargetTile, _data.User.isPlayerControlled(), true);
		this.m.TargetTile = null;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.TargetTile = null;
	}

});
