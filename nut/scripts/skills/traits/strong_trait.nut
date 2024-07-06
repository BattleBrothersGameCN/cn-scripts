this.strong_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.strong";
		this.m.Name = "强壮";
		this.m.Icon = "ui/traits/trait_icon_15.png";
		this.m.Description = "饮食饱足，身体健壮到极致。";
		this.m.Titles = [
			"大壮(the Strong)",
			"公牛(the Bull)",
			"壮牛(the Ox)",
			"大熊(the Bear)",
			"大个子(the Big)"
		];
		this.m.Excluded = [
			"trait.tiny",
			"trait.fragile",
			"trait.fat",
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
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] 点疲劳值上限"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Stamina += 10;
	}

});
