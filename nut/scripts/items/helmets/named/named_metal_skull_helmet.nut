this.named_metal_skull_helmet <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.named_metal_skull_helmet";
		this.m.Description = "一顶安装了颅状面具的典型北方野蛮人重头盔。它带给人的震撼足以和其重量相称。";
		this.m.NameList = [
			"北地之貌",
			"铁颅",
			"面罩",
			"氏族之面",
			"面具",
			"铁面",
			"部落之容",
			"劫掠之凝"
		];
		this.m.PrefixList = this.Const.Strings.BarbarianPrefix;
		this.m.UseRandomName = false;
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.HideCharacterHead = true;
		this.m.Variant = 232;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 5000;
		this.m.Condition = 210;
		this.m.ConditionMax = 210;
		this.m.StaminaModifier = -13;
		this.m.Vision = -2;
		this.randomizeValues();
	}

});
