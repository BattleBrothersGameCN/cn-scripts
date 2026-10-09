::Reforged.HooksMod.hook("scripts/skills/actives/charm_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = ::Reforged.Mod.Tooltips.parseString("尝试魅惑一名角色，强迫他背弃盟友，遵从你的命令。角色的[决心|Concept.Bravery]越高，抵抗魅惑的几率就越高。");
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
					text = ::Reforged.Mod.Tooltips.parseString("对目标触发多达" + ::MSU.Text.colorNegative("2") + "次[士气检定|Concept.Morale]，若成功至少1次，对目标施加[被魅惑|Skill+charmed_effect]效果")
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
