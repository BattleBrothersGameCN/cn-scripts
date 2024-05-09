this.fractured_ribs_injury <- this.inherit("scripts/skills/injury/injury", {
	m = {},
	function create()
	{
		this.injury.create();
		this.m.ID = "injury.fractured_ribs";
		this.m.Name = "肋骨骨折";
		this.m.Description = "肋骨的骨折使得每次呼吸身体都会感到疼痛。";
		this.m.Type = this.m.Type | this.Const.SkillType.TemporaryInjury;
		this.m.DropIcon = "injury_icon_02";
		this.m.Icon = "ui/injury/injury_icon_02.png";
		this.m.IconMini = "injury_icon_02_mini";
		this.m.HealingTimeMin = 3;
		this.m.HealingTimeMax = 4;
		this.m.IsShownOnBody = true;
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
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-30%[/color] 最大疲劳值"
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

		_properties.StaminaMult *= 0.7;
	}

});
