this.heavy_crossbow <- this.inherit("scripts/items/weapons/weapon", {
	m = {
		IsLoaded = true
	},
	function isLoaded()
	{
		return this.m.IsLoaded;
	}

	function setLoaded( _l )
	{
		this.m.IsLoaded = _l;
	}

	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.heavy_crossbow";
		this.m.Name = "重弩";
		this.m.Description = "一把有曲柄绞盘的重型弩，可以在中等距离射击弩矢，即使对重装甲目标也非常有效。 需要几乎整回合的时间来重新装弹。";
		this.m.Categories = "弩, 双手持";
		this.m.IconLarge = "weapons/ranged/crossbow_03.png";
		this.m.Icon = "weapons/ranged/crossbow_03_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.Defensive;
		this.m.EquipSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_crossbow_03";
		this.m.Value = 3200;
		this.m.RangeMin = 1;
		this.m.RangeMax = 6;
		this.m.RangeIdeal = 6;
		this.m.StaminaModifier = -12;
		this.m.Condition = 64.000000;
		this.m.ConditionMax = 64.000000;
		this.m.RegularDamage = 50;
		this.m.RegularDamageMax = 70;
		this.m.ArmorDamageMult = 0.750000;
		this.m.DirectDamageMult = 0.500000;
	}

	function getAmmoID()
	{
		return "ammo.bolts";
	}

	function getTooltip()
	{
		local result = this.weapon.getTooltip();

		if (!this.m.IsLoaded)
		{
			result.push({
				id = 10,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]必须重新装填才能再次发射[/color]"
			});
		}

		return result;
	}

	function onCombatFinished()
	{
		this.setLoaded(true);
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/shoot_bolt"));

		if (!this.m.IsLoaded)
		{
			this.addSkill(this.new("scripts/skills/actives/reload_bolt"));
		}
	}

	function onCombatFinished()
	{
		this.weapon.onCombatFinished();
		this.m.IsLoaded = true;
	}

});
