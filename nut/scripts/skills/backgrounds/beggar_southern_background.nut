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
		return "{一场大火夺走了一切 | 被赌瘾压垮了理智 | 被安上了从没犯过的罪，只得破财以免牢狱之灾 | 村庄被一场火烧成了白地 | 因兄弟不和被逐出家门 | 既没才能又没野心 | 无数年的牢狱生活终于重见天日 | 为了所谓的灵魂救赎把财产全数交给了邪教 | 强盗敲坏了他的聪明头脑}，{回过神来，%name%已然流落街头， | %name%被迫流落街头，}{为填饱肚子沿街乞讨 | 靠别人的善意苟且偷生 | 时常挨打并开始听天由命 | 把仅有的一点钱用来借酒消愁 | 躲避治安官的驱逐和追捕，在垃圾堆里刨食 | 讨钱的同时还得躲避流氓}。{看起来他真心成为一名雇佣兵，但街头的日子无疑消磨了%name%最好的年华。 | 这么多年过去，到今天他的健康已经受损。 | 对于像%name%这样在街上待了几天，更别说是几年的人来说，极其危险的佣兵工作他也能甘之如饴。 | 只有神知道%name%为了生存都经历了什么，你只知道，站在你面前的不过是一个瘦弱的人 | 他一看到你就张开双臂走了过来，说你是他多次一起冒险过的老熟人，不过他这会儿还想不起你的名字。}";
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
