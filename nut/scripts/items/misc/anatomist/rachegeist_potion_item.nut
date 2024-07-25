this.rachegeist_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.rachegeist_potion";
		this.m.Name = "复仇刀锋灵药";
		this.m.Description = "很少有生物能像所谓的“复仇之魂”那样难以理解。然而，通过对它所剩无几的遗骸仔细检查，这种神奇的药水诞生了！现在，即使是凡人，也可以发挥与亡灵无异的力量！";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_40.png";
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
			text = "造成 [color=" + this.Const.UI.Color.PositiveValue + "]+%25[/color] 伤害并仅受到[color=" + this.Const.UI.Color.PositiveValue + "]75%[/color] 任何伤害，如果生命值低于 [color=" + this.Const.UI.Color.NegativeValue + "]50%[/color]"
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
		_actor.getSkills().add(this.new("scripts/skills/effects/rachegeist_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});
