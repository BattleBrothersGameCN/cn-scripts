this.gambler_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.gambler";
		this.m.Name = "赌徒";
		this.m.Icon = "ui/backgrounds/background_20.png";
		this.m.BackgroundDescription = "赌徒往往比牌桌上的对手反应更迅速、决心更坚定。";
		this.m.GoodEnding = "让%name%这样的赌徒加入队伍本身也是一场豪赌。但现在看来，你显然做出了正确的选择。你上次听到的消息是，他还在战团里，并且用他的收入来丰富他的生活习惯。有传言说，他通过一系列胜利，已经秘密地成为了世界上最富有的人之一。你认为这是一派胡言，但出人意料的是，越来越多的官员放松了对赌博的管制……";
		this.m.BadEnding = "赌徒%name%从每况愈下的战团退休，重返赌博生活。没过多久，他就欠下了无法偿还的巨额债务。你看到他在街角乞讨，少了一只手，裂了几颗牙。你往他的罐子里扔了几个克朗，说了几句话，但他没有认出你来。";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.huge",
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.hate_beasts",
			"trait.paranoid",
			"trait.brute",
			"trait.athletic",
			"trait.dumb",
			"trait.clumsy",
			"trait.loyal",
			"trait.craven",
			"trait.dastard",
			"trait.deathwish",
			"trait.short_sighted",
			"trait.spartan",
			"trait.insecure",
			"trait.hesitant",
			"trait.strong",
			"trait.tough",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"二点牌(Deuces)",
			"百搭牌(the Wild Card)",
			"幸运制造者(the Luck Maker)",
			"幸运星",
			"牌术大师(the Cardsharper)",
			"赌徒(the Gambler)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Thick;
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
		return "{人们说运气是魔鬼，那%name%这样的赌徒又能与魔鬼共舞多久？ | 人都有赌的时候，所以%name%想：那为什么不赌点钱呢？ | 骰子，卡牌，弹珠 —— 赢人钱的方法数不胜数，%name%都有涉猎。 | %name%眼观六路耳听八方 —— 操弄纸牌就是他的特长。 | 在生死存亡的世界里，铤而走险就是%name%的生存方式。 | %name%这样的人能预见未来，尤其是牌堆里的下一张牌。} {他往来于城镇之间，靠赌博为生，直到他输光口袋里的钱为止。 | 但是真有人一天到晚打牌吗？真搞不懂。 | 来来往往的雇佣兵是赢钱的好目标 —— 直到有输不起的人提着手半剑把他赶了出来。 | 被生身父母遗弃，他靠赌博一点点刮来生活的本钱。 | 他还是个孩子的时候，一个骗子的杯子游戏让他明白了千术的价值。 | 他的父亲赌债缠身，他认为还债的最好方法就是用千术打败千术。 | 输了个底朝天， 各地以“宗教复兴”的名义把%name%拉进了黑名单。} {现如今，这位赌徒把骰子归还给天地， 加入任何愿意付钱的人。 | 一位牌术大师突然不打牌了，这真是让人想不明白。 不过话说回来，他愿意押在你的战团上，这没准是个好兆头。 | 多年来欺诈佣兵的经历给了他能轻易胜任佣兵的想法。 | 聪明又灵光，这位牌术大师总能先别人一步，光这一点就足以比上任何能力了。 | 讽刺的是，错误的押注让他欠下一位男爵巨额债务。现在他只能另寻方法还债了。 | 战争榨干了他所有的大鱼。他觉得与其等待，不如也加入战争一方。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-2,
				-2
			],
			Bravery = [
				12,
				12
			],
			Stamina = [
				-6,
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
				2
			],
			RangedDefense = [
				2,
				8
			],
			Initiative = [
				12,
				10
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/noble_tunic"));
		}
		else
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
