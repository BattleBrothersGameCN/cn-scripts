this.ancient_plate_harness <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.ancient_plate_harness";
		this.m.Name = "古代胄板甲";
		this.m.Description = "这件沉重的古代盔甲用厚金属板和链甲制成，历经无数年仍能提供巨大的保护。然而它部分已经腐烂得很粗糙了，这严重限制了穿戴者的机动性。";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 67;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 2800;
		this.m.Condition = 200;
		this.m.ConditionMax = 200;
		this.m.StaminaModifier = -28;
	}

});
