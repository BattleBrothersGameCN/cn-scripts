::Reforged.HooksMod.hook("scripts/skills/actives/grow_shield_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "再生盾牌，保护弱点！";
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
					text = ::Reforged.Mod.Tooltips.parseString("获得一面[$ $|Item+schrat_shield]")
				});
				return ret;
			}

		}.getTooltip;
	};
});
