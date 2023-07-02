this.direwolf_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.direwolf_potion";
		this.m.Name = "刀锋舞者药剂";
		this.m.Description = "这种略显喜感的混合物来源于对可怕的冰原野狼的研究，即使是最笨拙的白痴在喝下它之后也会变成动作如舞蹈般轻盈的战士，就算在那些足以把弱者累趴下的持久战中，他们也能在战场中翩翩起舞！服用后出现轻度的多动症状属于正常现象。";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_26.png";
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
			text = "攻击未命中时会有[color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] 的疲劳值消耗返还"
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
		_actor.getSkills().add(this.new("scripts/skills/effects/direwolf_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});
