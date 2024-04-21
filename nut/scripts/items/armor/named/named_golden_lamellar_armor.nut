this.named_golden_lamellar_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.named_golden_lamellar_armor";
		this.m.Description = "精心制作的薄片状盔甲。 它上面覆盖着金箔，这使它真正与众不同。";
		this.m.NameList = [
			"甲胄",
			"守护",
			"防卫",
			"辉煌",
			"金札甲"
		];
		this.m.Variant = 100;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 11000;
		this.m.Condition = 285;
		this.m.ConditionMax = 285;
		this.m.StaminaModifier = -40;
		this.randomizeValues();
	}

});
