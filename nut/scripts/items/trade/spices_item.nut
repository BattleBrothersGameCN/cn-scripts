this.spices_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "misc.spices";
		this.m.Name = "香料";
		this.m.Description = "来自南方王国的各种美味且稀有的香料。这些食材在北方很受欢迎。";
		this.m.Icon = "trade/inventory_trade_10.png";
		this.m.Culture = this.Const.World.Culture.Southern;
		this.m.ProducingBuildings = [
			"attached_location.plantation"
		];
		this.m.Value = 320;
	}

});
