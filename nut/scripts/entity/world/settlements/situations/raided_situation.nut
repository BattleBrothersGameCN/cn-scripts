this.raided_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.raided";
		this.m.Name = "被掠夺";
		this.m.Description = "这地方最近被掠夺了！它遭受了破坏，失去了宝贵的货物和补给，许多人因此丧命。";
		this.m.Icon = "ui/settlement_status/settlement_effect_08.png";
		this.m.Rumors = [
			"你是掠袭者吗？当然，看起来和闻起来都像！你的人抢劫 %settlement%？离开这里，我说，我们不想你们这种人在身边！",
			"从 %settlement% 来的人说那里被掠夺和抢掠了。可怜的哭泣，但我们该怎么办？我们自己也没什么。上帝应该保护他们！",
			"现在确实是危险时期，佣兵。我刚得到消息说 %settlement% 不到两个晚上就被抢掠和掠夺了。"
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
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.RecruitsMult *= 0.5;
		_modifiers.RarityMult *= 0.5;
	}

});
