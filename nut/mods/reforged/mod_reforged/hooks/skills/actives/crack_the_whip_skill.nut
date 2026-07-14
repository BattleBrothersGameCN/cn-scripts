::Reforged.HooksMod.hook("scripts/skills/actives/crack_the_whip_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "抽打鞭子，让你的野宠物听话。";
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
					text = ::Reforged.Mod.Tooltips.parseString("防止你的动物在下[回合|Concept.Turn]中回归野性")
				});
				return ret;
			}

		}.getTooltip;
	};
});
