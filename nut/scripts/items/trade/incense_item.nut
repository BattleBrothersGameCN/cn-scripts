this.incense_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "misc.incense";
		this.m.Name = "熏香";
		this.m.Description = "这些干燥的树液碎片会产生一种充满神秘和异国情调的浓烟。会卖个好价钱，尤其是在北方。";
		this.m.Icon = "trade/inventory_trade_12.png";
		this.m.Culture = this.Const.World.Culture.Southern;
		this.m.ProducingBuildings = [
			"attached_location.incense_dryer"
		];
		this.m.Value = 380;
	}

	function getSellPriceMult()
	{
		return this.World.State.getCurrentTown().getModifiers().IncensePriceMult;
	}

	function getBuyPriceMult()
	{
		return this.World.State.getCurrentTown().getModifiers().IncensePriceMult;
	}

});
