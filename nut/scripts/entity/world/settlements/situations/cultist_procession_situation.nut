this.cultist_procession_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.cultist_procession";
		this.m.Name = "邪教徒游行";
		this.m.Description = "有一队邪教徒穿过城市；源源不断的人似乎凭空出现，现在慢慢地沿着主要道路前进。他们身着柔和的色彩，敲响铃铛，单调地吟唱着达库尔的名字。";
		this.m.Icon = "ui/settlement_status/settlement_effect_37.png";
		this.m.Rumors = [
			"我刚看到最令人毛骨悚然的游行队伍经过 %settlement%！蒙面的人影，鞭打着自己的后背，直到他们都血淋淋的…",
			"%settlement% 到处都是奇怪的邪教徒，他们肯定在干坏事！我得说，应该有人把女巫猎人送过去！",
			"它醒了！沉睡的野兽即将从长达一个世纪的沉睡中醒来！去 %settlement%，我的宗教兄弟们也会告诉你的！达库尔会来的！"
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
		_settlement.resetRoster(true);
	}

	function onRemoved( _settlement )
	{
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
	}

	function onUpdateDraftList( _draftList )
	{
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
	}

});
