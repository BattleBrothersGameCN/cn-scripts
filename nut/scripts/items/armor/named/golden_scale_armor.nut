this.golden_scale_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.golden_scale";
		this.m.Description = "一种由细小的连锁鳞片打造的盔甲。这种风格和工艺暗示着盔甲来自遥远的地区。";
		this.m.NameList = [
			"鳞片衬衫",
			"鳞甲",
			"龙鳞甲",
			"蛇皮甲",
			"鳞皮甲",
			"古龙皮",
			"黄金之皮",
			"鳞片外衣",
			"黄金甲",
			"黄金提示"
		];
		this.m.Variant = 44;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 8000;
		this.m.Condition = 240;
		this.m.ConditionMax = 240;
		this.m.StaminaModifier = -28;
		this.randomizeValues();
	}

});
