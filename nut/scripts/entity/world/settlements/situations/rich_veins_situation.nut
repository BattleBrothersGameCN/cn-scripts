this.rich_veins_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.rich_veins";
		this.m.Name = "丰富的矿脉";
		this.m.Description = "一些幸运的矿工找到了一条特别丰富的矿脉！矿产和金属的开采量将大大增加，直到耗尽，但定居点的物价也上涨了。";
		this.m.Icon = "ui/settlement_status/settlement_effect_33.png";
		this.m.Rumors = [
			"他们在 %settlement% 的一个母矿脉里打起来了。我自己也在矿井里工作了几十年，我所能表现出来的只是一次严重的咳嗽。",
			"%settlement% 那些幸运的混蛋在矿井里发现了新矿脉。商队现在铲起的东西还不够快。",
			"我听说 %settlement% 的矿山最近生产效率很高。如果你在做生意的话，这是个不错的赚硬币方法。"
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 4;
	}

	function getAddedString( _s )
	{
		return _s + "有" + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return _s + "不再有" + this.m.Name;
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.SellPriceMult *= 1.100000;
		_modifiers.BuyPriceMult *= 1.100000;
		_modifiers.MineralRarityMult = 1.500000;
	}

});
