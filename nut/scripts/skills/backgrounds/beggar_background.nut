this.beggar_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.beggar";
		this.m.Name = "乞丐(Beggar)";
		this.m.Icon = "ui/backgrounds/background_18.png";
		this.m.BackgroundDescription = "乞丐并非是有决心的那种人，而且流落街头往往对他们的健康有害。";
		this.m.GoodEnding = "厌倦了所有的战斗后，%name%这个曾经的乞丐从%companyname%退休了。你知道这个人在佣兵战团时赚到过相当可观的收入，然而前几天你又看到他在乞讨。你问他是否把钱全浪费光了，他大笑了起来说他买了土地并且过得很好。然后他拿出他的小罐子，请求给他一枚克朗。你给了他俩。";
		this.m.BadEnding = "战斗生活充满艰辛，%name%这位曾经的乞丐在它变得致命之前选择了退役。不幸的是，他又回去当乞丐了。传言有位贵族清理了城中的无赖，且在当时是冬天的情况下将他们送往了北方。又冷又饿，%name%死在了路边，一只锡杯冻在他的手指上。";
		this.m.HiringCost = 30;
		this.m.DailyCost = 3;
		this.m.Excluded = [
			"trait.iron_jaw",
			"trait.tough",
			"trait.strong",
			"trait.cocky",
			"trait.fat",
			"trait.bright",
			"trait.fearless",
			"trait.brave",
			"trait.determined",
			"trait.deathwish",
			"trait.greedy",
			"trait.athletic"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Bravery
		];
		this.m.Titles = [
			"肮脏之人(the Dirty)",
			"穷鬼(the Poor)",
			"衣衫褴褛者(the Ragged)",
			"病人(the Sick)",
			"骗子(the Liar)",
			"懒鬼(the Idle)",
			"懒汉(the Sloth)",
			"无用之人(the Useless)",
			"乞丐(the Beggar)",
			"黄鼠狼",
			"臭鼬(the Skunk)",
			"懒汉(the Sluggard)",
			"无家可归者(the Homeless)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
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
			}
		];
	}

	function onBuildDescription()
	{
		return "{在一场大火中失去一切之后 | 在他赌博成瘾后 | 被诬陷了他不曾犯下的罪名，并不得不向治安官交出全部财产避免牢狱之灾 | 一个村庄被烧成平地后的难民 | 在与他的兄弟发生暴力冲突后被逐出家门 | 一个没有什么才能又没有野心的人 | 被关在领主地牢中数不尽的岁月后终于得到释放 | 在把他所有的财产交给一个承诺拯救他永恒的灵魂的不知名邪教后 | 一个非常聪明的人，直到一个强盗敲了他的头}，{%name%发现自己流落街头， | %name%被迫流落街头，}{不得不为面包乞讨 | 依靠别人的善意 | 时常挨打并开始听天由命 | 把仅有的一点钱都花在喝酒上 | 到处翻其他人的垃圾并躲治安官 | 一边躲避暴徒流氓，一边讨钱}。{尽管他似乎认真想成为一名雇佣兵，但但街头度日毫无疑问剥夺了%name%最好的年华。 | 这么多年过去，到今天他的健康已经受损。 | 像%name%这样的人只要在街上待上几天，更别说几年，即使是非常危险的佣兵工作，对他而言也是最棒的差事。 | 只有神知道%name%为了生存都经历了什么，但现在站在你面前的只是一个瘦弱的人 | 他一看到你就准备张开双臂拥抱，声称多年前就认识你并一同进行了许多冒险，尽管他这会儿还想不起你的名字。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-10,
				-10
			],
			Bravery = [
				-10,
				-5
			],
			Stamina = [
				-10,
				-10
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
				0
			]
		};
		return c;
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local dirt = actor.getSprite("dirt");
		dirt.Visible = true;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			local item = this.new("scripts/items/helmets/hood");
			item.setVariant(38);
			items.equip(item);
		}
	}

});
