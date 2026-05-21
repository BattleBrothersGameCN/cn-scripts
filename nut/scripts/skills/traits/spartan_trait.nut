this.spartan_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.spartan";
		this.m.Name = "清苦";
		this.m.Icon = "ui/traits/trait_icon_08.png";
		this.m.Description = "谁还需要燕麦粥和水以外的食物？这名角色对饮食毫无享乐之心，因此会消耗更少的补给，而且在补给完全耗尽时也不会那么快离你而去。";
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
