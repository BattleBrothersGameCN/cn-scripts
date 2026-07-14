this.named_rf_longsword <- ::inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.named_rf_longsword";
		this.m.NameList = ::Const.Strings.RF_LongswordNames;
		this.m.Description = "这件精美的工艺品展现了出的品质无与伦比。轻轻一挥，剑刃也随之轻声歌唱。";
		this.m.Value = 4000;
		this.m.BaseItemScript = "scripts/items/weapons/longsword";
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/rf_longsword_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/rf_longsword_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_rf_longsword_named_0" + this.m.Variant;
	}

});
