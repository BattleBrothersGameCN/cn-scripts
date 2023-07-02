this.daytaler_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.daytaler";
		this.m.Name = "日结工";
		this.m.Icon = "ui/backgrounds/background_36.png";
		this.m.BackgroundDescription = "日结工习惯于各种体力劳动，但是都也不算精通。";
		this.m.GoodEnding = "日结工%name%退出了战斗生涯，他继续用自己的双手工作。现在，他回到了铺砖和搬草的岗位上，而不是杀死野兽与打碎脑壳。他用所有的雇佣兵酬金购买了一小块土地并定居下来。他虽然不是最富有的人，但据说在这个领域里没有比他更幸福的人了。";
		this.m.BadEnding = "%name%在大部分手脚都完好无损时退役。他回去为贵族工作了。你最后听说他在{南部 | 北部 | 东部 | 西部}为某位贵族修建一座巨大的塔楼。不幸的是，你也听说这座塔楼在施工过程中倒塌了，许多工人一同遇难。";
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
		return "%name%{四处工作 | 没有稳定的工作 | 断断续续地工作 | 做做这做做那 | 没有学过手艺}，以日结工的身份为人所知，每当需要额外的帮手时，大家都会想起他。{已经有一段时间没啥活干了，于是 | 在过去的几周里几乎没什么工作要做，所以 | %name%想做些以前没有做过的事情，所以 | 尽管没有战斗经验，喝多了酒让他相信 | %name%认为干仗的活计在近期会不少，所以 | %name%的爱人因病逝去，就像最近发生在许多人身上的那样，他崩溃了。几个星期以来，他借酒消愁喝得烂醉如泥，}一个四处旅行的佣兵战团似乎是个{可以跟着混一段时间 | 赚些钱 | 去看看这个世界 | 让他清醒一下头脑 | 可以把他带到下一个村庄并且把钱袋子填满}的好机会。";
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
