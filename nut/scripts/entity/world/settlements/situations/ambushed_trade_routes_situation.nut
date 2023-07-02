this.ambushed_trade_routes_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.ambushed_trade_routes";
		this.m.Name = "受伏击的贸易路线";
		this.m.Description = "最近通往这里的道路很不安全，许多商队遭到伏击和抢劫。由于做成功的贸易很少，商品的选择更少，价格更高。";
		this.m.Icon = "ui/settlement_status/settlement_effect_12.png";
		this.m.Rumors = [
			"强盗和掠夺者是我们旅行商人的祸根！我的一个老朋友就在%settlement%外遭到伏击、抢劫和殴打！",
			"如果你身上有贵重物品，请远离%settlement%。那个地方到处都是割喉着、土匪和路霸！",
			"守卫们正在尽他们所能，但这些强盗只是转移到下一个城镇，在路上拦截商人。据说他们现在就潜伏在%settlement%附近！"
		];
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
		_settlement.removeSituationByID("situation.safe_roads");
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.BuyPriceMult *= 1.200000;
		_modifiers.SellPriceMult *= 1.100000;
		_modifiers.RarityMult *= 0.750000;
	}

});
