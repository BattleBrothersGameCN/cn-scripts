this.small_tundra_village <- this.inherit("scripts/entity/world/settlement", {
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.Name = this.getRandomName([
			"通德尔",
			"吕德尔斯霍尔姆",
			"克拉夫伦德",
			"波拉",
			"拉韦斯塔德",
			"奥斯利夫",
			"赫勒瓦德",
			"海姆斯塔德",
			"荷恩海姆",
			"杰斯塔尔",
			"海萨格",
			"卡尔克",
			"索默斯塔德",
			"霍恩",
			"布拉明",
			"瓦尔德",
			"诺尔",
			"维斯塔特",
			"奥尔宾",
			"格林斯塔德",
			"比尔克兰",
			"雷神镇",
			"唐瓦尔",
			"海尔维克",
			"欧格纳",
			"诺海姆",
			"温德海姆",
			"托尔瓦斯塔德",
			"斯科尔德",
			"艾兹维克",
			"哈尔海姆",
			"格海姆",
			"阿森斯塔德",
			"冈海姆",
			"哈玛",
			"布拉斯比",
			"隆内丘",
			"凯尔西姆"
		]);
		this.m.DraftList = [
			"brawler_background",
			"daytaler_background",
			"daytaler_background",
			"farmhand_background",
			"miner_background",
			"peddler_background",
			"poacher_background",
			"shepherd_background",
			"tailor_background",
			"vagabond_background",
			"wildman_background",
			"wildman_background"
		];
		this.m.UIDescription = "一座在稀疏苔原上生存下来的不起眼村庄";
		this.m.Description = "一座在稀疏苔原上生存下来的不起眼村庄。";
		this.m.UIBackgroundCenter = "ui/settlements/townhall_01";
		this.m.UIBackgroundLeft = "ui/settlements/bg_houses_01_left";
		this.m.UIBackgroundRight = "ui/settlements/bg_houses_01_right";
		this.m.UIRampPathway = "ui/settlements/ramp_01_planks";
		this.m.UISprite = "ui/settlement_sprites/townhall_01.png";
		this.m.Sprite = "world_townhall_01";
		this.m.Lighting = "world_townhall_01_light";
		this.m.Rumors = this.Const.Strings.RumorsTundraSettlement;
		this.m.Culture = this.Const.World.Culture.Northern;
		this.m.IsMilitary = false;
		this.m.Size = 1;
		this.m.HousesType = 1;
		this.m.HousesMin = 1;
		this.m.HousesMax = 2;
		this.m.AttachedLocationsMax = 3;
		this.m.ProduceString = "皮毛";
	}

	function onBuild()
	{
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/crowd_building"), 5);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/marketplace_building"), 2);

		if (this.Math.rand(1, 100) <= 40)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/weaponsmith_building"));
		}
		else if (this.Const.DLC.Unhold && (this.Const.World.Buildings.Taxidermists == 0 || this.Math.rand(1, 100)))
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/taxidermist_building"));
		}
		else if (this.Math.rand(1, 100) <= 20)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/temple_building"));
		}

		if (this.Math.rand(1, 100) <= 50)
		{
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/pig_farm_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], []);
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/trapper_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra,
				this.Const.World.TerrainType.Snow
			], [
				this.Const.World.TerrainType.Tundra
			]);
		}
		else
		{
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/pig_farm_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], []);
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/trapper_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra,
				this.Const.World.TerrainType.Snow
			], [
				this.Const.World.TerrainType.Tundra
			]);
		}

		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/surface_iron_vein_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], [
			this.Const.World.TerrainType.Tundra,
			this.Const.World.TerrainType.Hills
		]);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/herbalists_grove_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Swamp,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Forest,
			this.Const.World.TerrainType.AutumnForest,
			this.Const.World.TerrainType.SnowyForest,
			this.Const.World.TerrainType.LeaveForest,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], [], 2);
	}

});
