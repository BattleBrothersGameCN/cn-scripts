this.butchers_cleaver <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.butchers_cleaver";
		this.m.Name = "屠夫切肉刀";
		this.m.Description = "一种有厚的矩形刀片的刀具，用来劈砍肉和骨头。";
		this.m.Categories = "砍刀，单手持";
		this.m.IconLarge = "weapons/melee/cleaver_02.png";
		this.m.Icon = "weapons/melee/cleaver_02_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_cleaver_02";
		this.m.ShieldDamage = 0;
		this.m.Condition = 40.000000;
		this.m.ConditionMax = 40.000000;
		this.m.StaminaModifier = -6;
		this.m.Value = 110;
		this.m.RegularDamage = 20;
		this.m.RegularDamageMax = 35;
		this.m.ArmorDamageMult = 0.750000;
		this.m.DirectDamageMult = 0.250000;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local cleave = this.new("scripts/skills/actives/cleave");
		cleave.m.Icon = "skills/active_68.png";
		cleave.m.IconDisabled = "skills/active_68_sw.png";
		cleave.m.Overlay = "active_68";
		this.addSkill(cleave);
		local decapitate = this.new("scripts/skills/actives/decapitate");
		this.addSkill(decapitate);
	}

});
