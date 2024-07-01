this.honor_guard_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.honor_guard_potion";
		this.m.Name = "血肉化骨药剂";
		this.m.Description = "远古亡灵因其不可动摇的目标和坚不可摧的意志而受到应有的恐惧，但任何有经验的战士都知道骷髅还有第三种可怕的地方，那就是长矛和利箭对这些怪物几乎毫无作用。有了这种混合物，就算是活人也可以获得这样的防护力！";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_19.png";
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
			text = "承受[color=" + this.Const.UI.Color.PositiveValue + "]25%[/color]到[color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] 的伤害减免。"
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
		_actor.getSkills().add(this.new("scripts/skills/effects/honor_guard_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});
