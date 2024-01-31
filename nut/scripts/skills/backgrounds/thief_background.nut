this.thief_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.thief";
		this.m.Name = "盗贼";
		this.m.Icon = "ui/backgrounds/background_11.png";
		this.m.BackgroundDescription = "一个厉害的盗贼会有快速的反应力和躲避任何抓捕者的能力。";
		this.m.GoodEnding = "盗贼%name%退出了战斗这行，并从地图上消失了。你们自那以后再也没有听说过这个人，但有传言说，一位贵族的金库在一次完美的劫盗中被完全掏空了。";
		this.m.BadEnding = "盗贼%name%嗅出了征兆，趁还来得及的时候退出了%companyname%。他带着积攒的钱财招募了一支盗贼团队。最后你听说他们完成了一场完美的大劫案，只可惜其中一位同伴却对他背地里捅刀子，拿走了所有赃物。";
		this.m.HiringCost = 95;
		this.m.DailyCost = 10;
		this.m.Excluded = [
			"trait.huge",
			"trait.teamplayer",
			"trait.hate_undead",
			"trait.hate_greenskins",
			"trait.hate_beasts",
			"trait.paranoid",
			"trait.night_blind",
			"trait.clubfooted",
			"trait.brute",
			"trait.dumb",
			"trait.loyal",
			"trait.clumsy",
			"trait.fat",
			"trait.strong",
			"trait.hesitant",
			"trait.insecure",
			"trait.clubfooted",
			"trait.short_sighted",
			"trait.brute",
			"trait.strong",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"影子(the Shadow)",
			"掏包儿(the Cutpurse)",
			"蛇(the Snake)",
			"乌鸦(the Raven)",
			"恶贼(the Burglar)",
			"抢掠者(the Snatcher)",
			"黑猫(the Black Cat)",
			"王子(the Prince)",
			"快指(Quickfingers)",
			"盗贼(the Thief)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
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
		return "{被盗贼用蜂蜜牛奶和偷来的金子抚养长大，%name%的人生一开始就走错了路。 | 由酗酒的父亲和病重的母亲抚养长大，%name%一路被引导走向了偷盗生涯。 | 作为一个贫困家庭的第六个出生的孩子，初出茅庐的盗贼%name%从偷走晚餐的最后一点开始学习这门手艺。 | 在为富有贵族服务的仆人家庭中长大的%name%最终成长为了一个贼，多年来一直盯着王室的富丽堂皇 —— 并从中偷窃。 | 被当地一家孤儿院收养后，%name%很快就开始遭受那些低下的孤儿的虐待。他只好重拾了偷窃生涯以便维持生计。 | 成了孤儿的%name%成长为一个街头顽童，他的日子被割钱包和掏口袋支配着。 | 虽然从来没有特别需要钱，但%name%对物质的嫉妒致使他偷窃。 | 富人们在穷人群众中夸张挥霍总是让%name%不爽。所以他从他们那儿两头都偷东西给自己。 | %name%的父亲教会了他所有关于偷窃的知识，不幸的是，包括如何背后捅刀子。 | 教堂用银盘偷东西。领主们和收税员一起干这行当。所以%name%想，为什么不能自己动手呢？ | %name%在贫困中长大，于是开始偷面包。在吃饱后，他很快就开始偷钱了。}{在成功偷窃多年后，一次失误使%name%被关进了地牢。幸运的是，多年的偷窃也意味着多年的开锁，他没有花太长时间。 | 但当他试图偷窃神殿的圣餐杯被抓住时，与一位牧师的谈话说服了%name%考虑另一条道路。 | 不幸的是，在当地一家商店的一次砸抢事件以%name%被当场发现而告终。他很快就出现在了到处张贴的通告上，使得他的作案难度变得更大了。 | 由于胆敢割开一个胖商人的钱包，导致%name%很快开始护理他那少了几根手指的手。他也真的很喜欢那些手指。 | %name%的偷窃行为最终使他成为整个行会的首领。但在遭遇了十几次失败的暗杀行动后，这个盗贼意识到在他的行当里没有人可以信任。 | 和一个美女搭档，%name%成功从任何人身上偷到东西。可惜的是，最后，他被那个女人偷了。 | 想卖些东西，结果受信任的销赃商人却成了一个背叛他的线人。在经历一次惨痛的示众之后，盗贼被流放出了%randomtown%。 | 这是一次完美的抢劫。能说的就这么多。现在，%name%只需要保持低调。 | 在一个敌对帮派的折磨下，他失去了很多牙齿和指甲，也失去了重新偷窃的任何动力。 | 他身为盗贼的生涯在他于番茄季节被捕、被示众五天后结束了。 | 自然，没过多久他就进了监狱。他没有谈到他在那里的日子，但很明显他不想再回去了。 | 但有一天，他明白了舞刀弄剑赚钱比小偷小摸厉害多了。 | 但他同父异母的兄弟被当地的一个帮派抓获，迫使这个盗贼寻找新的方法来支付巨额赎金。 | 但是做贼的生活并不容易。他因吃了一只不属于自己的鸡而被捕，他被没收了两根手指，也失去了继续偷窃的意愿。 | 一次劫案发生后，这个男人指认了所有以前的伙伴以自保。现在他再也不能回去偷东西了。}{就你知道的而言，%name%可能只是用雇佣兵的旗号来给自己打掩护。不管他的理由是什么，他还是得赚取自己的酬劳。 | 你在一些招贴画上见过%name%。好吧，一个走了这么远却没被抓住的人一定很有价值。 | %name%一只手在指尖上旋转着一把刀，另一只手掏走了你的钱包。令人印象深刻。现在还我。 | 多年的偷窃使%name%善于逃避麻烦。 | %name%有做一个好佣兵的本事，但在他身边一定要小心自己的钱包。 | 你不能相信像%name%这样的人，但不管怎样，但是这种特质本来就很普遍。 | 据说，曾经有人向%name%射了一箭。没射中，但这个小贼却抓下了箭羽。 | %name%加入佣兵团的努力最好别是从你金库偷东西的一个计划。 | 通缉海报上说%name%被认为是“武装且危险的”。非常好。 | 有很多执法者在找%name%。也许你可以让他们入伙。}";
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
				5,
				8
			],
			RangedDefense = [
				5,
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
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/dagger"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/headscarf"));
		}
	}

});
