this.named_nordic_helmet_with_closed_mail <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.named_nordic_helmet_with_closed_mail";
		this.m.Description = "这顶护面北欧盔工艺出众，外观和防护能力俱佳，令人久久不能忘怀。";
		this.m.NameList = [
			"海寇盔",
			"枭盔",
			"装饰北欧盔",
			"酋长盔",
			"蚀刻北欧盔",
			"贵族北欧盔"
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
