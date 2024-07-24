this.deserter_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.deserter";
		this.m.Name = "逃兵";
		this.m.Icon = "ui/backgrounds/background_07.png";
		this.m.BackgroundDescription = "逃兵接受过一些军事训练，但往往不热衷付诸实践。";
		this.m.GoodEnding = "为了挽回名誉，逃兵%name%继续为%companyname%而战。有传言说，在一场激烈战斗中，他一头扎进了兽人堆里，把他们镇住了，在他们头上跳舞。他的英勇行为鼓舞了士气，带来了难以置信的胜利。此后，他走到哪家酒馆都会被敬酒。";
		this.m.BadEnding = "你听说，%name%在一场对绿皮的战斗中逃跑，弃%companyname%而去，从而刷新了他的头衔。一群地精在森林里揪出了他，把他的头做成了酒杯，献给了兽人军阀。";
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
			"狗",
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
		return "{领主军队里的普通士兵，%name%，在经历了一次又一次失败之后， | 作为%randomtown%郊区的卫兵，%name%目睹许多战友被潜藏的野兽杀害。失去了很多朋友 | 两位领主因为池塘归属的小事吵了起来，%name%被征召来摆平这件事。作为一名无名小卒，他的生命显然更没什么价值。一阵厮杀之后， | 在一位领主的职业军队服役时，一场恶疾降临到%name%和他的战友头上。骇于疫病之威， | 在一场漫长的战争中，%name%发觉行军太多，战利品太少。因此}他{把武器插在地上离开了。 | 趁夜色逃离了队伍。 | 和其他几个人一起逃走以示抗议。 | 自愿加入了巡逻队，在第一次巡逻开始时，趁机离开了自己的士兵生涯。}{逃兵遭人鄙视是众所周知的事情，%name%低下头，以免引人注目。 | 大多数逃兵余生都在东躲西藏，%name%也不例外。 | 穿上普通人的外衣，%name%暂时躲开了对逃兵的惩罚。 | 纯粹是运气好%name%至少到目前为止还没有受罚。}{但身无分文，他找机会重操旧业。 | 也许是因为执法者紧紧追随，现在他想加入另一支战斗部队。 | 可惜他不是个聪明人。缺乏对安全职业生活的想象，%name%重回战斗。 | 对抛下同袍兄弟感到愧疚，他在其他战斗队伍中寻找救赎。谁知道他会不会再次逃走呢？ | 钱袋空空，无以借酒消愁，他会考虑任何谋生的机会。}";
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
