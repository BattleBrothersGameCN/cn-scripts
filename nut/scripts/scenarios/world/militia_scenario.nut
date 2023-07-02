this.militia_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.militia";
		this.m.Name = "农民民兵";
		this.m.Description = "[p=c][img]gfx/ui/events/event_141.png[/img][/p][p]它最初是由勇敢或绝望的人组成的一支破烂民兵组织，他们自愿保卫家园，但现在已经成长为一支小型军队。 一支每天都需要补给的军队。 也许民兵的服务可以租出去？\n\n[color=#bcad8c]农民军：[/color] 从12个装备不良的农民开始。\n[color=#bcad8c]人海[/color]: 一次最多可带16人参加战斗，花名册中最多可有25人。\n[color=#bcad8c]肮脏农民[/color]: 不能雇佣任何不是低贱农民的人。[/p]";
		this.m.Difficulty = 1;
		this.m.Order = 20;
	}

	function isValid()
	{
		return this.Const.DLC.Wildmen;
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();
		local names = [];

		for( local i = 0; i < 12; i = ++i )
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.worsenMood(1.500000, "在战斗中失去了许多朋友");
			bro.improveMood(0.500000, "民兵的一部分");
			bro.m.HireTime = this.Time.getVirtualTimeF();

			while (names.find(bro.getNameOnly()) != null)
			{
				bro.setName(this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
			}

			names.push(bro.getNameOnly());
		}

		local bros = roster.getAll();
		bros[0].setStartValuesEx([
			"farmhand_background"
		]);
		bros[0].getBackground().m.RawDescription = "%name%是一个农夫的儿子，大概希望在某个时候成为自己儿子的父亲。现在，他和你在一起，这是梦想和现实之间令人遗憾的冲突。";
		bros[0].improveMood(3.000000, "最近坠入爱河");
		local items = bros[0].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/pitchfork"));
		bros[1].setStartValuesEx([
			"farmhand_background"
		]);
		bros[1].getBackground().m.RawDescription = "%name%拥有过一个农场，而那农场早已被无数路过的军队所践踏，包括他曾经为之战斗过的军队。他对你的“忠诚”可以说是空肚子的结果。";
		bros[1].worsenMood(0.500000, "卷入了一场斗殴");
		bros[1].addLightInjury();
		local items = bros[1].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/warfork"));
		bros[2].setStartValuesEx([
			"poacher_background"
		]);
		bros[2].getBackground().m.RawDescription = "说%name%实际上是一个避世的贵族是一个老笑话，但据你所知，他只是一个简单的偷猎者。世界的压力使他走到了今天这个地步，除了你希望他重新振作起来之外，别无他言。";
		bros[2].worsenMood(0.500000, "卷入了一场斗殴");
		bros[2].addLightInjury();
		local items = bros[2].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/staff_sling"));
		bros[3].setStartValuesEx([
			"vagabond_background",
			"thief_background",
			"gambler_background"
		]);
		bros[3].getBackground().m.RawDescription = "你注意到 %name% 对某些贵族有些躲闪。 他很可能是一个普通的罪犯，因为犯了一些小罪而逍遥法外，但只要他打得好，对你来说就没什么大不了的。";
		bros[3].improveMood(1.500000, "偷了别人的撒克逊大刀");
		items = bros[3].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/scramasax"));
		bros[4].setStartValuesEx([
			"daytaler_background"
		]);
		bros[4].getBackground().m.RawDescription = "作为一个日结工和普通工人，%name%宁愿加入你的队伍也不愿回去耗费他的身体去建造某个贵族的新豪华门厅。";
		bros[4].worsenMood(0.500000, "卷入了一场斗殴");
		bros[4].addLightInjury();
		bros[5].setStartValuesEx([
			"miller_background"
		]);
		bros[5].getBackground().m.RawDescription = "寻找财富，%name% 在你新成立的佣兵团中找到了正确的位置。 不幸的是，他的背景是种地、碾磨、铺石头，尤其是他不擅长的那些。";
		bros[5].improveMood(1.000000, "期待成为一个富有的佣兵");
		local items = bros[5].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/pitchfork"));
		bros[6].setStartValuesEx([
			"fisherman_background"
		]);
		bros[6].getBackground().m.RawDescription = "%name% 说他来内陆之前是个水手，后来加入了民兵，现在加入了你的佣兵团。 他希望最终拥有一艘船，并把它的帆驶向公海。 你真的希望有一天他能做到吗。";
		bros[6].worsenMood(0.250000, "最近觉得有点不舒服");
		bros[7].setStartValuesEx([
			"militia_background"
		]);
		bros[7].getBackground().m.RawDescription = "%name% 显然已经加入了许多民兵组织，所有的民兵组织最终都因为这样或那样的原因解散了。 在任何一个地方他都没有赚到钱，所以他希望通过做个全新的佣兵来改变这种状况。";
		bros[7].improveMood(3.000000, "最近成了父亲");
		bros[7].m.PerkPoints = 0;
		bros[7].m.LevelUps = 0;
		bros[7].m.Level = 1;
		bros[8].setStartValuesEx([
			"minstrel_background"
		]);
		bros[8].getBackground().m.RawDescription = "一个真正的小伙子，%name% 喜欢在酒吧里纵情款待女士，在教堂里追逐裙子。 你会感觉到他只是为了把他的“乐趣”传播到全世界。";
		local items = bros[8].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/lute"));
		bros[9].setStartValuesEx([
			"daytaler_background"
		]);
		bros[9].getBackground().m.RawDescription = "日结工、工人、商队队员、水手、民兵，%name%都做过一段时间。希望这次对雇佣兵工作的新尝试能让他坚持下去。";
		bros[9].worsenMood(1.000000, "偷了信赖他的人的撒克逊大刀");
		bros[10].setStartValuesEx([
			"militia_background"
		]);
		bros[10].getBackground().m.RawDescription = "和你一样，%name% 厌倦了民兵被过度用于解决毫无准备的贵族的危机。 他可以说是加入向佣兵工作过渡的人中最认真的一个。";
		bros[10].worsenMood(0.500000, "不喜欢民兵中的一些人卷入了一场斗殴");
		bros[10].m.PerkPoints = 0;
		bros[10].m.LevelUps = 0;
		bros[10].m.Level = 1;
		bros[11].setStartValuesEx([
			"butcher_background",
			"tailor_background",
			"shepherd_background"
		]);
		bros[11].getBackground().m.RawDescription = "%name% 表面上是在逃避他的妻子。 你见过她一次就完全同意了他的逃跑计划，不仅仅是因为这样你就能在前线多留一个人。那丫头真是疯了。";
		bros[11].improveMood(1.000000, "设法摆脱了他的妻子");
		this.World.Assets.m.BusinessReputation = -100;
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() + 9);
		this.World.Assets.m.Money = this.World.Assets.m.Money / 2;
		this.World.Assets.m.ArmorParts = this.World.Assets.m.ArmorParts / 2;
		this.World.Assets.m.Medicine = this.World.Assets.m.Medicine / 2;
		this.World.Assets.m.Ammo = this.World.Assets.m.Ammo / 2;
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() == 1)
			{
				break;
			}
		}

		local randomVillageTile = randomVillage.getTile();
		this.World.Flags.set("HomeVillage", randomVillage.getName());
		local navSettings = this.World.getNavigator().createSettings();
		navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 4), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 4));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 4), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 4));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) <= 1)
				{
				}
				else if (tile.Type != this.Const.World.TerrainType.Plains && tile.Type != this.Const.World.TerrainType.Steppe && tile.Type != this.Const.World.TerrainType.Tundra && tile.Type != this.Const.World.TerrainType.Snow)
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

		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(8);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		randomVillage.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(40.000000, "被认为是保护村庄安全的当地英雄");
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList([
				"music/retirement_01.ogg"
			], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.militia_scenario_intro");
		}, null);
	}

	function onInit()
	{
		this.World.Assets.m.BrothersMax = 25;
		this.World.Assets.m.BrothersMaxInCombat = 16;
		this.World.Assets.m.BrothersScaleMax = 14;
	}

	function onUpdateHiringRoster( _roster )
	{
		local garbage = [];
		local bros = _roster.getAll();

		foreach( i, bro in bros )
		{
			if (!bro.getBackground().isLowborn())
			{
				garbage.push(bro);
			}
		}

		foreach( g in garbage )
		{
			_roster.remove(g);
		}
	}

});
