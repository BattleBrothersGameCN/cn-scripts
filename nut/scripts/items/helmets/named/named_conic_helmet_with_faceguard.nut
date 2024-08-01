this.named_conic_helmet_with_faceguard <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.named_conic_helmet_with_faceguard";
		this.m.Description = "这顶锥形盔安装了一具护面，以及一块细密鳞状甲片排列成的护颈。护面上的雕饰神似一位磨刀霍霍的战士。";
		this.m.NameList = [
			"羽饰锥形盔",
			"铁面具",
			"军阀盔",
			"铁面",
			"钢之貌"
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
