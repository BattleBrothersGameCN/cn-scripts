this.golden_feathers_helmet <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.golden_feathers";
		this.m.Description = "一顶外来款式的结实合金盔，加装了链甲头肩巾，防护力极佳。";
		this.m.NameList = [
			"头冠",
			"金颅",
			"羽饰盔",
			"熠光盔",
			"衬链盔"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.Variant = 50;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 6000;
		this.m.Condition = 240;
		this.m.ConditionMax = 240;
		this.m.StaminaModifier = -16;
		this.m.Vision = -3;
		this.randomizeValues();
	}

});
