::Reforged.HooksMod.hook("scripts/contracts/contracts/deliver_item_contract", function ( q )
{
	q.onPrepareVariables = function ( __original )
	{
		return {
			function onPrepareVariables( _vars )
			{
				__original(_vars);

				foreach( var in _vars )
				{
					if (var[0] != "days")
					{
						continue;
					}

					local seconds = this.getSecondsRequiredToTravel(this.m.Flags.get("Distance"), ::Const.World.MovementSettings.Speed, true);
					var[1] = "[color=#f6eedb]" + ::Reforged.Text.getDaysAndHalf(seconds) + "[/color]";
					break;
				}
			}

		}.onPrepareVariables;
	};
	q.RF_getOriginText = function ( __original )
	{
		return {
			function RF_getOriginText()
			{
				return "去" + __original();
			}

		}.RF_getOriginText;
	};
});
