this.raiders_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.raiders";
		this.m.Name = "北方掠夺者";
		this.m.Description = "[p=c][img]gfx/ui/events/event_139.png[/img][/p][p]在你的成年生活中，你一直在这片土地上掠夺和抢劫。 但是，如果当地的农民穷得像老鼠一样，你可能最终想要扩大到佣兵工作的盈利领域，也就是说，如果你的潜在雇主愿意原谅你过去的违法行为。\n\n[color=#bcad8c]战团：[/color] 从三个有经验的野蛮人开始。\n[color=#bcad8c]抢劫者：[/color] 你有更高的几率从被杀死的敌人那里得到任何物品作为战利品。\n[color=#bcad8c]不法之徒：[/color] 从与大多数人类派别的坏关系开始。[/p]";
		this.m.Difficulty = 2;
		this.m.Order = 60;
	}

	function isValid()
	{
		return this.Const.DLC.Wildmen;
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();

		for( local i = 0; i < 4; i = ++i )
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.m.HireTime = this.Time.getVirtualTimeF();
		}

		local bros = roster.getAll();
		bros[0].setStartValuesEx([
			"barbarian_background"
		]);
		bros[0].getBackground().m.RawDescription = "一个强壮的战士，%name% 经历过多次的掠夺和抢劫。 虽然一个寡言的人，掠夺者在战斗中绝对是一个邪恶的样本。 即使对一个掠袭者来说，他对被击败的村民所做的事也让很多人恼火。 很可能他跟你来是为了满足他的虐待欲。";
		bros[0].improveMood(1.000000, "一次成功的掠夺");
		bros[0].setPlaceInFormation(3);
		bros[0].m.PerkPoints = 2;
		bros[0].m.LevelUps = 2;
		bros[0].m.Level = 3;
		bros[0].m.Talents = [];
		local talents = bros[0].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.MeleeSkill] = 2;
		talents[this.Const.Attributes.Hitpoints] = 2;
		talents[this.Const.Attributes.Fatigue] = 1;
		local items = bros[0].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Body));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Head));
		local warhound = this.new("scripts/items/accessory/warhound_item");
		warhound.m.Name = "芬里尔战獒";
		items.equip(warhound);
		items.equip(this.new("scripts/items/armor/barbarians/reinforced_animal_hide_armor"));
		items.equip(this.new("scripts/items/helmets/barbarians/bear_headpiece"));
		bros[1].setStartValuesEx([
			"barbarian_background"
		]);
		bros[1].getBackground().m.RawDescription = "%name% 是一个男孩，从南方的一个村庄被带走，在荒野的野蛮人中长大。 虽然他学习了当地的语言和文化，但他始终无法融入当地，经常成为残酷玩笑和游戏的受害者。 你不确定他着你是为了回家还是为了离开他在北方的“家人”。";
		bros[1].improveMood(1.000000, "一次成功的掠夺");
		bros[1].setPlaceInFormation(4);
		bros[1].m.PerkPoints = 2;
		bros[1].m.LevelUps = 2;
		bros[1].m.Level = 3;
		bros[1].m.Talents = [];
		local talents = bros[1].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.MeleeSkill] = 2;
		talents[this.Const.Attributes.Hitpoints] = 1;
		talents[this.Const.Attributes.Fatigue] = 2;
		local items = bros[1].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Body));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Head));
		items.equip(this.new("scripts/items/armor/barbarians/scrap_metal_armor"));
		items.equip(this.new("scripts/items/helmets/barbarians/leather_headband"));
		bros[2].setStartValuesEx([
			"barbarian_background"
		]);
		bros[2].getBackground().m.RawDescription = "野蛮人的掠夺者经常从他们陌生的土地上掠夺。 大多数人把他们的掠夺看作是物质和女人的问题，但有时他们会奴役有巨大潜力的难对付的男孩。%name%，一个北方人，就是这样一个孩子，他被培养成一个他们自己的掠夺者。 他的一半生活在原始氏族里，另一半生活在带走他的人那里。 这使他成为一个勇猛而野蛮的战士。";
		bros[2].improveMood(1.000000, "一次成功的掠夺");
		bros[2].setPlaceInFormation(5);
		bros[2].m.PerkPoints = 2;
		bros[2].m.LevelUps = 2;
		bros[2].m.Level = 3;
		bros[2].m.Talents = [];
		local talents = bros[2].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.MeleeSkill] = 1;
		talents[this.Const.Attributes.MeleeDefense] = 2;
		talents[this.Const.Attributes.Hitpoints] = 2;
		local items = bros[2].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Body));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Head));
		items.equip(this.new("scripts/items/armor/barbarians/hide_and_bone_armor"));
		items.equip(this.new("scripts/items/helmets/barbarians/leather_helmet"));
		bros[3].setStartValuesEx([
			"monk_background"
		]);
		bros[3].getBackground().m.RawDescription = "把你推上这条路的人，你相信 %name% 可能会为你获得巨大的财富发挥更大的作用。 你见过北方的混混和独臂战士，他们会在战斗中胜过他，但他的知识和智慧在适当的时候可能是更锋利的刀刃。";
		bros[3].improveMood(2.000000, "他还以为他说服你放弃了掠夺和抢劫");
		bros[3].setPlaceInFormation(13);
		bros[3].m.Talents = [];
		local talents = bros[3].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.Bravery] = 3;
		this.World.Assets.m.BusinessReputation = -50;
		this.World.Assets.addMoralReputation(-30.000000);
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/goat_cheese_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/smoked_ham_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/loot/silverware_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/loot/silver_bowl_item"));
		this.World.Assets.m.Money = this.World.Assets.m.Money / 2;
		this.World.Assets.m.Ammo = this.World.Assets.m.Ammo / 2;
	}

	function onSpawnPlayer()
	{
		local randomVillage;
		local northernmostY = 0;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
		{
			local v = this.World.EntityManager.getSettlements()[i];

			if (v.getTile().SquareCoords.Y > northernmostY && !v.isMilitary() && !v.isIsolatedFromRoads() && v.getSize() <= 2)
			{
				northernmostY = v.getTile().SquareCoords.Y;
				randomVillage = v;
			}
		}

		randomVillage.setLastSpawnTimeToNow();
		local randomVillageTile = randomVillage.getTile();
		local navSettings = this.World.getNavigator().createSettings();
		navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 2), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 2));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 2), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 2));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore || tile.IsOccupied)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) <= 1)
				{
				}
				else
				{
					local path = this.World.getNavigator().findPath(tile, randomVillageTile, navSettings, 0);

					if (!path.isEmpty())
					{
						randomVillageTile = tile;
						break;
					}
				}
			}
		}
		while (1);

		local attachedLocations = randomVillage.getAttachedLocations();
		local closest;
		local dist = 99999;

		foreach( a in attachedLocations )
		{
			if (a.getTile().getDistanceTo(randomVillageTile) < dist)
			{
				dist = a.getTile().getDistanceTo(randomVillageTile);
				closest = a;
			}
		}

		if (closest != null)
		{
			closest.setActive(false);
			closest.spawnFireAndSmoke();
		}

		local s = this.new("scripts/entity/world/settlements/situations/raided_situation");
		s.setValidForDays(5);
		randomVillage.addSituation(s);
		local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		local houses = [];

		foreach( n in nobles )
		{
			local closest;
			local dist = 9999;

			foreach( s in n.getSettlements() )
			{
				local d = s.getTile().getDistanceTo(randomVillageTile);

				if (d < dist)
				{
					dist = d;
					closest = s;
				}
			}

			houses.push({
				Faction = n,
				Dist = dist
			});
		}

		houses.sort(function ( _a, _b )
		{
			if (_a.Dist > _b.Dist)
			{
				return 1;
			}
			else if (_a.Dist < _b.Dist)
			{
				return -1;
			}

			return 0;
		});

		for( local i = 0; i < 2; i = ++i )
		{
			houses[i].Faction.addPlayerRelation(-100.000000, "你被认为是不法之徒和野蛮人");
		}

		houses[1].Faction.addPlayerRelation(18.000000);
		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(5);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList([
				"music/barbarians_02.ogg"
			], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.raiders_scenario_intro");
		}, null);
	}

	function isDroppedAsLoot( _item )
	{
		return this.Math.rand(1, 100) <= 15;
	}

});
