this.well_supplied_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.well_supplied";
		this.m.Name = "供应充足";
		this.m.Description = "这个地方最近被供应了新鲜的商品，其中许多现在可以用合适的价格买到。";
		this.m.Icon = "ui/settlement_status/settlement_effect_03.png";
		this.m.Rumors = [
			"%settlement%的生意越做越好了，我的朋友！路上又安全货色又齐，要是能一直这样就好了...",
			"我在%settlement%的表哥一直在吹嘘那儿有多好。市场上的货要多少有多少，不像这个烂地方。"
		];
		this.m.IsStacking = false;
	}

	function getAddedString( _s )
	{
		return _s + "现在" + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return _s + "不再" + this.m.Name;
	}

	function onAdded( _settlement )
	{
		_settlement.removeSituationByID("situation.ambushed_trade_routes");
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.PriceMult *= 0.9;
		_modifiers.RarityMult *= 1.15;
	}

});
