this.pierced_leg_muscles_injury <- this.inherit("scripts/skills/injury/injury", {
	m = {},
	function create()
	{
		this.injury.create();
		this.m.ID = "injury.pierced_leg_muscles";
		this.m.Name = "腿部肌肉穿孔";
		this.m.Description = "被刺穿的腿部肌肉使得突然快速行动即使可能，也会是一段痛苦的经历。";
		this.m.Type = this.m.Type | this.Const.SkillType.TemporaryInjury;
		this.m.DropIcon = "injury_icon_11";
		this.m.Icon = "ui/injury/injury_icon_11.png";
		this.m.IconMini = "injury_icon_11_mini";
		this.m.HealingTimeMin = 3;
		this.m.HealingTimeMax = 5;
		this.m.InfectionChance = 1.0;
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-30%[/color] 近战防御"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-30%[/color]主动值"
			}
		];
		this.addTooltipHint(ret);
		return ret;
	}

	function onUpdate( _properties )
	{
		this.injury.onUpdate(_properties);

		if (!_properties.IsAffectedByInjuries || this.m.IsFresh && !_properties.IsAffectedByFreshInjuries)
		{
			return;
		}

		_properties.MeleeDefenseMult *= 0.7;
		_properties.InitiativeMult *= 0.7;
	}

});
