::Reforged.HooksMod.hook("scripts/skills/actives/kraken_ensnare_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "用一条巨型触手困住目标，慢慢把它拽向你！";
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
					text = ::Reforged.Mod.Tooltips.parseString("对目标施加[$ $|Skill+kraken_ensnare_effect]状态")
				});
				return ret;
			}

		}.getTooltip;
	};
});
