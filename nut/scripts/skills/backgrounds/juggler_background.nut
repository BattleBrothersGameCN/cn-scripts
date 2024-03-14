this.juggler_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.juggler";
		this.m.Name = "杂耍者";
		this.m.Icon = "ui/backgrounds/background_14.png";
		this.m.BackgroundDescription = "杂耍者需要有良好的反应能力和手眼协调能力。";
		this.m.GoodEnding = "杂耍者%name%用当佣兵挣来的钱成立了一个巡回剧团。上次你听说，他建了一整座剧院，每个月推出一部新剧！";
		this.m.BadEnding = "杂耍者%name%退出了战斗。相传他曾在{南部地区 | 北部地区 | 东部地区 | 西部地区}为一个艳俗的贵族表演，结果某个节目出了大差错。他因这个失误被扔下塔楼，但你不肯相信。";
		this.m.HiringCost = 75;
		this.m.DailyCost = 7;
		this.m.Excluded = [
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.clubfooted",
			"trait.brute",
			"trait.clumsy",
			"trait.tough",
			"trait.strong",
			"trait.short_sighted",
			"trait.dumb",
			"trait.hesitant",
			"trait.deathwish",
			"trait.insecure",
			"trait.asthmatic",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"杂耍者(the Juggler)",
			"小丑(the Jester)",
			"愚者(the Fool)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
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
			},
			{
				id = 15,
				type = "text",
				icon = "ui/icons/chance_to_hit_head.png",
				text = "更高几率击中头部"
			}
		];
	}

	function onBuildDescription()
	{
		return "{有了后哥的指导，%name%学杂耍如水手学划桨。 | 同龄人的嘲笑也改变不了%name%对杂耍的钟爱。 | 正赶上小丑剧团巡演，%name%迷上了其中一位杂耍者，并拜他为师。 | 当地一位贵族的儿子，%name%，迷上了杂耍和娱乐。这种不合时宜的痴迷让他被赶了出来。 | %name%不是为了杂耍而杂耍，而是为了观众的笑声和掌声。}{不幸的是，战争肆虐了这片土地，已经没有什么可以娱乐的人了。 | 但在这片苦难和惨剧的土地上，客人和克朗都是稀有资源。 | 一场涉及锛子和皇室婴儿的表演事故让他亡命天涯。 | 过于擅长翻弄剑和匕首的他被指在表演中使用巫术，并被迫离开他钟爱的事业。 | 可悲的是，%name%的杂耍技艺引来了同行的嫉妒。他们密谋对付他 —— 还有他可怜的手腕。 | 随着看他表演的领主惨遭刺杀，杂耍者第一个被指控。而他勉强保住了小命。}{现在，%name%想换点事情做，即便这行的观众是死亡。 | 现在，%name%打算和同样倒霉的人抱团取暖。 | %name%眼疾手快，命中目标应该是没问题。 | %name%能闭着眼睛耍刀，他对此胸有成竹。 | 杀人比杂耍更能赚钱，%name%接受了这个可悲的现实。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-5,
				-5
			],
			Bravery = [
				0,
				0
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				0,
				0
			],
			RangedSkill = [
				3,
				3
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
				12,
				10
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/dagger"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/hatchet"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/jesters_hat"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.HitChance[this.Const.BodyPart.Head] += 5;
	}

});
