this.large_tundra_village <- this.inherit("scripts/entity/world/settlement", {
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.Name = this.getRandomName([
			"火种城",
			"北地领主城",
			"庇雪城",
			"巢城",
			"狂澜城",
			"平岩城",
			"角鸣城",
			"丘城",
			"如夏城",
			"踏雪城",
			"岩城",
			"硬地城",
			"草芜城",
			"火炉城",
			"峡城",
			"霜城",
			"诸神城",
			"战士城",
			"锤头城",
			"勇士城",
			"颅骨城",
			"先王城",
			"安居城",
			"平和城",
			"后裔城",
			"力量城"
		]);
		this.m.DraftList = [
			"apprentice_background",
			"beggar_background",
			"brawler_background",
			"brawler_background",
			"caravan_hand_background",
			"cultist_background",
			"cultist_background",
			"daytaler_background",
			"daytaler_background",
			"gravedigger_background",
			"graverobber_background",
			"hunter_background",
			"killer_on_the_run_background",
			"messenger_background",
			"militia_background",
			"militia_background",
			"militia_background",
			"minstrel_background",
			"monk_background",
			"peddler_background",
			"poacher_background",
			"ratcatcher_background",
			"shepherd_background",
			"tailor_background",
			"thief_background",
			"vagabond_background",
			"wildman_background",
			"wildman_background",
			"bastard_background",
			"disowned_noble_background",
			"raider_background",
			"sellsword_background",
			"swordmaster_background",
			"anatomist_background"
		];
		this.m.UIDescription = "一个被贫瘠苔原包围的大城市和贸易中心";
		this.m.Description = "这座被贫瘠的苔原包围的大城市一直是一个重要的贸易中心，也是思想家和艺术的家园。";
		this.m.UIBackgroundCenter = "ui/settlements/townhall_03";
		this.m.UIBackgroundLeft = "ui/settlements/bg_houses_03_left";
		this.m.UIBackgroundRight = "ui/settlements/bg_houses_03_right";
		this.m.UIRampPathway = "ui/settlements/ramp_01_cobblestone";
		this.m.UISprite = "ui/settlement_sprites/townhall_03.png";
		this.m.Sprite = "world_townhall_03";
		this.m.Lighting = "world_townhall_03_light";
		this.m.Rumors = this.Const.Strings.RumorsTundraSettlement;
		this.m.Culture = this.Const.World.Culture.Northern;
		this.m.IsMilitary = false;
		this.m.Size = 3;
		this.m.HousesType = 3;
		this.m.HousesMin = 3;
		this.m.HousesMax = 5;
		this.m.AttachedLocationsMax = 6;
	}

	function onBuild()
	{
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/crowd_building"), 5);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/marketplace_building"), 2);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/temple_building"));
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/tavern_building"));

		if (this.Const.DLC.Unhold && this.Const.World.Buildings.Taxidermists == 0)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/taxidermist_building"));
		}
		else if (this.Math.rand(1, 100) <= 75)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/barber_building"));
		}
		else
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/training_hall_building"));
		}

		if (this.Math.rand(1, 100) <= 50)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/armorsmith_building"));
		}
		else
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/weaponsmith_building"));
		}

		if (this.Math.rand(1, 100) <= 70)
		{
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/trapper_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra,
				this.Const.World.TerrainType.Snow
			], [
				this.Const.World.TerrainType.Tundra
			], 2);
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/peat_pit_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Tundra
			], [], 1);
		}
		else
		{
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/trapper_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra,
				this.Const.World.TerrainType.Snow
			], [
				this.Const.World.TerrainType.Tundra
			], 2);
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/peat_pit_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Tundra
			], [], 1);
		}

		if (this.Math.rand(1, 100) <= 70)
		{
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/pig_farm_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], []);
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/gatherers_hut_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Swamp,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Forest,
				this.Const.World.TerrainType.AutumnForest,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.SnowyForest,
				this.Const.World.TerrainType.LeaveForest,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [], 1);
		}
		else
		{
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/pig_farm_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], []);
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/gatherers_hut_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Swamp,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Forest,
				this.Const.World.TerrainType.AutumnForest,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.SnowyForest,
				this.Const.World.TerrainType.LeaveForest,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [], 1, false, true);
		}

		if (this.Math.rand(1, 100) <= 40)
		{
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/wooden_watchtower_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [], 4, true);
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/militia_trainingcamp_location", [
				this.Const.World.TerrainType.Tundra
			], [], 1, true);
		}
		else
		{
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/wooden_watchtower_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [], 4, true);
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/militia_trainingcamp_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Tundra
			], [], 1, true);
		}

		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/blast_furnace_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], [
			this.Const.World.TerrainType.Tundra,
			this.Const.World.TerrainType.Hills
		], 1, true);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/ore_smelters_location", [
			this.Const.World.TerrainType.Tundra
		], [], 1, true);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/workshop_location", [
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Tundra
		], [], 1, true);
	}

});
