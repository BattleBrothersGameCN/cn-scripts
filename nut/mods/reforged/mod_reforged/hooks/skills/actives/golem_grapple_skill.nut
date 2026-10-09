::Reforged.HooksMod.hook("scripts/skills/actives/golem_grapple_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = ::Reforged.Mod.Tooltips.parseString("一记不造成伤害，而是在命中时[缴械|Skill+disarmed_effect]敌人的近战攻击。");
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
