this.claw_club <- this.inherit("scripts/items/weapons/weapon", {
	m = {
		StunChance = 30
	},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.claw_club";
		this.m.Name = "爪棒";
		this.m.Description = "某种野生动物的巨大爪子固定在这根大棒上";
		this.m.Categories = "骨朵, 单手持";
		this.m.IconLarge = "weapons/melee/wildmen_02.png";
		this.m.Icon = "weapons/melee/wildmen_02_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_wildmen_02";
		this.m.Value = 100;
		this.m.Condition = 76.000000;
		this.m.ConditionMax = 76.000000;
		this.m.StaminaModifier = -10;
		this.m.RegularDamage = 20;
		this.m.RegularDamageMax = 30;
		this.m.ArmorDamageMult = 0.750000;
		this.m.DirectDamageMult = 0.400000;
		this.m.DirectDamageAdd = 0.100000;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill = this.new("scripts/skills/actives/bash");
		skill.m.Icon = "skills/active_183.png";
		skill.m.IconDisabled = "skills/active_183_sw.png";
		skill.m.Overlay = "active_183";
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/knock_out");
		skill.m.Icon = "skills/active_186.png";
		skill.m.IconDisabled = "skills/active_186_sw.png";
		skill.m.Overlay = "active_186";
		this.addSkill(skill);
	}

});
