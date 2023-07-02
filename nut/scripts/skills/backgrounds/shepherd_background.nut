this.shepherd_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.shepherd";
		this.m.Name = "牧羊人";
		this.m.Icon = "ui/backgrounds/background_44.png";
		this.m.BackgroundDescription = "牧羊人习惯于体力劳动，而且以用投石索击退偶尔出现的狼出名。";
		this.m.GoodEnding = "像%name%这样的牧羊人能够加入佣兵战团是十分不寻常的，但他证明了自己是一个出色的战士。随着伤病不断增多，他最终选择退役，拄着手杖回到牧场放羊，直到最后的平静日子。";
		this.m.BadEnding = "你认为一个牧羊人在雇佣军的队伍中会格格不入，而最终%name%也认同了这一点。他在你离开%companyname%不久后也离开了，据你最后听到的消息，他又回到了放羊的生活中。虽然大多数人在离开战团时情绪低落，但%name%受到的伤害并没有使他放弃安逸的生活方式 —— 盯着那吓人程度仅仅等同于坏梦的白绒绒可爱小动物。";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.hate_undead",
			"trait.impatient",
			"trait.iron_jaw",
			"trait.athletic",
			"trait.deathwish",
			"trait.sure_footing",
			"trait.disloyal",
			"trait.greedy",
			"trait.drunkard",
			"trait.fearless",
			"trait.brave",
			"trait.iron_lungs",
			"trait.strong",
			"trait.tough",
			"trait.cocky",
			"trait.brute",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"牧羊人(the Shepherd)",
			"谦卑者(the Humble)",
			"平和者(the Peaceful)",
			"山羊人(the Goatman)",
			"蹄心(Hoofmind)",
			"羊(the Sheep)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsOffendedByViolence = true;
		this.m.IsLowborn = true;
	}

	function onBuildDescription()
	{
		return "{%name%只是一个来自一个普通小镇的普通牧羊人，花了很多年照顾他的羊群。 | 像%townname%这样可爱的地方配得上有个像%name%这样可爱的牧羊人。 | %name%在埋葬他父亲的同一天继承了他的羊群。 | 在他小时候，%name%偶然发现了一个死去的牧羊人和他身边无精打采的羊群。男孩拿起牧羊人的手杖，接替着他的工作干了了许多年。 | 比狗更色盲的%name%总是喜欢和喜欢颜色的绵羊在一起。 | 当%name%从塔上摔下来时，一群绵羊托住了他。他发誓要通过成为这片土地上最安全的牧羊人来报答它们的牺牲。 | %name%把绵羊从一个镇带到另一个镇，把它们的羊毛卖给裁缝，把皮卖给制革匠，从中获利。 | 放羊是%name%能找到的最容易的工作。 | %name%和他照看的绵羊一样无害，为了在残酷的世界中找到平静，他开始牧羊。 | %name%从来没有在人类中找到过好伙伴，他更喜欢绵羊的忧郁智慧。 | 从小被霸凌的%name%在放羊的过程中找到了安宁。 | %name%生活中顽皮而温顺的绵羊让他在原本艰苦的成长环境中得到了平静和安宁。 | %name%曾经被误认为是{先知 | 新的救世主}，他最终借由混入牧羊的活计逃脱了{宗教团体 | 愤怒的审判官}。 | 看管着{绵羊 | 白色的羊毛团}整天吃草听起来很无聊，但对%name%来说却是一种极乐。 | %name%被一场放羊比赛吸引住了，于是把放羊当作一项竞争激烈的职业。 | %name%一直是一个温柔善良的男孩，对于他这样的人而言牧羊是很合适的。 | 在逃离虐待他的{母亲 | 父亲 | 姐姐 | 哥哥 | 叔叔 | 阿姨}后，%name%通过当一个牧羊人得到了宁静。}{在诸神追随者和邪教之间的宗教冲突中，他的羊群遭受了那些既寻找替罪羊也需要祭品的人的愤怒。 | 有一次他用手杖击退了{强盗 | 狼群}，牧羊人想知道，也许他的身体比他曾经想象的更有力。 | 随着时间的推移，这个人觉得{他的职业已经离他远去了。 | 好像他的心思不在这上面了。}{他悲伤地退休 | 他挂上了他的牧羊杖}去找别的工作。 | 他觉得自己仿佛看到了世界的美丽，却没有完全体会到，于是他决定放弃牧羊。 | 当庞大、毛茸茸的野兽屠杀他的羊群时，牧羊人只能寻求复仇。 | 不幸的是，这个人唯一的同伴，一只牧羊犬，被{强盗 | 兽人 | 狼群}杀死了，使得这个平和的人寻求复仇。 | 被借贷骗子的诡计所困，牧羊人短期内需要的钱大大超过他养的一群羊能提供的。 | 然而，生活的孤独最终让这个牧羊人难以承受。 | 长时间的独处日夜逐渐耗损着牧羊人，就像对任何人一样。 | 但他无法摆脱父亲对他男子气概的期许，有一天他放下手杖，去寻找一份更有男子气概的职业。 | 但有一天，他一边织布一边放羊，最终把他所有的羊都带下了悬崖。 | 但是在一个下雨的下午，他忍无可忍地发出了一声羊叫声：他必须做点什么，而不是整天盯着羊看。 | 一天早晨，他醒来时满身是羊血、羊内脏和满是羊内脏的血淋淋的羊毛。狼群在远处欢快地嚎叫着。事实证明，那天晚上他数的羊多了一只。 | 不幸的是，关于他在他的羊群中私下做的事情的谣言太令人尴尬了，他不得不逃往更加绿色、更加宽容的牧场。 | 不幸的是，沉溺于暴力的强盗偶然发现了他的羊群。贝茜、小艾达，甚至刚出生的山羊都遭到了惨绝人寰的屠戮。}{在进城思索事情时，%name%偶然看到了一份招募雇佣军的通告。既然没有什么好失去的，他准备签约。 | 这片土地容不下一个平和的牧羊人。是时候开始新的生活了。 | %name%的脖子下面挂着一个小小的、沾满鲜血的铃铛。它是另一个生命的遗物，也许是一个新生活的标志。 | 他发誓还能听到羊群的咩咩叫。出于某种原因，这并没有激发人们对他战斗技巧的信心。 | 虽然尽可能地保持平静无波，但没有了羊，这个人还是有点迷失。 | 虽然他算不上战士，但他知道如何保持队形紧凑。 | %name%对星星的认识出奇地好，他能在黑暗中定位声音，就像盲犬嗅出食物一样。 | 长途跋涉使%name%拥有了结实的腿，但他最多的战斗经验就是用棍子打架。 | 世界通常不会在需要时依靠牧羊人，但当前这个世界实在太需要帮助了。 | 看着牧羊人，你不禁会想：事情已经变得多么糟糕，以至于这样的人都站在了这里。 | %name%几乎把所有的武器都像手杖一样拿着，而且他有一个坏习惯，就是敲打别人的腿来推动他们前进。 | %name%的谦逊相对雇佣兵中常见的鼓吹战士很受欢迎。 | %name%看起来连一只苍蝇都不会伤害，但经过良好的训练，你会发现他可以伤到更多。 | %name%不像其他佣兵那样有杀人的信念，但他和其他男人一样，可以被训练成为一个优秀的战士。 | %companyname%的有些人比绵羊强不了多少。也许%name%还是在这里有一席之地的。}";
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
				0,
				5
			],
			MeleeSkill = [
				0,
				0
			],
			RangedSkill = [
				5,
				7
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

		if (this.Const.DLC.Wildmen)
		{
			if (this.Math.rand(1, 100) <= 66)
			{
				items.equip(this.new("scripts/items/weapons/staff_sling"));
			}
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			local item = this.new("scripts/items/armor/linen_tunic");
			item.setVariant(this.Math.rand(6, 7));
			items.equip(item);
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/straw_hat"));
		}
	}

});
