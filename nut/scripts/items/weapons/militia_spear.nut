this.militia_spear <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.militia_spear";
		this.m.Name = "民兵矛";
		this.m.Description = "一条装有金属矛尖的简易木矛。";
		this.m.Categories = "矛，单手持";
		this.m.IconLarge = "weapons/melee/spear_02.png";
		this.m.Icon = "weapons/melee/spear_02_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded | this.Const.Items.ItemType.Defensive;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_spear_02";
		this.m.Value = 180;
		this.m.Condition = 48.0;
		this.m.ConditionMax = 48.0;
		this.m.StaminaModifier = -6;
		this.m.RegularDamage = 25;
		this.m.RegularDamageMax = 30;
		this.m.ArmorDamageMult = 0.9;
		this.m.DirectDamageMult = 0.25;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/thrust"));
		this.addSkill(this.new("scripts/skills/actives/spearwall"));
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});
