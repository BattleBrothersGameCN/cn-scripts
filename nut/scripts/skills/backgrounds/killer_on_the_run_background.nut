this.killer_on_the_run_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.killer_on_the_run";
		this.m.Name = "在逃杀人犯";
		this.m.Icon = "ui/backgrounds/background_02.png";
		this.m.BackgroundDescription = "在逃杀人犯不吝杀人，也知道该怎么杀。";
		this.m.GoodEnding = "你总爱冒险，即便%name%是个在逃杀人犯，你也让他加入了%companyname%的行列。如你所愿，他的确是个勇敢能干的佣兵。据你所知，他仍在战团里，充分享受着每个“干活儿”的机会。";
		this.m.BadEnding = "很多人对雇佣%name%这样的在逃杀人犯有所顾虑，但事实证明，他确实是个出色的佣兵。不幸的是，躲得过初一躲不过十五，赏金猎人们趁着夜色绑走了他。他的骸骨现在挂在三丈高的绞刑架上。";
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
			"背藏刀(Backblade)",
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
		return "{%fullname%有张没有人想要的脸 —— 通缉令上的脸。 | 手上沾着鲜血的%name%很像赏金猎人跟你说的那个人。 | %name%愿意加入任何组织 ， 或者说消失在其行列中。 | %name%介绍自己的时候结结巴巴的，就怕说出去再也收不回来了。}{认出%name%并不难：这人是众所周知的杀人犯，手上沾满了出轨妻子和她情人的鲜血。 | 他的眼睛深邃且变幻莫测。目光中藏着犯罪感，但也透露出一丝人性，好像他知道自己做错了事，并正在试图弥补过失。 | 他的腿上结满了泥巴。他已经跑了很久。他的手也在颤抖，看来他的腿是为了跑离他的手。 | 人们说他杀死了自己的新生女儿，他一直想要个儿子。 | 有人认为他是出于自卫才击倒了一个人。 | 鉴于他受到的诽谤勒索，你很难把他的所作所为怪到他头上。}{他做的错事并不会妨碍他加入到一群“杀手”中间。但他值得信任吗？ | 当你问他会不会使用武器时，%name%眼神躲躲闪闪，咕哝着说，打“那个人”一下就知道了。 | %name%壮实的体格肯定能派上用场，但你指望得上一个习惯了逃跑的人吗？ | 这个人像海狸啃树一样啃着他的指甲。他很神经质，但在这个世界上这也许是件好事。 | 佣兵团正适合他这样的人。}";
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
