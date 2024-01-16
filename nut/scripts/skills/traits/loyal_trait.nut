this.loyal_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.loyal";
		this.m.Name = "忠诚";
		this.m.Icon = "ui/traits/trait_icon_39.png";
		this.m.Description = "与你同在！这个角色忠诚到底，即使你耗尽了克朗和粮食，也不太可能离开你。";
		this.m.Titles = [
			"忠诚者(the Loyal)",
			"追随者(The Follower)",
			"狗(the Dog)"
		];
		this.m.Excluded = [
			"trait.disloyal",
			"trait.craven",
			"trait.fainthearted",
			"trait.dastard"
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

});
