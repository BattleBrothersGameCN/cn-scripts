this.named_rf_poleaxe <- ::inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.named_rf_poleaxe";
		this.m.NameList = ::Const.Strings.SpetumNames;
		this.m.Description = "这杆长柄斧制作精良，能够刺穿锁子，砸凹铁盔。打造它的铁匠不愧是大师，很懂战场上需要什么。";
		this.m.Value = 4200;
		this.m.BaseItemScript = "scripts/items/weapons/rf_poleaxe";
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/rf_poleaxe_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/rf_poleaxe_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_rf_poleaxe_named_0" + this.m.Variant;
	}

});
