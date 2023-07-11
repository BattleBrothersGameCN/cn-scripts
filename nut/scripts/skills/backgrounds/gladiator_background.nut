this.gladiator_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.gladiator";
		this.m.Name = "角斗士";
		this.m.Icon = "ui/backgrounds/background_61.png";
		this.m.BackgroundDescription = "角斗士身价不菲，但竞技场场的生活将他们塑造为了技艺精湛的斗士。";
		this.m.GoodEnding = "你以为角斗士%name%会像你想象的那样重返竞技场，然而，来自南方的消息说，负债者和角斗士们一同发动了起义。与以往的起义不同，这次维齐尔被吊在屋顶上、奴隶贩子在街上被私刑处决。这次的动乱似乎将使这位曾经的擂台战士成为该地区的合法权力经纪人。";
		this.m.BadEnding = "人群的呼声对角斗士%name%来说太过嘈杂。在你从不成功的%companyname%迅速退休后，这位战士回到了南方王国的竞技场。不幸的是，他在与佣兵一起度过的时光中所受到的疲损使他慢了一步，最终被一个半饿的奴隶用草叉和网致命地击杀。";
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
		return "{南方到处都是各种各样的奴隶，他们被称为负债者 —— 因其背负着镀金者的债务。虽然大多数人都在田间劳作，但也有少数人被带到竞技场去决一死战。 | 尽管北方人也会参加战斗锦标赛，但没有什么能与南方角斗场里的暴力血腥比拟。 | 在南方，富人和穷人都喜欢为斗坑里的角斗士欢呼。 | 南方的角斗场充斥着负债累累和自愿杀人的人。 | 一幢充满战斗和赌博的血腥建筑，一个角斗场是南方唯一富人和穷人会挤在一起的地方。}{%name%便是从这群人中脱颖而出的。他迅速在角斗场中崭露头角，并设法用金钱摆脱了土坑生活，进入了在那种生活之后能够找到的所谓的“自由”。 | 深受观众喜欢的%name%作为角斗士的生涯在他富有的赞助商的“赦免”后结束。但在早早退休后，他发现自己的生活并不圆满。 | 像%name%这样的成功杀手可以赎买下通往自由的道路，尽管嗜血的欲望从未离开他的内心。 | %name%卷入了一次“跳水”事件，并因此被禁赛一年。 | 但是像%name%这样的角斗士不仅受公众欢迎，而且尤其受女性欢迎。一次与贵族之妻的淫秽幽会导致这名战士在夜色的掩护下溜走，以此避免被阉割。 | 土坑中最受欢迎的斗士通常是凶残和英俊的混合体，而像%name%这样的人只是前者。他对自认应获得的名声的缺乏感到失望，于是他赎买了自己，离开了这项血腥的运动。}{角斗士通常会从一个斗坑跑到另一个斗坑，所以像%name%这样强壮、技术娴熟的战士在场外很少见。然而他却站在这里，身上带着足够让自笞者脸红的伤疤。 | 你遇到过很多战士，但很少有人拥有像%name%这样的土坑斗士的特殊技能。所有在竞技场上的冲突使他成为一个聪明的战士，同时他身上也有许多伤疤和受伤，与他在那里度过的时间相匹配。 | 这个世界上有很多种组合，一个毫发无损的角斗士不是其中之一。%name%是一个熟练的战士，但他是用自己的鲜血和肉体赢得的这些经验。 | %name%带来的令人印象深刻的角斗士履历表明他精通杀戮之道。然而，众多的伤疤无情地表明他在土坑中度过的时间也使其付出了不可逆转的代价。 | 像%name%这样的角斗士可能是这片土地上最熟练的战士，但是斗坑里到处都是旨在给所有参与者带来伤害的竞赛。这个人是一名有才华的战士，但他身上带着竞技场职业生涯所留下的疤痕和伤口。}";
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
