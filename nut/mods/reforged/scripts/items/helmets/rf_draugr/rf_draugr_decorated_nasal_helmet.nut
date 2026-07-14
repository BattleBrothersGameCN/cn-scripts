this.rf_draugr_decorated_nasal_helmet <- ::inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.rf_draugr_decorated_nasal_helmet";
		this.m.Name = "墓穴装饰护鼻盔";
		this.m.Description = "这顶古老的头盔工艺精湛，盔顶上还装饰着野猪图案。";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = false;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.Variant = 1;
		this.m.VariantString = "rf_draugr_helmet_16";
		this.updateVariant();
		this.m.ImpactSound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 750;
		this.m.Condition = 150;
		this.m.ConditionMax = 150;
		this.m.StaminaModifier = -11;
		this.m.Vision = -1;
	}

});
