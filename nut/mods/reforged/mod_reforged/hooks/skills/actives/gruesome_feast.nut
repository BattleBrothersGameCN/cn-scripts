::Reforged.HooksMod.hook("scripts/skills/actives/gruesome_feast", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "吞食尸体，治疗自己，增长身量！";
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
					icon = "ui/icons/health.png",
					text = ::Reforged.Mod.Tooltips.parseString("治愈所有[生命值|Concept.Hitpoints]和[创伤|Concept.InjuryTemporary]")
				});
				ret.push({
					id = 12,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("获得[$ $|Skill+gruesome_feast_effect]效果")
				});
				return ret;
			}

		}.getTooltip;
	};
});
