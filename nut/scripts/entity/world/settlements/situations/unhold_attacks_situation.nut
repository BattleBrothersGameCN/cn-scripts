this.unhold_attacks_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.unhold_attacks";
		this.m.Name = "巨魔攻击";
		this.m.Description = "大量的巨魔在该地区被看到和听到。镇上的居民害怕离开定居点附近。";
		this.m.Icon = "ui/settlement_status/settlement_effect_26.png";
		this.m.Rumors = [
			"一位旅行商人告诉我，从 %settlement% 来的路上有巨大的脚印。当然他妈的不想见到那些野兽留下的东西！",
			"前几天我在 %settlement% 时，一群猎人失踪了。他们在追捕某种巨人…",
			"有没有听说过巨魔？巨大的怪物把整个货车踩在脚下！我听目击者说那是在 %settlement%。"
		];
		this.m.IsStacking = false;
	}

	function getAddedString( _s )
	{
		return _s + "处于" + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return _s + "不再有" + this.m.Name;
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.BuyPriceMult *= 1.100000;
		_modifiers.SellPriceMult *= 0.900000;
		_modifiers.RarityMult *= 0.900000;
		_modifiers.RecruitsMult *= 0.750000;
	}

});
