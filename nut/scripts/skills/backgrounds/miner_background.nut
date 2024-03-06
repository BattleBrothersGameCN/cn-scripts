this.miner_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.miner";
		this.m.Name = "矿工";
		this.m.Icon = "ui/backgrounds/background_45.png";
		this.m.BackgroundDescription = "矿工习惯于体力劳动，但多年来呼吸矿井里的带尘空气可能已经对他的健康造成了损害。";
		this.m.GoodEnding = "谢天谢地，矿工%name%从此再也没有回到矿井里。如果有一种生活比为生存而战斗更糟糕，那很可能就是为生存而挖山！据说，这位矿工在海边盖起了一座房子，余生平静地从事捕鱼工作，享受着日出等这些伤感的破玩意。";
		this.m.BadEnding = "如果说有一种生活比当佣兵更加艰苦，那便是当矿工。可悲的是，%name%又回到了那种生活，回到矿井里去开采金属和矿石来填满一些富人的口袋。最近的一次地震导致了许多类似的矿井坍塌。你不知道这位老兄弟是否安然无恙，但情况看起来非常严峻。";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.huge",
			"trait.hate_undead",
			"trait.night_blind",
			"trait.swift",
			"trait.iron_lungs",
			"trait.bright",
			"trait.fat",
			"trait.clumsy",
			"trait.fragile",
			"trait.strong",
			"trait.craven",
			"trait.dastard"
		];
		this.m.Titles = [
			"矿工(the Miner)",
			"爬行者(the Crawler)",
			"地底人(Earthside)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsLowborn = true;
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
		return "{为了养活一个没有父亲的家庭，%name%在很小的时候就进入了矿山。 | 作为一个孤儿，%name%唯一能找到的工作就是开采土地里的矿藏。 | 采矿是一项艰苦的工作，许多像%name%这样的人群集而来。 | 尽管他的父亲死在矿山里，%name%还是不得不在那里工作，就像他长大的地方的大多数人一样。 | %name%在矿山工作，这是一个世代相传的家族传统。 | 每当战争开始时，人们比以往任何时候都更需要像%name%这样的矿工，否则军队就没有能挥舞的钢铁。 | 一顶硬帽和一把鹤嘴锄，%name%已经带着这些工具深入大地很多年了。}{但是，一如既往的，一个矿山不会永远存在，这位矿工在上一次坍塌中险些丧命。 | 不幸的是，他是坍塌事故中唯一的幸存者，他不可能一个人挖回去。 | 在一次悲惨的矿难之后，看着几十个寡妇让有了换个工作领域的想法。 | 在又一次坍塌中幸存下来后，他的妻子要求他找一份新的工作，不管新工作是什么。 | 不过，在黑暗中弯腰匍匐逐渐令人乏味，所以这个人寻求起了另一种职业。 | 由于工作环境过于黑暗，这名男子意外杀死了一名同事。这场悲剧迫使他离开了矿井。 | 在他自己的儿子于矿井中丧生后，这个人永远离开了这份工作。 | 但由于不断咳嗽，他觉得也许在新鲜空气中的事业对他更有好处。}{%name%有矿工般结实的身躯。不幸的是，他也有一个矿工的肺。 | %name%很坚韧，但他的喘息声听起来就像生锈的刀片在相互摩擦。 | 你会怀疑%name%肺里的金属粉尘是否有足够造上一两把刀片。 | %name%呼出的气差不多能把煤染得更黑 | %name%曾经花了好几年的时间为公司的商店打工，现在他想要赚些真正的钱。 | %name%期待着将那些他花了多年时间从地里挖出来的黄金放进自己的口袋。 | 令人恼火的是，%name%指着你一半的装备 —— 大部分是金属制品 —— 并提醒大伙这些是谁的成果。 | %name%在黑暗中几乎有猫一样的视力。要不是他那该死的喘息声，他本可以成为一个出色的刺客。 | %name%已经死里逃生几次了，为什么不以佣兵的身份再试几次呢？ | %name%已经被大地索取过性命，所以地面上的一些东西不会吓到他。 | 如果黑暗真的是死亡的使节，那么%name%已经与其交谈了多年。 | 像%name%这样愚蠢却勇敢的人一定能在队伍里找个好差事。 | %name%自豪地夸耀说，从前他能在黑暗中打牌。你毫不怀疑。 | 如果%name%能像挥舞鹤嘴锄一样挥剑，那就万事大吉了。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				10,
				10
			],
			Bravery = [
				5,
				8
			],
			Stamina = [
				-10,
				-10
			],
			MeleeSkill = [
				5,
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

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local dirt = actor.getSprite("dirt");
		dirt.Visible = true;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		items.equip(this.new("scripts/items/weapons/pickaxe"));
		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/mouth_piece"));
		}
	}

});
