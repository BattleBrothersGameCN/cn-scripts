this.cured_rations_item <- this.inherit("scripts/items/supplies/food_item", {
	m = {},
	function create()
	{
		this.food_item.create();
		this.m.ID = "supplies.cured_rations";
		this.m.Name = "精制口粮";
		this.m.Description = "食物。密封分装在小盒子里，囊括了精腌肉类和蔬菜的套装口粮。是长途旅行和探险的理想食品。";
		this.m.Icon = "supplies/inventory_provisions_16.png";
		this.m.Value = 150;
		this.m.GoodForDays = 16;
	}

	function getBuyPrice()
	{
		if (this.m.IsSold)
		{
			return this.getSellPrice();
		}

		if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null)
		{
			return this.Math.max(this.getSellPrice(), this.Math.ceil(this.getValue() * this.getBuyPriceMult() * this.getPriceMult() * this.World.State.getCurrentTown().getFoodPriceMult() * this.World.State.getCurrentTown().getBuyPriceMult() * this.Const.World.Assets.BuyPriceNotProducedHere));
		}

		return this.item.getBuyPrice();
	}

	function getSellPrice()
	{
		if (this.m.IsBought)
		{
			return this.getBuyPrice();
		}

		if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null)
		{
			return this.Math.floor(this.getValue() * this.getSellPriceMult() * this.World.State.getCurrentTown().getFoodPriceMult() * this.World.State.getCurrentTown().getSellPriceMult() * this.Const.World.Assets.SellPriceNotProducedHere);
		}

		return this.item.getSellPrice();
	}

});
