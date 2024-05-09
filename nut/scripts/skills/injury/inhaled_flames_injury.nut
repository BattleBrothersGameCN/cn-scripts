this.inhaled_flames_injury <- this.inherit("scripts/skills/injury/injury", {
	m = {},
	function create()
	{
		this.injury.create();
		this.m.ID = "injury.inhaled_flames";
		this.m.Name = "吸入火焰";
		this.m.Description = "很明显第二个通气孔没有什么用，只会让你听起来像个风笛。";
		this.m.Type = this.m.Type | this.Const.SkillType.TemporaryInjury;
		this.m.DropIcon = "injury_icon_49";
		this.m.Icon = "ui/injury/injury_icon_49.png";
		this.m.IconMini = "injury_icon_49_mini";
		this.m.HealingTimeMin = 4;
		this.m.HealingTimeMax = 6;
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
				icon = "ui/icons/action_points.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-2[/color] 行动点"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-40%[/color] 最大疲劳值"
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

		_properties.ActionPoints -= 2;
		_properties.StaminaMult *= 0.6;
	}

});
