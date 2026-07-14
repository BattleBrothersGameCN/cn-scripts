this.named_rf_swordstaff <- ::inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = ::Math.rand(1, 2);
		this.updateVariant();
		this.m.ID = "weapon.named_rf_swordstaff";
		this.m.NameList = ::Const.Strings.SpetumNames;
		this.m.Description = "一把美丽而致命的精制剑杖。但凡是个佣兵团都会乐意得到这么一件杰作。";
		this.m.Value = 4200;
		this.m.BaseItemScript = "scripts/items/weapons/rf_swordstaff";
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/rf_swordstaff_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/rf_swordstaff_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_rf_swordstaff_named_0" + this.m.Variant;
	}

});
