this.manhunters_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.manhunters";
		this.m.Name = "猎奴者";
		this.m.Description = "[p=c][img]gfx/ui/events/event_172.png[/img][/p][p]城邦和游牧民族之间不断的冲突有利于生意的发展。 你队伍大部分都是俘虏构成，为了获得自由被迫战斗，他们的队伍在每次战斗后都会增加。\n\n[color=#bcad8c]俘虏大军：[/color] 从两个搜捕者和四个负债者开始。 一次最多可携带16人参战。 负债者与非负债者相等或更少会使你的人不满意。\n[color=#bcad8c]监工：[/color] 所有非负债者都可以在战斗中鞭打负债者的来重置他们的士气和增加他们的属性。\n[color=#bcad8c]俘虏：[/color] 负债者获得的经验增加10%，上限为7级，如果被击倒将直接死亡。[/p]";
		this.m.Difficulty = 3;
		this.m.Order = 89;
		this.m.IsFixedLook = true;
	}

	function isValid()
	{
		return this.Const.DLC.Desert;
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();
		local names = [];

		for( local i = 0; i < 6; i = ++i )
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.m.HireTime = this.Time.getVirtualTimeF();
		}

		local bros = roster.getAll();
		local talents;
		bros[0].setStartValuesEx([
			"manhunter_background"
		]);
		bros[0].setTitle("斯多葛学派信徒");
		bros[0].getBackground().m.RawDescription = "{从某种意义上说，你并不特别关心 %name%。他对俘虏、罪犯之类的人既不憎恨也不宽恕。 他只是处理他的生意。 但他对你也是如此平静，坚定，这有点麻烦。 这个人很有潜力，这就是为什么你让他加入 %companyname%，但你只是希望他时不时表现出一些激情。}";
		bros[0].setPlaceInFormation(12);
		local items = bros[0].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Head));
		items.equip(this.new("scripts/items/weapons/oriental/light_southern_mace"));
		bros[0].getSkills().add(this.new("scripts/skills/actives/whip_slave_skill"));
		bros[0].m.Talents = [];
		talents = bros[0].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.MeleeSkill] = 1;
		talents[this.Const.Attributes.Bravery] = 2;
		talents[this.Const.Attributes.RangedDefense] = 1;
		local traits = bros[0].getSkills().getAllSkillsOfType(this.Const.SkillType.Trait);

		foreach( t in traits )
		{
			if (!t.isType(this.Const.SkillType.Special) && !t.isType(this.Const.SkillType.Background))
			{
				bros[0].getSkills().remove(t);
			}
		}

		bros[1].setStartValuesEx([
			"manhunter_background"
		]);
		bros[1].setTitle("鞭子(the Whip)");
		bros[1].getBackground().m.RawDescription = "{%name% 是你认识的最糟糕的人之一。 他对负债者毫不留情地残暴，即使以你的标准来衡量，他也要对你的一些捕获物负责。 也就是说，他的刻薄作风将对战团很有好处。 考虑到你已经因为失去库存而鞭打了他一到三次，你知道他也能承受打击。}";
		bros[1].setPlaceInFormation(13);
		local items = bros[1].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Offhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Head));
		items.equip(this.new("scripts/items/helmets/oriental/southern_head_wrap"));
		items.equip(this.new("scripts/items/weapons/battle_whip"));
		bros[1].getSkills().add(this.new("scripts/skills/actives/whip_slave_skill"));
		bros[1].worsenMood(0.0, "对你最近对不要虐待俘虏的训斥而感到恼火");
		bros[1].m.Talents = [];
		talents = bros[1].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.Fatigue] = 2;
		talents[this.Const.Attributes.MeleeSkill] = 1;
		talents[this.Const.Attributes.Hitpoints] = 1;
		bros[2].setStartValuesEx([
			"slave_southern_background"
		]);
		bros[2].setTitle("博学者(the Learned)");
		bros[2].getBackground().m.RawDescription = "{你发现 %name% 正受到城市警卫的法律制裁。 看起来他们要用他的手腕玩一个“接住弯刀”的游戏，直到你介入，他认为他欠镀金者的钱远比欠任何人的钱还多。 你希望把他高价卖给的维齐尔，但没有人会接受他，因为他太“博学”了，而且似乎正是那种会引发起义的威胁。 对一个地位如此之高的人来说，他确实对你怀有一点尊敬。}";
		bros[2].setPlaceInFormation(2);
		bros[2].getSkills().removeByID("trait.dumb");
		bros[2].getSkills().add(this.new("scripts/skills/traits/bright_trait"));
		bros[2].getSprite("miniboss").setBrush("bust_miniboss_indebted");
		local items = bros[2].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/wooden_stick"));
		items.equip(this.new("scripts/items/helmets/oriental/nomad_head_wrap"));
		bros[2].worsenMood(0.0, "想念他的书");
		bros[3].setStartValuesEx([
			"slave_background"
		]);
		bros[3].setTitle("北方人(the Northerner)");
		bros[3].getBackground().m.RawDescription = "{无论如何不是一个友好的人，但这就是枷锁的作用。当你碰巧碰到他时，%name% 正因为一系列的犯罪而被送上了绞架。 你为他的生命付出了投资，说他现在应该努力工作才能在镀金者的目光中找到救赎。 他对你的虔诚信仰不太有把握，但你却雇了一位牧师来证实他的汗水确实来自于更高的崇高境界。}";
		bros[3].setPlaceInFormation(3);
		bros[3].getSprite("miniboss").setBrush("bust_miniboss_indebted");
		local items = bros[3].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/bludgeon"));
		bros[3].worsenMood(2.0, "差点被处决");
		bros[3].improveMood(2.0, "他逃脱了处决");
		bros[3].worsenMood(0.0, "担心接下来会发生什么");
		bros[4].setStartValuesEx([
			"slave_southern_background"
		]);
		bros[4].setTitle("逃兵(the Deserter)");
		bros[4].getBackground().m.RawDescription = "{%name% 是异端的传家宝，是维齐尔的一位牧师送给你的。 这个人在大领主的军队里是个逃兵，但通过富有的关系设法避免了处决。 然而，只有一种方法可以避免地狱之火，那就是通过负债感恩。 他会为你工作，直到他找到救赎，什么时候会发生完全取决于你。}";
		bros[4].setPlaceInFormation(4);
		bros[4].getSprite("miniboss").setBrush("bust_miniboss_indebted");
		local items = bros[4].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/militia_spear"));
		bros[4].worsenMood(0.5, "觉得自己被诅咒了，逃离了一支军队，却在另一支军队中当负债者");
		bros[5].setStartValuesEx([
			"slave_southern_background"
		]);
		bros[5].setTitle("要饭的");
		bros[5].getBackground().m.RawDescription = "{在街上发现的，%name% 根本没机会。 作为一个乞丐，在身体上很容易给他戴上镣铐，在社会上没有人会在意。 镀金者不关心那些不工作的人，他们每天浪费金钱，不付出汗水，只会欠下债务。 现在必须付出代价，以免他永远尝到沙漠之火的滋味。 他现在看起来比你找到他的时候更健康，尽管他似乎从来没有为此感谢过你。}";
		bros[5].setPlaceInFormation(5);
		bros[5].getSprite("miniboss").setBrush("bust_miniboss_indebted");
		local items = bros[5].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/wooden_stick"));
		this.World.Assets.m.BusinessReputation = 100;
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/rice_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/rice_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/rice_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/misc/manhunters_ledger_item"));
		this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() + 9);
		this.World.Assets.m.Money = this.World.Assets.m.Money;
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

		this.countIndebted();
		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(18);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList([
				"music/worldmap_11.ogg"
			], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.manhunters_scenario_intro");
		}, null);
	}

	function onInit()
	{
		this.World.Assets.m.BrothersMax = 25;
		this.World.Assets.m.BrothersMaxInCombat = 16;
		this.World.Assets.m.BrothersScaleMax = 14;
	}

	function onHired( _bro )
	{
		if (_bro.getBackground().getID() != "background.slave")
		{
			_bro.getSkills().add(this.new("scripts/skills/actives/whip_slave_skill"));
		}
		else
		{
			_bro.getSprite("miniboss").setBrush("bust_miniboss_indebted");
		}

		this.countIndebted();
	}

	function onCombatFinished()
	{
		this.countIndebted();
		return true;
	}

	function onUnlockPerk( _bro, _perkID )
	{
		if (_bro.getLevel() == 7 && _bro.getBackground().getID() == "background.slave" && _perkID == "perk.student")
		{
			_bro.setPerkPoints(_bro.getPerkPoints() + 1);
		}
	}

	function onUpdateLevel( _bro )
	{
		if (_bro.getLevel() == 7 && _bro.getBackground().getID() == "background.slave" && _bro.getSkills().hasSkill("perk.student"))
		{
			_bro.setPerkPoints(_bro.getPerkPoints() + 1);
		}
	}

	function onGetBackgroundTooltip( _background, _tooltip )
	{
		if (_background.getID() != "background.slave")
		{
			if (_background.getID() == "background.wildman")
			{
				_tooltip.pop();
				_tooltip.push({
					id = 16,
					type = "text",
					icon = "ui/icons/xp_received.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] 经验获取"
				});
			}
			else if (_background.getID() == "background.apprentice")
			{
				_tooltip.pop();
			}
			else if (_background.getID() == "background.historian")
			{
				_tooltip.pop();
				_tooltip.push({
					id = 16,
					type = "text",
					icon = "ui/icons/xp_received.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5%[/color] 经验获取"
				});
			}
			else
			{
				_tooltip.push({
					id = 16,
					type = "text",
					icon = "ui/icons/xp_received.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] 经验获取"
				});
			}
		}
		else
		{
			_tooltip.push({
				id = 16,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] 经验获取"
			});
			_tooltip.push({
				id = 17,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "角色只能到7级"
			});
			_tooltip.push({
				id = 18,
				type = "text",
				icon = "ui/icons/days_wounded.png",
				text = "如果被击倒就会永久死亡，且不会带着永久创伤存活"
			});
		}
	}

	function countIndebted()
	{
		local roster = this.World.getPlayerRoster().getAll();
		local indebted = 0;
		local nonIndebted = [];

		foreach( bro in roster )
		{
			if (bro.getBackground().getID() == "background.slave")
			{
				indebted++;
			}
			else
			{
				nonIndebted.push(bro);
			}
		}

		this.World.Statistics.getFlags().set("ManhunterIndebted", indebted);
		this.World.Statistics.getFlags().set("ManhunterNonIndebted", nonIndebted.len());
	}

});
