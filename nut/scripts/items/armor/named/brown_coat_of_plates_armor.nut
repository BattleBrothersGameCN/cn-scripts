this.brown_coat_of_plates_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.brown_coat_of_plates";
		this.m.Description = "一种用结实金属板组成的厚链锁子甲。即使是最激烈的战斗也能保护其穿戴者。";
		this.m.NameList = [
			"甲胄",
			"守护",
			"防卫",
			"阻截者",
			"板甲",
			"护板背心",
			"救生者"
		];
		this.m.Variant = 45;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 14000;
		this.m.Condition = 300;
		this.m.ConditionMax = 300;
		this.m.StaminaModifier = -36;
		this.randomizeValues();
	}

});
