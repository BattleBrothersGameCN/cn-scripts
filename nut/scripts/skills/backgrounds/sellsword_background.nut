this.sellsword_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.sellsword";
		this.m.Name = "佣兵";
		this.m.Icon = "ui/backgrounds/background_10.png";
		this.m.BackgroundDescription = "佣兵价格不菲，但战争生涯将他们铸就为了技艺精湛的战士。";
		this.m.GoodEnding = "佣兵%name%离开了%companyname%并创建了自己的佣兵战团。据你所知，这是一次非常成功的冒险，他经常和%companyname%合伙合作。";
		this.m.BadEnding = "%name%离开了%companyname%并创立了他自己的另一家竞争的战团。两个战团在一场贵族之间的战斗中处于对立的双方。这个佣兵在冲突中被另一名%companyname%佣兵用一顶雇佣骑士的头盔砸死了。";
		this.m.HiringCost = 100;
		this.m.DailyCost = 35;
		this.m.Excluded = [
			"trait.weasel",
			"trait.night_blind",
			"trait.ailing",
			"trait.asthmatic",
			"trait.clubfooted",
			"trait.irrational",
			"trait.hesitant",
			"trait.loyal",
			"trait.tiny",
			"trait.fragile",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.dastard",
			"trait.insecure"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(2, 4);
		this.m.IsCombatBackground = true;
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
		return "{%fullname%自从他父亲把装备传给他以后就当了佣兵。 | %fullname%记不得他不做佣兵的日子了。 | 作为一个佣兵，%fullname%从不需要花太长时间找工作。 | 有文化的人谈论释放战争之犬。%fullname%就是这样其中一只猎犬。 | 在战争中，有死亡也有利益。%fullname%造成前者以赚取后者。 | 对于像%name%这样的佣兵来说，现在是赚取一两个克朗的绝佳时机。 | 在他的妻子带着他的孩子跑了之后，愤怒的%name%成为了一名凶残的佣兵。 | 十年前%name%在一场火灾中失去了一切。从那以后他就一直当佣兵。 | %name%一直有暴力倾向，长期从事佣兵职业。 | 曾经一贫如洗的%name%多年来当佣兵赚了不少钱。 | %fullname%更倾向于保守自己来自何处的秘密，但他身为受雇武力的名声就说明了一切。}{他经验丰富，曾随多家战团旅行。 | 军事行动对他来说不过是小菜一碟。 | 从一个领主的保镖到一个肮脏商人的打手，%name%已经见识了种种。 | 他曾经以杀戮侵犯人类定居点的野兽为生。 | 他狞笑着吹嘘自己杀死过各种各样的生物。 | 通过大量的运用，这个佣兵学会了一些你甚至不知道存在的武器。 | 这个佣兵至今还在计算他杀过多少人，而且似乎短期内还不会停下。 | 手里拿着剑和盾，这个佣兵似乎在做他最擅长的事情来谋生。}{这个人对战场并不陌生。 | 这个人对战争的残酷并不陌生。 | 他已经习惯了佣兵生活的残酷现实。 | 据说他在任何盾墙中都是可靠的一员。 | 有人说他能像棵橡树一样守住战线。 | 传闻说这个人喜欢看血。 | 他毫不羞耻地在战场上对他人的苦难感到莫名的快乐。 | 奇怪的是，他很少和别人一起围坐在营火旁，而是一个人呆着。 | 这个人喜欢讲他如何杀死这个或那个东西的好故事。 | 只要有机会，这个人能迅速展示各种不同的格斗风格。}{只要你有钱，%name%就归你指挥。 | 一个真正的佣兵，只要价钱合适，%name%会与任何人战斗。 | %name%展示了高超的剑术，说他能刺穿任何人。 | 只需要点头暗示，%name%就同意加入你，前提是你有克朗。 | %name%为有机会赚克朗而兴奋地在桌上敲着酒杯。}";
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");

		if (this.Math.rand(1, 100) <= 25)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (this.Math.rand(1, 100) <= 30)
		{
			tattoo_head.setBrush("scar_02_head");
			tattoo_head.Visible = true;
		}
	}

	function updateAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");

		if (tattoo_body.HasBrush)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
		}
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				5,
				5
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				13,
				10
			],
			RangedSkill = [
				12,
				10
			],
			MeleeDefense = [
				5,
				8
			],
			RangedDefense = [
				5,
				8
			],
			Initiative = [
				0,
				0
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(0, 3) == 3)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.SellswordTitles[this.Math.rand(0, this.Const.Strings.SellswordTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 9);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/falchion"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/flail"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/hand_axe"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/greataxe"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/weapons/longsword"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/weapons/billhook"));
		}
		else if (r == 6)
		{
			items.equip(this.new("scripts/items/weapons/winged_mace"));
		}
		else if (r == 7)
		{
			items.equip(this.new("scripts/items/weapons/warhammer"));
		}
		else if (r == 8)
		{
			items.equip(this.new("scripts/items/weapons/boar_spear"));
		}
		else if (r == 9)
		{
			items.equip(this.new("scripts/items/weapons/crossbow"));
			items.equip(this.new("scripts/items/ammo/quiver_of_bolts"));
		}

		r = this.Math.rand(0, 5);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/patched_mail_shirt"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/padded_leather"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/basic_mail_shirt"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/worn_mail_shirt"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/armor/leather_lamellar"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/armor/mail_shirt"));
		}

		r = this.Math.rand(0, 9);

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
			items.equip(this.new("scripts/items/helmets/mail_coif"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/closed_mail_coif"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/helmets/reinforced_mail_coif"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/helmets/kettle_hat"));
		}
		else if (r == 6)
		{
			items.equip(this.new("scripts/items/helmets/padded_kettle_hat"));
		}
		else if (r == 7)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
	}

});
