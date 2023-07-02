this.lumberjack_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.lumberjack";
		this.m.Name = "伐木工";
		this.m.Icon = "ui/backgrounds/background_04.png";
		this.m.BackgroundDescription = "伐木工习惯于体力劳动。还有斧子。";
		this.m.GoodEnding = "%name%这位魁梧的伐木工最终离开战团回到了森林。他办起了一桩伐木生意，并全年每天运营。幸运的是，时机对他有利：贵族们最近非常“迷恋”小木屋，并向任何能够建造它们的人大量支付克朗。";
		this.m.BadEnding = "%name%这位伐木工已经受够了佣兵的生活，重新开始砍树。你最后听到的消息是，他卷入了一场砍树的意外事故。他的身躯卷成了地毯般，骨头被彻底碾碎了。";
		this.m.HiringCost = 100;
		this.m.DailyCost = 13;
		this.m.Excluded = [
			"trait.weasel",
			"trait.hate_undead",
			"trait.night_blind",
			"trait.ailing",
			"trait.clubfooted",
			"trait.asthmatic",
			"trait.clumsy",
			"trait.fat",
			"trait.craven",
			"trait.fainthearted",
			"trait.bright",
			"trait.bleeder",
			"trait.fragile",
			"trait.tiny"
		];
		this.m.Titles = [
			"结实者(the Sturdy)",
			"砍斧(the Axe)",
			"伐木工(the Woodsman)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
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
		return "作为一个伐木工，%fullname%{大部分时间都用来在树林里砍树 | 靠砍树当柴火赚克朗 | 肩上总是抗着斧头或木头 | 一向是个文静的人，喜欢林中的宁静，而不喜欢与人为伍 | 因其身材魁梧、双手有力而吸引了许多年轻女性的目光 | 总是幻想自己是一名骑士，挥舞着斧头砍的不是树，而是兽人和巨魔}。{他是一个高大强壮的男人，在外面干活对他来说很容易 | 他喜欢他的斧子收藏，每一把斧子都以他认识的一个女人的名字命名 | 他每天都工作得很努力，但这是项诚实的工作 | 在树林里独处时他会和树木交谈，让它们告诉他哪棵树能提供最好的木材 | 很少有人能像他那样挥动斧头，让一棵树就像他想要的那样倒下 | 凭借他高大而结实的体格，他能够背负会压垮其他人的重物}。{像大多数人一样，他继承了他父亲的职业。然而，随着时间的推移，他逐渐意识到，他想从世界上看到更多的东西，而不是每天都待在同一片树林里。经过长时间的深思熟虑，他决定 | 当他深爱的妻子难产而死时，他的生活崩溃了。他的一切都被夺走了，他变得越来越离群索居，即使是树林也不能再给他带来安宁。只是想离开，他决定 | 一天，他从树林里回来，看见远处有烟。他的村庄被烧毁，人们被屠杀或绑架。他的家被毁了。他怒气冲冲地出发，决定 | 随着时间的推移，奇怪的生物开始出现在树林中。一个又一个村民消失了，一些人搬走了。经过一个漫长的不眠之夜，他决定也是时候离开了。由于没有什么可以谋生的，他迫切希望 | 令所有村民感到奇怪的是，随着时间的推移，%name%似乎对森林失去了兴趣，如果他说话的话，他经常会谈起离开这里。在决定命运的一天，他们看到他主动 | 有一天，他砍倒的一棵树砸死了一只鹿。%name%不想浪费它，于是把它带回家，但却发现自己被指控盗猎。在宣判之前，他决定匆忙离开村庄，并试图}加入一个旅行中的佣兵战团。";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				10,
				10
			],
			Bravery = [
				0,
				5
			],
			Stamina = [
				10,
				15
			],
			MeleeSkill = [
				5,
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
			items.equip(this.new("scripts/items/weapons/hand_axe"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/hatchet"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/woodcutters_axe"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 2)
		{
			local item = this.new("scripts/items/armor/linen_tunic");
			item.setVariant(6);
			items.equip(item);
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
	}

});
