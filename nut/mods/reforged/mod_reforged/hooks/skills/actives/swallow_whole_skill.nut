::Reforged.HooksMod.hook("scripts/skills/actives/swallow_whole_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "囫囵吞下接邻目标!";
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
					text = ::Reforged.Mod.Tooltips.parseString("目标下肚，获得[$ $|Skill+swallowed_whole_effect]效果")
				});
				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/bravery.png",
					text = ::Reforged.Mod.Tooltips.parseString("目标[士气|Concept.Morale]变为[崩溃|Concept.Morale]")
				});
				return ret;
			}

		}.getTooltip;
	};
});
