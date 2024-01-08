this.collectors_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.collectors";
		this.m.Name = "收藏家";
		this.m.Description = "有几个寻求异国古董的收藏家来到镇上。在这里，出售野兽战利品能获得不错的收益。";
		this.m.Icon = "ui/settlement_status/settlement_effect_46.png";
		this.m.Rumors = [
			"你们是猎兽人吗？我听说在%settlement%出现了一些奇怪的人，他们正在购买他们能找到的每一个奇异的怪物战利品。",
			"看到这个狗牙了吗？我打算把它卖到%settlement%，我听说那儿有人愿意为对动物身上的一些东西付的很多钱。",
			"似乎各路野兽猎人和捡尸者都聚集在%settlement%。我听说是为了出售野兽战利品。听起来有点像巫术。"
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 3;
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
		_modifiers.BeastPartsPriceMult *= 2.000000;
		_modifiers.RecruitsMult *= 1.250000;
	}

	function onUpdateDraftList( _draftList )
	{
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");

		if (this.Const.DLC.Unhold)
		{
			_draftList.push("beast_hunter_background");
			_draftList.push("beast_hunter_background");
			_draftList.push("beast_hunter_background");
			_draftList.push("beast_hunter_background");
			_draftList.push("beast_hunter_background");
		}

		if (this.Const.DLC.Paladins)
		{
			_draftList.push("anatomist_background");
			_draftList.push("anatomist_background");
			_draftList.push("anatomist_background");
			_draftList.push("anatomist_background");
			_draftList.push("anatomist_background");
		}
	}

});
