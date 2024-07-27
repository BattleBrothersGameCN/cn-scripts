this.named_skull_and_chain_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.named_skull_and_chain_armor";
		this.m.Description = "一件经过调整的粗制蛮人甲，既有保护能力又不太笨重。带有北方野蛮部落的典型标志。";
		this.m.NameList = [
			"部落兽皮甲",
			"蛮族外衣",
			"重铸战甲",
			"蛮族披挂",
			"原始甲胄"
		];
		this.m.PrefixList = this.Const.Strings.BarbarianPrefix;
		this.m.UseRandomName = false;
		this.m.Variant = 102;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 5500;
		this.m.Condition = 190;
		this.m.ConditionMax = 190;
		this.m.StaminaModifier = -24;
		this.randomizeValues();
	}

});
