::Reforged.HooksMod.hook("scripts/entity/world/settlements/buildings/tavern_building", function ( q )
{
	q.getRumor = function ( __original )
	{
		return {
			function getRumor( _isPaidFor = false )
			{
				local lastRumor = this.m.LastRumor;
				::Reforged.__IsDuringGetRumor = true;
				local ret = __original(_isPaidFor);
				::Reforged.__IsDuringGetRumor = false;

				if (this.m.RumorsGiven > 3)
				{
					return ret;
				}

				if (ret == null)
				{
					return ret;
				}

				if (ret == lastRumor)
				{
					return ret;
				}

				local r = ::World.Assets.m.IsNonFlavorRumorsOnly ? ::Math.rand(1, 5) : ::Math.rand(1, 7);

				if (r != 1)
				{
					return ret;
				}

				local bestLocation = this.getLegendaryLocationForRumor();

				if (bestLocation == null)
				{
					return ret;
				}

				this.m.Location = ::WeakTableRef(bestLocation);
				local candidates = ::Const.Strings.RumorsUniqueLocation[::Math.rand(0, 1)];
				local rumor = "";

				if (_isPaidFor)
				{
					rumor = ::MSU.Array.rand(::Const.Strings.PayTavernRumorsIntro);
				}
				else
				{
					rumor = "客人们谈天说地。";
				}

				rumor = rumor + "\n\n[color=#bcad8c]\"";
				rumor = rumor + ::MSU.Array.rand(candidates);
				rumor = rumor + "\"[/color]\n\n";
				rumor = this.buildText(rumor);
				this.m.LastRumor = rumor;
				return rumor;
			}

		}.getRumor;
	};
	q.buildText = function ( __original )
	{
		return {
			function buildText( _text )
			{
				local buildTextFromTemplate = ::buildTextFromTemplate;
				::buildTextFromTemplate = function ( _text, _vars )
				{
					this.adjustVars(_vars);
					return buildTextFromTemplate(_text, _vars);
				};
				local ret = __original(_text);
				::buildTextFromTemplate = buildTextFromTemplate;
				return ret;
			}

		}.buildText;
	};
	q.getLegendaryLocationForRumor <- {
		function getLegendaryLocationForRumor()
		{
			local bestLocation;
			local bestDist = 9000;

			foreach( s in ::World.EntityManager.getLocations() )
			{
				if (s.isLocationType(::Const.World.LocationType.Unique) == false)
				{
					continue;
				}

				if (s.isDiscovered())
				{
					continue;
				}

				if (s.getVisibilityMult() == 0.0)
				{
					continue;
				}

				local d = s.getTile().getDistanceTo(this.m.Settlement.getTile()) - ::Math.rand(1, 10);

				if (d > bestDist)
				{
					continue;
				}

				bestDist = d;
				bestLocation = s;
			}

			return bestLocation;
		}

	}.getLegendaryLocationForRumor;
	q.adjustVars <- {
		function adjustVars( _vars )
		{
			foreach( var in _vars )
			{
				if (var[0] == "distance")
				{
					local wrongDistances = ::Const.Strings.Distance.filter(function ( _idx, _val )
					{
						return _val != var[1];
					});
					_vars.push([
						"wrongDistance",
						::MSU.Array.rand(wrongDistances)
					]);
				}
				else if (var[0] == "direction")
				{
					local wrongDirections = ::Const.Strings.Direction8.filter(function ( _idx, _val )
					{
						return _val != var[1];
					});
					_vars.push([
						"wrongDirection",
						::MSU.Array.rand(wrongDirections)
					]);
				}
				else if (var[0] == "terrain")
				{
					local wrongTerrains = ::Const.Strings.Terrain.filter(function ( _idx, _val )
					{
						return _val != var[1] && _val != "";
					});
					_vars.push([
						"wrongTerrain",
						::MSU.Array.rand(wrongTerrains)
					]);
				}
			}

			  // [072]  OP_CLOSE          0      2    0    0
			_vars.push([
				"legendaryLocationAdjective",
				::MSU.Array.rand(::Const.Strings.LegendaryLocationAdjective)
			]);
		}

	}.adjustVars;
});
