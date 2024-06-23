this.bastard_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.bastard";
		this.m.Name = "私生子";
		this.m.Icon = "ui/backgrounds/background_37.png";
		this.m.BackgroundDescription = "私生子们经常从近身格斗的训练中获益。";
		this.m.GoodEnding = "{%name%，作为一个不为他人着想的贵族的私生子。离开了%companyname%以试图开创自己的家族血统。据你最后一次听到的消息，他已经成功地获得了一块好土地，并在上面建起了一座简陋的石头城堡。虽然他取得了成功，但是他仍然对他的家庭心怀怨恨。 | 作为贵族的私生子，%name%总有一种觉得自己并不属于这个世界的困惑。但%companyname%赋予了他兄弟组建的家庭。据你所知，他至今仍然在为这个战团战斗着。}";
		this.m.BadEnding = "像%name%这样的私生子通常在这个世界上走不远。他们被所生存的上流社会所憎恨，也被下层社会所憎恨 —— 下层人民不理解为何私生子比贵族更为常见的政治原则。在你离开战团后不久，你听说%name%去世了。很明显，一个年轻而残酷的领主接管了他的贵族家庭，并将这个私生子视为他王位的威胁。尽管这个私生子不再想跟那种生活有任何牵连，但事情还是找上了他。他在一个旅店的床上被刺杀，在睡梦中被割开了喉咙。";
		this.m.HiringCost = 110;
		this.m.DailyCost = 14;
		this.m.Excluded = [
			"trait.teamplayer",
			"trait.ailing",
			"trait.clumsy",
			"trait.fat",
			"trait.tiny",
			"trait.hesitant",
			"trait.bleeder",
			"trait.dastard",
			"trait.asthmatic"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(1, 3);
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
		return "{%name%出生在远离他父亲家的一场激烈的军事行动中。 | %name%的母亲来自%randomtown%的一家酒馆。这很稀奇，因为他的父亲是%townname%的已婚王室成员。 | 由于妻子被女巫诅咒，%name%的父亲把自己交给了另一个女人来“延续”血脉。 | 国王离开太久了，让%name%的王后母亲再也抗拒不了本地侍从的诱惑。 | %name%是在掠袭者掠袭他父母的城堡九个月后出生的。}{一个私生子的生活并不容易：他经常被嫉妒的半血亲兄弟们追杀。 | 就像某种王室麻风病患者一样，这个私生子被隔离在公众视线之外。 | 谢天谢地，%name%一生中大部分时间都不知道自己是个私生子。 | %name%一出生就饱受争议，直到当地一位神谕祭司的预言才使他免于被遗弃。 | 作为王室私生子，只要他保持低调，淡化他不被欢迎的身份，这个人的生活还是相当不错的。 | 来自陌生人和家人的仇恨予以这个私生子锤炼，以面对皇室教育之外未来可能的艰难险阻。}{对自己在生活中所扮演的角色感到愤怒，%name%确实试图发动政变夺取王位。事情并没成。他现在被所有宫廷驱逐。 | 当一个同父异母的兄弟向他扔石头时，%name%毫不后悔地用剑刺穿了这个亲属。他把责任推给了一个仆人，但很快就离开了他的王室住所。 | %name%的父亲试图给他伪造出合法的子嗣身份，但是一次皇室婚姻的失败以及不当行为的丑闻使得这一计划难以为继。现在这个私生子已经自由地漫游于这片土地上，摆脱了争议的束缚。 | 作为长子，%name%成为了婚生弟弟们的攻击目标。离开那种充斥着政治和暗箭伤人的生活是一个轻松的选择。 | 在与半血亲的妹妹同床共枕被发现后，%name%生活中越来越多的丑闻迫使他最终无法留在宫廷之中。 | 在厌倦宫廷内的琐事后，%name%只希望加入一群不在意血统和合法性的男人。 | 当一个刺客在他父亲的酒里下毒后，%name%很快就被认为是谋杀的罪魁祸首。逃离愤怒的暴民只是一段激动人心的新生活的开始。 | 虽然%name%的父亲非常爱他，但他知道王室并不安全。他打发走了%name%，让他去打造自己想要的生活。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				-5,
				-5
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				5,
				10
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				-5,
				5
			],
			RangedDefense = [
				0,
				0
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

		if (this.Math.rand(0, 4) == 4)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.BastardTitles[this.Math.rand(0, this.Const.Strings.BastardTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/falchion"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/shortsword"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/hand_axe"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/shields/wooden_shield"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/padded_leather"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/basic_mail_shirt"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}

		r = this.Math.rand(0, 3);

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
			items.equip(this.new("scripts/items/helmets/hood"));
		}
	}

});
