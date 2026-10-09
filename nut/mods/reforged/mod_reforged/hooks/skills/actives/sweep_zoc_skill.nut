::Reforged.HooksMod.hook("scripts/skills/actives/sweep_zoc_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = ::Reforged.Mod.Tooltips.parseString("向试图你[离开|Concept.ZoneOfControl]的敌人挥舞拳头。");
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
					text = ::Reforged.Mod.Tooltips.parseString("命中时会[趔趄|Skill+staggered_effect]目标")
				});
				return ret;
			}

		}.getTooltip;
	};
});
