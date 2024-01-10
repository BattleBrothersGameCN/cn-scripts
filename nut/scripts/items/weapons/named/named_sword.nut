this.named_sword <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = this.Math.rand(1, 5);
		this.updateVariant();
		this.m.ID = "weapon.named_sword";
		this.m.NameList = this.Const.Strings.SwordNames;
		this.m.Description = "一把平衡性良好的双锋利刃。像这样精心制作的武器很难找到。";
		this.m.Categories = "剑，单手持";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Condition = 72.000000;
		this.m.ConditionMax = 72.000000;
		this.m.StaminaModifier = -8;
		this.m.Value = 4200;
		this.m.RegularDamage = 45;
		this.m.RegularDamageMax = 50;
		this.m.ArmorDamageMult = 0.850000;
		this.m.DirectDamageMult = 0.200000;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/sword_03_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/sword_03_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_named_sword_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/slash"));
		this.addSkill(this.new("scripts/skills/actives/riposte"));
	}

});
