::Reforged.HooksMod.hook("scripts/skills/actives/serpent_hook_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "缠住目标，将其拖入险境！";
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
					text = ::Reforged.Mod.Tooltips.parseString("将目标拖到身边地格中")
				});
				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("使目标[$ $|Skill+staggered_effect]")
				});
				ret.push({
					id = 12,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("使目标失去[$ $|Skill+shieldwall_effect]，[$ $|Skill+spearwall_effect]和[$ $|Skill+riposte_effect]效果")
				});
				ret.push({
					id = 13,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = ::Reforged.Mod.Tooltips.parseString("目标被拖到较低地格时会受到伤害")
				});
				ret.push({
					id = 14,
					type = "text",
					icon = "ui/icons/vision.png",
					text = "攻击范围为" + ::MSU.Text.colorizeValue(this.getMaxRange()) + "格"
				});
				return ret;
			}

		}.getTooltip;
	};
});
