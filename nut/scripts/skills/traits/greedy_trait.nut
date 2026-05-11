this.greedy_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.greedy";
		this.m.Name = "贪婪";
		this.m.Icon = "ui/traits/trait_icon_06.png";
		this.m.Description = "我还要更多！这个角色很贪婪，其日薪会比类似背景的人更高，一旦你的克朗用完，他会很快离开。";
		this.m.Excluded = [];
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

	function addTitle()
	{
		this.character_trait.addTitle();
	}

	function onUpdate( _properties )
	{
		_properties.DailyWageMult *= 1.15;
	}

});
