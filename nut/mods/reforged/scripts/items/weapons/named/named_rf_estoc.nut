this.named_rf_estoc <- ::inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.named_rf_estoc";
		this.m.NameList = ::Const.Strings.FencingSwordNames;
		this.m.Description = "对于一把精心锻成的穿甲剑来说，在保证重量够轻操纵灵活的同时，长度和强度缺一不可。面前这把正是你所见过最精良的之一。";
		this.m.Value = 4200;
		this.m.BaseItemScript = "scripts/items/weapons/rf_estoc";
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/rf_estoc_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/rf_estoc_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_rf_estoc_named_0" + this.m.Variant;
	}

});
