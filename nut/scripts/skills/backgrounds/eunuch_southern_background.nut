this.eunuch_southern_background <- this.inherit("scripts/skills/backgrounds/eunuch_background", {
	m = {},
	function create()
	{
		this.eunuch_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernThick;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = null;
		this.m.Ethnicity = 1;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.weasel",
			"trait.lucky",
			"trait.cocky",
			"trait.athletic",
			"trait.brute",
			"trait.bloodthirsty",
			"trait.deathwish",
			"trait.impatient"
		];
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{沙漠掠袭者入侵他的村庄时，%name%奋起反抗，结果被赏了个鸡飞蛋打。 | %name%被控没有征得女人的同意就和她上了床。要么死，要么阉，你不需要物证就能知道他选了哪一个。 | %name%小时候，他醉酒的{母亲 | 父亲 | 姐姐 | 哥哥}用{热锅 | 锯齿状的刀子}{在他睡觉时杀向了他的老二 | 对他的下体进行残忍的折磨}。 | %name%穿越%townname%附近的无边沙漠时，受到了野生鬣狗的攻击，扯下了他身上一大块肉。他虽然幸存下来，但后来才意识到，这只野兽也阉割了他。 | %name%来自%randomcitystate%的妓院，为了满足特定客人的要求，他的身体被割掉了一部分。}{当你碰见他时，他正在四处漂泊。现在看来，他只是想远离这个世界，即便这意味着加入{佣兵 | 雇佣军}的行列。虽然你不愿看到他的困境复现在别人身上，但他实在是相当冷静。 | 你发现他的时候，他正被孩子欺负。看到你的剑，他礼貌地请求加入你的队伍 —— 一个不在乎人的过去或是身体残缺的地方。他已经习惯了生活中的挣扎，或许是以大多数男人无法理解的方式。 | 令人意外的是，这人站得比大多数人还要直。对于一个失去了如此珍贵的东西的人来说，他看起来相当平和镇定。 | 这个男人过去的恐怖遭遇令你毛骨悚然，胯下一紧，但这个阉人似乎并不为自己所经历的事情感到困扰。他是一个冷静静、甚至有些被动的人物。 | 这个人的一举一动比你见过的大多数僧侣还要冷静。他似乎能和自己惨痛的过去和平共处。 | 不再有肉欲需要满足，这个人似乎变得相当平静，甚至可以说是坚定，看待事物远比其表象更深。}";
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/oriental/cloth_sash"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/oriental/padded_vest"));
		}
	}

});
