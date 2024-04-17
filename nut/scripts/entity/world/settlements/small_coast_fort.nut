this.small_coast_fort <- this.inherit("scripts/entity/world/settlement", {
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.Name = this.getRandomName([
			"望海塔",
			"沙地岗",
			"海垒",
			"船骨垒",
			"滨海垒",
			"水獭岗",
			"营垒岗",
			"树桩垣",
			"海砦",
			"维京垒",
			"沙地塔",
			"海妖岗",
			"滨海卫",
			"海卫",
			"沧海卫",
			"表土卫",
			"滨滩垒",
			"咸水岗",
			"风暴垒",
			"海岗",
			"远眺垒",
			"水兵堡",
			"白日垒",
			"过风岗",
			"白溪岗",
			"渔堡",
			"熏鱼垒",
			"潮垒",
			"落潮岗",
			"回潮堡",
			"航峡垒",
			"水坝堡"
		]);
		this.m.DraftList = [
			"fisherman_background",
			"fisherman_background",
			"houndmaster_background",
			"messenger_background",
			"militia_background",
			"militia_background",
			"ratcatcher_background",
			"witchhunter_background",
			"adventurous_noble_background",
			"bastard_background",
			"deserter_background",
			"raider_background",
			"raider_background",
			"retired_soldier_background"
		];
		this.m.UIDescription = "在附近的海岸线上高耸着一个木制城寨";
		this.m.Description = "在附近的海岸线上高耸着一个木制城寨.";
		this.m.UIBackgroundCenter = "ui/settlements/stronghold_01";
		this.m.UIBackgroundLeft = "ui/settlements/water_01";
		this.m.UIBackgroundRight = "ui/settlements/bg_houses_01_right";
		this.m.UIRampPathway = "ui/settlements/ramp_01_planks";
		this.m.UISprite = "ui/settlement_sprites/stronghold_01.png";
		this.m.Sprite = "world_stronghold_01";
		this.m.Lighting = "world_stronghold_01_light";
		this.m.Rumors = this.Const.Strings.RumorsFishingSettlement;
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.IsMilitary = true;
		this.m.Size = 1;
		this.m.HousesType = 1;
		this.m.HousesMin = 1;
		this.m.HousesMax = 2;
		this.m.AttachedLocationsMax = 3 + 1;
	}

	function onBuild()
	{
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/crowd_building"), 5);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/marketplace_building"), 2);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/port_building"), 3);

		if (this.Const.World.Buildings.Kennels == 0)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/kennel_building"));
		}
		else
		{
			local r = this.Math.rand(1, 3);

			if (r == 1)
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/armorsmith_building"));
			}
			else if (r == 2)
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/weaponsmith_building"));
			}
			else if (r == 3)
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/kennel_building"));
			}
		}

		this.buildAttachedLocation(1, "scripts/entity/world/attached_location/harbor_location", [
			this.Const.World.TerrainType.Shore
		], [
			this.Const.World.TerrainType.Ocean,
			this.Const.World.TerrainType.Shore
		], -1, false, false);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/leather_tanner_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], []);
		this.buildAttachedLocation(1, "scripts/entity/world/attached_location/fishing_huts_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Tundra
		], [
			this.Const.World.TerrainType.Shore
		]);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/wooden_watchtower_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], [], 4, true);
	}

});
