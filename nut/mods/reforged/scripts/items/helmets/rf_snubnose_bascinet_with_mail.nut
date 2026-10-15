this.rf_snubnose_bascinet_with_mail <- ::inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.rf_snubnose_bascinet_with_mail";
		this.m.Name = "衬链猪面盔";
		this.m.Description = "这顶装有猪面护面的中盔提供了现象级的覆盖和防护。单靠加钱可找不到比这还好的头盔了。";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.Variant = 1;
		this.m.VariantString = "rf_snubnose_bascinet_with_mail";
		this.updateVariant();
		this.m.ImpactSound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 5500;
		this.m.Condition = 330;
		this.m.ConditionMax = 330;
		this.m.StaminaModifier = -21;
		this.m.Vision = -3;
	}

});
