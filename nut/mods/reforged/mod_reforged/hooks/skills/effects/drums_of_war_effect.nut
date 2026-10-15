::Reforged.HooksMod.hook("scripts/skills/effects/drums_of_war_effect", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "得益于盟友战鼓的激昂节奏，该角色体会到了前所未有的活力。";
				this.m.IsHidden = false;
			}

		}.create;
	};
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/fatigue.png",
					text = ::Reforged.Mod.Tooltips.parseString("受到该效果时，累积[疲劳值|Concept.Fatigue]减少" + ::MSU.Text.colorPositive("15") + "点")
				});
				ret.push({
					id = 20,
					type = "text",
					icon = "ui/icons/warning.png",
					text = ::Reforged.Mod.Tooltips.parseString("每[回合|Concept.Turn]只能受到一次")
				});
				return ret;
			}

		}.getTooltip;
	};
});
