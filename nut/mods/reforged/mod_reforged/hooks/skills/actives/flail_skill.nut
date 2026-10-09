::Reforged.HooksMod.hook("scripts/skills/actives/flail_skill", function ( q )
{
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();

				foreach( entry in ret )
				{
					if (entry.id == 7)
					{
						entry.text = ::Reforged.Mod.Tooltips.parseString(this.format("无视除[$ $|Skill+shieldwall_effect]效果外的盾牌[近战防御|Concept.MeleeDefense]增益"));
						break;
					}
				}

				return ret;
			}

		}.getTooltip;
	};
});
