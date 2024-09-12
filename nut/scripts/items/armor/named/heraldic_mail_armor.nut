this.heraldic_mail_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.heraldic_mail";
		this.m.Description = "用最好的材料制成，最华贵的饰品装点，这件长身链甲配得上一位正牌骑士。";
		this.m.NameList = [
			"纹章链甲",
			"辉煌",
			"华丽",
			"盛典礼服",
			"优雅",
			"全身链甲",
			"全身链铠",
			"锁甲",
			"荣誉",
			"荣耀",
			"贵族链甲"
		];
		this.m.Variant = 36;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 7000;
		this.m.Condition = 210;
		this.m.ConditionMax = 210;
		this.m.StaminaModifier = -26;
		this.randomizeValues();
	}

});
