this.rf_half_closed_sallet_with_bevor <- ::inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.rf_half_closed_sallet_with_bevor";
		this.m.Name = "护颈闭面半轻盔";
		this.m.Description = "一件穷工极巧的护颈配上了一顶制作精良的闭面半轻盔。一套只见于最富人身上的昂贵装备。";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.Variant = 1;
		this.m.VariantString = "rf_half_closed_sallet_with_bevor";
		this.updateVariant();
		this.m.ImpactSound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 5000;
		this.m.Condition = 315;
		this.m.ConditionMax = 315;
		this.m.StaminaModifier = -20;
		this.m.Vision = -3;
	}

});
