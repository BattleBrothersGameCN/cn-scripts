this.furs_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "misc.furs";
		this.m.Name = "毛皮";
		this.m.Description = "野生动物身上的保暖绒皮。商人，尤其是南方的商人，会为此付个好价钱。";
		this.m.Icon = "trade/inventory_trade_05.png";
		this.m.Culture = this.Const.World.Culture.Northern;
		this.m.ProducingBuildings = [
			"attached_location.trapper"
		];
		this.m.Value = 300;
	}

});
