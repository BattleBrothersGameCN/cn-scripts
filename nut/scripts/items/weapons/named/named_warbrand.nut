this.named_warbrand <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = this.Math.rand(1, 3);
		this.updateVariant();
		this.m.ID = "weapon.named_warbrand";
		this.m.NameList = this.Const.Strings.WarbrandNames;
		this.m.Description = "一把精心制作的双手剑的变体型号，有着长而薄的锋刃，单侧开锋且没有护手。既可用于快速挥砍，也可用于横扫打击。";
		this.m.Categories = "长剑，双手持";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = false;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 4000;
		this.m.ShieldDamage = 0;
		this.m.Condition = 64.000000;
		this.m.ConditionMax = 64.000000;
		this.m.StaminaModifier = -10;
		this.m.RegularDamage = 50;
		this.m.RegularDamageMax = 75;
		this.m.ArmorDamageMult = 0.750000;
		this.m.DirectDamageMult = 0.200000;
		this.m.ChanceToHitHead = 5;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/military_scythe_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/military_scythe_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_named_warbrand_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		local slash = this.new("scripts/skills/actives/slash");
		slash.m.FatigueCost = 13;
		this.addSkill(slash);
		this.addSkill(this.new("scripts/skills/actives/split"));
		this.addSkill(this.new("scripts/skills/actives/swing"));
	}

});
