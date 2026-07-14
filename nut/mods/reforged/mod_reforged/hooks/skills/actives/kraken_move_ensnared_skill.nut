::Reforged.HooksMod.hook("scripts/skills/actives/kraken_move_ensnared_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "该角色正被拖向克拉肯！";
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
					text = ::Reforged.Mod.Tooltips.parseString("每回合中，你都会被拖向克拉肯")
				});
				return ret;
			}

		}.getTooltip;
	};
});
