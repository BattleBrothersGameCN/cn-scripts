this.draught_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.draught";
		this.m.Name = "干旱";
		this.m.Description = "一股意料之外的热浪烧毁了许多当地的农作物。食物少，价格高。";
		this.m.Icon = "ui/settlement_status/settlement_effect_16.png";
		this.m.Rumors = [
			"据我所知，%settlement% 正遭受严重的干旱。对那边的人来说一直很艰难，但这次更可怕。",
			"如果你像你看起来那样鲁莽，你可能会在 %settlement% 卖食物赚克朗。一场严重的干旱使人们挨饿，所以他们会不惜一切代价从牙缝里得到东西。",
			"哦，儿子，我以前在 %settlement% 是个求雨法师，但那些傻瓜把我赶走了！现在，无可否认，村里正遭受着一场旱灾，但这难道不是更需要依靠我的理由吗？傻瓜，我说！"
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 7;
	}

	function getAddedString( _s )
	{
		return _s + "受损于" + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return _s + "不再受损于" + this.m.Name;
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.FoodRarityMult *= 0.5;
		_modifiers.FoodPriceMult *= 2.0;
	}

	function onUpdateDraftList( _draftList )
	{
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
	}

});
