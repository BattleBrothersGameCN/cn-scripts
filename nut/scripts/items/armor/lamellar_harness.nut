this.lamellar_harness <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.lamellar_harness";
		this.m.Name = "札甲";
		this.m.Description = "一件厚重层叠金属甲片制成的身甲，能护住上身大部。";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 88;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 3000;
		this.m.Condition = 230;
		this.m.ConditionMax = 230;
		this.m.StaminaModifier = -30;
	}

});
