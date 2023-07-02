this.dagger <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.dagger";
		this.m.Name = "匕首";
		this.m.Description = "一把为近身格斗而制造的尖匕首。";
		this.m.Categories = "匕首，单手持";
		this.m.IconLarge = "weapons/melee/dagger_01.png";
		this.m.Icon = "weapons/melee/dagger_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_dagger_01";
		this.m.Condition = 40.000000;
		this.m.ConditionMax = 40.000000;
		this.m.Value = 180;
		this.m.RegularDamage = 15;
		this.m.RegularDamageMax = 35;
		this.m.ArmorDamageMult = 0.600000;
		this.m.DirectDamageMult = 0.200000;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/stab"));
		this.addSkill(this.new("scripts/skills/actives/puncture"));
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});
