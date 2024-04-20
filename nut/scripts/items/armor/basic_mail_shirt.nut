this.basic_mail_shirt <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.basic_mail_shirt";
		this.m.Name = "标准链甲衫";
		this.m.Description = "一件朴实无华的链甲衫。以实惠的价格提供了良好的劈砍和戳刺防护。";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 26;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 450;
		this.m.Condition = 115;
		this.m.ConditionMax = 115;
		this.m.StaminaModifier = -12;
	}

});
