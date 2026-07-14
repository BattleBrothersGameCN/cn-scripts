this.rf_padded_skull_cap_with_rondels <- ::inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.rf_padded_skull_cap_with_rondels";
		this.m.Name = "护盘衬帽颅盔";
		this.m.Description = "一顶装有一对护盘，套在棉甲衬帽上的颅盔。";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.Variant = 1;
		this.m.VariantString = "rf_padded_skull_cap_with_rondels";
		this.updateVariant();
		this.m.ImpactSound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 1500;
		this.m.Condition = 160;
		this.m.ConditionMax = 160;
		this.m.StaminaModifier = -8;
		this.m.Vision = -1;
	}

});
