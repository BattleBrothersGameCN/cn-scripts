this.rf_orc_racial <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "racial.rf_orc";
		this.m.Name = "兽人";
		this.m.Description = "该角色是兽人。";
		this.m.Icon = "ui/orientation/orc_02_orientation.png";
		this.m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Last;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("遭受[创伤|Concept.InjuryTemporary]的[阈值|Concept.InjuryThreshold]提高" + ::MSU.Text.colorPositive("25%"))
		});
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.ThresholdToReceiveInjuryMult *= 1.25;
	}

});
