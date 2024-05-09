this.southern_quickstart_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.southern_quickstart";
		this.m.Name = "南方佣兵";
		this.m.Description = "[p=c][img]gfx/ui/events/event_156.png[/img][/p][p]你和你那一小撮雇佣军多年来一直在做小商贩的肮脏勾当，但你跟强盗比还差一步。 你想变得更大。 你想要一切。 镀金者会给你指路。\n\n[color=#bcad8c]快速开始进入世界南部，没有任何特殊的优势或劣势。[/color][/p]";
		this.m.Difficulty = 1;
		this.m.Order = 11;
	}

	function isValid()
	{
		return this.Const.DLC.Desert;
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
			bro.improveMood(1.5, "加入了一个雇佣兵战团");

			while (names.find(bro.getNameOnly()) != null)
			{
				bro.setName(this.Const.Strings.SouthernNames[this.Math.rand(0, this.Const.Strings.SouthernNames.len() - 1)]);
			}

			names.push(bro.getNameOnly());
		}

		local bros = roster.getAll();
		bros[0].setStartValuesEx([
			"companion_1h_southern_background"
		]);
		bros[0].getBackground().m.RawDescription = "{%name% 曾经是维齐尔的精英先锋。 在一场激烈的战斗中，他的整个军团被歼灭，而他自己则被埋在他们的尸体下面。 直到今天他也不会告诉你他当时被遗弃在沙漠里却活了下来。 但他对你忠贞不渝，比任何战争故事都更能说明问题。}";
		bros[0].setPlaceInFormation(3);
		bros[1].setStartValuesEx([
			"companion_2h_southern_background"
		]);
		bros[1].getBackground().m.RawDescription = "{如果忠诚是金子，%name% 可能是站在镀金者的目光底下最富有的人。 你发现那个人在巷子里被伏击了。 他帮助他击退盗贼，他向你宣誓效忠一年。 从那以后，已经发生了很多次。 尽管 %name% 一上来被揍了一顿，但当他没有被灌木丛击中时，他是一个非常可怕的斗士。}";
		bros[1].setPlaceInFormation(4);
		bros[2].setStartValuesEx([
			"companion_ranged_southern_background"
		]);
		bros[2].getBackground().m.RawDescription = "{你不能完全确定 %name%的过去，只知道他的道路没有人们希望的那样闪耀。 他说他扮演了很多角色，但是军队没有他，城市警卫没有他，女人们当然不会有他，所以他把自己活成了逐币者。 他认为一个光荣而迅速的死亡会把他带到镀金者的目光中，这样他就可以问他为什么他会如此严厉地对待自己的生命。 当他不自怨自艾的时候，%name% 可以是快乐和有趣的。 只要让他远离酒和牧师。}";
		bros[2].setPlaceInFormation(5);
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/rice_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/rice_item"));
		this.World.Assets.m.Money = this.World.Assets.m.Money + 400;
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isIsolatedFromRoads() && randomVillage.isSouthern())
			{
				break;
			}
		}

		local randomVillageTile = randomVillage.getTile();
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

		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(13);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList([
				"music/worldmap_11.ogg"
			], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.southern_quickstart_scenario_intro");
		}, null);
	}

});
