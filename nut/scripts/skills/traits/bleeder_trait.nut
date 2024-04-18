this.bleeder_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.bleeder";
		this.m.Name = "出血体质";
		this.m.Icon = "ui/traits/trait_icon_16.png";
		this.m.Description = "这个角色容易流血，而且流血的时间比大多数其他角色长。";
		this.m.Excluded = [
			"trait.tough",
			"trait.iron_jaw",
			"trait.survivor"
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
				text = "额外受到 [color=" + this.Const.UI.Color.NegativeValue + "]1[/color] 回合流血伤害"
			}
		];
	}

});
