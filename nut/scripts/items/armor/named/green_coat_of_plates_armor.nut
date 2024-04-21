this.green_coat_of_plates_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.green_coat_of_plates";
		this.m.Description = "一种用链甲和额外衬垫加固的罕见的板甲。 一件真正的艺术品！";
		this.m.NameList = [
			"板甲衣",
			"堡垒",
			"甲壳",
			"坚壳",
			"胸板甲",
			"厚板外衣",
			"甲胄",
			"守护"
		];
		this.m.Variant = 43;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 15000;
		this.m.Condition = 320;
		this.m.ConditionMax = 320;
		this.m.StaminaModifier = -42;
		this.randomizeValues();
	}

});
