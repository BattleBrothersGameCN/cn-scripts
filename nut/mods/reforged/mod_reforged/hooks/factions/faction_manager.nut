::Reforged.HooksMod.hook("scripts/factions/faction_manager", function ( q )
{
	q.RF_createDraugr <- {
		function RF_createDraugr()
		{
			local f = ::new("scripts/factions/rf_draugr_faction");
			f.setID(this.m.Factions.len());
			f.setName("Barrowkin");
			f.setDiscovered(true);
			f.addTrait(::Const.FactionTrait.RF_Draugr);
			this.m.Factions.push(f);
		}

	}.RF_createDraugr;
	q.createNobleHouses = function ( __original )
	{
		return {
			function createNobleHouses()
			{
				local oldMathRand = ::Math.rand;
				::Math.rand = function ( _min, _max )
				{
					if (_min == 2 && _max == 10)
					{
						_min = 1;
					}

					return oldMathRand(_min, _max);
				};
				local ret = __original();
				::Math.rand = oldMathRand;
				return ret;
			}

		}.createNobleHouses;
	};
	q.createAlliances = function ( __original )
	{
		return {
			function createAlliances()
			{
				this.RF_createDraugr();
				__original();
			}

		}.createAlliances;
	};
	q.runSimulation = function ( __original )
	{
		return {
			function runSimulation()
			{
				local draugr = this.getFactionOfType(::Const.FactionType.RF_Draugr);
				local ping = this.__ping;
				this.__ping = function ()
				{
					draugr.update(true, true);
					ping();
				};
				__original();
				this.__ping = ping;
			}

		}.runSimulation;
	};
});
