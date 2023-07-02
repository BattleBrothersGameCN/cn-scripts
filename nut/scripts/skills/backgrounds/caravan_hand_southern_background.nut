this.caravan_hand_southern_background <- this.inherit("scripts/skills/backgrounds/caravan_hand_background", {
	m = {},
	function create()
	{
		this.caravan_hand_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernSkinny;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.BeardChance = 90;
		this.m.Ethnicity = 1;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.tiny",
			"trait.clubfooted",
			"trait.gluttonous",
			"trait.bright",
			"trait.asthmatic",
			"trait.fat"
		];
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{%name%一向是爱冒险的人，很容易被商队队员的生活所吸引。 | %name%因战争和瘟疫而成为孤儿，在一个商人的庇护下长大。 | 商队队员的生活是艰苦的，但%name%很难忍受在一个地方呆太久。 | 尽管工作很危险，但做一个商队队员可以让%name%见世面。 | 当他的家庭和责任被大火烧毁时，%name%觉得没有理由不加入路过的商队。 | %name%吃苦耐劳，意志坚定，是第一个被商人选来保护他货物的商队队员。 | %name%离家出走，没过多久就加入了一支商队，并最终在那里工作。}{但是他为之工作的商人最终被证明是个虐待狂，离奴隶贩子只差了一根鞭子。在与那个女人激烈争吵之后，%name%认为最好离开，以免自己做出可怕的事情。 | 有一天，货物不见了，这位商队队员因此受到指责，很快结束了他在商队的生活。 | 但商队需要保护是有原因的，一场沙漠掠夺者的伏击证明了这一点。%name%勉强活了下来。 | 几年的路途一帆风顺，直到一位新的商队老板拒绝支付克朗给%name%。这个商队队员只用一只手就打翻了老板夺回了他的工资。不过，他是用两条腿逃跑的。 | 商队经常是个令人神经紧张的地方。在一次有关赌债的争执中，他用炉子敲碎了另一名旅行者的头骨。为了防止报复，%name%在早晨离开了商队。 | 可悲的是，随着战争的扩大，商队的利润微乎其微。随着商人们的载重马车退役，%name%也被解雇了。 | 在看到野兽残杀同行商队队员的惨状后，很快%name%就意识到他的工资并不与他周围的威胁相匹配。 | 但是战争让商队损失了存货，很快商队头领就开始买卖奴隶了。%name%对此感到震惊，他在离开之前尽可能地解放了他能解放的奴隶。 | 可悲的是，他所在的商队开始出售人身动产（奴隶）。虽然获利颇丰，但这引起了当地民兵的注意 —— 以及他们的干草叉。一次伏击之后，%name%不得不逃命。}{现在他不知道该做什么，于是寻找任何可能出现的机会。 | 像%name%这样的人对危险并不陌生，这使他成为任何雇佣兵组织的合适人选。 | 随着他商队年华的过去，干佣兵的活计只是另一种冒险和赚钱的途径。 | 在%name%看来，当佣兵和在商队里干活很像。只是报酬更高。 | %name%在旅行方面很有经验，似乎天生就适合雇佣兵的任务。 | 多年行路把%name%塑造成了一个结实耐劳的人。任何佣兵团队都需要更多像他这样的人。}";
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/bludgeon"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/oriental/light_southern_mace"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/oriental/saif"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/oriental/cloth_sash"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/oriental/padded_vest"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/oriental/nomad_robe"));
		}
		else
		{
			items.equip(this.new("scripts/items/armor/oriental/thick_nomad_robe"));
		}

		r = this.Math.rand(0, 3);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/oriental/southern_head_wrap"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/oriental/nomad_head_wrap"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/oriental/nomad_leather_cap"));
		}
	}

});
