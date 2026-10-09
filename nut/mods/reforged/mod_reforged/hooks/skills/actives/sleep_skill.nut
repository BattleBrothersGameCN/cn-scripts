::Reforged.HooksMod.hook("scripts/skills/actives/sleep_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "使敌人坠入梦境，直面让其魂飞魄散的梦魇！";
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
					text = ::Reforged.Mod.Tooltips.parseString("目标进行一次有[决心|Concept.Bravery]减值的[士气检定|Concept.Morale]，离你越近减值越大，如成功，目标就会[睡着|Skill+sleeping_effect]。")
				});
				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/vision.png",
					text = "技能范围为" + ::MSU.Text.colorizeValue(this.getMaxRange()) + "格"
				});
				return ret;
			}

		}.getTooltip;
	};
});
