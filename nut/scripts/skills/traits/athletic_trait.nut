this.athletic_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.athletic";
		this.m.Name = "身强体壮";
		this.m.Icon = "ui/traits/trait_icon_21.png";
		this.m.Description = "这个角色身体健康壮实。";
		this.m.Titles = [];
		this.m.Excluded = [
			"trait.asthmatic",
			"trait.clubfooted",
			"trait.fat",
			"trait.gluttonous",
			"trait.ailing"
		];
	}

	function getTooltip()
	{
		return [
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
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]-2[/color] 疲劳值增量（每行走一格）"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.MovementFatigueCostAdditional -= 2;
	}

});
