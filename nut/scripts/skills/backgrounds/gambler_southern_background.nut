this.gambler_southern_background <- this.inherit("scripts/skills/backgrounds/gambler_background", {
	m = {},
	function create()
	{
		this.gambler_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernThick;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.Ethnicity = 1;
		this.m.BeardChance = 90;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.huge",
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.hate_beasts",
			"trait.paranoid",
			"trait.brute",
			"trait.athletic",
			"trait.dumb",
			"trait.clumsy",
			"trait.loyal",
			"trait.craven",
			"trait.dastard",
			"trait.deathwish",
			"trait.short_sighted",
			"trait.spartan",
			"trait.insecure",
			"trait.hesitant",
			"trait.strong",
			"trait.tough",
			"trait.bloodthirsty"
		];
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{人们都说运气是魔鬼，那么像%name%这样的赌徒能玩多久呢？ | 每个人都会赌博，所以%name%觉得干嘛不为钱而赌呢？ | 骰子，纸牌，弹珠 —— 有很多赚取别人钱的方法，而%name%全都知道。 | %name%有着沙漠蛇一样的眼睛 —— 而操弄纸牌就是他的特长。 | 在生死存亡的世界里，冒险成为了%name%的游戏。 | 像%name%这样的人能预见一切，尤其是牌堆下一张牌的情况。}{他从一个镇打牌打到另一个镇来维持生计，只有在把他们的口袋里的钱都掏光后才离开。 | 但是，一个人是如何决定把打牌作为一种生活方式的，这是一个谜。 | 雇佣兵的不断进进出出使他们成为了很容易的目标 —— 直到一个输不起的人用一把手半剑把他赶走。 | 他生来就是孤儿，总是靠与人赌博为生。 | 当他还是个孩子的时候，一个骗子的杯子游戏让他明白了诈骗的价值。 | 当他的父亲陷入赌债时，他想到最好的还债方式是成为一个更好的骗子。 | 在拿走他们所有的克朗后，各地封杀了%name%的赌博生涯，以所谓的“宗教复兴”之名。}{现在，这个赌徒想要把他的骰子扔到风中 —— 以及泥中，与任何愿意愿意付钱的人为伍。 | 人们不禁要问，打牌的人不打牌是在干什么。不过话说回来，也许他把你的团队看作场聪明的赌博是件好事。 | 也许多年来欺骗雇佣兵的经历让他觉得自己也可以轻而易举地成为一名雇佣兵。 | 机智而反应迅速的牌术大师凭借比别人行动更快为生，这是种与世上其他任何技能一样有用的技能。 | 具有讽刺意味的是，一次糟糕的下注让他欠下了一位男爵的巨额债务。现在他得另想办法还债了。 | 战争已经榨干了他卡牌游戏的大多数目标。他觉得与其无所事事等待，还不如直接紧跟时事。}";
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/noble_tunic"));
		}
		else
		{
			items.equip(this.new("scripts/items/armor/oriental/cloth_sash"));
		}
	}

});
