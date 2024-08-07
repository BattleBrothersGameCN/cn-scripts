this.named_sellswords_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.named_sellswords_armor";
		this.m.Description = "这件多层护甲曾属于一位著名的雇佣兵。它的高弹性和柔韧性使它成为了一件杰出的工艺品。它甚至还带着额外的口袋！";
		this.m.NameList = [
			"佣兵外套",
			"佣兵的遮挡",
			"复层装甲",
			"板甲衣"
		];
		this.m.Variant = 101;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 10000;
		this.m.Condition = 260;
		this.m.ConditionMax = 260;
		this.m.StaminaModifier = -32;
		this.randomizeValues();
	}

});
