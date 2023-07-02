this.cultist_zealot_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.cultist_zealot";
		this.m.Name = "达库尔狂信者";
		this.m.Icon = "ui/traits/trait_icon_65.png";
		this.m.Description = "这个角色是一个达库尔的狂信追随者，以至于他开始接受身体上的痛苦，因为这让他更接近救赎。";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] 决心"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/morale.png",
				text = "友军死亡时不会触发士气检查"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/morale.png",
				text = "失去生命值时不会触发士气检查"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += 10;
		_properties.IsAffectedByDyingAllies = false;
		_properties.IsAffectedByLosingHitpoints = false;
	}

});
