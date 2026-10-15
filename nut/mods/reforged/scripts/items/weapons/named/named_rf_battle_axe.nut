this.named_rf_battle_axe <- ::inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.named_rf_battle_axe";
		this.m.NameList = ::Const.Strings.AxeNames;
		this.m.Description = "一位经过铁匠大师手艺担保，配以利落的表面处理，会在挥动时发出悦耳声音的战斗斧。";
		this.m.Value = 4000;
		this.m.BaseItemScript = "scripts/items/weapons/rf_battle_axe";
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/rf_battle_axe_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/rf_battle_axe_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_rf_battle_axe_named_0" + this.m.Variant;
	}

});
