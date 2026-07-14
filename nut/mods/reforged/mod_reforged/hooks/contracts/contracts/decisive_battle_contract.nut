::Reforged.HooksMod.hook("scripts/contracts/contracts/decisive_battle_contract", function ( q )
{
	q.RF_getOriginText = function ()
	{
		return {
			function RF_getOriginText()
			{
				return ::Reforged.Mod.Tooltips.parseString(this.format("Against %s about %s %s of %s", ::Reforged.NestedTooltips.getNestedFactionName(::World.FactionManager.getFaction(this.m.Flags.get("EnemyNobleHouse"))), ::Reforged.Text.getDaysAndHalf(this.RF_getDaysRequiredToTravel(this.RF_getTile(this.getHome()), this.m.WarcampTile) * ::World.getTime().SecondsPerDay), ::Const.Strings.Direction8[this.getHome().getTile().getDirection8To(this.m.WarcampTile)], ::MSU.isEqual(::World.State.getCurrentTown(), this.getHome()) ? "here" : ::Reforged.NestedTooltips.getNestedWorldEntityName(this.getHome())));
			}

		}.RF_getOriginText;
	};
	q.onSerialize = function ( __original )
	{
		return {
			function onSerialize( _out )
			{
				if (!::MSU.isNull(this.m.WarcampTile))
				{
					this.m.Flags.set("RF_WarcampTileSquareCoords", this.format("%i,%i", this.m.WarcampTile.SquareCoords.X, this.m.WarcampTile.SquareCoords.Y));
				}

				__original(_out);
			}

		}.onSerialize;
	};
	q.onDeserialize = function ( __original )
	{
		return {
			function onDeserialize( _in )
			{
				__original(_in);

				if (this.m.Flags.has("RF_WarcampTileSquareCoords"))
				{
					local coords = ::split(this.m.Flags.get("RF_WarcampTileSquareCoords"), ",");
					this.m.WarcampTile = ::World.getTileSquare(coords[0].tointeger(), coords[1].tointeger());
					this.m.Flags.remove("RF_WarcampTileSquareCoords");
				}
			}

		}.onDeserialize;
	};
});
