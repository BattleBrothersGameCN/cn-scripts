this.lucky_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.lucky";
		this.m.Name = "幸运";
		this.m.Icon = "ui/traits/trait_icon_54.png";
		this.m.Description = "这个角色天生有在最后一秒摆脱伤害的天赋。";
		this.m.Titles = [
			"幸运星(the Lucky)",
			"蒙福者(the Blessed)"
		];
		this.m.Excluded = [
			"trait.pessimist",
			"trait.clumsy",
			"trait.ailing",
			"trait.clubfooted"
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
				text = "有 [color=" + this.Const.UI.Color.PositiveValue + "]10%[/color] 几率使任何攻击者需要进行两次成功的攻击检定才能命中"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.RerollDefenseChance += 10;
	}

});
