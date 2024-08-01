this.gold_and_black_turban <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.gold_and_black_turban";
		this.m.Description = "这顶南方风头盔可不只是看着气派，其重量分布合理，所用材料也是一流。";
		this.m.NameList = [
			"南方之冠",
			"沙漠羽冠",
			"赤日缠头",
			"金羽冠",
			"维齐尔之傲",
			"沙王之盔",
			"蝎之盔",
			"庇日者",
			"镀金者之傲",
			"镀金者之容"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.VariantString = "helmet_southern_named";
		this.m.Variant = 2;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 6000;
		this.m.Condition = 290;
		this.m.ConditionMax = 290;
		this.m.StaminaModifier = -20;
		this.m.Vision = -3;
		this.randomizeValues();
	}

});
