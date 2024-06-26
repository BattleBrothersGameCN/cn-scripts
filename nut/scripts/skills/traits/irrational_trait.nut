this.irrational_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.irrational";
		this.m.Name = "不理性";
		this.m.Icon = "ui/traits/trait_icon_28.png";
		this.m.Description = "刚刚这杯子还是半满的，怎么现在有半空了。";
		this.m.Excluded = [
			"trait.pessimist",
			"trait.optimist",
			"trait.insecure"
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
				text = "每当士气检查时，随机 [color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] 或 [color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] 决心"
			}
		];
	}

});
