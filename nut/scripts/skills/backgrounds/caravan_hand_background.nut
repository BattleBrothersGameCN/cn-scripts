this.caravan_hand_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.caravan_hand";
		this.m.Name = "商队队员";
		this.m.Icon = "ui/backgrounds/background_12.png";
		this.m.BackgroundDescription = "商队队员已经习惯了漫长而疲惫的旅行。";
		this.m.GoodEnding = "曾经的商队队员，%name%，从战斗生涯中退役了。他用自己当佣兵赚来的钱做起了押镖的生意，专门运送货物通过危险的地区。";
		this.m.BadEnding = "商队队员%name%退役后做回了护卫商队的工作。他在抵御强盗伏击时牺牲了。他们夺走了他的衣服，把他的尸体丢进了沟里。";
		this.m.HiringCost = 75;
		this.m.DailyCost = 8;
		this.m.Excluded = [
			"trait.tiny",
			"trait.clubfooted",
			"trait.gluttonous",
			"trait.bright",
			"trait.asthmatic",
			"trait.fat"
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
			}
		];
	}

	function onBuildDescription()
	{
		return "{%name%一向喜欢冒险，被商队生活吸引也是自然。 | %name%是战争和瘟疫的孩子，在商人的庇护下长大。 | 商队生活可谓艰苦，但对%name%来说，久居一地更加难熬。 | 商队工作险象环生，也让%name%大开眼界。 | 大火烧毁了他的家庭，也免除了他的义务，再也没有什么能阻止%name%加入商队了。 | 能吃苦，有决断，%name%第一个被商人选中，保护他的货物。 | 离家出走后不久，%name%就加入了一支商队，并最终在那里工作。}{时间证明，领头的商人嗜虐成性，给她根鞭子她就能驱策奴隶。一阵激烈争吵之后，%name%认为最好赶快离开，以免自己做出可怕的事情。 | 有一天，货物不见了，%name%为此挨了骂，很快结束了他在商队的生活。 | 商队雇人保护是有原因的，比如要面对强盗的伏击。%name%勉强逃过一劫。 | 几年的路途一帆风顺，直到新的商队老板拒绝给%name%工资。这个商队队员只用一只手就打翻了老板，夺回了他的工资。不过逃跑还是要两条腿的。 | 商队经常搞得人精神紧张。一天晚上，他和一位旅行者就赌债起了争执，把他的脑袋开了瓢。为了防止报复，%name%一早离开了商队。 | 可悲的是，随着战争的扩大，商队的利润变得微乎其微。商人们把马车退役，%name%也随即被解雇了。 | 目睹了同行商队队员面对野兽残杀的惨状，%name%很快意识到，他的工资配不上他要面对的威胁。 | 但是战争让商队损失了存货，不久商队头领便开始买卖奴隶。%name%的心灵受到了冲击，他尽可能多地解放了奴隶，离开了商队。 | 可悲的是，他所在的商队开始出售人身动产（奴隶）。虽然获利颇丰，但这引来了当地民兵的注意 —— 以及他们的干草叉。一次伏击之后，%name%逃走了。}{现在他无所事事，寻找任何可能的工作机会。 | %name%这样的人对危险并不陌生，是佣兵的合适人选。 | 随着商队生活成为过去，佣兵行业成了冒险和赚钱两不耽误的不二之选。 | 在%name%看来，当佣兵和在商队里干活很像。只是报酬更高。 | %name%在旅行方面很有经验，天生适合佣兵的任务要求。 | 多年行路把%name%塑造成了一个结实耐劳的人。对佣兵团来说，这样的人来多少都不嫌多。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				3,
				5
			],
			Bravery = [
				3,
				3
			],
			Stamina = [
				5,
				7
			],
			MeleeSkill = [
				4,
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
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/dagger"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/bludgeon"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/hatchet"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/weapons/shortsword"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/gambeson"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/padded_leather"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/thick_tunic"));
		}
		else
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}

		r = this.Math.rand(0, 2);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/headscarf"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/open_leather_cap"));
		}
	}

});
