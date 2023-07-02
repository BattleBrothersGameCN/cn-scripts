this.heraldic_mail_helmet <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.heraldic_mail";
		this.m.Description = "在链甲上面附有活动面罩的重型头盔。 它适合真正的骑士。";
		this.m.NameList = [
			"覆面式链甲盔",
			"骑士中型盔",
			"纹章中头盔",
			"帽檐中头盔",
			"纹章头盔",
			"骑士头盔"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.Variant = 53;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 8000;
		this.m.Condition = 280;
		this.m.ConditionMax = 280;
		this.m.StaminaModifier = -19;
		this.m.Vision = -2;
		this.randomizeValues();
	}

});
