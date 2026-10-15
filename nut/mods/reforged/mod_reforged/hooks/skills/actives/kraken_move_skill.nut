::Reforged.HooksMod.hook("scripts/skills/actives/kraken_move_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "将一根触手从移动到另一处。";
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				return this.skill.getDefaultUtilityTooltip();
			}

		}.getTooltip;
	};
});
