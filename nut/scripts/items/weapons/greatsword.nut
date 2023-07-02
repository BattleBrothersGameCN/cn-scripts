this.greatsword <- this.inherit("scripts/items/weapons/weapon", {
	m = {
		StunChance = 0
	},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.greatsword";
		this.m.Name = "大剑";
		this.m.Description = "一种很长的双手利刃，既能切割又能斩破敌人。";
		this.m.Categories = "长剑，双手持";
		this.m.IconLarge = "weapons/melee/sword_two_hand_02.png";
		this.m.Icon = "weapons/melee/sword_two_hand_02_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_sword_two_handed_02";
		this.m.Value = 3200;
		this.m.ShieldDamage = 16;
		this.m.Condition = 72.000000;
		this.m.ConditionMax = 72.000000;
		this.m.StaminaModifier = -12;
		this.m.RegularDamage = 85;
		this.m.RegularDamageMax = 100;
		this.m.ArmorDamageMult = 1.000000;
		this.m.DirectDamageMult = 0.250000;
		this.m.ChanceToHitHead = 5;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skillToAdd = this.new("scripts/skills/actives/overhead_strike");
		skillToAdd.setStunChance(this.m.StunChance);
		this.addSkill(skillToAdd);
		this.addSkill(this.new("scripts/skills/actives/split"));
		this.addSkill(this.new("scripts/skills/actives/swing"));
		local skillToAdd = this.new("scripts/skills/actives/split_shield");
		skillToAdd.setFatigueCost(skillToAdd.getFatigueCostRaw() + 5);
		this.addSkill(skillToAdd);
	}

});
