this.trader_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.trader";
		this.m.Name = "交易员";
		this.m.Description = "南方商人以他们的易货技巧而闻名。 你真幸运，你能说服这样一位讨价还价的高手加入你的战团。 这么便宜！";
		this.m.Image = "ui/campfire/trader_01";
		this.m.Cost = 3500;
		this.m.Effects = [
			"对于每个生产贸易商品的地点，将贸易商品的销售数量增加1，比如盐矿附近的盐，允许你以更高的交易量进行交易"
		];
		this.m.Requirements = [
			{
				IsSatisfied = false,
				Text = ""
			}
		];
	}

	function onUpdate()
	{
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "售出" + this.Math.min(25, this.World.Statistics.getFlags().getAsInt("TradeGoodsSold")) + "/25 贸易商品";

		if (this.World.Statistics.getFlags().getAsInt("TradeGoodsSold") >= 25)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});
