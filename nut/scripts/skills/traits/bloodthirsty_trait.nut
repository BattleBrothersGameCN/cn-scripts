this.bloodthirsty_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.bloodthirsty";
		this.m.Name = "嗜血";
		this.m.Icon = "ui/traits/trait_icon_42.png";
		this.m.Description = "这个角色容易对敌人过度暴力和残忍。死了还不够，把他的头串起来！";
		this.m.Titles = [
			"屠夫",
			"疯子",
			"残酷者"
		];
		this.m.Excluded = [
			"trait.weasel",
			"trait.fainthearted",
			"trait.hesistant",
			"trait.craven",
			"trait.insecure",
			"trait.craven",
			"trait.paranoid",
			"trait.fear_beasts",
			"trait.fear_undead",
			"trait.fear_greenskins",
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
				text = "所有的击杀都是必死击杀(如果武器允许)。"
			}
		];
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		_properties.FatalityChanceMult = 1000.000000;
	}

});
