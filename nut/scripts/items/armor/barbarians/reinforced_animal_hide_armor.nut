this.reinforced_animal_hide_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.reinforced_animal_hide_armor";
		this.m.Name = "强化兽皮甲";
		this.m.Description = "一件在厚皮革上加强有链甲和金属鳞片的兽皮甲。";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 97;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 120;
		this.m.Condition = 65;
		this.m.ConditionMax = 65;
		this.m.StaminaModifier = -7;
	}

});
