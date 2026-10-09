::Reforged.HooksMod.hook("scripts/skills/actives/drums_of_war_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "打出激昂节奏，消除友军疲劳，提升其战意。";
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
					icon = "ui/icons/fatigue.png",
					text = ::Reforged.Mod.Tooltips.parseString("所有其他友军获得[战鼓|Skill+drums_of_war_effect]效果")
				});
				return ret;
			}

		}.getTooltip;
	};
});
