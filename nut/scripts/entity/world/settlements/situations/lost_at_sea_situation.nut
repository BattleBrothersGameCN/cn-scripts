this.lost_at_sea_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.lost_at_sea";
		this.m.Name = "海上遇难";
		this.m.Description = "一艘载着渔民的船在暴风雨中在海上失踪了。新鲜的鱼和自愿的新兵都是罕见的景象。";
		this.m.Icon = "ui/settlement_status/settlement_effect_18.png";
		this.m.Rumors = [
			"他们再也没有从海上回来过…想到从 %settlement% 失去的所有可怜的灵魂，我不禁发抖",
			"%settlement% 的讨厌的姑娘们，哭哭啼啼。我去卖了几头猪给他们，但他们只是嚎啕大哭，找不到一个人。是什么船在海上失踪了还是什么。一头猪也没卖出去。",
			"航海一直是一种危险的职业。所以我才背对着水。我可以说，时间正好，否则，在那艘迷路的船上可能是我，那里是 %settlement%。"
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 4;
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
		_modifiers.FoodRarityMult *= 0.5;
		_modifiers.FoodPriceMult *= 2.0;
		_modifiers.RecruitsMult *= 0.5;
	}

});
