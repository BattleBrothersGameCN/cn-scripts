this.orc_javelin <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function isAmountShown()
	{
		return true;
	}

	function getAmountString()
	{
		return this.m.Ammo + "/" + this.m.AmmoMax;
	}

	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.orc_javelin";
		this.m.Name = "一捆粗糙的标枪";
		this.m.Description = "一堆粗制滥造用来投向目标的标枪。射程有限，且十分消耗体力，但能造成毁灭性的伤害。如果被盾牌格挡，也会对盾牌造成轻微伤害。";
		this.m.Categories = "投掷武器，单手持";
		this.m.IconLarge = "weapons/ranged/orc_javelins.png";
		this.m.Icon = "weapons/ranged/orc_javelins_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.Ammo | this.Const.Items.ItemType.Defensive;
		this.m.EquipSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.AddGenericSkill = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_javelin_01";
		this.m.Value = 150;
		this.m.Ammo = 5;
		this.m.AmmoMax = 5;
		this.m.RangeMin = 1;
		this.m.RangeMax = 4;
		this.m.RangeIdeal = 4;
		this.m.StaminaModifier = -8;
		this.m.RegularDamage = 30;
		this.m.RegularDamageMax = 40;
		this.m.ArmorDamageMult = 0.7;
		this.m.DirectDamageMult = 0.45;
		this.m.ShieldDamage = 0;
		this.m.IsDroppedAsLoot = true;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/throw_javelin"));
	}

	function setAmmo( _a )
	{
		this.weapon.setAmmo(_a);

		if (this.m.Ammo > 0)
		{
			this.m.Name = "一捆粗糙的标枪";
			this.m.IconLarge = "weapons/ranged/orc_javelins.png";
			this.m.Icon = "weapons/ranged/orc_javelins_70x70.png";
			this.m.ShowArmamentIcon = true;
		}
		else
		{
			this.m.Name = "一捆粗糙的标枪（空）";
			this.m.IconLarge = "weapons/ranged/orc_javelins_bag_140x70.png";
			this.m.Icon = "weapons/ranged/orc_javelins_bag_70x70.png";
			this.m.ShowArmamentIcon = false;
		}

		this.updateAppearance();
	}

});
