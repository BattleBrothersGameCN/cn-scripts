this.named_skull_and_chain_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.named_skull_and_chain_armor";
		this.m.Description = "一种粗制的野蛮人盔甲，经过调整后可以保护，但又不太笨重。 它带有北方野蛮部落的典型标志。";
		this.m.NameList = [
			"部落兽皮(Tribal Hide)",
			"蛮族外套 (Barbarian Coat)",
			"扫气装甲",
			"蛮族皮毛(Barbarian Pelt)",
			"原始马具(Primitive Harness)"
		];
		this.m.PrefixList = this.Const.Strings.BarbarianPrefix;
		this.m.UseRandomName = false;
		this.m.Variant = 102;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 5500;
		this.m.Condition = 190;
		this.m.ConditionMax = 190;
		this.m.StaminaModifier = -24;
		this.randomizeValues();
	}

});
