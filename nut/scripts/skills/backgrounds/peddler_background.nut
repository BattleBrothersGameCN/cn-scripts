this.peddler_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.peddler";
		this.m.Name = "小贩";
		this.m.Icon = "ui/backgrounds/background_19.png";
		this.m.BackgroundDescription = "小贩不习惯艰苦的体力劳动或战争，但他们确实擅长讨价还价。";
		this.m.GoodEnding = "一个以买卖为生的人，小贩%name%没办法长时间参加战斗。他最终离开了%companyname%，开始自己的生意。最近，你听说他在卖印有战团标志的小饰品。你明确告诉他，他可以做任何他想做的事，除了这一件，但显然你的警告只是在他心中助长了这种想法。当你去叫他停下来的时候，他猛然将装了许多克朗的挎包扔在他那相当华丽的桌子上，并表示这是你的“分成”。他至今仍在出售那些小饰品。";
		this.m.BadEnding = "由于%companyname%遭遇困境，许多兄弟们觉得应该回到他们以前的生活中。小贩%name%也不例外。据你最后一次听到的消息，他试图向商人出售“从运货马车上掉下来的”商人自己的被盗货物而被痛打了一顿。";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
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
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Thick;
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
		return "{挨家挨户地走， | 曾经是一个骄傲的商人，现在 | 对于大多数人而言都很烦人， | 在困难时期，每个人都要设法勉强度日，这就是为什么 | 不是什么行当的人，而是专门做买卖，}%name%只不过是个小贩。{他会跳舞，他会唱歌，他会吹嘘，他会扮演一个国王，不择手段只为做成一笔生意。 | 他勇往直前、不屈不挠，他的坚韧令人钦佩。 | 他会试图将一只生锈的桶子当作曾被国王佩戴过的头盔出售。这个人什么都敢卖。 | 这个男人会让你渴望你从未想过想要的东西。不过，概不退货。 | 他以前靠卖{二手推车 | 锅碗瓢盆}来维持体面的生活，直到激烈的竞争把他赶出了这个行业 —— 弄断了他的胳膊。}{推销自己是这个男人最擅长的事情，尽管很少有人相信他“剑术精湛、勇敢无畏”的宣传。 | 据说他为他的服务发放“优惠券”，尽管我们不知道这些服务具体是什么。不过他很有活力，现在任何团队都需要一个热心的成员，无论他的实际价值如何。 | 他承诺，如果被录用，你将获得一种增强男子气概的药剂的特别折扣。 | 那人压低声音告诉你，他有很多生锈的箭头，专为你准备的。他对你缺乏兴趣显得很失望。 | 这个人认识一个人，那个人又认识另一个人，那个人又认识另一个人。三个陌生人都可能比他更擅长打架。 | 遗憾的是如今人不能用嘴巴干架，否则%name%将无人可挡。}";
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
				0
			],
			MeleeSkill = [
				-10,
				-9
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				2,
				7
			],
			RangedDefense = [
				2,
				7
			],
			Initiative = [
				0,
				7
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(0, 3) == 3)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.PeddlerTitles[this.Math.rand(0, this.Const.Strings.PeddlerTitles.len() - 1)]);
		}
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
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/feathered_hat"));
		}
	}

});
