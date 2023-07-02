this.craven_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.craven";
		this.m.Name = "懦夫";
		this.m.Icon = "ui/traits/trait_icon_40.png";
		this.m.Description = "逃命吧！这个角色是个懦夫，只要有一点不利的迹象，他就会逃跑。";
		this.m.Titles = [
			"胆小鬼(the Coward)",
			"懦夫(the Craven)",
			"变节者(Turncoat)",
			"没骨气(the Spineless)"
		];
		this.m.Excluded = [
			"trait.fearless",
			"trait.brave",
			"trait.determined",
			"trait.fainthearted",
			"trait.deathwish",
			"trait.cocky",
			"trait.bloodthirsty",
			"trait.hate_greenskins",
			"trait.hate_undead",
			"trait.hate_beasts"
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
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] 决心"
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = "总是满足于充当后备"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += -10;
		_properties.IsContentWithBeingInReserve = true;
	}

});
