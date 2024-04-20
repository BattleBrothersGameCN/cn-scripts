this.butcher_apron <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.butcher_apron";
		this.m.Name = "屠宰围裙";
		this.m.Description = "屠夫穿戴的结实围裙，用于防止意外割伤。";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 9;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 55;
		this.m.Condition = 25;
		this.m.ConditionMax = 25;
		this.m.StaminaModifier = 0;
	}

});
