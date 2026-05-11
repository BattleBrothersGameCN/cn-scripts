this.oracle_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "一座古老神庙的遗迹，在久远的过去曾有先知居住于此。如今虽已倾颓，人们仍蜂拥而至，企图在此窥探未来的景象。";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.holy_site.oracle";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = true;
		this.m.IsAttackable = false;
		this.m.IsDestructible = false;
		this.m.VisibilityMult = 0.8;
		this.m.Resources = 0;
		this.m.OnEnter = "event.location.oracle_enter";
	}

	function onSpawned()
	{
		this.m.Name = "神谕所";
		this.location.onSpawned();
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_holy_site_02");
		local banner = this.addSprite("banner");
		banner.setOffset(this.createVec(90, 80));
	}

});
