this.trade_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		AmountToBuy = 25,
		AmountToSell = 25
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.trade";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "城镇间的贸易能赚很多\n克朗。让我们大赚一笔吧！";
		this.m.UIText = "购买和销售贸易商品";
		this.m.TooltipText = "买卖25件贸易商品，如毛皮、盐或香料等。在生产它们的小村庄买入，然后在大城市卖出，是最能赚钱的买卖方法。有些商品是特定地区，比如南部沙漠的特产，在世界其他地方销售它们可以进一步提高利润率。";
		this.m.SuccessText = "[img]gfx/ui/events/event_55.png[/img]这个念头从一开始就萦绕在你的脑海中，但很多佣兵队长却没有想到过。这个想法是如此自然，却被许多队长持剑的自尊心所隐藏。既然%companyname%要从城市之间往来，寻找雇佣工作，其实也已经一只脚踏进了另一行 —— 做买卖的门槛里。你很快就明白了这一点，意识到商品的价值并不只限于它的标价，而在眼前的价格之外，还随着时间和地点波涛起伏。现在，你的晚上被痛苦地算钱占据了，一种甜蜜的痛苦。";
		this.m.SuccessButtonText = "这已经是底线了。";
	}

	function getUIText()
	{
		local bought = 25 - (this.m.AmountToBuy - this.World.Statistics.getFlags().getAsInt("TradeGoodsBought"));
		local sold = 25 - (this.m.AmountToSell - this.World.Statistics.getFlags().getAsInt("TradeGoodsSold"));
		local d = this.Math.min(25, this.Math.min(bought, sold));
		return this.m.UIText + " (" + d + "/25)";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 1 && this.World.Assets.getOrigin().getID() != "scenario.trader")
		{
			return;
		}

		this.m.AmountToBuy = this.World.Statistics.getFlags().getAsInt("TradeGoodsBought") + 25;
		this.m.AmountToSell = this.World.Statistics.getFlags().getAsInt("TradeGoodsSold") + 25;
		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Statistics.getFlags().getAsInt("TradeGoodsBought") >= this.m.AmountToBuy && this.World.Statistics.getFlags().getAsInt("TradeGoodsSold") >= this.m.AmountToSell)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeU32(this.m.AmountToBuy);
		_out.writeU32(this.m.AmountToSell);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);

		if (_in.getMetaData().getVersion() >= 63)
		{
			this.m.AmountToBuy = _in.readU32();
			this.m.AmountToSell = _in.readU32();
		}
	}

});
