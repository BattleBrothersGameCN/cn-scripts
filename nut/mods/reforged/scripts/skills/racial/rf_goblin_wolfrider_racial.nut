this.rf_goblin_wolfrider_racial <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "racial.rf_goblin_wolfrider";
		this.m.Name = "骑狼";
		this.m.Description = "角色骑在狼上，提高了使用武器的难度。";
		this.m.Icon = "ui/orientation/goblin_05_orientation.png";
		this.m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Any;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/rf_reach.png",
			text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+1") + "[触及距离|Concept.Reach]")
		});
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::Reforged.Mod.Tooltips.parseString("武器技能消耗的[行动点数|Concept.ActionPoints]" + ::MSU.Text.colorNegative("+1") + " [Action Point|Concept.ActionPoints]")
		});
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.Reach += 1;
	}

	function onAfterUpdate( _properties )
	{
		local weapon = this.getContainer().getActor().getMainhandItem();

		if (weapon == null)
		{
			return;
		}

		foreach( skill in weapon.getSkills() )
		{
			skill.m.ActionPointCost += 1;
		}
	}

});
