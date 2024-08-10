this.assassin_southern_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.assassin_southern";
		this.m.Name = "刺客";
		this.m.Icon = "ui/backgrounds/background_53.png";
		this.m.BackgroundDescription = "刺客必须腿脚利索，精于武器使用。";
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
			"影子",
			"刺客",
			"潜伏者",
			"背刺者",
			"无形者",
			"杀手",
			"匕首",
			"莫测"
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
		return "{起初你并没有多想，毕竟%name%长得和每个平凡人都差不多。普通得很。再普通不过的一个人。 | %name%的面容就像是你见过的每个人长在了一起。你总是记不清这张脸。 | %name%笑容可亲，举止得体。面对任何人都能做到不卑不亢，平衡着看待富人和穷人的观点，调整着自己在中间的位置。 | %name%没有什么能让人再看一眼的点，简单得不能再简单，注定要成为这个世界的一部分。}{当然了，这都是设计好的。他是一家老练杀手组成的行会派来的。他随身携带的卷轴建议你 —— 并没有威胁的意思，雇佣他。 | 这个不起眼的存在实际上是一名训练有素的刺客，随身携带着他工会独有的刺杀匕首。 | 然而，这张平淡无奇的脸却藏着凶残的过去，他随身携带的刺杀匕首只被南方的刺客工会授予给最好的杀手。 | 但那张“熟悉的陌生人”的脸只是一种伪装，旨在掩盖他来自一家刺客行会的事实，而他被派来的原因你可能永远都不会知道。}{%name%可以就站在你的旁边，而让你感觉他已经消失在只有两个人的人群中了。 | 尽管你知道你是第一次见到%name%，但你还是忍不住觉得在哪里见过他。 | 在%name%身边，你自然而然地就会感到放松，简直就像是有谁给你设了个局，所以，只要他在你身边，你就会强迫自己保持警惕。}";
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
