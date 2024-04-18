this.glorious_resolve_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.glorious";
		this.m.Name = "决心之誉";
		this.m.Icon = "ui/traits/trait_icon_72.png";
		this.m.Description = "这个角色在南方的竞技场上由各种敌人锻炼而成，有人类，也有野兽。要打破他的决心需要付出很多。 他奢华的生活方式需要高薪来维持，但他永远不会抛弃你，也不能被解雇。 如果三个初始成员都死了，你的战役就结束了。";
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
