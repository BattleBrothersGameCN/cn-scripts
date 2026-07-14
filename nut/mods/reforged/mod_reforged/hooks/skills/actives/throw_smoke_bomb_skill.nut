::Reforged.HooksMod.hook("scripts/skills/actives/throw_smoke_bomb_skill", function ( q )
{
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();

				foreach( index, entry in ret )
				{
					if (entry.id == 5 && entry.text.find("烟雾中的角色远程防御增加 ") != null)
					{
						ret.remove(index);
						break;
					}
				}

				ret.extend([
					{
						id = 10,
						type = "text",
						icon = "ui/icons/ranged_skill.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("50%") + " less [Ranged Skill|Concept.RangeSkill] for anyone inside")
					},
					{
						id = 11,
						type = "text",
						icon = "ui/icons/ranged_defense.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+30") + " [Ranged Defense|Concept.RangeDefense] for anyone inside")
					}
				]);
				return ret;
			}

		}.getTooltip;
	};
});
