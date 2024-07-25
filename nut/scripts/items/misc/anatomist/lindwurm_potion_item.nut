this.lindwurm_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.lindwurm_potion";
		this.m.Name = "灰烬之血药剂";
		this.m.Description = "让你的血液沸腾起来吧！或者，更准确的形容是……算了不重要！有了这种药剂，林德蠕龙那滚烫的鲜血将流过人类的血管，幸运的受试者对此却毫不知情。当然，直到他们开始流血为止。";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_27.png";
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
			text = "使用者的血液将变为滚烫的酸液，并在承受生命值伤害时对近战范围内的攻击者施加“酸液腐蚀”状态"
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
		_actor.getSkills().add(this.new("scripts/skills/effects/lindwurm_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});
