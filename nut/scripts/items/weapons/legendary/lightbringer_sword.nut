this.lightbringer_sword <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.lightbringer_sword";
		this.m.Name = "旧神之叱";
		this.m.Description = "每当黄昏时分，这把剑都会吸引来黄紫色的光芒，直到它将来自黄昏的精华凝聚，自身的光芒到达巅峰为止。当你把它握在手中时，那种冰冷与灼热交织的触感让人难以分辨。且不管它是魔法淬炼的天地精华还是匠心独运的惊世巨作，这把武器总是在嗡鸣振动，抗拒着封印在其中的无穷能量，只消稍稍一挥，便能激发出剑身上的真正力量，释放出强大而纯粹的电流。";
		this.m.Categories = "剑，单手持";
		this.m.IconLarge = "weapons/melee/sword_legendary_01.png";
		this.m.Icon = "weapons/melee/sword_legendary_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded | this.Const.Items.ItemType.Legendary;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_sword_legendary_01";
		this.m.Condition = 90.0;
		this.m.ConditionMax = 90.0;
		this.m.StaminaModifier = -8;
		this.m.Value = 20000;
		this.m.RegularDamage = 50;
		this.m.RegularDamageMax = 55;
		this.m.ArmorDamageMult = 0.9;
		this.m.DirectDamageMult = 0.2;
	}

	function getTooltip()
	{
		local result = this.weapon.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "额外对最多三个目标造成 [color=" + this.Const.UI.Color.DamageValue + "]10[/color] - [color=" + this.Const.UI.Color.DamageValue + "]20[/color] 点无视护甲的伤害"
		});
		return result;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/slash_lightning"));
		this.addSkill(this.new("scripts/skills/actives/riposte"));
	}

	function onAddedToStash( _stashID )
	{
		if (_stashID == "player")
		{
			this.updateAchievement("ReproachOfTheOldGods", 1, 1);
		}
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});
