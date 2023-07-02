this.farmhand_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.farmhand";
		this.m.Name = "雇农";
		this.m.Icon = "ui/backgrounds/background_09.png";
		this.m.BackgroundDescription = "雇农习惯于艰苦的体力劳动。";
		this.m.GoodEnding = "那个前雇农，%name%，从%companyname%退休了。他把赚来的钱拿来买了一小块地。他的余生都在快乐地务农，组建了一个有很多孩子的家庭。";
		this.m.BadEnding = "那个前雇农，%name%，很快离开了%companyname%。他在{南方 | 北方 | 东方 | 西方}买了一小块地，并取得了不错的成果 —— 直到贵族士兵因他拒绝交出所有收成而将他吊死在树上。";
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
		return "{开垦土地是一份艰苦的活，需要壮汉们洒下血与汗。 | 这片土地上的每一个农场都需要一批吃苦耐劳的人来耕田。 | 人把自己的汗水注入泥土喂养自己，并通过喂饱自己以把自己的汗水注入另一天的泥土里。 | 无论天气如何，农场都需要耕种。 | 猪圈、马厩和没有大门的围栏，这些既是种地人的梦想也是他们的噩梦。 | 虽然有些人通过杀戮谋生，但其他人则注视着脚下，思考土地能够种出哪些庄稼。 | 从养殖者和农夫中产生了一种特殊的男人。坚强、坚决、勤奋。 | 人们如此需要食物，难怪农夫是这片土地上最常见的一种人。 | 农夫讨厌看到自己的土地用血施肥，但现在这种情况越来越普遍了。 | 在战争中，农场是军队的重要目标，不仅是为了获取军队的补给，也是为了从在这些土地上劳作的强壮男人中招募士兵。 | 随着城市的不断扩张和与腹地的疏远，市民们往往会忘记他们的饱腹应该感谢谁。}%name%{是一个身材魁梧、汗流浃背的雇农。 | 他来自%randomtown%的郊区，在那里他开着犁，驯着马。 | 知道好几种雇农能轻松挥动的锄头。 | 在这片土地上众多农场中的一个长大。 | 花了许多年的时间收割喂养这片土地上每个人的庄稼。 | 在一个简陋的农庄里当雇农。 | 在他的船业生意失败后开始务农。 | 为了养活他的十几个孩子和两个妻子成为了一名雇农。 | 选择种田作为填饱肚子的手段。 | 有着适合种植、收获和度过冬天的粗壮体魄。}{不幸的是，没过多久他的农场就遭遇了战争和动乱。 | 但歉收迫使他离开了农场。 | 不幸的是，他的农场是最早在这艰难时期遭到袭击的那一批。 | 然而，即将发生暴乱的消息迫使他放弃了和平的农耕职业。 | 干旱，和以往一样不合时宜，现在迫使他离开了工作。 | 由于没有得到劳动报酬，他最终放弃了农场生活。 | 由于杀戮业务赚得史无前例得多，这个人轻易就放弃了他那杂乱无章的庄稼。 | 有一天，他意识到他强壮的身体用来砍脑袋比挤牛奶更有价值。 | 在掠夺者抢掠了他的庄稼后，他受够了一切，永远离开了农场生活。 | 在天气坏了他的收成之后，这位农民决定选择一个不完全由大自然摆布的职业。 | 传言说他和农场主的女儿睡过觉，所以他没能留在农场这一点让人很吃惊。}{站在你们面前的%name%由谷物喂养长大，是你们所见过的最健壮的人。 | 他想念奶牛，没错，但%name%应该能轻松适应雇佣兵的艰苦生活。 | 在农场长大给了一个人所需的所有营养，%name%当然利用了这一点。 | %name%有一次脸上挨了一脚骡子踢。它的脚断了，他们不得不把那个畜生杀了。 | 如果人是树，那%name%就永远不会倒下。或者类似于这样高雅的说法。 | 别让他单纯的过去愚弄了你，%name%可以和任何摔跤手或打手过招。 | %name%和役畜有很多共同之处。只需给他指条正确的路。 | 从他的体型来看，%name%这辈子吃下的谷物里有不少的肉。 | %name%强壮到可以像挤牛奶一样扭断一个人的脖子。}";
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
