this.named_conic_helmet_with_faceguard <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.named_conic_helmet_with_faceguard";
		this.m.Description = "这顶圆锥形头盔有一个面罩和一个很好的鳞片来保护颈部。 面罩像一个即将攻击敌人的可怖的战士。";
		this.m.NameList = [
			"圆锥形羽毛头盔",
			"铁面具",
			"军阀的头盔",
			"铁面",
			"钢制面"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.Variant = 205;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 8000;
		this.m.Condition = 280;
		this.m.ConditionMax = 280;
		this.m.StaminaModifier = -19;
		this.m.Vision = -3;
		this.randomizeValues();
	}

});
