this.rf_warmth_potion_item <- ::inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "accessory.rf_warmth_potion";
		this.m.Name = "沸血补剂";
		this.m.Description = "一种辛辣的合剂，喝下比刀刮嗓子还难受，却能带给你前所未有的活力。效果持续到下一场战斗。";
		this.m.SlotType = ::Const.ItemSlot.None;
		this.m.ItemType = ::Const.Items.ItemType.Usable;
		this.m.IsDroppedAsLoot = true;
		this.m.IsAllowedInBag = false;
		this.m.IsUsable = true;
		this.m.IconLarge = "";
		this.m.Icon = "consumables/rf_warmth_potion_item.png";
		this.m.Value = 550;
	}

	function getTooltip()
	{
		local ret = this.item.getTooltip();
		local effect = ::new("scripts/skills/effects/rf_warmth_potion_effect");
		ret.extend(effect.getTooltip().slice(2));
		ret.push({
			id = 65,
			type = "text",
			text = "右键单击或拖动到当前选定的角色上进行饮用。此物品会在使用过程中消耗掉。"
		});
		ret.push({
			id = 65,
			type = "hint",
			icon = "ui/tooltips/warning.png",
			text = "过度使用可能导致疾病"
		});
		return ret;
	}

	function playInventorySound( _eventType )
	{
		::Sound.play("sounds/bottle_01.wav", ::Const.Sound.Volume.Inventory);
	}

	function onUse( _actor, _item = null )
	{
		::Sound.play("sounds/combat/drink_0" + ::Math.rand(1, 3) + ".wav", ::Const.Sound.Volume.Inventory);
		_actor.getSkills().add(::new("scripts/skills/effects/rf_warmth_potion_effect"));
		::Const.Tactical.Common.checkDrugEffect(_actor);
		return true;
	}

});
