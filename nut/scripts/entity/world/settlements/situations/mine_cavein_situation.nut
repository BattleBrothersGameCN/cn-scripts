this.mine_cavein_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.mine_cavein";
		this.m.Name = "矿山塌方";
		this.m.Description = "在一个山洞的一个矿井里，一场悲惨的事故发生了。生产停止，直到损害得到修复，矿工们没有办法养家糊口。";
		this.m.Icon = "ui/settlement_status/settlement_effect_24.png";
		this.m.Rumors = [
			"我从不在地下工作，我不是臭鼹鼠！这是个该死的死亡陷阱！不久前，%settlement% 的一个矿井被毁了，我甚至不想知道那天死了多少人…",
			"从 %settlement% 的矿场运来的矿石和矿物预计今天就到了，可惜还没到。那边一定发生了什么事。",
			"听说 %settlement% 的一个矿井发生了塌方。想象一下被活埋在岩石和泥土的深处…"
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 5;
	}

	function getAddedString( _s )
	{
		return _s + "有" + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return _s + "不再受损于" + this.m.Name;
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.RecruitsMult *= 1.250000;
	}

	function onUpdateShop( _stash )
	{
		do
		{
		}
		while (_stash.removeByID("misc.uncut_gems") != null);

		do
		{
		}
		while (_stash.removeByID("misc.copper_ingots") != null);
	}

	function onUpdateDraftList( _draftList )
	{
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
	}

});
