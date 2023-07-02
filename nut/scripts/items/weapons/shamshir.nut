this.shamshir <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.shamshir";
		this.m.Name = "狮尾弯刀";
		this.m.Description = "这把来自南方异域的精制的弯刀，它有一个弯曲的刀刃可以轻松地切出深深的伤口，但不适合插入和穿透盔甲。 在这片陆地上很稀有。";
		this.m.Categories = "短剑，单手持";
		this.m.IconLarge = "weapons/melee/scimitar_01.png";
		this.m.Icon = "weapons/melee/scimitar_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_scimitar_01";
		this.m.Value = 2900;
		this.m.Condition = 72.000000;
		this.m.ConditionMax = 72.000000;
		this.m.StaminaModifier = -8;
		this.m.RegularDamage = 45;
		this.m.RegularDamageMax = 50;
		this.m.ArmorDamageMult = 0.750000;
		this.m.DirectDamageMult = 0.200000;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill = this.new("scripts/skills/actives/slash");
		skill.m.Icon = "skills/active_172.png";
		skill.m.IconDisabled = "skills/active_172_sw.png";
		skill.m.Overlay = "active_172";
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/gash_skill");
		this.addSkill(skill);
	}

});
