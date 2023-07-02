this.named_khopesh <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.named_khopesh";
		this.m.NameList = this.Const.Strings.CleaverNames;
		this.m.PrefixList = this.Const.Strings.OldWeaponPrefix;
		this.m.UseRandomName = false;
		this.m.Description = "一把优雅的弧形弯刀，配着华丽的手柄。像这样的武器已经遗失了几个世纪，据说可以追溯到帝国的鼎盛时期。";
		this.m.Categories = "刀，单手持";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 3200;
		this.m.ShieldDamage = 0;
		this.m.Condition = 42.000000;
		this.m.ConditionMax = 42.000000;
		this.m.StaminaModifier = -10;
		this.m.RegularDamage = 35;
		this.m.RegularDamageMax = 55;
		this.m.ArmorDamageMult = 1.200000;
		this.m.DirectDamageMult = 0.250000;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/kopesh_01_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/kopesh_01_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_khopesh_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/cleave"));
		this.addSkill(this.new("scripts/skills/actives/decapitate"));
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});
