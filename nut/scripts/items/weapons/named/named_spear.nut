this.named_spear <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = this.Math.rand(1, 3);
		this.updateVariant();
		this.m.ID = "weapon.named_spear";
		this.m.NameList = this.Const.Strings.SpearNames;
		this.m.Description = "这是一支制作精良的矛，重量很轻，但很结实。";
		this.m.Categories = "矛，单手持";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded | this.Const.Items.ItemType.Defensive;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 3200;
		this.m.Condition = 72.000000;
		this.m.ConditionMax = 72.000000;
		this.m.StaminaModifier = -10;
		this.m.RegularDamage = 35;
		this.m.RegularDamageMax = 40;
		this.m.ArmorDamageMult = 1.000000;
		this.m.DirectDamageMult = 0.250000;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/spear_03_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/spear_03_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_named_spear_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/thrust"));
		this.addSkill(this.new("scripts/skills/actives/spearwall"));
	}

});
