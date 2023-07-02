this.butcher_southern_background <- this.inherit("scripts/skills/backgrounds/butcher_background", {
	m = {},
	function create()
	{
		this.butcher_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernMale;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.Ethnicity = 1;
		this.m.BeardChance = 60;
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{在他父亲去世后，%name%接管了%randomtown%的家族肉店。 | 在贫穷中长大的%name%很快学会了宰杀和剥皮，最终建立了一家肉店。 | 由于干旱毁坏了农田，%name%的肉店开始在%randomcitystate%兴旺起来。 | %name%一直是个奇怪的孩子，他从事屠宰不仅是为了赚钱，也是为了取乐。 | 当%name%的商店开张，他收到第一批生猪的订单时，他笑得合不拢嘴。 | 作为一名屠夫，%name%花了数年时间从死兔子身上取出内脏，有时还砍掉死鱼的头。}{但是有关其虐待动物的传言最终导致了这个挥刀者离开了他的生意。 | 鉴于黑魔法的可怕谣言已经四处流传，没过多久，人们就开始质疑他的肉的来源，把他赶出了这个行业。 | 但由于这样或那样的原因，杀戮动物不再让他感到兴奋。他在寻找新的东西。 | 在他的一个鹿皮包裹被发现有一根人的手指后，他被赶出了他的生意。 | 有人说他最喜欢的是在一次与沙漠部落作战的战役中为维齐尔的手下进行屠杀，并希望再次回到那种经历中。 | 不幸的是，战争席卷过他的商店，留下了许多他不敢宰杀的尸体。 | 对一头小猪的屠宰成了一桩丑闻，因为它原来是一位贵族的宠物。他为了保全自己的一身肉而逃跑。}{有关血腥和内脏的东西对%name%来说恰到好处。那么，欢迎来到战场。 | %name%把所有事物都看作带着会呼吸、会动的包装的潜在肉品 | %name%的存在和那双过于睁大的眼睛让许多人感到不安。 | %name%是出了名的爱咬舌头，品尝鲜血。 | 每当有猪叫唤时，%name%的耳朵就会竖起来。男人尖叫时也会发生同样的事情。有趣。 | %name%是个屠夫，但显然对真正为组织提供餐食不感兴趣。}";
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
