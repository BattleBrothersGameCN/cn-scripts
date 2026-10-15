this.rf_sallet_helmet_with_bevor <- ::inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.rf_sallet_helmet_with_bevor";
		this.m.Name = "护颈轻盔";
		this.m.Description = "一顶配有上品护颈的精制轻盔。一件提供了极佳防护能力的昂贵装备。";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.Variant = 1;
		this.m.VariantString = "rf_sallet_helmet_with_bevor";
		this.updateVariant();
		this.m.ImpactSound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 3500;
		this.m.Condition = 275;
		this.m.ConditionMax = 275;
		this.m.StaminaModifier = -17;
		this.m.Vision = -2;
	}

});
