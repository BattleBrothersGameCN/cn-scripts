this.slave_southern_background <- this.inherit("scripts/skills/backgrounds/slave_background", {
	m = {},
	function create()
	{
		this.slave_background.create();
		this.m.GoodEnding = "你以极少的金币将%name%买作战团负债者并继续支付他“奴隶工资”作为佣兵报酬。他确实把自己塑造成了一名不错的战士，毫无疑问，他相信自己最好是无薪但奋战以生存，而不是无薪并放弃以堕落。在你离开之后，你听说%companyname%前往南方进行了一次战役，并且负债者得到了一个向他过去一些敌人复仇的好机会。幸运的是，尽管你也奴役过他，但他没把你算在那伙人中。";
		this.m.BadEnding = "你将%name%买作战团的负债者，且在你退出后，他继续留在%companyname%的队伍里。这个雇佣兵团的问题的消息已经逐渐传开，但目前这个负债者的状况却杳无音讯。考虑到这个世界的运作方式，他可能被放在最前线充当炮灰，或者甚至被出售以回收利润。不管怎么说，这个世界上佣兵还是负债者都不轻松，而这个人不幸两者都是。";
		this.m.Bodies = this.Const.Bodies.SouthernSlave;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.SouthernUntidy;
		this.m.BeardChance = 90;
		this.m.Ethnicity = 1;
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
		this.m.Titles = [
			"受奴役者(the Enslaved)",
			"囚犯(the Prisoner)",
			"倒霉蛋(the Unlucky)",
			"负债者(the Indebted)",
			"负债者(the Indebted)",
			"负债者(the Indebted)",
			"不自由者(the Unfree)",
			"罪犯(the Criminal)",
			"顺从者(the Obedient)",
			"受铐者(the Shackled)",
			"被缚者(the Bound)"
		];
	}

	function onBuildDescription()
	{
		return "{许多南方城邦都建立在战俘、罪犯和负债者可牺牲的尸体上，这些人蔑视了镀金者或他的追随者，必须通过努力工作来“赚取”救赎。%name%就是这样一个不幸的灵魂。}{令人震惊的是，大多数奴隶并非天生就是被追猎的对象，%name%正是大多数之一。在游牧民伏击他的商队之前，他是一名旅行商人。游牧民把他带到一个维齐尔那里，谎称他是罪犯，然后把他作为猎物出售。 | 因其英俊的外表而被盯上，%name%在%randomcitystate%的街道上被绑架，然后直接卖给了一个善于操控的维齐尔。他没有提及自己的所有经历，但感觉他并非只做体力劳动。 | %name%先祖们的宗教罪行大到了他生下来就得做负债者的地步，不知道要往上翻多少辈才能找到一个自由人。 | %name%不顾一切地想把他的家庭从世代的债务中拯救出来，于是他把自己卖作契约奴隶，以确保他的妻子和孩子们有自己的生活。 | %name%发誓他是北方人，但是南方的沙漠让他晒得黝黑，坦白说，你没有理由相信一个前战俘的话，不管他来自哪里。 | %name%曾经是一名海员，多年来一直从事划桨的活计，为富裕的商人在港口间运送货物。把他交给你的人说他有海盗犯罪的前科。 | %name%被指控强暴一位老妇人，并被判死刑或终身奴役。 | %name%在水果摊偷东西被抓住，被迫服终身奴役。 | 与“非女性”的通奸导致%name%依城邦法被奴役。他只能在服刑或做阉人之间做出选择，他选择苦力也是自然而然的了。}{他生活的离奇艰辛，可以作为塑造一个合适的雇佣兵的绝佳素材。 | 他遭受的奴役无疑使他的外表令人生畏，但很难说他在成为实际上的契约佣兵这件事上的想法如何。 | 在南方城市，奴隶战士很常见，%name%可能会成为一个有用的，尽管还是奴隶的佣兵。 | 你希望%name%能够成为一个卓越的佣兵，但你有一种感觉，他最优先忠诚的是任何人都渴望品尝的东西：自由。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-10,
				-10
			],
			Bravery = [
				-10,
				-5
			],
			Stamina = [
				5,
				5
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
				-5,
				-5
			]
		};
		return c;
	}

});
