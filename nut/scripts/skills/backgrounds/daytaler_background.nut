this.daytaler_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.daytaler";
		this.m.Name = "日结工";
		this.m.Icon = "ui/backgrounds/background_36.png";
		this.m.BackgroundDescription = "日结工习惯于参加各类体力劳动，但也都算不上精通。";
		this.m.GoodEnding = "日结工%name%退出了战斗生涯，继续用自己的双手工作。离开了杀野兽和砸脑壳，回归到铺砖头和搬干草的岗位上。他用所有的雇佣兵酬金购买了一小块土地定居下来。虽然不是最富有的，但他说得上是这行里最幸福人的了。";
		this.m.BadEnding = "趁着手脚都还完整，%name%退役了。他回去为贵族工作。你上次听说，他去了{南方 | 北方 | 东方 | 西方}，在为贵族修建一座巨塔。不幸的是，你还听说这座塔楼在施工过程中倒塌，许多工人一同遇难。";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.fear_undead",
			"trait.hate_beasts",
			"trait.hate_undead",
			"trait.hate_greenskins"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsLowborn = true;
	}

	function onBuildDescription()
	{
		return "{这儿干点那儿干点儿 | 没有稳定的工作 | 断断续续工作 | 做做这做做那 | 没有学过手艺}，%name%以日结工的身份为人所知，每当需要帮手时，大家都会想起他。{有一段时间没活干了， | 已经几周没什么活了， | %name%想做些以前没有做过的事情，  | 尽管没有战斗经验，脑袋里的酒精让他相信 | %name%估计最近不会缺干仗的活， | %name%的爱人因病逝去，就像最近发生在许多人身上的那样，他崩溃了。几个星期以来，他借酒消愁喝得烂醉如泥，}一个四处旅行的佣兵团似乎是个{可以跟着混一段时间 | 赚些钱 | 去看看这个世界 | 清醒一下头脑 | 能把钱袋子装满，顺便把他捎到下个村庄}的好机会。";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				0,
				0
			],
			Stamina = [
				0,
				3
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
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else
		{
			local item = this.new("scripts/items/armor/linen_tunic");
			item.setVariant(this.Math.rand(6, 7));
			items.equip(item);
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/headscarf"));
		}
	}

});
