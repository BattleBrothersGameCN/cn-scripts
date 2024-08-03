this.golden_scale_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.golden_scale";
		this.m.Description = "一件细密层叠鳞状金属甲片制成的铠甲。这种风格和工艺暗示这件盔甲来自遥远的国度。";
		this.m.NameList = [
			"鳞甲衫",
			"鳞甲",
			"龙鳞甲",
			"蛇皮甲",
			"鳞皮甲",
			"古龙皮",
			"金皮",
			"鳞片外衣",
			"黄金甲",
			"金色遗物"
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
