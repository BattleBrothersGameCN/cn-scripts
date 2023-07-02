this.small_farming_village <- this.inherit("scripts/entity/world/settlement", {
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.Name = this.getRandomName([
			"魏德菲尔德",
			"海梅尔恩",
			"萨克斯多夫",
			"科肯多夫",
			"奥尔腾霍夫",
			"韦德诺",
			"斯涅伦",
			"诺多夫",
			"弗赖多夫",
			"魏森豪斯",
			"姆伦海姆",
			"格伦费尔德",
			"因文道夫",
			"格拉芬海德",
			"赫尔曼霍夫",
			"科珀道夫",
			"梅丁",
			"瓦雷尔",
			"德巴赫",
			"德雷菲登",
			"博克霍恩",
			"胡夫斯拉格",
			"哈格",
			"瓦根海姆",
			"哈灵根",
			"维瑟",
			"维森多夫",
			"马尔克多夫",
			"赫维勒尔",
			"毕特费尔德",
			"诺伊恩里德",
			"奥恩巴赫",
			"阿德尔斯霍芬",
			"奥勒斯多夫",
			"布伦多夫",
			"奥克森豪森",
			"魏恩加滕",
			"孔尼希费尔德",
			"罗森霍夫",
			"韦登巴赫"
		]);
		this.m.DraftList = [
			"beggar_background",
			"daytaler_background",
			"daytaler_background",
			"farmhand_background",
			"farmhand_background",
			"farmhand_background",
			"farmhand_background",
			"miller_background",
			"miller_background",
			"ratcatcher_background",
			"tailor_background",
			"vagabond_background",
			"poacher_background"
		];
		this.m.UIDescription = "主要生活在周围肥沃土地上的小农庄";
		this.m.Description = "主要生活在周围肥沃土地上的小农庄.";
		this.m.UIBackgroundCenter = "ui/settlements/townhall_01";
		this.m.UIBackgroundLeft = "ui/settlements/bg_houses_01_left";
		this.m.UIBackgroundRight = "ui/settlements/bg_houses_01_right";
		this.m.UIRampPathway = "ui/settlements/ramp_01_planks";
		this.m.UISprite = "ui/settlement_sprites/townhall_01.png";
		this.m.Sprite = "world_townhall_01";
		this.m.Lighting = "world_townhall_01_light";
		this.m.Rumors = this.Const.Strings.RumorsFarmingSettlement;
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.IsMilitary = false;
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

		if (this.Math.rand(1, 100) <= 25)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/temple_building"));
		}
		else if (this.Math.rand(1, 100) <= 25)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/tavern_building"));
		}

		this.buildAttachedLocation(this.Math.rand(1, 2), "scripts/entity/world/attached_location/wheat_fields_location", [
			this.Const.World.TerrainType.Plains
		], [], 2);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/orchard_location", [
			this.Const.World.TerrainType.Plains
		], [], 1);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/wool_spinner_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Tundra
		], [
			this.Const.World.TerrainType.Plains
		]);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/herbalists_grove_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Swamp,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Forest,
			this.Const.World.TerrainType.AutumnForest,
			this.Const.World.TerrainType.LeaveForest,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], [], 2, true);
	}

});
