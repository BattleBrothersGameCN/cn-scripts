this.companion_1h_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.companion";
		this.m.Name = "伙伴";
		this.m.Icon = "ui/traits/trait_icon_32.png";
		this.m.HiringCost = 0;
		this.m.DailyCost = 14;
		this.m.DailyCostMult = 1.000000;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.hate_undead",
			"trait.hate_beasts",
			"trait.hate_greenskins",
			"trait.huge",
			"trait.weasel",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.paranoid",
			"trait.night_blind",
			"trait.ailing",
			"trait.impatient",
			"trait.asthmatic",
			"trait.greedy",
			"trait.dumb",
			"trait.clubfooted",
			"trait.drunkard",
			"trait.disloyal",
			"trait.tiny",
			"trait.fragile",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.dastard",
			"trait.insecure"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.RangedSkill
		];
		this.m.GoodEnding = "%name%从一开始就跟随你，退休后也跟着你，在你离开战团不久后也离开了。但他还没有结束战斗的生活，而是开始为另一个战团而战 —— 他自己的战团。他在你的领导下学到了很多，像你自己儿子一样令你感到自豪。讽刺的是，他讨厌你扮演他父亲的角色，而你总是告诉他你绝不可能做这么难看的儿子的爸爸。你们一直保持联系到如今。";
		this.m.BadEnding = "%name%从一开始就跟随着你，他既忠诚又有才华。他在战团呆了一段时间，最终离开自行开创事业。前几天，你收到了一封来自这位雇佣兵的信，他在信中表示已经开创了自己的战团，并急需帮助。不幸的是，这封信是将近一年之前寄出的。当你调查了他的战团的存在时，你得知它已经在贵族间的一场战斗中被彻底摧毁了。";
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.IsCombatBackground = true;
		this.m.IsUntalented = true;
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
		return "%name%并不以爱吹牛闻名，但他完全有权利这样做。{他曾救过%2h%和%ranged%。 | 他曾经把你从兽人的邪恶枷锁中解救出来。 | 如果不是这个人，你已经在酒吧被刺客杀了。 | 一支走火的弩箭差点把你的眼睛剜出来 —— 要不是%name%的盾牌挡住了它。 | 他曾经用盾牌和两条强壮的腿将两个人推下悬崖。 | 他从父亲那里学会了如何战斗，他父亲是一位诸多著名战役中的先锋。 | 他牺牲了他家的传家宝 —— 一面镶钉的旧木盾 —— 救了你的命。 | 他是一个一贯英勇的人，他从酒吧火灾中救出了醉酒的%2h%。 | 面对一大群地精，他用他的盾牌和力量在他们的防线上开了一个洞，为%2h%和%ranged%打开一条杀光地精的路。}凭借着回旋腾挪和盾牌挥舞，他躲开了各种各样的致命危险。尽管他话不多，但你已经发现%name%在盾墙中的位置是非常不可或缺的。";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		_vars.push([
			"1h",
			brothers.len() >= 1 ? brothers[0].getName() : ""
		]);
		_vars.push([
			"2h",
			brothers.len() >= 2 ? brothers[1].getName() : ""
		]);
		_vars.push([
			"ranged",
			brothers.len() >= 3 ? brothers[2].getName() : ""
		]);
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				10,
				5
			],
			Stamina = [
				5,
				5
			],
			MeleeSkill = [
				10,
				5
			],
			RangedSkill = [
				5,
				5
			],
			MeleeDefense = [
				5,
				5
			],
			RangedDefense = [
				5,
				5
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
		local talents = this.getContainer().getActor().getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.Hitpoints] = 2;
		talents[this.Const.Attributes.Fatigue] = 1;
		talents[this.Const.Attributes.Bravery] = 1;
		local items = this.getContainer().getActor().getItems();
		local r;
		items.equip(this.new("scripts/items/weapons/militia_spear"));
		items.equip(this.new("scripts/items/shields/wooden_shield"));
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/gambeson"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/aketon_cap"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/open_leather_cap"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/full_aketon_cap"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/full_leather_cap"));
		}
	}

});
