this.adventurous_noble_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.adventurous_noble";
		this.m.Name = "爱冒险的贵族";
		this.m.Icon = "ui/backgrounds/background_06.png";
		this.m.BackgroundDescription = "爱冒险的贵族往往有很高的决心和近战技能，但往往不重视远程防御。";
		this.m.GoodEnding = "冒险的精神从不离开像%name%这样的男人的灵魂。{离开%companyname%后，他没有回他的贵族家庭而是向东寻找稀有野兽。有传言说他带着一个看起来像巨型蜥蜴的头回到了镇上，但你不会相信这种荒诞的说法。 | 他离开了%companyname%，向西冒险，穿越海洋到达未知的土地。现在谁也不知道他在哪里，但你毫不怀疑他一定会带着故事回来。 | 他从%companyname%退休，但并没有回到他的贵族家庭，而是向南方前往。有传言说他参加了一场伟大的贵族内战，杀死了一个兽人军阀，爬上了这片土地上最高的山峰，目前正在写一部关于他的旅行的史诗。 | 这个贵族离开了%companyname%，选择了冒险而非无聊的贵族生活，向北方前进。有传言说他正在领着一队探险家前往世界的最远处。}";
		this.m.BadEnding = "%name%离开了%companyname%并到别处继续他的冒险旅程。{他向东走去，希望发现绿皮的来源，但自那以后就再也没有听到这位贵族的消息。 | 他向北走进入了白雪皑皑的荒原。有传言说，一周前有人看见他向南行军，这一次他脸色苍白、步履蹒跚。 | 他向南走入了残酷的沼泽地。有传言说迷雾中出现了神秘的火焰，他走向它后就不见了。看到这个场面的人说他消失在雾中，再也没有回来。 | 他向西航行前往远洋。尽管没有海上经验，但他自以为有资格成为船长。据说他那船的残骸和死去水手的尸体在数周内被接连不断地冲上岸来。}";
		this.m.HiringCost = 150;
		this.m.DailyCost = 25;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_beasts",
			"trait.clubfooted",
			"trait.irrational",
			"trait.hesitant",
			"trait.drunkard",
			"trait.fainthearted",
			"trait.craven",
			"trait.dastard",
			"trait.fragile",
			"trait.insecure",
			"trait.asthmatic",
			"trait.spartan"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Names = this.Const.Strings.KnightNames;
		this.m.Level = this.Math.rand(1, 3);
		this.m.IsCombatBackground = true;
		this.m.IsNoble = true;
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
		return "{作为一个小贵族 | 作为第三顺位继承人 | 作为一位年轻而傲慢的贵族 | 作为一位熟练的剑客}，%name%的宫廷生活{对他来说已经不新鲜了 | 充斥着宫廷礼仪和家族血统课程，这令他倍感无聊 | 感觉像是在浪费他生命中最美好的时光 | 远没有那些故事中的冒险、战役、等待征服的野兽和少女那样激动人心}。{骄傲地戴着家族徽章 | 在他哥哥的鼓励下 | 令他母亲沮丧的是 | 终于做出了改变的决定}，%name%踏上旅途，打算{去证明自己 | 去打出一片名声 | 去在战场上赢得荣耀 | 去在战斗中测试他的技能}，期待能{像他在城堡墙后想象的那样，尽情享受生活 | 看遍世界上所有的奇观和异域 | 赢得他在世界上的地位 | 因英勇而被封为爵士 | 受到全世界人的了解和喜爱 | 在全世界树立威名}。";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				15,
				20
			],
			Stamina = [
				0,
				5
			],
			MeleeSkill = [
				10,
				10
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
				-10,
				-5
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
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/arming_sword"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/winged_mace"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/hand_axe"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/shields/heater_shield"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/shields/kite_shield"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/mail_shirt"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/basic_mail_shirt"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/mail_hauberk"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/nasal_helmet"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/padded_nasal_helmet"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/nasal_helmet_with_mail"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/mail_coif"));
		}
	}

});
