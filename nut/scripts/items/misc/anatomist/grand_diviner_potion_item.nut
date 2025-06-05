this.grand_diviner_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.grand_diviner_potion";
		this.m.Name = "启迪灵药";
		this.m.Description = "人们常说，毒与药的区别在于剂量，最能印证这一点的，莫过于这种在大先知香炉里发现，甚至存在于他血液里的奇异物质。而这种物质炼成的灵药，必将授予饮用者不亚于他的超凡洞察力！";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_39.png";
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
			text = "立即获得相当于10级的经验值。"
		});
		result.push({
			id = 65,
			type = "text",
			text = "右键单击或拖动到当前选定的角色上进行饮用。此物品会在使用过程中消耗掉。"
		});
		result.push({
			id = 65,
			type = "hint",
			icon = "ui/tooltips/warning.png",
			text = "使身体发生变异，导致疾病"
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onUse( _actor, _item = null )
	{
		_actor.addXP(this.Const.LevelXP[10], false);
		_actor.updateLevel();
		_actor.getSkills().add(this.new("scripts/skills/effects/grand_diviner_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});
