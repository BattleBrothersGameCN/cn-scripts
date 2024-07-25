this.bruised_leg_injury <- this.inherit("scripts/skills/injury/injury", {
	m = {},
	function create()
	{
		this.injury.create();
		this.m.ID = "injury.bruised_leg";
		this.m.Name = "腿部瘀伤";
		this.m.Description = "腿部严重瘀伤极大地限制了活动性，好在不久就能痊愈。";
		this.m.Type = this.m.Type | this.Const.SkillType.TemporaryInjury;
		this.m.DropIcon = "injury_icon_26";
		this.m.Icon = "ui/injury/injury_icon_26.png";
		this.m.IconMini = "injury_icon_26_mini";
		this.m.HealingTimeMin = 2;
		this.m.HealingTimeMax = 3;
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
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]+1[/color] 每移动一格的行动点消耗"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20%[/color]主动值"
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

		_properties.MovementAPCostAdditional += 1;
		_properties.InitiativeMult *= 0.8;
	}

});
