::Reforged.HooksMod.hook("scripts/skills/actives/kraken_bite_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "用你巨大的口器扯碎目标！";
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.skill.getDefaultTooltip();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("当造成至少[$ $|Skill+bleeding_effect]时" + ::MSU.Text.colorNegative(::Const.Combat.MinDamageToApplyBleeding) + "点[生命值|Concept.Hitpoints]伤害时，施加[$ $|Skill+bleeding_effect]效果")
				});
				return ret;
			}

		}.getTooltip;
	};
});
