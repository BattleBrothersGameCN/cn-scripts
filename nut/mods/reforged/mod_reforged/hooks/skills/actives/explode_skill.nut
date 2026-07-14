::Reforged.HooksMod.hook("scripts/skills/actives/explode_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "爆裂成骨头破片，伤害周围的一切。";
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
					text = ::Reforged.Mod.Tooltips.parseString("对相邻地格上的所有角色造成少量伤害")
				});
				return ret;
			}

		}.getTooltip;
	};
});
