this.besieged_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.besieged";
		this.m.Name = "围攻";
		this.m.Description = "这个地方一直被敌人围困到现在！它毁坏严重，补给不足，有许多人丧命。";
		this.m.Icon = "ui/settlement_status/settlement_effect_13.png";
		this.m.Rumors = [
			"岩石和火箭掠过天空，燃烧的热油飞溅，饿殍遍地－这就是围城。你可以去 %settlement% 看个仔细。",
			"我年轻时曾在 %randomnoble%的军队服役。最惨烈的莫过于围城战了，一打就是几个月。很遗憾现在%settlement%又发生了这种事 。",
			"听说了吗？%settlement% 被包围了！可怜那儿的人要倒大霉了。"
		];
		this.m.IsStacking = false;
	}

	function getAddedString( _s )
	{
		return _s + "现在被" + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return _s + "不再被" + this.m.Name;
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
		_settlement.resetRoster(false);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.SellPriceMult *= 1.0;
		_modifiers.BuyPriceMult *= 1.25;
		_modifiers.FoodPriceMult *= 2.0;
		_modifiers.RecruitsMult *= 0.5;
		_modifiers.RarityMult *= 0.5;
	}

});
