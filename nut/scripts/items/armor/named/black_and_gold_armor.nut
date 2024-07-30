this.black_and_gold_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.black_and_gold";
		this.m.Description = "锻制这套甲用上了古代的智识。它由轻质链甲与金色条状甲片层叠而成，提供较高保护能力的同时把负重控制在了合理范围之内。";
		this.m.NameList = [
			"镀金者的光辉守护",
			"镀金者之肤",
			"庇日者",
			"炽热链甲",
			"日灼甲",
			"闪光链铠",
			"蝎王铠甲"
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
