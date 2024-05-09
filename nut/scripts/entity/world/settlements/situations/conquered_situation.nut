this.conquered_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.conquered";
		this.m.Name = "被征服";
		this.m.Description = "这个地方最近被征服了。许多人丧生，侥幸活下来的人也不得不面对征服者的肆意掠夺。定居点的大部分还没得到修缮，人们的情绪也很低落。";
		this.m.Icon = "ui/settlement_status/settlement_effect_02.png";
		this.m.Rumors = [
			"%settlement% 最近被占领了，至少我听说是这样。我常说“领主换了－那是黄鼠狼换狐狸”…",
			"征服新的土地是贵族的游戏。我听说他们刚刚洗劫了 %settlement%。",
			"嘿，佣兵！围攻 %settlement% 的时候你在吗？那真是他妈的恭喜你了。你杀了几个？强奸了几个？ "
		];
		this.m.IsStacking = false;
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.SellPriceMult *= 0.9;
		_modifiers.BuyPriceMult *= 1.1;
		_modifiers.RarityMult *= 0.6;
		_modifiers.FoodRarityMult *= 0.9;
	}

});
