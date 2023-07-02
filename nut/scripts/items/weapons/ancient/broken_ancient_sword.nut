this.broken_ancient_sword <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.broken_ancient_sword";
		this.m.Name = "破损的古代刃剑";
		this.m.Description = "一把断刃的古剑，严重限制了它的使用。";
		this.m.Categories = "短剑，单手持";
		this.m.IconLarge = "weapons/melee/ancient_broken_sword_01.png";
		this.m.Icon = "weapons/melee/ancient_broken_sword_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_ancient_sword_02";
		this.m.Value = 200;
		this.m.Condition = 24.000000;
		this.m.ConditionMax = 24.000000;
		this.m.StaminaModifier = -3;
		this.m.RegularDamage = 30;
		this.m.RegularDamageMax = 35;
		this.m.ArmorDamageMult = 0.750000;
		this.m.DirectDamageMult = 0.200000;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/slash"));
		this.addSkill(this.new("scripts/skills/actives/riposte"));
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});
