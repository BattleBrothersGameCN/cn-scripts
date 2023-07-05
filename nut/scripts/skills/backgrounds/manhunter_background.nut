this.manhunter_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.manhunter";
		this.m.Name = "猎奴者";
		this.m.Icon = "ui/backgrounds/background_62.png";
		this.m.BackgroundDescription = "猎奴者习惯在南方的恶劣环境中捕猎人口。";
		this.m.GoodEnding = "猎奴者%name%在你离开%companyname%后依然在战团中待了很长一段时日。你对他的新消息了解不多，只知道他在佣兵的世界里找到了比追捕负债者多得多的收入。";
		this.m.BadEnding = "对于他在%companyname%战团的经历感到不满意，猎奴者%name%离开战团并回到了南方。很难说他最终的结局如何，但追踪和猎杀人类猎物的事业带来了无尽的危险。你能得知的与他相关的消息只与他的职业符合：许多负债者起义，许多猎奴者被活埋或喂给了各种栖息在沙漠中的生物。";
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
		return "{南方大量的的奴隶、囚犯、罪犯和负债仆人产生了由卖家、买家以及鉴于该类商品易逃亡的特性 —— 猎奴者组成的经济。 | 南方城邦必须拥有巨大的劳动力储备来推动沙漠经济。虽然许多人生来就为维齐尔不倦地工作，但还有有些人必须被迫过上受奴役的生活。 | 沙漠的自然资源如此稀少，却常常有充足的被捕罪犯和负债者来支撑南方的经济。而捕猎这些未来仆人的业务也非常繁荣。 | 南方的维齐尔们对叛乱如此恐惧，以至于整个搜捕者市场的出现以遏制这种情况的发生。}{%name%带着复仇的态度进入了捕奴的事业：他的全家都在奴隶起义中被屠杀了。 | %name%曾经是一名普通的商队护卫，但后来转而捕捉那些总是试图伏击他商队的游牧民。在人口贸易中发现了更多的利润，他就一直维持着这项事业。 | %name%是一个善于追踪罪犯、逃兵、战俘等角色的猎奴者。你有时会怀疑他是否有能闻到恐惧之汗水的灵敏嗅觉。 | 曾经是一名巨兽猎人的%name%逐渐喜欢上追逐最伟大的猎物：人类。他是一位擅长追踪的专家，能嗅出绝望的气息。}{对于%name%来说，为佣兵战团工作比等待某个急于摆脱束缚的罪犯的活计更为持续稳定。 | %name%是个粗野、阴暗的人，他可能和他曾试图追捕的那些人同样靠不住。 | 像%name%这样的猎人拥有在佣兵团中非常有用的特质和技能，但对一些人来说，他们的过去可能始终存在一丝瑕疵。并非所有猎奴者都被人们看作是好人。 | 对很多人来说，为了劳力而追捕人类是不受赞许的，同样，追捕那些寻求自由的人也是如此。像%name%这样的猎奴者确实拥有有用的技能，但可能会得罪某些人。 | 许多人将%name%这样的人看作是机会主义者毫不奇怪。如果他能在战团中取得成就，改变一些人对他过去的看法可能需要时间。}";
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
