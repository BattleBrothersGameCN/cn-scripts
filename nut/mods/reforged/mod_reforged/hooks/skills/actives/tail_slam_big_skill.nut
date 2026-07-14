::Reforged.HooksMod.hook("scripts/skills/actives/tail_slam_big_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Name = "扫尾";
				this.m.Description = "肆意扫动你的尾巴，不分敌我，抽打周围的所有目标！";
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
						text = ::Reforged.Mod.Tooltips.parseString("随机[茫然|Skill+dazed_effect]，[击晕|Skill+stunned_effect]，或击退目标")
					}
				]);
				return ret;
			}

		}.getTooltip;
	};
});
