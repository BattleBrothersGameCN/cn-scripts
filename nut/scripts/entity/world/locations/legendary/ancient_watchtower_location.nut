this.ancient_watchtower_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "一座高耸入云的尖塔。从顶上看出去的景色一定很壮观。";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.ancient_watchtower";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = false;
		this.m.VisibilityMult = 1.100000;
		this.m.Resources = 0;
		this.m.OnEnter = "event.location.ancient_watchtower";
	}

	function onSpawned()
	{
		this.m.Name = "古代尖塔";
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
		body.setBrush("world_ancient_watchtower");
	}

});
