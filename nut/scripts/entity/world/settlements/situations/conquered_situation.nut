this.conquered_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.conquered";
		this.m.Name = "征服";
		this.m.Description = "这个地方最近被征服了。许多人丧生，幸存者不得不忍受征服者夺取战利品。大部分的定居点依旧被破坏，人们的情绪也很低落。";
		this.m.Icon = "ui/settlement_status/settlement_effect_02.png";
		this.m.Rumors = [
			"%settlement% 最近被占领了，我听说。“新领主－同样操蛋”是我常说的…",
			"征服新大陆是贵族的游戏。我听说他们刚刚洗劫了 %settlement%。",
			"好的。哦，嘿，佣兵！你在围攻 %settlement% 吗？他妈的恭喜你。你杀了多少人？你强奸了多少人？ "
		];
		this.m.IsStacking = false;
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.SellPriceMult *= 0.900000;
		_modifiers.BuyPriceMult *= 1.100000;
		_modifiers.RarityMult *= 0.600000;
		_modifiers.FoodRarityMult *= 0.900000;
	}

});
