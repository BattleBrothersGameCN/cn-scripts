this.ancient_plate_harness <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.ancient_plate_harness";
		this.m.Name = "古代板甲";
		this.m.Description = "这件厚金属板和链环制成的沉重古代盔甲，历经岁月洗礼，仍能提供强大的保护。但一些部件已经锈蚀硬结，严重限制了穿戴者的机动性。";
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
