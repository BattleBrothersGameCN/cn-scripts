::Reforged.HooksMod.hook("scripts/contracts/contracts/escort_caravan_contract", function ( q )
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

					local seconds = this.getSecondsRequiredToTravel(this.m.Flags.get("Distance"), ::Const.World.MovementSettings.Speed * 0.6, true);
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
	q.RF_getDaysRequiredToTravel = function ()
	{
		return {
			function RF_getDaysRequiredToTravel( _start, _end )
			{
				return this.getDaysRequiredToTravel(_start.getDistanceTo(_end), ::Const.World.MovementSettings.Speed * 0.6, true);
			}

		}.RF_getDaysRequiredToTravel;
	};
});
