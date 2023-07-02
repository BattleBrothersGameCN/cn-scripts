this.abducted_children_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.abducted_children";
		this.m.Name = "被拐卖儿童";
		this.m.Description = "孩子们从这个定居点消失了。不信任和恐惧统治着街道，并慢慢毒害着社区。";
		this.m.Icon = "ui/settlement_status/settlement_effect_34.png";
		this.m.Rumors = [
			"有传言说，有传言说孩子们从 %settlement% 的婴儿床上消失得无影无踪。想象一下父母的恐惧…",
			"我奶奶给我讲了一个故事，说女巫为了孩子的清白血液而拐走他们。现在在 %settlement%，孩子们像故事里那样失踪了。",
			"永远不要和女巫做交易！%settlement% 的一个亲戚几年前做的，现在他的孩子失踪了"
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

	function onAdded( _settlement )
	{
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.BuyPriceMult *= 1.250000;
		_modifiers.SellPriceMult *= 0.750000;
		_modifiers.RecruitsMult *= 0.500000;
	}

});
