this.hedge_knight_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hedge_knight";
		this.m.Name = "雇佣骑士";
		this.m.Icon = "ui/backgrounds/background_33.png";
		this.m.BackgroundDescription = "雇佣骑士实力出众，好勇斗狠，擅长以蛮力和沉重盔甲对抗敌人，但在与他人合作或迅速行动方面则稍显不足。";
		this.m.GoodEnding = "%name%这样的人从不缺少出路。这位雇佣骑士最终，或者说不可避免地，离开了战团，独自一人行动。与其他许多兄弟不同，他并没有把克朗花在买地或混进贵族圈子上。相反，他买了最好的战马和铠甲。这位巨人般的男子奔波于场场骑士比武比赛之间，轻松赢得了所有比赛。他至今还坚持如此，你认为他会不死不休。他只是对其他活法没有概念。";
		this.m.BadEnding = "雇佣骑士%name%最终离开了战团。他游历各地，重新回他最喜欢的马上骑枪比武，但这其实只是个幌子，他喜欢的是沐浴在把人挑下马的荣耀和飞溅的骑枪碎片里。有一次，他对上了一个可怜的瘦高个王子，当地贵族命令他\"放水\"，给那王子赢取些声望。然而，这个雇佣骑士却用骑枪直接刺穿了那人的脑袋。愤怒之下，那里的领主下令杀死这个雇佣骑士。据说赶去他家一百多名士兵里，只有一半活着回来。";
		this.m.HiringCost = 100;
		this.m.DailyCost = 35;
		this.m.Excluded = [
			"trait.weasel",
			"trait.teamplayer",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.ailing",
			"trait.swift",
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
			"trait.insecure",
			"trait.asthmatic"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Initiative,
			this.Const.Attributes.RangedSkill
		];
		this.m.Titles = [
			"独狼(the Lone Wolf)",
			"狼(the Wolf)",
			"猎犬(the Hound)",
			"执钢者(Steelwielder)",
			"杀手(the Slayer)",
			"比武骑士(the Jouster)",
			"巨人(the Giant)",
			"大山(The Mountain)",
			"强面(Strongface)",
			"亵渎者(the Defiler)",
			"骑士杀手(the Knightslayer)",
			"雇佣骑士(the Hedge Knight)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(2, 5);
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
		return "{有些人生来就令人畏惧。%name%身长八尺，光是他的身材就足以让人望而生畏。 | %name%的影子足以罩住矮小的人。而当他走过时，只会让他们更显渺小。 | %name%站在人群中就像一只穿着铠甲的熊，许多人看了都会愣住。 | 多年来，与他同样身形魁梧的兄弟们的残酷战斗给%name%留下了一副伤痕累累的可怕形象。}{这个雇佣骑士带着他那匹赢来的宝贝马参加了多个赛季的比赛。不幸的是，一杆长柄武器给他的马开了瓢，令他失去了他的坐骑。 | 作为一个佣兵，这个雇佣骑士常年流浪，为那些出价最高的人而战。 | 当他一挥之间砍倒了包括三个自己人的五人后，各地的军队一致拒绝他加入。 | 为了杀死一名领主的敌人，这个雇佣骑士踢开了一户人家的门，并徒手将他们全部屠杀了。领主拒绝付钱，%name%就把他也杀了。 | 这个雇佣骑士度过了许多个在苍白月光下平静睡眠的夜晚 —— 同样多个在炽热日光下无情杀戮的白天。}{他总是想赚更多的钱，与佣兵为伍正合适。 | 他太过骇人以至于没有人敢长期雇佣他，%name%寻找的是那些在他拿起武器时不会尿裤子的队员。 | 厌倦了杀戮武者领主，妇女儿童，%name%决定干点佣兵的活儿度假。 | 战争显然阻碍了%name%的马上骑枪比武生涯。他试图修正这个问题。}";
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

		if (this.Math.rand(1, 100) <= 25)
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
				12,
				13
			],
			Bravery = [
				9,
				4
			],
			Stamina = [
				15,
				10
			],
			MeleeSkill = [
				11,
				10
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				6,
				5
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				-14,
				-7
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(0, 2) == 2)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.HedgeKnightTitles[this.Math.rand(0, this.Const.Strings.HedgeKnightTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;

		if (this.Const.DLC.Unhold)
		{
			r = this.Math.rand(0, 2);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/weapons/greataxe"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/greatsword"));
			}
			else if (r == 2)
			{
				items.equip(this.new("scripts/items/weapons/two_handed_flanged_mace"));
			}
		}
		else
		{
			r = this.Math.rand(0, 1);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/weapons/greataxe"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/greatsword"));
			}
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/mail_hauberk"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/basic_mail_shirt"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/scale_armor"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/reinforced_mail_hauberk"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/armor/worn_mail_shirt"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/nasal_helmet"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/nasal_helmet_with_mail"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/mail_coif"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/bascinet_with_mail"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/helmets/closed_flat_top_helmet"));
		}
	}

});
