this.dumb_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.dumb";
		this.m.Name = "愚笨";
		this.m.Icon = "ui/traits/trait_icon_17.png";
		this.m.Description = "呃，啥？这个角色不太聪明，总要花些时间才能理解新概念。";
		this.m.Titles = [
			"蠢货",
			"白痴",
			"怪人"
		];
		this.m.Excluded = [
			"trait.bright",
			"trait.aspiring",
			"trait.sophisticated",
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
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15%[/color] 经验获取"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.XPGainMult *= 0.85;
	}

});
