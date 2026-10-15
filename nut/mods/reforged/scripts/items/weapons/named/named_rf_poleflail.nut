this.named_rf_poleflail <- ::inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.named_rf_poleflail";
		this.m.NameList = ::Const.Strings.TwoHandedFlailNames;
		this.m.Description = "再也不必担心和原型农具混在一起了，这一看就是哪位铁匠大师的杰作。";
		this.m.Value = 4000;
		this.m.BaseItemScript = "scripts/items/weapons/rf_poleflail";
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/rf_poleflail_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/rf_poleflail_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_rf_poleflail_named_0" + this.m.Variant;
	}

});
