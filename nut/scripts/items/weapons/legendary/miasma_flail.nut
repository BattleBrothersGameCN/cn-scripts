this.miasma_flail <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.miasma_flail";
		this.m.Name = "占卜师的香炉";
		this.m.Description = "一只沉重的香炉，被改造成了凶恶的链枷头，安在一根长柄上。你无从知晓那位大占卜师曾用何种香料来激发他疯狂的幻象，但那些香料燃烧时如同毒药，而这武器正从某个未知且不可阻挡的源头源源不断地释放着它们。";
		this.m.Categories = "链枷, 双手持";
		this.m.IconLarge = "weapons/melee/miasma_flail_01.png";
		this.m.Icon = "weapons/melee/miasma_flail_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded | this.Const.Items.ItemType.Legendary;
		this.m.IsAoE = true;
		this.m.EquipSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_miasma_flail_01";
		this.m.Value = 14000;
		this.m.ShieldDamage = 0;
		this.m.Condition = 120.0;
		this.m.ConditionMax = 120.0;
		this.m.StaminaModifier = -16;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 60;
		this.m.RegularDamageMax = 110;
		this.m.ArmorDamageMult = 1.1;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 15;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/censer_strike"));
		this.addSkill(this.new("scripts/skills/actives/censer_castigate_skill"));
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});
