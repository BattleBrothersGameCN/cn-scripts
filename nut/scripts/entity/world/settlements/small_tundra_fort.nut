this.small_tundra_fort <- this.inherit("scripts/entity/world/settlement", {
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.Name = this.getRandomName([
			"桐德沃德",
			"洪沃德",
			"格林托恩",
			"海尔维尔",
			"卡尔克韦尔",
			"利德斯沃德",
			"角之塔",
			"夏之芽",
			"布拉明沃德",
			"瓦尔德加德",
			"诺尔沃德",
			"碧克托恩",
			"唐纳斯沃尔德",
			"唐威尔",
			"海尔维克托恩",
			"托瓦斯托恩",
			"斯科尔德沃德",
			"艾德斯维克顿",
			"哈尔斯皮拉",
			"格沃尔德",
			"冈斯皮拉",
			"阿森托恩",
			"哈马沃尔德",
			"霍尔姆沃德",
			"艾达斯沃尔德",
			"斯卡勒沃尔德",
			"克诺雷斯皮拉",
			"林德斯托恩",
			"内德斯皮拉",
			"布雷达斯沃尔德"
		]);
		this.m.DraftList = [
			"apprentice_background",
			"houndmaster_background",
			"daytaler_background",
			"militia_background",
			"militia_background",
			"miner_background",
			"vagabond_background",
			"wildman_background",
			"bastard_background",
			"deserter_background",
			"deserter_background",
			"retired_soldier_background",
			"retired_soldier_background"
		];
		this.m.UIDescription = "苔原上高耸着的一个木制城寨";
		this.m.Description = "在冻土带的平地上，可以从很远的地方看到这个小小的防御工事。";
		this.m.UIBackgroundCenter = "ui/settlements/stronghold_01";
		this.m.UIBackgroundLeft = "ui/settlements/bg_houses_01_left";
		this.m.UIBackgroundRight = "ui/settlements/bg_houses_01_right";
		this.m.UIRampPathway = "ui/settlements/ramp_01_planks";
		this.m.UISprite = "ui/settlement_sprites/stronghold_01.png";
		this.m.Sprite = "world_stronghold_01";
		this.m.Lighting = "world_stronghold_01_light";
		this.m.Rumors = this.Const.Strings.RumorsTundraSettlement;
		this.m.Culture = this.Const.World.Culture.Northern;
		this.m.IsMilitary = true;
		this.m.Size = 1;
		this.m.HousesType = 1;
		this.m.HousesMin = 1;
		this.m.HousesMax = 2;
		this.m.AttachedLocationsMax = 3;
	}

	function onBuild()
	{
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/crowd_building"), 5);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/marketplace_building"), 2);

		if (!this.Const.World.Buildings.Kennels == 0)
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

		if (this.Math.rand(1, 100) <= 50)
		{
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/gatherers_hut_location", [
				this.Const.World.TerrainType.Tundra,
				this.Const.World.TerrainType.Hills
			], [], 1);
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/pig_farm_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], []);
		}
		else
		{
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/gatherers_hut_location", [
				this.Const.World.TerrainType.Tundra,
				this.Const.World.TerrainType.Hills
			], [], 1);
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/pig_farm_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], []);
		}

		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/surface_iron_vein_location", [
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], [
			this.Const.World.TerrainType.Hills
		]);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/leather_tanner_location", [
			this.Const.World.TerrainType.Tundra,
			this.Const.World.TerrainType.Hills
		], [
			this.Const.World.TerrainType.Tundra
		]);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/wooden_watchtower_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], 4, true);
	}

});
