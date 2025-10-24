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

					this.Contract.m.BulletpointsObjectives.push("每杀死一个袭击者就可以得到一笔报酬（%killcount%/%maxcount%）");
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
					this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).addPlayerRelation(this.Const.World.Assets.RelationAttacked, "攻击了一些他们的人");
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
			Text = "[img]gfx/ui/events/event_98.png[/img]{%employer%的书房烧着暖融融的炉火。他请你坐下，并递给你一杯酒，两个你都接受了。%SPEECH_ON%佣兵，你也知道如今这路上有多危险吧？%SPEECH_OFF%诸神在上，这酒可真不错。你点点头，努力掩饰自己的惊叹。%employer%淡淡一笑，继续说道。%SPEECH_ON%很好，那你就能理解我给你的这个任务了。我需要你沿路护送一支商队至%objective%，离这大概%days%的路程。很简单，对吧？你有空接吗？有的话我们就谈谈细节。%SPEECH_OFF% | 你看到%employer%正在研究桌案上的几幅地图。他的手指从一幅地图的边缘划过，又延续到另一幅上。%SPEECH_ON%我需要有人护送一支商队到%objective%，在这里的%direction%方向约%days%路程。会有危险吗？当然。所以我才找你，佣兵。有兴趣吗？%SPEECH_OFF% | %employer%抱起双臂，抿紧了嘴唇。%SPEECH_ON%通常我不会找佣兵来护卫商队，但我常用的那帮人现在有点靠不住——病了、醉了、嫖了……我想你懂的。重要的是，我有重要货物要运往%objective%，大概从这往%direction%边走上%days%，我需要有人照看它。有兴趣吗？%SPEECH_OFF% | %employer%凝视着窗外，看着一群人往几辆货车上装载货物。他头也不回地对你说。%SPEECH_ON%我有一批重要货物要送往%objective%，从这往%direction%大概%days%的路程。不幸的是，有个竞争对手出价比我高，抢走了本地的一支商队护卫。现在我需要你的服务。如果有兴趣，我们谈谈价钱。%SPEECH_OFF% | %employer%从架子上取下一个箱子放在桌上。一打开，一堆文件就弹了出来，反复是在争先恐后地逃散。他抓住一张并摊开。一面是一份合同，另一面是一张小地图。%SPEECH_ON%很简单，佣兵。我接了份合同，要运送一些……特别的货物去%objective%。货我有，但护卫我没有。如果你有兴趣临时当会儿商队护卫，大概%days%左右，告诉我，我们可以敲定具体报酬。%SPEECH_OFF% | 你望着%employer%的窗外，看着人们往几辆货车上装货。%employer%拿着两杯酒走到你身边。你接过一杯一饮而尽。他盯着你看。%SPEECH_ON%这酒可不便宜。你应该细细品尝。%SPEECH_OFF%你耸耸肩。%SPEECH_ON%抱歉。能再来一杯让我再好好地品尝一下吗？%SPEECH_OFF%%employer%转身走向他的书桌。%SPEECH_ON%那么，我需要人手来护送一支商队到%objective%。在%direction%方向，大约%days%路程。很简单，对吧？如果你有兴趣，报酬绝对丰厚。%SPEECH_OFF% | %employer%翻看着一些账本，浏览着上面大量的数字。%SPEECH_ON%我有一批特殊货物要运往%objective%，很快就要出发了。我需要一群可靠的剑客帮忙确保货物安全抵达。路上大概要花%days%时间。你能接吗？%SPEECH_OFF% | %employer%开门见山地说。%SPEECH_ON%我有一批……嗯，具体是什么与你无关。它要运往%objective%，而且和许多人一样，我担心路上的土匪。我需要你照看商队，确保它在大约%days%内安全无恙地到达。听着有兴趣吗？%SPEECH_OFF% | %employer%望向窗外。%SPEECH_ON%我们都知道强盗，还有天知道什么别的玩意儿在这片地方横行，而且他们都特别喜欢在路上找麻烦。经过一次特别糟糕的行程后，我之前的商队护卫们都没了继续干下去的心思。现在我需要别人来照看我的货。下一批货要运往%direction%方向的%objective%，离这儿大概%days%路程。愿意去那边一趟吗？%SPEECH_OFF%}",
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
					Text = "{不感兴趣。 | 我们不想接这类差事。}",
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
			Text = "[img]gfx/ui/events/event_98.png[/img]{钟声与鸟鸣回荡在塔楼和禽舍之间，如同这座受困城市奏响的即兴乐章。在这喧嚣之下，宫殿沉闷的大理石厅堂里，你看到%employer%正在下令处死一名仆人。你不知道那仆人犯了什么罪，不过这位维齐尔也丝毫不以为意，他带着微笑，双手干净地走向你。%SPEECH_ON%几位议员正有一批货物要送往%objective%，在%direction%方向约%days%路程。这些货物必须完好无损地交到等候的商人手中。我相信像你这样的逐币者能负责这项任务，对吧？%SPEECH_OFF% | 你见到了当地维齐尔%employer%手下的几位议员和市府参事。他们拿着一份盖有他徽章的文件向你走来。%SPEECH_ON%我们很快将带着一商队货物出发前往%objective%。城市卫队拒绝协助我们保护货物，然而我们在镀金者眼中依然闪耀，口袋里也满是金光。我们会付钱给你，逐币者，雇你在接下来的%days%里护送我们到达目的地。%SPEECH_OFF% | 一个侍童一手牵着串在一起的奴隶，另一手拿着一张便条。他递上便条，上面写着指示，让你与一队商人会面。他们宣布，奉镀金者和维齐尔之命，他们将前往%objective%，大约在%direction%方向%days%路程的地方，并且需要保护。为此，我们需要你的服务，并将支付相当丰厚的报酬。 | 镇上的商人广场熙熙攘攘，显然，他们希望你也能参与其中。维齐尔手下几位“最优秀”的商贩想将一队货物运往%objective%，路程约有%days%。其中一人简短地解释道。%SPEECH_ON%如果镀金者愿意睁只眼闭只眼，我祈祷镇上那些所谓的‘士兵’都坠入阴影世界。你嘛，克朗林，我想在别人都不肯帮忙的时候，你会愿意帮我们一把吧？当然，有报酬。%SPEECH_OFF% | 你看着奴隶们捆扎货物并装上一排马车上。商队的主人发现了你，便找了过来，一边把干活的奴隶推开或者无缘无故地掌掴他们——似乎这么做能带来某种莫名的快感。其中一人笑容满面地招呼你。他伸出一只手，但你没有握。%SPEECH_ON%啊，逐币者，诚然这手被负债者的皮肉玷污了，但你不必如此害羞。在镀金者的注视下我们都闪耀如金，不是吗？我们有个任务交给你，是奉我们的宗主%employer%治理之名，颇为重要。商队要前往%objective%，足有%days%路程，需要相当可靠的护卫才能安然抵达。这个任务符合你追求克朗的兴趣吧？%SPEECH_OFF%}",
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
					Text = "{不感兴趣。 | 我们不想接这类差事。}",
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
			Text = "[img]gfx/ui/events/event_78.png[/img]{一队打着%noblehouse%旗帜的人出现在路上。他们的马匹拴在路边，缰绳扎在土里。看来他们一直在等你们。其中一人双手叉腰，迈步上前。%SPEECH_ON%你们在运输赃物，朋友们。这些货物原属于%noblehouse%。立刻交出来，否则后果自负。%SPEECH_OFF%嗯，你早该知道%employer%运送的东西有问题。 | 几个人走到路中央。他们举着%noblehouse%的旗帜，这恐怕不是什么好兆头。他们的头目向你们全体喊话。%SPEECH_ON%问候诸位！不幸的是，你们运输的货物是偷自%noblehouse%的赃物。从商队旁边让开，调头，原路返回。照做，你们就能活命。留下，你们今天就会死在这里。%SPEECH_OFF% | 嚯，看来%employer%对你有所隐瞒：一队举着%noblehouse%旗帜的士兵正在质问你们怎么在运送从他们那偷来的货物。 他们的军官向你们喊道。%SPEECH_ON%如果你想见到明天的太阳，把货交过来并原路返回。 我理解你们只是打工的。 然而，你的工作不包括违抗我。 要是敢违抗，我保证，你们今天全得死在这里。%SPEECH_OFF% | 一个人走到路中央，丝毫没有要让开的意思。一个商队车夫猛地拉紧缰绳，就在这时，一大群其他武装人员跟上了刚才孤身站在路上的人。 他们带着的是%noblehouse%的纹章。%SPEECH_ON%所以，%noblehouse%的货物是到这儿来了。你们这帮家伙在运输属于我们贵族家族的货物。想活命，就把东西全交出来。想找死，嗯，就别照我说的做，看看会发生什么。%SPEECH_OFF%%randombrother%走到你身边，低声说。%SPEECH_ON%我们真不该相信%employer%那鼠辈。%SPEECH_OFF% | 你真的应该多问问你在运什么的。一伙人在路上拦住了你们，要求你们交出商队并原路返回。当你询问究竟是谁提出这个要求时，他们声称来自%noblehouse%，并且你们运输的每一件货物都是一周前被盗的。他们的军官明确给出了平安离开的选择。%SPEECH_ON%离开，你们就能活命。我对你们这些人没有芥蒂，只针对你们的雇主。但是，如果你们在这里阻碍我们收回失物，那你们就得死。别为不属于你们的货物送命。这不值得。%SPEECH_OFF%",
			Image = "",
			List = [],
			Banner = "",
			Options = [
				{
					Text = "我觉得不行。如果有必要我们会保护它。",
					function getResult()
					{
						return "StolenGoods2";
					}

				},
				{
					Text = "他们给的报酬可不是让我们和%noblehouse%作对的。拿走吧。",
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
						Text = "你的领主看到他们的盟友——%companyname%——被这样阻拦，肯定不会高兴。",
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
			Text = "[img]gfx/ui/events/event_78.png[/img]{你点了点头。%SPEECH_ON%那听起来倒是不错，但不幸的是，我们收钱是为了保护这些货物，而不是来搞清楚它们属于谁。%SPEECH_OFF%军官同样点了点头，几乎像是表示理解。%SPEECH_ON%那好吧。%SPEECH_OFF%他拔出了剑。你也拔出了你的。那人举起手，准备下令。%SPEECH_ON%搞到这步田地真是遗憾。冲锋！%SPEECH_OFF% | 你拔出了剑。%SPEECH_ON%我不是来给贵族家族之间当说客的。我来这里是为了护送这支商队去%objective%。如果你们想要阻挠，那么没错，有些人今天就要死在这里了。%SPEECH_OFF% | 你朝那排货车一挥手。%SPEECH_ON%%employer%命令我把他的货物护送到目的地。我正打算这么做。%SPEECH_OFF%你盯着军官，缓缓拔剑出鞘。他也在点头后做了同样的事。%SPEECH_ON%非得走到这一步，真是遗憾。%SPEECH_OFF%",
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
			Text = "[img]gfx/ui/events/event_78.png[/img]{%employer%不会乐于见到这个结果的，但如果他运送的是赃物，他本该告诉你。你手一挥，命令手下让到一边。士兵们立刻围向商队，开始卸货，倒霉的日工和商人们只能眼睁睁看着。 | 你才不想为一些你根本不在乎的货物拼个你死我活。你让到一边，任由士兵们取回本属于他们的货物。%randombrother%说%employer%对此肯定不会高兴。你点了点头。%SPEECH_ON%嗯，那是他的问题。%SPEECH_OFF% | 你既不干运输赃物的勾当，也不想杀那些跟你无冤无仇的士兵。你不顾几个商人的抗议，侧身让开，任由商队和货物物归原主。一个商人挥舞着拳头，告诉你%employer%知道你未能履行合同后肯定会极其不满。}",
			Image = "",
			List = [],
			Banner = "",
			Options = [
				{
					Text = "真不走运。",
					function getResult()
					{
						this.Flags.set("IsStolenGoods", false);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "未能保护好商队");
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
			Text = "[img]gfx/ui/events/event_78.png[/img]{你告诉这些人，你和他们的%noblehouse%是好朋友，无意破坏这层关系。一名袭击者闻言迟疑了。%SPEECH_ON%该死，他可能在撒谎，但万一不是……这麻烦不值得惹。我们撤。%SPEECH_OFF% | 你用几句简短的话告诉这些人，你对%noblehouse%家族相当熟悉，并点出了几位家族成员的名字。这些人收起了剑，不希望把事情进一步复杂化。在这个世界上，小心总比后悔好。 | 你告诉这些人你与%noblehouse%家族关系良好。他们要求你证明，你便说出了所有你能记起的贵族名字，还略微提及了其中几位的特殊癖好。证据足够充分——袭击者们放下了武器，不再为难你。}",
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
			Text = "[img]gfx/ui/events/event_55.png[/img]{商队休息时，%randombrother%拉着你的手臂，偷偷地把你带到其中一辆马车的后面。他四处张望，确保没人看见，然后掀开一个盒子的盖子。里面是一堆宝石，在微弱的光线下闪闪发光。他关上了盖子。%SPEECH_ON%有什么想法吗？那可是好大一笔钱，长官。%SPEECH_OFF% | 商队停下修理车轮时，一根车轴断裂，货车猛地侧翻在地。一个板条箱哐当一声掉在地上，箱盖震开了。你抓起锤子正准备把它钉回去，却注意到许多宝石从箱子里散落出来。%randombrother%也看见了，他一只手按在了武器上。%SPEECH_ON%这，呃，可是批特别扎眼的货啊。我们应该闷不吭声还是……？%SPEECH_OFF% | 商队头领突然尖叫。你看着他追赶并迅速扑倒一个试图逃跑的男人。两人旋转扭打着摔倒在地，如同四肢构成的旋风，一个棕色袋子从中飞了出来。袋子落在你脚边，宝石从松开的袋口迸射出来。%randombrother%俯身捡起几颗。他直起身，另一只手已经按在武器上。他盯着你。%SPEECH_ON%这些东西的价格，你懂的，值得……%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "赶紧回去干活。我们还有合约要履行。",
					function getResult()
					{
						this.Flags.set("IsValuableCargo", false);
						return 0;
					}

				},
				{
					Text = "终于走运了。这些宝石就归我们了！",
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
			Text = "[img]gfx/ui/events/event_50.png[/img]{一名商队护卫走了过来。%SPEECH_ON%嘿弟兄们，咱们让这趟活儿继续上路，怎么样？%SPEECH_OFF%你朝你的佣兵点了点头。他也点头回应，然后迅速转身，将匕首刺入护卫的下巴。战团的其他人意识到发生了什么，迅速拔出武器扑向那些护卫。他们毫无胜算，一旦屠杀结束，你就成了那些精美宝石的新主人。 | 宝石的力量征服了你！随着点头示意和一声大喊，你命令%companyname%杀死所有护卫。过程很快，毕竟他们曾信任你来帮助他们，有几个人倒下时仍在疑惑为何会遭到如此残酷的背叛。 | 那些宝石的价值远超任何合同能给你的报酬。你尽可能大声地呼喊，命令%companyname%杀死视线内的每一个护卫。你的手下动作迅速、毫不迟疑，而护卫们则反应迟缓、困惑不解。不过片刻之后，宝石就已唾手可得。%employer%肯定不会高兴，但去他的吧，你现在有宝石了。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "这些应该值很多克朗。",
					function getResult()
					{
						this.Flags.set("IsValuableCargo", false);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationBetrayal, "屠杀了一支你受命保护的商队");
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
			Text = "[img]gfx/ui/events/event_53.png[/img]{随商队行进时，你撞见几个护卫正朝一个笼子里吐口水。里面关着个男人，衣衫褴褛，双脚沾满泥污。他发现了护卫身后的你，恳求道。%SPEECH_ON%求你了，佣兵！我是%noblehouse%的%noble%。杀了这些人，你会得到重赏！%SPEECH_OFF%一个护卫大笑起来。%SPEECH_ON%别信他的鬼话，雇佣兵。%SPEECH_OFF% | 你走过一辆货车时，突然有什么东西抓住了你的胳膊。你猛地转身，手里举着已经出鞘的剑，那只紧抓的手缩回了货车底部的黑暗中。 你小心地掀开篷布，看见一个男人被镣铐锁在那里。他的声音嘶哑可怕，仿佛他开口第一句本该是讨水喝。%SPEECH_ON%不要在意我身上的破布，雇佣兵，我是%noblehouse%的%noble%。杀光那些护卫，放了我，并送我到家。 我将确保你得到合适的报偿。%SPEECH_OFF%一个卫兵打断了他，囚犯缩回到他的容身之处。卫兵笑道。%SPEECH_ON%那个小杂种又在撒谎吗？ 走吧，雇佣兵，我们还有很长段路要走。%SPEECH_OFF% | 你听到其中一辆货车传来干呕声。循声查探，你看到一个衣衫褴褛的男人蜷缩着，头顶上一个卫兵正坏笑着。%SPEECH_ON%再用那种语气跟我说话，我就把你的牙打落让你吞进去。明白了吗，囚犯？%SPEECH_OFF%倒地那人点点头，向后挪了挪。他看见你，然后虚弱地点了点头。%SPEECH_ON%佣兵，我是%noblehouse%的%noble%。我相信你听过我的名号。如果你杀了眼前这个弱不禁风的废物和他所有的同伙，我保证你会得到最丰厚的奖赏。%SPEECH_OFF%那护卫紧张地笑了笑。%SPEECH_ON%一个字都别信他的，佣兵！%SPEECH_OFF% | %SPEECH_ON%雇佣兵！能说句话吗？%SPEECH_OFF%你转过身，惊讶地发现一辆货车的后部有个男人。他浑身缠满锁链。%SPEECH_ON%我想跟你说，我是%noblehouse%的%noble%。显然我眼下有点小麻烦，但这不会难倒你，对吧？杀了所有这些卫兵，送我回家。我想他们付的报酬，肯定会比你看守这屎一样的商队能拿到的多得多。%SPEECH_OFF%一个守卫笑着走过来。%SPEECH_ON%喂，这混蛋又在胡扯了？别理会他的胡言乱语，佣兵。来吧，咱们回去干活了。%SPEECH_OFF% | 你听到清晰的锁链声，那是链环互相撞击时发出的脆响，这声音让人以为它们能轻易地挣脱。 然而，一个被重重束缚的人却在向你哀求。%SPEECH_ON%总算能跟你说上话了。佣兵，听着，你或许不信，但我是%noblehouse%的%noble%。我不知道这些人为什么要抓我，但这不重要。重要的是你得对得起你的名号，尤其是那个‘佣’字。如果你杀了所有这些守卫，送我回家，我保证你会得到重赏！%SPEECH_OFF%一个守卫走上前来。%SPEECH_ON%给老子安静点，你这杂种！别理他，雇佣兵。我们还有活儿要干，走吧。%SPEECH_OFF% | 商队短暂休息时，你发现一个男人坐在货车边缘，一条腿从车板上垂下来。只不过他的脚并不自由——它们被锁链捆在一起，胳膊也是同样处境。他看到了你。%SPEECH_ON%你认得我吗？我是%noblehouse%的%noble%，一个颇有价值的囚犯，我相信我的姓氏已说明一切。 但我自由后的价值更大。杀了这些守卫，送我回家，你口袋里的克朗会多到让你走不动路！%SPEECH_OFF%一个守卫走过来，用刀鞘拍打那人的小腿。%SPEECH_ON%你，安静点！好了，雇佣兵，我们准备再次上路了。别理会这混蛋，行吗？他跟你说的全是鬼话。%SPEECH_OFF%",
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
					Text = "这最好值得。你得救了别忘了信守承诺。",
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
			Text = "[img]gfx/ui/events/event_60.png[/img]{你吐了口唾沫清了清嗓子，随即拔剑出鞘，瞬间砍倒了那名商队护卫。%randombrother%见状，立刻喝令其余%companyname%成员照做。 一场短暂、迷惑的乱战开始了，商队护卫们还没明白发生了什么，你的手下就已扑向他们。\n\n你释放了囚犯，他连声道谢，然后让你带路。%SPEECH_ON%一旦我们抵达%noblesettlement%，等他们看到我这张生气勃勃的笑脸，你就能在克朗里洗澡了！%SPEECH_OFF% | 你拔剑出鞘，劈向护卫的脸庞。他踉跄转身，你顺势将剑刃砸进他的头颅，脑组织在碎裂的骨片间翻涌，如同坍塌的蛋奶酥。%randombrother%目睹此景，立刻呼叫战团其余人投入战斗。他们迅速解决了剩下的商队护卫。当你释放%noble%后，他指向道路前方。%SPEECH_ON%前往%noblesettlement%，我的家族将会给予你超乎想象的重赏！%SPEECH_OFF% | 趁那商队守卫转身之际，你掏出匕首猛刺进他腋下，直贯心脏。他闷哼一声，随即倒地。另一名守卫闻声赶来，目睹此景，接着便看见你的剑剖开了他自己的肚肠。然而他的惨叫却无法被掩盖。战斗随即爆发，尽管完全一边倒——%companyname%迅速解决了所有商队守卫。\n\n 当一切尘埃落地，%noble%被放了出来。 他揉着发紫的手腕，指向%noblesettlement%的方向。%SPEECH_ON%前进，送我回到家族领地，我要用满满的财宝回报你这非凡的勇武！%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我已经看到我的口袋装满克朗了！",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationAttacked, "屠杀了一支你受命保护的商队");
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
						this.World.Assets.addMoralReputation(-5);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Prisoner3",
			Title = "%noblesettlement%里",
			Text = "[img]gfx/ui/events/event_31.png[/img]{你们抵达了%noblesettlement%。一名盔甲精良的守卫发现了%noble%，大声发出命令，这命令迅速传遍了小镇。很快，几匹马疾驰而来，骑手们迅速下马。看来这人终究没有说谎。%noblehouse%按照这名囚犯承诺的那样给予了你们报酬。 | 你们甚至还没进入%noblesettlement%，几名骑手就出来迎接你们。他们身后飘扬着皇家纹章的布料。不远处还有一大队全副武装的卫兵。无需多少猜测，他们迅速将囚犯迎回了他们的行列。其中一人从热烈的欢迎回家场面中抽身，过来将报酬交给你。对于你这个确保贵族脑袋还留在肩膀上的平民，他们没再多说什么。哦，好吧。 | 囚犯没有说谎，但你很快就被提醒了自己的社会地位：一名全副武装的卫兵将报酬递给你。尽管你救回了他们血脉中的一员，但%noblehouse%的人似乎并不想亲自与你交谈。事实就是如此。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "至少报酬不少。",
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
					text = "你获得了[color=" + this.Const.UI.Color.PositiveValue + "]3000[/color]克朗"
				});
				this.List.push({
					id = 10,
					icon = "ui/icons/relations.png",
					text = "你与" + this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).getName() + "关系改进了"
				});
			}

		});
		this.m.Screens.push({
			ID = "Prisoner4",
			Title = "%noblesettlement%里",
			Text = "[img]gfx/ui/events/event_31.png[/img]{当你们接近%noblesettlement%时，%noble%突然窜到一些灌木丛后面。%SPEECH_ON%抱歉了，朋友们，我得去拉个屎。%SPEECH_OFF%你点点头等着。等啊等。等啊等。最后你意识到自己上当了，冲到灌木丛后，却发现那人完全不见了踪影，而你的鞋上还沾上了屎。 | %noble%要求你们停下。他窜到一条溪床边。%SPEECH_ON%等一下，弟兄们。让我清理一下，免得我家人看到我这副惨状！%SPEECH_OFF%说得在理。你留他一个人处理，但当你回去查看时，他已经不见了。泥泞的脚印通向一座小山，你跟着它们。山另一面是一片长有茂密庄稼的农田，任何骗子都能轻易溜走。%randombrother%来到你身边。%SPEECH_ON%该死。%SPEECH_OFF%确实该死。 | 在通往%noblesettlement%的路上有几个农民。他们正在互相理发，这似乎吸引了%noble%的注意。%SPEECH_ON%抱歉，弟兄们，我需要打理一下。可不想让老夫人看到我这副模样，你们懂的。%SPEECH_OFF%你点点头，去清点库存打发时间。当你回到农民那里询问那贵族去哪儿时，其中一个盯着你看。%SPEECH_ON%我没见过什么贵族老爷。%SPEECH_OFF%你解释说他穿得破破烂烂的，然后快速描述了他的样子。他们耸耸肩。%SPEECH_ON%我看到那家伙跑进那边的田里，然后骑上一匹马，接着就骑向更远的地方了。我们都觉得他脑子有问题，因为他一路都在哈哈大笑。%SPEECH_OFF%你怒火中烧。 | 你将%noble%带到了%noblesettlement%。进城时他几乎在发抖。%SPEECH_ON%啊，我只是有点紧张。%SPEECH_OFF%没有卫兵认出这个人，但考虑到他的衣着状态，这很容易理解。你走向一个盔甲精良的守卫，请他叫贵族家族的人来。他微微向你转身，几乎没有偏离他站岗的位置。%SPEECH_ON%那么我该报上谁的名字？%SPEECH_OFF%你转身指向。%SPEECH_ON%呃，就是……那个……嗯……%SPEECH_OFF%%noble%已经不见踪影。你环顾四周。%randombrother%的注意力被一个乡下姑娘吸引走了，战团的其他人则在闲逛。成群结队的镇民来来往往，如同一片灰色的洪流，骗子可以轻易消失其中。你攥紧了拳头。那卫兵将你推开。%SPEECH_ON%如果你没有要务，那请你们离开此地，否则我们将强行驱逐。%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_33.png[/img]{商队停下休息时，你听到一种奇怪的声响，如同有人咬了一口苹果并吸吮汁液。绕到一辆马车末尾，你发现一个苍白的身影俯在一名死去的商队护卫身上，这怪物的獠牙深深刺入那护卫的脖颈。你能看到皮肉随着啃咬被撕扯起来，那畅饮鲜血的生物边吸食边狞笑。\n\n你拔出剑，向你的佣兵们高喊。%SPEECH_ON%邪恶的畜生！准备战斗，弟兄们！%SPEECH_OFF% | 一个箱子的盖子在晃动。你盯着它，与一名商队护卫交换了下眼神。%SPEECH_ON%你们还运狗吗？%SPEECH_OFF%突然，箱盖爆开，木屑从一股巨大而愤怒的力量源头四散飞溅。伴随着呻吟，一个生物从箱中升起，双臂交叉在胸前。它的面孔苍白，皮肤紧绷且看上去冰冷异常。那是……一个……\n\n那商队护卫逃开喊道。%SPEECH_ON%货物跑出来了！货物跑出来了！%SPEECH_OFF%货物？谁敢称这样的恐怖之物为‘货物’？ | 你看着一名商队护卫从板条箱里拎起一只猫。那猫儿悬空蹬着腿，一边喵喵叫着想找个落脚点，一边又愤怒地乱踢试图抓挠拎起它的东西。你饶有兴趣地询问那人在做什么。他耸耸肩，掀开一个箱盖把猫扔了进去。%SPEECH_ON%喂食。%SPEECH_OFF%猫尖叫起来，其嘶叫声与挣扎一样激烈，但很快你就什么也听不到了。就在那商队护卫转身准备离开箱子时，箱盖猛地打开，一个苍白的生物向上浮现，动作几乎如同无形体一般，用双臂环抱住了那人。它将獠牙刺入他的脖颈。护卫的脖颈泛起紫光，随后迅速开始消退，他额头的青筋暴起，仿佛在试图帮助他的血液逃离被吸食的命运。\n\n你向后退去，拔出剑，向你的手下们警示这新出现的恐怖妖物。 | 休息时，一个年轻的商队护卫几乎悄无声息地凑近你。%SPEECH_ON%嘿佣兵，想看点东西吗？%SPEECH_OFF%你很闲，而且闲得无聊，所以是的，你当然想看。他带你到一辆马车旁，掀开一个箱子的盖。里面是一个苍白的身影，双臂交叉在胸前，面容毫无血色，紧绷着，带着某种沉睡中的满足。你却向后跳开，因为那绝非普通的尸体。那商队护卫笑了。%SPEECH_ON%怎么，有点怕死人？%SPEECH_OFF%而就在这时，那生物的手臂猛然抬起，抓住那小子并把他拖进了箱子。你没费心去救那个白痴，而是跑去集结战团的兄弟们，与此同时，在你奔跑的途中，周围有更多的箱子砰砰打开。 | 正在路边休息时，你听到车队某处传来一声可怕的尖叫。你拔出剑，迅速冲向声源。一名商队护卫蹒跚着从你身边经过，紧捂着自己的脖子。他双眼圆睁，嘴巴惊愕地张着，说不出话来。%SPEECH_ON%它们跑出来了！它们跑出来了！%SPEECH_OFF%另一名护卫飞奔而过，甚至懒得停下来帮助同伴。你向前望去，看到一群苍白的身影在护卫间跳跃，用黑色斗篷裹住他们的受害者，将其笼罩入恐怖的死亡。在它们接近你之前，你转身跑去向战团警示这骇人的危险。 | 车队休息时，你四处检查马车，确保一切整理妥当。然而，最后一辆马车倾斜着陷在地里，拉车的牲口死在泥泞中。附近是两名死去的护卫。他们全身惨白，却保持着刚死不久的姿势。你抬头望去，发现一些满面鲜血的生物蜷伏在马车顶上，而它们嘴里正叼着悬垂的人！\n\n%randombrother%手持武器来到你身后，将你向后推。%SPEECH_ON%我们去提醒大家，长官！%SPEECH_OFF%这在眼下算是能想到的最好主意了。你尽可能大声呼喊，召集你其余的部下投入战斗。 | 你去小解时，一声可怕的尖叫让你停了下来。整理好衣服，你转身冲向骚动处。在那里，你看到一名商队护卫双腿交叉着往前走了几步，踉跄了一下然后脸朝下摔倒。在他身后，一个苍白的生物正擦拭着嘴边的血迹。而马车上，箱子正在打开，惨白的身影从中升起，眼中充满嗜血的欲望。\n\n 你看到得已经足够让你赶紧跑去警告伙计们了。}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "未能保护好商队");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "%objective%里",
			Text = "[img]gfx/ui/events/event_04.png[/img]{抵达%objective%后，商队首领转向你，手里拿着一个大袋子。%SPEECH_ON%谢谢你护送我们到这里，佣兵。%SPEECH_OFF%你接过袋子递给%randombrother%清点。他数完后点了点头。商队首领笑了。%SPEECH_ON%也谢谢你没有背叛我们，你懂的，没有把我们全杀光了之类的。%SPEECH_OFF%雇佣兵得到的感谢总是这么奇怪。 | 到达%objective%后，商队的货车立即开始卸货，货物被运往附近的仓库。一切清空后，车队首领递给你一袋克朗，感谢你确保了他们的旅途安全。 | 你们抵达%objective%后，迎面而来的是一大群正在找工作的日结工。商队首领拿出钱分给他们，他们脏兮兮的手便伸向货车开始卸货。打发完那群人后，首领转向你。他手里拿着一个袋子。%SPEECH_ON%这是给你的，雇佣兵。%SPEECH_OFF%你接过袋子。几个日工盯着这笔交易，就像猫盯着晃来晃去的老鼠。 | 你做到了，你像答应%employer%的一样，护送商队到了目的地。商队头领拿出克朗交给你以示感谢。他似乎对自己还活着这件事相当感激，简短地给你讲了个他差点死于土匪伏击的故事。你点着头，装作好像很在乎这人的遭遇似的。 | 车队驶入%objective%，每辆马车在驶过干泥堆时都不断颠簸摇晃。商队的人手忙着卸货，其中几个还在驱赶一两个乞丐。车队首领递给你一个袋子，仅此而已。他忙于工作，没空跟你多说。这种沉默好极了。 | 抵达%objective%后，商队首领搭起话来，好像你们俩有什么共同点似的。他谈起自己年轻时的日子，那时他是个活跃的小伙子，本可以做这做那。显然，他错过了很多战斗。真遗憾。你对他的谈话感到无聊，便让他付钱给你，好让你离开这个鬼地方。}",
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
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "按照承诺成功护送了一支商队");
						}
						else if (this.Flags.get("IsStolenGoods"))
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess * 2.0, "成功护送一支运输赃物的商队");
						}
						else
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "按照承诺成功护送了一支商队");
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
			Title = "%objective%里",
			Text = "[img]gfx/ui/events/event_04.png[/img]{你不禁怀疑，像%objective%这样的地方是否值得牺牲一些性命。你们确实到了，但并非所有货车都安然抵达。车队首领向你走来，手里的钱袋比预期要轻。%SPEECH_ON%我本想多付你些，佣兵，因为我知道这世道很难面面俱到，但%employer%坚持要我根据……嗯，我们的损失来扣减。你肯定能理解吧？%SPEECH_OFF%他似乎害怕你会对他进行报复，但你只是拿了钱就走。做生意就是这样。 | 抵达%objective%后，商队首领转向你，手里拿着钱袋。%SPEECH_ON%比你想的要轻。%SPEECH_OFF%确实如此。他继续说道。%SPEECH_ON%不是每辆车都到了。%SPEECH_OFF%确实没有。%SPEECH_ON%我只是%employer%的信使。求你别杀我。%SPEECH_OFF%你不会的。虽然……算了。 | 到达%objective%后，车队首领让商队伙计开始卸货。他们少了些人手，也少了几辆货车。首领拿着报酬来到你面前，解释了情况。%SPEECH_ON%%employer%坚持要我根据实际抵达的货物来支付你。不幸的是，我们损失了一些……%SPEECH_OFF%你点点头，收下了报酬。毕竟，当初说好了的。 | 当你们抵达%objective%时，车队首领几乎要哭出来。他说他在路上失去了一些好伙计，而损失的货车在未来会让他们付出沉重代价。你并不在乎，但还是对他点了点头以示回应。%SPEECH_ON%我想我还是该谢谢你，佣兵。毕竟我们没全死光。不幸的是……我只能付你这么多了。%employer%要求所有损失都得从你的报酬里扣。%SPEECH_OFF%你再次点头，拿走了你应得的报酬。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "事情不太顺利……",
					function getResult()
					{
						local money = this.Contract.m.Payment.getOnCompletion() + this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected");
						money = this.Math.floor(money / 2);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(money);

						if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getType() == this.Const.FactionType.OrientalCityState)
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractPoor, "成功护送一支商队，尽管损失不小");
						}
						else if (this.Flags.get("IsStolenGoods"))
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractPoor * 2.0, "成功护送一支运输赃物的商队，尽管损失不小");
						}
						else
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractPoor, "成功护送一支商队，尽管损失不小");
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
			Text = "[img]gfx/ui/events/event_60.png[/img]{你启程时，身边伴随着几位商队伙计和商人，他们将性命托付于你。如今，他们的尸体散落在大地上，手臂张开，手指上苍蝇飞舞。阳光将把你的失败发酵成腐朽的气味。是时候继续前行了。 | 货车倾覆在地。人体与残肢四散着。一声呻吟从废墟中响起，但那是垂死的呻吟，因为你再也没听到后续。黑色的阴影在草场上波动，头顶上聚集的秃鹫越来越多。最好让它们饱餐一顿，因为你在此已无能为力。 | 雇佣你的商人倒毙在你脚下。他倒下的姿势不能说是面朝黄土，因为他的脸已经不复存在。血液一股股地在地面蔓延，你不由自主地凝视着这失败的最终体现。你的一名手下注意到有人抽搐了一下，但你心知肚明，你无力回天。商队的其余人状况更糟。留在这里毫无意义。 | 战斗平息了，但你发现商人靠在一辆倾覆的货车旁。他圆睁双眼，绝望地捂着被割开的脖子。血柱从他的指缝间喷射而出，不待采取任何行动，那人便瘫倒在地。你试图救活他，但为时已晚。无光的双眼向上看着你。%randombrother%，你的一名手下，在起身翻检商队的残骸前，为他合上了双眼。 | 你在货车的残骸间蹒跚而行。不难看出：商人的脑袋被某种箱子砸得凹陷下去，那或许正是他在激战中用来保护自己的东西。可惜，商队的其他人也没有好到哪里去。即使以你的标准来看，这场战斗也是残酷的，而造成的屠杀让你的一些弟兄们恶心干呕。如果噩梦要来，那就让它们来吧。你的失败只配得到这些不眠的夜晚。}",
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
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "未能保护好商队");
						}
						else
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "未能保护好商队");
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
			party = faction.spawnEntity(this.m.Home.getTile(), "贸易商队", false, this.Const.World.Spawn.CaravanSouthernEscort, this.m.Home.getResources() * this.Math.rand(10, 25) * 0.01, this.getMinibossModifier());
		}
		else
		{
			party = faction.spawnEntity(this.m.Home.getTile(), "贸易商队", false, this.Const.World.Spawn.CaravanEscort, this.m.Home.getResources() * 0.4, this.getMinibossModifier());
		}

		party.getSprite("banner").Visible = false;
		party.getSprite("base").Visible = false;
		party.setMirrored(true);
		party.setDescription("一支来自" + this.m.Home.getName() + "的贸易商队，在定居点间运送各种货物。");
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
				party.setDescription("一伙粗野凶悍的土匪，专挑弱者下手。");
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
				party.setDescription("一伙狡诈的地精，身形矮小却诡计多端，不容小觑。");
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
				party.setDescription("一支野蛮人战团。");
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
				party.setDescription("一群凶狠的兽人，绿皮肤、个头比任何人类都高。");
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
