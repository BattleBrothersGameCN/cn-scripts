this.nomad_mace <- this.inherit("scripts/items/weapons/weapon", {
	m = {
		StunChance = 30
	},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.nomad_mace";
		this.m.Name = "游牧骨朵";
		this.m.Description = "一把金属头的简易木柄骨朵。这种武器在南方的游牧民间十分流行。";
		this.m.Categories = "骨朵, 单手持";
		this.m.IconLarge = "weapons/melee/wooden_nomad_mace_01.png";
		this.m.Icon = "weapons/melee/wooden_nomad_mace_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_nomad_mace_01";
		this.m.Value = 100;
		this.m.ShieldDamage = 0;
		this.m.Condition = 64.0;
		this.m.ConditionMax = 64.0;
		this.m.StaminaModifier = -8;
		this.m.RegularDamage = 25;
		this.m.RegularDamageMax = 35;
		this.m.ArmorDamageMult = 0.9;
		this.m.DirectDamageMult = 0.4;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local bash = this.new("scripts/skills/actives/bash");
		this.addSkill(bash);
		local knockout = this.new("scripts/skills/actives/knock_out");
		this.addSkill(knockout);
	}

});
