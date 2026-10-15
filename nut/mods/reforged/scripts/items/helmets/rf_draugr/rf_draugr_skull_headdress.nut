this.rf_draugr_skull_headdress <- ::inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.rf_draugr_skull_headdress";
		this.m.Name = "墓穴羊头头饰";
		this.m.Description = "一件公羊头骨制成的头饰，可能属于某位精神领袖。";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = false;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.Variant = ::Math.rand(1, 2);
		this.m.VariantString = "rf_draugr_helmet_09";
		this.updateVariant();
		this.m.ImpactSound = ::Const.Sound.ArmorBoneImpact;
		this.m.InventorySound = ::Const.Sound.ClothEquip;
		this.m.Value = 250;
		this.m.Condition = 70;
		this.m.ConditionMax = 70;
		this.m.StaminaModifier = -5;
		this.m.Vision = -1;
	}

});
