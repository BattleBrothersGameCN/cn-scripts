this.sand_storm_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.sand_storm";
		this.m.Name = "沙尘暴";
		this.m.Description = "呼啸的沙尘暴吞噬了这座城市，阻碍了商人安全进出。商品越来越稀缺，价格越来越高。";
		this.m.Icon = "ui/settlement_status/settlement_effect_38.png";
		this.m.Rumors = [
			"我刚从 %settlement% 回来，差点就没出来！一场沙尘暴席卷了整个城市！",
			"事情再次发生，%settlement% 已经被最可怕的沙尘暴吞噬了。"
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 3;
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
		_modifiers.BuyPriceMult *= 1.2;
		_modifiers.SellPriceMult *= 1.1;
		_modifiers.RarityMult *= 0.75;
	}

});
