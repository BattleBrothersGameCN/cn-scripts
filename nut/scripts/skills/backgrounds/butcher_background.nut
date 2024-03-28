this.butcher_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.butcher";
		this.m.Name = "屠夫";
		this.m.Icon = "ui/backgrounds/background_43.png";
		this.m.BackgroundDescription = "屠夫习惯于流血杀戮。";
		this.m.GoodEnding = "佣兵的工作充满了鲜血，正是如此，%name%这样的屠夫如鱼得水。虽然他是个出色的战士，但他对战团里狗动手的消息还是经常传到你耳朵里。最终，战团的兄弟用尽了办法，给了他一只可爱的小狗，让他自己养大。据你所知，小家伙眼睛里泛着天真无邪的光，把这个讨厌狗的人变成了爱狗之人。现在每当有战犬受到伤害，他就会进入一种无法满足的血腥狂热状态，而他的小杂种狗已经成长为战团中最凶猛的野兽！";
		this.m.BadEnding = "屠夫%name%最终离开了每况愈下的战团。他加入了另一支队伍，却在杀他们的战犬时被逮了个正着。显然，他一直在把那些“失踪”狗的狗肉拿给那些佣兵吃。他们没有选择忍让，而是剥去了屠夫的衣服，把他喂给了野兽。";
		this.m.HiringCost = 80;
		this.m.DailyCost = 7;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.swift",
			"trait.bleeder",
			"trait.bright",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.spartan",
			"trait.iron_lungs",
			"trait.tiny",
			"trait.optimist"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.RangedSkill
		];
		this.m.Titles = [
			"屠夫(the Butcher)",
			"剁肉者(the Cleaver)",
			"血红(the Red)",
			"红肉(Redmeat)",
			"血眼(Bloodeye)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Thick;
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
		return "{在他父亲去世后，%name%接手了%randomtown%的家族肉店。 | 在贫穷中长大，%name%很快就学会了宰杀和剥皮，最终办了一家肉店。 | 由于干旱毁坏了农田，%name%在%randomtown%的肉店开始兴旺起来。 | %name%从小就不同寻常，他从事屠宰不仅是为了赚钱，也是为了取乐。 | 当%name%的商店开张，他收到第一批生猪的订单时，他笑得合不拢嘴。 | 多年来，屠户%name%一直在和兔子内脏和死鱼头打交道。}{但虐待动物的传言最终迫使这个靠刀吃饭的人离开了他的生意。 | 有关黑魔法的流言传得沸沸扬扬，没过多久，人们开始质疑他肉的来源，把他赶出了这个行业。 | 但由于这样或那样的原因，杀戮动物不再让他感到兴奋。他在寻找新的东西。 | 他卖出的一包鹿肉里，出现了一根人的手指，他被赶出了他的生意。 | 有人说，他最怀念那些兽人入侵期间，为士兵宰肉的日子，并希望再次体验那段时光。 | 不幸的是，战争席卷过他的商店，留下了许多他不敢下手的尸体。 | 城市被围攻期间，他为饥饿的人提供肉食。肉的来源被发现以后，他被交给了围攻者，围攻者稀里糊涂地放了他。 | 对偷猎者的友善最终变成了麻烦，迫使他在当地领主的追捕下落荒而逃。 | 丑闻传出去他才知道，他宰杀的小猪是贵族的宠物。为了不任人宰割，他只得落荒而逃。}{血腥和内脏之类的对%name%来说恰到好处。那么，欢迎来到战场。 | %name%把所有事物都看作会呼吸、会动的包好的肉 | 仅仅是%name%和他那双圆睁的眼睛就足以让许多人感到不安。 | %name%是出了名的爱咬舌头，品尝鲜血。 | 每当有猪叫唤时，%name%的耳朵就会竖起来。有人尖叫时也是一样。有趣。 | %name%是个屠夫，但明显不是为做饭来的。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				4
			],
			Bravery = [
				7,
				5
			],
			Stamina = [
				0,
				4
			],
			MeleeSkill = [
				3,
				2
			],
			RangedSkill = [
				-3,
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
		r = this.Math.rand(0, 2);

		if (r <= 1)
		{
			items.equip(this.new("scripts/items/weapons/butchers_cleaver"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/butcher_apron"));
		}
	}

});
