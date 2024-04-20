this.quick_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.quick";
		this.m.Name = "快速";
		this.m.Icon = "ui/traits/trait_icon_18.png";
		this.m.Description = "已经到了！这个角色行动迅速，通常比他的对手更快。";
		this.m.Titles = [
			"快人(the Quick)"
		];
		this.m.Excluded = [
			"trait.huge",
			"trait.hesitant",
			"trait.clubfooted"
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
				id = 10,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color]主动值"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Initiative += 10;
	}

});
