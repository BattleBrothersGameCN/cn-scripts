this.mustering_troops_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.mustering_troops";
		this.m.Name = "集合部队";
		this.m.Description = "在这个定居点，已经下令集合部队服役。装备和新兵供应不足，但在这里出售武器和盔甲可以迅速获得克朗。";
		this.m.Icon = "ui/settlement_status/settlement_effect_35.png";
		this.m.Rumors = [
			"另一个该死的贵族正在 %settlement% 把年轻人逼进一个团。啊，为什么我要跟你谈这个，佣兵？你一点也不好！",
			"如果我是一个装满武器和盔甲的商人，我就知道在哪里卖它－他们在 %settlement% 集结军队，肯定会付出很高的代价。唉，我既不是商人也没有武器。",
			"我只是在低谷。勉强逃出 %settlement% 的强征入伍。他们想强迫我为某个领主而战，但不，谢谢，我说，不会发生的，我就走了。我要在更南边碰碰运气。"
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 4;
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
		_modifiers.PriceMult *= 1.250000;
		_modifiers.RecruitsMult *= 0.500000;
		_modifiers.RarityMult *= 0.500000;
	}

});
