this.superstitious_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.superstitious";
		this.m.Name = "迷信";
		this.m.Icon = "ui/traits/trait_icon_26.png";
		this.m.Description = "这是诅咒！这个角色非常迷信，因此更容易受到直接攻击他的决心的技能的影响。";
		this.m.Excluded = [
			"trait.fearless",
			"trait.brave"
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
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] 决心（仅在恐惧、恐慌或精神控制士气检查中生效）"
			}
		];
	}

});
