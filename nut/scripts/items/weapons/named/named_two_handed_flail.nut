this.named_two_handed_flail <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = this.Math.rand(1, 2);
		this.updateVariant();
		this.m.ID = "weapon.named_two_handed_flail";
		this.m.NameList = this.Const.Strings.TwoHandedFlailNames;
		this.m.Description = "这件令人印象深刻的双手链枷与它所起源的农具几乎没有什么共同之处。它看上去由一位经验丰富的战士设计，并由一位技艺高超的工匠所打造。";
		this.m.Categories = "链枷, 双手持";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAoE = true;
		this.m.EquipSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 2800;
		this.m.ShieldDamage = 0;
		this.m.Condition = 80.0;
		this.m.ConditionMax = 80.0;
		this.m.StaminaModifier = -16;
		this.m.RegularDamage = 45;
		this.m.RegularDamageMax = 90;
		this.m.ArmorDamageMult = 1.15;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 15;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/flail_two_handed_02_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/flail_two_handed_02_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_flail_two_handed_02_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		local skill;
		skill = this.new("scripts/skills/actives/pound");
		skill.m.Icon = "skills/active_129.png";
		skill.m.IconDisabled = "skills/active_129_sw.png";
		skill.m.Overlay = "active_129";
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/thresh");
		skill.m.Icon = "skills/active_130.png";
		skill.m.IconDisabled = "skills/active_130_sw.png";
		skill.m.Overlay = "active_130";
		this.addSkill(skill);
	}

});
