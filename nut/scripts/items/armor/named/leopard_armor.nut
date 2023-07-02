this.leopard_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.leopard_armor";
		this.m.Description = "重型多层板状甲胄与精细的链甲和舒适的垫相结合。 一个真正的制作精良的作品，几乎是珍奇物品，很怕它在战斗中撕裂。";
		this.m.NameList = [
			"镀金者的拥抱",
			"镀金者的守卫",
			"闪光札甲",
			"维齐尔的甲胄",
			"沙漠的甲壳",
			"猎人大师的盔甲"
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
