::Reforged.HooksMod.hook("scripts/skills/actives/grant_night_vision_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "授予友军看穿黑暗的能力！";
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
					text = ::Reforged.Mod.Tooltips.parseString("本场战斗中，使目标和其相邻友军角色免受[$ $|Skill+night_effect]影响")
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
