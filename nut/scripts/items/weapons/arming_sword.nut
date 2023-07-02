this.arming_sword <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.arming_sword";
		this.m.Name = "武装剑";
		this.m.Description = "一种易于挥砍和戳刺的轻质直剑。";
		this.m.Categories = "短剑，单手持";
		this.m.IconLarge = "weapons/melee/sword_02.png";
		this.m.Icon = "weapons/melee/sword_02_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_sword_02";
		this.m.Condition = 56.000000;
		this.m.ConditionMax = 56.000000;
		this.m.StaminaModifier = -6;
		this.m.Value = 1250;
		this.m.RegularDamage = 40;
		this.m.RegularDamageMax = 45;
		this.m.ArmorDamageMult = 0.800000;
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
