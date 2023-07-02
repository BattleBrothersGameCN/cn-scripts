this.razed_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.razed";
		this.m.Name = "夷为平地";
		this.m.Description = "这个地方被夷为平地。它的许多居民被杀害，任何贵重物品都被抢掠了。";
		this.m.Icon = "ui/settlement_status/settlement_effect_10.png";
		this.m.Rumors = [
			"从几英里外可以看到烟柱。%settlement% 曾经矗立的地方，只不过是一堆燃烧着的瓦砾。",
			"大批难民从 %settlement% 涌来。他们声称大部分都被烧成了白地！这是真的吗？",
			"%settlement% 已不复存在，只不过是一具黑焦的骷髅在冒烟冒烟…怎么会这样？"
		];
		this.m.IsStacking = false;
	}

	function getAddedString( _s )
	{
		return _s + "现在有" + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return _s + "不再有" + this.m.Name;
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
		_settlement.resetRoster(false);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.SellPriceMult *= 0.500000;
		_modifiers.BuyPriceMult *= 2.000000;
		_modifiers.FoodPriceMult *= 2.000000;
		_modifiers.RecruitsMult *= 0.250000;
		_modifiers.RarityMult *= 0.250000;
	}

});
