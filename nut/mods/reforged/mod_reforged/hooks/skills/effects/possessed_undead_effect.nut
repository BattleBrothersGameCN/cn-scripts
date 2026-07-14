::Reforged.HooksMod.hook("scripts/skills/effects/possessed_undead_effect", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = ::Reforged.Mod.Tooltips.parseString("该角色正被支配，直到其[回合|Concept.Turn]结束时为止。");
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.skill.getTooltip();
				ret.extend([
					{
						id = 10,
						type = "text",
						icon = "ui/icons/action_points.png",
						text = ::Reforged.Mod.Tooltips.parseString("[行动点数|Concept.ActionPoints]上限变为" + ::MSU.Text.colorPositive("12"))
					},
					{
						id = 11,
						type = "text",
						icon = "ui/icons/melee_skill.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+15") + "[近战技能|Concept.MeleeSkill]")
					},
					{
						id = 12,
						type = "text",
						icon = "ui/icons/melee_defense.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+10") + "[近战防御|Concept.MeleeDefense]")
					},
					{
						id = 13,
						type = "text",
						icon = "ui/icons/ranged_defense.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+10") + "[远程防御|Concept.RangeDefense]")
					},
					{
						id = 15,
						type = "text",
						icon = "ui/icons/initiative.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+50") + "[主动值|Concept.Initiative]")
					},
					{
						id = 16,
						type = "text",
						icon = "ui/icons/special.png",
						text = "受到的所有伤害降低" + ::MSU.Text.colorNegative("25%")
					}
				]);
				return ret;
			}

		}.getTooltip;
	};
});
