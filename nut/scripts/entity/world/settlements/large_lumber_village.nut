this.large_lumber_village <- this.inherit("scripts/entity/world/settlement", {
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.Name = this.getRandomName([
			"材木边城",
			"暗林边城",
			"冷杉镇",
			"密林坪",
			"幽林镇",
			"林翳边城",
			"橡树镇",
			"鸮鹰边城",
			"雹降坪",
			"菘蓝镇",
			"车运镇",
			"马鹿边城",
			"小村城",
			"比林坪",
			"洼地边城",
			"林绿镇",
			"树海镇",
			"林绿坪",
			"密林边城",
			"幽林边城",
			"国王之森",
			"擢爵林地",
			"国王林地"
		]);
		this.m.DraftList = [
			"apprentice_background",
			"beggar_background",
			"bowyer_background",
			"bowyer_background",
			"bowyer_background",
			"brawler_background",
			"butcher_background",
			"cultist_background",
			"daytaler_background",
			"hunter_background",
			"hunter_background",
			"hunter_background",
			"killer_on_the_run_background",
			"lumberjack_background",
			"lumberjack_background",
			"lumberjack_background",
			"militia_background",
			"militia_background",
			"minstrel_background",
			"peddler_background",
			"poacher_background",
			"poacher_background",
			"poacher_background",
			"ratcatcher_background",
			"refugee_background",
			"servant_background",
			"tailor_background",
			"thief_background",
			"vagabond_background",
			"wildman_background",
			"wildman_background",
			"witchhunter_background",
			"bastard_background",
			"disowned_noble_background",
			"hedge_knight_background",
			"retired_soldier_background",
			"cripple_background",
			"eunuch_background",
			"anatomist_background"
		];

		if (this.Const.DLC.Unhold)
		{
			this.m.DraftList.push("beast_hunter_background");
			this.m.DraftList.push("beast_hunter_background");
		}

		this.m.UIDescription = "以珍贵的木材和鹿肉为主要产品的繁荣城市";
		this.m.Description = "一座繁荣的城市，靠近森林，其主要产品是有价值的木材和鹿肉。";
		this.m.UIBackgroundCenter = "ui/settlements/townhall_03";
		this.m.UIBackgroundLeft = "ui/settlements/bg_houses_03_left";
		this.m.UIBackgroundRight = "ui/settlements/bg_houses_03_right";
		this.m.UIRampPathway = "ui/settlements/ramp_01_cobblestone";
		this.m.UISprite = "ui/settlement_sprites/townhall_03.png";
		this.m.Sprite = "world_townhall_03";
		this.m.Lighting = "world_townhall_03_light";
		this.m.Rumors = this.Const.Strings.RumorsForestSettlement;
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.IsMilitary = false;
		this.m.Size = 3;
		this.m.HousesType = 3;
		this.m.HousesMin = 3;
		this.m.HousesMax = 5;
		this.m.AttachedLocationsMax = 6;
		this.m.ProduceString = "木材";
	}

	function onBuild()
	{
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/crowd_building"), 5);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/marketplace_building"), 2);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/temple_building"));
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/tavern_building"));
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/fletcher_building"));

		if (this.Const.DLC.Unhold)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/taxidermist_building"));
		}
		else if (this.Math.rand(1, 100) <= 50)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/armorsmith_building"));
		}
		else
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/training_hall_building"));
		}

		if (this.Math.rand(1, 100) <= 50)
		{
			this.buildAttachedLocation(this.Math.rand(1, 2), "scripts/entity/world/attached_location/hunters_cabin_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Forest,
				this.Const.World.TerrainType.SnowyForest,
				this.Const.World.TerrainType.AutumnForest,
				this.Const.World.TerrainType.LeaveForest,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [
				this.Const.World.TerrainType.Forest,
				this.Const.World.TerrainType.SnowyForest,
				this.Const.World.TerrainType.AutumnForest,
				this.Const.World.TerrainType.LeaveForest
			], 2, false, true);
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/lumber_camp_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Forest,
				this.Const.World.TerrainType.SnowyForest,
				this.Const.World.TerrainType.AutumnForest,
				this.Const.World.TerrainType.LeaveForest,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [
				this.Const.World.TerrainType.Forest,
				this.Const.World.TerrainType.SnowyForest,
				this.Const.World.TerrainType.AutumnForest,
				this.Const.World.TerrainType.LeaveForest
			], 1, false, true);
		}
		else
		{
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/hunters_cabin_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Forest,
				this.Const.World.TerrainType.SnowyForest,
				this.Const.World.TerrainType.AutumnForest,
				this.Const.World.TerrainType.LeaveForest,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [
				this.Const.World.TerrainType.Forest,
				this.Const.World.TerrainType.SnowyForest,
				this.Const.World.TerrainType.AutumnForest,
				this.Const.World.TerrainType.LeaveForest
			], 2, false, true);
			this.buildAttachedLocation(this.Math.rand(1, 2), "scripts/entity/world/attached_location/lumber_camp_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Forest,
				this.Const.World.TerrainType.SnowyForest,
				this.Const.World.TerrainType.AutumnForest,
				this.Const.World.TerrainType.LeaveForest,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [
				this.Const.World.TerrainType.Forest,
				this.Const.World.TerrainType.SnowyForest,
				this.Const.World.TerrainType.AutumnForest,
				this.Const.World.TerrainType.LeaveForest
			], 1, false, true);
		}

		if (this.Math.rand(1, 100) <= 50)
		{
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/wooden_watchtower_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [], 4, true);
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/militia_trainingcamp_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
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
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [], 1, true);
		}

		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/fletchers_hut_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Forest,
			this.Const.World.TerrainType.AutumnForest,
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.SnowyForest,
			this.Const.World.TerrainType.LeaveForest,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], [], 0, false, true);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/leather_tanner_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Hills
		], []);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/herbalists_grove_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Swamp,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Forest,
			this.Const.World.TerrainType.AutumnForest,
			this.Const.World.TerrainType.LeaveForest,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], [], 2);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/wheat_fields_location", [
			this.Const.World.TerrainType.Plains
		], [], 1);
	}

});
