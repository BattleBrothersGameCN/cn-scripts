this.bodily_reward_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.bodily_reward";
		this.m.Name = "幽绿小瓶";
		this.m.Description = "用他人的生命与女巫交易而来，这瓶神秘合剂许诺能和身体共鸣，立即治愈所有能自愈的创伤。";
		this.m.Icon = "consumables/vial_green_01.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsDroppedAsLoot = true;
		this.m.IsAllowedInBag = false;
		this.m.IsUsable = true;
		this.m.Value = 2500;
	}

	function getTooltip()
	{
		local result = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
		result.push({
			id = 66,
			type = "text",
			text = this.getValueString()
		});

		if (this.getIconLarge() != null)
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIconLarge(),
				isLarge = true
			});
		}
		else
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIcon()
			});
		}

		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "立即治愈所有临时创伤，消除宿醉和精疲力竭状态"
		});
		result.push({
			id = 65,
			type = "text",
			text = "右键单击或拖动到当前选定的角色上进行饮用。此物品会在使用过程中消耗掉。"
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onUse( _actor, _item = null )
	{
		this.Sound.play("sounds/combat/drink_03.wav", this.Const.Sound.Volume.Inventory);
		_actor.getSkills().removeByType(this.Const.SkillType.TemporaryInjury);
		_actor.getSkills().removeByID("effects.hangover");
		_actor.getSkills().removeByID("effects.exhausted");
		_actor.setHitpoints(_actor.getHitpointsMax());
		this.Const.Tactical.Common.checkDrugEffect(_actor);
		return true;
	}

});
