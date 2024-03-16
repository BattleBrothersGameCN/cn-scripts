this.farmhand_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.farmhand";
		this.m.Name = "雇农";
		this.m.Icon = "ui/backgrounds/background_09.png";
		this.m.BackgroundDescription = "雇农习惯于艰苦的体力劳动。";
		this.m.GoodEnding = "前雇农%name%从%companyname%退休了。他拿赚来的钱买了一小块地。他的余生都在快乐地务农，组建了一个有很多孩子的家庭。";
		this.m.BadEnding = "没多久，前雇农%name%就离开了%companyname%。他在{南方 | 北方 | 东方 | 西方}买了一小块地，并取得了不错的收成 —— 直到他拒绝交出所有收成，并因此被贵族士兵绞死。";
		this.m.HiringCost = 90;
		this.m.DailyCost = 10;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.clubfooted",
			"trait.asthmatic"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
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
		return "{开垦土地是一份艰苦的活，需要壮汉们洒下血与汗。 | 这片土地上的每一个农场都需要一批吃苦耐劳的人来耕田。 | 为了喂饱自己，人们把汗水注入泥土，为了把汗水注入泥土，人们又得喂饱自己。 | 无论天气如何，农场都需要耕种。 | 猪圈、马厩和没有大门的围栏，这是种地人的梦想，也是他们的噩梦。 | 有些人通过杀戮谋生，其他人则注视着脚下，思考土地能够种出哪些庄稼。 | 养殖者和农夫的工作孕育出了一些特别的人。坚强、果断、勤奋。 | 人们对食物的需求如此迫切，不会有人对农夫遍地感到奇怪。 | 农夫讨厌用血给土地施肥，但现在这种情况越来越普遍了。 | 在战争中，农场是军队争夺的热点，不仅是为了获取给养，也是为了招募士兵，招募这些面朝黄土的强壮男丁。 | 随着城市的不断扩张，市中心离乡村越来越远，市民往往疏于感谢这些养活他们的人。}%name%{是一个身材魁梧、汗流浃背的雇农。 | 来自%randomtown%的郊区，那是他驾马牵犁的地方。 | 是锄头的行家，知道什么挥着趁手。 | 在这片土地上众多农场中的一个长大。 | 多年来一直在收割庄稼，养活这片土地上的人。 | 在一个简陋的农庄里当雇农。 | 在他的船业生意失败后开始务农。 | 养活着十几个孩子和两个妻子。 | 选择种田来填饱肚子。 | 有着适合种植、收获和过冬的粗壮体魄。}{不幸的是，战争和动乱很快就找上了门。 | 但歉收迫使他离开了农场。 | 不幸的是，他的农场在艰难时期首当其冲。 | 然而，暴乱的消息迫使他放下了耕地的活。 | 干旱总是不合时宜地来，迫使他离开了工作。 | 得不到报酬，他最终还是放弃了农场生活。 | 鉴于杀戮业务赚得史无前例得多，这个人轻易就放弃了他那杂乱无章的庄稼。 | 有一天，他意识到，想要发挥更大的价值，他强壮的身体应该用在砍脑袋上，而不是挤牛奶上。 | 掠袭者抢掠了他的庄稼，他受够了，永远离开了农场生活。 | 天气坏了他的收成，他决定选择一个不完全由大自然摆布的职业。 | 他和农场主的女儿睡过觉的事传的像真的一样，他没能留在农场真是出人意料。}{面前的%name%靠谷物喂大，是你们所见过的最健壮的人。 | %name%的确想念奶牛，但这并不影响他轻松适应佣兵的艰苦生活。 | 农场里有养大一个人用得上的一切，%name%当然利用了这一点。 | %name%有一次脸上挨了一脚骡子踢。它的脚断了，他们不得不把那个畜生杀了。 | 如果人是树，那%name%就永远不会倒下。或者类似于这样高雅的说法。 | 别让他单纯的过去愚弄了你，%name%可以和任何摔跤手或打手过招。 | %name%和役畜有很多共同之处。只需给他指条正确的路。 | 从他的体型来看，%name%这辈子吃下的谷物里有不少的肉。 | %name%强壮到可以像挤牛奶一样扭断一个人的脖子。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				12,
				10
			],
			Bravery = [
				-2,
				-3
			],
			Stamina = [
				10,
				20
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
		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/pitchfork"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/wooden_flail"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else
		{
			local item = this.new("scripts/items/armor/linen_tunic");
			item.setVariant(this.Math.rand(6, 7));
			items.equip(item);
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/straw_hat"));
		}
	}

});
