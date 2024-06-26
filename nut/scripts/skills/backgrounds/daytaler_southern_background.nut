this.daytaler_southern_background <- this.inherit("scripts/skills/backgrounds/daytaler_background", {
	m = {},
	function create()
	{
		this.daytaler_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernSkinny;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.SouthernUntidy;
		this.m.Ethnicity = 1;
		this.m.BeardChance = 90;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.fear_undead",
			"trait.hate_beasts",
			"trait.hate_undead",
			"trait.hate_greenskins"
		];
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{这儿干点那儿干点儿 | 没有稳定的工作 | 断断续续工作 | 做做这做做那 | 没有学过手艺}，%name%以日结工的身份为人所知，每当需要帮手时，大家都会想起他。{有一段时间没活干了， | 已经几周没什么活了， | %name%想做些以前没有做过的事情，  | 尽管没有战斗经验，脑袋里的酒精让他相信 | %name%估计最近不会缺干仗的活， | %name%的爱人因病逝去，就像最近发生在许多人身上的那样，他崩溃了。几个星期以来，他借酒消愁喝得烂醉如泥，}一个四处旅行的佣兵团似乎是个{可以跟着混一段时间 | 赚些钱 | 去看看这个世界 | 清醒一下头脑 | 能把钱袋子装满，顺便把他捎到下个村庄}的好机会。";
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
			local item = this.new("scripts/items/armor/oriental/cloth_sash");
			items.equip(item);
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/oriental/southern_head_wrap"));
		}
	}

});
