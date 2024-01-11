this.fear_greenskins_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.fear_greenskins";
		this.m.Name = "惧怕绿皮";
		this.m.Icon = "ui/traits/trait_icon_49.png";
		this.m.Description = "要么是过去的经历，要么是逼真的故事。这个角色以往的生活让他觉得绿皮锐不可当，在战场面对它们时会不太靠谱。";
		this.m.Excluded = [
			"trait.fearless",
			"trait.brave",
			"trait.determined",
			"trait.cocky",
			"trait.bloodthirsty",
			"trait.hate_greenskins"
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
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] 决心，与绿皮战斗时"
			}
		];
	}

	function onUpdate( _properties )
	{
		if (!this.getContainer().getActor().isPlacedOnMap())
		{
			return;
		}

		local fightingGreenskins = false;
		local enemies = this.Tactical.Entities.getAllHostilesAsArray();

		foreach( enemy in enemies )
		{
			if (this.Const.EntityType.getDefaultFaction(enemy.getType()) == this.Const.FactionType.Orcs || this.Const.EntityType.getDefaultFaction(enemy.getType()) == this.Const.FactionType.Goblins)
			{
				fightingGreenskins = true;
				break;
			}
		}

		if (fightingGreenskins)
		{
			_properties.Bravery -= 10;
		}
	}

});
