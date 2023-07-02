this.anatomist_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.anatomist";
		this.m.Name = "解剖学家";
		this.m.Icon = "ui/backgrounds/background_70.png";
		this.m.BackgroundDescription = "解剖学家既是科学家又是外科医生，他们不习惯于战斗，但他们的手很稳。";
		this.m.GoodEnding = "在%companyname%里你所认识的所有人中，解剖学家%name%可能是最令人难忘的一个。他不停的来信更是令你永远不会忘记他。你浏览了他最新的单向通讯：“队长！我已经成功地……”浏览中，浏览中，“……最伟大的发明！最……”浏览中，浏览中，“我将会出名！我的大脑会被研究，其重量……”似乎没有什么新内容，不过你很高兴他仍然健康，尽管可能身体会比精神更健康些。";
		this.m.BadEnding = "离开%companyname%后，解剖学家%name%在其他地方继续进行他的研究。他因为以这种粗鲁的方式冒险而受到同行们的谴责，并发现自己在知识领域变得平庸。几年后，他在为研究甲虫做出一些微小贡献之后，立即跳下了海边的悬崖，把自己的大脑捐献给了岩石，身体则归于海洋。";
		this.m.HiringCost = 130;
		this.m.DailyCost = 12;
		this.m.Excluded = [
			"trait.ailing",
			"trait.asthmatic",
			"trait.bleeder",
			"trait.craven",
			"trait.huge",
			"trait.determined",
			"trait.fear_beasts",
			"trait.hate_beasts",
			"trait.fear_greenskins",
			"trait.hate_greenskins",
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.teamplayer",
			"trait.impatient",
			"trait.clumsy",
			"trait.iron_jaw",
			"trait.dumb",
			"trait.athletic",
			"trait.brute",
			"trait.fragile",
			"trait.iron_lungs",
			"trait.irrational",
			"trait.cocky",
			"trait.strong",
			"trait.tough",
			"trait.superstitious"
		];
		this.m.Titles = [
			"秃鹫(the Curious)",
			"乌鸦(The Crow)",
			"治安官(the Magistrate)",
			"殡葬业者(the Mortician)",
			"葬礼承办人(the Undertaker)",
			"阴郁者(the Grim)",
			"解剖学家(the Anatomist)",
			"好奇者(the Curious)",
			"被污染者(the Tainted)"
		];
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
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
		return "{%name%是一位精明的男子，但因为经常进行激烈的测试而皮肤状态很糟糕。你希望他的方法论能够更好地应用于他的敌人，而不是他自己。 | 关于%name%的传言表明他试图弄清楚如何飞行。不是靠机器，而是靠长翅膀。他究竟打算怎么做，以及他的实验结果如何，都不得而知。然而，现在他非常精明地站在地面上，时不时环顾四周。 | 像许多解剖学家一样，%name%独自进入了这个世界。当然，也像许多人一样，他很快就被那些对科学毫无意义的人的饥饿感所吞噬。现在，他将和雇佣兵一起战斗，哪怕只是为了给自己争取更多的时间来真正完成研究。 | %name%愤世嫉俗，对他的一些同龄人能得到充分的教育而他却必须挣钱来支持他学业的现状感到不满。希望他的愤怒能在战场上表现出来。 | 一个像%name%这样的人似乎更适合在战斗之后出现，而不是实质参与其中。事实上，一个如此聪明但又古怪的人仍需要雇佣兵的收入，这让你开始怀疑自己在这个世界上的前途是否比你之前意识到的更加糟糕。 | %name%的智商难以言喻。他是一个极其聪明的人，他的聪明才智会让你怀疑神为什么要赐予你思想，如果它只是如此微不足道。但就佣兵而言，他不过是另一名战士。希望他的武艺和他的智慧一样敏锐。 | 你永远无法确定是艰难时期迫使%name%成为佣兵，还是他仅仅是通过另一种更残酷的方式追求科学探究。他把晚上用在解剖被马车碾死的狗和没有翅膀的蝴蝶，这让你对这位好奇的家伙有很多疑问。 | 好奇心，而不是金钱，驱使%name%进入了佣兵的行列，他对探索世界上的生物以及它们内部长什么有着浓厚的兴趣。只要他能把这些内部结构展现出来，你就无所谓他拿这些去做什么其他的事情。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-4,
				-4
			],
			Bravery = [
				10,
				10
			],
			Stamina = [
				0,
				-5
			],
			MeleeSkill = [
				7,
				7
			],
			RangedSkill = [
				9,
				9
			],
			MeleeDefense = [
				1,
				0
			],
			RangedDefense = [
				1,
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
		else if (r <= 2)
		{
			items.equip(this.new("scripts/items/weapons/dagger"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/butchers_cleaver"));
		}

		r = this.Math.rand(0, 5);

		if (r < 3)
		{
			items.equip(this.new("scripts/items/armor/undertaker_apron"));
		}
		else if (r < 5)
		{
			items.equip(this.new("scripts/items/armor/wanderers_coat"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/armor/reinforced_leather_tunic"));
		}

		r = this.Math.rand(0, 5);

		if (r < 3)
		{
			items.equip(this.new("scripts/items/helmets/undertaker_hat"));
		}
		else if (r < 5)
		{
			items.equip(this.new("scripts/items/helmets/physician_mask"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/helmets/masked_kettle_helmet"));
		}
	}

});
