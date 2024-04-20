this.ragged_surcoat <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.rugged_surcoat";
		this.m.Name = "耐用外套";
		this.m.Description = "一件皮革外套，添加了填充物以提升防护性能。通常穿在盔甲之下。";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 20;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 100;
		this.m.Condition = 55;
		this.m.ConditionMax = 55;
		this.m.StaminaModifier = -6;
	}

});
