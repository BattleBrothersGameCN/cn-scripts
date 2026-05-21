this.vulcano_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "曾经的繁华城市，早已化作灰烬覆盖的废墟。这座有过诸多称谓的旧日都会，已成为南北双方文化与宗教尊严的象征。";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.holy_site.vulcano";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = true;
		this.m.IsAttackable = false;
		this.m.IsDestructible = false;
		this.m.VisibilityMult = 0.8;
		this.m.Resources = 0;
		this.m.OnEnter = "event.location.vulcano_enter";
	}

	function onSpawned()
	{
		this.m.Name = "远古城市";
		this.location.onSpawned();
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_holy_site_03");
		local banner = this.addSprite("banner");
		banner.setOffset(this.createVec(-20, 60));
	}

});
