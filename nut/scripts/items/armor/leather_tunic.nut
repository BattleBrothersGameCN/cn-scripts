this.leather_tunic <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.leather_tunic";
		this.m.Name = "皮革束腰外衣";
		this.m.Description = "一件套有皮坎肩的布制束腰外衣，增强了防护能力。";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 13;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 65;
		this.m.Condition = 30;
		this.m.ConditionMax = 30;
		this.m.StaminaModifier = 0;
	}

});
