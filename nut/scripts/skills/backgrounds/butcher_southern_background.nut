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
		return "{在他父亲去世后，%name%接手了%randomtown%的家族肉店。 | 在贫穷中长大，%name%很快就学会了宰杀和剥皮，最终办了一家肉店。 | 由于干旱毁坏了农田，%name%在%randomcitystate%的肉店开始兴旺起来。 | %name%从小就不同寻常，他从事屠宰不仅是为了赚钱，也是为了取乐。 | 当%name%的商店开张，他收到第一批生猪的订单时，他笑得合不拢嘴。 | 多年来，屠户%name%一直在和兔子内脏和死鱼头打交道。}{但虐待动物的传言最终迫使这个靠刀吃饭的人离开了他的生意。 | 有关黑魔法的流言传得沸沸扬扬，没过多久，人们开始质疑他肉的来源，把他赶出了这个行业。 | 但由于这样或那样的原因，杀戮动物不再让他感到兴奋。他在寻找新的东西。 | 他卖出的一包鹿肉里，出现了一根人的手指，他被赶出了他的生意。 | 有人说，他最怀念征讨沙漠部族期间，为维齐尔的士兵宰肉的日子，并希望再次体验那段时光。 | 不幸的是，战争席卷过他的商店，留下了许多他不敢下手的尸体。 | 丑闻传出去他才知道，他宰杀的小猪是贵族的宠物。为了不任人宰割，他只得落荒而逃。}{血腥和内脏之类的对%name%来说恰到好处。那么，欢迎来到战场。 | %name%把所有事物都看作会呼吸、会动的包好的肉 | 仅仅是%name%和他那双圆睁的眼睛就足以让许多人感到不安。 | %name%是出了名的爱咬舌头，品尝鲜血。 | 每当有猪叫唤时，%name%的耳朵就会竖起来。有人尖叫时也是一样。有趣。 | %name%是个屠夫，但明显不是为做饭来的。}";
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
