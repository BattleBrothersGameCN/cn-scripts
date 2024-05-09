this.survivor_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.survivor";
		this.m.Name = "幸存者";
		this.m.Icon = "ui/traits/trait_icon_43.png";
		this.m.Description = "你怎么就死不了呢？这个角色是一个幸存者，他的寿命比大多数同龄人都要长。";
		this.m.Titles = [
			"幸存者(the Survivor)",
			"幸运星(the Lucky)",
			"蒙福者(the Blessed)"
		];
		this.m.Excluded = [
			"trait.bleeder",
			"trait.pessimist",
			"trait.deathwish",
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
				text = "有 [color=" + this.Const.UI.Color.PositiveValue + "]90%[/color] 几率在被非致命伤害击倒时幸存"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.SurviveWithInjuryChanceMult *= 2.72;
	}

});
