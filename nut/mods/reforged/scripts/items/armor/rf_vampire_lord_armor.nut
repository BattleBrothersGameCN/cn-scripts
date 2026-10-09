this.rf_vampire_lord_armor <- ::inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.rf_vampire_lord_armor";
		this.m.Name = "死灵领主胸甲";
		this.m.Description = "死灵领主穿戴的装饰护胸甲，提供了一定的防护。";
		this.m.SlotType = ::Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.VariantString = "rf_vampire_lord_armor";
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 1000;
		this.m.Condition = 70;
		this.m.ConditionMax = 70;
		this.m.StaminaModifier = -5;
	}

});
