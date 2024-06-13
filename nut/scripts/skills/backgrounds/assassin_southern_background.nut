this.assassin_southern_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.assassin_southern";
		this.m.Name = "刺客";
		this.m.Icon = "ui/backgrounds/background_53.png";
		this.m.BackgroundDescription = "一个刺客必须腿脚利索且精于武器使用。";
		this.m.GoodEnding = "刺客%name%带着一大箱子的黄金离开了%companyname%远走他乡。 你听说，他在南方王国的东部山脉中建造了一座城堡。你不确定此事的真假，但维齐尔和领主的死亡率开始稳步上升。";
		this.m.BadEnding = "你从%companyname%退休后不久，%name%就消失了。这名刺客也许不想被人找到，他的位置也实在无法预料。说实话，你希望自己从没雇佣过他。说不定他要杀的就是你，这个恐怖的想法在你的脑海中挥之不去，你常常睡不合眼，寻找带着弯刃匕首的黑衣人。";
		this.m.HiringCost = 800;
		this.m.DailyCost = 25;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.huge",
			"trait.weasel",
			"trait.teamplayer",
			"trait.night_blind",
			"trait.clubfooted",
			"trait.brute",
			"trait.dumb",
			"trait.loyal",
			"trait.clumsy",
			"trait.fat",
			"trait.strong",
			"trait.hesitant",
			"trait.insecure",
			"trait.short_sighted",
			"trait.bloodthirsty"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Fatigue
		];
		this.m.Titles = [
			"影子(the Shadow)",
			"刺客(the Assassin)",
			"潜伏者",
			"背刺者(the Backstabber)",
			"无形者(the Unseen)",
			"凶手(the Murderer)",
			"匕首(the Dagger)",
			"莫测(the Elusive)"
		];
		this.m.Bodies = this.Const.Bodies.SouthernSkinny;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.SouthernYoung;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.Ethnicity = 1;
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
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
		return "{刚见到%name%时，你不会觉得他有什么特别，很普通。仅仅是一个普普通通的人 | %name%看上去几乎就是你所见过的所有男人的集合体。他长着一张你永远不会记下的脸。 | %name%有着温和的微笑和风度。他和所有人平等相处、交谈，似乎在衡量自己与富人和穷人之间的观点权重。 | %name%没有什么能让人再看一眼的点，就是一个简单的人，注定要成为这个世界的一部分。}{当然，这一切都是有意设计的。他是一名受训杀手行会派来的刺客。他随身携带的卷轴表明，你可以毫无风险地雇用他。 | 这个不起眼的存在实际上是一名训练有素刺客的伪装身份，手里拿着来自他行会的卡塔尔匕首，独一无二的那种。 | 然而，一张平淡无奇的脸却有着凶残的过去，因为这个男人手里拿着一把卡塔尔匕首 —— 只有南方刺客行会中最优秀的杀手才能持有。 | 但那张“熟悉的陌生人”的脸是装出来的，旨在掩盖他来自一家刺客行会的事实，而他被派来的原因你可能永远都不会知道。}{%name%可以就站在你的旁边，而让你感觉他已经消失在只有两个人的人群中了。 | 尽管你知道你直到现在才见过这个人，但你还是忍不住觉得你以前在什么地方见过%name%。 | 在%name%身边，你自然而然地感到轻松自在，这本质上几乎就像是一种设置，所以反过来，你强迫自己在他身边时保持警惕。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-5,
				-5
			],
			Bravery = [
				10,
				10
			],
			Stamina = [
				-5,
				-5
			],
			MeleeSkill = [
				10,
				10
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				5,
				8
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				20,
				15
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
			items.equip(this.new("scripts/items/weapons/oriental/qatal_dagger"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/dagger"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/tools/smoke_bomb_item"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/tools/daze_bomb_item"));
		}

		r = this.Math.rand(1, 2);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/oriental/thick_nomad_robe"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/oriental/assassin_robe"));
		}

		items.equip(this.new("scripts/items/helmets/oriental/assassin_head_wrap"));
	}

});
