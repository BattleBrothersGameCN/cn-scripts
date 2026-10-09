this.rf_padded_sallet_helmet <- ::inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.rf_padded_sallet_helmet";
		this.m.Name = "衬帽轻盔";
		this.m.Description = "一顶穿在棉甲衬帽上的精制轻盔。在不超重的前提下提供了很好的防护。";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.Variant = 1;
		this.m.VariantString = "rf_padded_sallet_helmet";
		this.updateVariant();
		this.m.ImpactSound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 2000;
		this.m.Condition = 180;
		this.m.ConditionMax = 180;
		this.m.StaminaModifier = -9;
		this.m.Vision = -1;
	}

});
