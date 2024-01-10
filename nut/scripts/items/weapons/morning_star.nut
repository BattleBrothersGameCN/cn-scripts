this.morning_star <- this.inherit("scripts/items/weapons/weapon", {
	m = {
		StunChance = 30
	},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.morning_star";
		this.m.Name = "晨星棒";
		this.m.Description = "一柄带有尖钉金属头的木杆，可以用来造成蛮力与穿刺结合的打击。";
		this.m.Categories = "骨朵, 单手持";
		this.m.IconLarge = "weapons/melee/morning_star_01.png";
		this.m.Icon = "weapons/melee/morning_star_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_morning_star_01";
		this.m.Value = 650;
		this.m.ShieldDamage = 0;
		this.m.Condition = 72.000000;
		this.m.ConditionMax = 72.000000;
		this.m.StaminaModifier = -10;
		this.m.RegularDamage = 30;
		this.m.RegularDamageMax = 45;
		this.m.ArmorDamageMult = 1.000000;
		this.m.DirectDamageMult = 0.400000;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local bash = this.new("scripts/skills/actives/bash");
		bash.m.Icon = "skills/active_76.png";
		bash.m.IconDisabled = "skills/active_76_sw.png";
		bash.m.Overlay = "active_76";
		this.addSkill(bash);
		this.addSkill(this.new("scripts/skills/actives/knock_out"));
	}

});
