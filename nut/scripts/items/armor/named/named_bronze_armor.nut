this.named_bronze_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.named_bronze_armor";
		this.m.Description = "这种盔甲是由一种奇怪的合金制成的，按照野蛮人的标准精心制作。 一件真正的珍品。";
		this.m.NameList = [
			"哑光甲",
			"合金板装甲",
			"受污染的保障",
			"部落板甲"
		];
		this.m.PrefixList = this.Const.Strings.BarbarianPrefix;
		this.m.UseRandomName = false;
		this.m.Variant = 103;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 9000;
		this.m.Condition = 280;
		this.m.ConditionMax = 280;
		this.m.StaminaModifier = -35;
		this.randomizeValues();
	}

});
