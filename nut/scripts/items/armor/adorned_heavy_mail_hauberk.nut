this.adorned_heavy_mail_hauberk <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.adorned_heavy_mail_hauberk";
		this.m.Name = "装饰重链铠";
		this.m.Description = "加强了手臂防护，穿在厚重铆接外套下的重型链甲。虽然用得很多，却受到了精心维护和装饰，它的主人是个真正的冒险骑士。";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 109;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 6000;
		this.m.Condition = 300;
		this.m.ConditionMax = 300;
		this.m.StaminaModifier = -34;
	}

});
