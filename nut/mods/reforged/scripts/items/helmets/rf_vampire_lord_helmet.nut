this.rf_vampire_lord_helmet <- ::inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.rf_vampire_lord_helmet";
		this.m.Name = "死灵领主头冠";
		this.m.Description = "死灵领主穿戴的装饰性头冠。";
		this.m.ShowOnCharacter = true;
		this.m.HideHair = false;
		this.m.HideBeard = false;
		this.m.VariantString = "rf_vampire_lord_helmet";
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 1500;
		this.m.Condition = 70;
		this.m.ConditionMax = 70;
		this.m.StaminaModifier = -1;
	}

});
