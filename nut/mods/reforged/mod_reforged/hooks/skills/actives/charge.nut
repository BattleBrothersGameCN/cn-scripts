::Reforged.HooksMod.hook("scripts/skills/actives/charge", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "全力冲刺，以绝对的力量撞向敌人！";
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
						text = ::Reforged.Mod.Tooltips.parseString("移动到目标地格")
					},
					{
						id = 11,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("[击晕|Skill+stunned_effect]接邻目标地格的一名随机敌人，击晕概率为" + ::MSU.Text.colorPositive("100%") + "减去目标盾牌和[盾墙|Skill+shieldwall_effect]技能提供的近战防御")
					},
					{
						id = 12,
						type = "text",
						icon = "ui/icons/vision.png",
						text = "技能范围为" + ::MSU.Text.colorizeValue(this.getMaxRange()) + "格"
					}
				]);

				if (this.getContainer().getActor().isEngagedInMelee())
				{
					ret.push({
						id = 20,
						type = "text",
						icon = "ui/icons/warning.png",
						text = ::Reforged.Mod.Tooltips.parseString("因已[陷入近战|Concept.ZoneOfControl]，无法使用")
					});
				}

				return ret;
			}

		}.getTooltip;
	};
});
