this.full_nets_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.full_nets";
		this.m.Name = "渔获颇丰";
		this.m.Description = "水里有成群的鱼。鲜鱼资源丰富，价格便宜。";
		this.m.Icon = "ui/settlement_status/settlement_effect_19.png";
		this.m.Rumors = [
			"每年这个时候，%settlement%总会有大批的鱼来。他们所需要做的就是把一些网扔进水里，然后拉出比他们能吃掉的更多的鱼！幸运的混蛋！",
			"明天我要去%settlement%，把我的货车装满鱼。据说那边的渔民们走运了！",
			"你是做贸易的吗？我听说%settlement%那儿的渔网里装满了鱼。"
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 3;
	}

	function getAddedString( _s )
	{
		return _s + "处于" + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return _s + "不再" + this.m.Name;
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.FoodRarityMult *= 2.0;
		_modifiers.FoodPriceMult *= 0.5;
	}

});
