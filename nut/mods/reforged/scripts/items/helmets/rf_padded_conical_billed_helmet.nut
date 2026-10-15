this.rf_padded_conical_billed_helmet <- ::inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.rf_padded_conical_billed_helmet";
		this.m.Name = "衬帽尖顶鸭嘴盔";
		this.m.Description = "一顶套有棉甲衬帽的异域风格头盔，其突出的鸭嘴形护面，用较少的金属护住了面部大部。";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.Variant = 1;
		this.m.VariantString = "rf_padded_conical_billed_helmet";
		this.updateVariant();
		this.m.ImpactSound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 2900;
		this.m.Condition = 245;
		this.m.ConditionMax = 245;
		this.m.StaminaModifier = -14;
		this.m.Vision = -2;
	}

});
