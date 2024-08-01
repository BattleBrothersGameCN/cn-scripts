this.red_and_gold_band_helmet <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.red_and_gold_band_helmet";
		this.m.Description = "这顶南方风头盔可不只是看着气派，其重量分布合理，所用材料更是优中选优。";
		this.m.NameList = [
			"板条盔",
			"多层盔",
			"沙王之冠",
			"炽穹",
			"游牧王冠",
			"羽饰板条盔"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.VariantString = "helmet_southern_named";
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 6000;
		this.m.Condition = 255;
		this.m.ConditionMax = 255;
		this.m.StaminaModifier = -17;
		this.m.Vision = -2;
		this.randomizeValues();
	}

});
