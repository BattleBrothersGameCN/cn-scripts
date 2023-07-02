this.killer_on_the_run_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.killer_on_the_run";
		this.m.Name = "在逃杀人犯";
		this.m.Icon = "ui/backgrounds/background_02.png";
		this.m.BackgroundDescription = "一个在逃杀人犯可能会再次杀人，他知道该瞄准哪里。";
		this.m.GoodEnding = "你总是一个冒险家，即便%name%是一个在逃杀人犯，你也让他加入了%companyname%的行列。这对你是有利的，因为他证明了自己是个能干勇敢的佣兵。据你所知，他仍然在战团里，充分享受战团提供给他的每一个“商业”机会。";
		this.m.BadEnding = "虽然很多人对雇佣像%name%这样的在逃杀人犯的风险有所顾虑，但这个人确实证明了自己是一个非常有能力的佣兵。不幸的是，旧生活总是紧随其后，赏金猎人们在夜间绑走了他。你可以在空中五十英尺高的绞架上找到他的骸骨。";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.teamplayer",
			"trait.hate_undead",
			"trait.lucky",
			"trait.clubfooted",
			"trait.cocky",
			"trait.clumsy",
			"trait.loyal",
			"trait.hesitant",
			"trait.bright",
			"trait.brave",
			"trait.determined",
			"trait.deathwish",
			"trait.fainthearted",
			"trait.craven",
			"trait.fearless",
			"trait.optimist"
		];
		this.m.Titles = [
			"黑心者(Darkhearted)",
			"背刃(Backblade)",
			"割喉(Throatslash)",
			"在逃者(on the Run)",
			"通缉犯(the Wanted)",
			"凶手(the Murderer)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
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
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/chance_to_hit_head.png",
				text = "更高几率击中头部"
			}
		];
	}

	function onBuildDescription()
	{
		return "{%fullname%有张没有人想要的脸 —— 一张适合通缉令的脸。 | 手上沾着鲜血的%name%很像赏金猎人最近向你描述的那个人。 | %name%似乎随时准备加入任何组织 —— 或者消失在其行列中。 | 在见到人时，%name%结结巴巴地说出自己的名字，好像不愿轻易透露出来。}{认出%name%并不是一件难事：这人是众所周知的杀人犯，他手上沾满了出轨妻子和她情人的鲜血。 | 他的眼睛深邃且变幻莫测。目光中蕴藏着一种犯罪感，但也透露出一丝人性，好像他知道自己做错了事，并正在试图弥补过失。 | 他的腿上沾满了泥巴。他已经跑了很长时间了。他的手也在颤抖，因为他的腿正因他手所做的事而奔跑。 | 他们说他杀死了自己刚出生的女儿，因为他一直想要一个儿子。 | 有人认为他是出于自卫才击倒了一个人。 | 由于他受到诽谤信息的勒索，你很难对他所做的事进行责怪。}{即使他做了错事，一群杀手也会需要像他这样的人。但这个人可以信任吗？ | %name%避开了你的目光当你问他是否知道如何使用武器时，他咕哝着说只要打一次“那个人”就行了。 | 一个拥有%name%这样体格的人是有用的，但是你能在多大程度上依靠一个前半生一直在逃亡的人呢？ | 这个人啃着他的指甲，就像海狸啃树一样。他很神经质，但在这个世界上这也许是件好事。 | 像他这样的人最适合雇佣兵团了。}";
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
				4,
				0
			],
			RangedSkill = [
				2,
				3
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
				0,
				5
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/dagger"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}

		r = this.Math.rand(1, 2);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.HitChance[this.Const.BodyPart.Head] += 10;
	}

});
