this.servant_southern_background <- this.inherit("scripts/skills/backgrounds/servant_background", {
	m = {},
	function create()
	{
		this.servant_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernThick;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.Ethnicity = 1;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.huge",
			"trait.hate_undead",
			"trait.hate_greenskins",
			"trait.hate_beasts",
			"trait.impatient",
			"trait.iron_jaw",
			"trait.brute",
			"trait.athletic",
			"trait.strong",
			"trait.disloyal",
			"trait.fat",
			"trait.brave",
			"trait.fearless",
			"trait.optimist",
			"trait.cocky",
			"trait.bright",
			"trait.determined",
			"trait.greedy",
			"trait.sure_footing",
			"trait.bloodthirsty"
		];
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{生活何其艰辛。而有些人尤其艰辛。 | 一些人可以从高位坠落。而另一些人则无处可坠，他们生来就处于底层。 | 如果投胎就像掷骰子，那么有些人可能是傻瓜，选择做人而不是做老鼠。}%name%{曾是一个颓废维齐尔的仆人。 | 曾为一个孩子玩火的虐待狂家族服务。 | 被游牧民绑架，被迫满足他们的任何，一点，需求。 | 狂热地为那些整天盯着星星的疯子工作。}他很少看错自己在这世上的地位。然而，有一天，他的主人{将他殴打至昏迷。当他醒来时，他在一位仁慈的医生的床上苏醒过来，这位医生拒绝让他回到他的“雇主”那里。相反，%name%获得了自由，他的主人们被告知他已经死了。 | 予以他自由，且没说理由。%name%不是个繁文缛节的人，他很认真地离开了。 | 邀请他参加一个聚会。他以为自己是客人，所以穿上了他最好的衣服 —— 一件缩褶袖的衬衫和一条宽松的灯笼裤，藏住了他的瘦骨嶙峋。不幸的是，他只是聚会中的一个节目 —— 他们给了他一面木盾和一把剑，把他和一头鬣狗扔进一个竞技场，看着它们互相厮杀，拿它们的命打赌。他勉强活过了这场“庆典”。}{%name%从此发誓不再为某人“服务”。 | 这个人，虽然已经摆脱了杂役工作，却仍然承受漫长的苦日子带来的巨大羞辱和痛苦。}";
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/oriental/cloth_sash"));
		}
	}

});
