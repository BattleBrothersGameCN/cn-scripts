this.greater_flesh_golem_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.greater_flesh_golem_potion";
		this.m.Name = "卓越药剂";
		this.m.Description = "这种血清提取自所谓“更伟大”的血肉魔像的骨髓之中，只要有了它，再虚弱的人也能重返体能巅峰。看啊，大先知的扭曲愿景，已经突破了束缚，成为了现实！";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_43.png";
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
			text = "随机获得两个正面特性"
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
			text = "使身体发生变异，引发疾病。"
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onUse( _actor, _item = null )
	{
		local applicableTraits = [
			"scripts/skills/traits/athletic_trait",
			"scripts/skills/traits/brave_trait",
			"scripts/skills/traits/bright_trait",
			"scripts/skills/traits/deathwish_trait",
			"scripts/skills/traits/dexterous_trait",
			"scripts/skills/traits/eagle_eyes_trait",
			"scripts/skills/traits/fearless_trait",
			"scripts/skills/traits/hate_beasts_trait",
			"scripts/skills/traits/hate_greenskins_trait",
			"scripts/skills/traits/hate_undead_trait",
			"scripts/skills/traits/iron_lungs_trait",
			"scripts/skills/traits/iron_jaw_trait",
			"scripts/skills/traits/loyal_trait",
			"scripts/skills/traits/lucky_trait",
			"scripts/skills/traits/night_owl_trait",
			"scripts/skills/traits/optimist_trait",
			"scripts/skills/traits/quick_trait",
			"scripts/skills/traits/strong_trait",
			"scripts/skills/traits/sure_footing_trait",
			"scripts/skills/traits/survivor_trait",
			"scripts/skills/traits/swift_trait",
			"scripts/skills/traits/teamplayer_trait",
			"scripts/skills/traits/tough_trait"
		];
		local traitsToAdd = 2;

		while (traitsToAdd > 0 && applicableTraits.len() > 0)
		{
			local trait = this.new(applicableTraits.remove(this.Math.rand(0, applicableTraits.len() - 1)));

			if (!_actor.getSkills().hasSkill(trait.getID()))
			{
				_actor.getSkills().add(trait);
				traitsToAdd = traitsToAdd - 1;
			}
		}

		_actor.getSkills().add(this.new("scripts/skills/effects/greater_flesh_golem_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});
