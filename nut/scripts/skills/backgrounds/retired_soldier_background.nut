this.retired_soldier_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.retired_soldier";
		this.m.Name = "退役士兵";
		this.m.Icon = "ui/backgrounds/background_24.png";
		this.m.BackgroundDescription = "退役士兵往往有丰富的战争经验，他们的决心不易动摇。然而，他们的年龄可能对他们的身体素质造成了影响。";
		this.m.GoodEnding = "%name%再次退役了，这次是离开佣兵生涯而非士兵生涯。他从%companyname%离开，在树林里搭建了一间小屋，享受着和平与宁静，尽可能远离所有的战斗。";
		this.m.BadEnding = "因为厌倦了所有的战斗，%name%离开了急剧衰落的%companyname%，并在树林里给自己建了一间小屋。不幸的是，流浪汉们袭击了他。传言称他被发现血流不止地躺在地上，周围倒了六个死人。最后一个站着的人是个紧张的、垮掉的男孩，摇摇晃晃地向垂死的老人挥舞着一把剑。";
		this.m.HiringCost = 140;
		this.m.DailyCost = 15;
		this.m.Excluded = [
			"trait.weasel",
			"trait.swift",
			"trait.clubfooted",
			"trait.irrational",
			"trait.gluttonous",
			"trait.disloyal",
			"trait.clumsy",
			"trait.tiny",
			"trait.insecure",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.dastard",
			"trait.hesitant",
			"trait.fragile",
			"trait.iron_lungs",
			"trait.tough",
			"trait.strong",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"老卫兵(the Oldguard)",
			"老人(the Old)",
			"军士(the Sergeant)",
			"老兵(the Veteran)",
			"士兵(the Soldier)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.Old;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(2, 3);
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
		return "作为当地领主军队中曾经的{一位军士 | 一位皇家卫兵 | 一位忠诚的士兵 | 一位受人尊敬的军人 | 一个前线兵 | 一个士兵 | 一个步兵}，%fullname%{在膝盖中了一箭后退役了 | 被一个有抱负的年轻人取代了 | 在值勤时睡着被开除了 | 在长期模范级服役后退休了 | 在战斗中受伤被迫退休 | 厌倦了战争和杀戮，在战争毁了他的思想之前正式结束了他的服役 | 与凶猛的兽人部落作战，这场战役最终迫使他退休}。{他把自己的装备连同他的职责记忆一起锁在一个箱子里，打算再也不将他们拾起了 | 他把剑和盾牌都放在书房里，仅仅当做是军事过往的遗物 | 他把武器挂在烟囱上，作为一个无声的提醒，提醒自己曾经是一个什么样的人 | 但是，他的人生新篇章正在等待着他，在那里他不再需要执剑继续他的生活 | 在他服役多年之后，他终于可以得到一些安宁了 | 没有了军事演习的咆哮声，他的生活从未如此安静过}。{多年来，他与心爱的妻子过着幸福的生活，直到她因年老离世。此后，他别无所依。 | 直到他发现他以前的战友在一次伏击中被残忍杀害后， | 只有当他听到一场大规模入侵即将摧毁他的家园的传言后， | 他试着做了一段时间的农夫，但每天他都怀念手握好剑身处盾墙的时光。最后， | 但事实证明，军队以外的生活并不适合他，因为他觉得自己无所事事，毫无用处。最后， | 有一段时间，他感到很自在。但随着这片土地被战争吞噬， | 远离战争的时间是短暂的，因为战争很快就来到了他身边。没过多久 | 由于居住在农场里，%name%被无聊缠身，最终，}他再次拿起了武器。尽管{尽管他的黄金岁月已经过去很久了 | 身体状况不如从前 | 他的体质已不再年轻 | 他不再是以前那个鲁莽的年轻战士了 | 离开部队的日子削弱了他的技能}，{他的剑术仍然足以打败任何一个吹牛的年轻人 | 他仍然知道如何在战场上战斗 | 他的经验是首屈一指的 | 他可以依靠一生的战斗经验 | 他渴望和兄弟们站在一起 | 他渴望再次寻求战斗 | 他对战斗的渴望反映在他实际战斗的能力上 | 他还是知晓如何保持盾墙}。";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-10,
				-15
			],
			Bravery = [
				13,
				10
			],
			Stamina = [
				-10,
				-10
			],
			MeleeSkill = [
				13,
				10
			],
			RangedSkill = [
				5,
				0
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
				-5,
				-10
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/shortsword"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/hand_axe"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/boar_spear"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/falchion"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/shields/wooden_shield"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/basic_mail_shirt"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/padded_leather"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/patched_mail_shirt"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/worn_mail_shirt"));
		}

		r = this.Math.rand(0, 8);

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
			items.equip(this.new("scripts/items/helmets/rusty_mail_coif"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/helmets/aketon_cap"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/helmets/full_aketon_cap"));
		}
	}

});
