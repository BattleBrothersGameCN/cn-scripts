this.golden_feathers_helmet <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.golden_feathers";
		this.m.Description = "国外设计的一款带有完整链甲面罩的坚固合金头盔，可以给予佩戴者最大限度的保护。";
		this.m.NameList = [
			"头饰",
			"金头盖",
			"羽毛头盔",
			"闪闪发光的头盔",
			"带头巾的头盔"
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
