this.rf_brigandine_shirt <- ::inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.rf_brigandine_shirt";
		this.m.Name = "镶甲衫";
		this.m.Description = "穿在麻衣和软甲之外，用层层甲片在布制衣衫上嵌铆而成的镶甲。以最小的机动损失换来了较好的防护。";
		this.m.SlotType = ::Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = ::Math.rand(1, 5);
		this.m.VariantString = "rf_brigandine_shirt";
		this.updateVariant();
		this.m.ImpactSound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 3000;
		this.m.Condition = 190;
		this.m.ConditionMax = 190;
		this.m.StaminaModifier = -21;
	}

});
