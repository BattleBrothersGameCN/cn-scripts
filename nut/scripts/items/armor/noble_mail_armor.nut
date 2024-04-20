this.noble_mail_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.noble_mail";
		this.m.Name = "贵族链甲";
		this.m.Description = "一件独具匠心的链甲。轻便灵活不累人的同时保证了良好的防御力。";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 87;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 2500;
		this.m.Condition = 160;
		this.m.ConditionMax = 160;
		this.m.StaminaModifier = -15;
	}

});
