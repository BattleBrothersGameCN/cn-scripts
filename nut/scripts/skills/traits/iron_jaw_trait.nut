this.iron_jaw_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.iron_jaw";
		this.m.Name = "铁颌";
		this.m.Icon = "ui/traits/trait_icon_44.png";
		this.m.Description = "这个角色能够摆脱那些会让一个弱者瘫痪的打击。";
		this.m.Titles = [
			"铁颌(Ironjaw)",
			"岩石(the Rock)",
			"种马(the Stallion)"
		];
		this.m.Excluded = [
			"trait.fragile",
			"trait.fainthearted",
			"trait.bleeder",
			"trait.tiny",
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
				text = "被命中时遭受伤残的伤害阈值提高 [color=" + this.Const.UI.Color.PositiveValue + "]25%[/color]"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.ThresholdToReceiveInjuryMult *= 1.250000;
	}

});
