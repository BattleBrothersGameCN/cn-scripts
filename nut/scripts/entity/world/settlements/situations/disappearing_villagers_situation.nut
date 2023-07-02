this.disappearing_villagers_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.disappearing_villagers";
		this.m.Name = "消失的村民";
		this.m.Description = "村民们陆续从这个小镇消失，让每个人都感到不安。在街上发现的潜在新兵越来越少，人们对陌生人的态度也越来越不友好。";
		this.m.Icon = "ui/settlement_status/settlement_effect_11.png";
		this.m.Rumors = [
			"听说那边有人失踪，我就取消了%settlement%之行。到目前为止，远离麻烦对我很有帮助！",
			"俺的邻居%randomname%大约一周前去了%settlement%。从那以后就再也没有听到过他的消息。我只希望他别出什么事，你知道，那些强盗和怪物，到处游荡……",
			"邪恶势力在这个世界上很强大。他们躲在树林里，山里，阴影里，有时消失得无影无踪。现在又出现了，就在%settlement%。"
		];
	}

	function getAddedString( _s )
	{
		return _s + "现在有" + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return _s + "不再有" + this.m.Name;
	}

	function onUpdate( _modifiers )
	{
		_modifiers.BuyPriceMult *= 1.250000;
		_modifiers.SellPriceMult *= 0.750000;
		_modifiers.RecruitsMult *= 0.500000;
	}

});
