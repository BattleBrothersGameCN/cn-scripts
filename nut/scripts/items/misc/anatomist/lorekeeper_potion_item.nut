this.lorekeeper_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.lorekeeper_potion";
		this.m.Name = "冥府之门灵药";
		this.m.Description = "这个小瓶里装着一种强大的镇静剂，它会使人进入即使疼痛也无法打破的深度睡眠。这瓶药剂的实际作用是让受试者长时间处于麻醉状态，以便移植一排肋骨，这些骨骼本身是从“守密人”的一个命匣中抢救出来的。";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_38.png";
		this.m.Value = 0;
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
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = "每场战斗只能触发一次，在遭受致命伤害时抵抗该次伤害并恢复所有生命值"
		});
		result.push({
			id = 65,
			type = "text",
			text = "右键单击或拖动到当前选定的角色上进行饮用。 此物品会在使用过程中消耗掉。"
		});
		result.push({
			id = 65,
			type = "hint",
			icon = "ui/tooltips/warning.png",
			text = "会让使用者的身体发生突变并导致疾病"
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onUse( _actor, _item = null )
	{
		_actor.getSkills().add(this.new("scripts/skills/effects/lorekeeper_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});
