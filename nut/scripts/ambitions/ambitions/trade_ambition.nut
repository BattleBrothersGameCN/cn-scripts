this.trade_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		AmountToBuy = 25,
		AmountToSell = 25
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.trade";
		this.m.Duration = 21.000000 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "城镇之间的贸易可以赚很多克朗。\n让我们赚一大笔钱吧！";
		this.m.UIText = "购买和销售贸易商品";
		this.m.TooltipText = "买卖25种贸易商品，如毛皮、盐或香料。在生产它们的小村庄购买它们，然后在大城市出售它们，你会赚到最多的硬币。\n有些商品是特定地区的特产，比如南部沙漠，在世界其他地方销售它们可以进一步提高利润率。";
		this.m.SuccessText = "[img]gfx/ui/events/event_55.png[/img]这个念头从一开始就萦绕在你的脑海中，但很多雇佣军队长却没有想到过。这个想法是如此自然，却被许多队长持剑的自尊心所隐藏。如果%companyname%要从城市之间往来寻找雇佣工作，那么离从事贸易也只有一步之遥。你很快就明白了这一点，意识到商品携带的是一种不同于表面的货币，一种被眼所隐藏的价值，隐藏在时间和地点的涟漪中。现在，你每晚痛苦地计算克朗。一种甜蜜的痛苦。";
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
