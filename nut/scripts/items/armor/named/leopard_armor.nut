this.leopard_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.leopard_armor";
		this.m.Description = "一件复合了细密链甲和舒适衬垫的重型札板甲。一件真正的匠心之作，生怕它会在战斗中损坏。";
		this.m.NameList = [
			"镀金者的拥抱",
			"镀金者的守护",
			"闪光札甲",
			"维齐尔的甲胄",
			"沙漠之壳",
			"大师猎人之甲"
		];
		this.m.VariantString = "body_southern_named";
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 15000;
		this.m.Condition = 290;
		this.m.ConditionMax = 290;
		this.m.StaminaModifier = -35;
		this.randomizeValues();
	}

});
