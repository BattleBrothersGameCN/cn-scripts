this.deserter_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.deserter";
		this.m.Name = "逃兵";
		this.m.Icon = "ui/backgrounds/background_07.png";
		this.m.BackgroundDescription = "逃兵接受过一些军事训练，但通常不急于将其付诸实践。";
		this.m.GoodEnding = "%name%这位逃兵为了赎回名誉继续为%companyname%战斗。据说，在与兽人的残酷战斗中，他一头扎进了一群绿皮，在他们震惊的头顶上冲浪。他的英勇行为鼓舞了士气获，最终取得了难以置信的胜利，在他的余生中，他每进入一个酒吧都会被敬酒。";
		this.m.BadEnding = "你听说逃兵%name%真的在%companyname%和一些绿皮的战斗中更新了他的头衔并逃跑了。地精在森林中抓住了他，把他的头变成了一个兽人军阀的酒杯。";
		this.m.HiringCost = 85;
		this.m.DailyCost = 11;
		this.m.Excluded = [
			"trait.teamplayer",
			"trait.impatient",
			"trait.clubfooted",
			"trait.fearless",
			"trait.sure_footing",
			"trait.brave",
			"trait.loyal",
			"trait.deathwish",
			"trait.cocky",
			"trait.determined",
			"trait.fragile",
			"trait.optimist",
			"trait.bloodthirsty"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Bravery
		];
		this.m.Titles = [
			"逃兵(the Deserter)",
			"叛徒(Turncloak)",
			"背叛者(the Betrayer)",
			"跑手(the Runner)",
			"狗(the Dog)",
			"蠕虫(the Worm)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.Level = this.Math.rand(1, 2);
		this.m.IsCombatBackground = true;
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
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = "总是满足于充当后备"
			}
		];
	}

	function onBuildDescription()
	{
		return "{%name%曾经是一位领主军队里的一名普通士兵，但在经历了一次又一次的失败后， | %name%曾经是%randomtown%郊区的一个守夜人，他看到他所有的朋友都死于潜伏在那里的野兽。在经受如此多损失后 | 当两位领主为谁拥有当地一个池塘的小问题争吵起来时，%name%被征召来帮助解决这件事。作为一个无名小卒，他的生命显然没有什么价值。在一次屠杀之后， | 在一个领主的职业军队服役时，一种可怕的恶疾降临到了%name%和他的战友身上。由于害怕疾病之威， | 在一次漫长的军事战役中，%name%觉得行军太多，战利品太少。所以}他{把他的武器插在地上离开了。 | 等到了晚上逃离了队伍。 | 还有几个人一起散伙了以示抗议。 | 自愿参加巡逻队，并在第一次巡逻开始时放弃了士兵生涯。}{逃兵被普遍鄙视已经不是什么秘密了 —— %name%一直低着头不让别人看见。 | 大多数逃兵在剩下的日子里都在躲避绞索，%name%也不例外。 | 穿上普通人的外衣，%name%暂时躲过了做逃兵的惩罚。 | 幸运的是，%name%已经，至少到目前为止，没有因罪行而受罚。}{但现在他身无分文，想要回到之前的领域打拼。 | 也许是迫于执法者的逼近，他加入了另一支战斗部队。 | 不幸的是，他不是个聪明人。由于缺乏追求更安全职业的想象力，%name%再次回归战斗。 | 他对在战场上抛弃了他的兄弟感到内疚，现在他为另一支部队而战，寻求救赎。但谁能保证他不会再次逃跑呢？ | 由于借酒忘掉过去耗瘪了钱包，他现在考虑任何谋生的机会。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				-15,
				-10
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				5,
				5
			],
			RangedSkill = [
				7,
				0
			],
			MeleeDefense = [
				3,
				5
			],
			RangedDefense = [
				3,
				5
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
		r = this.Math.rand(1, 4);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/bludgeon"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/militia_spear"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/hatchet"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/weapons/short_bow"));
			items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/shields/wooden_shield"));
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
			items.equip(this.new("scripts/items/armor/gambeson"));
		}

		r = this.Math.rand(0, 5);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/aketon_cap"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/full_aketon_cap"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/open_leather_cap"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.IsContentWithBeingInReserve = true;
	}

});
