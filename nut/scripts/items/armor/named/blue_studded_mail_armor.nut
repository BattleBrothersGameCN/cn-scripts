this.blue_studded_mail_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.blue_studded_mail";
		this.m.Description = "这件特殊的锁子甲由厚实的软甲铆接皮夹克制成，质量轻但能提供很好的防护作用。";
		this.m.NameList = [
			"镶甲",
			"蟾蜍皮",
			"食人魔皮",
			"复层装甲",
			"强化甲"
		];
		this.m.Variant = 46;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 4000;
		this.m.Condition = 140;
		this.m.ConditionMax = 140;
		this.m.StaminaModifier = -16;
		this.randomizeValues();
	}

});
