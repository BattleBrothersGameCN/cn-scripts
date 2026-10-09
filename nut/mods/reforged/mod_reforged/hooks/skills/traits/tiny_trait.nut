::Reforged.HooksMod.hook("scripts/skills/traits/tiny_trait", function ( q )
{
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();

				foreach( entry in ret )
				{
					if (entry.id == 12)
					{
						entry.text = ::MSU.Text.colorNegative("10%") + " less melee damage";
						break;
					}
				}

				ret.push({
					id = 13,
					type = "text",
					icon = "ui/icons/rf_reach.png",
					text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("-1") + "[触及距离|Concept.Reach]")
				});
				return ret;
			}

		}.getTooltip;
	};
	q.getPerkGroupMultiplier = function ()
	{
		return {
			function getPerkGroupMultiplier( _groupID, _perkTree )
			{
				if (_groupID == "pg.rf_tough")
				{
					return 0;
				}
			}

		}.getPerkGroupMultiplier;
	};
	q.onUpdate = function ( __original )
	{
		return {
			function onUpdate( _properties )
			{
				local oldMult = _properties.MeleeDamageMult;
				__original(_properties);
				_properties.MeleeDamageMult = oldMult * 0.9;
				_properties.Reach -= 1;
			}

		}.onUpdate;
	};
});
