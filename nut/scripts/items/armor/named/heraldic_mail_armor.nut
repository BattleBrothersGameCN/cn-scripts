this.heraldic_mail_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.heraldic_mail";
		this.m.Description = "这锁子甲是由最高质量的材料和珍贵的装饰品制成，适合真正的骑士。";
		this.m.NameList = [
			"纹章链甲",
			"辉煌",
			"华丽",
			"盛典",
			"优雅",
			"完整裹体",
			"全身链铠",
			"锁甲",
			"荣誉",
			"荣誉",
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
