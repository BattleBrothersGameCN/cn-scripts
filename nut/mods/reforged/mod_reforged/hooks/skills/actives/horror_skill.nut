::Reforged.HooksMod.hook("scripts/skills/actives/horror_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "释放目标最深的恐惧，吓得他们动弹不得！";
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
					icon = "ui/icons/bravery.png",
					text = ::Reforged.Mod.Tooltips.parseString("目标会承受一次带有[士气检定|Concept.Morale]的" + ::MSU.Text.colorNegative(-15) + "[决心|Concept.Bravery]减值的精神[士气检定|Concept.Morale]")
				});
				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/bravery.png",
					text = ::Reforged.Mod.Tooltips.parseString("目标还会额外承受一次带有[士气检定|Concept.Morale]的" + ::MSU.Text.colorNegative(-5) + "[决心|Concept.Bravery]减值的精神[士气检定|Concept.Morale]。若此次[士气检定|Concept.MoraleCheck]成功，对目标施加[惊骇|Skill+horrified_effect]效果")
				});
				return ret;
			}

		}.getTooltip;
	};
});
