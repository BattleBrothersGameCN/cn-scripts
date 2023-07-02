this.peddler_southern_background <- this.inherit("scripts/skills/backgrounds/peddler_background", {
	m = {},
	function create()
	{
		this.peddler_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernMale;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.BeardChance = 90;
		this.m.Ethnicity = 1;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.huge",
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.hate_beasts",
			"trait.iron_jaw",
			"trait.clubfooted",
			"trait.brute",
			"trait.athletic",
			"trait.iron_lungs",
			"trait.strong",
			"trait.tough",
			"trait.cocky",
			"trait.dexterous",
			"trait.dumb",
			"trait.deathwish",
			"trait.bloodthirsty"
		];
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{挨家挨户地走， | 曾经是一个骄傲的商人，现在 | 对于大多数人而言都很烦人， | 在困难时期，每个人都要设法勉强度日，这就是为什么 | 不是什么行当的人，而是专门做买卖，}%name%只不过是个小贩。{他会跳舞，他会唱歌，他会吹嘘，他会扮演一个国王，不择手段只为做成一笔生意。 | 他勇往直前、不屈不挠，他的坚韧令人钦佩。 | 他会试图将一只生锈的桶子当作曾被国王佩戴过的头盔出售。这个人什么都敢卖。 | 这个男人会让你渴望你从未想过想要的东西。不过，概不退货。 | 他以前靠卖{二手推车 | 锅碗瓢盆}来维持体面的生活，直到激烈的竞争把他赶出了这个行业 —— 弄断了他的胳膊。}{推销自己是这个男人最擅长的事情，尽管很少有人相信他“剑术精湛、勇敢无畏”的宣传。 | 据说他为他的服务发放“优惠券”，尽管我们不知道这些服务具体是什么。不过他很有活力，现在任何团队都需要一个热心的成员，无论他的实际价值如何。 | 他承诺，如果被录用，你将获得一种增强男子气概的药剂的特别折扣。 | 那人压低声音告诉你，他有很多生锈的箭头，专为你准备的。他对你缺乏兴趣显得很失望。 | 这个人认识一个人，那个人又认识另一个人，那个人又认识另一个人。三个陌生人都可能比他更擅长打架。 | 遗憾的是如今人不能用嘴巴干架，否则%name%将无人可挡。}";
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/dagger"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/oriental/cloth_sash"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/oriental/southern_head_wrap"));
		}
	}

});
