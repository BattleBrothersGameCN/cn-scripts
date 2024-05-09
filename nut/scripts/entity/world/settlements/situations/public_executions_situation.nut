this.public_executions_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.public_executions";
		this.m.Name = "公开处决";
		this.m.Description = "公开处决是不容错过的，它为全家人提供了娱乐。在这样的场合，食物和饮料都很丰富，但商人也可能会试图利用观众。";
		this.m.Icon = "ui/settlement_status/settlement_effect_14.png";
		this.m.Rumors = [
			"一大群人正赶往 %settlement% 观看盛大的盛会！男人，女人，年轻人，都在路上要赶去看即将到来的处决！",
			"我听说他们在 %settlement% 附近抓了几个强盗，把他们送上了断头台。他们活该，在路上伏击穷人…",
			"现在，我们穷人没有什么好享受的，但是，一个好的绞刑总是受欢迎的。秋天以后这里就没人来过了，但他们在 %settlement% 有一些人，这是 %randomname% 告诉我的。"
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 2;
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
	}

	function onUpdate( _modifiers )
	{
		_modifiers.FoodRarityMult *= 1.35;
		_modifiers.FoodPriceMult *= 1.15;
	}

});
