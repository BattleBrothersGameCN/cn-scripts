this.ancient_temple_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "一座某种神庙或陵墓的入口，被深埋在地下，只露出一半。";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.ancient_temple";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = false;
		this.m.VisibilityMult = 0.900000;
		this.m.Resources = 0;
		this.m.OnEnter = "event.location.ancient_temple_enter";
	}

	function onSpawned()
	{
		this.m.Name = "远古神殿";
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
		body.setBrush("world_ancient_temple");
	}

});
