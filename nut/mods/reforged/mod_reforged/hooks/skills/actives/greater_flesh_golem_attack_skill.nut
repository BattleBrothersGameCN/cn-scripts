::Reforged.HooksMod.hook("scripts/skills/actives/greater_flesh_golem_attack_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = ::Reforged.Mod.Tooltips.parseString("一记能[击晕|Skill+stunned_effect]命中目标的强力近战钝击。");
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
