::Reforged.HooksMod.hook("scripts/skills/actives/gore_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "裹挟着超自然灵能冲锋，用你的巨角顶撞敌人。";
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
					text = ::Reforged.Mod.Tooltips.parseString("[趔趄|Skill+staggered_effect]并击退目标地格周围的敌人")
				});
				return ret;
			}

		}.getTooltip;
	};
});
