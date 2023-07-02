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
		return "{当沙漠掠夺者入侵他的村庄时，%name%奋起反抗，结果他的老二和蛋蛋被从他身上割下来作为惩罚。 | %name%被指控在一名不情愿的女人的床上犯下了可恶的罪行，他面临着死亡或成为一名阉人的选择。你不需要物证就能知道他选了哪一个。 | 在%name%小时候，他醉酒的{母亲 | 父亲 | 姐姐 | 哥哥}用{热锅 | 锯齿状的刀子}{在他睡觉时杀向了他的老二 | 对他的下体进行残忍的折磨}。 | 当%name%穿过无尽的沙漠时，他被鬣狗攻击，扯下了他身上一大块肉。他虽然幸存下来，但后来才意识到这只野兽也阉割了他。 | %name%来自%randomcitystate%的妓院，他的身体曾被毁损以满足某位特定客人的要求。}{当你碰见他时，他正在四处漂泊。现在看来，他只是想远离这个世界，即使这意味着加入{佣兵 | 雇佣军}的行列。虽然他的困境是你不希望发生在任何人身上的，但他是个相当冷静的伙计。 | 你发现他的时候发现他正在被孩子欺负。看到你的剑，他礼貌地请求加入你的队伍 —— 一个人的过去或身体残缺都不重要的地方。他已经习惯了生活中的挣扎，或许是以大多数男人无法理解的方式。 | 令人惊讶的是，这个人站得比大多数人都直。对于一个失去了如此珍贵的东西的人来说，他看起来相当平静和镇定。 | 虽然这个男人过去的恐怖遭遇令你毛骨悚然，让你感觉下体几乎要缩起来，但这个阉人似乎并不为自己所经历的事情感到困扰。他是一个镇静、几乎被动的人物。 | 这个人的动作比你见过的大多数僧侣都更冷静。他似乎能和自己惨痛的过去和平共处。 | 不能再满足他的肉欲后，这个人似乎变得相当平静。甚至是坚定，并看待事物看到得比其的表象更多。}";
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
