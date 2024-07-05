this.escort_caravan_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Caravan = null,
		NobleHouseID = 0,
		NobleSettlement = null,
		IsEscortUpdated = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.escort_caravan";
		this.m.Name = "护送商队";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		local nobleHouses = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);

		foreach( i, h in nobleHouses )
		{
			if (h.getSettlements().len() == 0)
			{
				continue;
			}

			if (this.m.Home.getOwner() != null && this.m.Home.getOwner().getID() == h.getID())
			{
				nobleHouses.remove(i);
				break;
			}
		}

		if (nobleHouses.len() != 0)
		{
			this.m.NobleHouseID = nobleHouses[this.Math.rand(0, nobleHouses.len() - 1)].getID();
		}

		local name = this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)] + "·冯·" + this.World.FactionManager.getFaction(this.m.NobleHouseID).getNameOnly();
		this.m.Flags.set("NobleName", name);
		local settlements = this.World.EntityManager.getSettlements();
		local bestDist = 9000;
		local best;

		foreach( s in settlements )
		{
			if (!s.isDiscovered() || !s.isMilitary())
			{
				continue;
			}

			if (s.getID() == this.m.Destination.getID())
			{
				continue;
			}

			if (s.getOwner() != null && s.getOwner().getID() == this.m.NobleHouseID)
			{
				local d = this.getDistanceOnRoads(s.getTile(), this.m.Home.getTile());

				if (d < bestDist)
				{
					bestDist = d;
					best = s;
				}
			}
		}

		if (best != null)
		{
			this.m.NobleSettlement = this.WeakTableRef(best);
			this.m.Flags.set("NobleSettlement", best.getID());
		}

		this.contract.start();
	}

	function setup()
	{
		local settlements = this.World.EntityManager.getSettlements();
		local candidates = [];

		foreach( s in settlements )
		{
			if (s.getID() == this.m.Origin.getID())
			{
				continue;
			}

			if (!s.isAlliedWith(this.getFaction()))
			{
				continue;
			}

			if (this.m.Origin.isIsolated() || s.isIsolated() || !this.m.Origin.isConnectedToByRoads(s) || this.m.Origin.isCoastal() && s.isCoastal())
			{
				continue;
			}

			local d = this.m.Origin.getTile().getDistanceTo(s.getTile());

			if (d <= 12 || d > 100)
			{
				continue;
			}

			local distance = this.getDistanceOnRoads(this.m.Origin.getTile(), s.getTile());
			local days = this.getDaysRequiredToTravel(distance, this.Const.World.MovementSettings.Speed * 0.6, true);

			if (days > 7 || distance < 15)
			{
				continue;
			}

			if (this.World.getTime().Days <= 10 && days > 4)
			{
				continue;
			}

			if (this.World.getTime().Days <= 5 && days > 2)
			{
				continue;
			}

			candidates.push(s);
		}

		if (candidates.len() == 0)
		{
			this.m.IsValid = false;
			return;
		}

		this.m.Destination = this.WeakTableRef(candidates[this.Math.rand(0, candidates.len() - 1)]);
		local distance = this.getDistanceOnRoads(this.m.Origin.getTile(), this.m.Destination.getTile());
		local days = this.getDaysRequiredToTravel(distance, this.Const.World.MovementSettings.Speed * 0.6, true);

		if (days >= 5)
		{
			this.m.DifficultyMult = this.Math.rand(115, 135) * 0.01;
		}
		else if (days >= 2)
		{
			this.m.DifficultyMult = this.Math.rand(95, 105) * 0.01;
		}
		else
		{
			this.m.DifficultyMult = this.Math.rand(70, 85) * 0.01;
		}

		this.m.Payment.Pool = this.Math.max(150, distance * 7.0 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult());
		local r = this.Math.rand(1, 3);

		if (r == 1)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else if (r == 2)
		{
			this.m.Payment.Count = 0.25;
			this.m.Payment.Completion = 0.75;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		local maximumHeads = [
			15,
			20,
			25,
			30
		];
		this.m.Payment.MaxCount = maximumHeads[this.Math.rand(0, maximumHeads.len() - 1)];
		this.m.Flags.set("HeadsCollected", 0);
		this.m.Flags.set("Distance", distance);
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"护送商队去%direction%方约%days%路程的%objective%",
					"为你的人准备了路上的食物"
				];
				local isSouthern = this.World.FactionManager.getFaction(this.Contract.getFaction()).getType() == this.Const.FactionType.OrientalCityState;

				if (!isSouthern && this.Math.rand(1, 100) <= this.Const.Contracts.Settings.IntroChance)
				{
					this.Contract.setScreen("Intro");
				}
				else if (isSouthern)
				{
					this.Contract.setScreen("TaskSouthern");
				}
				else
				{
					this.Contract.setScreen("Task");
				}
			}

			function end()
			{
				local isSouthern = this.World.FactionManager.getFaction(this.Contract.getFaction()).getType() == this.Const.FactionType.OrientalCityState;
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 5)
				{
					if (this.World.Assets.getBusinessReputation() > 700 && !isSouthern)
					{
						this.Flags.set("IsStolenGoods", true);
						this.Flags.set("IsEnoughCombat", true);

						if (this.Contract.m.Home.getOwner() != null)
						{
							this.Contract.m.NobleHouseID = this.Contract.m.Home.getOwner().getID();
						}
						else if (this.Contract.m.Destination.getOwner() != null)
						{
							this.Contract.m.NobleHouseID = this.Contract.m.Destination.getOwner().getID();
						}
						else
						{
							local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
							this.Contract.m.NobleHouseID = nobles[this.Math.rand(0, nobles.len() - 1)].getID();
						}
					}
				}
				else if (r <= 10)
				{
					if (this.World.Assets.getBusinessReputation() > 1000 && this.Contract.getDifficultyMult() >= 0.95)
					{
						this.Flags.set("IsVampires", true);
						this.Flags.set("IsEnoughCombat", true);
					}
				}
				else if (r <= 15)
				{
					this.Flags.set("IsValuableCargo", true);
				}
				else if (r <= 20)
				{
					if (this.Contract.m.NobleHouseID != 0 && this.Flags.has("NobleName") && this.Flags.has("NobleSettlement") && !isSouthern)
					{
						this.Flags.set("IsPrisoner", true);
					}
				}
				else if (this.Contract.getDifficultyMult() < 0.95 || this.World.Assets.getBusinessReputation() <= 500 || this.Contract.getDifficultyMult() <= 1.1 && this.Math.rand(1, 100) <= 20)
				{
					this.Flags.set("IsEnoughCombat", true);
				}

				this.Contract.spawnCaravan();
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
				this.World.State.setCampingAllowed(false);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
				}

				if (this.Contract.m.Payment.Count != 0)
				{
					if (this.Contract.m.BulletpointsObjectives.len() >= 2)
					{
						this.Contract.m.BulletpointsObjectives.remove(1);
					}

					this.Contract.m.BulletpointsObjectives.push("每杀死一个攻击者就可以得到一笔报酬(%killcount%/%maxcount%)");
				}

				this.World.State.setEscortedEntity(this.Contract.m.Caravan);
			}

			function update()
			{
				if (this.Contract.m.Caravan == null || this.Contract.m.Caravan.isNull() || !this.Contract.m.Caravan.isAlive() || this.Contract.m.Caravan.getTroops().len() == 0)
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (!this.Contract.m.IsEscortUpdated)
				{
					this.World.State.setEscortedEntity(this.Contract.m.Caravan);
					this.Contract.m.IsEscortUpdated = true;
				}

				this.World.State.setCampingAllowed(false);
				this.World.State.getPlayer().setPos(this.Contract.m.Caravan.getPos());
				this.World.State.getPlayer().setVisible(false);
				this.World.Assets.setUseProvisions(false);
				this.World.getCamera().moveTo(this.World.State.getPlayer());

				if (!this.World.State.isPaused())
				{
					this.World.setSpeedMult(this.Const.World.SpeedSettings.EscortMult);
				}

				this.World.State.m.LastWorldSpeedMult = this.Const.World.SpeedSettings.EscortMult;

				if (this.Flags.get("IsFleeing"))
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
					return;
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Destination))
				{
					if (this.Flags.get("IsCaravanHalfDestroyed"))
					{
						this.Contract.setScreen("Success2");
					}
					else
					{
						this.Contract.setScreen("Success1");
					}

					this.World.Contracts.showActiveContract();
				}
				else if (!this.Flags.get("IsEnoughCombat"))
				{
					if (this.Contract.spawnEnemies())
					{
						this.Flags.set("IsEnoughCombat", true);
					}
				}
				else
				{
					local parties = this.World.getAllEntitiesAtPos(this.World.State.getPlayer().getPos(), 400.0);
					local numParties = 0;

					foreach( party in parties )
					{
						numParties = ++numParties;
					}

					if (numParties > 2)
					{
						return;
					}

					if (this.Flags.get("IsStolenGoods") && this.World.State.getPlayer().getTile().HasRoad)
					{
						if (!this.TempFlags.get("IsStolenGoodsDialogTriggered") && this.Contract.getDistanceToNearestSettlement() >= 6 && this.Math.rand(1, 1000) <= 1)
						{
							this.TempFlags.set("IsStolenGoodsDialogTriggered", true);
							this.Contract.setScreen("StolenGoods1");
							this.World.Contracts.showActiveContract();
						}
					}
					else if (this.Flags.get("IsVampires") && !this.World.getTime().IsDaytime)
					{
						if (!this.TempFlags.get("IsVampiresDialogTriggered") && this.Contract.getDistanceToNearestSettlement() >= 6 && this.Math.rand(1, 1000) <= 2)
						{
							this.TempFlags.set("IsVampiresDialogTriggered", true);
							this.Contract.setScreen("Vampires1");
							this.World.Contracts.showActiveContract();
						}
					}
					else if (this.Flags.get("IsValuableCargo"))
					{
						if (!this.TempFlags.get("IsValuableCargoDialogTriggered") && this.Contract.getDistanceToNearestSettlement() >= 6 && this.Math.rand(1, 1000) <= 1)
						{
							this.TempFlags.set("IsValuableCargoDialogTriggered", true);
							this.Contract.setScreen("ValuableCargo1");
							this.World.Contracts.showActiveContract();
						}
					}
					else if (this.Flags.get("IsPrisoner"))
					{
						if (!this.TempFlags.get("IsPrisonerDialogTriggered") && this.Contract.getDistanceToNearestSettlement() >= 6 && this.Math.rand(1, 1000) <= 1)
						{
							this.TempFlags.set("IsPrisonerDialogTriggered", true);
							this.Contract.setScreen("Prisoner1");
							this.World.Contracts.showActiveContract();
						}
					}
				}
			}

			function onCombatVictory( _combatID )
			{
				this.Flags.set("IsEnoughCombat", true);

				if (_combatID == "StolenGoods")
				{
					this.Flags.set("IsStolenGoods", false);
					this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).addPlayerRelation(this.Const.World.Assets.RelationAttacked, "杀了一些他们的人");
				}
				else if (_combatID == "Vampires")
				{
					this.Flags.set("IsVampires", false);
				}

				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Flags.set("IsEnoughCombat", true);
				this.Flags.set("IsFleeing", true);
				this.Flags.set("IsStolenGoods", false);
				this.Flags.set("IsVampires", false);

				if (_combatID == "StolenGoods")
				{
					this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).addPlayerRelation(this.Const.World.Assets.RelationAttacked, "攻击了他们的一些人");
				}

				if (this.Contract.m.Caravan != null && !this.Contract.m.Caravan.isNull())
				{
					this.Contract.m.Caravan.die();
					this.Contract.m.Caravan = null;
				}

				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getType() == this.Const.EntityType.CaravanDonkey && _actor.getWorldTroop() != null && _actor.getWorldTroop().Party.getID() == this.Contract.m.Caravan.getID())
				{
					this.Flags.set("IsCaravanHalfDestroyed", true);
				}
				else
				{
					this.Contract.addKillCount(_actor, _killer);
				}
			}

			function end()
			{
				this.World.State.setCampingAllowed(true);
				this.World.State.setEscortedEntity(null);
				this.World.State.getPlayer().setVisible(true);
				this.World.Assets.setUseProvisions(true);

				if (!this.World.State.isPaused())
				{
					this.World.setSpeedMult(1.0);
				}

				this.World.State.m.LastWorldSpeedMult = 1.0;

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
				}

				this.Contract.clearSpawnedUnits();
			}

		});
		this.m.States.push({
			ID = "Running_Prisoner",
			function start()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
				}

				if (this.Contract.m.NobleSettlement != null && !this.Contract.m.NobleSettlement.isNull())
				{
					this.Contract.m.NobleSettlement.getSprite("selection").Visible = true;
				}

				this.Contract.m.BulletpointsObjectives = [
					"将%noble%安全护送到%nobledirection%方的%noblesettlement%。"
				];
				this.Contract.m.BulletpointsPayment = [];
				this.Contract.m.BulletpointsPayment.push("到达时获得报酬");
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.NobleSettlement))
				{
					if (this.Flags.get("IsPrisonerLying"))
					{
						this.Contract.setScreen("Prisoner4");
					}
					else
					{
						this.Contract.setScreen("Prisoner3");
					}

					this.World.Contracts.showActiveContract();
				}
			}

		});
	}

	function createScreens()
	{
		this.importScreens(this.Const.Contracts.NegotiationPerHeadAtDestination);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "谈判",
			Text = "[img]gfx/ui/events/event_98.png[/img]{%employer%的书房被温暖的炉火照亮。他请你坐下，并递给你一杯酒，两个你都接受了。%SPEECH_ON%佣兵，你知道现在的道路有多危险吧？%SPEECH_OFF%天哪，这酒真不错。你点点头，试图掩饰你的惊讶。%employer%简单地笑了一下继续道。%SPEECH_ON%很好，那你就会明白我交给你的任务了。我需要让一个商队被沿路护送至%objective%，大概离这%days%的路程。很简单，对吧？你有时间吗？有就让我们谈谈。%SPEECH_OFF% | 你发现%employer%正研读着几张他办公桌上的地图。他的手指滑到其中一张的边缘并继续行进到另一张上。%SPEECH_ON%我需要给商队找些护卫去%objective%，从这往%direction%大概%days%的路程。危险吗？当然。因此我才找你，佣兵。有兴趣吗？%SPEECH_OFF% | %employer%噘着嘴叉起手。%SPEECH_ON%通常来说我不会找佣兵来护送商队，但我的老伙计们有点不在状态——病了、醉了、嫖了……我想你懂的。重要的是我有重要货物要去%objective%，大概从这往%direction%走上%days%，而且我需要些人照看它。你有兴趣吗？%SPEECH_OFF% | %employer%凝视着窗外，看到一群人把货物装进几辆马车。他开口时没有看你。%SPEECH_ON%我有一份重要货物要去%objective%，从这往%direction%大概%days%的路程。不幸的是，一个竞争者在招募本地商队护卫出价更高。现在我需要你的服务。如果你感兴趣我们就谈谈价钱。%SPEECH_OFF% | %employer%从架子上拿起一个箱子放在桌子上。当他打开它时，一堆文件蹦了出来，几乎是急着要挣脱出来。他抓住一张并把它摊开。一面是一份合同，另一面是一张小地图。%SPEECH_ON%活很简单，佣兵。我承包了些……特别的货物要去%objective%。我有货，但我没有卫兵。如果你有兴趣当会儿商队护卫，可能%days%左右，请告诉我，我们好谈谈价钱。%SPEECH_OFF% | 你从%employer%的窗户向外望，看着人们把货物装上几辆马车。%employer%端着两杯酒走了过来。你拿上一杯并一口饮尽。那男人盯着你。%SPEECH_ON%那可不便宜。你本应该好好享受它的。%SPEECH_OFF%你耸耸肩。%SPEECH_ON%抱歉。能再给我一杯让我再好好地喝一次吗？%SPEECH_OFF%%employer%转身走向他的书桌。%SPEECH_ON%好了，我有一支商队需要被护送到%objective%。离这往%direction%大概%days%的路程。很简单，对吧？如果你有兴趣，给你的克朗可不少。%SPEECH_OFF% | %employer%看着他的几本书，细阅着上面的大量数字。%SPEECH_ON%我有一批特殊的货物要运往%objective%，他们很快就要出发了。我需要一群强壮的剑士来确保它安全到达那里。应该要花你大约%days%的时间。你有兴趣干吗？%SPEECH_OFF% | %employer%开门见山。%SPEECH_ON%我有一批……额，那是什么跟你没关系。它要被送到%objective%。并且，像许多人一样，我担心路上的强盗。我需要你照看着商队并确保它在大约%days%内安全到达。你听着有兴趣吗？%SPEECH_OFF% | %employer%向窗外望去。%SPEECH_ON%我们都知道强盗和各种神才知道的玩意在威胁着这片地方，而且他们都很喜欢在大路上搞事情。在经历了一次非常糟糕的运输后，我的老商队护卫们失去了继续工作的勇气。现在我需要其他人来看管我的货物。下一趟是往%direction%去%objective%，从这里出发大概要走%days%。那听起来像是个你愿意被雇去的地方吗？%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{谈谈价钱吧。 | 多大的生意？ | 报酬如何？}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{不感兴趣。 | 这不是我们要找的工作。}",
					function getResult()
					{
						this.World.Contracts.removeContract(this.Contract);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "TaskSouthern",
			Title = "谈判",
			Text = "[img]gfx/ui/events/event_98.png[/img]{在嵌套着塔楼和鸟笼的城市里，钟声和鸟鸣回响于空气中，宛如被囚禁的城市内部发出的紧张终始曲。在噪音的背后，宫殿的暗淡大理石大厅中，你看见%employer%正在下命令处死一名仆人。你不知道那人的罪过是什么，虽然这也丝毫不影响维齐尔，他笑着走近你，双手干净。%SPEECH_ON%几个议员有些货物要去%objective%，大概要往%direction%走上%days%。这些商品必须以能让等待的商人接受的状态送达。我相信像你这样的逐币者可以干好这活，对吗？%SPEECH_OFF% | 你碰上了这里的维齐尔%employer%手下的几个议员和市政官。他们拿着一份盖着他徽章的文件走近你。%SPEECH_ON%我们很快就要前往%objective%，带着一车队的货。城市的卫兵拒绝帮助我们护送我们的货物，然而我们在镀金者的眼眸下依然光鲜亮丽，口袋里也满是光芒。我们将给你报酬，逐币者，你要在接下来的%days%里帮助我们到达目的地。%SPEECH_OFF% | 一个男孩侍从一只手牵着一串奴隶，另一只手拿着一张纸条。他展示了后者，上面写着会见一群商人的指示。他们声称要去%objective%，大约要往%direction%走上%days%，这是镀金者和维齐尔之流的命令，并且需要保护。为此，你的服务是必要的，并且将得到相当可观的报酬。 | 城镇的商业广场上生意兴隆，而且显然的，你被希望参与其中。几个维齐尔“最优秀”的小贩想要组织一队商队去%objective%，大概要走上%days%。其中一人简洁地解释道。%SPEECH_ON%如果镀金者能转过视线，我祈求这个城镇所谓的‘士兵’们消失于黯淡之地。你，逐币者，我怀疑你愿意向我们提供他人不提供的帮助？当然，有报酬。%SPEECH_OFF% | 你看着奴隶们把货物打包装载到一系列的马车上。商队的主人看到了你并找了过来，一路推开或捶打手下的劳工 —— 除了给自己带来某种未知快乐外没有任何理由。其中一人满溢着欣喜向你问好。他伸出一只手，但你没有握它。%SPEECH_ON%啊，逐币者，确实这手被负债者的皮肉玷污了，但你不必如此害羞。在镀金者的目光下我们都闪闪发亮，不是吗？我们有个活给你，一件出于我们宗主%employer%的缘由有些重要的活。商队正要去往%objective%，大概要走上%days%，而且需要一定数量的护卫，以确保其安全到达。这份工作是否符合你逐币的兴致？%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{谈谈价钱吧。 | 多大的生意？ | 报酬如何？}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{不感兴趣。 | 这不是我们要找的工作。}",
					function getResult()
					{
						this.World.Contracts.removeContract(this.Contract);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "StolenGoods1",
			Title = "在路上……",
			Text = "[img]gfx/ui/events/event_78.png[/img]{一群举着 %noblehouse% 旗帜的人出现在了路上。 他们的马停在一边，缰绳插在地上。 看起来他们在等你。 其中一人走上前，叉着腰。%SPEECH_ON%你在运输赃物，朋友。 属于 %noblehouse% 的赃物。立刻交过来或者承担后果。%SPEECH_OFF%哼，你该想到 %employer% 运的货有问题的。 | 几个人走上了马路。 他们带着 %noblehouse% 的旗帜，这恐怕不是什么好消息。 他们的军官走上前来。%SPEECH_ON%欢迎！不幸的是，你在运的是 %noblehouse% 被盗的赃物。站商队一边，转身，并哪来回哪去。 照做，你就能活。 留下来，这里今天就是你的葬身之地。%SPEECH_OFF% | 霍，看起来 %employer% 对你有所隐瞒：一群举着 %noblehouse% 旗帜的士兵正在质问你怎么在护送从他们那里偷来的货物。 他们的军官向你们喊道。%SPEECH_ON%如果你想见到明天的太阳，把货交过来并原路返回。 我理解你们只是打工的。 然而，你的工作不包括反抗我。 如果那么做的话，我保证，你们今天都要死在这里。%SPEECH_OFF% | 一个人出来走到路上并且看起来不准备移开。 其中一个车夫拉起缰绳，他这么做的同时，一大群武装人员加入了刚才孤身站在路上的人。 他们带着的纹章是 %noblehouse%。%SPEECH_ON%所以，这就是 %noblehouse%的货跑去的地方。 你们正在运输属于我们的贵族家族的货物。 如果你想活，把它们都交过来。 如果你想死，那，就不要这么做看看会发生什么。%SPEECH_OFF%%randombrother% 走到你身边，耳语道。%SPEECH_ON%我们就不该相信那个鼠辈 %employer%。%SPEECH_OFF% | 你真的应该多问问你在运什么的。 一群人在路上跟你搭上了话，要求你把商队交过去并原路返回。 当你询问起是谁在提出要求时，他们声称来自 %noblehouse% 而且你正运的货是一个星期前从他们那里偷来的。 他们的军官给出了安全通过的选项。%SPEECH_ON%放下那么就能活。 我跟你们没有矛盾，只跟你们的委托人有。 不过，你要是阻碍我们的行动那么你就得死。 不要为了不属于你的货物送死。 这不值得。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Banner = "",
			Options = [
				{
					Text = "我不这么认为。 如果必要我们会保护它。",
					function getResult()
					{
						return "StolenGoods2";
					}

				},
				{
					Text = "我们可没拿够报酬去跟 %noblehouse% 作对。拿走吧。",
					function getResult()
					{
						return "StolenGoods3";
					}

				}
			],
			function start()
			{
				this.Banner = this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).getUIBannerSmall();

				if (this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).getPlayerRelation() >= 80)
				{
					this.Options.push({
						Text = "你的领主不会愿意他的盟友，%companyname%，被这样拖延。",
						function getResult()
						{
							return "StolenGoods4";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "StolenGoods2",
			Title = "在路上……",
			Text = "[img]gfx/ui/events/event_78.png[/img]{你点了点头。%SPEECH_ON%听起来不错，但不幸的是我们收了钱来保护这些货物，不是弄明白它们属于谁。%SPEECH_OFF%军官同样点了点头，几乎是在表示理解。%SPEECH_ON%那么好吧。%SPEECH_OFF%他拔出他的剑。 你抽出你的。 他举起手，准备发号施令。%SPEECH_ON%很遗憾得变成这样。冲锋！%SPEECH_OFF% | 你拔出你的剑。%SPEECH_ON%我来这不是给贵族家族间谈判的。 我来这是要护送这商队到 %objective%。如果你想要阻挠，那么，是的，有些人今天就要死在这里了。%SPEECH_OFF% | 你向排成一条的载重货车甩了甩手。%SPEECH_ON%%employer%的命令是让我护送他的货物到目的地。 那也正是我打算做的。%SPEECH_OFF%看着军官，你慢慢地拔出你的了剑。 他也同样，点头说道。%SPEECH_ON%很遗憾，事情得发展成这样。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Banner = "",
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos(), true);
						p.CombatID = "StolenGoods";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.IsAutoAssigningBases = false;
						p.TemporaryEnemies = [
							this.Contract.m.NobleHouseID
						];
						p.EnemyBanners = [
							this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).getPartyBanner()
						];

						foreach( e in p.Entities )
						{
							if (e.Faction == this.Contract.getFaction())
							{
								e.Faction = this.Const.Faction.PlayerAnimals;
							}
						}

						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.m.NobleHouseID);
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
				this.Banner = this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "StolenGoods3",
			Title = "在路上……",
			Text = "[img]gfx/ui/events/event_78.png[/img]{%employer% 不会乐于见到这样，但如果他在运的是赃物他应该告诉你的。 一个响指，你命令你的人站到一边去。 士兵们马上向商队靠拢，卸载起货物，另一边倒霉的临时工和商人只能看着。 | 你可不会为了不在乎的货物来场恶战。 站到一边，你邀请士兵们来拿走属于他们的货物。%randombrother% 说 %employer% 不会乐于知道的。你点头。%SPEECH_ON%那是他的问题。%SPEECH_OFF% | 你可不想掺和进运输赃物或杀害无冤无仇的士兵。 尽管几个商人的反对，你站到了一边，放任商队和货物回到它的主人手里。 其中一个商人挥舞着拳头，告诉你 %employer% 知道你没有遵守合同将会非常愤怒。}",
			Image = "",
			List = [],
			Banner = "",
			Options = [
				{
					Text = "真不走运。",
					function getResult()
					{
						this.Flags.set("IsStolenGoods", false);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "没能保护好商队");
						this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).addPlayerRelation(this.Const.World.Assets.RelationNobleContractPoor, "与他们的士兵合作");
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.updateAchievement("NeverTrustAMercenary", 1, 1);
				this.Banner = this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "StolenGoods4",
			Title = "在路上……",
			Text = "[img]gfx/ui/events/event_78.png[/img]{你告诉他们你是 %noblehouse% 的好朋友并且无意破坏这关系。 其中一个攻击者停了下来。%SPEECH_ON%可恶，他可能在撒谎，但如果没有…这不值得冒险。 让我们离开这里。%SPEECH_OFF% | 几句简要的话语，你告诉这些人你跟 %noblehouse% 家族很熟悉，叫出了几位贵族的名字。 他们收起剑，无意进一步扩大局势。 在这个世界上，安全总比遗憾好。 | 你让他们知道你与 %noblehouse% 家族关系不错。 他们要求你给出证据，而你通过告诉他们每个你知道的贵族名字，还有他们中一些人的一点小癖好。 证据足够令人信服－攻击者放下了武器并离开了。}",
			Image = "",
			List = [],
			Banner = "",
			Options = [
				{
					Text = "我们继续前进！",
					function getResult()
					{
						this.Flags.set("IsStolenGoods", false);
						return 0;
					}

				}
			],
			function start()
			{
				this.Banner = this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "ValuableCargo1",
			Title = "露营时……",
			Text = "[img]gfx/ui/events/event_55.png[/img]{商队休息时，%randombrother%拉着你的手臂，偷偷地把你带到其中一辆马车的后面。他四处张望，确保没人看见，然后打开箱子的盖子。宝石在里面晃动，在微弱的光线下闪闪发光。他关上了盖子。%SPEECH_ON%有什么想法吗？那可是好大一笔，先生。%SPEECH_OFF% | 当商队停下来修轮子时，一个车轴崩掉使得载重货车侧倾。一只板条箱哗啦一声落在地上，盖子震开了。你拿上一把锤子准备去把它钉上，这时你注意到一些宝石从盒子里溢了出来。%randombrother%也看到了，并把手放在他的武器上。%SPEECH_ON%那是，额，东西声音还挺大，先生。我们应该闷不吭声还是……？%SPEECH_OFF% | 商队头领突开始尖叫。你看着他追赶并迅速抓住一个试图逃跑的人。两个人扭打着摔到地上，一阵肢体的龙卷风，从中飞出来一个褐色的包。它掉在你的脚边，宝石从它打开的开口射出。%randombrother%蹲下身捡起来几个。他站直身板，另一只手放在武器上。他凝视着你。%SPEECH_ON%这里有很多可以，你知道的，所以值得……%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "在我打你之前回去工作。我们有一份合同要履行。",
					function getResult()
					{
						this.Flags.set("IsValuableCargo", false);
						return 0;
					}

				},
				{
					Text = "终于，幸运向我们微笑了。我们把这些宝石据为己有！",
					function getResult()
					{
						return "ValuableCargo2";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ValuableCargo2",
			Title = "露营时……",
			Text = "[img]gfx/ui/events/event_50.png[/img]{以为商队护卫走过来。%SPEECH_ON%嗨伙计，让我们回到正路上，好吗？%SPEECH_OFF%你向你的雇佣兵点头。 他点头回应，然后快速的转身一匕首刺穿了护卫的面颊。 战团其余人，意识到在发生什么，很快拔出他们的武器并扑向了卫队。 他们毫无胜算，当血雨腥风告一段落时，你成为了这些优质宝石的新主人。 | 宝石的力量征服了你！ 一串快速的点头及号令，你下令让 %companyname% 杀光了所有的护卫。 事办的很快，看看他们是如何信任你会帮助他们的，几个人直到死仍在问着为什么要如此残忍的背叛他们。 | 这些宝石可比任何合同能给你的有价值多了。 尽可能大声地喊起来，你命令 %companyname% 杀掉所有卫兵。 他们动作很快，毫无质疑，而护卫们还很缓慢并且疑惑。 没过多久你就拥有了宝石。%employer% 不会感到高兴，但让他见鬼去吧，你现在手里有宝石了。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "这些应该值很多克朗。",
					function getResult()
					{
						this.Flags.set("IsValuableCargo", false);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationBetrayal, "屠杀了一个负责保护的商队");
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
						this.World.Assets.addMoralReputation(-10);
						this.Contract.m.Caravan.die();
						this.Contract.m.Caravan = null;
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				local n = this.Math.min(this.Math.max(1, this.World.Assets.getBusinessReputation() / 1000), 3) + 1;

				for( local i = 0; i != n; i = ++i )
				{
					local gems = this.new("scripts/items/trade/uncut_gems_item");
					this.World.Assets.getStash().add(gems);
					this.List.push({
						id = 10,
						icon = "ui/items/" + gems.getIcon(),
						text = "你获得了" + gems.getName()
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Prisoner1",
			Title = "在路上……",
			Text = "[img]gfx/ui/events/event_53.png[/img]{跟着商队行进，你遇到了几个卫兵向一个笼子里吐口水。 一个人被关在里面，穿着破布，脚底满是泥土。 他投过浓郁的仇恨看到你并恳求道。%SPEECH_ON%求你了，佣兵！我的名字是 %noble% 来自 %noblehouse%。你杀了所有这些人，你会得到最大的奖赏！%SPEECH_OFF%其中一个卫兵笑道。%SPEECH_ON%不要相信他的谎言，雇佣兵。%SPEECH_OFF% | 你走过了一辆载重货车，突然什么东西抓住你的手臂。 你转过身，手里拿着剑，抓你的手缩回了载重货车底的黑暗中。 小心地，你掀起油布看到一个人被拷在那里。 他听起来很害怕，好似他的第一句话更应该是恳求点水。%SPEECH_ON%不要在意我身上的破布，雇佣兵，我是 %noble% 来自 %noblehouse%。杀光那些卫兵，解救我，并确保我到家。 我将确保你得到合适的报偿。%SPEECH_OFF%一个卫兵打断了他，囚犯缩回到他的藏身处。卫兵笑道。%SPEECH_ON%那个小杂种又在撒谎吗？ 走吧，雇佣兵，我们还有很长段路要走。%SPEECH_OFF% | 你从其中一辆载重货车中听到声干呕。 调查一下，你发现了一个衣衫褴褛的人，蜷缩着，顶上一个卫兵坏笑着。%SPEECH_ON%再那样跟我说话你就要拉出你的牙齿了。明白吗，囚犯？%SPEECH_OFF%被击倒的人点头并往后缩。 他看到了你，微弱地点了点头。%SPEECH_ON%佣兵，我是 %noble% 来自 %noblehouse%。我相信你听过我的名号。 如果你在这里杀了这个狗杂种和他的所有同党，那么我会确保你得到最丰厚的回报。%SPEECH_OFF%卫兵紧张地笑道。%SPEECH_ON%不要相信他一个字，佣兵！%SPEECH_OFF% | %SPEECH_ON%雇佣兵！我能说上一句吗？%SPEECH_OFF%你转身，惊讶地发现一个人在其中一辆载重货车的后部里。 他被锁链拷着。%SPEECH_ON%我想让你知道我是 %noble% 来自 %noblehouse%。显然我遇到了点麻烦，但那挡不住你，对吧？ 杀光这些卫兵并带我回家。 我想他们会给你的比给看管这狗屎商队的多得多。%SPEECH_OFF%其中一个卫兵走过来，笑道。%SPEECH_ON%唔，那杂碎又在撒谎了？ 别理他，佣兵。 来吧，回到工作上。%SPEECH_OFF% | 你听到了锁链独特的响声，链接伸展产生的脆弱声音，金属发出的令人误以为他们可以轻松逃脱的窃笑。 与之相对，一个非常不自由的人向你恳求道。%SPEECH_ON%终于，我能跟你说上话了。 佣兵，看一下，你可能不相信，但我是 %noble% 来自 %noblehouse%。我不知道为什么这些人抓了我，但那不重要。 重要的是你的名副其实，特别是“佣”的那部分。 如果你杀光这些卫兵并带我回家，我保证你会得到丰厚的报酬！%SPEECH_OFF%一个卫兵走过来。%SPEECH_ON%安静点你个狗杂种！ 不要在意他，雇佣兵。 我们还有工作要做，走吧。%SPEECH_OFF% | 在商队短暂休息时，你发现了个人腿摆在载重货车底上歇息。 特别的是他的双脚并不自由－它们被锁链捆在一起而且他的手臂也没好到哪里去。他看到了你。%SPEECH_ON%你认识我吗？我是 %noble% 来自 %noblehouse%，一个有些价值的俘虏，如同我的名号所暗示的。 但我自由后会更有价值。 杀掉这些卫兵，带我回家，你得到的克朗将会塞到你走不动路！%SPEECH_OFF%一个卫兵走过来并用剑鞘扇了他胫部一下。%SPEECH_ON%你，安静！来吧，佣兵，我们准备要再次上路了。 并且不要信这个杂种的话，好吗？ 他除了谎言没什么可以给你的。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "别白费口舌了。我才不管你是谁。",
					function getResult()
					{
						this.Flags.set("IsPrisoner", false);
						return 0;
					}

				},
				{
					Text = "这最好值得。 救了你得记得信守承诺。",
					function getResult()
					{
						this.updateAchievement("NeverTrustAMercenary", 1, 1);
						return "Prisoner2";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Prisoner2",
			Title = "在路上……",
			Text = "[img]gfx/ui/events/event_60.png[/img]{你吐了口口水清清嗓子，然后你很快地拔剑出鞘并击倒了商队护卫。%randombrother% 看到了后快速的喊出条命令好让 %companyname% 其余的伙计们跟上。 一场短暂，迷惑的乱战，商队护卫在你的手下动手时都不确定在发生什么。\n\n 解放了犯人后，他不胜感激并提出让你带路。%SPEECH_ON%一旦我们到达 %noblesettlement%，并且让他们看到我充满活力的笑脸，你就能在克朗里洗澡了！%SPEECH_OFF% | 你拔出你的剑，砍到卫兵的脸上。 他转了个身，你用你的刀锋击碎他的脑壳，他的脑浆在倾斜的硬骨片之间起泡，就像一个爆裂的蛋奶酥。%randombrother% 看到后叫上战团其余人也加入战斗 他们很快便解决了剩下的商队护卫。 你释放了 %noble% 后，他指向路上。%SPEECH_ON%到 %noblesettlement%，到那我的家人会赏给你难以置信的奖赏！%SPEECH_OFF% | 当商队护卫转身时，你拿出一把匕首，插在他的腋窝下，直接刺入他的心脏。 他咕哝着什么，然后瘫在了地上。 另一个守卫过来，看到这，然后看到你的剑把他开膛破肚。 他的哭喊传了出去。 一场战斗迅速的展开了，短时间内 %companyname% 一边倒地解决了所有的商队护卫。\n\n 当一切尘埃落地，%noble% 被放了出来。 搓着他发紫的手腕，他将你指向 %noblesettlement%。%SPEECH_ON%前进吧，带我回我家人身边，我会为你这非凡的勇气填满你的口袋的！%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我已经可以看到我的口袋装满克朗了！",
					function getResult()
					{
						this.Flags.set("IsPrisoner", false);
						this.Flags.set("IsPrisonerLying", this.Math.rand(1, 100) <= 33);
						this.Contract.setState("Running_Prisoner");
						this.World.State.setCampingAllowed(true);
						this.World.State.getPlayer().setVisible(true);
						this.World.Assets.setUseProvisions(true);

						if (!this.World.State.isPaused())
						{
							this.World.setSpeedMult(1.0);
						}

						this.World.State.m.LastWorldSpeedMult = 1.0;
						this.Contract.m.Caravan.die();
						this.Contract.m.Caravan = null;
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationAttacked, "屠杀了一个负责保护的商队");
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
						this.World.Assets.addMoralReputation(-5);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Prisoner3",
			Title = "在%noblesettlement%",
			Text = "[img]gfx/ui/events/event_31.png[/img]{你抵达了 %noblesettlement%。一个全副武装的卫兵看到了 %noble% 然后喊出了一道命令，命令快速地被传到镇里。 很快，几匹马跑了过来，他们的骑手快速地下马。 到头看来他没有在撒谎。%noblehouse% 如同囚犯许诺的一样奖赏了你。 | 在你能进入 %noblesettlement% 前，几个骑手从中出来迎接你。 他们背后有贵族服饰在随风飘荡。 同样，一大部重装卫队就在不远处跟着。 没什么好寻思的，特别是看着他们快速地欢迎那位囚犯回到他们中间。 其中一个人从热烈欢迎回家的狂热中回来，把你的奖赏交给你。 他们很少对那些出身卑微却要为出身高贵的人出头负责的人说些别的。哦好吧。 | 囚犯没有撒谎，但你很快就得到了一份茶点，以保持你在社会中的地位：一个全副武装的警卫递给你奖励。 尽管你营救了他们的一位血亲，看起来 %noblehouse% 并不想亲自跟你说话。事实就是这样。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "至少报酬不错。",
					function getResult()
					{
						this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).addPlayerRelation(this.Const.World.Assets.RelationFavor, "释放了一个被囚禁的贵族家族成员");
						this.World.Assets.addMoney(3000);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你将获得[color=" + this.Const.UI.Color.PositiveValue + "]3000[/color]克朗"
				});
				this.List.push({
					id = 10,
					icon = "ui/icons/relations.png",
					text = "你与" + this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).getName() + "改进"
				});
			}

		});
		this.m.Screens.push({
			ID = "Prisoner4",
			Title = "在%noblesettlement%",
			Text = "[img]gfx/ui/events/event_31.png[/img]{当你接近%noblesettlement%时，%noble%窜到了一些灌木后。%SPEECH_ON%劳驾，朋友们，我有点屎要拉。%SPEECH_OFF%你点头并等了会。然后又等了会。又再等了会后。意识到自己的错误，你匆忙跑到灌木丛后面，却发现那个人已经彻底消失了，而你的鞋沾上了粪便。 | %noble% 要求你停下来。 他跳到了一条溪流里。%SPEECH_ON%等会，伙计。让我弄干净点以免我的家族看到我这邋遢样！%SPEECH_OFF%有道理。你放他一个人去洗，但当你回来看看他时他已经跑了。 泥巴脚印引向一个山丘，你跟着它们。 在另一边展露出来一片农夫的田地以及浓厚的庄稼，任何骗子都能轻易地溜走。%randombrother% 跟到了你身边。%SPEECH_ON%操蛋。%SPEECH_OFF%真操蛋。 | 去 %noblesettlement% 的路上有几个农民。它们正在互相剪头发，而且这看起来也吸引了 %noble%。%SPEECH_ON%劳驾，兄弟，我得打理打理。 可不想让老夫人看到我这个样子，你懂的。%SPEECH_OFF%你点头并去检查货物以度时间。 当你回到农民们那里时你问那个贵族去哪里了。 其中一位看着你。%SPEECH_ON%我没见过什么贵族。%SPEECH_OFF%你解释道他穿着破布，然后快速地描述了他。他们耸耸肩。%SPEECH_ON%我看到那个家伙跑到那边的田地里去了，然后骑上了匹马，再然后骑的越来越远了。 我们还觉得他脑子有点问题，因为看他整个过程都在笑。%SPEECH_OFF%愤怒到气炸。 | 你把 %noble% 带到了 %noblesettlement%。他在你进入城镇时几乎在颤抖。%SPEECH_ON%啊，我只是有点紧张。%SPEECH_OFF%没有一个卫兵认的出他，但那可以理解，特别是他穿成这样的个状态。 你走上前到了一个装备非常精良的人边并让他找来个贵族。 他向你倾过身来，几乎没有偏离他站岗的位置。%SPEECH_ON%那么我该报上谁的名字？%SPEECH_OFF%你转身想指。%SPEECH_ON%嗯，是…那个…额…%SPEECH_OFF%%noble% 不见了。你环顾一圈。%randombrother%的注意力被一个女人吸走了，其余的战团成员都在闲逛。 一大群居民熙熙攘攘地来往着，一片骗子能轻易消失的灰幕。 你的手握紧成拳头。 卫兵将你推后。%SPEECH_ON%如果你没有要务，那么我得要求你离开此地，不然我们就得动武了。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "该死！",
					function getResult()
					{
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Vampires1",
			Title = "在路上……",
			Text = "[img]gfx/ui/events/event_33.png[/img]{商队停下来歇息时，你听到了声异响，像有人咬了口苹果并且在吮吸汁水一般。 绕过一辆货车的后端，你看到了一个苍白的身影蹲在一位死掉的商队护卫边，那奇怪生物的利齿深深的嵌入了那人的脖子。 你可以看到血肉因啃咬而被带起，浑身是血的生物咧着嘴饮着。\n\n 拔出剑，你大声呼喊起你的雇佣兵。%SPEECH_ON%肮脏的野兽！拿起武器，伙计们！%SPEECH_OFF% | 一个箱子的盖子晃来晃去。 你看了会它，并与一位商队护卫交换了下眼神。%SPEECH_ON%你们这是在运狗吗？%SPEECH_OFF%突然，盒盖爆开，大量的碎片在一股巨大，愤怒的力量下乱飞。 呻咛着，一个生物从箱子中站起，双臂抱在胸前。 面色苍白，皮肤紧绷且冰冷。那是…一个…\n\n 商队护卫逃开喊道。%SPEECH_ON%货物逃出来了！ 货物逃出来了！%SPEECH_OFF%货物？为什么会有人敢叫这种恐怖之物“货物”？ | 你看到一个商队护卫从一个盒子中举起了一只猫。 那小家伙蹬着腿喵喵叫，想找到个落脚点，愤怒地踢着周围想挠把它举起来的东西。 感到点兴趣，你询问起这个人在做什么。 他耸耸肩，抬起箱盖并把猫丢了进去。%SPEECH_ON%喂食。%SPEECH_OFF%猫尖叫起来，它猫科动物的咆哮声跟它的反抗一样尖锐，但很快你什么都听不到了。 正在商队护卫转身离开盒子，它的盖子爆开，一个苍白的生物从中升起，几乎无形般移动着，并将它的双臂围绕在那人身上。 它将它的獠牙刺入他的脖子。 护卫的脖子泛出紫色，然后快速地开始消散，他的青筋在额头上暴起好似在试图帮助他的血液逃离吸食。\n\n 退后几步，你拔出剑并警告了你的人这新发现的恐怖。 | 休息时，一个年轻的商队护卫几乎摸到了你背后。%SPEECH_ON%嗨佣兵，想看点东西吗？%SPEECH_OFF%你有空而且这份空闲已经让你感到无聊了，所以没错，你当然想找点乐子。 他带你到其中一辆货车边并抬起一箱子上的盖子。 一个苍白的身形在里面，手臂抱在胸前，它面孔毫无无血色，紧绷着维持着种睡眠的姿态。 你吓到后跳一步，因为那不是什么寻常尸体。 商队护卫笑起来。%SPEECH_ON%怎么了，你被死人吓到了？%SPEECH_OFF%就在这时，那生物的手臂从中射出，抓住那小子并把它拽到了箱子里。 你没有浪费时间试图去救那蠢货，赶快跑去召集能打的兄弟，于此同时，一路上更多的盒子不停的在你周围崩开。 | 停留在路边休息，你听到了声恐怖的惨叫从车队末端某处传来。 拔出剑，你快速跑向了声源。 一个商队护卫蹒跚着走过你，抱着他的脖子。 他的眼睛大大睁开，他的嘴巴冻住般僵住艰难地说。%SPEECH_ON%它们出来了！它们出来了！%SPEECH_OFF%另一个护卫跑过，都没有想过停下来帮助其他人。 你向前方看去，看到一群苍白的身影在护卫们间跳跃，黑色的斗篷笼罩住它们的猎物以将他们盖入残忍的死亡。 在他们能接触到你之前，你转身跑去警告了战团这股恐怖的威胁。 | 在车队休息时，你散散步来检查货车以确保一切都还规矩。 不过最后一辆载重货车倾斜到了土里，它的驮兽躺在泥地里。 附近有两个死掉的护卫。 他们的皮肤惨白，但姿势却还很鲜活。 将你的目光上移，你看到了群脸上全是血的生物弯腰蹲在车上，而且他们嘴里挂着人！\n\n%randombrother% 跑到你身后，武器在手，并将你推到后方。%SPEECH_ON%去警告伙计们，头！%SPEECH_OFF%这应该是这时候最好的主意了。 你尽可能大地喊叫，好唤来其余的伙计们加入战斗。 | 你抽空去撒尿时一声可怕的尖叫打断了你。 穿上衣服，你转身跑去查看。 在那里你看到了一个商队护卫面朝前摔倒，他的双腿交叉地绊倒了他自己之后一头栽在了地上。 在他身后，一个苍白的生物正在擦去它嘴边的血。 另一边的载重货车上箱子正在被打开，煞白的身影从它们中立起，双眼里闪烁着嗜血的光芒。\n\n 你看到得已经足够让你赶紧跑去警告伙计们了。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "保护商队！",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos(), true);
						p.CombatID = "Vampires";
						p.Music = this.Const.Music.UndeadTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Vampires, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
						this.World.Contracts.startScriptedCombat(p, false, false, false);
						return 0;
					}

				},
				{
					Text = "快逃命吧！快跑！快跑！",
					function getResult()
					{
						this.Contract.m.Caravan.die();
						this.Contract.m.Caravan = null;
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "没能保护好商队");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "在%objective%",
			Text = "[img]gfx/ui/events/event_04.png[/img]{抵达%objective%后，商队队长转向你，手里拿着一个大包。%SPEECH_ON%谢谢护送我们到这里，佣兵。%SPEECH_OFF%你接下它并把它交给%randombrother%来数。他数完后点了点头。商队头领露出了微笑。%SPEECH_ON%也谢谢你没有背叛我们并，你懂的，杀光我们所有人之类的。%SPEECH_OFF%佣兵总会以最奇怪的方式得到感谢。 | 到达%objective%后，商队的载重货车立刻开始卸下他们的货物并运到附近的一座仓库。当一切都搬完了后，商队的领头人交给你一背包克朗并谢谢你保护他们一路上的安全。 | 在%objective%迎接你的是一大群正在找工作的日结工。商队头领到处给人发克朗，人们脏兮兮的手很快开始着手装卸货物。在处理完人群后，头领转向了你。他手里拿着个小包。%SPEECH_ON%而这是给你的，佣兵。%SPEECH_OFF%你拿上它。几个日结工像猫盯着晃来晃去的老鼠一样，观看着金钱的交换。 | 你做到了，你像答应%employer%的一样，护送商队到了目的地。商队头领拿出克朗交给你以示感谢。他似乎非常感激自己还活着，并简要地向你讲述了他惊险逃过强盗伏击的经历。你点点头表示你对这个人身上发生的事情毫不在乎。 | 马车队驶入%objective%，每一辆的轮子都颠簸驶过干燥的泥堆。商队成员们开始卸载货物，其中几个人还得应付几个乞丐的纠缠。领头的交给你一个背包，这就是他所做的一切。他工作太忙了，不能和你多说。这份沉默是受欢迎的。 | 到了%objective%，商队头领突然开始跟你说话，仿佛你们之间可能有共同之处。他谈论起他年轻的时候，那时候他还是个活跃的小年轻，本能够干点这个那个的。他，很显然，错过了很多的战斗。真遗憾。厌倦了他的谈话，你要求他支付你的报酬，这样你就可以离开这个讨厌的地方了。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "受之无愧。",
					function getResult()
					{
						local money = this.Contract.m.Payment.getOnCompletion() + this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected");
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(money);

						if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getType() == this.Const.FactionType.OrientalCityState)
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "按照承诺保护了一支商队");
						}
						else if (this.Flags.get("IsStolenGoods"))
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess * 2.0, "保护了一个商队的赃物");
						}
						else
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "按照承诺保护了一支商队");
						}

						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				local money = this.Contract.m.Payment.getOnCompletion() + this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected");
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color]克朗"
				});
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/well_supplied_situation"), 3, this.Contract.m.Destination, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "在%objective%",
			Text = "[img]gfx/ui/events/event_04.png[/img]{你不得不思考像 %objective% 这样的个地方是否值得冒生命危险。 你确实到了地方，但不是每辆货车都到了。 车队领头的走过来带这个稍许轻些的袋子。%SPEECH_ON%我本会给你更多的，佣兵，因为我知道在这个世界完美来之不易，但 %employer% 坚持让我做点减法，毕竟…嗯，我们的损失。你肯定能理解的？%SPEECH_OFF%他看起来害怕你会报复他，但你只是拿上钱走了。生意就是生意。 | 到了 %objective%，商队头领转身找到你，手里拿着个袋子。%SPEECH_ON%它比你想的要轻点。%SPEECH_OFF%确实。他继续道。%SPEECH_ON%不是每辆货车都到了。%SPEECH_OFF%他们没有。%SPEECH_ON%我只是 %employer% 的信使。请不要杀我。%SPEECH_OFF%你不会的。尽管…算了。 | 到了 %objective%，车队的领头让工人们开始卸载货物。 他们少了几个人，还有几辆货车。 拿着报酬向你走过来，领头的解释起来。%SPEECH_ON%%employer% 要求我按照到达的货物付钱。 不幸的是，我们丢失了一些…%SPEECH_OFF%你点头拿上了报酬。 毕竟，协议就是协议。 | 商队的领头在到达 %objective% 时看起来都要哭了。他说他这一路失去了不少好弟兄，而且遗失的那些货车对他们的未来影响巨大。 你不在乎，但你点了个头以示同情。%SPEECH_ON%我想不论如何我得谢谢你，佣兵。 毕竟，我们还活着。 不幸的是…我只能付你这么多。这是 %employer% 的要求，任何损失都要从你的报酬里扣。%SPEECH_OFF%你再次点头并拿上了你所能挣到的报酬。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "事情不太顺利…",
					function getResult()
					{
						local money = this.Contract.m.Payment.getOnCompletion() + this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected");
						money = this.Math.floor(money / 2);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(money);

						if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getType() == this.Const.FactionType.OrientalCityState)
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractPoor, "保护了一个商队，尽管很糟糕");
						}
						else if (this.Flags.get("IsStolenGoods"))
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractPoor * 2.0, "保护了一个商队的赃物, albeit poorly");
						}
						else
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractPoor, "保护了一个商队，尽管很糟糕");
						}

						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				local money = this.Contract.m.Payment.getOnCompletion() + this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected");
				money = this.Math.floor(money / 2);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color]克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "战斗之后",
			Text = "[img]gfx/ui/events/event_60.png[/img]{你在一些商队队员和几个商人的陪伴下开始了旅程，他们都信任你。现在，他们的尸体散布在地上，手臂张开，苍蝇在手指上飞舞。太阳将令你的失败弥漫出毁灭的气味。是时候继续前行了。 | 载重货车倾倒在一边。人与肢体四散着。废墟中传来一声呻吟，但那是垂死的呻吟，因为你再也没有听到过。黑影在草地上荡漾，头顶上是一群越来越多的秃鹰。最好让它们尽情享受，因为在这里你没有什么可做的了。 | 雇你的商人死在了你脚下。他不完全是面朝下，因为他的那部分已经不存在了。血液喷洒在地面上，你不禁盯着自己失败的总结。你的一个手下发现了他身体有些抽搐，但你很清楚，已经无法挽救。商队里其他人的状况更糟糕。留在这里毫无意义。 | 战斗了却，但你看到商人倚在一辆翻覆的载重货车上。他睁大眼睛，绝望地抓着被割开的脖子。血从他的指间喷涌而出，你还没来得及做任何事情，他就倒下了。你试图救活他，但为时已晚。无光的双眼向上看着你。%randombrother%，你的一个手下，在收拾商队的残骸之前关合上了他的双眼。 | 你在残留的货车残骸中踉跄着。很容易看出：商人的头被某种箱子砸坏了，可能正是他在激战中寻求保护的东西。可惜，商队的其他人也没有好受多少。即使以你的标准来看，这场战斗也是残酷的，而随之而来的大屠杀也让你的一些兄弟难以接受。如果噩梦来临，就让它们来吧。对于你的失败而言，那是自找的。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "该死！",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);

						if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getType() == this.Const.FactionType.OrientalCityState)
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "没能保护好商队");
						}
						else
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "没能保护好商队");
						}

						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function addKillCount( _actor, _killer )
	{
		if (_killer != null && _killer.getFaction() != this.Const.Faction.Player && _killer.getFaction() != this.Const.Faction.PlayerAnimals)
		{
			return;
		}

		if (this.m.Flags.get("HeadsCollected") >= this.m.Payment.MaxCount)
		{
			return;
		}

		if (_actor.getXPValue() == 0)
		{
			return;
		}

		if (_actor.getType() == this.Const.EntityType.GoblinWolfrider || _actor.getType() == this.Const.EntityType.Wardog || _actor.getType() == this.Const.EntityType.Warhound || _actor.getType() == this.Const.EntityType.SpiderEggs || this.isKindOf(_actor, "lindwurm_tail"))
		{
			return;
		}

		if (!_actor.isAlliedWithPlayer() && !_actor.isResurrected())
		{
			this.m.Flags.set("HeadsCollected", this.m.Flags.get("HeadsCollected") + 1);
		}
	}

	function spawnCaravan()
	{
		local faction = this.World.FactionManager.getFaction(this.getFaction());
		local party;

		if (faction.hasTrait(this.Const.FactionTrait.OrientalCityState))
		{
			party = faction.spawnEntity(this.m.Home.getTile(), "贸易商队", false, this.Const.World.Spawn.CaravanSouthernEscort, this.m.Home.getResources() * this.Math.rand(10, 25) * 0.01);
		}
		else
		{
			party = faction.spawnEntity(this.m.Home.getTile(), "贸易商队", false, this.Const.World.Spawn.CaravanEscort, this.m.Home.getResources() * 0.4);
		}

		party.getSprite("banner").Visible = false;
		party.getSprite("base").Visible = false;
		party.setMirrored(true);
		party.setDescription("一支来自" + this.m.Home.getName() + "的贸易商队，在定居点之间运输各种各样的货物。");
		party.setMovementSpeed(this.Const.World.MovementSettings.Speed * 0.6);
		party.setLeaveFootprints(false);

		if (this.m.Home.getProduce().len() != 0)
		{
			for( local j = 0; j != 3; j = ++j )
			{
				party.addToInventory(this.m.Home.getProduce()[this.Math.rand(0, this.m.Home.getProduce().len() - 1)]);
			}
		}

		party.getLoot().Money = this.Math.rand(0, 100);
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(this.m.Destination.getTile());
		move.setRoadsOnly(true);
		local unload = this.new("scripts/ai/world/orders/unload_order");
		local despawn = this.new("scripts/ai/world/orders/despawn_order");
		local wait = this.new("scripts/ai/world/orders/wait_order");
		wait.setTime(4.0);
		c.addOrder(move);
		c.addOrder(unload);
		c.addOrder(wait);
		c.addOrder(despawn);
		this.m.Caravan = this.WeakTableRef(party);
	}

	function spawnEnemies()
	{
		local tries = 0;
		local myTile = this.m.Destination.getTile();
		local tile;

		while (tries++ == 0)
		{
			local tile = this.getTileToSpawnLocation(myTile, 7, 11);

			if (tile.getDistanceTo(this.World.State.getPlayer().getTile()) <= 6)
			{
				continue;
			}

			local nearest_bandits = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getNearestSettlement(tile);
			local nearest_goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(tile);
			local nearest_orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(tile);
			local nearest_barbarians = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians) != null ? this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getNearestSettlement(tile) : null;
			local nearest_nomads = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits) != null ? this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getNearestSettlement(tile) : null;

			if (nearest_bandits == null && nearest_goblins == null && nearest_orcs == null && nearest_barbarians == null && nearest_nomads == null)
			{
				this.logInfo("没有找到敌人的基地");
				return false;
			}

			local bandits_dist = nearest_bandits != null ? nearest_bandits.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local goblins_dist = nearest_goblins != null ? nearest_bandits.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local orcs_dist = nearest_orcs != null ? nearest_bandits.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local barbarians_dist = nearest_barbarians != null ? nearest_barbarians.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local nomads_dist = nearest_nomads != null ? nearest_nomads.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local party;
			local origin;

			if (bandits_dist <= goblins_dist && bandits_dist <= orcs_dist && bandits_dist <= barbarians_dist && bandits_dist <= nomads_dist)
			{
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).spawnEntity(tile, "强盗", false, this.Const.World.Spawn.BanditRaiders, this.Math.rand(80, 100) * this.getDifficultyMult() * this.getScaledDifficultyMult());
				party.setDescription("一支粗暴而强悍的强盗队伍在捕食弱者。");
				party.setFootprintType(this.Const.World.FootprintsType.Brigands);
				party.getLoot().Money = this.Math.rand(50, 100);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 2);
				party.getLoot().Ammo = this.Math.rand(0, 20);
				local r = this.Math.rand(1, 6);

				if (r == 1)
				{
					party.addToInventory("supplies/bread_item");
				}
				else if (r == 2)
				{
					party.addToInventory("supplies/roots_and_berries_item");
				}
				else if (r == 3)
				{
					party.addToInventory("supplies/dried_fruits_item");
				}
				else if (r == 4)
				{
					party.addToInventory("supplies/ground_grains_item");
				}
				else if (r == 5)
				{
					party.addToInventory("supplies/pickled_mushrooms_item");
				}

				origin = nearest_bandits;
			}
			else if (goblins_dist <= bandits_dist && goblins_dist <= orcs_dist && goblins_dist <= barbarians_dist && goblins_dist <= nomads_dist)
			{
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).spawnEntity(tile, "地精掠袭者", false, this.Const.World.Spawn.GoblinRaiders, this.Math.rand(80, 100) * this.getDifficultyMult() * this.getScaledDifficultyMult());
				party.setDescription("一群捣蛋的地精，小而狡猾，不可低估。");
				party.setFootprintType(this.Const.World.FootprintsType.Goblins);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 2);
				party.getLoot().Ammo = this.Math.rand(0, 30);
				local r = this.Math.rand(1, 4);

				if (r == 1)
				{
					party.addToInventory("supplies/strange_meat_item");
				}
				else if (r == 2)
				{
					party.addToInventory("supplies/roots_and_berries_item");
				}
				else if (r == 3)
				{
					party.addToInventory("supplies/pickled_mushrooms_item");
				}

				origin = nearest_goblins;
			}
			else if (barbarians_dist <= goblins_dist && barbarians_dist <= bandits_dist && barbarians_dist <= orcs_dist && barbarians_dist <= nomads_dist)
			{
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).spawnEntity(tile, "野蛮人", false, this.Const.World.Spawn.Barbarians, this.Math.rand(80, 100) * this.getDifficultyMult() * this.getScaledDifficultyMult());
				party.setDescription("一支野蛮部落的战团。");
				party.setFootprintType(this.Const.World.FootprintsType.Barbarians);
				party.getLoot().Money = this.Math.rand(0, 50);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 5);
				party.getLoot().Ammo = this.Math.rand(0, 30);

				if (this.Math.rand(1, 100) <= 50)
				{
					party.addToInventory("loot/bone_figurines_item");
				}

				if (this.Math.rand(1, 100) <= 50)
				{
					party.addToInventory("loot/bead_necklace_item");
				}

				local r = this.Math.rand(2, 5);

				if (r == 2)
				{
					party.addToInventory("supplies/roots_and_berries_item");
				}
				else if (r == 3)
				{
					party.addToInventory("supplies/dried_fruits_item");
				}
				else if (r == 4)
				{
					party.addToInventory("supplies/ground_grains_item");
				}
				else if (r == 5)
				{
					party.addToInventory("supplies/pickled_mushrooms_item");
				}

				origin = nearest_barbarians;
			}
			else if (nomads_dist <= barbarians_dist && nomads_dist <= goblins_dist && nomads_dist <= bandits_dist && nomads_dist <= orcs_dist)
			{
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).spawnEntity(tile, "游牧民", false, this.Const.World.Spawn.NomadRaiders, this.Math.rand(80, 100) * this.getDifficultyMult() * this.getScaledDifficultyMult());
				party.setDescription("一群沙漠掠袭者，狩猎任何试图穿越沙海的人。");
				party.setFootprintType(this.Const.World.FootprintsType.Nomads);
				party.getLoot().Money = this.Math.rand(50, 200);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 2);
				party.getLoot().Ammo = this.Math.rand(0, 20);
				local r = this.Math.rand(1, 4);

				if (r == 1)
				{
					party.addToInventory("supplies/bread_item");
				}
				else if (r == 2)
				{
					party.addToInventory("supplies/dates_item");
				}
				else if (r == 3)
				{
					party.addToInventory("supplies/rice_item");
				}
				else if (r == 4)
				{
					party.addToInventory("supplies/dried_lamb_item");
				}

				origin = nearest_nomads;
			}
			else
			{
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).spawnEntity(tile, "兽人掳掠者", false, this.Const.World.Spawn.OrcRaiders, this.Math.rand(80, 100) * this.getDifficultyMult() * this.getScaledDifficultyMult());
				party.setDescription("一群凶狠的兽人，绿皮肤，高过所有人。");
				party.setFootprintType(this.Const.World.FootprintsType.Orcs);
				party.getLoot().ArmorParts = this.Math.rand(0, 25);
				party.getLoot().Ammo = this.Math.rand(0, 10);
				party.addToInventory("supplies/strange_meat_item");
				origin = nearest_orcs;
			}

			party.getSprite("banner").setBrush(origin.getBanner());
			party.setAttackableByAI(false);
			party.setAlwaysAttackPlayer(true);
			local c = party.getController();
			local intercept = this.new("scripts/ai/world/orders/intercept_order");
			intercept.setTarget(this.World.State.getPlayer());
			c.addOrder(intercept);
			this.m.UnitsSpawned.push(party.getID());
			return true;
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		local days = this.getDaysRequiredToTravel(this.m.Flags.get("Distance"), this.Const.World.MovementSettings.Speed * 0.6, true);
		_vars.push([
			"objective",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.m.Destination.getName()
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Destination.getTile())]
		]);
		_vars.push([
			"noblehouse",
			this.World.FactionManager.getFaction(this.m.NobleHouseID).getName()
		]);
		_vars.push([
			"noble",
			this.m.Flags.get("NobleName")
		]);
		_vars.push([
			"noblesettlement",
			this.m.NobleSettlement == null || this.m.NobleSettlement.isNull() ? "" : this.m.NobleSettlement.getName()
		]);
		_vars.push([
			"nobledirection",
			this.m.NobleSettlement == null || this.m.NobleSettlement.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.NobleSettlement.getTile())]
		]);
		_vars.push([
			"killcount",
			this.m.Flags.get("HeadsCollected")
		]);
		_vars.push([
			"days",
			days <= 1 ? "1天" : days + "天"
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.World.State.setCampingAllowed(true);
			this.World.State.setEscortedEntity(null);
			this.World.State.getPlayer().setVisible(true);
			this.World.Assets.setUseProvisions(true);

			if (!this.World.State.isPaused())
			{
				this.World.setSpeedMult(1.0);
			}

			this.World.State.m.LastWorldSpeedMult = 1.0;

			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
			}

			if (this.m.NobleSettlement != null && !this.m.NobleSettlement.isNull())
			{
				this.m.NobleSettlement.getSprite("selection").Visible = false;
			}
		}
	}

	function onIsValid()
	{
		if (this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive() || !this.m.Destination.isAlliedWith(this.getFaction()))
		{
			return false;
		}

		return true;
	}

	function onIsTileUsed( _tile )
	{
		if (this.m.Destination != null && !this.m.Destination.isNull() && _tile.ID == this.m.Destination.getTile().ID)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		if (this.m.Destination != null && !this.m.Destination.isNull())
		{
			_out.writeU32(this.m.Destination.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		if (this.m.Caravan != null && !this.m.Caravan.isNull())
		{
			_out.writeU32(this.m.Caravan.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		_out.writeU32(this.m.NobleHouseID);
		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		local caravan = _in.readU32();

		if (caravan != 0)
		{
			this.m.Caravan = this.WeakTableRef(this.World.getEntityByID(caravan));
		}

		this.m.NobleHouseID = _in.readU32();

		if (!this.m.Flags.has("Distance"))
		{
			this.m.Flags.set("Distance", 0);
		}

		if (!this.m.Flags.has("HeadsCollected"))
		{
			this.m.Flags.set("HeadsCollected", 0);
		}

		this.contract.onDeserialize(_in);

		if (this.m.Flags.has("NobleSettlement"))
		{
			local e = this.World.getEntityByID(this.m.Flags.get("NobleSettlement"));

			if (e != null)
			{
				this.m.NobleSettlement = this.WeakTableRef(e);
			}
		}
	}

});
