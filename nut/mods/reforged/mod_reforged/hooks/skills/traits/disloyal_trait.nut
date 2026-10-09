::Reforged.HooksMod.hook("scripts/skills/traits/disloyal_trait", function ( q )
{
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/asset_money.png",
					text = ::MSU.Text.colorNegative("100%") + " more chance to desert on low mood"
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
				if (_groupID == "pg.special.rf_leadership")
				{
					return 0;
				}
			}

		}.getPerkGroupMultiplier;
	};
});
