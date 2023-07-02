this.gladiators_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.gladiators";
		this.m.Name = "角斗士";
		this.m.Description = "[p=c][img]gfx/ui/events/event_155.png[/img][/p][p]你已经在南方的竞技场战斗多年了。 首先是为了你的自由，然后是为了克朗，最后是为了不朽。 命运还为你准备了什么？\n\n[color=#bcad8c]角斗士：[/color] 从三个经验丰富的角斗士开始，他们装备精良，但日工资很高。\n[color=#bcad8c]竞技场传奇：[/color] 每个角斗士在战斗中都有自己独特的特点。\n[color=#bcad8c]荣耀之三：[/color] 你的花名册上不能超过12个人，如果你的三个特殊角斗士都死了，你的战役就结束了。[/p]";
		this.m.Difficulty = 3;
		this.m.Order = 100;
		this.m.IsFixedLook = true;
	}

	function isValid()
	{
		return this.Const.DLC.Desert;
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();

		for( local i = 0; i < 3; i = ++i )
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.setStartValuesEx([
				"gladiator_origin_background"
			]);
			bro.getSkills().removeByID("trait.survivor");
			bro.getSkills().removeByID("trait.greedy");
			bro.getSkills().removeByID("trait.loyal");
			bro.getSkills().removeByID("trait.disloyal");
			bro.getSkills().add(this.new("scripts/skills/traits/arena_fighter_trait"));
			bro.getFlags().set("ArenaFightsWon", 5);
			bro.getFlags().set("ArenaFights", 5);
			bro.setPlaceInFormation(3 + i);
			bro.getFlags().set("IsPlayerCharacter", true);
			bro.getSprite("miniboss").setBrush("bust_miniboss_gladiators");
			bro.m.HireTime = this.Time.getVirtualTimeF();
			bro.m.PerkPoints = 2;
			bro.m.LevelUps = 2;
			bro.m.Level = 3;
			bro.m.Talents = [];
			bro.m.Attributes = [];
		}

		local bros = roster.getAll();
		local a;
		local u;
		bros[0].setTitle("狮子");
		bros[0].getSkills().add(this.new("scripts/skills/traits/glorious_resolve_trait"));
		bros[0].getTalents().resize(this.Const.Attributes.COUNT, 0);
		bros[0].getTalents()[this.Const.Attributes.MeleeDefense] = 2;
		bros[0].getTalents()[this.Const.Attributes.Fatigue] = 2;
		bros[0].getTalents()[this.Const.Attributes.MeleeSkill] = 3;
		bros[0].fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
		a = this.new("scripts/items/armor/oriental/gladiator_harness");
		a.setUpgrade(this.new("scripts/items/armor_upgrades/light_gladiator_upgrade"));
		bros[0].getItems().equip(a);
		a = this.new("scripts/items/helmets/oriental/gladiator_helmet");
		a.setVariant(13);
		bros[0].getItems().equip(a);
		bros[0].getItems().equip(this.new("scripts/items/weapons/scimitar"));
		bros[0].getItems().equip(this.new("scripts/items/tools/throwing_net"));
		bros[0].improveMood(0.750000, "渴望在竞技场外证明自己");
		bros[1].setTitle("大熊(the Bear)");
		bros[1].getSkills().add(this.new("scripts/skills/traits/glorious_endurance_trait"));
		bros[1].getTalents().resize(this.Const.Attributes.COUNT, 0);
		bros[1].getTalents()[this.Const.Attributes.Hitpoints] = 3;
		bros[1].getTalents()[this.Const.Attributes.Fatigue] = 2;
		bros[1].getTalents()[this.Const.Attributes.Bravery] = 2;
		bros[1].fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
		a = this.new("scripts/items/armor/oriental/gladiator_harness");
		a.setUpgrade(this.new("scripts/items/armor_upgrades/heavy_gladiator_upgrade"));
		bros[1].getItems().equip(a);
		a = this.new("scripts/items/helmets/oriental/gladiator_helmet");
		a.setVariant(15);
		bros[1].getItems().equip(a);
		bros[1].getItems().equip(this.new("scripts/items/weapons/oriental/heavy_southern_mace"));
		bros[1].getItems().equip(this.new("scripts/items/shields/oriental/metal_round_shield"));
		bros[1].improveMood(0.750000, "渴望在竞技场外证明自己");
		bros[2].setTitle("毒蛇");
		bros[2].getSkills().add(this.new("scripts/skills/traits/glorious_quickness_trait"));
		bros[2].getTalents().resize(this.Const.Attributes.COUNT, 0);
		bros[2].getTalents()[this.Const.Attributes.MeleeDefense] = 2;
		bros[2].getTalents()[this.Const.Attributes.Initiative] = 3;
		bros[2].getTalents()[this.Const.Attributes.MeleeSkill] = 2;
		bros[2].fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
		a = this.new("scripts/items/armor/oriental/gladiator_harness");
		a.setUpgrade(this.new("scripts/items/armor_upgrades/light_gladiator_upgrade"));
		bros[2].getItems().equip(a);
		a = this.new("scripts/items/helmets/oriental/gladiator_helmet");
		a.setVariant(14);
		bros[2].getItems().equip(a);
		bros[2].getItems().equip(this.new("scripts/items/weapons/oriental/qatal_dagger"));
		bros[2].getItems().equip(this.new("scripts/items/tools/throwing_net"));
		bros[2].improveMood(0.750000, "渴望在竞技场外证明自己");
		bros[0].getBackground().m.RawDescription = "{%fullname% 认为肌肉是荣耀。错了，队长，应该是我！ " + bros[2].getName() + ", 谁命令这个领域的女士们。不用问我怎么做。看啊！看看！看看它的大小！是啊。我就是这么想的。 傻瓜，训练你想要的，你不能这样！}";
		bros[0].getBackground().buildDescription(true);
		bros[1].getBackground().m.RawDescription = "{%fullname% 不是这里最好的战士，让我们说清楚。队长, 看我的肌肉, 不是我， " + bros[0].getName() + ", 谁能获得人生最大的回报：对自己敌人的恐惧！听着，如果我擦一点泡沫，然后抓住阳光，肌肉就会发光。 当所有的女人都说她们就在这里，尤其是在这里，在我美丽的胸脯上找到了天堂，难道不是把我的胸肌错当成了天堂吗？}";
		bros[1].getBackground().buildDescription(true);
		bros[2].getBackground().m.RawDescription = "{你为什么看着%fullname%？队长，应该是我！" + bros[1].getName() + ", 谁是你最伟大的角斗士. 我就是那个扫过林德蠕龙腿，用它自己的尾巴把它勒死的人！ 你们这些混蛋怎么说？ 你说这是个大故事？ 呸！充其量只是一只横着的蜥蜴。}";
		bros[2].getBackground().buildDescription(true);
		this.World.Assets.m.BusinessReputation = 100;
		this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() - 9);
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/dried_lamb_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/wine_item"));
		this.World.Assets.m.Money = this.World.Assets.m.Money / 2 - (this.World.Assets.getEconomicDifficulty() == 0 ? 0 : 300);
		this.World.Assets.m.ArmorParts = this.World.Assets.m.ArmorParts / 2;
		this.World.Assets.m.Medicine = this.World.Assets.m.Medicine / 2;
		this.World.Assets.m.Ammo = 0;
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isIsolatedFromRoads() && randomVillage.isSouthern() && randomVillage.hasBuilding("building.arena"))
			{
				break;
			}
		}

		local randomVillageTile = randomVillage.getTile();

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 1), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 1));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 1), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 1));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) == 0)
				{
				}
				else if (!tile.HasRoad)
				{
				}
				else
				{
					randomVillageTile = tile;
					break;
				}
			}
		}
		while (1);

		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(16);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList([
				"music/worldmap_11.ogg"
			], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.gladiators_scenario_intro");
		}, null);
	}

	function onInit()
	{
		this.World.Assets.m.BrothersMax = 12;
	}

	function onCombatFinished()
	{
		local roster = this.World.getPlayerRoster().getAll();
		local gladiators = 0;

		foreach( bro in roster )
		{
			if (bro.getFlags().get("IsPlayerCharacter"))
			{
				gladiators = ++gladiators;
			}
		}

		if (gladiators == 2 && !this.World.Flags.get("GladiatorsOriginDeath2"))
		{
			this.World.Flags.set("GladiatorsOriginDeath2", true);

			foreach( bro in roster )
			{
				if (bro.getFlags().get("IsPlayerCharacter"))
				{
					bro.getBackground().m.RawDescription = "{%fullname% 对一个好朋友的去世感到悲伤，但是他在展望未来的时候知道有一个人一直在他身后。就是以兄弟般的方式在他身后。精神上的。只有兄弟般的精神上的。}";
					bro.getBackground().buildDescription(true);
				}
			}
		}
		else if (gladiators == 1 && !this.World.Flags.get("GladiatorsOriginDeath1"))
		{
			this.World.Flags.set("GladiatorsOriginDeath1", true);

			foreach( bro in roster )
			{
				if (bro.getFlags().get("IsPlayerCharacter"))
				{
					bro.getBackground().m.RawDescription = "{你应该知道些什么，队长。 我很高兴你能置身事外。 大概有十年了，我还没有感受到这样的生活。 如果你看到我在那即将倒下，你就呆在原地，因为我正站在我想站的地方。}";
					bro.getBackground().buildDescription(true);
				}
			}
		}

		return gladiators != 0;
	}

});
