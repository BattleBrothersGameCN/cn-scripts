::Reforged.HooksMod.hook("scripts/skills/actives/adrenaline_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.AIBehaviorID = ::Const.AI.Behavior.ID.Adrenaline;
			}

		}.create;
	};
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();
				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("技能激活时，不会受到[临时创伤|Concept.InjuryTemporary]，也不会被其影响。")
				});
				return ret;
			}

		}.getTooltip;
	};
});
