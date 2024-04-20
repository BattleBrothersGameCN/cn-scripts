this.undertaker_apron <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.undertaker_apron";
		this.m.Name = "送葬者围裙";
		this.m.Description = "一种厚皮围裙，可以防止轻度割伤和擦伤。";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 110;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 65;
		this.m.Condition = 30;
		this.m.ConditionMax = 30;
		this.m.StaminaModifier = 0;
	}

});
