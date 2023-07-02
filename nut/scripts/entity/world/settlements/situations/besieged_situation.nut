this.besieged_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.besieged";
		this.m.Name = "围困";
		this.m.Description = "这个地方现在或直到最近一直被敌人围困！它遭受了破坏，补给不足，许多人丧生。";
		this.m.Icon = "ui/settlement_status/settlement_effect_13.png";
		this.m.Rumors = [
			"岩石和火箭飞扬，燃烧的热油，人们饿死－这是一场围攻。你可以亲自去 %settlement% 仔细看看。",
			"我年轻时曾在 %randomnoble%的军队服役。最糟糕的是我们参与的围攻，持续了几个月。很遗憾现在那里又发生了这种事，那是 %settlement%。",
			"听到这个词了吗？%settlement% 被包围了！那里的穷人深受其害。"
		];
		this.m.IsStacking = false;
	}

	function getAddedString( _s )
	{
		return _s + "现在有" + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return _s + "不再有" + this.m.Name;
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
		_settlement.resetRoster(false);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.SellPriceMult *= 1.000000;
		_modifiers.BuyPriceMult *= 1.250000;
		_modifiers.FoodPriceMult *= 2.000000;
		_modifiers.RecruitsMult *= 0.500000;
		_modifiers.RarityMult *= 0.500000;
	}

});
