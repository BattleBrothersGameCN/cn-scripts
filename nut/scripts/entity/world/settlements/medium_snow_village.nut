this.medium_snow_village <- this.inherit("scripts/entity/world/settlement", {
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.Name = this.getRandomName([
			"火种地",
			"庇雪漫",
			"衣食地",
			"波拉",
			"狂澜镇",
			"雪封地",
			"平岩渡",
			"海姆斯塔德",
			"角鸣乡",
			"杰斯塔尔",
			"海萨格",
			"石灰地",
			"如夏镇",
			"角鸣地",
			"踏雪地",
			"岩镇",
			"硬土地",
			"维斯塔特",
			"奥尔宾",
			"芜地镇",
			"桦木坪",
			"雷神镇",
			"唐瓦尔",
			"海尔维克",
			"欧格纳",
			"北地乡",
			"温德海姆",
			"泥潭镇",
			"斯科尔德",
			"艾兹维克",
			"哈尔海姆",
			"格海姆",
			"阿森斯塔德",
			"冈海姆",
			"锤头地"
		]);
		this.m.DraftList = [
			"apprentice_background",
			"brawler_background",
			"brawler_background",
			"cultist_background",
			"daytaler_background",
			"daytaler_background",
			"gravedigger_background",
			"gravedigger_background",
			"graverobber_background",
			"hunter_background",
			"killer_on_the_run_background",
			"lumberjack_background",
			"militia_background",
			"miner_background",
			"peddler_background",
			"poacher_background",
			"poacher_background",
			"poacher_background",
			"thief_background",
			"vagabond_background",
			"wildman_background",
			"wildman_background",
			"disowned_noble_background",
			"cripple_background"
		];
		this.m.UIDescription = "全年大部分时间被雪覆盖的中型村庄";
		this.m.Description = "全年大部分时间被雪覆盖的中型村庄.";
		this.m.UIBackgroundCenter = "ui/settlements/townhall_02_snow";
		this.m.UIBackgroundLeft = "ui/settlements/bg_houses_02_left_snow";
		this.m.UIBackgroundRight = "ui/settlements/bg_houses_02_right_snow";
		this.m.UIRampPathway = "ui/settlements/ramp_01_planks";
		this.m.UISprite = "ui/settlement_sprites/townhall_02.png";
		this.m.Sprite = "world_townhall_02";
		this.m.Lighting = "world_townhall_02_light";
		this.m.Rumors = this.Const.Strings.RumorsSnowSettlement;
		this.m.Culture = this.Const.World.Culture.Northern;
		this.m.IsMilitary = false;
		this.m.Size = 2;
		this.m.HousesType = 2;
		this.m.HousesMin = 2;
		this.m.HousesMax = 3;
		this.m.AttachedLocationsMax = 4;
	}

	function onBuild()
	{
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/crowd_building"), 5);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/marketplace_building"), 2);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/tavern_building"));
		local r = this.Math.rand(1, 3);

		if (r == 1)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/weaponsmith_building"));
		}
		else if (r == 2)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/armorsmith_building"));
		}
		else if (r == 3)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/barber_building"));
		}

		if (this.Math.rand(1, 100) <= 50)
		{
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/surface_iron_vein_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [
				this.Const.World.TerrainType.Tundra,
				this.Const.World.TerrainType.Hills
			], 1);
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/leather_tanner_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Tundra
			], [], 1);
		}
		else
		{
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/surface_iron_vein_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [
				this.Const.World.TerrainType.Tundra,
				this.Const.World.TerrainType.Hills
			], 1);
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/leather_tanner_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Tundra
			], [], 1);
		}

		this.buildAttachedLocation(this.Math.rand(1, 2), "scripts/entity/world/attached_location/trapper_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra,
			this.Const.World.TerrainType.Snow
		], [
			this.Const.World.TerrainType.Tundra
		]);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/surface_copper_vein_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], []);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/wooden_watchtower_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], [], 3, true);
	}

});
