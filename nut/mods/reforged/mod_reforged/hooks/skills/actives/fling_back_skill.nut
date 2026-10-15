::Reforged.HooksMod.hook("scripts/skills/actives/fling_back_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "猛然撞退一名角色，移动到他的位置！";
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
					icon = "ui/icons/fatigue.png",
					text = ::Reforged.Mod.Tooltips.parseString("使目标积累" + ::MSU.Text.colorNegative("10") + "点[疲劳值|Concept.Fatigue]")
				});
				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = ::Reforged.Mod.Tooltips.parseString("目标被猛然撞退，会在下落时受到伤害")
				});
				ret.push({
					id = 12,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("目标会失去诸如[$ $|Skill+shieldwall_effect]、[$ $|Skill+spearwall_effect]和[$ $|Skill+riposte_effect]之类的效果")
				});
				ret.push({
					id = 13,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("无视[控制区域|Concept.ZoneOfControl]，移入目标地格")
				});
				return ret;
			}

		}.getTooltip;
	};
	q.onFollow = function ( __original )
	{
		return {
			function onFollow( _tag )
			{
				if (::Time.getVirtualSpeed() > 2)
				{
					::Time.scheduleEvent(::TimeUnit.Virtual, 100, __original, _tag);
				}
				else
				{
					__original(_tag);
				}
			}

		}.onFollow;
	};
});
