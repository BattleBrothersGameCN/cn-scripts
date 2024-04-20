this.send_beast_roamers_action <- this.inherit("scripts/factions/faction_action", {
	m = {
		Options = [],
		BeastsLow = [],
		BeastsMedium = [],
		BeastsHigh = []
	},
	function create()
	{
		this.m.ID = "send_beast_roamers_action";
		this.m.Cooldown = 5.000000;
		this.faction_action.create();
		local distanceToNextAlly = 10;
		local beast;
		beast = function ( _action, _nearTile = null )
		{
			local disallowedTerrain = [];

			if (this.Const.DLC.Unhold)
			{
				for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
				{
					if (i == this.Const.World.TerrainType.Steppe || i == this.Const.World.TerrainType.Plains)
					{
					}
					else
					{
						disallowedTerrain.push(i);
					}
				}
			}
			else
			{
				disallowedTerrain = [
					this.Const.World.TerrainType.Snow,
					this.Const.World.TerrainType.SnowyForest,
					this.Const.World.TerrainType.Forest,
					this.Const.World.TerrainType.LeaveForest,
					this.Const.World.TerrainType.AutumnForest,
					this.Const.World.TerrainType.Desert,
					this.Const.World.TerrainType.Oasis
				];
			}

			local tile = _action.getTileToSpawnLocation(10, disallowedTerrain, 7, 35, 1000, 3, 0, _nearTile, 0.000000, 0.750000);

			if (tile == null)
			{
				return false;
			}

			if (_action.getDistanceToNextAlly(tile) <= distanceToNextAlly / (_nearTile == null ? 1 : 2))
			{
				return false;
			}

			local distanceToNextSettlement = _action.getDistanceToSettlements(tile);
			local party = _action.getFaction().spawnEntity(tile, "食尸鬼", false, this.Const.World.Spawn.Ghouls, this.Math.rand(80, 120) * _action.getScaledDifficultyMult() * this.Math.maxf(0.700000, this.Math.minf(1.500000, distanceToNextSettlement / 14.000000)));
			party.getSprite("banner").setBrush("banner_beasts_01");
			party.setDescription("一群寻觅的食尸鬼");
			party.setFootprintType(this.Const.World.FootprintsType.Ghouls);
			party.setSlowerAtNight(false);
			party.setUsingGlobalVision(false);
			party.setLooting(false);
			local roam = this.new("scripts/ai/world/orders/roam_order");
			roam.setAllTerrainAvailable();
			roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
			roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
			roam.setTerrain(this.Const.World.TerrainType.Shore, false);
			party.getController().addOrder(roam);
			return true;
		};
		this.m.Options.push(beast);
		this.m.BeastsLow.push(beast);
		beast = function ( _action, _nearTile = null )
		{
			local disallowedTerrain = [];

			for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
			{
				if (i == this.Const.World.TerrainType.Forest || i == this.Const.World.TerrainType.SnowyForest || i == this.Const.World.TerrainType.LeaveForest || i == this.Const.World.TerrainType.AutumnForest)
				{
				}
				else
				{
					disallowedTerrain.push(i);
				}
			}

			local tile = _action.getTileToSpawnLocation(10, disallowedTerrain, 7, 50, 1000, 3, 0, _nearTile, 0.200000);

			if (tile == null)
			{
				return false;
			}

			if (_action.getDistanceToNextAlly(tile) <= distanceToNextAlly / (_nearTile == null ? 1 : 2))
			{
				return false;
			}

			local distanceToNextSettlement = _action.getDistanceToSettlements(tile);
			local party = _action.getFaction().spawnEntity(tile, "恐狼", false, this.Const.World.Spawn.Direwolves, this.Math.rand(80, 120) * _action.getScaledDifficultyMult() * this.Math.maxf(0.700000, this.Math.minf(1.500000, distanceToNextSettlement / 14.000000)));
			party.getSprite("banner").setBrush("banner_beasts_01");
			party.setDescription("一群寻找猎物的凶猛恐狼。");
			party.setFootprintType(this.Const.World.FootprintsType.Direwolves);
			party.setSlowerAtNight(false);
			party.setUsingGlobalVision(false);
			party.setLooting(false);
			local roam = this.new("scripts/ai/world/orders/roam_order");
			roam.setNoTerrainAvailable();
			roam.setTerrain(this.Const.World.TerrainType.Forest, true);
			roam.setTerrain(this.Const.World.TerrainType.SnowyForest, true);
			roam.setTerrain(this.Const.World.TerrainType.LeaveForest, true);
			roam.setTerrain(this.Const.World.TerrainType.AutumnForest, true);
			roam.setTerrain(this.Const.World.TerrainType.Hills, true);
			party.getController().addOrder(roam);
			return true;
		};
		this.m.Options.push(beast);
		this.m.BeastsLow.push(beast);

		if (this.Const.DLC.Desert)
		{
			beast = function ( _action, _nearTile = null )
			{
				local disallowedTerrain = [];

				for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
				{
					if (i == this.Const.World.TerrainType.Desert || i == this.Const.World.TerrainType.Oasis || i == this.Const.World.TerrainType.Hills)
					{
					}
					else
					{
						disallowedTerrain.push(i);
					}
				}

				local tile = _action.getTileToSpawnLocation(10, disallowedTerrain, 7, 50, 1000, 3, 0, _nearTile, 0.000000, 0.200000);

				if (tile == null)
				{
					return false;
				}

				if (_action.getDistanceToNextAlly(tile) <= distanceToNextAlly / (_nearTile == null ? 1 : 2))
				{
					return false;
				}

				local distanceToNextSettlement = _action.getDistanceToSettlements(tile);
				local party = _action.getFaction().spawnEntity(tile, "鬣狗", false, this.Const.World.Spawn.Hyenas, this.Math.rand(80, 120) * _action.getScaledDifficultyMult() * this.Math.maxf(0.700000, this.Math.minf(1.500000, distanceToNextSettlement / 14.000000)));
				party.getSprite("banner").setBrush("banner_beasts_01");
				party.setDescription("一群贪婪的鬣狗在捕猎猎物。");
				party.setFootprintType(this.Const.World.FootprintsType.Hyenas);
				party.setSlowerAtNight(false);
				party.setUsingGlobalVision(false);
				party.setLooting(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setNoTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Desert, true);
				roam.setTerrain(this.Const.World.TerrainType.Oasis, true);
				roam.setTerrain(this.Const.World.TerrainType.Steppe, true);
				roam.setTerrain(this.Const.World.TerrainType.Hills, true);
				party.getController().addOrder(roam);
				return true;
			};
			this.m.Options.push(beast);
			beast = function ( _action, _nearTile = null )
			{
				if (this.World.getTime().Days < 15 && _nearTile == null)
				{
					return false;
				}

				local disallowedTerrain = [];

				for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
				{
					if (i == this.Const.World.TerrainType.Desert || i == this.Const.World.TerrainType.Oasis)
					{
					}
					else
					{
						disallowedTerrain.push(i);
					}
				}

				local tile = _action.getTileToSpawnLocation(10, disallowedTerrain, 7, 50, 1000, 3, 0, _nearTile, 0.000000, 0.200000);

				if (tile == null)
				{
					return false;
				}

				if (_action.getDistanceToNextAlly(tile) <= distanceToNextAlly / (_nearTile == null ? 1 : 2))
				{
					return false;
				}

				local distanceToNextSettlement = _action.getDistanceToSettlements(tile);
				local party = _action.getFaction().spawnEntity(tile, "大蛇", false, this.Const.World.Spawn.Serpents, this.Math.rand(80, 120) * _action.getScaledDifficultyMult() * this.Math.maxf(0.700000, this.Math.minf(1.500000, distanceToNextSettlement / 14.000000)));
				party.getSprite("banner").setBrush("banner_beasts_01");
				party.setDescription("巨大的蛇在游荡。");
				party.setFootprintType(this.Const.World.FootprintsType.Serpents);
				party.setSlowerAtNight(false);
				party.setUsingGlobalVision(false);
				party.setLooting(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setNoTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Desert, true);
				roam.setTerrain(this.Const.World.TerrainType.Oasis, true);
				roam.setTerrain(this.Const.World.TerrainType.Steppe, true);
				roam.setTerrain(this.Const.World.TerrainType.Hills, true);
				party.getController().addOrder(roam);
				return true;
			};
			this.m.Options.push(beast);
		}

		if (this.Const.DLC.Unhold)
		{
			beast = function ( _action, _nearTile = null )
			{
				local disallowedTerrain = [];

				for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
				{
					if (i == this.Const.World.TerrainType.Forest || i == this.Const.World.TerrainType.LeaveForest || i == this.Const.World.TerrainType.AutumnForest)
					{
					}
					else
					{
						disallowedTerrain.push(i);
					}
				}

				local tile = _action.getTileToSpawnLocation(10, disallowedTerrain, 7, 40, 1000, 3, 0, _nearTile, this.Const.DLC.Desert ? 0.200000 : 0.100000, 0.800000);

				if (tile == null)
				{
					return false;
				}

				if (_action.getDistanceToNextAlly(tile) <= distanceToNextAlly / (_nearTile == null ? 1 : 2))
				{
					return false;
				}

				local distanceToNextSettlement = _action.getDistanceToSettlements(tile);
				local party = _action.getFaction().spawnEntity(tile, "蛛魔", false, this.Const.World.Spawn.Spiders, this.Math.rand(80, 120) * _action.getScaledDifficultyMult() * this.Math.maxf(0.700000, this.Math.minf(1.500000, distanceToNextSettlement / 14.000000)));
				party.getSprite("banner").setBrush("banner_beasts_01");
				party.setDescription("一群蛛魔在游荡。");
				party.setFootprintType(this.Const.World.FootprintsType.Spiders);
				party.setSlowerAtNight(false);
				party.setUsingGlobalVision(false);
				party.setLooting(false);
				party.getFlags().set("IsWebknechts", true);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setNoTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Forest, true);
				roam.setTerrain(this.Const.World.TerrainType.LeaveForest, true);
				roam.setTerrain(this.Const.World.TerrainType.AutumnForest, true);
				roam.setMinRange(1);
				roam.setMaxRange(4);
				party.getController().addOrder(roam);
				return true;
			};
			this.m.Options.push(beast);
			this.m.BeastsLow.push(beast);
			beast = function ( _action, _nearTile = null )
			{
				if (this.World.getTime().Days < 10 && _nearTile == null)
				{
					return false;
				}

				local disallowedTerrain = [];

				for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
				{
					if (i == this.Const.World.TerrainType.Tundra || i == this.Const.World.TerrainType.Hills || i == this.Const.World.TerrainType.Mountains)
					{
					}
					else
					{
						disallowedTerrain.push(i);
					}
				}

				local tile = _action.getTileToSpawnLocation(10, disallowedTerrain, 10 - (_nearTile == null ? 0 : 2), 100, 1000, 3, 0, _nearTile, 0.000000, 0.900000);

				if (tile == null)
				{
					return false;
				}

				if (_action.getDistanceToNextAlly(tile) <= distanceToNextAlly / (_nearTile == null ? 1 : 2))
				{
					return false;
				}

				local distanceToNextSettlement = _action.getDistanceToSettlements(tile);
				local party = _action.getFaction().spawnEntity(tile, "巨魔", false, this.Const.World.Spawn.Unhold, this.Math.rand(80, 120) * _action.getScaledDifficultyMult() * this.Math.maxf(0.700000, this.Math.minf(1.500000, distanceToNextSettlement / 14.000000)));
				party.getSprite("banner").setBrush("banner_beasts_01");
				party.setDescription("一个或多个笨拙的巨人。");
				party.setFootprintType(this.Const.World.FootprintsType.Unholds);
				party.setSlowerAtNight(true);
				party.setUsingGlobalVision(false);
				party.setLooting(false);
				party.getFlags().set("IsUnholds", true);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setNoTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Forest, true);
				roam.setTerrain(this.Const.World.TerrainType.Hills, true);
				roam.setTerrain(this.Const.World.TerrainType.Tundra, true);
				roam.setTerrain(this.Const.World.TerrainType.Mountains, true);
				party.getController().addOrder(roam);
				return true;
			};
			this.m.Options.push(beast);
			this.m.BeastsMedium.push(beast);
			beast = function ( _action, _nearTile = null )
			{
				if (this.World.getTime().Days < 10 && _nearTile == null)
				{
					return false;
				}

				local isTundraAllowed = this.Math.rand(1, 100) <= 20;
				local disallowedTerrain = [];

				for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
				{
					if (i == this.Const.World.TerrainType.Snow || i == this.Const.World.TerrainType.SnowyForest || i == this.Const.World.TerrainType.Tundra && isTundraAllowed)
					{
					}
					else
					{
						disallowedTerrain.push(i);
					}
				}

				local tile = _action.getTileToSpawnLocation(10, disallowedTerrain, 5, 100, 1000, 3, 0, _nearTile, 0.700000);

				if (tile == null)
				{
					return false;
				}

				if (_action.getDistanceToNextAlly(tile) <= distanceToNextAlly / (_nearTile == null ? 1 : 2))
				{
					return false;
				}

				local distanceToNextSettlement = _action.getDistanceToSettlements(tile);
				local party = _action.getFaction().spawnEntity(tile, "巨魔", false, this.Const.World.Spawn.UnholdFrost, this.Math.rand(80, 120) * _action.getScaledDifficultyMult() * this.Math.maxf(0.700000, this.Math.minf(1.500000, distanceToNextSettlement / 14.000000)));
				party.getSprite("banner").setBrush("banner_beasts_01");
				party.setDescription("一个或多个笨拙的巨人。");
				party.setFootprintType(this.Const.World.FootprintsType.Unholds);
				party.setSlowerAtNight(true);
				party.setUsingGlobalVision(false);
				party.setLooting(false);
				party.getFlags().set("IsUnholds", true);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setNoTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Snow, true);
				roam.setTerrain(this.Const.World.TerrainType.SnowyForest, true);
				roam.setTerrain(this.Const.World.TerrainType.Hills, true);

				if (isTundraAllowed)
				{
					roam.setTerrain(this.Const.World.TerrainType.Tundra, true);
				}

				party.getController().addOrder(roam);
				return true;
			};
			this.m.Options.push(beast);
			this.m.BeastsMedium.push(beast);
			beast = function ( _action, _nearTile = null )
			{
				if (this.World.getTime().Days < 10 && _nearTile == null)
				{
					return false;
				}

				local disallowedTerrain = [];

				for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
				{
					if (i == this.Const.World.TerrainType.Swamp || i == this.Const.World.TerrainType.LeaveForest || i == this.Const.World.TerrainType.Oasis)
					{
					}
					else
					{
						disallowedTerrain.push(i);
					}
				}

				local tile = _action.getTileToSpawnLocation(10, disallowedTerrain, 10 - (_nearTile == null ? 0 : 2), 100, 1000, 3, 0, _nearTile);

				if (tile == null)
				{
					return false;
				}

				if (_action.getDistanceToNextAlly(tile) <= distanceToNextAlly / (_nearTile == null ? 1 : 2))
				{
					return false;
				}

				local distanceToNextSettlement = _action.getDistanceToSettlements(tile);
				local party = _action.getFaction().spawnEntity(tile, "巨魔", false, this.Const.World.Spawn.UnholdBog, this.Math.rand(80, 120) * _action.getScaledDifficultyMult() * this.Math.maxf(0.700000, this.Math.minf(1.500000, distanceToNextSettlement / 14.000000)));
				party.getSprite("banner").setBrush("banner_beasts_01");
				party.setDescription("一个或多个笨拙的巨人。");
				party.setFootprintType(this.Const.World.FootprintsType.Unholds);
				party.setSlowerAtNight(true);
				party.setUsingGlobalVision(false);
				party.setLooting(false);
				party.getFlags().set("IsUnholds", true);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setNoTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Swamp, true);
				roam.setTerrain(this.Const.World.TerrainType.LeaveForest, true);
				party.getController().addOrder(roam);
				return true;
			};
			this.m.Options.push(beast);
			this.m.BeastsMedium.push(beast);
			beast = function ( _action, _nearTile = null )
			{
				if (_nearTile == null && this.Math.rand(1, 100) <= 25)
				{
					return false;
				}

				if (this.World.getTime().Days < 15 && _nearTile == null)
				{
					return false;
				}

				local tile = _action.getTileToSpawnLocation(10, [
					this.Const.World.TerrainType.Mountains,
					this.Const.World.TerrainType.Forest,
					this.Const.World.TerrainType.LeaveForest,
					this.Const.World.TerrainType.AutumnForest,
					this.Const.World.TerrainType.SnowyForest,
					this.Const.World.TerrainType.Swamp,
					this.Const.World.TerrainType.Hills
				], 7, 35, 1000, 3, 0, _nearTile);

				if (tile == null)
				{
					return false;
				}

				if (_action.getDistanceToNextAlly(tile) <= distanceToNextAlly / (_nearTile == null ? 1 : 2))
				{
					return false;
				}

				local distanceToNextSettlement = _action.getDistanceToSettlements(tile);
				local party = _action.getFaction().spawnEntity(tile, "梦魇", false, this.Const.World.Spawn.Alps, this.Math.rand(80, 120) * _action.getScaledDifficultyMult() * this.Math.maxf(0.700000, this.Math.minf(1.500000, distanceToNextSettlement / 14.000000)));
				party.getSprite("banner").setBrush("banner_beasts_01");
				party.setDescription("苍白而憔悴的生物在四处爬行。");
				party.setFootprintType(this.Const.World.FootprintsType.Alps);
				party.setSlowerAtNight(false);
				party.setUsingGlobalVision(false);
				party.setLooting(false);
				party.getFlags().set("IsAlps", true);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setAllTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
				roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
				roam.setTerrain(this.Const.World.TerrainType.Shore, false);
				party.getController().addOrder(roam);
				return true;
			};
			this.m.Options.push(beast);
			this.m.BeastsMedium.push(beast);
			beast = function ( _action, _nearTile = null )
			{
				if (this.World.getTime().Days < 20 && _nearTile == null)
				{
					return false;
				}

				if (_nearTile == null && this.Math.rand(1, 100) <= 10)
				{
					return false;
				}

				local tile = _action.getTileToSpawnLocation(10, [
					this.Const.World.TerrainType.Mountains,
					this.Const.World.TerrainType.Hills,
					this.Const.World.TerrainType.Snow,
					this.Const.World.TerrainType.SnowyForest,
					this.Const.World.TerrainType.Desert,
					this.Const.World.TerrainType.Oasis
				], 8, 50, 1000, 3, 0, _nearTile, 0.100000, 0.900000);

				if (tile == null)
				{
					return false;
				}

				if (_action.getDistanceToNextAlly(tile) <= distanceToNextAlly / (_nearTile == null ? 1 : 2))
				{
					return false;
				}

				local distanceToNextSettlement = _action.getDistanceToSettlements(tile);
				local party = _action.getFaction().spawnEntity(tile, "女巫", false, this.Const.World.Spawn.HexenAndMore, this.Math.rand(80, 120) * _action.getScaledDifficultyMult() * this.Math.maxf(0.700000, this.Math.minf(1.500000, distanceToNextSettlement / 14.000000)));
				party.getSprite("banner").setBrush("banner_beasts_01");
				party.setDescription("一个恶毒的老太婆，据说引诱和诱拐小孩子来做肉汤和调料，与村民签订邪恶的契约，并编织诅咒。");
				party.setFootprintType(this.Const.World.FootprintsType.Hexen);
				party.setSlowerAtNight(false);
				party.setUsingGlobalVision(false);
				party.setLooting(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setAllTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
				roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
				roam.setTerrain(this.Const.World.TerrainType.Shore, false);
				party.getController().addOrder(roam);
				return true;
			};
			this.m.Options.push(beast);
			this.m.BeastsMedium.push(beast);
			beast = function ( _action, _nearTile = null )
			{
				if (this.World.getTime().Days < 25 && _nearTile == null)
				{
					return false;
				}

				local disallowedTerrain = [];

				for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
				{
					if (i == this.Const.World.TerrainType.Forest || i == this.Const.World.TerrainType.LeaveForest || i == this.Const.World.TerrainType.AutumnForest)
					{
					}
					else
					{
						disallowedTerrain.push(i);
					}
				}

				local tile = _action.getTileToSpawnLocation(10, disallowedTerrain, 20 - (_nearTile == null ? 0 : 11), 100, 1000, 3, 0, _nearTile, 0.100000, 0.900000);

				if (tile == null)
				{
					return false;
				}

				if (_action.getDistanceToNextAlly(tile) <= distanceToNextAlly / (_nearTile == null ? 1 : 2))
				{
					return false;
				}

				local distanceToNextSettlement = _action.getDistanceToSettlements(tile);
				local party = _action.getFaction().spawnEntity(tile, "树人", false, this.Const.World.Spawn.Schrats, this.Math.rand(80, 120) * _action.getScaledDifficultyMult() * this.Math.maxf(0.700000, this.Math.minf(1.500000, distanceToNextSettlement / 14.000000)));
				party.getSprite("banner").setBrush("banner_beasts_01");
				party.setDescription("一种树皮和木头的生物，混迹于树间，缓慢地蹒跚而行，它的根在土壤中挖掘。");
				party.setFootprintType(this.Const.World.FootprintsType.Schrats);
				party.setSlowerAtNight(false);
				party.setUsingGlobalVision(false);
				party.setLooting(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setNoTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Forest, true);
				roam.setTerrain(this.Const.World.TerrainType.LeaveForest, true);
				roam.setTerrain(this.Const.World.TerrainType.AutumnForest, true);
				roam.setMinRange(1);
				roam.setMaxRange(4);
				party.getController().addOrder(roam);
				return true;
			};
			this.m.Options.push(beast);
			this.m.BeastsHigh.push(beast);
			beast = function ( _action, _nearTile = null )
			{
				if (!this.World.Flags.get("IsKrakenDefeated"))
				{
					return false;
				}

				local disallowedTerrain = [];

				for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
				{
					if (i == this.Const.World.TerrainType.Swamp)
					{
					}
					else
					{
						disallowedTerrain.push(i);
					}
				}

				local tile = _action.getTileToSpawnLocation(10, disallowedTerrain, 25, 1000, 1000, 3, 0, _nearTile);

				if (tile == null)
				{
					return false;
				}

				if (_action.getDistanceToNextAlly(tile) <= distanceToNextAlly)
				{
					return false;
				}

				local distanceToNextSettlement = _action.getDistanceToSettlements(tile);
				local party = _action.getFaction().spawnEntity(tile, "克拉肯", false, this.Const.World.Spawn.Kraken, 1000);
				party.getSprite("banner").setBrush("banner_beasts_01");
				party.setDescription("来自另一个时代的有触角的恐怖生物。");
				party.setFootprintType(this.Const.World.FootprintsType.Kraken);
				party.setSlowerAtNight(true);
				party.setUsingGlobalVision(false);
				party.setLooting(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setNoTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Swamp, true);
				party.getController().addOrder(roam);
				return true;
			};
			this.m.Options.push(beast);
		}

		if (this.Const.DLC.Desert)
		{
			beast = function ( _action, _nearTile = null )
			{
				if (this.World.getTime().Days < 20 && _nearTile == null)
				{
					return false;
				}

				local disallowedTerrain = [];

				for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
				{
					if (i == this.Const.World.TerrainType.Desert || i == this.Const.World.TerrainType.Oasis || i == this.Const.World.TerrainType.Hills)
					{
					}
					else
					{
						disallowedTerrain.push(i);
					}
				}

				local tile = _action.getTileToSpawnLocation(10, disallowedTerrain, 16 - (_nearTile == null ? 0 : 10), 100, 1000, 3, 0, _nearTile, 0.000000, 0.200000);

				if (tile == null)
				{
					return false;
				}

				if (_action.getDistanceToNextAlly(tile) <= distanceToNextAlly / (_nearTile == null ? 1 : 2))
				{
					return false;
				}

				local distanceToNextSettlement = _action.getDistanceToSettlements(tile);
				local party = _action.getFaction().spawnEntity(tile, "伊夫利特", false, this.Const.World.Spawn.SandGolems, this.Math.rand(80, 120) * _action.getScaledDifficultyMult() * this.Math.maxf(0.700000, this.Math.minf(1.500000, distanceToNextSettlement / 14.000000)));
				party.getSprite("banner").setBrush("banner_beasts_01");
				party.setDescription("活生生的石头制成的生物，由南方烈日的酷热和烈火塑造而成。");
				party.setFootprintType(this.Const.World.FootprintsType.SandGolems);
				party.setSlowerAtNight(false);
				party.setUsingGlobalVision(false);
				party.setLooting(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setNoTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Desert, true);
				roam.setTerrain(this.Const.World.TerrainType.Oasis, true);
				roam.setTerrain(this.Const.World.TerrainType.Hills, true);
				party.getController().addOrder(roam);
				return true;
			};
			this.m.Options.push(beast);
		}

		if (this.Const.DLC.Lindwurm)
		{
			beast = function ( _action, _nearTile = null )
			{
				if (this.World.getTime().Days < 25 && _nearTile == null)
				{
					return false;
				}

				local disallowedTerrain = [];

				for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
				{
					if (i == this.Const.World.TerrainType.Steppe || i == this.Const.World.TerrainType.Desert)
					{
					}
					else
					{
						disallowedTerrain.push(i);
					}
				}

				local tile = _action.getTileToSpawnLocation(10, disallowedTerrain, 18 - (_nearTile == null ? 0 : 10), 100, 1000, 3, 0, _nearTile, this.Const.DLC.Desert ? 0.100000 : 0.000000, 0.500000);

				if (tile == null)
				{
					return false;
				}

				if (_action.getDistanceToNextAlly(tile) <= distanceToNextAlly / (_nearTile == null ? 1 : 2))
				{
					return false;
				}

				local distanceToNextSettlement = _action.getDistanceToSettlements(tile);
				local party = _action.getFaction().spawnEntity(tile, "林德蠕龙", false, this.Const.World.Spawn.Lindwurm, this.Math.rand(80, 120) * _action.getScaledDifficultyMult() * this.Math.maxf(0.700000, this.Math.minf(1.500000, distanceToNextSettlement / 14.000000)));
				party.getSprite("banner").setBrush("banner_beasts_01");
				party.setDescription("一条林德蠕龙 —— 一种无翼双足龙，形似巨蛇。");
				party.setFootprintType(this.Const.World.FootprintsType.Lindwurms);
				party.setSlowerAtNight(false);
				party.setUsingGlobalVision(false);
				party.setLooting(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setNoTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Forest, true);
				roam.setTerrain(this.Const.World.TerrainType.LeaveForest, true);
				roam.setTerrain(this.Const.World.TerrainType.AutumnForest, true);
				roam.setTerrain(this.Const.World.TerrainType.Desert, true);
				roam.setTerrain(this.Const.World.TerrainType.Steppe, true);
				party.getController().addOrder(roam);
				return true;
			};
			this.m.Options.push(beast);
			this.m.BeastsHigh.push(beast);
		}
	}

	function onUpdate( _faction )
	{
		foreach( u in _faction.getUnits() )
		{
			if (!u.isDiscovered() && this.Time.getVirtualTimeF() - u.getSpawnTime() >= 20.000000 * this.World.getTime().SecondsPerDay && !u.getSprite("selection").Visible && (this.World.State.getPlayer() == null || this.World.State.getPlayer().getTile().getDistanceTo(u.getTile()) >= 8))
			{
				u.die();
				break;
			}
		}

		if (_faction.getUnits().len() >= 15 + (this.Const.DLC.Desert ? 3 : 0))
		{
			return;
		}

		this.m.Score = 10;
	}

	function onClear()
	{
	}

	function onExecute( _faction )
	{
		local r = this.Math.rand(0, this.m.Options.len() - 1);

		if (this.World.getTime().Days <= 9)
		{
			local r_max = 1;

			if (this.Const.DLC.Desert)
			{
				r_max = r_max + 2;
			}

			if (this.Const.DLC.Unhold)
			{
				r_max = r_max + 1;
			}

			r = this.Math.rand(0, r_max);
		}

		for( local i = 0; i < 15 - _faction.getUnits().len(); i = ++i )
		{
			if (this.m.Options[r](this))
			{
				this.m.Cooldown = 5.000000;
				break;
			}
			else
			{
				this.m.Cooldown = 0.000000;
			}
		}
	}

});
