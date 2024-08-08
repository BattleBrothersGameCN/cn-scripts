this.adventurous_noble_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.adventurous_noble";
		this.m.Name = "冒险贵族";
		this.m.Icon = "ui/backgrounds/background_06.png";
		this.m.BackgroundDescription = "冒险贵族往往有较高的决心和近战技能，忽视远程防御。";
		this.m.GoodEnding = "冒险精神是%name%的一部分。{离开%companyname%之后，他没有回到家族，而是向东进发，寻找奇珍异兽。传说他带着个超大号蜥蜴头回到了镇上，但你不相信这种天方夜谭。 | 他离开了%companyname%，向西冒险，穿过海洋，前往未知的土地，没人知道他现在何处，但毫无疑问，他会满载着故事回来。 | 他从%companyname%退休，但并没有回到他的家族，而是去了南方。传说他参加了一场宏大的贵族内战，杀死了一名兽人军阀，爬上了最高的山峰，正在写一部记录他旅行的史诗。 | 这名贵族离开%companyname%之后，选择了冒险，而非无聊的贵族生活，向北方启程。传说他正在领着一支探险队前往世界的尽头。}";
		this.m.BadEnding = "%name%离开了%companyname%，继续他的冒险旅程。{他向东进发，希望发现绿皮的来源，但那自以后，他音信全无。 | 他走向北方的皑皑雪原。据说一周前，有人看见他向南折返，脸色苍白、步履蹒跚。 | 他向南行进，走入了严酷的沼泽。据说，他走向了雾中出现的神秘火焰。目击者说他消失在雾中，再也没有回来。 | 他向西航行，前往远洋。尽管没有海上经验，他还是自封为船长。据说此后几周，尸体和船只碎片源源不断地被冲上岸。}";
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
		return "对于{作为小贵族 | 作为第三顺位继承人 | 年轻而傲慢 | 精于剑术}的%name%来说，宫廷生活{已经不新鲜了 | 充斥着无聊的礼仪和血统课程 | 是在浪费他生命中最美好的时光 | 远没有那些故事里的冒险、战役、等待征服的野兽和少女那样激动人心}。{骄傲地戴着家族徽章 | 在他哥哥的鼓励下 | 令他母亲沮丧的是 | 终于做出了改变的决定}，%name%踏上旅途，打算{去证明自己 | 去打出一片名声 | 去在战场上赢得荣耀 | 在实战中检验自己的技能}，期待能{像他在城堡墙后想象的那样，尽情享受生活 | 看遍世界上所有的奇观和异域 | 赢得他在世界上的地位 | 因英勇而被封为爵士 | 受到全世界人的了解和喜爱 | 在全世界树立威名}。";
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
