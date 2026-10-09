::Reforged.HooksMod.hook("scripts/skills/actives/insects_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "召唤虫群，围攻一名敌人，让他们无法专心战斗！";
				this.m.IconDisabled = "skills/active_69_sw.png";
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
					text = ::Reforged.Mod.Tooltips.parseString("对目标施加[虫群笼罩|Skill+insect_swarm_effect]效果")
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
