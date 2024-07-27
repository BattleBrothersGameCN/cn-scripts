this.named_plated_fur_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.named_plated_fur_armor";
		this.m.Description = "一件在外侧铆接了厚重金属板状甲片的简单毛皮甲。简单又沉重，在战斗中却非常有效。";
		this.m.NameList = [
			"毛皮板甲",
			"钢板甲胄",
			"覆板皮甲",
			"毛铆甲"
		];
		this.m.PrefixList = this.Const.Strings.BarbarianPrefix;
		this.m.UseRandomName = false;
		this.m.Variant = 104;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 4000;
		this.m.Condition = 130;
		this.m.ConditionMax = 130;
		this.m.StaminaModifier = -14;
		this.randomizeValues();
	}

});
