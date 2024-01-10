this.ancient_sword <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.ancient_sword";
		this.m.Name = "古代刃剑";
		this.m.Description = "一把起源于古代的直刃。握把上覆盖着奇怪的装饰物，这可能使它对历史学家和其他有学术头脑的人有价值。";
		this.m.Categories = "剑，单手持";
		this.m.IconLarge = "weapons/melee/ancient_sword_01.png";
		this.m.Icon = "weapons/melee/ancient_sword_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_ancient_sword_01";
		this.m.Value = 850;
		this.m.Condition = 42.000000;
		this.m.ConditionMax = 42.000000;
		this.m.StaminaModifier = -6;
		this.m.RegularDamage = 38;
		this.m.RegularDamageMax = 43;
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
