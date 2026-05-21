this.glorious_resolve_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.glorious";
		this.m.Name = "荣耀之心";
		this.m.Icon = "ui/traits/trait_icon_72.png";
		this.m.Description = "这个角色在南方的竞技场上经历过无数敌人的锤炼，有人类，也有野兽。这让他的意志坚不可摧。他奢靡的生活需要高薪来维持，但他永远不会抛弃你，也不能被解雇。如果三个初始成员都死了，你的战役就结束了。";
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
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "每个失败的士气检定都有第二次机会重新掷骰"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.RerollMoraleChance = 100;
	}

});
