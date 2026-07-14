::Reforged.HooksMod.hook("scripts/entity/world/locations/legendary/black_monolith_location", function ( q )
{
	q.m.NumTroopsMax <- 47;
	q.m.NumTroopsToRecoverBeforeCombat <- 6;
	q.onSpawned = function ()
	{
		return {
			function onSpawned()
			{
				this.m.Name = "黑色巨石";
				this.location.onSpawned();
				local troops = [
					[
						3,
						::Const.World.Spawn.Troops.RF_SkeletonDecanus
					],
					[
						7,
						::Const.World.Spawn.Troops.RF_SkeletonMediumElite
					],
					[
						3,
						::Const.World.Spawn.Troops.SkeletonMedium
					],
					[
						3,
						::Const.World.Spawn.Troops.RF_SkeletonMediumElitePolearm
					],
					[
						2,
						::Const.World.Spawn.Troops.RF_SkeletonCenturion
					],
					[
						2,
						::Const.World.Spawn.Troops.RF_SkeletonMediumElitePolearm
					],
					[
						3,
						::Const.World.Spawn.Troops.SkeletonMediumPolearm
					],
					[
						1,
						::Const.World.Spawn.Troops.RF_SkeletonLegatus
					],
					[
						6,
						::Const.World.Spawn.Troops.Vampire
					],
					[
						1,
						::Const.World.Spawn.Troops.RF_VampireLord
					],
					[
						2,
						::Const.World.Spawn.Troops.RF_SkeletonHeavyEliteBodyguard
					],
					[
						3,
						::Const.World.Spawn.Troops.SkeletonHeavyBodyguard
					],
					[
						2,
						::Const.World.Spawn.Troops.RF_SkeletonHeavyElite
					],
					[
						5,
						::Const.World.Spawn.Troops.SkeletonHeavy
					],
					[
						1,
						::Const.World.Spawn.Troops.SkeletonBoss
					],
					[
						3,
						::Const.World.Spawn.Troops.SkeletonPriest
					]
				];

				foreach( entry in troops )
				{
					local num = entry[0];
					local troop = entry[1];

					for( local i = 0; i < num; i++ )
					{
						::Const.World.Common.addTroop(this, {
							Type = troop
						}, false);
					}
				}
			}

		}.onSpawned;
	};
	q.onBeforeCombatStarted = function ()
	{
		return {
			function onBeforeCombatStarted()
			{
				this.location.onBeforeCombatStarted();

				if (this.m.Troops.len() == this.m.NumTroopsMax || this.m.NumTroopsToRecoverBeforeCombat == 0)
				{
					return;
				}

				local pool = this.getTroopRecoveryPool();

				if (pool.len() == 0)
				{
					return;
				}

				for( local i = 0; i < this.m.NumTroopsToRecoverBeforeCombat && this.m.Troops.len() <= this.m.NumTroopsMax; i++ )
				{
					local type = pool.roll();

					if (type == ::Const.World.Spawn.Troops.RF_SkeletonDecanus || ::Const.World.Spawn.Troops.RF_SkeletonCenturion || ::Const.World.Spawn.Troops.RF_SkeletonLegatus || ::Const.World.Spawn.Troops.RF_VampireLord)
					{
						pool.setWeight(type, pool.getWeight(type) - 1);
					}

					::Const.World.Common.addTroop(this, {
						Type = type
					}, false);
				}
			}

		}.onBeforeCombatStarted;
	};
	q.getTroopRecoveryPool <- {
		function getTroopRecoveryPool()
		{
			local pool = ::MSU.Class.WeightedContainer().addMany(1, [
				::Const.World.Spawn.Troops.SkeletonMedium,
				::Const.World.Spawn.Troops.SkeletonMediumPolearm,
				::Const.World.Spawn.Troops.RF_SkeletonMediumElite,
				::Const.World.Spawn.Troops.RF_SkeletonMediumElitePolearm,
				::Const.World.Spawn.Troops.RF_SkeletonHeavyLesser,
				::Const.World.Spawn.Troops.SkeletonHeavy,
				::Const.World.Spawn.Troops.SkeletonPriest,
				::Const.World.Spawn.Troops.Vampire
			]);
			local addToPoolIfFewerThan = function ( _troopType, _count )
			{
				local numPresent = 0;

				foreach( t in this.getTroops() )
				{
					if (t.Script == _troopType.Script)
					{
						numPresent++;
					}
				}

				if (numPresent < _count)
				{
					pool.add(_troopType, _count - numPresent);
				}
			};
			addToPoolIfFewerThan(::Const.World.Spawn.Troops.RF_SkeletonDecanus, 3);
			addToPoolIfFewerThan(::Const.World.Spawn.Troops.RF_SkeletonCenturion, 2);
			addToPoolIfFewerThan(::Const.World.Spawn.Troops.RF_SkeletonLegatus, 1);
			addToPoolIfFewerThan(::Const.World.Spawn.Troops.RF_VampireLord, 1);
			return pool;
		}

	}.getTroopRecoveryPool;
});
