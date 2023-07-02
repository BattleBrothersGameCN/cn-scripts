this.glorious_resolve_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.glorious";
		this.m.Name = "荣耀决心";
		this.m.Icon = "ui/traits/trait_icon_72.png";
		this.m.Description = "在南方竞技场锻造的这个角色，曾与人与野兽战斗过，要打破他的决心需要付出很多。 他美妙的生活方式要求很高的薪水，但他永远不会抛弃你，也不能被解雇。 如果三个初始成员都死了，你的战役就结束了。";
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
