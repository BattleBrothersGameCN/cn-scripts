this.silk_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "misc.silk";
		this.m.Name = "丝绸";
		this.m.Description = "这些光滑的丝绸布料十分难得。只有最为富有和尊贵的人才有用它裁剪服装的机会，在北方价格尤为不菲。";
		this.m.Icon = "trade/inventory_trade_11.png";
		this.m.Culture = this.Const.World.Culture.Southern;
		this.m.ProducingBuildings = [
			"attached_location.silk_farm"
		];
		this.m.Value = 460;
	}

});
