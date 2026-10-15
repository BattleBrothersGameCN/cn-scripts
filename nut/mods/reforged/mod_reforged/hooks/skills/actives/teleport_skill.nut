::Reforged.HooksMod.hook("scripts/skills/actives/teleport_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "在位面当中穿梭，在本位面的其他位置现身。";
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
					text = ::Reforged.Mod.Tooltips.parseString("将传送起点和终点周围的地形变为雪地")
				});
				return ret;
			}

		}.getTooltip;
	};
});
