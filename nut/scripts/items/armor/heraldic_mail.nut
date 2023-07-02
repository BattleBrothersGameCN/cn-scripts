this.heraldic_mail <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.heraldic_mail";
		this.m.Name = "纹章链甲";
		this.m.Description = "重且特别精心制作的链锁子甲，有附加的锁子手套和软垫底毛。 只有真正的大师才能制作出这样的盔甲。";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 36;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 2500;
		this.m.Condition = 185;
		this.m.ConditionMax = 185;
		this.m.StaminaModifier = -18;
	}

});
