this.warbrand <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.warbrand";
		this.m.Name = "布兰德战刃";
		this.m.Description = "一把双手剑的变体型号，有着长而薄的锋刃，单侧开锋且没有护手。既可用于快速挥砍，也可用于横扫打击。";
		this.m.Categories = "长剑，双手持";
		this.m.IconLarge = "weapons/melee/warbrand_01.png";
		this.m.Icon = "weapons/melee/warbrand_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = false;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_scythe_01";
		this.m.Value = 1600;
		this.m.ShieldDamage = 0;
		this.m.Condition = 64.000000;
		this.m.ConditionMax = 64.000000;
		this.m.StaminaModifier = -10;
		this.m.RegularDamage = 50;
		this.m.RegularDamageMax = 75;
		this.m.ArmorDamageMult = 0.750000;
		this.m.DirectDamageMult = 0.200000;
		this.m.ChanceToHitHead = 5;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local slash = this.new("scripts/skills/actives/slash");
		slash.m.FatigueCost = 13;
		this.addSkill(slash);
		this.addSkill(this.new("scripts/skills/actives/split"));
		this.addSkill(this.new("scripts/skills/actives/swing"));
	}

});
