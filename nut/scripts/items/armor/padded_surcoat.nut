this.padded_surcoat <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.padded_surcoat";
		this.m.Name = "填充外套";
		this.m.Description = "一件用羊毛填充的布衣。";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 14;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 90;
		this.m.Condition = 50;
		this.m.ConditionMax = 50;
		this.m.StaminaModifier = -4;
	}

});
