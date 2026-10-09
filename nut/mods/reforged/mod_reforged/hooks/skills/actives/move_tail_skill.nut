::Reforged.HooksMod.hook("scripts/skills/actives/move_tail_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "你走到哪，尾巴就跟到哪！";
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.skill.getDefaultUtilityTooltip();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("无视[控制区域|Concept.ZoneOfControl]，将尾巴带到相邻地格")
				});
				return ret;
			}

		}.getTooltip;
	};
});
