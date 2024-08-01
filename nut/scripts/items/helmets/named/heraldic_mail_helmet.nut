this.heraldic_mail_helmet <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.heraldic_mail";
		this.m.Description = "一顶配有活动面罩，下有链甲头肩巾的重型中盔。对正牌骑士来说张扬得恰到好处。";
		this.m.NameList = [
			"链甲中盔",
			"骑士中盔",
			"纹章中盔",
			"护面中盔",
			"纹章盔",
			"骑士盔"
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
