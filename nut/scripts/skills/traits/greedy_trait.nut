this.greedy_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.greedy";
		this.m.Name = "贪婪";
		this.m.Icon = "ui/traits/trait_icon_06.png";
		this.m.Description = "我想要更多！这个角色很贪婪，会比其他有着相同背景的人要求更高的日薪，如果你的克朗用完了，他会很快离开你。";
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
