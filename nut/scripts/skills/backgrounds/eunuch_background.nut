this.eunuch_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.eunuch";
		this.m.Name = "阉人";
		this.m.Icon = "ui/backgrounds/background_52.png";
		this.m.BackgroundDescription = "阉人不能有孩子这件事可能不是佣兵战团首要考虑的。";
		this.m.GoodEnding = "对于%name%来说，有些事情总是有点短缺。但这并没有阻止这个阉人享受生活。他带着一大堆克朗从%companyname%退休，且完全没有被女性吸引，这个人过上了美好而极其专注的生活。";
		this.m.BadEnding = "据说阉人%name%在你离开战团不久后也离开了，他流浪四方，一贫如洗，将仅剩的克朗用于酒和妓女。由于被妓女侮辱老二的缺失，这个醉酒又暴怒的太监用山羊角刺进那女人的眼睛。这个困惑和惊骇的太监在治安官发现他时仍然醉着，最终被当地人剥光、绞死并肢解喂猪。";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.weasel",
			"trait.lucky",
			"trait.cocky",
			"trait.athletic",
			"trait.brute",
			"trait.bloodthirsty",
			"trait.deathwish",
			"trait.impatient"
		];
		this.m.Titles = [
			"阉人(the Eunuch)",
			"去势者(the Gelding)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.YoungMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = null;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.IsOffendedByViolence = true;
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
		return "{当%name%还是个孩子的时候，当地的一位牧师阉割了他，让他的嗓音能在当地的合唱团中音调更高。 | 当掠袭者入侵他的村庄时，%name%奋起反抗，结果他的老二和蛋蛋被从他身上割下来作为惩罚。 | %name%被指控在一名不情愿的女人的床上犯下了可恶的罪行，他面临着死亡或成为一名阉人的选择。你不需要物证就能知道他选了哪一个。 | %name%曾经是一名正在接受训练的僧侣，据说他和一个信仰不同的女人上床了。他被驱逐出了教派，为了重新获得他们的同情，这名男子去掉了犯下冒犯之罪的“设备”。看来信徒们并不欢迎他回来。 | 在%name%小时候，他醉酒的{母亲 | 父亲 | 姐姐 | 哥哥}用{热锅 | 锯齿状的刀子}{在他睡觉时杀向了他的老二 | 对他的下体进行残忍的折磨}。 | 当%name%穿过距%townname%不远的森林时，他被{野猪 | 野熊 | 野狗 | 野鹰}攻击，扯下了他身上一大块肉。他虽然幸存下来，但后来才意识到这只野兽也阉割了他。 | %name%来自%randomtown%的妓院，他的身体曾被毁损以满足某位特定客人的要求。}{当你碰见他时，他正在四处漂泊。现在看来，他只是想远离这个世界，即使这意味着加入{佣兵 | 雇佣军}的行列。虽然他的困境是你不希望发生在任何人身上的，但他是个相当冷静的伙计。 | 你发现他的时候发现他正在被孩子欺负。看到你的剑，他礼貌地请求加入你的队伍 —— 一个人的过去或身体残缺都不重要的地方。他已经习惯了生活中的挣扎，或许是以大多数男人无法理解的方式。 | 令人惊讶的是，这个人站得比大多数人都直。对于一个失去了如此珍贵的东西的人来说，他看起来相当平静和镇定。 | 虽然这个男人过去的恐怖遭遇令你毛骨悚然，让你感觉下体几乎要缩起来，但这个阉人似乎并不为自己所经历的事情感到困扰。他是一个镇静、几乎被动的人物。 | 这个人的动作比你见过的大多数僧侣都更冷静。他似乎能和自己惨痛的过去和平共处。 | 不能再满足他的肉欲后，这个人似乎变得相当平静。甚至是坚定，并看待事物看到得比其的表象更多。}";
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
				-5,
				-5
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
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}
	}

});
