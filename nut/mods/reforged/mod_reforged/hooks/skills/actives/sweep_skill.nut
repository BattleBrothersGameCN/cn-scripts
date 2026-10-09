::Reforged.HooksMod.hook("scripts/skills/actives/sweep_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "大弧度逆时针挥舞拳头，最多命中三个相邻角色！";
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.skill.getDefaultTooltip();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("最多命中" + ::MSU.Text.colorPositive(3) + "个目标")
				});
				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("击退不免疫击退或定身的目标。被击退时，目标会失去[$ $|Skill+shieldwall_effect]、[$ $|Skill+spearwall_effect]和[$ $|Skill+riposte_effect]效果")
				});
				ret.push({
					id = 12,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("免疫击退或定身的目标会被[$ $|Skill+staggered_effect]")
				});
				return ret;
			}

		}.getTooltip;
	};
});
