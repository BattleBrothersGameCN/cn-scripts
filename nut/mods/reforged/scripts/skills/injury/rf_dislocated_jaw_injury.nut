this.rf_dislocated_jaw_injury <- ::inherit("scripts/skills/injury/injury", {
	m = {
		FatigueRecoveryModifier = -3,
		BraveryMult = 0.7,
		IsApplyingBraveryMult = false
	},
	function create()
	{
		this.injury.create();
		this.m.ID = "injury.rf_dislocated_jaw";
		this.m.Name = "下巴脱臼";
		this.m.Description = "一记猛击打得下巴脱臼，别说是说话了，喘口气都十分痛苦。";
		this.m.Type = this.m.Type | ::Const.SkillType.TemporaryInjury;
		this.m.DropIcon = "rf_dislocated_jaw_injury";
		this.m.Icon = "ui/injury/rf_dislocated_jaw_injury.png";
		this.m.IconMini = "rf_dislocated_jaw_injury_mini";
		this.m.HealingTimeMin = 1;
		this.m.HealingTimeMax = 2;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (this.m.FatigueRecoveryModifier != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.FatigueRecoveryModifier, {
					AddSign = true
				}) + " [Fatigue Recovery|Concept.FatigueRecovery]")
			});
		}

		if (this.m.BraveryMult != 1.0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMult(this.m.BraveryMult) + " less [Resolve|Concept.Bravery] during skill use except attacks")
			});
		}

		this.addTooltipHint(ret);
		return ret;
	}

	function onBeforeAnySkillExecuted( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (!_skill.isAttack())
		{
			this.m.IsApplyingBraveryMult = true;
		}
	}

	function onAnySkillExecuted( _skill, _targetTile, _targetEntity, _forFree )
	{
		this.m.IsApplyingBraveryMult = false;
	}

	function onUpdate( _properties )
	{
		this.injury.onUpdate(_properties);

		if (!_properties.IsAffectedByInjuries || this.m.IsFresh && !_properties.IsAffectedByFreshInjuries)
		{
			return;
		}

		_properties.FatigueRecoveryRate += this.m.FatigueRecoveryModifier;
		local actor = this.getContainer().getActor();

		if (this.m.IsApplyingBraveryMult || actor.isPreviewing() && actor.getPreviewSkill() != null && !actor.getPreviewSkill().isAttack())
		{
			_properties.BraveryMult *= this.m.BraveryMult;
		}
	}

});
