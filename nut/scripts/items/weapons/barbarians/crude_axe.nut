this.crude_axe <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.crude_axe";
		this.m.Name = "粗制斧";
		this.m.Description = "一把制作粗糙的斧头，沉重且带有锯齿。";
		this.m.Categories = "斧，单手持";
		this.m.IconLarge = "weapons/melee/wildmen_05.png";
		this.m.Icon = "weapons/melee/wildmen_05_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.IsAgainstShields = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_wildmen_05";
		this.m.Value = 800;
		this.m.ShieldDamage = 12;
		this.m.Condition = 82.000000;
		this.m.ConditionMax = 82.000000;
		this.m.StaminaModifier = -12;
		this.m.RegularDamage = 30;
		this.m.RegularDamageMax = 40;
		this.m.ArmorDamageMult = 1.200000;
		this.m.DirectDamageMult = 0.300000;
		this.m.DirectDamageAdd = 0.100000;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill = this.new("scripts/skills/actives/chop");
		skill.m.Icon = "skills/active_185.png";
		skill.m.IconDisabled = "skills/active_185_sw.png";
		skill.m.Overlay = "active_185";
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/split_shield");
		skill.setApplyAxeMastery(true);
		this.addSkill(skill);
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});
