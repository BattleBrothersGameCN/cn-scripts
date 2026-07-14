local RF_getResolveTooltipText = function ( _text )
{
	_text = ::String.replace(_text, "决心", "[Resolve|Concept.Bravery]");
	_text = ::String.replace(_text, "近战", "[engaged|Concept.ZoneOfControl]");
	_text = _text + " during [morale checks|Concept.Morale]";
	return ::Reforged.Mod.Tooltips.parseString(_text);
};
::Reforged.HooksMod.hook("scripts/items/armor_upgrades/direwolf_pelt_upgrade", function ( q )
{
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();

				foreach( entry in ret )
				{
					if (entry.id == 15)
					{
						entry.text = RF_getResolveTooltipText(entry.text);
						break;
					}
				}

				return ret;
			}

		}.getTooltip;
	};
	q.onArmorTooltip = function ( __original )
	{
		return {
			function onArmorTooltip( _result )
			{
				local idx = _result.len() - 1;
				__original(_result);

				for( local i = idx + 1; i < _result.len(); i++ )
				{
					local entry = _result[i];

					if (entry.id == 15)
					{
						entry.text = RF_getResolveTooltipText(entry.text);
						break;
					}
				}
			}

		}.onArmorTooltip;
	};
});
