this.rf_shield_bash_skill <- ::inherit("scripts/skills/skill", {
	m = {
		MeleeSkillAdd = 25
	},
	function create()
	{
		this.m.ID = "actives.rf_shield_bash";
		this.m.Name = "盾牌猛击";
		this.m.Description = "将你的盾牌猛然撞向敌人，使他们失去平衡，晕头转向。";
		this.m.Icon = "skills/rf_shield_bash_skill.png";
		this.m.IconDisabled = "skills/rf_shield_bash_skill_sw.png";
		this.m.Overlay = "rf_shield_bash_skill";
		this.m.SoundOnUse = [
			"sounds/combat/knockback_01.wav",
			"sounds/combat/knockback_02.wav",
			"sounds/combat/knockback_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/knockback_hit_01.wav",
			"sounds/combat/knockback_hit_02.wav",
			"sounds/combat/knockback_hit_03.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.AIBehaviorID = ::Const.AI.Behavior.ID.Distract;
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();

		if (this.m.MeleeSkillAdd != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("命中率" + ::MSU.Text.colorizeValue(this.m.MeleeSkillAdd, {
					AddSign = true,
					AddPercent = true
				}) + " chance to hit")
			});
		}

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("对命中的目标施加[茫然|Skill+dazed_effect]效果")
		});
		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return this.skill.onVerifyTarget(_originTile, _targetTile) && !_targetTile.getEntity().getCurrentProperties().IsImmuneToDaze;
	}

	function onUse( _user, _targetTile )
	{
		local targetEntity = _targetTile.getEntity();
		this.spawnAttackEffect(_targetTile, ::Const.Tactical.AttackEffectImpale);

		if (!this.attackEntity(_user, targetEntity))
		{
			return false;
		}

		targetEntity.getSkills().add(::new("scripts/skills/effects/dazed_effect"));

		if (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + "茫然了" + ::Const.UI.getColorizedEntityName(targetEntity));
		}

		::Sound.play(::MSU.Array.rand(this.m.SoundOnHit), ::Const.Sound.Volume.Skill, targetEntity.getPos());
		return true;
	}

	function onAfterUpdate( _properties )
	{
		if (_properties.IsProficientWithShieldSkills)
		{
			this.m.FatigueCostMult *= ::Const.Combat.WeaponSpecFatigueMult;
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageTotalMult = 0.0;
			_properties.MeleeSkill += this.m.MeleeSkillAdd;
		}
	}

});
