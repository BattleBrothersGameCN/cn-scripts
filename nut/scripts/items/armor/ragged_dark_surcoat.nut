this.ragged_dark_surcoat <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.rugged_dark_surcoat";
		this.m.Name = "耐用黑外套";
		this.m.Description = "一件深色皮革斗篷，罩在毛皮大衣上增加防护。";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 61;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 100;
		this.m.Condition = 60;
		this.m.ConditionMax = 60;
		this.m.StaminaModifier = -4;
	}

});
