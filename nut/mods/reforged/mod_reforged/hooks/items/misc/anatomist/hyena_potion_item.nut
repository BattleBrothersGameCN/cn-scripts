::Reforged.HooksMod.hook("scripts/items/misc/anatomist/hyena_potion_item", function ( q )
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
						entry.text = ::Reforged.Mod.Tooltips.parseString("[$ $|Skill+bleeding_effect]的效果" + ::MSU.Text.colorPositive("减半"));
						break;
					}
				}

				return ret;
			}

		}.getTooltip;
	};
});
