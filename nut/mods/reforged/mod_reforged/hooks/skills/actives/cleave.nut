::Reforged.HooksMod.hook("scripts/skills/actives/cleave", function ( q )
{
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();

				foreach( entry in ret )
				{
					if (entry.id == 8 && entry.text.find("流血伤害，持续") != null)
					{
						entry.text = ::Reforged.Mod.Tooltips.parseString("额外造成可叠加的[流血|Skill+bleeding_effect]伤害");
						break;
					}
				}

				return ret;
			}

		}.getTooltip;
	};
});
