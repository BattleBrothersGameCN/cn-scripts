this.black_leather_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.black_leather";
		this.m.Description = "一种精心制作的硬化皮革盔甲，由加垫的软甲和链甲支撑。穿起来很轻，但是很结实。";
		this.m.NameList = [
			"皮胸甲",
			"链甲衫",
			"皮甲",
			"皮肤",
			"外皮",
			"守卫",
			"外衣",
			"夜斗篷",
			"黑色",
			"黑暗预兆"
		];
		this.m.Variant = 42;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 2000;
		this.m.Condition = 115;
		this.m.ConditionMax = 115;
		this.m.StaminaModifier = -12;
		this.randomizeValues();
	}

});
