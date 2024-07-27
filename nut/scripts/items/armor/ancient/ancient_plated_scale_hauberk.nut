this.ancient_plated_scale_hauberk <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.ancient_plated_scale_hauberk";
		this.m.Name = "古代板鳞甲";
		this.m.Description = "一件部分加固有金属板的重型鳞甲衣。这件巨大的古代盔甲老化严重。";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 69;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 3200;
		this.m.Condition = 210;
		this.m.ConditionMax = 210;
		this.m.StaminaModifier = -30;
	}

});
