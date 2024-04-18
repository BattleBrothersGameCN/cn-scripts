this.oath_of_camaraderie_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.oath_of_camaraderie";
		this.m.Name = "友谊誓言";
		this.m.Icon = "ui/traits/trait_icon_85.png";
		this.m.Description = "该角色立下了友谊誓言，发誓与他的战友同生共死。然而更多参战人员导致的混乱，以及对个人技能和个人荣耀的关注的缺乏，都让这个角色在战斗开始时的决心受到了影响。";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
		this.m.Excluded = [];
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
				icon = "ui/icons/morale.png",
				text = "将以动摇或瓦解士气开始战斗。"
			}
		];
	}

	function onUpdate( _properties )
	{
		if (this.getContainer().getActor().isPlacedOnMap() && this.Time.getRound() < 1)
		{
			if (this.Math.rand(1, 100) <= 50)
			{
				this.getContainer().getActor().setMoraleState(this.Const.MoraleState.Wavering);
			}
			else
			{
				this.getContainer().getActor().setMoraleState(this.Const.MoraleState.Breaking);
			}
		}
	}

});
