this.fisherman_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.fisherman";
		this.m.Name = "渔夫";
		this.m.Icon = "ui/backgrounds/background_15.png";
		this.m.BackgroundDescription = "渔夫习惯于体力劳动。";
		this.m.GoodEnding = "%name%从战场上退役，回到了他的渔业事业中。一场巨大的风暴席卷海岸，摧毁了每一艘小艇和舢板 —— 除了这位狡猾渔夫的！坐拥唯一幸存的船只，%name%的渔业事业得以迅速繁荣。他每天早上醒来都能享受美丽的海滩景色，生活舒适惬意。";
		this.m.BadEnding = "战斗生涯屡遭不顺，%name%决定退出战场，回归捕鱼。一场巨大的风暴席卷了海岸线后，他失踪了。";
		this.m.HiringCost = 65;
		this.m.DailyCost = 7;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.paranoid",
			"trait.night_blind",
			"trait.tiny",
			"trait.fat"
		];
		this.m.Titles = [
			"渔民(the Fisherman)",
			"渔夫(the Fisher)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsLowborn = true;
	}

	function onBuildDescription()
	{
		return "{%name%喜欢大海和独自在水面上捕鱼的宁静 | 讽刺的是，%name%一直讨厌水，但他还是接了他父亲和他父亲的父亲的班，成为了一名渔夫 | %name%是个强壮能干的渔夫 | %name%对渔夫工作感到满意 | %name%总是能幸运地找到最好的渔场并捕捉到最肥美的鱼}。只要没有暴风雨，他就在外面捕鱼，日复一日。 {不幸的是，当他出海时，他的渔房被烧毁了。 | 但暴风雨突然降临，他失去了最好的朋友、船只也严重受损，没人和他一起出海了。 | 但是，灾难降临了，他的妻子死于难产，粉碎了他所珍视的一切。 | 然而，还不起债务，他的船被一个放高利贷的夺走了，真是无情。 | 在一气之下勒死妻子之后，他完全失去了对捕鱼的兴趣。 | 他垂头丧气，捕了整整一个夏天的鱼，大部分都已经从内部腐坏、死翘翘了。 | 一位诸神的牧师告诉%name%，诸神并不期望他作为渔夫生活下去，祂们希望他以祂们的名义流血，于是他将目光投向了另一个行业。}一天晚上，他来到酒馆，一个玩命赚钱的机会出现在他眼前。";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				5,
				0
			],
			Bravery = [
				5,
				0
			],
			Stamina = [
				5,
				5
			],
			MeleeSkill = [
				0,
				0
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				0,
				0
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				0,
				5
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}

		items.equip(this.new("scripts/items/tools/throwing_net"));
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 2)
		{
			local item = this.new("scripts/items/armor/linen_tunic");
			item.setVariant(this.Math.rand(6, 7));
			items.equip(item);
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/straw_hat"));
		}
	}

});
