this.impale <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.impale";
		this.m.Name = "刺击";
		this.m.Description = "一种穿透攻击，可以覆盖2格的距离，可以从前线后方使用，超出大多数近战武器的范围。";
		this.m.KilledString = "刺穿";
		this.m.Icon = "skills/active_30.png";
		this.m.IconDisabled = "skills/active_30_sw.png";
		this.m.Overlay = "active_30";
		this.m.SoundOnUse = [
			"sounds/combat/impale_01.wav",
			"sounds/combat/impale_02.wav",
			"sounds/combat/impale_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/impale_hit_01.wav",
			"sounds/combat/impale_hit_02.wav",
			"sounds/combat/impale_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = false;
		this.m.IsTooCloseShown = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.DirectDamageMult = 0.3;
		this.m.HitChanceBonus = 10;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "攻击范围为 [color=" + this.Const.UI.Color.PositiveValue + "]2[/color] 格"
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "有 [color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] 命中几率"
		});

		if (!this.getContainer().getActor().getCurrentProperties().IsSpecializedInPolearms)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "有 [color=" + this.Const.UI.Color.NegativeValue + "]-15%[/color] 施展不便命中惩罚（对近身敌人）"
			});
		}

		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInPolearms ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		this.m.ActionPointCost = _properties.IsSpecializedInPolearms ? 5 : 6;
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectImpale);
		return this.attackEntity(_user, _targetTile.getEntity());
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.MeleeSkill += 10;

			if (_targetEntity != null && !this.getContainer().getActor().getCurrentProperties().IsSpecializedInPolearms && this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile()) == 1)
			{
				_properties.MeleeSkill += -15;
				this.m.HitChanceBonus = -5;
			}
			else
			{
				this.m.HitChanceBonus = 10;
			}
		}
	}

});
