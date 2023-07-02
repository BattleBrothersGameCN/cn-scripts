this.oracle_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "一座曾经容纳着古代先知的神殿遗址。虽然现在已经破败不堪，但人们仍涌向这里，并对即将发生的事情抱有幻想。";
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
		this.m.VisibilityMult = 0.800000;
		this.m.Resources = 0;
		this.m.OnEnter = "event.location.oracle_enter";
	}

	function onSpawned()
	{
		this.m.Name = "神谕之地";
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
