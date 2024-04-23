this.trader_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.trader";
		this.m.Name = "商人";
		this.m.Description = "南方商人以他们的易货技巧而闻名。 能说服这样一位讨价还价的高手加入你的战团，你肯定是捡了个大便宜。";
		this.m.Image = "ui/campfire/trader_01";
		this.m.Cost = 3500;
		this.m.Effects = [
			"通过使每个定居点附属地点（如盐矿）提供的贸易商品（如盐）数量增加1，使您能以更高的交易量进行交易"
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
		this.m.Requirements[0].Text = "售出" + this.Math.min(25, this.World.Statistics.getFlags().getAsInt("TradeGoodsSold")) + "/25件商品";

		if (this.World.Statistics.getFlags().getAsInt("TradeGoodsSold") >= 25)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});
