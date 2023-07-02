this.black_and_gold_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.black_and_gold";
		this.m.Description = "古老的知识被用来锻造这套独特的盔甲。 它的轻甲片与黄金夹板重叠提供高保护和易于操控进而减轻负担。";
		this.m.NameList = [
			"镀金者的光辉监护",
			"镀金者的皮肤",
			"太阳斗篷",
			"炽热的链甲",
			"日晒甲胄",
			"光辉锁子甲",
			"蝎子王的盔甲"
		];
		this.m.VariantString = "body_southern_named";
		this.m.Variant = 2;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 9000;
		this.m.Condition = 210;
		this.m.ConditionMax = 210;
		this.m.StaminaModifier = -25;
		this.randomizeValues();
	}

});
