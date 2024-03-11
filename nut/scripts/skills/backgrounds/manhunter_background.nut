this.manhunter_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.manhunter";
		this.m.Name = "猎奴者";
		this.m.Icon = "ui/backgrounds/background_62.png";
		this.m.BackgroundDescription = "猎奴者习惯在南方的恶劣环境中捕猎人口。";
		this.m.GoodEnding = "在你离开%companyname%后，猎奴者%name%依然呆在战团里。你对他的近况了解不多，只知道他当佣兵远比追捕负债者赚钱。";
		this.m.BadEnding = "不满在%companyname%虚度光阴，猎奴者%name%不辞而别，回到了南方。很难说他后来怎么样了，但追猎人类本就伴随着无数的风险。你只知道他们这一行的消息：许多负债者起义，而那些猎奴者要么被活埋，要么给沙漠中的生物当了饲料。";
		this.m.HiringCost = 120;
		this.m.DailyCost = 10;
		this.m.Excluded = [
			"trait.bleeder",
			"trait.bright",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.iron_lungs",
			"trait.tiny",
			"trait.optimist",
			"trait.dastard",
			"trait.asthmatic",
			"trait.craven",
			"trait.insecure",
			"trait.short_sighted"
		];
		this.m.Titles = [
			"猎奴者(the Manhunter)",
			"猎人者(the Mancatcher)",
			"猎人(the Hunter)",
			"无情者(the Ruthless)",
			"赏金猎人(the Bounty Hunter)",
			"凶残者(the Brutal)",
			"残酷者(the Cruel)",
			"无慈悲者(the Unforgiving)",
			"无情者(the Merciless)",
			"追踪者(the Tracker)",
			"捕手(the Catcher)",
			"无心者(the Heartless)",
			"猪人(the Swine)",
			"奴隶贩子(the Slaver)"
		];
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.BeardChance = 90;
		this.m.Bodies = this.Const.Bodies.SouthernThick;
		this.m.Ethnicity = 1;
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
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
		return "{南方大量的的奴隶、囚犯、罪犯和负债仆人产生了由卖家、买家以及负责追捕逃亡商品的猎奴者组成的经济。 | 南方城邦发展沙漠经济离不开巨量的劳动力储备。许多人生来就为维齐尔不倦地工作，还有些人需要别人逼他们一把。 | 沙漠的自然资源相当稀少，往往靠大量罪犯和负债者来支撑经济。而捕猎这些劳动力的业务也非常繁荣。 | 所谓防患于未然，鉴于南方的维齐尔对叛乱极度恐惧，猎奴者市场应运而生。}{%name%进入捕奴的事业是为了复仇：他的全家都因奴隶起义而死。 | %name%曾经是一名普通的商队护卫，因为商队是被游牧民伏击，他转而追猎他们。而鉴于买卖人口更加赚钱，他就一直干了下去。 | 猎奴者%name%善于追踪罪犯、逃兵和战俘。你时常怀疑他是否能闻到恐惧的汗味。 | 前巨兽猎人%name%找到了最棒的猎物——人类。他是追踪的专家，能嗅出绝望的气息。}{%name%觉得，当佣兵比抓犯人稳定多了，不用等那戴着链子哆嗦的人。 | %name%是个粗野、阴暗的人，可能和他抓过那些人一样善变。 | 像%name%这样的猎人都有些能在佣兵团里派上用场的本事，但对一些人来说，他们的过去是种污点。并非所有猎奴者都是好人。 | 对很多人来说，抓人来干活不是什么好事，剥夺别人的自由也是如此。像%name%这样的猎奴者当然有些本事，但可能会让一些人感到不快。 | 许多人认为%name%不过是风口上的猪。如果他能在战团中取得成就，也许能渐渐改变一些人对他的看法。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				2,
				3
			],
			Bravery = [
				7,
				5
			],
			Stamina = [
				3,
				5
			],
			MeleeSkill = [
				5,
				5
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				2,
				2
			],
			RangedDefense = [
				-1,
				-1
			],
			Initiative = [
				3,
				5
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/battle_whip"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/bludgeon"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/oriental/saif"));
		}

		items.equip(this.new("scripts/items/tools/throwing_net"));
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/oriental/nomad_robe"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/oriental/thick_nomad_robe"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/oriental/southern_head_wrap"));
		}
	}

});
