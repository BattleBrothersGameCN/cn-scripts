this.ailing_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.ailing";
		this.m.Name = "虚弱";
		this.m.Icon = "ui/traits/trait_icon_59.png";
		this.m.Description = "这个人总是面色苍白，处于病态，这使他特别容易受毒物的影响。";
		this.m.Titles = [
			"苍白者(the Pale)",
			"病弱者(the Sickly)",
			"衰弱者(the Ailing)"
		];
		this.m.Excluded = [
			"trait.tough",
			"trait.iron_jaw",
			"trait.survivor",
			"trait.strong",
			"trait.athletic",
			"trait.iron_lungs",
			"trait.lucky",
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
				icon = "ui/icons/special.png",
				text = "中毒效果额外持续 [color=" + this.Const.UI.Color.NegativeValue + "]1[/color] 回合"
			}
		];
	}

});
