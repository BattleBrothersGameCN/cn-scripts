this.clubfooted_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.clubfooted";
		this.m.Name = "畸形足";
		this.m.Icon = "ui/traits/trait_icon_23.png";
		this.m.Description = "从小患有畸形足，这名角色走路难过他人。";
		this.m.Titles = [];
		this.m.Excluded = [
			"trait.weasel",
			"trait.athletic",
			"trait.quick",
			"trait.sure_footing",
			"trait.impatient",
			"trait.swift",
			"trait.lucky"
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
				text = "走过一格的疲劳值积累增加[color=" + this.Const.UI.Color.NegativeValue + "]2[/color]"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.MovementFatigueCostAdditional += 2;
	}

});
