this.servant_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.servant";
		this.m.Name = "仆人";
		this.m.Icon = "ui/backgrounds/background_16.png";
		this.m.BackgroundDescription = "仆人不经常从事艰苦的体力劳动。";
		this.m.GoodEnding = "原来%name%这个仆人一直积攒着他在%companyname%赚来的每一枚克朗。当他储蓄够了的时候，他退休了，买了一块土地并缓慢地攀登社会阶层。他最终在一张舒适的床上离开了人世，被朋友、家人和忠诚的仆人所包围。";
		this.m.BadEnding = "%name%这个仆人已经厌倦了雇佣兵的生活并离开了战团。他回去为贵族服务。当掠夺者攻击他的领主城堡时，仆人被贵族推出门外，只有一把厨房刀来自保。他被发现躺在一堆破椅子中，没有脑袋，周围散落着几具袭击者的尸体。";
		this.m.HiringCost = 45;
		this.m.DailyCost = 4;
		this.m.Excluded = [
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
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.Old;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsOffendedByViolence = true;
	}

	function onBuildDescription()
	{
		return "{生活是艰难的。对一些人来说更甚。 | 一些人可以从高位坠落。而另一些人则无处可坠，因为他们生来已处于底层。 | 如果投胎就像掷骰子，那么有些人可能是傻瓜，选择做人而不是做老鼠。}%name%{曾是一个颓废领主的仆人。 | 曾为一个孩子会玩火的虐待狂家族服务。 | 被强盗绑架，被迫满足他们的需求，各种需求，直到最后。 | 狂热地为那些盯着星星看得太久的疯子工作。}他很少对自己在这世上的地位有错误的认识。然而，有一天，他的主人{将他殴打至昏迷。当他醒来时，他在一位仁慈的医生的床上苏醒过来，这位医生拒绝让他回到他的“雇主”那里。相反，%name%获得了自由，他的主人们被告知他已经死了。 | 予以他自由，且没说理由。%name%不是一个在客套上拖延的人，他很认真地离开了。 | 邀请他参加一个聚会。他以为自己是客人，所以穿上了他最好的衣服 —— 一件袖子有褶边的衬衫和一条遮住了他瘦骨嶙峋身躯的宽松裤子。不幸的是，他只是聚会中的一个节目 —— 他们给了他一面木盾和一把剑，把他和一头野猪扔进一个竞技场，并押注看着这可怕的场景。他勉强活过了这场“庆典”。}{%name%从此发誓不再为某人“服务”。 | 这个人，虽然现在摆脱了他的旧职责，但仍然承受着他漫长而艰苦的生活带来的巨大羞辱和痛苦。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-5,
				-5
			],
			Bravery = [
				-5,
				-5
			],
			Stamina = [
				-5,
				-5
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
				2,
				0
			],
			Initiative = [
				5,
				0
			]
		};
		return c;
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
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}
	}

});
