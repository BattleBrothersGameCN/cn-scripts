this.weasel_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.weasel";
		this.m.Name = "鼬鼠";
		this.m.Icon = "ui/traits/trait_icon_60.png";
		this.m.Description = "这个人物像黄鼠狼一样敏捷。可惜，只有逃命时他才能使出这种本领。";
		this.m.Titles = [
			"胆小鬼",
			"鼬鼠",
			"鸡仔",
			"鳗鱼"
		];
		this.m.Excluded = [
			"trait.clubfooted",
			"trait.clumsy",
			"trait.determined",
			"trait.bloodthirsty",
			"trait.deathwish",
			"trait.brave",
			"trait.fearless",
			"trait.cocky",
			"trait.optimist",
			"trait.hate_greenskins",
			"trait.hate_undead",
			"trait.hate_beasts"
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
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+25[/color] 撤退时的近战防御"
			}
		];
	}

	function onBeingAttacked( _attacker, _skill, _properties )
	{
		if (("State" in this.Tactical) && this.Tactical.State != null && this.Tactical.State.isScenarioMode())
		{
			return;
		}

		if (this.getContainer().getActor().isPlacedOnMap() && this.Tactical.State.isAutoRetreat() && this.Tactical.TurnSequenceBar.getActiveEntity() != null && this.Tactical.TurnSequenceBar.getActiveEntity().getID() == this.getContainer().getActor().getID())
		{
			_properties.MeleeDefense += 25;
		}
	}

});
