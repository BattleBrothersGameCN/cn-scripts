this.named_flail <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = this.Math.rand(1, 3);
		this.updateVariant();
		this.m.ID = "weapon.named_flail";
		this.m.NameList = this.Const.Strings.FlailNames;
		this.m.Description = "一个单独的锤头被锁链连接在握把上。它的攻击有些难以预测，但很适合绕过盾牌的掩护。由于其独特的构造，这件特别的链枷显得尤其可怕。";
		this.m.Categories = "链枷, 单手持";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.ItemProperty = this.Const.Items.Property.IgnoresShieldwall;
		this.m.IsDoubleGrippable = true;
		this.m.IsAgainstShields = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 3400;
		this.m.ShieldDamage = 0;
		this.m.Condition = 72.0;
		this.m.ConditionMax = 72.0;
		this.m.StaminaModifier = -8;
		this.m.RegularDamage = 25;
		this.m.RegularDamageMax = 55;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 10;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/flail_01_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/flail_01_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_named_flail_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/flail_skill"));
		this.addSkill(this.new("scripts/skills/actives/lash_skill"));
	}

});
