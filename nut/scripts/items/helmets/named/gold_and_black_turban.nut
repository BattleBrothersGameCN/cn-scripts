this.gold_and_black_turban <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.gold_and_black_turban";
		this.m.Description = "这种南方风格的头盔不仅装饰丰富，而且平衡良好，由最高质量的材料制成。";
		this.m.NameList = [
			"南方王冠",
			"沙漠冠",
			"太阳头巾",
			"金冠",
			"维齐尔的骄傲",
			"沙王之舵",
			"太阳面纱",
			"太阳斗篷",
			"镀金者的骄傲",
			"镀金者的面容"
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
