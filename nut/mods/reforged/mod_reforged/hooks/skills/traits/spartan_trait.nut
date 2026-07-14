::Reforged.HooksMod.hook("scripts/skills/traits/spartan_trait", function ( q )
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
					icon = "ui/icons/asset_daily_food.png",
					text = "每日食物消耗" + ::MSU.Text.colorPositive("-1") + " food daily"
				});
				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/asset_daily_food.png",
					text = "缺少食物失去的心情降低" + ::MSU.Text.colorPositive("50%") + " less mood due to going hungry"
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
				switch(_groupID)
				{
				case "pg.rf_tough":
				case "pg.rf_vigorous":
					return 0.5;
				}
			}

		}.getPerkGroupMultiplier;
	};
});
