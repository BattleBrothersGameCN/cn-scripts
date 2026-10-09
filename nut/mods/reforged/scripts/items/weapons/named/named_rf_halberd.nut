this.named_rf_halberd <- ::inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = ::Math.rand(1, 3);
		this.updateVariant();
		this.m.ID = "weapon.named_rf_halberd";
		this.m.NameList = ::Const.Strings.AxeNames;
		this.m.Description = "这把精工打造的长戟专为作战设计，挥舞起来势大力沉，能够快速结束战斗。";
		this.m.Value = 4600;
		this.m.BaseItemScript = "scripts/items/weapons/rf_halberd";
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/rf_halberd_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/rf_halberd_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_rf_halberd_named_0" + this.m.Variant;
	}

});
