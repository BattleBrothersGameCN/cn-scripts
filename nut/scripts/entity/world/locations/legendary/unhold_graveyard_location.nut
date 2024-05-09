this.unhold_graveyard_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "广阔的土地上散落着巨大的骨头和头骨。有些已成苍白色，但有些是新鲜的，仍然有肉附着。";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.unhold_graveyard";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = false;
		this.m.VisibilityMult = 0.9;
		this.m.Resources = 500;
		this.m.OnEnter = "event.location.unhold_graveyard";
	}

	function onSpawned()
	{
		this.m.Name = "巨魔墓地";
		this.location.onSpawned();
	}

	function onDiscovered()
	{
		this.location.onDiscovered();
		this.World.Flags.increment("LegendaryLocationsDiscovered", 1);

		if (this.World.Flags.get("LegendaryLocationsDiscovered") >= 10)
		{
			this.updateAchievement("FamedExplorer", 1, 1);
		}
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_unhold_graveyard");
	}

});
