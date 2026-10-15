::Reforged.HooksMod.hook("scripts/skills/actives/fire_mortar_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "将炮弹发射到空中，以期在落到地面时产生爆炸冲击，造成严重破坏。";
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
					text = ::Reforged.Mod.Tooltips.parseString("标记某地格和它周围的地格，在该角色的下[回合|Concept.Turn]冲击该位置。冲击时，这些地格上的角色会受到伤害，并被[炮火震撼|Skill+shellshocked_effect]")
				});
				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/vision.png",
					text = "技能范围为" + ::MSU.Text.colorizeValue(this.getMaxRange()) + "格"
				});
				ret.push({
					id = 20,
					type = "text",
					icon = "ui/icons/warning.png",
					text = ::Reforged.Mod.Tooltips.parseString("每" + ::MSU.Text.colorNegative(this.m.Cooldown) + "[回合|Concept.Turn]限一次")
				});
				return ret;
			}

		}.getTooltip;
	};
});
