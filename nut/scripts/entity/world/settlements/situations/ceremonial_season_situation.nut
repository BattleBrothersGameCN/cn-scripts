this.ceremonial_season_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.ceremonial_seasonn";
		this.m.Name = "仪式季节";
		this.m.Description = "在祭典时节，神殿会消耗大量的熏香。对熏香的需求和价格都处于历史最高水平。";
		this.m.Icon = "ui/settlement_status/settlement_effect_44.png";
		this.m.Rumors = [
			"每年的这个时候，%settlement%的神殿就像着火的窝棚一样冒烟！我想知道他们是从哪里弄来的香……",
			"如果你是一个虔诚的人，你可能会想去%settlement%烧香和祈祷。"
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 3;
	}

	function getAddedString( _s )
	{
		return _s + "现在处于" + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return _s + "不再处于" + this.m.Name;
	}

	function onAdded( _settlement )
	{
	}

	function onUpdate( _modifiers )
	{
		_modifiers.IncensePriceMult *= 1.500000;
	}

});
