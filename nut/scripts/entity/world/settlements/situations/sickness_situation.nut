this.sickness_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.sickness";
		this.m.Name = "疾病";
		this.m.Description = "一场疾病使这个定居点的许多人丧命。现有的新兵更少，食物和医疗用品也很稀缺。";
		this.m.Icon = "ui/settlement_status/settlement_effect_23.png";
		this.m.Rumors = [
			"不要靠近 %settlement%！一场疾病袭击了那个贫穷的小镇，那里的人们像苍蝇一样死去…",
			"我们有一些人从 %settlement% 来，但不得不把他们送到大门口。每个人都知道一种残酷的恶疾正在那个被诅咒的城镇蔓延。",
			"喜欢我的草药项链吗？它保护我免受最严重的恶疾的侵袭。你最好也买一个，如果你打算去 %settlement%。"
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
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.FoodPriceMult *= 2.000000;
		_modifiers.MedicalPriceMult *= 3.000000;
		_modifiers.RecruitsMult *= 0.250000;
	}

});
