this.gladiator_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.gladiator";
		this.m.Name = "角斗士";
		this.m.Icon = "ui/backgrounds/background_61.png";
		this.m.BackgroundDescription = "角斗士身价不菲，但竞技场场的生活将他们塑造为了技艺精湛的斗士。";
		this.m.GoodEnding = "你以为角斗士 %name% 会回到竞技场，但来自南方的消息传来，债务和角斗士们正在起义。与以往的起义不同，此次起义导致大臣们被吊在屋顶上，奴隶主在街头被私刑处决。这次普遍动荡显然将使得这位曾经的拳击手成为该地区的合法权力经纪人。";
		this.m.BadEnding = "人群的呼声对角斗士%name%来说太过嘈杂。在你从未成功的%companyname%迅速退役后，这位战士回到了南方王国的竞技场。不幸的是，他在佣兵时期的磨损使他慢了一步，最终被一名半饥饿的奴隶手持草叉和渔网致命地杀死。";
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
		return "{南方到处都是各种各样的奴隶，他们被称为背负镀金者债务的人。虽然大多数人都在田间劳作，但也有少数人被带到竞技场去决一死战。 | 尽管北方人也会参加战斗锦标赛，但没有什么能与南方角斗场里的暴力血腥比拟。 | 在南方，富人和穷人都喜欢为斗坑里的角斗士欢呼。 | 南方的角斗场充斥着负债累累和自愿杀人的人。 | 一幢充满战斗和赌博的血腥建筑，一个角斗场是南方唯一富人和穷人会挤在一起的地方。}{%name% 是从这群人中走出来的。 他迅速地在这伙人中成长，并设法买通了自己的出路，走出了角斗场，进入了某种可以寻求“自由”的生活。 | 深受观众喜欢的 %name% 作为角斗士的生涯在他富有的赞助商的“赦免”后结束。 但在早早退休后，他发现自己的生活并不圆满。 | 像 %name% 这样的成功杀手可以赎买通往自由的道路，尽管嗜血的欲望从未离开他的内心。 | %name% 卷入了一次“深潜”事件，并被禁赛一年。 | 但是像 %name% 这样的角斗士不仅受公众欢迎，而且特别受女性欢迎。 与一位贵族的妻子进行了一次淫荡的幽会后，这名战士在夜色的掩护下溜走了，以免被阉割。 | 最受欢迎的斗士通常是凶残和英俊的混合体，而像 %name% 这样的人只是前者。 由于他认为自己赚来的名气不足，他赎买了自己的自由，离开了这项血腥的运动。} {角斗士通常从一个角斗场奔波另一个角斗场，所以像 %name% 这样强壮、技术高超的战士在场外很少见。 然而他却站在这里，身上有足够让苦修者脸红的伤疤。 | 你遇到过很多战士，但很少有人拥有像 %name% 这样的特殊技能。所有在竞技场上的冲突使他成为一个聪明的战士，同时也有很多伤疤和伤痕，与他在那里的时间相当。 | 这个世界上有很多组合，一个身体未受伤害的角斗士不是其中之一。%name% 是一个熟练的战士，但他是用自己的鲜血和肉体赢得了这些经验。 | 一份令人印象深刻的角斗士简历，%name% 暗示了他是一个精通杀戮的人。 然而，许多伤疤却明确地表明，他在角斗场中的时光是让他付出了许多不可逆转的代价的。 | 像 %name% 这样的角斗士可能是世界上最熟练的战士，但是角斗场里到处都是旨在给所有参与者带来伤害的竞赛。 这个人是一个有才华的战士，但他身上有着竞技场从业者特有的伤疤。}";
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
