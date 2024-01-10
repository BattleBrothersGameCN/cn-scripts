this.wooden_stick <- this.inherit("scripts/items/weapons/weapon", {
	m = {
		StunChance = 10
	},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.wooden_stick";
		this.m.Name = "木棍";
		this.m.Description = "一根简单的木棍，通常充当临时武器。";
		this.m.Categories = "骨朵, 单手持";
		this.m.IconLarge = "weapons/melee/club_01.png";
		this.m.Icon = "weapons/melee/club_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.EquipSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_club_01";
		this.m.Value = 35;
		this.m.Condition = 32.000000;
		this.m.ConditionMax = 32.000000;
		this.m.StaminaModifier = -6;
		this.m.RegularDamage = 15;
		this.m.RegularDamageMax = 25;
		this.m.ArmorDamageMult = 0.500000;
		this.m.DirectDamageMult = 0.400000;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/bash"));
		this.addSkill(this.new("scripts/skills/actives/knock_out"));
	}

});
