::Reforged.HooksMod.hook("scripts/items/accessory/iron_will_potion_item", function ( q )
{
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();

				foreach( entry in ret )
				{
					if (entry.id == 11)
					{
						entry.text = ::Reforged.Mod.Tooltips.parseString("不会受到[临时创伤|Concept.InjuryTemporary]，也不会被其影响。");
						break;
					}
				}

				return ret;
			}

		}.getTooltip;
	};
});
