this.tailor_southern_background <- this.inherit("scripts/skills/backgrounds/tailor_background", {
	m = {},
	function create()
	{
		this.tailor_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernThick;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.Ethnicity = 1;
		this.m.Excluded = [
			"trait.superstitious",
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
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{%name%一直对织物很好奇，他认为在亚麻布中看到的科学要比{一个占卜师在沙漠的沙子里看到的要多。 | 一个肠卜师从蟾蜍的内脏里看到的要多。 | 一个炼金术士在研钵和研杵中看到的要多。} | %name%从小到大一直是一个古怪的男孩，他喜欢漂亮的丝绸衣服，而不是衣服之下的女孩。 | 作为{屠夫 | 士兵}的儿子，%name%转向时装设计让所有人都感到意外。 | 当%name%的兄弟们幻想成为战士和英雄时，%name%却认为自己将来会成为维齐尔的打扮师。 | %name%的大部分青春时光都是在女孩的陪伴下度过的，但并不是出于人们可能会想到的原因。 | %name%总是喜欢动物，尤其喜欢它们做大衣或围巾的样子。 | 随着束腰外衣和衬衫越来越受欢迎，%name%开始做裁缝来赚取一两个克朗。 | 随着马裤的流行，%name%为了赚更多的钱从皮匠变成了裁缝。 | 裁缝是一门关于颜色和面料的科学，%name%以此著称。 | %name%擅长测量和计算，他把自己的数学才能用在裁缝业上，尽可能多地赚钱。 | %name%从事裁缝业是为了纪念他的父亲 —— 被一位不满的顾客杀害的裁缝。 | %name%的母亲在战争中丧偶，她教他如何更好地利用双手去做裁缝，而不是去杀人。}{当游牧民袭击他的家时，%name%给每个人都做了巧妙的伪装。镇子被摧毁了，但没有一个人丧命。 | 他花了很多年时间为王室成员搭配服装，直到一次时尚失误导致他被流放。 | 不幸的是，像%name%喜欢做的那样，一个男子追求好布料这种情况让这位裁缝被许多村庄排斥。 | 他试图在城市闯出一片天来，但遗憾的是，他无法与其他裁缝竞争。 | 当一个维齐尔组织一支军队时，%name%负责服装，给应征兵们穿上合适的制服。 | 但是裁缝之间的激烈竞争最终产生了一个裹着亚麻布的死者，%name%同时离开了他的商店。 | 他曾经用一束测量线把一个想偷东西的人勒死了。总之他是这么说的。 | 有一次，%name%受命制作一件绣有史诗壮举的束腰外衣，他不禁想知道外面的世界到底是什么样子。 | 在设计一件饰有{史诗般探险 | 史诗般壮举}的衣服时，%name%想到也许应该由他自己成为编织故事的那个人。}现在，这位裁缝正在寻找一种新的生活，无论它会把他带到哪里。{也许他能把部队打扮得漂漂亮亮什么的。 | 他很挑剔而独特，对每个人的衣着都吹毛求疵。 | 他并不是个天生的士兵，但他会以仿佛要对它开战的作态评估一个人的着装。 | 从他测量和计算着装的方式来看，很遗憾%name%不是一个攻城工程师。 | 虽然算不上是个士兵，但%name%对裁缝的真诚热爱值得赞赏。 | %name%对各种布料的了解令人印象深刻。 | %name%有点难说，他的脚法像个剑士，剑术却像阵软风一般温和。 | %name%穿着盔甲看起来很不合适，但是他迫切需要一套。 | 事实证明，%name%真的可以用母猪耳朵做一个丝绸钱包。 | 别让他的职业愚弄了你，%name%的手比一些{玩牌手 | 杂耍者 | 扒手}还强。 | 裁缝似乎不适合战斗，但话说回来，你现在遇到的大多数男人也不适合。 | 裁缝似乎不适合上战场，但不知为什么，你总能在最奇怪的地方找到最优秀的士兵。 | %name%非常善于{计算 | 测量}，他比第一眼看上去要聪明得多。}";
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}
		else
		{
			items.equip(this.new("scripts/items/armor/oriental/cloth_sash"));
		}

		r = this.Math.rand(1, 4);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/feathered_hat"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/oriental/southern_head_wrap"));
		}
	}

});
