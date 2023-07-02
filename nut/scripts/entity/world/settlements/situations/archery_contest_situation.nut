this.archery_contest_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.archery_contest";
		this.m.Name = "射箭比赛";
		this.m.Description = "射箭比赛吸引了任何精通弓的人。也许是寻找新员工的好时机。";
		this.m.Icon = "ui/settlement_status/settlement_effect_31.png";
		this.m.Rumors = [
			"如果你是一个熟练的弓箭手，你可能会想去 %settlement% 的那场大型比赛，让他们射箭！",
			"你知道，我发誓，我自己曾经是远近最好的弓箭手！直到一头该死的驴子踩到我的手。否则，我现在就在 %settlement% 参加射箭比赛了…",
			"这些天，任何熟练的弓箭手都要去 %settlement% 参加比赛。我想，他们中的大多数是偷猎者和其他贱民。"
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
		_modifiers.RecruitsMult *= 1.250000;
	}

	function onUpdateDraftList( _draftList )
	{
		_draftList.push("hunter_background");
		_draftList.push("hunter_background");
		_draftList.push("hunter_background");
		_draftList.push("hunter_background");
		_draftList.push("hunter_background");
		_draftList.push("hunter_background");
		_draftList.push("hunter_background");
		_draftList.push("hunter_background");
		_draftList.push("hunter_background");
		_draftList.push("hunter_background");
		_draftList.push("hunter_background");
		_draftList.push("poacher_background");
		_draftList.push("poacher_background");
		_draftList.push("poacher_background");
		_draftList.push("poacher_background");
		_draftList.push("poacher_background");
		_draftList.push("poacher_background");
		_draftList.push("poacher_background");
		_draftList.push("poacher_background");
		_draftList.push("poacher_background");
		_draftList.push("poacher_background");
		_draftList.push("poacher_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("sellsword_background");
		_draftList.push("sellsword_background");
		_draftList.push("sellsword_background");

		if (this.Const.DLC.Unhold)
		{
			_draftList.push("beast_hunter_background");
			_draftList.push("beast_hunter_background");
			_draftList.push("beast_hunter_background");
			_draftList.push("beast_hunter_background");
			_draftList.push("beast_hunter_background");
			_draftList.push("beast_hunter_background");
			_draftList.push("beast_hunter_background");
		}
	}

});
