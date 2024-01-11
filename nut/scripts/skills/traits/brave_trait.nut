this.brave_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.brave";
		this.m.Name = "勇敢";
		this.m.Icon = "ui/traits/trait_icon_37.png";
		this.m.Description = "前进就是了。这个角色将勇敢地冒险进入未知领域。";
		this.m.Titles = [
			"勇士(the Brave)",
			"英雄(the Hero)"
		];
		this.m.Excluded = [
			"trait.weasel",
			"trait.insecure",
			"trait.craven",
			"trait.hesitant",
			"trait.dastard",
			"trait.fainthearted",
			"trait.fearless",
			"trait.paranoid",
			"trait.fear_beasts",
			"trait.fear_undead",
			"trait.fear_greenskins"
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
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] 决心"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += 5;
	}

});
