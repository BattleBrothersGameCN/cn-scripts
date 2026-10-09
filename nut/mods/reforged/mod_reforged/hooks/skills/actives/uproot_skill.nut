::Reforged.HooksMod.hook("scripts/skills/actives/uproot_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "从地上升起带刺的粗壮根系，冲撞穿刺多个目标。";
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.getDefaultTooltip();
				ret.extend([
					{
						id = 10,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("攻击一条直线上的至多" + ::MSU.Text.colorPositive(3) + "个目标")
					},
					{
						id = 11,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("命中时，使目标陷入[[|Skill+staggered_effect]")
					},
					{
						id = 12,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("不会伤害或影响其他树人")
					}
				]);
				return ret;
			}

		}.getTooltip;
	};
});
