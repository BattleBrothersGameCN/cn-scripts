this.hedge_knight_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hedge_knight";
		this.m.Name = "雇佣骑士";
		this.m.Icon = "ui/backgrounds/background_33.png";
		this.m.BackgroundDescription = "雇佣骑士是一些具有竞争力的个体，擅长以蛮力和沉重盔甲对抗敌人，但在与他人合作或迅速行动方面则稍显不足。";
		this.m.GoodEnding = "像%name%这样的人总是会有办法的。这位雇佣骑士最终，或者说不可避免地，离开了战团，独自一人行动。与其他许多兄弟不同，他并没有把克朗用来买地或爬上贵族社会的阶梯。相反，他买了最好的战马和铠甲。这位巨人般的男子奔波于场场骑士比武比赛之间，轻松赢得了所有比赛。他至今还在坚持此事，你认为他在死之前不会停下来。这个雇佣骑士只是对其他生活毫不了解。";
		this.m.BadEnding = "%name%这位雇佣骑士最终离开了战团。他游历各地，重新回他最喜欢的马上骑枪比武，这实际上是种对他过去真正喜欢的在碎片和荣耀的阵雨中把人从马上戳下的时光的掩护。在某个时刻，他被命令在一个可怜而瘦高笨拙的王子面前\"放水\"，为贵族赢取些声望。然而，这个雇佣骑士却用长矛直接刺穿了那人的脑袋。愤怒之下，那片土地的领主下令杀死这个雇佣骑士。据说一百多名士兵前往了他的住所，只有一半活着返回。";
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
		return "{有些人生来就令人畏惧。%name%身高超过一米八，光是他的身材就足以让人望而生畏。 | %name%的影子笼罩在更矮小的男人身上 —— 当他走过时，他们似乎只会进一步缩小。 | %name%站在人群中就像一只穿着铠甲的熊，引得许多人再次回头。 | 与他同样身形魁梧的兄弟们多年的残酷战斗给%name%留下了一副伤痕累累的可怕形象。}{这个雇佣骑士带着他那匹宝贝马参加了多个赛季的比赛。不幸的是，一把长柄武器击败了他的马，令他失去了他的坐骑。 | 作为一个佣兵，这个雇佣骑士常年流浪，为那些出价最高的人而战。 | 当他一挥之间砍倒了包括三个自己人的五人后，这个雇佣骑士被各地的军队所拒绝。 | 为了杀死一个领主的敌人，这个雇佣骑士踢开了一户人家的门，并徒手将他们全部屠杀了。当领主拒绝付钱时，%name%把他也杀了。 | 这个雇佣骑士度过了许多个在苍白月光下平静睡眠的夜晚 —— 同样多个在炽热日光下无情地杀戮的白天。}{他总是在寻找更多的克朗，与佣兵为伍似乎很合适。 | 他太过骇人以至于没有人敢长期雇佣他，%name%寻找的是那些在他拿起武器时不会尿裤子的队员。 | 厌倦了杀戮比武者和领主，以及妇女和儿童，%name%把佣兵的工作视为一种度假。 | 战争显然阻碍了%name%的马上骑枪比武生涯。他试图修正这个问题。}";
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
