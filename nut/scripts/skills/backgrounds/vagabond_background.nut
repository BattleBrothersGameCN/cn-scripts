this.vagabond_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.vagabond";
		this.m.Name = "流民";
		this.m.Icon = "ui/backgrounds/background_32.png";
		this.m.BackgroundDescription = "流民惯于长途旅行，没有什么具体特长";
		this.m.GoodEnding = "有些人注定要漂泊。虽然与%companyname%在一起的时光很愉快，但流民%name%最终还是离开了战团，重新踏上了漫漫征程。你不知道他去了哪里，只知道他对旅行充满了兴趣。";
		this.m.BadEnding = "随着战团分崩离析，流民%name%会选择离开战团重新上路并不奇怪。不幸的是，由于世道艰辛，他很快就遇到了麻烦。他的尸体在一个小村外被发现。被挂在树上的他胸前钉着一块牌子，上面写着:“流浪汉勿入”。";
		this.m.HiringCost = 70;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.hate_beasts",
			"trait.hate_undead",
			"trait.hate_greenskins",
			"trait.clubfooted",
			"trait.fat",
			"trait.loyal",
			"trait.gluttonous",
			"trait.asthmatic"
		];
		this.m.Titles = [
			"流民",
			"流浪者(the Wanderer)",
			"三只脚(Threefeet)",
			"背包客(Bindlestiff)",
			"褴褛汉(Tatterdemalion)",
			"流浪汉",
			"不得安歇者(the Restless)",
			"旅行者(the Traveller)",
			"乌鸦(the Raven)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
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
		return "{%name%被战争赶出了家乡，在世界各地流浪。 | 懒惰而缺乏动力，%name%打包上自己仅有的三件东西就上路了。 | %name%在学校里学得不好，于是退学去流浪了。 | %name%没有商业头脑来保护他的遗产不受债务人、执法者和其他坏人的侵害。现在他正带着口袋里最后一枚叮当作响的克朗四处游荡。 | 路上的生活把%name%教成了一个什么都懂点，但什么都不精通的人 —— 当然，除了走路。 | 既不太喜欢城市，也不太喜欢荒野，%name%在这两者之间漫无目的地游荡度日。 | 在酗酒的日子里，%name%成功靠赌博输掉了一笔可观的财富。现在他无家可归，只是漫游街头。 | 他的妻子在他外出时被杀，从此%name%拒绝回到自己的家。这个人走遍四方，试图忘却。 | 他儿子杀了五个人。羞愧难当，%name%背井离乡独自流浪四方，希望忘记自己作为一个父亲的失败。}{但是当一帮小偷偷走了他所有的东西 —— 包括他的鞋子后 —— 他明白他需要再改变一次。 | 但是当他走到一条字面意义上的岔路口时，这个人意识到他已经有一段时间没有吃东西了。他的胃要求换个场所 —— 以及饮食。 | 可悲的是，对于那些没人挂念的人来说，这个世界不是一个愉快的地方。他每天都受到骚扰和欺负。 | 在泥泞中艰难跋涉了一天之后，他意识到漫无目的地四处走动是毫无意义的。 | 奇怪的是，有一天他遇见了自己早已遗忘的“他从未拥有过的兄弟”，那个人告诉他一个佣兵团需要人干那种长途跋涉的活计 —— 而且他们还愿意为此付钱！ | 就像任何一个冲动的好男人一样，他抛硬币来决定是否要尝试从事佣兵工作。}{他什么都不是特别擅长，但%name%已经见识和经历了很多事情，这至少有点价值。 | 在这片暴力的土地上游荡，四肢健全地生存下来，这已经强过了不少普通人。 | 对于%name%这样的流浪汉来说，加入佣兵团不过是又一次冒险，但愿他能活着把这些故事写下来。 | 他旅行时唯一的武器就是一根拐杖。让我们看看他如何处理稍微尖锐一点的东西。 |小偷、恶棍、面包师、裁缝，%name%什么都干过。可惜他从来都做不到擅长某件事情。也许这次会有所不同。 | 多年来，世界对%name%一直很苛刻。这不会改变，但至少他现在和兄弟们在一起了。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-3,
				0
			],
			Bravery = [
				-5,
				-7
			],
			Stamina = [
				10,
				15
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
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
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
