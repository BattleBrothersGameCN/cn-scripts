::Reforged.HooksMod.hook("scripts/skills/actives/goblin_whip", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "抽打鞭子，确保麾下地精的战斗意志。";
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
					icon = "ui/icons/bravery.png",
					text = ::Reforged.Mod.Tooltips.parseString("将目标士气[士气|Concept.Morale]提升到自信，若目标溃逃，则提升到稳定。")
				});
				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/vision.png",
					text = "技能范围为" + ::MSU.Text.colorizeValue(this.getMaxRange()) + "格"
				});
				return ret;
			}

		}.getTooltip;
	};
});
