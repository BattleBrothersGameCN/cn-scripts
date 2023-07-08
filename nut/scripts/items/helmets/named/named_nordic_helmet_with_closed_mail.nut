this.named_nordic_helmet_with_closed_mail <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.named_nordic_helmet_with_closed_mail";
		this.m.Description = "这顶带护面的北欧头盔是特别制作的，它的保护性和令人印象深刻的外观一样。";
		this.m.NameList = [
			"海上掠袭者头盔",
			"猫头鹰头盔",
			"装饰的北欧头盔",
			"酋长头盔",
			"北欧雕刻头盔",
			"北欧贵族头盔"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.Variant = 206;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 7500;
		this.m.Condition = 265;
		this.m.ConditionMax = 265;
		this.m.StaminaModifier = -18;
		this.m.Vision = -2;
		this.randomizeValues();
	}

});
