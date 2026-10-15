this.rf_grave_chill_bomb_item <- ::inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.rf_grave_chill_bomb";
		this.m.Name = "尸尘罐";
		this.m.Description = "一个易碎的罐子，装满了梦魇生物残骸研磨成的细粉。这种粉末有强烈的精神毒性，哪怕只是闻上一下，也会感到强烈的压抑和绝望。可以短距离投掷。";
		this.m.IconLarge = "tools/rf_grave_chill_bomb_01.png";
		this.m.Icon = "tools/rf_grave_chill_bomb_01_70x70.png";
		this.m.SlotType = ::Const.ItemSlot.Offhand;
		this.m.ItemType = ::Const.Items.ItemType.Tool;
		this.m.AddGenericSkill = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_rf_grave_chill_bomb_01";
		this.m.Value = 400;
		this.m.RangeMax = 3;
		this.m.StaminaModifier = 0;
		this.m.IsDroppedAsLoot = true;
		this.m.ArmorDamageMult = 0.0;
	}

	function getTooltip()
	{
		local rangeMax = this.m.RangeMax;
		this.m.RangeMax = 0;
		local ret = this.weapon.getTooltip();
		this.m.RangeMax = rangeMax;
		ret.push({
			id = 64,
			type = "text",
			text = "副手持用"
		});
		local throwSkill = ::new("scripts/skills/actives/rf_throw_grave_chill_bomb_skill");
		throwSkill.m.Container = ::MSU.getDummyPlayer().getSkills();
		ret.extend(throwSkill.getTooltip().slice(3));
		throwSkill.m.Container = null;
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "使用即摧毁"
		});
		return ret;
	}

	function playInventorySound( _eventType )
	{
		::Sound.play("sounds/bottle_01.wav", ::Const.Sound.Volume.Inventory);
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(::new("scripts/skills/actives/rf_throw_grave_chill_bomb_skill"));
	}

});
