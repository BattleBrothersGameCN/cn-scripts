this.adorned_heavy_mail_hauberk <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.adorned_heavy_mail_hauberk";
		this.m.Name = "装饰重型链锁子甲";
		this.m.Description = "一种沉重的链锁甲，穿在厚的铆接外套内，用纱布加固。 这是一个真正的探险骑士的盔甲，装饰着战利品，尽管使用广泛，但仍得到了精心维护。";
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
