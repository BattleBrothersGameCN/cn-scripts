this.rf_half_closed_sallet_with_mail <- ::inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.rf_half_closed_sallet_with_mail";
		this.m.Name = "衬链闭面半轻盔";
		this.m.Description = "一顶穿在链甲头肩巾上的精制闭面半轻盔。提供了极好的防护。";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.Variant = 1;
		this.m.VariantString = "rf_half_closed_sallet_with_mail";
		this.updateVariant();
		this.m.ImpactSound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 4000;
		this.m.Condition = 290;
		this.m.ConditionMax = 290;
		this.m.StaminaModifier = -18;
		this.m.Vision = -2;
	}

});
