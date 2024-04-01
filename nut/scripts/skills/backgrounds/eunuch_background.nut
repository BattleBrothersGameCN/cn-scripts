this.eunuch_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.eunuch";
		this.m.Name = "阉人";
		this.m.Icon = "ui/backgrounds/background_52.png";
		this.m.BackgroundDescription = "阉人能不能有孩子不在战团的优先考虑之列。";
		this.m.GoodEnding = "%name%总觉得短点儿什么。但这并不影响这个阉人享受生活。他带着一大堆克朗从%companyname%退休，不受女色吸引，过上了美好而极其专注的生活。";
		this.m.BadEnding = "据说，在你离开战团不久后，阉人%name%也离开了，他流浪四方，一贫如洗，将仅剩的钱花在酒和妓女身上。妓女笑他没有老二，被激怒的阉人借着酒劲，用一只山羊角刺穿了她的眼。治安官找到他时，他还没醒酒。最终，在惊骇和困惑当中，他被当地人扒光、绞死、肢解喂猪。";
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
		return "{当%name%还是个孩子的时候，当地的牧师就阉割了他，好让他带动合唱团里的高声部。 | 掠袭者入侵他的村庄时，%name%奋起反抗，结果被赏了个鸡飞蛋打。 | %name%被控没有征得女人的同意就和她上了床。要么死，要么阉，你不需要物证就能知道他选了哪一个。 | %name%曾经是一名受训僧侣，据说他和异教女人上了床。被逐出了教派之后，为了重获他们的同情，他自愿上交了“作案工具”。看来信徒们并不欢迎他回去。 | %name%小时候，他醉酒的{母亲 | 父亲 | 姐姐 | 哥哥}用{热锅 | 锯齿状的刀子}{在他睡觉时杀向了他的老二 | 对他的下体进行残忍的折磨}。 | %name%穿越%townname%附近的森林时，受到了{野猪 | 熊 | 野狗 | 鹰}的攻击，扯下了他身上一大块肉。他虽然幸存下来，但后来才意识到，这只野兽也阉割了他。 | %name%来自%randomtown%的妓院，为了满足特定客人的要求，他的身体被割掉了一部分。}{当你碰见他时，他正在四处漂泊。现在看来，他只是想远离这个世界，即便这意味着加入{佣兵 | 雇佣军}的行列。虽然你不愿看到他的困境复现在别人身上，但他实在是相当冷静。 | 你发现他的时候，他正被孩子欺负。看到你的剑，他礼貌地请求加入你的队伍 —— 一个不在乎人的过去或是身体残缺的地方。他已经习惯了生活中的挣扎，或许是以大多数男人无法理解的方式。 | 令人意外的是，这人站得比大多数人还要直。对于一个失去了如此珍贵的东西的人来说，他看起来相当平和镇定。 | 这个男人过去的恐怖遭遇令你毛骨悚然，胯下一紧，但这个阉人似乎并不为自己所经历的事情感到困扰。他是一个冷静静、甚至有些被动的人物。 | 这个人的一举一动比你见过的大多数僧侣还要冷静。他似乎能和自己惨痛的过去和平共处。 | 不再有肉欲需要满足，这个人似乎变得相当平静，甚至可以说是坚定，看待事物远比其表象更深。}";
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
