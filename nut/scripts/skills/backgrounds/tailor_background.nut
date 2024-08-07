this.tailor_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.tailor";
		this.m.Name = "裁缝";
		this.m.Icon = "ui/backgrounds/background_48.png";
		this.m.BackgroundDescription = "裁缝不习惯艰苦的体力劳动。";
		this.m.GoodEnding = "一名裁缝身在佣兵战团能做什么？问得好，但%name%杀够了一条史诗挂毯都织不尽的敌人，很好地回答了这个问题。在战团度过了几年好时光后，他最终离开，创业为贵族制作服装。他世界闻名，至少是在已知的世界上闻名，他现在的生意很好，赚了一大笔钱。";
		this.m.BadEnding = "一心想当裁缝的%name%没怎么犹豫就离开了日薄西山的战团。他离开战团打算创业，但途中却被一个强盗团伙绑架。当他们威胁要杀他时，他伪装成一个单纯而又虚弱的裁缝，并展示了他在制作服装方面的才华。这些衣衫褴褛的强盗们对他产生了兴趣，并接纳他成为他们团队的一员。几天后，他们全部被杀，而这个“温顺”的人则带着一点点红印子走出了他们的营地。一周后，他开始了自己的生意，并至今生意兴隆。";
		this.m.HiringCost = 50;
		this.m.DailyCost = 5;
		this.m.Excluded = [
			"trait.huge",
			"trait.hate_undead",
			"trait.athletic",
			"trait.deathwish",
			"trait.clumsy",
			"trait.fearless",
			"trait.spartan",
			"trait.brave",
			"trait.iron_lungs",
			"trait.strong",
			"trait.tough",
			"trait.cocky",
			"trait.dumb",
			"trait.brute",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"精打细算者(the Peculiar)",
			"裁缝(the Tailor)",
			"讲究者(The Particular)",
			"妙手(the Fine)",
			"蚕(Silkworm)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Thick;
		this.m.IsLowborn = true;
	}

	function onBuildDescription()
	{
		return "{%name%一直对织物很好奇，他认为他从亚麻布中看到的科学要比{占卜师在沙漠的沙子里看到的要多。 | 肠卜师从蟾蜍的内脏里看到的要多。 | 炼金术士从杵臼中看到的要多。} | 从小到大，%name%一直是一个古怪的男孩，他喜欢漂亮的丝绸衣服，而不是衣服之下的女孩。 | 作为{矿工 | 乡绅 | 骑士 | 农夫}的儿子，%name%转向时装设计让所有人都感到意外。 | 当%name%的姐妹们幻想成为战士和英雄时，%name%却认为自己将来会成为宫廷服装师。 | %name%的大部分青春时光都是在女孩的陪伴下度过的，但并不是出于人们会想到的那个原因。 | %name%一直到喜欢动物，尤其喜欢它们做成大衣或围巾的样子。 | 随着束腰外衣和衬衫越来越受欢迎，%name%开始做裁缝赚点小钱。 | 随着马裤的流行，想要多赚钱的前皮匠%name%转行成了裁缝。 | %name%来自一个遥远的国度，在那里男人的穿着比他的武艺更重要。 | 裁缝是一门关于颜色和面料的科学，%name%正是以此著称。 | %name%擅长测量和计算，他把自己的数学才能用在裁缝业上，尽可能多地赚钱。 | %name%的裁缝生涯，始于母亲为躲避贵族征兵，强迫他从事这一职业。 | %name%从事裁缝业是为了纪念他的父亲 —— 被一位不满的顾客杀害的裁缝。 | %name%的母亲在战争中丧偶，她教他如何更好地利用双手去做裁缝，而不是去杀人。}{当掠袭者袭击他的家乡时，%name%给每个人都做了巧妙的伪装。镇子被摧毁了，但没有一个人丧命。 | 他花了很多年时间为王室成员搭配服装，直到一次时尚失误导致他被流放。 | 不幸的是，像%name%这样追求好布料的男子，受到了许多村庄的排挤。 | 他试图在大城市闯出一片天来，但遗憾的是，他无法与其他裁缝竞争。 | 当一个领主组织一支军队时，%name%负责服装，给士兵们穿上合适的制服。 | 但是裁缝之间的激烈竞争到了死人的地步，巧的是%name%正是这时候离开了他的店。 | 不幸的是，强盗们洗劫了他的商店，再加上战争还在继续，他不可能再进货了。 | 但当他剪了一只不属于他的羊的毛时，%name%被赶出了镇子。 | 他曾经用测量线把一个想偷东西的人勒死了。反正他自己是这么说的。 | 但是，给不讨喜和不友善的贵族折腾衣服最终{让他厌烦了。 | 让他精疲力尽了。} | 有一次，%name%受命制作一件绣有史诗壮举的束腰外衣，他不禁想知道外面的世界到底是什么样子。 | 在设计一件饰有{史诗般探险 | 史诗般壮举}的衣服时，%name%想到也许应该由他自己成为编织故事的那个人。}现在，这位裁缝正在寻找一种新的生活，无论它会把他带到哪里。{也许他能把部队打扮得漂漂亮亮什么的。 | 他挑剔而讲究，对每个人的衣着都吹毛求疵。 | 他不是个天生的士兵，但他会以仿佛要对它开战的作态评估一个人的着装。 | 从他测量和计算着装的方式来看，很遗憾%name%不是一个攻城工程师。 | 虽然难说的上是个士兵，但%name%对裁缝的真诚热爱值得赞赏。 | %name%对各种布料的了解令人印象深刻。 | %name%有点难说，他的脚法像个剑士，剑术却像轻风一般温和。 | %name%和盔甲非常不搭，但是他迫切需要一套。 | 事实证明，%name%真的可以用母猪耳朵做一个丝绸钱包。 | 别被他的职业糊弄了，%name%的手比一些{牌手 | 杂耍者 | 扒手}还强。 | 裁缝似乎不适合战斗，但话说回来，你现在遇到的大多数男人都不适合。 | 裁缝似乎不适合上战场，但不知为什么，你总能在最奇怪的地方找到最优秀的士兵。 | %name%非常善于{计算 | 测量}，他比第一眼看上去要聪明得多。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-3,
				0
			],
			Bravery = [
				0,
				0
			],
			Stamina = [
				-5,
				-5
			],
			MeleeSkill = [
				0,
				0
			],
			RangedSkill = [
				0,
				0
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
		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/feathered_hat"));
		}
	}

});
