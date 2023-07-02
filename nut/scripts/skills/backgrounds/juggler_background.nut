this.juggler_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.juggler";
		this.m.Name = "杂耍者";
		this.m.Icon = "ui/backgrounds/background_14.png";
		this.m.BackgroundDescription = "杂耍者需要有良好的反应能力和手眼协调能力。";
		this.m.GoodEnding = "杂耍者%name%拿出他所有做佣兵挣的钱，成立了一个巡回剧团。你最后听到的消息是，他建立了一座剧院，每月上演一部新剧！";
		this.m.BadEnding = "杂耍者%name%退出了战斗。他在{南部地区 | 北部地区 | 东部地区 | 西部地区}为一个花哨的贵族表演时，某个节目出了差错。有传言说他因为这个失误被从塔楼上扔下，但你不愿意相信这个说法。";
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
		return "{在继兄弟的传授下，%name%像水手学会划桨一样学会了杂耍。 | 虽然被同龄人嘲笑，但%name%一直很喜欢杂耍。 | 在一个小丑剧团的拜访下，%name%对其中一位特别有趣的人情有独钟 —— 并最终向他学习，那人就是一个杂耍演员。 | 作为当地一位贵族的儿子，%name%对杂耍和娱乐令人尴尬的痴迷使他从家族中被流放。 | %name%不是为了杂耍而杂耍，而是为了赢得观众的笑声和掌声。}{不幸的是，当战争肆虐这片土地时，没有多少人可以娱乐。 | 但人群和克朗在这片充满苦难和痛苦的土地上很稀少。 | 但一场涉及锛子和皇室婴儿的杂耍事故让这位艺人不得不逃命。 | 他擅长翻弄剑和匕首，但很快他就被指控使用巫术，并被迫离开他钟爱的事业。 | 可悲的是，%name%的杂耍技巧引起了同行们的嫉妒。他们密谋对付他 —— 还有他可怜的手腕。 | 当一个刺客杀死了其为之逗乐的领主时，杂耍者是第一个被指控的人。他勉强逃过一劫。}{现在，%name%寻求一条新的道路，即使死亡本身已经成为他的观众。 | 现在，%name%在与同样倒霉的人们的陪伴中寻求慰藉。 | 鉴于他眼疾手快，%name%命中目标应该没有问题。 | %name%能闭着眼睛杂耍玩刀，他知道把每把刀扔到哪里。 | 杀人比杂耍赚得更多，%name%已经接受了这个可悲的现实。}";
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
