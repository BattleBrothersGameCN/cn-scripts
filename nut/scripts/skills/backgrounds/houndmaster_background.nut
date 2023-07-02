this.houndmaster_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.houndmaster";
		this.m.Name = "训犬师";
		this.m.Icon = "ui/backgrounds/background_50.png";
		this.m.BackgroundDescription = "驯犬师习惯于驯养战犬。";
		this.m.GoodEnding = "虽然%name%的头衔是“训犬师”，但狗对于他来说不仅仅是他的“猎犬”，它们是他生命中最忠诚的朋友。在离开了战团后，他发现了一种巧妙的方法，可以专门根据贵族的需求繁殖动物。想要一只野性十足的守卫犬？他可以做到。想要为孩子们准备一只小巧可爱的狗狗？他也可以做到。这位前佣兵现在靠着他热爱的事业 —— 训犬，获得了惊人的收入。";
		this.m.BadEnding = "对于某些人而言仅仅是战犬的东西对%name%来说是一只忠诚的野兽。在离开战团后，这位训犬师去为贵族工作。不幸的是，他拒绝让他的几百只狗被用作战斗先锋，为了短暂的战术优势而被牺牲。他因为他的“不忠理念”而被绞死。";
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
			"训犬师(the Houndmaster)",
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
				text = "这个角色释放的战犬将以自信的士气开始。"
			}
		];
	}

	function onBuildDescription()
	{
		return "{%name%对狗的喜爱始于他父亲在一次射击比赛中赢得一只小狗。 | 当一只狗把他从熊手中救出来时，%name%将他的一生献给了犬类。 | 看到一只狗逼退了一个抢劫犯，%name%对杂种狗的喜爱只增不减。 | 作为一个年轻的打鸟汉，%name%很快就体会出了狗的荣誉、忠诚和技艺。 | %name%曾经被野狗咬伤，为了克服对狗的恐惧，他学会了训练它们。}{这位训犬师为当地一位领主工作了多年。但当领主仅仅为了娱乐而杀死一只狗后，他放弃了那个职位。 | 这位训犬师训练杂种狗的速度很快，他把他的狗带到有利可图的旅行商展中去。 | 这人在斗狗巡回赛上赚了很多钱，他的杂种狗以容易控制 —— 以及释放的凶猛而闻名。 | 受执法人员雇用的训犬师利用他嗅觉敏锐的狗狩猎了许多犯罪分子。 | 被当地一位领主雇佣，许多训犬师的狗都走上了战场。 | 多年来，这位训犬师用他的狗来帮助孤儿和残疾人重振精神。}{不过，现在，%name%想换一份工作。 | 当%name%听说了雇佣兵的报酬时，他决定试着当一名佣兵。 | 在被一个雇佣兵推销一只狗后，%name%对自己成为佣兵的前景更感兴趣了。 | 厌倦了为了这样或那样的目的训狗，%name%试图训练自己以……好吧，达成这样或那样的目的。 | 一个有趣的前景，你只能希望%name%像他曾经指挥的那些狗一样忠诚。}";
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
