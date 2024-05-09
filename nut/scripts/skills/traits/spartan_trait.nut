this.spartan_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.spartan";
		this.m.Name = "斯巴达人";
		this.m.Icon = "ui/traits/trait_icon_08.png";
		this.m.Description = "谁需要比燕麦片和水更好的食物呢？这个角色在进食中体会不到快乐，因此会使用更少的口粮，当你的口粮完全用完时，也不会离开你得那么快。";
		this.m.Excluded = [
			"trait.fat",
			"trait.gluttonous"
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
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.DailyFood -= 1.0;
	}

});
