this.kraken_cult_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "带有奇怪标记的石圈和石柱暗示着该地区有一些怪异的东西正在出没。";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.kraken_cult";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsShowingDefenders = true;
		this.m.IsShowingBanner = false;
		this.m.VisibilityMult = 0.900000;
		this.m.Resources = 500;
		this.m.OnEnter = "event.location.kraken_cult_enter";
		this.m.OnDestroyed = "event.location.kraken_cult_destroyed";
	}

	function onEnter()
	{
		this.m.IsVisited = false;
		this.location.onEnter();
	}

	function onSpawned()
	{
		this.m.Name = "石柱群";
		this.location.onSpawned();
		this.Const.World.Common.addTroop(this, {
			Type = this.Const.World.Spawn.Troops.Kraken
		}, false);
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
		body.setBrush("world_kraken_stones");
	}

});
