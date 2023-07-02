this.named_plated_fur_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.named_plated_fur_armor";
		this.m.Description = "一个简单的毛皮和皮革装甲与厚层金属板铆接在一起。 一个非常简单和沉重的设计，但在战斗中相当有效。";
		this.m.NameList = [
			"镀毛皮铠甲",
			"钢板甲胄",
			"板盖皮",
			"铆接毛皮"
		];
		this.m.PrefixList = this.Const.Strings.BarbarianPrefix;
		this.m.UseRandomName = false;
		this.m.Variant = 104;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 4000;
		this.m.Condition = 130;
		this.m.ConditionMax = 130;
		this.m.StaminaModifier = -14;
		this.randomizeValues();
	}

});
