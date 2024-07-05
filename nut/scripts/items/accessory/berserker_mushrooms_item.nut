this.berserker_mushrooms_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "accessory.berserker_mushrooms";
		this.m.Name = "怪异蘑菇";
		this.m.Description = "奇怪的蘑菇，曾经有人咀嚼它们进入一个恍惚的愤怒状态，他们不感到任何痛苦，并表现出显着增加的侵略性。谨慎食用，效果持续到下一场战斗。";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsDroppedAsLoot = true;
		this.m.IsAllowedInBag = false;
		this.m.IsUsable = true;
		this.m.IconLarge = "";
		this.m.Icon = "consumables/mushrooms_01.png";
		this.m.Value = 100;
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
			id = 10,
			type = "text",
			icon = "ui/icons/regular_damage.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+25%[/color] 近战伤害"
		});
		result.push({
			id = 11,
			type = "text",
			icon = "ui/icons/melee_defense.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15[/color] 近战防御"
		});
		result.push({
			id = 12,
			type = "text",
			icon = "ui/icons/ranged_defense.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15[/color] 远程防御"
		});
		result.push({
			id = 13,
			type = "text",
			icon = "ui/icons/morale.png",
			text = "失去生命值时不会触发士气检查"
		});
		result.push({
			id = 65,
			type = "text",
			text = "右键单击或拖动到当前选定的角色上进行食用。 此物品会在使用过程中消耗掉。"
		});
		result.push({
			id = 65,
			type = "hint",
			icon = "ui/tooltips/warning.png",
			text = "过度使用可能导致疾病"
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/cloth_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onUse( _actor, _item = null )
	{
		this.Sound.play("sounds/combat/eat_01.wav", this.Const.Sound.Volume.Inventory);
		_actor.getSkills().add(this.new("scripts/skills/effects/berserker_mushrooms_effect"));
		this.Const.Tactical.Common.checkDrugEffect(_actor);
		return true;
	}

});
