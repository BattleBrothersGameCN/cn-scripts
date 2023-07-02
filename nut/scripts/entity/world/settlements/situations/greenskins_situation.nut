this.greenskins_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.greenskins";
		this.m.Name = "绿皮劫掠";
		this.m.Description = "绿皮正在恐吓周围的土地，很多人已经失去了生命，因为兽人或地精继续突袭边远的商队和夷为平地的农场。补给开始减少，人们变得绝望。";
		this.m.Icon = "ui/settlement_status/settlement_effect_01.png";
		this.m.Rumors = [
			"我听说有谣言说卑鄙的绿皮在 %settlement% 到处劫掠！是真的吗？我希望他们不要过来…",
			"你看见夜空中的烟柱了吗？它们从 %settlement% 升起，绿皮在那里焚烧和掠夺乡村。",
			"来，看看我手上还剩下什么！我几乎不能再使用它了，因为它已经没有手指了，因为不久前和绿皮发生了冲突。现在我听说他们回来了，就在我们说话的时候在 %settlement% 四处劫掠。"
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
		_settlement.resetShop();
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.RarityMult *= 0.750000;
		_modifiers.RecruitsMult *= 0.750000;
	}

});
