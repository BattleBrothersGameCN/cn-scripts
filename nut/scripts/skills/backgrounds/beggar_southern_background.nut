this.beggar_southern_background <- this.inherit("scripts/skills/backgrounds/beggar_background", {
	m = {},
	function create()
	{
		this.beggar_background.create();
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.SouthernUntidy;
		this.m.Bodies = this.Const.Bodies.SouthernSkinny;
		this.m.BeardChance = 90;
		this.m.Ethnicity = 1;
		this.m.Names = this.Const.Strings.SouthernNames;
	}

	function onBuildDescription()
	{
		return "{在一场大火中失去一切之后 | 在他赌博成瘾后 | 被诬陷了他不曾犯下的罪名，并不得不向治安官交出全部财产避免牢狱之灾 | 一个村庄被烧成平地后的难民 | 在与他的兄弟发生暴力冲突后被逐出家门 | 一个没有什么才能又没有野心的人 | 一个没有什么才能又没有野心的人 | 被关在领主地牢中数不尽的岁月后终于得到释放 | 在把他所有的财产交给一个承诺拯救他永恒的灵魂的不知名邪教后 | 一个非常聪明的人，直到一个强盗敲了他的头}，{%name%发现自己流落街头， | %name%被迫流落街头，}{不得不为面包乞讨 | 依靠别人的善意 | 时常挨打并开始听天由命 | 把仅有的一点钱都花在喝酒上 | 把仅有的一点钱都花在喝酒上 | 到处翻其他人的垃圾并躲治安官 | 一边躲避暴徒流氓，一边讨钱}。{尽管他似乎认真想成为一名雇佣兵，但毫无疑问，他所有的街头生活都剥夺了%name%最好的年华。 | 这么多年过去，到今天他的健康已经受损。 | 像%name%这样的人只要在街上待上几天，更别说几年，即使是非常危险的佣兵工作，对他而言也是最棒的差事。 | 只有神知道%name%为了生存都经历了什么，但现在站在你面前的只是一个瘦弱的人。 | 他一看到你就准备张开双臂拥抱，声称多年前就认识你并一同进行了许多冒险，尽管他这会儿还想不起你的名字。}";
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
			local item = this.new("scripts/items/helmets/oriental/nomad_head_wrap");
			item.setVariant(16);
			items.equip(item);
		}
	}

});
