this.beggar_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.beggar";
		this.m.Name = "乞丐";
		this.m.Icon = "ui/backgrounds/background_18.png";
		this.m.BackgroundDescription = "乞丐可说不上有什么决心，流落街头也损害了他们的健康。";
		this.m.GoodEnding = "厌倦了打打杀杀，曾经的乞丐%name%从%companyname%退休了。据你所知，他在战团里赚了不少钱，可是前几天，你又看到他在乞讨。你问他是不是把钱挥霍光了，他大笑道他买了块地并且过得很好。然后他拿出他的小罐子，讨要一枚克朗。你给了他俩。";
		this.m.BadEnding = "战斗生活充满艰辛，曾经的乞丐%name%趁它还没变得要命，选择了退役。可怜他只能靠乞讨过活。传言初冬时节，有位贵族清理了城中的无赖，把他们送往了北方。饥寒交迫的%name%死在路边，手指上还冻着他的小钱罐儿。";
		this.m.HiringCost = 30;
		this.m.DailyCost = 3;
		this.m.Excluded = [
			"trait.iron_jaw",
			"trait.tough",
			"trait.strong",
			"trait.cocky",
			"trait.fat",
			"trait.bright",
			"trait.fearless",
			"trait.brave",
			"trait.determined",
			"trait.deathwish",
			"trait.greedy",
			"trait.athletic"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Bravery
		];
		this.m.Titles = [
			"肮脏之人(the Dirty)",
			"穷光蛋",
			"衣衫褴褛者(the Ragged)",
			"病秧子",
			"骗子",
			"无业游民",
			"懒汉",
			"白吃饱",
			"要饭的",
			"黄鼠狼",
			"臭鼬",
			"懒蛋",
			"流浪汉"
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
		return "{一场大火夺走了一切 | 被赌瘾压垮了理智 | 被安上了从没犯过的罪，只得破财以免牢狱之灾 | 村庄被一场火烧成了白地 | 因兄弟不和被逐出家门 | 既没才能又没野心 | 无数年的牢狱生活终于重见天日 | 为了所谓的灵魂救赎把财产全数交给了邪教 | 强盗敲坏了他的聪明头脑}，{回过神来，%name%已然流落街头， | %name%被迫流落街头，}{为填饱肚子沿街乞讨 | 靠别人的善意苟且偷生 | 时常挨打并开始听天由命 | 把仅有的一点钱用来借酒消愁 | 躲避治安官的驱逐和追捕，在垃圾堆里刨食 | 讨钱的同时还得躲避流氓}。{看起来他真心成为一名雇佣兵，但街头的日子无疑消磨了%name%最好的年华。 | 这么多年过去，到今天他的健康已经受损。 | 对于像%name%这样在街上待了几天，更别说是几年的人来说，极其危险的佣兵工作他也能甘之如饴。 | 只有神知道%name%为了生存都经历了什么，你只知道，站在你面前的不过是一个瘦弱的人 | 他一看到你就张开双臂走了过来，说你是他多次一起冒险过的老熟人，不过他这会儿还想不起你的名字。}";
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
				-10,
				-10
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

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local dirt = actor.getSprite("dirt");
		dirt.Visible = true;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			local item = this.new("scripts/items/helmets/hood");
			item.setVariant(38);
			items.equip(item);
		}
	}

});
