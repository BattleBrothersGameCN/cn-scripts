this.thick_dark_tunic <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.thick_dark_tunic";
		this.m.Name = "黑厚束腰外衣";
		this.m.Description = "一件多层黑色厚布束腰外衣，能抵御天气和擦伤。";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 60;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 75;
		this.m.Condition = 35;
		this.m.ConditionMax = 35;
		this.m.StaminaModifier = -2;
	}

});
