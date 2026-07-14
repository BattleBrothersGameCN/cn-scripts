this.rf_random_trio <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.rf_random_trio";
		this.m.Name = "重铸 - 随机三人组";
		this.m.Description = "[p=c][img]gfx/ui/events/event_80.png[/img][/p][p]以随机的开始进入世界，没有任何特殊的优势或劣势。\n\n[color=#bcad8c]随机开始：[/color]以三名随机兄弟开始游戏。\n[color=#bcad8c]天赋过人：[/color]初始角色等级为2，天赋等级都是2星。[/p]";
		this.m.Difficulty = 2;
		this.m.Order = 1;
	}

	function onSpawnAssets()
	{
		local roster = ::World.getPlayerRoster();

		for( local i = 1; i <= 3; i = ++i )
		{
			local bro = roster.create("scripts/entity/tactical/player");
			bro.m.HireTime = ::Time.getVirtualTimeF();
			bro.setPlaceInFormation(i + 2);
			bro.improveMood(1.5, "加入了佣兵团");
			bro.setStartValuesEx(::Const.MV_getHireableCharacterBackgrounds());
			bro.m.Attributes = [];

			for( local i = 0; i < bro.m.Talents.len(); i = ++i )
			{
				if (bro.m.Talents[i] != 0)
				{
					bro.m.Talents[i] = 2;
				}
			}

			bro.fillAttributeLevelUpValues(::Const.XP.MaxLevelWithPerkpoints - 1);
			bro.m.PerkPoints = 1;
			bro.m.LevelUps = 1;
			bro.m.Level = 2;
		}

		::World.Assets.getStash().add(::new("scripts/items/weapons/knife"));
		::World.Assets.getStash().add(::new("scripts/items/weapons/wooden_stick"));
		::World.Assets.getStash().add(::new("scripts/items/shields/wooden_shield_old"));
		::World.Assets.getStash().add(::new("scripts/items/tools/throwing_net"));
		::World.Assets.getStash().add(::new("scripts/items/supplies/ground_grains_item"));
		::World.Assets.getStash().add(::new("scripts/items/supplies/ground_grains_item"));
	}

	function onSpawnPlayer()
	{
		local randomVillage;
		local allSettlements = ::World.EntityManager.getSettlements();

		for( local i = 0; i != allSettlements.len(); i = ++i )
		{
			randomVillage = allSettlements[i];

			if (!randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() >= 3 && !randomVillage.isSouthern())
			{
				break;
			}
		}

		local randomVillageTile = randomVillage.getTile();
		local navSettings = ::World.getNavigator().createSettings();
		navSettings.ActionPointCosts = ::Const.World.TerrainTypeNavCost_Flat;

		while (true)
		{
			local x = ::Math.rand(::Math.max(2, randomVillageTile.SquareCoords.X - 4), ::Math.min(::Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 4));
			local y = ::Math.rand(::Math.max(2, randomVillageTile.SquareCoords.Y - 4), ::Math.min(::Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 4));

			if (::World.isValidTileSquare(x, y))
			{
				local tile = ::World.getTileSquare(x, y);

				if (tile.Type == ::Const.World.TerrainType.Ocean || tile.Type == ::Const.World.TerrainType.Shore || tile.IsOccupied)
				{
					continue;
				}

				for( ; tile.getDistanceTo(randomVillageTile) <= 1;  )
				{
				}

				local path = ::World.getNavigator().findPath(tile, randomVillageTile, navSettings, 0);

				if (!path.isEmpty())
				{
					randomVillageTile = tile;
					break;
				}
			}
		}

		::World.State.m.Player = ::World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		::World.getCamera().setPos(::World.State.m.Player.getPos());
		::Time.scheduleEvent(::TimeUnit.Real, 1000, function ( _tag )
		{
			::Music.setTrackList(::Const.Music.IntroTracks, ::Const.Music.CrossFadeTime);
			::World.Events.fire("event.rf_random_trio_scenario_intro");
		}, null);
	}

});
