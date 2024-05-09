this.reinforced_wooden_flail <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.reinforced_wooden_flail";
		this.m.Name = "强化木链枷";
		this.m.Description = "两根用短链连接的用金属加固的大木棍，强化木连枷是一种农具衍生出的武器。它的攻击有些难以预测，但如果结实的命中头部一下就能击倒大部分人，同时它还很适合攻击在盾牌掩护下的敌人。";
		this.m.Categories = "链枷, 单手持";
		this.m.IconLarge = "weapons/melee/flail_03.png";
		this.m.Icon = "weapons/melee/flail_03_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.ItemProperty = this.Const.Items.Property.IgnoresShieldwall;
		this.m.IsDoubleGrippable = true;
		this.m.IsAgainstShields = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_flail_03";
		this.m.Value = 300;
		this.m.ShieldDamage = 0;
		this.m.Condition = 40.0;
		this.m.ConditionMax = 40.0;
		this.m.StaminaModifier = -7;
		this.m.RegularDamage = 20;
		this.m.RegularDamageMax = 45;
		this.m.ArmorDamageMult = 0.8;
		this.m.ChanceToHitHead = 10;
		this.m.DirectDamageMult = 0.3;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local flail = this.new("scripts/skills/actives/flail_skill");
		flail.m.Icon = "skills/active_65.png";
		flail.m.IconDisabled = "skills/active_65_sw.png";
		flail.m.Overlay = "active_65";
		this.addSkill(flail);
		local lash = this.new("scripts/skills/actives/lash_skill");
		lash.m.Icon = "skills/active_92.png";
		lash.m.IconDisabled = "skills/active_92_sw.png";
		lash.m.Overlay = "active_92";
		this.addSkill(lash);
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});
