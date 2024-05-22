this.houndmaster_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.houndmaster";
		this.m.Name = "驯犬师";
		this.m.Icon = "ui/backgrounds/background_50.png";
		this.m.BackgroundDescription = "驯犬师习惯于驯养战犬。";
		this.m.GoodEnding = "虽然%name%的头衔是“驯犬师”，但对他来说，狗不仅仅是训练的对象，它们是他生命中最忠实的朋友。在离开了战团后，他发现了一种根据贵族需求繁殖动物的巧妙方法。野性十足看家护院？行。小巧可爱儿童宠物？没问题。这位前佣兵靠着他热爱的事业 —— 驯犬，获得了惊人的收入。";
		this.m.BadEnding = "对某些人而言，狗就是狗，但对%name%来说，狗是忠诚的伙伴。在离开战团后，这位驯犬师去为贵族工作。不幸的是，由于他拒绝为短暂的战术优势，把几百只狗投入先锋部队送死，他以“心怀不忠”的罪名被绞死。";
		this.m.HiringCost = 80;
		this.m.DailyCost = 7;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_beasts",
			"trait.hate_beasts",
			"trait.hate_undead",
			"trait.bleeder",
			"trait.bright",
			"trait.asthmatic",
			"trait.fainthearted",
			"trait.tiny"
		];
		this.m.Titles = [
			"驯犬师",
			"养犬师(the Kennelmaster)",
			"看狗人(the Dogkeeper)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsLowborn = true;
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 14,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "这个角色释放的战犬将以自信士气加入战斗。"
			}
		];
	}

	function onBuildDescription()
	{
		return "{%name%对犬类的喜爱始于他父亲从射箭比赛中赢来的小狗。 | 自从%name%从熊爪下获救， 他就与犬类结下了不解之缘。 | 目睹劫犯被狗逼退，%name%对犬类的喜爱只增不减。 | 年轻的打鸟汉%name%很快就体会到了犬类的积极、忠实和精湛技艺。 | 被狗咬过的%name%通过学习训狗克服了对犬类的恐惧。} {多年来，这位驯犬师一直为当地领主工作，直到他的主子为取乐杀死了一条狗。 | 这位驯犬师训狗很快，把狗带去各地展销赚钱。 | 他在斗犬巡回赛中赚了很多钱，而他的狗也以听话又凶猛打出了名气。 | 受治安官雇佣，他和他嗅觉敏锐的狗抓捕了大量犯罪分子。 | 为当地领主所用，驯犬师的狗在战场上派上了用场。 | 多年来，这位驯犬师用他的狗帮助许多孤儿和残疾人重振了精神。} {不过现在，%name%想要换份工作。 | 鉴于有关佣兵收入的传闻，%name%决定试着当一名佣兵。 | 见有佣兵来找他买狗，%name%对当佣兵提起了兴趣。 | 厌倦了让狗去这样那样，%name%想要训练自己，呃，这样那样。 | 试想一下，%name% 会不会和他驯过的狗一样忠诚。}";
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
				5
			],
			Stamina = [
				5,
				0
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
				3,
				3
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				5,
				0
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;

		if (this.Math.rand(1, 100) >= 50)
		{
			items.equip(this.new("scripts/items/tools/throwing_net"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/open_leather_cap"));
		}
	}

});
