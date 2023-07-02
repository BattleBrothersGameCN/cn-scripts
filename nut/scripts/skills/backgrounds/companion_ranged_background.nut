this.companion_ranged_background <- this.inherit("scripts/skills/backgrounds/character_background", {
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
			"trait.impatient",
			"trait.asthmatic",
			"trait.greedy",
			"trait.clubfooted",
			"trait.dumb",
			"trait.fragile",
			"trait.short_sighted",
			"trait.disloyal",
			"trait.drunkard",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.craven",
			"trait.dastard",
			"trait.insecure",
			"trait.hesitant"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.MeleeSkill,
			this.Const.Attributes.MeleeDefense
		];
		this.m.GoodEnding = "%name%从一开始就跟随你，退休后也跟着你，在你离开战团不久后也离开了。但他还没有结束战斗的生活，而是开始为另一个战团而战 —— 他自己的战团。他在你的领导下学到了很多，像你自己儿子一样令你感到自豪。讽刺的是，他讨厌你扮演他父亲的角色，而你总是告诉他你绝不可能做这么难看的儿子的爸爸。你们一直保持联系到如今。";
		this.m.BadEnding = "%name%从一开始就跟随着你，他既忠诚又有才华。他在战团呆了一段时间，最终离开自行开创事业。前几天，你收到了一封来自这位雇佣兵的信，他在信中表示已经开创了自己的战团，并急需帮助。不幸的是，这封信是将近一年之前寄出的。当你调查了他的战团的存在时，你得知它已经在贵族间的一场战斗中被彻底摧毁了。";
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.IsUntalented = true;
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
		return "%name%是你旅途中遇到的最有天赋的射手之一。{在他一箭射进一个要刺杀你的刺客的心脏后，你立刻雇佣了这个人。 | 了解这个男人很容易 —— 你只需要找到当地射击比赛的冠军即可。 | 他曾赢过一场有数百来自各地的人参加的射箭比赛。 | 据说他能射劈开一支箭 —— 飞在半空中的一支。 | 你在农场里找到了他，很明显他的射击天赋会在那儿被浪费。 | 一个偷猎者、弓匠、弓箭手，这个人的技能得到了充分的利用。你怀疑他欣然接受你的雇佣合同只是为了说“他全干过了”。 | 你曾见他挽弓射月，但那可能是某种把戏。 | 他是一个聪明的弓箭手，曾经一次射出两支箭杀死一伙冲锋的强盗。}虽然他更喜欢远距离杀戮，但%name%在近身格斗中也丝毫不差。";
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
				5,
				5
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				5,
				0
			],
			RangedSkill = [
				16,
				10
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
				5,
				5
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
		talents[this.Const.Attributes.RangedSkill] = 2;
		talents[this.Const.Attributes.RangedDefense] = 1;
		talents[this.Const.Attributes.Initiative] = 1;
		local items = this.getContainer().getActor().getItems();
		local r;
		items.equip(this.new("scripts/items/weapons/light_crossbow"));
		items.equip(this.new("scripts/items/ammo/quiver_of_bolts"));
		items.addToBag(this.new("scripts/items/weapons/knife"));
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/thick_tunic"));
		}
	}

});
