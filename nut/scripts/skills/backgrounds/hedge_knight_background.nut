this.hedge_knight_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hedge_knight";
		this.m.Name = "雇佣骑士";
		this.m.Icon = "ui/backgrounds/background_33.png";
		this.m.BackgroundDescription = "雇佣骑士是一种非常竞争力的个体，擅长于用蛮力和重甲对抗人，但在与他人合作或迅速行动方面则不那么出色。";
		this.m.GoodEnding = "像%name%这样的人总是会有办法的。那位农民骑士最终也离开了他所在的战团，独自一人出发。与其他许多兄弟不同，他并没有把克朗用来买地或爬上贵族社会的阶梯。相反，他买了最好的战马和铠甲。这位巨人般的男子从一个又一个的比武大会上奔波，轻松赢得了所有比赛。他现在还在坚持，你觉得除非死去，他才会停下来。这位农民骑士只了解这样一种生活。";
		this.m.BadEnding = "%name% 这位小地主最终离开了战团。他漫游于各地，重新开始他喜爱的比武大会，其实这只是他真正喜爱的把人从马上刺下来撑成木屑的活动的幌子。某时，他接到指令要在比武大会中放水，让一个可怜的瘦弱的王子获得些名气。结果，这位小地主却直接穿透了那位王子的头颅。愤怒的领主下令将这位小地主处死。据说，一百多个士兵前往他的住所，但只有一半生还。";
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
			"独狼",
			"狼",
			"猎犬",
			"钢铁侠",
			"杀手",
			"比武骑士(the Jouster)",
			"巨人(the Giant)",
			"大山(The Mountain)",
			"强面(Strongface)",
			"污染者",
			"骑士杀手",
			"雇佣骑士 (the Hedge Knight)"
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
		return "{有些人生来就令人畏惧。 身高六英尺多，%name% 光是身材就足以让人望而生畏。 | %name%的影子笼罩在身材矮小的男人身上－当他走过时，他们似乎只会进一步矮小。 | 像身披战甲的熊一样站在人群当中，%name% 赚取了许多份双倍工资。 | 与他同样身形魁梧的兄弟们多年的残酷战斗给 %name% 留下了一个伤痕累累的可怕形象。} {这位雇佣骑士花了很多年时间带着他那匹珍贵的马参加比赛。 不幸的是，一杆长柄让他的坐骑挂了彩，让他失去了他的坐骑。 | 作为一个佣兵，雇佣骑士徘徊多年，为那些提供最多克朗的人战斗。 | 当他用一记环劈砍下五个人时，其中三个是他这边的，雇佣骑士被禁止在这片土地上的任何一支军队服役。 | 为了杀死一个领主的敌人，雇佣骑士踢开了一户人家的门，并徒手杀了他们。 当领主拒绝付钱时，%name% 也杀了他。 | 雇佣骑士曾经在苍白的月光下安详地睡过很多晚，也同样在灿烂的阳光下无情地杀了很多人。} {总是在寻找更多的克朗，与佣兵战团为伍似乎很合适。 | 太骇人了以至于没有人敢长期雇佣他，%name% 找的是那些在他拿起武器时不会被吓尿裤子的队友。 | 厌倦了杀戮权贵和贵族，以及妇女和儿童，%name% 认为佣兵工作是一种休假。 | 战争显然阻碍了 %name%的骑枪对决生涯。 他试图修正这个问题。}";
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
