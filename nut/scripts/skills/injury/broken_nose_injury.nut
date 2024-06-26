this.broken_nose_injury <- this.inherit("scripts/skills/injury/injury", {
	m = {},
	function create()
	{
		this.injury.create();
		this.m.ID = "injury.broken_nose";
		this.m.Name = "鼻骨骨折";
		this.m.Description = "钝器打断了这个角色的鼻子，使他难以正常呼吸。";
		this.m.Type = this.m.Type | this.Const.SkillType.TemporaryInjury;
		this.m.DropIcon = "injury_icon_22";
		this.m.Icon = "ui/injury/injury_icon_22.png";
		this.m.IconMini = "injury_icon_22_mini";
		this.m.HealingTimeMin = 3;
		this.m.HealingTimeMax = 5;
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
				id = 11,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] 每回合疲劳值恢复量"
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

		_properties.FatigueRecoveryRate -= 5;
	}

});
