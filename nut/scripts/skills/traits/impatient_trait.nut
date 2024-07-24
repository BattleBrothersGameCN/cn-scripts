this.impatient_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.impatient";
		this.m.Name = "急躁";
		this.m.Icon = "ui/traits/trait_icon_46.png";
		this.m.Description = "我们赶紧走吧！怎么还拖拖拉拉的？这个人物希望现在就开始做事。";
		this.m.Titles = [
			"快人一步",
			"渴望者",
			"急性子"
		];
		this.m.Excluded = [
			"trait.hesitant",
			"trait.clubfooted",
			"trait.teamplayer"
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
				icon = "ui/icons/special.png",
				text = "在战斗的第一轮中总是先行动"
			}
		];
	}

	function onUpdate( _properties )
	{
		if (this.getContainer().getActor().isPlacedOnMap() && this.Time.getRound() <= 1)
		{
			_properties.InitiativeForTurnOrderAdditional += 1000;
		}
	}

});
