this.gladiator_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.gladiator";
		this.m.Name = "角斗士";
		this.m.Icon = "ui/backgrounds/background_61.png";
		this.m.BackgroundDescription = "角斗士身价不菲，但竞技场的生活将他们塑造成了技艺精湛的斗士。";
		this.m.GoodEnding = "你以为角斗士%name%会像你想象的那样重返竞技场，然而，来自南方的消息说，负债者和角斗士们一同发动了起义。与以往的起义不同，这次维齐尔被吊上屋顶、奴隶贩子不经审判当街处决。这场大规模动荡让这位曾经的斗士成了当地合法的权力代理人。";
		this.m.BadEnding = "人群的呼声对角斗士%name%来说太过嘈杂。在你从走向失败的%companyname%草草退休后，这位斗士回到了南方王国的竞技场。不幸的是，佣兵生活的疲损使他慢了一步，被一个半饿的奴隶用草叉和网杀死。";
		this.m.HiringCost = 200;
		this.m.DailyCost = 35;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.fear_undead",
			"trait.weasel",
			"trait.night_blind",
			"trait.ailing",
			"trait.asthmatic",
			"trait.clubfooted",
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
		this.m.Bodies = this.Const.Bodies.Gladiator;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.BeardChance = 60;
		this.m.Ethnicity = 1;
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
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
		return "{南方充斥着各种各样的奴隶，这些人往往对镀金者有所亏欠，因而被称为负债者。他们大多数在田野中劳作，也有少数被选中，带到角斗场里一决高下。 | 北方人也会举行比赛，参与战斗，但论起暴力血腥，南方角斗场无出其右。 | 在南方，无论富人穷人都喜欢为斗坑里的角斗士欢呼。 | 南方的角斗场既有负债奴隶，也有自愿加入杀戮的自由人。 | 斗士在斗坑里血拼，观众在赌桌上血拼，南方的角斗场有富人也有贫苦大众。}{%name%就是从这些人里闯了出来。他迅速崭露头角，设法赎身，在经历的那样的生活后，抓住任何“自由”的机会。 | %name%深受观众喜爱，有人用一笔钱“赎”出了他，不必再作为角斗士拼杀。但早早退役的他，生活只剩空虚。 | 像%name%这样的成功杀手可以赎买下通往自由的道路，但嗜血的欲望从未离开他的内心。 | %name%卷入了一场“跳水”事件，并因此被禁赛一年。 | 不只是一般大众，%name%这样的角斗士尤其讨女人喜欢。一次与贵族夫人的淫秽幽会后，为了免于阉割，他只得趁着夜色溜走。  | 角斗场上最受欢迎的斗士通常是凶残和英俊的结合体，而有些%name%这样的人只是前者。他认为现在的名声配不上自己的实力，于是他赎买了自己，离开了这项血腥的运动。}{角斗士通常会在斗坑之间巡回参赛，所以像%name%这样强壮、技术娴熟的战士很少出现在场外。而他就站在这里，身上的伤疤足以让自笞者脸红。 | 你遇到过很多战士，但很少有像%name%这样专精土坑角斗的。竞技场里的交锋把他打造成了一个聪明的战士，也给他烙印上了与他漫长岁月相符的伤疤。 | 这个世界上有很多种组合，一个毫发无伤的角斗士不是其中之一。%name%经验丰富，但那是他用自己的血肉换来的。 | %name%带来的角斗士履历表明他精通杀戮之道。不过，众多的伤疤也坦率地展示了斗坑中的漫长岁月里，他所付出的不可逆转的代价。 | 像%name%这样的角斗士可能是这片土地上最熟练的战士，但是斗坑里的打斗接连不断，让参与者受伤来取悦观众本就是赛事设计的一部分。他称得上是一名有才华的战士，但竞技场职业生涯带来的疤痕和伤害永远留在了他身上。}";
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
				8,
				6
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

		if (this.Math.rand(1, 2) == 2)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.GladiatorTitles[this.Math.rand(0, this.Const.Strings.GladiatorTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;

		if (items.hasEmptySlot(this.Const.ItemSlot.Mainhand))
		{
			local weapons = [
				"weapons/shamshir",
				"weapons/shamshir",
				"weapons/oriental/two_handed_scimitar",
				"weapons/oriental/heavy_southern_mace",
				"weapons/oriental/heavy_southern_mace",
				"weapons/oriental/swordlance",
				"weapons/oriental/polemace",
				"weapons/fighting_axe",
				"weapons/fighting_spear"
			];

			if (this.Const.DLC.Wildmen)
			{
				weapons.extend([
					"weapons/two_handed_flail",
					"weapons/two_handed_flanged_mace",
					"weapons/bardiche"
				]);
			}

			items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
		}

		if (items.hasEmptySlot(this.Const.ItemSlot.Offhand))
		{
			local offhand = [
				"tools/throwing_net",
				"shields/oriental/metal_round_shield"
			];
			items.equip(this.new("scripts/items/" + offhand[this.Math.rand(0, offhand.len() - 1)]));
		}

		local a = this.new("scripts/items/armor/oriental/gladiator_harness");
		local u;
		r = this.Math.rand(1, 2);

		if (r == 1)
		{
			u = this.new("scripts/items/armor_upgrades/light_gladiator_upgrade");
		}
		else if (r == 2)
		{
			u = this.new("scripts/items/armor_upgrades/heavy_gladiator_upgrade");
		}

		a.setUpgrade(u);
		items.equip(a);
		r = this.Math.rand(2, 3);

		if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/oriental/gladiator_helmet"));
		}
	}

});
