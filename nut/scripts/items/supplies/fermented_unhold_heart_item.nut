this.fermented_unhold_heart_item <- this.inherit("scripts/items/supplies/food_item", {
	m = {},
	function create()
	{
		this.food_item.create();
		this.m.ID = "supplies.fermented_unhold_heart";
		this.m.Name = "酵制巨魔心脏";
		this.m.Description = "食物。曾是北方蛮王们为增强雄风而享用的珍馐，但其味道实在令人难以下咽。";
		this.m.Icon = "supplies/inventory_provisions_19.png";
		this.m.Value = 150;
		this.m.GoodForDays = 20;
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
