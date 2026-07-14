::Reforged.HooksMod.hook("scripts/skills/actives/headbutt_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "一记造成钝击创伤的蛮力攻击。";
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				return this.skill.getDefaultTooltip();
			}

		}.getTooltip;
	};
});
