::Reforged.HooksMod.hook("scripts/skills/actives/miasma_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "在目标区域召唤有毒瘴气，对所有需要呼吸的生灵造成伤害！";
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
					text = ::Reforged.Mod.Tooltips.parseString("目标地格生成瘴气，持续" + ::MSU.Text.colorPositive(3) + "[轮|Concept.Round]")
				});
				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("若有任何非亡灵角色在瘴气中结束[回合|Concept.Turn]，使其受到" + ::MSU.Text.colorNegative(5) + " - " + ::MSU.Text.colorNegative(10) + " damage when they end their [turn|Concept.Turn] in the miasma")
				});
				ret.push({
					id = 12,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("吹散火焰，烟雾等现有地格效果")
				});
				ret.push({
					id = 13,
					type = "text",
					icon = "ui/icons/vision.png",
					text = "技能范围为" + ::MSU.Text.colorizeValue(this.getMaxRange()) + "格"
				});
				return ret;
			}

		}.getTooltip;
	};
});
