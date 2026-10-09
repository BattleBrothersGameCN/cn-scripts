this.rf_goblin_racial <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "racial.rf_goblin";
		this.m.Name = "地精";
		this.m.Description = "该角色是一名地精";
		this.m.Icon = "ui/orientation/goblin_01_orientation.png";
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
			text = ::Reforged.Mod.Tooltips.parseString("[投网|Skill+throw_net]的技能范围提升1格，最多为3格")
		});
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		local throwNet = this.getContainer().getSkillByID("actives.throw_net");

		if (throwNet != null && throwNet.m.MaxRange < 3)
		{
			throwNet.m.MaxRange += 1;
		}
	}

});
