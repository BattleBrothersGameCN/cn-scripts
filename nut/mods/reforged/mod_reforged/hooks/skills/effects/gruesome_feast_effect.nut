::Reforged.HooksMod.hook("scripts/skills/effects/gruesome_feast_effect", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "对着具尸体饱餐一顿，这怪物长得越发硕大，变得更有力量。";
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.skill.getTooltip();
				local size = this.getContainer().getActor().getSize();

				if (size == 2)
				{
					ret.push({
						id = 10,
						type = "text",
						icon = "ui/icons/health.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+120") + "[生命值|Concept.Hitpoints]")
					});
					ret.push({
						id = 11,
						type = "text",
						icon = "ui/icons/melee_skill.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+10") + "[近战技能|Concept.MeleeSkill]")
					});
					ret.push({
						id = 12,
						type = "text",
						icon = "ui/icons/melee_defense.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+5") + "[近战防御|Concept.MeleeDefense]")
					});
					ret.push({
						id = 13,
						type = "text",
						icon = "ui/icons/ranged_defense.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("-5") + "[远程防御|Concept.RangeDefense]")
					});
					ret.push({
						id = 14,
						type = "text",
						icon = "ui/icons/bravery.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+30") + "[决心|Concept.Bravery]")
					});
					ret.push({
						id = 15,
						type = "text",
						icon = "ui/icons/regular_damage.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+15") + "最小伤害")
					});
					ret.push({
						id = 16,
						type = "text",
						icon = "ui/icons/regular_damage.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+20") + "最大伤害")
					});
					ret.push({
						id = 17,
						type = "text",
						icon = "ui/icons/initiative.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("-15") + "[主动值|Concept.Initiative]")
					});
				}
				else if (size == 3)
				{
					ret.push({
						id = 10,
						type = "text",
						icon = "ui/icons/health.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+300") + "[生命值|Concept.Hitpoints]")
					});
					ret.push({
						id = 11,
						type = "text",
						icon = "ui/icons/melee_skill.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+20") + "[近战技能|Concept.MeleeSkill]")
					});
					ret.push({
						id = 12,
						type = "text",
						icon = "ui/icons/melee_defense.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+10") + "[近战防御|Concept.MeleeDefense]")
					});
					ret.push({
						id = 13,
						type = "text",
						icon = "ui/icons/ranged_defense.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("-10") + "[远程防御|Concept.RangeDefense]")
					});
					ret.push({
						id = 14,
						type = "text",
						icon = "ui/icons/bravery.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+60") + "[决心|Concept.Bravery]")
					});
					ret.push({
						id = 15,
						type = "text",
						icon = "ui/icons/regular_damage.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+30") + "最小伤害")
					});
					ret.push({
						id = 16,
						type = "text",
						icon = "ui/icons/regular_damage.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+40") + "最大伤害")
					});
					ret.push({
						id = 17,
						type = "text",
						icon = "ui/icons/initiative.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("-30") + "[主动值|Concept.Initiative]")
					});
				}

				return ret;
			}

		}.getTooltip;
	};
});
