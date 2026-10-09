::Reforged.HooksMod.hook("scripts/skills/racial/grand_diviner_racial", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();

				if (this.isType(::Const.SkillType.Perk))
				{
					this.removeType(::Const.SkillType.Perk);
				}
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.skill.getTooltip();
				ret.extend([
					{
						id = 10,
						type = "text",
						icon = "ui/icons/action_points.png",
						text = ::Reforged.Mod.Tooltips.parseString("[$ $|Skill+censer_castigate_skill]和[$ $|Skill+censer_strike]消耗的[行动点数|Concept.ActionPoints]" + ::MSU.Text.colorizeValue(this.m.APAdjust, {
							AddSign = true,
							InvertColor = true
						}) + " [Action Points|Concept.ActionPoints]")
					}
				]);
				return ret;
			}

		}.getTooltip;
	};
});
