::Reforged.HooksMod.hook("scripts/skills/actives/tail_slam_split_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Name = "劈尾";
				this.m.Description = "猛扫尾巴，凌头拍击，能一次攻击直线上的两个地格。";
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.getDefaultTooltip();
				ret.extend([
					{
						id = 10,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("随机[茫然|Skill+dazed_effect]或[击晕|Skill+stunned_effect]目标")
					}
				]);
				return ret;
			}

		}.getTooltip;
	};
});
