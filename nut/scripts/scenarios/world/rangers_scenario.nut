this.rangers_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.rangers";
		this.m.Name = "偷猎者团队";
		this.m.Description = "[p=c][img]gfx/ui/events/event_10.png[/img][/p][p]多年来，你一直在当地的森林里偷猎，快速地站起来躲避你主人的手下，过着体面的生活。 但是油水变得越来越少，你面临着一个决定，当你只知道如何使用弓时，如何谋生？\n\n[color=#bcad8c]猎人：[/color] 初始队伍包含三个巡林者。\n[color=#bcad8c]专家侦察员：[/color] 你移动的更快，并且总是可以得到附近敌人的详细侦查报告。\n[color=#bcad8c]轻装旅行：[/color] 你的战团只能携带略少的物品。[[/p]";
		this.m.Difficulty = 2;
		this.m.Order = 30;
	}

	function isValid()
	{
		return this.Const.DLC.Wildmen;
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();
		local names = [];

		for( local i = 0; i < 3; i = ++i )
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.m.HireTime = this.Time.getVirtualTimeF();

			while (names.find(bro.getNameOnly()) != null)
			{
				bro.setName(this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
			}

			names.push(bro.getNameOnly());
		}

		local bros = roster.getAll();
		local talents;
		bros[0].setStartValuesEx([
			"hunter_background"
		]);
		bros[0].getBackground().m.RawDescription = "{有点像个狡猾的小矮子，虽然内心是个好人。%name% 曾经为他的当地君主狩猎，但当贵族掉进一个看不见的峡谷死亡时，猎人被指责并被踢出了法庭 带着一些诡计，他把他的狩猎天赋变成了偷猎和毛皮贸易。 他有商人的头脑，因此很快就产生了佣兵工作的想法。}";
		bros[0].setPlaceInFormation(3);
		bros[0].m.Talents = [];
		talents = bros[0].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.RangedSkill] = 2;
		talents[this.Const.Attributes.RangedDefense] = 1;
		talents[this.Const.Attributes.Initiative] = 1;
		bros[0].m.PerkPoints = 0;
		bros[0].m.LevelUps = 0;
		bros[0].m.Level = 1;
		bros[1].setStartValuesEx([
			"poacher_background"
		]);
		bros[1].getBackground().m.RawDescription = "{%name% 的农场遭到干旱破坏后，他就开始偷猎。 像大多数偷猎者一样，他不是真正的罪犯。 长期以来，你都是狩猎团伙的一员，%name% 很快就提名你为新佣兵队伍的队长。}";
		bros[1].setPlaceInFormation(4);
		bros[1].m.Talents = [];
		talents = bros[1].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.RangedSkill] = 2;
		talents[this.Const.Attributes.Fatigue] = 1;
		talents[this.Const.Attributes.Initiative] = 1;
		local items = bros[1].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Ammo));
		items.equip(this.new("scripts/items/weapons/short_bow"));
		items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
		bros[2].setStartValuesEx([
			"poacher_background"
		]);
		bros[2].getBackground().m.RawDescription = "{一个前小丑，他的噱头是从天上射三个水罐。 你不知道他是怎么开始偷猎的，事实上，他似乎对一些与小丑有关的戏剧很不满，但他是一个出色的弓箭手。 他还喜欢提醒你，他的射术比你高明得多。}";
		bros[2].setPlaceInFormation(5);
		bros[2].m.Talents = [];
		talents = bros[2].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.RangedSkill] = 2;
		talents[this.Const.Attributes.Bravery] = 1;
		talents[this.Const.Attributes.Initiative] = 1;
		local items = bros[2].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Ammo));
		items.equip(this.new("scripts/items/weapons/staff_sling"));
		this.World.Assets.m.BusinessReputation = 100;
		this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() - 18);
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/cured_venison_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/trade/furs_item"));
		this.World.Assets.m.ArmorParts = this.World.Assets.m.ArmorParts / 2;
		this.World.Assets.m.Ammo = this.World.Assets.m.Ammo * 2;
	}

	function onSpawnPlayer()
	{
		local spawnTile;
		local settlements = this.World.EntityManager.getSettlements();
		local nearestVillage;
		local navSettings = this.World.getNavigator().createSettings();
		navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;

		do
		{
			local x = this.Math.rand(5, this.Const.World.Settings.SizeX - 5);
			local y = this.Math.rand(5, this.Const.World.Settings.SizeY - 5);

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.IsOccupied)
				{
				}
				else if (tile.Type != this.Const.World.TerrainType.Forest && tile.Type != this.Const.World.TerrainType.SnowyForest && tile.Type != this.Const.World.TerrainType.LeaveForest && tile.Type != this.Const.World.TerrainType.AutumnForest)
				{
				}
				else
				{
					local next = true;

					foreach( s in settlements )
					{
						local d = s.getTile().getDistanceTo(tile);

						if (d > 6 && d < 15)
						{
							local path = this.World.getNavigator().findPath(tile, s.getTile(), navSettings, 0);

							if (!path.isEmpty())
							{
								next = false;
								nearestVillage = s;
								break;
							}
						}
					}

					if (next)
					{
					}
					else
					{
						spawnTile = tile;
						break;
					}
				}
			}
		}
		while (1);

		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", spawnTile.Coords.X, spawnTile.Coords.Y);
		this.World.Assets.updateLook(10);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		local f = nearestVillage.getFactionOfType(this.Const.FactionType.NobleHouse);
		f.addPlayerRelation(-20.000000, "听说你在他们的树林里偷猎");
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList(this.Const.Music.IntroTracks, this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.rangers_scenario_intro");
		}, null);
	}

	function onInit()
	{
		if (this.World.State.getPlayer() != null)
		{
			this.World.State.getPlayer().m.BaseMovementSpeed = 111;
		}
	}

});
