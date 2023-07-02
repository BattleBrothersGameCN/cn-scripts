this.large_tundra_fort <- this.inherit("scripts/entity/world/settlement", {
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.Name = this.getRandomName([
			"桐德堡",
			"洪堡",
			"格林博格",
			"赫勒堡",
			"卡尔克堡",
			"吕德斯堡",
			"洪斯堡",
			"松马斯堡",
			"布拉明堡",
			"瓦尔德堡",
			"诺尔堡",
			"伯克堡",
			"雷神堡",
			"唐堡",
			"海尔维克堡垒",
			"托尔瓦堡",
			"斯科尔博格",
			"艾兹维克堡",
			"哈尔斯堡",
			"格尔堡",
			"冈伯格",
			"阿森堡",
			"哈马堡",
			"斯卡加堡",
			"塞拉斯堡",
			"海尔伯格",
			"坎帕堡",
			"古法斯堡",
			"胡斯纳堡",
			"瑞斯塔堡",
			"盖尔博格"
		]);
		this.m.DraftList = [
			"apprentice_background",
			"beggar_background",
			"bowyer_background",
			"brawler_background",
			"brawler_background",
			"brawler_background",
			"gambler_background",
			"cultist_background",
			"daytaler_background",
			"farmhand_background",
			"gravedigger_background",
			"graverobber_background",
			"messenger_background",
			"militia_background",
			"militia_background",
			"militia_background",
			"peddler_background",
			"ratcatcher_background",
			"refugee_background",
			"shepherd_background",
			"shepherd_background",
			"vagabond_background",
			"wildman_background",
			"wildman_background",
			"wildman_background",
			"witchhunter_background",
			"bastard_background",
			"bastard_background",
			"deserter_background",
			"deserter_background",
			"disowned_noble_background",
			"raider_background",
			"retired_soldier_background",
			"sellsword_background",
			"sellsword_background",
			"squire_background",
			"swordmaster_background",
			"cripple_background",
			"eunuch_background",
			"hedge_knight_background",
			"hedge_knight_background",
			"paladin_background"
		];
		this.m.UIDescription = "高高耸立在周围苔原上的大城堡";
		this.m.Description = "一个高耸于周围冻原的大堡垒，巩固了大片开阔地区的安全。许多人来到这里补给、修理并休息，以便再次出发。";
		this.m.UIBackgroundCenter = "ui/settlements/stronghold_03";
		this.m.UIBackgroundLeft = "ui/settlements/bg_houses_03_left";
		this.m.UIBackgroundRight = "ui/settlements/bg_houses_03_right";
		this.m.UIRampPathway = "ui/settlements/ramp_01_cobblestone";
		this.m.UISprite = "ui/settlement_sprites/stronghold_03.png";
		this.m.Sprite = "world_stronghold_03";
		this.m.Lighting = "world_stronghold_03_light";
		this.m.Rumors = this.Const.Strings.RumorsTundraSettlement;
		this.m.Culture = this.Const.World.Culture.Northern;
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
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/armorsmith_building"));
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/weaponsmith_building"));
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/training_hall_building"));

		if (this.Math.rand(1, 100) <= 50)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/tavern_building"));
		}
		else
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/temple_building"));
		}

		if (this.Math.rand(1, 100) <= 30)
		{
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/stone_watchtower_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [], 4, true);
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/fortified_outpost_location", [
				this.Const.World.TerrainType.Tundra,
				this.Const.World.TerrainType.Hills
			], [], 2, true);
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
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/fortified_outpost_location", [
				this.Const.World.TerrainType.Tundra,
				this.Const.World.TerrainType.Hills
			], [], 2, true);
		}

		if (this.Math.rand(1, 100) <= 70)
		{
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/pig_farm_location", [
				this.Const.World.TerrainType.Tundra,
				this.Const.World.TerrainType.Hills
			], [], 1);
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/brewery_location", [
				this.Const.World.TerrainType.Tundra,
				this.Const.World.TerrainType.Hills
			], [], 1);
		}
		else
		{
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/pig_farm_location", [
				this.Const.World.TerrainType.Tundra,
				this.Const.World.TerrainType.Hills
			], [], 1);
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/brewery_location", [
				this.Const.World.TerrainType.Tundra,
				this.Const.World.TerrainType.Hills
			], [], 1);
		}

		this.buildAttachedLocation(1, "scripts/entity/world/attached_location/ore_smelters_location", [
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], [
			this.Const.World.TerrainType.Hills
		]);
		this.buildAttachedLocation(1, "scripts/entity/world/attached_location/blast_furnace_location", [
			this.Const.World.TerrainType.Tundra,
			this.Const.World.TerrainType.Hills
		], [
			this.Const.World.TerrainType.Tundra
		]);
		this.buildAttachedLocation(this.Math.rand(1, 1), "scripts/entity/world/attached_location/workshop_location", [
			this.Const.World.TerrainType.Tundra,
			this.Const.World.TerrainType.Hills
		], []);
	}

});
