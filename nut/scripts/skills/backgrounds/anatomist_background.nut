this.anatomist_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.anatomist";
		this.m.Name = "解剖学家";
		this.m.Icon = "ui/backgrounds/background_70.png";
		this.m.BackgroundDescription = "介于科学家和外科医生之间，解剖学家不习惯于战斗，却有着一双沉稳的双手。";
		this.m.GoodEnding = "所有你在%companyname%认识的人中，解剖学家%name%或许是最难忘的一个。源源不断的来信更是让你深信不疑。你粗读了他最新的单向通讯：“队长！我已经成功地……”略过，略过，“……最伟大的发明！最……”略过，略过，“我将会出名！我的大脑会被研究，它的重量……”没有什么新鲜的，不过你很高兴他仍然健康，尽管身体比精神健康得多。";
		this.m.BadEnding = "逃离%companyname%后，解剖学家%name%在其他地方继续他的研究。他因不修边幅的研究方式饱受同行谴责，又发觉自己在智力上并无过人之处。过了几年，在为甲虫研究做出一些微小贡献之后，他立即跳下了海边的悬崖，把自己的大脑捐献给了岩石，身体则归于海洋。";
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
			"秃鹫",
			"乌鸦",
			"判官",
			"殡葬业者",
			"送葬者",
			"阴郁者",
			"解剖学家",
			"好奇者",
			"被污染者"
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
		return "{%name%是个敏锐的人，长期激烈的实验毁伤了他的皮肤。你希望他的方法论能更好地用在敌人而不是自己身上。 | 关于%name%的传言表明，他试图解开飞行的奥秘。不是用机器，而是长翅膀。他具体怎么打算，实验结果如何，都不得而知。不过，现在他脚踏实地，环顾四周，肩头也没有异样。 | 像许多解剖学家一样，%name%独自闯荡世界。不过，饥饿感才不管什么科学头脑，照样吞噬了他。现在，他将和雇佣兵一起战斗，哪怕只为了争取更多的研究时间。 | %name%慨叹世事不公，一些同龄人可以全身心接受教育，他却必须挣钱来支持学业。希望他的愤怒能表现在战场上。 | %name%这样的人更适合在战斗之后出现，而不是实质参与其中。老实说，如果这么聪明独特的人都要当佣兵赚钱，或许这个世界比你认识的还要糟糕。 | %name%的智商难以言喻。他极其聪明，聪明到了让你怀疑上天为什么要给你脑子的程度。但就佣兵而言，他不过是一名新战士。希望他的武艺和他的智慧一样高超。 | 你总是搞不清楚，是困难时期迫使%name%成为佣兵，还是他纯粹想用残酷的方式追求科学探究。他整晚都在解剖马车碾死的狗和没有翅膀的蝴蝶，这让你对这位好奇的家伙有很多疑问。 | 好奇心，而不是金钱，驱使%name%当起了佣兵，他热衷于发现世界上的生物，探索他们的内部构造。反正都开膛破肚了，你也没有什么好担心的。}";
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
