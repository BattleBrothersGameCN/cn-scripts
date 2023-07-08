this.nomad_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.nomad";
		this.m.Name = "游牧民";
		this.m.Icon = "ui/backgrounds/background_63.png";
		this.m.BackgroundDescription = "任何一个在沙漠中生存下来的游牧民都会有一些战斗的经验。";
		this.m.GoodEnding = "游牧民%name%在你离开几个月后也离开了%companyname%。他显然去了南方，现在领导着他们所谓的“腿上之城” —— 一支漫游于沙漠中的巨大人群。这个社会显然非常富裕和成功，以至于维齐尔们担心自己的人民会涌去那里。";
		this.m.BadEnding = "你获悉游牧民%name%离开了战团，希望能够找到新的平原漫游。显然，他萌生了远行至北方并与那里的野蛮人和平共处的念头。值得称赞的是，除了一些外在的相似之处，野蛮人和游牧民还分享着相似的生活方式、文化、语言、宗教、法律、斗争、冲突和一些其他方面。这位游牧民在进入野蛮人的营地后几乎立即被屠杀，他的遗体在一场战士仪式中被吃掉。";
		this.m.HiringCost = 200;
		this.m.DailyCost = 28;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.weasel",
			"trait.hate_undead",
			"trait.night_blind",
			"trait.ailing",
			"trait.asthmatic",
			"trait.clubfooted",
			"trait.hesitant",
			"trait.loyal",
			"trait.tiny",
			"trait.fragile",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.dastard",
			"trait.insecure"
		];
		this.m.Titles = [
			"沙漠掠袭者(the Desert Raider)",
			"·沙漠(of the Desert)",
			"沙漠之子(Son of the Desert)",
			"沙漠之灾(the Desert Scourge)",
			"蝎子(the Scorpion)",
			"游牧民(the Nomad)",
			"红沙(Redsands)",
			"鬣狗(the Hyena)",
			"鹰(the Hawk)",
			"大蛇(the Serpent)",
			"自由者(the Free)",
			"流浪者(the Wanderer)",
			"拦路者(the Waylayer)"
		];
		this.m.Bodies = this.Const.Bodies.SouthernMuscular;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.BeardChance = 90;
		this.m.Ethnicity = 1;
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
		this.m.Level = this.Math.rand(2, 4);
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
		return "{和许多南方人一样，%name%是在沙漠中长大的，在沙丘上游荡，拦截商队和迷路的旅行者。 | %name%出生于南方众多的沙漠部落之一，在学会任何其他知识之前就学会了沙漠的生存之道。 | 游牧民遍布南部沙漠，%name%就是在这些游牧民中出生的。 | 真正的游牧民在南方的城市中很少见，%name%也不例外。 | 你很少见到游牧民族离开他们南方沙漠沙丘这些环境，但%name%站在那里，皮肤黝黑，全身是沙。}{然而，游牧政治有点复杂。某件事使他来到城里找工作，但这个从游牧民变成佣兵的人拒绝解释这件事。 | 他部落的规矩是，每三个儿子中必须有一个出去看世界，如果他太想回去也行。所以，%name%就在这里了。 | 因被指控与一个没有正式给予他的女人有不当关系，%name%面临着被处死或被部落驱逐的选择。他还站在你面前喘着气，暗示了他选择了什么。 | 由于欠了赌债，这个游牧民谋杀了他的一个部落同胞，被驱逐出了他的部落。 | 但由他负责策划的一场灾难性的伏击，令他被赶出了自己的部落。 | 然而这个游牧民希望看到更多的世界，看到自己在部落中难以体现的优点，于是他离开了自己的部落，前往城市寻求冒险性的工作。}{这个游牧民站在你的面前，身上尽显他的成长经历：肤色暗沉，眼睛深黑，手掌磨砂粗糙。如果他还不是个战士，他很可能会在时间的磨练下成为一个战士。 | 作为一个生活在难以忍受的南方沙漠的人，这个游牧民身体素质自然准备好承担出卖武力的任务并不奇怪。而技能如何则完全是另一回事了。 | 在沙漠中冒险的人都适应力很强，%name%也不例外。 | 像%name%这样的游牧民的战斗经验主要来自伏击商队。这在雇佣兵团中是有用的，尽管前线工作与拦路袭击穷商人有很大的不同。 | %name%完全符合你对南方的期待：被沙子磨砺，但是有着迎接挑战和未来的一切的体质。 | %name%现在很可能还不是个受训且技艺高超的战士，但作为一个来自南方荒原的男人，毫无疑问他有着勇士的心灵和精神。}";
	}

	function updateAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");

		if (tattoo_body.HasBrush)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
		}
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				0,
				-3
			],
			Stamina = [
				2,
				0
			],
			MeleeSkill = [
				12,
				10
			],
			RangedSkill = [
				5,
				0
			],
			MeleeDefense = [
				6,
				5
			],
			RangedDefense = [
				6,
				5
			],
			Initiative = [
				0,
				0
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/falchion"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/oriental/saif"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/oriental/nomad_mace"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/oriental/light_southern_mace"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/weapons/militia_spear"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/shields/oriental/southern_light_shield"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/oriental/nomad_robe"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/oriental/thick_nomad_robe"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/oriental/stitched_nomad_armor"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/oriental/leather_nomad_robe"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/oriental/nomad_head_wrap"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/oriental/nomad_leather_cap"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/oriental/nomad_light_helmet"));
		}
	}

});
