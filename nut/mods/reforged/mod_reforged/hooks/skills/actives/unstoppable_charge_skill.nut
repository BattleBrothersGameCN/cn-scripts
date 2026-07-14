::Reforged.HooksMod.hook("scripts/skills/actives/unstoppable_charge_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "以不可阻挡之势冲进目标地格，为该区域带去混乱！";
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.getDefaultUtilityTooltip();
				ret.extend([
					{
						id = 10,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("将你移动到目标格中，随机[击晕|Skill+stunned_effect]，[趔趄|Skill+staggered_effect]或击退该格周围的敌人")
					},
					{
						id = 11,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("被击退的目标会失去[$ $|Skill+shieldwall_effect]，[$ $|Skill+spearwall_effect]和[$ $|Skill+riposte_effect]效果")
					},
					{
						id = 12,
						type = "text",
						icon = "ui/icons/vision.png",
						text = "技能范围为" + ::MSU.Text.colorizeValue(this.getMaxRange()) + "格"
					}
				]);
				return ret;
			}

		}.getTooltip;
	};
});
