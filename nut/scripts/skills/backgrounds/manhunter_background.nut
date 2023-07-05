this.manhunter_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.manhunter";
		this.m.Name = "猎奴者";
		this.m.Icon = "ui/backgrounds/background_62.png";
		this.m.BackgroundDescription = "猎奴者习惯在南方的恶劣环境中捕猎人口。";
		this.m.GoodEnding = "猎奴者%name%在你离开 %companyname% 后和战团待了很长一段时间。你没有听说这个人的消息，除了他在佣兵世界中找到了比追债更多的收入。";
		this.m.BadEnding = "对于他在%companyname%战团的经历感到不满意，猎奴者%name%离开了战团，回到了南方。很难说他最终的结局如何，但追踪和猎杀人类猎物的事业充满了无尽的危险。你唯一收到过他的消息是与他职业相关联的：许多猎奴者被埋在地下或被喂给各种生活在沙漠中的恶兽。";
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
		return "{南方大量的奴隶、囚犯、罪犯和负债的雇工造就了一个由卖家、买家考虑产品的轻浮特性还有猎人组成的经济模式。 | 南方城邦必须拥有巨大的劳动力储备来推动沙漠经济。 虽然许多人生来就为维齐尔不倦地工作，但还有有些人必须被迫过上奴役的生活。 | 自然资源如此稀少的沙漠，往往有充足的被俘罪犯和负债累累的灵魂来支撑南方经济。 而捕猎这些最终将会成为仆人的家伙们的事业非常繁荣。 | 南方维齐尔对叛乱如此恐惧，以至于整个搜捕者市场出现了，来把他们扼杀在萌芽状态。} {%name% 带着复仇的态度进入了追捕奴隶的事业：他的家人都在奴隶起义中被屠杀。 | %name% 曾经是一名普通的商队护卫，但后来转而追捕那些试图伏击他的商队的游牧民族。 在人口贸易中发现了更多的利润，他就一直坚持干下去了。 | %name% 是一个善于追踪罪犯、逃兵、战俘等等的搜捕者。 你有时会怀疑他是否有灵敏的嗅觉，能闻到惊恐的冷汗。 | 曾经是一个王牌猎手，%name% 逐渐喜欢追逐最伟大的游戏：人。 他是一个寻踪专家，有嗅出绝望气息的鼻子。} {对于 %name% 来说，选择为一个佣兵团工作意味着更稳定的工作，不用空等那些对他手中的锁链感到不安的罪犯。 | %name% 是个粗野、阴暗的人，很可能他和他要追捕的人一样轻浮。 | 像 %name% 这样的猎人拥有在佣兵团中能派上用场的特质和技能，但对某些人来说，他们的过去可能永远会遭到蔑视。 并不是所有的搜捕者都被看好。 | 许多人不赞成出于需要劳动力去抓捕人类，同样也反对抓捕那些追求自由的人。 像 %name% 这样的搜捕者当然拥有有用的技能，但可能会弄错一些。 | 毫不奇怪，许多人认为像 %name% 这样的人是信奉机会主义的懒虫。 如果他要与战团合作，也许需要画点时间来改变一些人对他的过去的看法。}";
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
