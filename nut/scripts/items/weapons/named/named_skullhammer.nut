this.named_skullhammer <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.named_skullhammer";
		this.m.NameList = this.Const.Strings.HammerNames;
		this.m.PrefixList = this.Const.Strings.BarbarianPrefix;
		this.m.SuffixList = this.Const.Strings.BarbarianSuffix;
		this.m.UseRandomName = false;
		this.m.Description = "这把粗糙而沉重的锤子上装饰着额外的动物头骨，仿佛锤子本身还不够令人印象深刻一样。 就如公羊的头一般，它会击碎它的目标。";
		this.m.Categories = "长柄锤，双手持";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 3200;
		this.m.ShieldDamage = 26;
		this.m.Condition = 120.000000;
		this.m.ConditionMax = 120.000000;
		this.m.StaminaModifier = -16;
		this.m.RegularDamage = 45;
		this.m.RegularDamageMax = 65;
		this.m.ArmorDamageMult = 1.800000;
		this.m.DirectDamageMult = 0.500000;
		this.m.DirectDamageAdd = 0.100000;
		this.m.ChanceToHitHead = 0;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/wildmen_07_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/wildmen_07_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_wildmen_07_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		local skill = this.new("scripts/skills/actives/smite_skill");
		skill.m.Icon = "skills/active_180.png";
		skill.m.IconDisabled = "skills/active_180_sw.png";
		skill.m.Overlay = "active_180";
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/shatter_skill");
		skill.m.Icon = "skills/active_181.png";
		skill.m.IconDisabled = "skills/active_181_sw.png";
		skill.m.Overlay = "active_181";
		this.addSkill(skill);
		local skill = this.new("scripts/skills/actives/split_shield");
		skill.setFatigueCost(skill.getFatigueCostRaw() + 5);
		this.addSkill(skill);
	}

});
