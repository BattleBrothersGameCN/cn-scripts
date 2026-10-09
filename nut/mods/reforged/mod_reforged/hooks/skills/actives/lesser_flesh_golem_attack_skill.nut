::Reforged.HooksMod.hook("scripts/skills/actives/lesser_flesh_golem_attack_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = ::Reforged.Mod.Tooltips.parseString("一记对不免疫[$ $|Skill+stunned_effect]的命中目标施加[$ $|Skill+dazed_effect]效果的近战钝击。");
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
