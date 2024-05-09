this.slave_revolt_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.slave_revolt";
		this.m.Name = "奴隶起义";
		this.m.Description = "负债者，城邦的奴隶阶层，举起了武器来对抗他们的主人！负债者是很难得到的，武器和盔甲已从市场上一扫而光。";
		this.m.Icon = "ui/settlement_status/settlement_effect_40.png";
		this.m.Rumors = [
			"%settlement% 的奴隶拿起武器，转而从事土匪的拦路抢劫。自称无垢者还是什么，我琢磨着。很显然会有点活给你这样的雇佣兵干。",
			"有消息说 %settlement% 的奴隶们正在反抗。一场像样的起义可以推翻他们整个城市，我希望是这样。"
		];
		this.m.IsStacking = false;
	}

	function getAddedString( _s )
	{
		return _s + "有一个" + this.m.Name;
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
		_modifiers.RecruitsMult *= 0.75;
		_modifiers.RarityMult *= 0.5;
	}

	function onUpdateDraftList( _draftList )
	{
		for( local i = _draftList.len() - 1; i >= 0; i = --i )
		{
			if (_draftList[i] == "slave_background" || _draftList[i] == "slave_southern_background")
			{
				_draftList.remove(i);
			}
		}
	}

});
