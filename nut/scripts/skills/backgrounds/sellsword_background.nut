this.sellsword_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.sellsword";
		this.m.Name = "佣兵";
		this.m.Icon = "ui/backgrounds/background_10.png";
		this.m.BackgroundDescription = "佣兵价格不菲，但战争生涯将他们铸就为了技艺精湛的战士。";
		this.m.GoodEnding = "%name%佣兵离开了%companyname%并创建了自己的雇佣军战团。据你所知，这是一次非常成功的尝试，他经常和 %companyname% 的人一起工作。";
		this.m.BadEnding = "%name% 离开了 %companyname% 并创立了他自己的战团。两个战团在贵族之间的战斗中发生了冲突，在冲突中他被 %companyname% 的一名佣兵用头盔顶死了。 ";
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
		return "{%fullname% 从他父亲手上接过他的装备后，开始了佣兵的工作。 | %fullname% 不记得他不是雇佣之剑的日子了。 | 作为一个佣兵，%fullname% 从不需要花太长时间找工作。 | 学者谈论释放战犬。%fullname% 就是这样的猎犬。 | 战争中有死有利。%fullname% 造成前者赚取后者。 | 对于像 %name% 这样的佣兵来说，赢得一两个克朗是再好不过的了。 | 在他妻子带着孩子私奔后，愤怒 %name% 把当卑鄙的佣兵当做了一个稳定的职业。 | 十年前 %name% 在一场火灾中失去了一切。 从那以后，他一直干佣兵的活。 | %name% 一直有暴力的想法，并长期从事佣兵职业。 | 曾经一贫如洗的 %name% 多年来作为佣兵赚了一大笔钱。 | %fullname% 宁愿回归故里，但他作为佣兵的名声已经不言而喻。} {经验丰富，他曾跟随许多武装战团旅行。 | 军事行动对他来说不过是小菜一碟。 | 从一个领主的保镖到一个肮脏商人的打手，%name% 已经见识了各种。 | 他曾经以杀戮侵占人类定居点的野兽为生。 | 他咧嘴一笑，吹嘘自己杀死了各种各样的生物。 | 通过大量的使用，佣兵学会了一些你甚至不知道是否存在的武器。 | 佣兵正在计算他今天已经杀了多少人，他似乎不会很快停止。 | 手里拿着剑和盾牌，佣兵似乎在做他最擅长的工作。} {这个人对战场并不陌生。 | 这个人对战争的残酷并不陌生。 | 他已经习惯了唯利是图的残酷现实。 | 据说他是任何盾墙中可靠的齿轮。 | 有人说他能像橡树一样坚守战场。 | 传闻说这个人喜欢看血。 | 毫无羞耻，他对战场上其他人的痛苦感到一种令人不安的愉悦。 | 奇怪的是，他很少在篝火旁和其他人在一起，而是保持沉默。 | 这个人喜欢讲他是怎么杀了这个或那个东西的。 | 如果有机会，这个人很快就能展示出各种各样的战斗风格。} {只要你有硬币，%name% 就归你指挥了。 | 一个真正的唯利是图的人，只要价钱合适 %name% 会与任何人战斗。 | 显示出高超的剑术，%name% 说他可以击败任何人。 | 只要点头，%name% 就同意加入你，如果你有克朗的话。 | %name% 为有机会赚到硬币而兴奋得在桌上敲着酒杯。}";
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
