this.gambler_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.gambler";
		this.m.Name = "赌徒";
		this.m.Icon = "ui/backgrounds/background_20.png";
		this.m.BackgroundDescription = "赌徒往往比牌桌上的对手反应更迅速、决心更坚定。";
		this.m.GoodEnding = "让%name%这样的赌徒加入你的队伍也许是有风险的。现在，许多天过去了，很明显你的选择是正确的。你最后听到的消息是，他还在战团里，并且用他的收入来丰富他的生活习惯。有传言说他通过一系列胜利已经秘密地成为世界上最富有的人之一。你认为这是一派胡言，但令人惊讶的是，许多市长在赌博问题上变得突然松懈了……";
		this.m.BadEnding = "%name%这个赌徒从每况愈下的战团退休了，又回到了他的赌博生活中。他很快就欠下了无法偿还的巨额债务。你看到他在街角乞讨，一只手不见了，牙齿上有裂缝。你往他的罐子里扔了几个克朗，说了几句话，但他没有认出你来。";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
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
		this.m.Titles = [
			"二点牌(Deuces)",
			"百搭牌(the Wild Card)",
			"幸运制造者(the Luck Maker)",
			"幸运星(the Lucky)",
			"牌术大师(the Cardsharper)",
			"赌徒(the Gambler)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Thick;
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
		return "{人们都说运气是魔鬼，那么像%name%这样的赌徒能玩多久呢？ | 每个人都会赌博，所以%name%觉得干嘛不为钱而赌呢？ | 骰子，纸牌，弹珠 —— 有很多赚取别人钱的方法，而%name%全都知道。 | %name%有着沙漠蛇一样的眼睛 —— 而操弄纸牌就是他的特长。 | 在生死存亡的世界里，冒险成为了%name%的游戏。 | 像%name%这样的人能预见一切，尤其是牌堆下一张牌的情况。}{他从一个镇打牌打到另一个镇来维持生计，只有在把他们的口袋里的钱都掏光后才离开。 | 但是，一个人是如何决定把打牌作为一种生活方式的，这是一个谜。 | 雇佣兵的不断进进出出使他们成为了很容易的目标 —— 直到一个输不起的人用一把手半剑把他赶走。 | 他生来就是孤儿，总是靠与人赌博为生。 | 当他还是个孩子的时候，一个骗子的杯子游戏让他明白了诈骗的价值。 | 当他的父亲陷入赌债时，他想到最好的还债方式是成为一个更好的骗子。 | 在拿走他们所有的克朗后，各地封杀了%name%的赌博生涯，以所谓的“宗教复兴”之名。}{现在，这个赌徒想要把他的骰子扔到风中 —— 以及泥中，与任何愿意愿意付钱的人为伍。 | 人们不禁要问，打牌的人不打牌是在干什么。不过话说回来，也许他把你的团队看作场聪明的赌博是件好事。 | 也许多年来欺骗雇佣兵的经历让他觉得自己也可以轻而易举地成为一名雇佣兵。 | 机智而反应迅速的牌术大师凭借比别人行动更快为生，这是种与世上其他任何技能一样有用的技能。 | 具有讽刺意味的是，一次糟糕的下注让他欠下了一位男爵的巨额债务。现在他得另想办法还债了。 | 战争已经榨干了他卡牌游戏的大多数目标。他觉得与其无所事事等待，还不如直接紧跟时事。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-2,
				-2
			],
			Bravery = [
				12,
				12
			],
			Stamina = [
				-6,
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
				2
			],
			RangedDefense = [
				2,
				8
			],
			Initiative = [
				12,
				10
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
			items.equip(this.new("scripts/items/armor/noble_tunic"));
		}
		else
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/feathered_hat"));
		}
	}

});
