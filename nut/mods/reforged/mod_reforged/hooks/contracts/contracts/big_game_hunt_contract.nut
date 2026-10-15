::Reforged.HooksMod.hook("scripts/contracts/contracts/big_game_hunt_contract", function ( q )
{
	q.RF_getDestinations = function ()
	{
		return {
			function RF_getDestinations()
			{
				return [
					this.m.Flags.get("Region")
				];
			}

		}.RF_getDestinations;
	};
});
