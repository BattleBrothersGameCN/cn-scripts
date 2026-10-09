::Reforged.HooksMod.hook("scripts/skills/actives/wither_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "诅咒目标，抽干他的体力。";
				this.m.AIBehaviorID = ::Const.AI.Behavior.ID.Wither;
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.getDefaultUtilityTooltip();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("使目标[$ $|Skill+withered_effect]")
				});
				return ret;
			}

		}.getTooltip;
	};
});
