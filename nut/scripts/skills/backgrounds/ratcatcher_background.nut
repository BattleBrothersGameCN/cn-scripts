this.ratcatcher_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.ratcatcher";
		this.m.Name = "捕鼠者";
		this.m.Icon = "ui/backgrounds/background_41.png";
		this.m.BackgroundDescription = "捕鼠者需要快速反应才能捉住他们的猎物。";
		this.m.GoodEnding = "捉鼠人%name%出身神秘，亦归于神秘。离开了%companyname%后，他开了一家捉鼠公司。他的生意非常好，直到有传言称他没有杀死任何老鼠，而是将成千上万的老鼠藏在城外的一个仓库里。据你最后所知，这个人对他新交的众多朋友非常满意。";
		this.m.BadEnding = "你本以为%name%不适合当佣兵，但是他证明了自己的能力。不幸的是，%companyname%瓦解了，他又回去抓老鼠了。你听说他的尸体在下水道里被发现，老鼠爬满了全身，啃食着他的血肉，据说他脸上带着微笑。";
		this.m.HiringCost = 40;
		this.m.DailyCost = 4;
		this.m.Excluded = [
			"trait.huge",
			"trait.hate_undead",
			"trait.hate_beasts",
			"trait.clubfooted",
			"trait.brute",
			"trait.tough",
			"trait.strong",
			"trait.cocky",
			"trait.fat",
			"trait.hesitant",
			"trait.bright",
			"trait.fearless",
			"trait.brave",
			"trait.determined",
			"trait.deathwish",
			"trait.greedy",
			"trait.sure_footing",
			"trait.clumsy",
			"trait.short_sighted"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
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
		return "{老鼠捕手，这是%name%曾经喜欢的头衔。 | 也许是自尊心错位，%name%把自己打扮成一个下水道工人。 | 罗圈腿、骨瘦如柴，%name%捕鼠的职业生涯似乎已将他也变成了老鼠。}他在%townname%长大，{在巷子里 | 靠老鼠，这下水道的果实 | 和毛茸茸的、爬行的动物，还有一些老鼠一同}生存了下来。{为了廉价的娱乐，他父亲教他如何诱捕小啮齿动物 | 他死去弟弟的尸体被老鼠吃掉，铸就了他向啮齿类复仇的愤怒未来 | 他母亲要他找能找到的最好的肉，她并不是指从市场上买的}。但是%townname%慢慢消磨着人们，就像一只巨大的、咬人的生物一样影响了%name%。{听说世界上有更大的老鼠 | 觉得生活中一定有比老鼠更重要的东西 | 相信他的鼠语技巧}，%name%现在试图{好好利用他干瘪的鼻子，奇怪的啃食习惯，以及敏捷但有点令人不快的双手。 | 碾碎每一只老鼠，看着它们在他面前被驱赶，听到它们同类的尖叫。当他告诉你这些的时候，他瞪着眼睛，攥紧拳头。 | 把他的技能从老鼠身上转移到狗身上，也许还可以转移到人类身上，他这么说。他似乎不知道自己要面对什么，但也许最好不要告诉他。 | 准备一些老鼠汤、老鼠沙拉、老鼠烤串、老鼠面包、老鼠炖肉、老鼠炸鸡、老鼠酒……过了一会儿，你就听不下去了。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-5,
				-5
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
				18,
				15
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
			actor.setTitle(this.Const.Strings.RatcatcherTitles[this.Math.rand(0, this.Const.Strings.RatcatcherTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/tools/throwing_net"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
	}

});
