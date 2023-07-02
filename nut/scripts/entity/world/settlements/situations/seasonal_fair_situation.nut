this.seasonal_fair_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.seasonal_fair";
		this.m.Name = "季节性交易会";
		this.m.Description = "来自四面八方的商人聚集在这里参加季节性交易会。很多人从周围的乡村聚集在这里，现在是出售商品或通过大量的报价进行翻箱倒柜的好时机。";
		this.m.Icon = "ui/settlement_status/settlement_effect_28.png";
		this.m.Rumors = [
			"你在问这附近发生了什么事？嗯，%settlement% 有个集市。来自四面八方的商人聚集在一起献上他们的货物。",
			"我，我更喜欢孤独型。像 %settlement% 那样的大型集市对我一点吸引力都没有…。"
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 3;
	}

	function onAdded( _settlement )
	{
		_settlement.removeSituationByID("situation.ambushed_trade_routes");
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.PriceMult *= 1.250000;
		_modifiers.RarityMult *= 1.250000;
		_modifiers.FoodRarityMult *= 1.250000;
		_modifiers.MedicalRarityMult *= 1.250000;
		_modifiers.RecruitsMult *= 1.250000;
	}

	function onUpdateDraftList( _draftList )
	{
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
	}

});
