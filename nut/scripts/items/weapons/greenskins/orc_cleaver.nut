this.orc_cleaver <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.orc_cleaver";
		this.m.Name = "斩首刀";
		this.m.Description = "一片锋利而粗糙的金属碎片，握柄被包裹，类似于剑，但重了很多。不适合人类手持。";
		this.m.Categories = "砍刀，单手持";
		this.m.IconLarge = "weapons/melee/orc_cleaver.png";
		this.m.Icon = "weapons/melee/orc_cleaver_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_orc_weapon_04";
		this.m.Value = 1100;
		this.m.ShieldDamage = 0;
		this.m.Condition = 52.000000;
		this.m.ConditionMax = 52.000000;
		this.m.StaminaModifier = -18;
		this.m.RegularDamage = 40;
		this.m.RegularDamageMax = 70;
		this.m.ArmorDamageMult = 1.100000;
		this.m.DirectDamageMult = 0.250000;
		this.m.FatigueOnSkillUse = 5;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill;
		skill = this.new("scripts/skills/actives/cleave");
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/decapitate");
		this.addSkill(skill);
	}

});
