this.seasonal_fair_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.seasonal_fair";
		this.m.Name = "时令大集";
		this.m.Description = "时令大集吸引了来自天南海北的商人。周围乡村的人们大量涌向这里，出售商品或寻珍探宝也正是时候。";
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
