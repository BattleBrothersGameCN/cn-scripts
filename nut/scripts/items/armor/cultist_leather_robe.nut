this.cultist_leather_robe <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.cultist_leather_robe";
		this.m.Name = "邪教徒皮袍";
		this.m.Description = "一件覆盖着强化皮革甲片和神秘纹饰的厚皮甲。";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 106;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 240;
		this.m.Condition = 88;
		this.m.ConditionMax = 88;
		this.m.StaminaModifier = -9;
	}

});
