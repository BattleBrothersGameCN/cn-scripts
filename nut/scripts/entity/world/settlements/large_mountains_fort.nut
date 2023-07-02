this.large_mountains_fort <- this.inherit("scripts/entity/world/settlement", {
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.Name = this.getRandomName([
			"霍恩费斯特",
			"沃尔芬费斯特",
			"沃尔芬斯坦",
			"菲尔斯菲斯特",
			"艾森菲斯特",
			"格罗尔费斯特",
			"格鲁本费斯特",
			"雷鸣要塞",
			"埃尔茨费斯特",
			"格罗嫩费斯特",
			"扎特尔费斯特",
			"卡姆菲斯特",
			"高塔要塞",
			"温德费斯特",
			"鹰堡",
			"布伦沃德",
			"英雄要塞",
			"乌姆费斯特",
			"剑堡",
			"兰岑费斯特",
			"福肯斯坦",
			"弗莱克滕斯坦",
			"天空要塞",
			"石塔",
			"山峰要塞",
			"楚格堡",
			"花岗岩堡垒",
			"锡南堡",
			"瓦克斯菲斯特",
			"远眺堡",
			"野丘要塞"
		]);
		this.m.DraftList = [
			"apprentice_background",
			"apprentice_background",
			"brawler_background",
			"caravan_hand_background",
			"caravan_hand_background",
			"gambler_background",
			"gravedigger_background",
			"graverobber_background",
			"juggler_background",
			"mason_background",
			"mason_background",
			"messenger_background",
			"militia_background",
			"militia_background",
			"militia_background",
			"miner_background",
			"miner_background",
			"miner_background",
			"ratcatcher_background",
			"vagabond_background",
			"witchhunter_background",
			"adventurous_noble_background",
			"bastard_background",
			"deserter_background",
			"deserter_background",
			"disowned_noble_background",
			"retired_soldier_background",
			"retired_soldier_background",
			"sellsword_background",
			"sellsword_background",
			"sellsword_background",
			"squire_background",
			"squire_background",
			"swordmaster_background",
			"cripple_background",
			"hedge_knight_background",
			"hedge_knight_background",
			"paladin_background"
		];
		this.m.UIDescription = "一座巨大的石头城堡建在陡峭的山中";
		this.m.Description = "这座巨大的石头城堡建在陡峭的山中。许多人驻扎在这里以牢牢控制这片土地。";
		this.m.UIBackgroundCenter = "ui/settlements/stronghold_03";
		this.m.UIBackgroundLeft = "ui/settlements/bg_houses_03_left";
		this.m.UIBackgroundRight = "ui/settlements/bg_houses_03_right";
		this.m.UIRampPathway = "ui/settlements/ramp_01_cobblestone";
		this.m.UISprite = "ui/settlement_sprites/stronghold_03.png";
		this.m.Sprite = "world_stronghold_03";
		this.m.Lighting = "world_stronghold_03_light";
		this.m.Rumors = this.Const.Strings.RumorsMiningSettlement;
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.IsMilitary = true;
		this.m.Size = 3;
		this.m.HousesType = 3;
		this.m.HousesMin = 3;
		this.m.HousesMax = 4;
		this.m.AttachedLocationsMax = 5;
	}

	function onBuild()
	{
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/crowd_building"), 5);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/marketplace_building"), 2);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/tavern_building"));
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/training_hall_building"));
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/armorsmith_building"));
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/weaponsmith_building"));

		if (this.Math.rand(1, 100) <= 60)
		{
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/stone_watchtower_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [], 4, true);
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/workshop_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Tundra,
				this.Const.World.TerrainType.Hills
			], [], 1, true);
		}
		else
		{
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/stone_watchtower_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [], 4, true);
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/workshop_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Tundra,
				this.Const.World.TerrainType.Hills
			], [], 1, true);
		}

		if (this.Math.rand(1, 100) <= 50)
		{
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/goat_herd_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [], 1);
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/wheat_fields_location", [
				this.Const.World.TerrainType.Plains
			], [], 1);
		}
		else
		{
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/goat_herd_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [], 1);
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/wheat_fields_location", [
				this.Const.World.TerrainType.Plains
			], [], 1);
		}

		this.buildAttachedLocation(1, "scripts/entity/world/attached_location/ore_smelters_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], [
			this.Const.World.TerrainType.Hills
		]);
		this.buildAttachedLocation(1, "scripts/entity/world/attached_location/blast_furnace_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], [
			this.Const.World.TerrainType.Hills
		]);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/workshop_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], []);
	}

});
