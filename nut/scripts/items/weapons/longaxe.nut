this.longaxe <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.longaxe";
		this.m.Name = "长斧";
		this.m.Description = "在一个很长的木柄上有一个相对较薄而锋利的刀片，能在一定距离内进行毁灭性的劈砍，或者在前排后方让对手的盾牌无法使用。";
		this.m.Categories = "斧，双手持";
		this.m.IconLarge = "weapons/melee/longaxe_01.png";
		this.m.Icon = "weapons/melee/longaxe_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_longaxe_01";
		this.m.Value = 1200;
		this.m.ShieldDamage = 24;
		this.m.Condition = 72.0;
		this.m.ConditionMax = 72.0;
		this.m.StaminaModifier = -14;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 70;
		this.m.RegularDamageMax = 95;
		this.m.ArmorDamageMult = 1.1;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 5;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local strike_skill = this.new("scripts/skills/actives/strike_skill");
		strike_skill.setApplyAxeMastery(true);
		this.addSkill(strike_skill);
		local split_shield = this.new("scripts/skills/actives/split_shield");
		split_shield.setApplyAxeMastery(true);
		split_shield.m.MaxRange = 2;
		split_shield.m.FatigueCost += 10;
		split_shield.m.Icon = "skills/active_67.png";
		split_shield.m.IconDisabled = "skills/active_67_sw.png";
		split_shield.m.Overlay = "active_67";
		this.addSkill(split_shield);
	}

});
