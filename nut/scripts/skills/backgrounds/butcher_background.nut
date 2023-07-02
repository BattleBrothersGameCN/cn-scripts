this.butcher_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.butcher";
		this.m.Name = "屠夫";
		this.m.Icon = "ui/backgrounds/background_43.png";
		this.m.BackgroundDescription = "屠夫习惯于流血杀戮。";
		this.m.GoodEnding = "雇佣兵的工作是一项血腥的事业，这也许就是为什么像%name%这样的屠夫在其中会感到很自在。虽然他是个出色的战士，但你听说他与队伍内的战犬仍有矛盾，曾多次被抓到试图宰杀它们。最终，如果不是没办法的话，战团给了这个人一只可爱的小狗养。从你所知道的情况来看，这小家伙的发光无辜眼睛把这个讨厌狗的人变成了爱狗之人。现在每当有战犬受到伤害时，他就会进入一种无法满足的血腥狂热状态，而他的小杂种狗已经成长为战团中最凶猛的野兽！";
		this.m.BadEnding = "屠夫%name%最终离开了这个每况愈下的战团。他加入了另一支队伍，但在屠杀他们的一只战犬时被抓了个正着。显然，他一直在给雇佣兵们提供他们所有那些“失踪”的杂种狗的狗肉。他们对于这个消息并不满意，于是剥去了屠夫的衣服，并将他喂给了野兽。";
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
		return "{在他父亲去世后，%name%接管了%randomtown%的家族肉店。 | 在贫穷中长大的%name%很快学会了宰杀和剥皮，最终建立了一家肉店。 | 由于干旱毁坏了农田，%name%的肉店开始在%randomtown%兴旺起来。 | %name%一直是个奇怪的孩子，他从事屠宰不仅是为了赚钱，也是为了取乐。 | 当%name%的商店开张，他收到第一批生猪的订单时，他笑得合不拢嘴。 | 作为一名屠夫，%name%花了数年时间从死兔子身上取出内脏，有时还砍掉死鱼的头。}{但是有关其虐待动物的传言最终导致了这个挥刀者离开了他的生意。 | 鉴于黑魔法的可怕谣言已经四处流传，没过多久，人们就开始质疑他的肉的来源，把他赶出了这个行业。 | 但由于这样或那样的原因，杀戮动物不再让他感到兴奋。他在寻找新的东西。 | 在他的一个鹿皮包裹被发现有一根人的手指后，他被赶出了他的生意。 | 有人说他最喜欢在兽人入侵期间为士兵屠宰，并希望再次回到那种经历中。 | 不幸的是，战争席卷过他的商店，留下了许多他不敢宰杀的尸体。 | 他生活在一个被围困的城市里，为饥饿的人提供肉类。当肉的来源被发现后，他被交给了围攻者，而围攻者在不知不觉中让他活了下来。 | 这个人对偷猎者的友善让他陷入了困境，最终让他在路上被当地领主的手下追杀。 | 对一头小猪的屠宰成了一桩丑闻，因为它原来是一位贵族的宠物。他为了保全自己的一身肉而逃跑。}{有关血腥和内脏的东西对%name%来说恰到好处。那么，欢迎来到战场。 | %name%把所有事物都看作带着会呼吸、会动的包装的潜在肉品 | %name%的存在和那双过于睁大的眼睛让许多人感到不安。 | %name%是出了名的爱咬舌头，品尝鲜血。 | 每当有猪叫唤时，%name%的耳朵就会竖起来。男人尖叫时也会发生同样的事情。有趣。 | %name%是个屠夫，但显然对真正为组织提供餐食不感兴趣。}";
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
