this.messenger_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.messenger";
		this.m.Name = "信使";
		this.m.Icon = "ui/backgrounds/background_46.png";
		this.m.BackgroundDescription = "信使习惯习惯于漫长而劳累的旅行。";
		this.m.GoodEnding = "在信使%name%展现自己的杀戮本领之后，你自然接纳了他。据你所知，他依旧留在战团中，更喜欢当一名佣兵而不是信使。你并不怪他，跑腿的必须向他遇到的每位贵族屈膝，但在佣兵团里，他偶有机会杀掉其中的一些混蛋。值了！";
		this.m.BadEnding = "信使%name%离开了%companyname%，重拾为封建领主传递信函的差事。你曾尝试找到他去了哪里，最终找到了他 —— 或者说是他的遗骸。不幸的是，“不斩来使”在这片四分五裂的土地上并不被人们遵循。";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.huge",
			"trait.hate_undead",
			"trait.paranoid",
			"trait.clubfooted",
			"trait.asthmatic",
			"trait.cocky",
			"trait.craven",
			"trait.deathwish",
			"trait.dumb",
			"trait.fat",
			"trait.gluttonous",
			"trait.brute"
		];
		this.m.Titles = [
			"信使(the Messenger)",
			"邮差(the Courier)",
			"跑手(the Runner)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
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
		return "{有的人重要到了需要别人替他传话的地步。%name%就是这样一个人 —— 确切地说，是后面那种。 | %name%肩膀上扛着一包包的邮件，但几乎可以肯定的是大多数收件人在邮件送达前就死了。 | 为了逃离被奴役的生活，%name%从事了信使的职业。 | 着急了解他们亲戚情况的人太多了，信使%name%的工作过于充实。 | %name%曾经作为一个小信使走遍了这片土地。 | 就像他父亲和他父亲的父亲一样，%name%为皇室和普通人传递信息。 | 捡起一个死去信使的包，%name%很快就发现自己成了个准信使。 | 作为一名曾经的难民，%name%发现既然他已经在这片土地上游荡，他还不如去送信。}{但是来回奔波开始变得无聊。这个邮递员开始寻找新的工作领域。 | 带着情书，这个想要成为冒险者的家伙想知道自己究竟在干什么。 | 自称是一个新兴英雄的%name%现在认为送信的活计配不上他了。 | 雨或阳光，当然可以；雪或冰雹，没有问题；但全面战争？还是算了。 | 但在打开一封会毁掉一个好心贵族的信后，信使决定离开他的岗位。 | 当强盗把他的生活搞得一团糟时，%name%认为他最好和武装人员结伴旅行。 | 在和一位镇长的妻子上床后，信使被一支小部队追捕。他觉得为了自己的安全，最好换套行头。}{%name%多年来一直在记忆信息。现在他必须记住在箭雨落下时保持住盾墙。 | 具有讽刺意味的是，%name%一生中从未写过任何东西。 | %name%卷起袖子，自夸他还有一条最后的信息要传达给世界。大家要注意了。 | 也许他加入佣兵的行为表明，笔的确不如剑有力。 | %name%有重复每一句对他说的话的倾向。信使的旧习难改。 | 具有讽刺意味的是，这个行走千里的信使在路上可能比大多数队伍中的男人目睹了更多的恐怖景象。 | %name%几乎没有任何能让他准备好参与战斗的技能。但他确实有一双强壮的腿，希望那不只是为了逃跑而准备的。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				5,
				0
			],
			Stamina = [
				15,
				10
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
				2
			],
			RangedDefense = [
				3,
				3
			],
			Initiative = [
				0,
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
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/straw_hat"));
		}
	}

});
