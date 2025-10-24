this.deliver_item_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Location = null,
		RecipientID = 0
	},
	function create()
	{
		this.contract.create();
		this.m.DifficultyMult = this.Math.rand(70, 105) * 0.01;
		this.m.Type = "contract.deliver_item";
		this.m.Name = "武装押运";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		if (this.m.Home == null)
		{
			this.setHome(this.World.State.getCurrentTown());
		}

		local recipient = this.World.FactionManager.getFaction(this.m.Destination.getFactions()[0]).getRandomCharacter();
		this.m.RecipientID = recipient.getID();
		this.m.Flags.set("RecipientName", recipient.getName());
		this.contract.start();
	}

	function setup()
	{
		local settlements = this.World.EntityManager.getSettlements();
		local candidates = [];

		foreach( s in settlements )
		{
			if (s.getID() == this.m.Home.getID())
			{
				continue;
			}

			if (!s.isDiscovered() || s.isMilitary())
			{
				continue;
			}

			if (!s.isAlliedWithPlayer())
			{
				continue;
			}

			if (this.m.Home.isIsolated() || s.isIsolated() || !this.m.Home.isConnectedToByRoads(s) || this.m.Home.isCoastal() && s.isCoastal())
			{
				continue;
			}

			local d = this.m.Home.getTile().getDistanceTo(s.getTile());

			if (d < 15 || d > 100)
			{
				continue;
			}

			if (this.World.getTime().Days <= 10)
			{
				local distance = this.getDistanceOnRoads(this.m.Home.getTile(), s.getTile());
				local days = this.getDaysRequiredToTravel(distance, this.Const.World.MovementSettings.Speed, false);

				if (this.World.getTime().Days <= 5 && days >= 2)
				{
					continue;
				}

				if (this.World.getTime().Days <= 10 && days >= 3)
				{
					continue;
				}
			}

			candidates.push(s);
		}

		if (candidates.len() == 0)
		{
			this.m.IsValid = false;
			return;
		}

		this.m.Destination = this.WeakTableRef(candidates[this.Math.rand(0, candidates.len() - 1)]);
		local distance = this.getDistanceOnRoads(this.m.Home.getTile(), this.m.Destination.getTile());
		local days = this.getDaysRequiredToTravel(distance, this.Const.World.MovementSettings.Speed, false);

		if (days >= 2 || distance >= 40)
		{
			this.m.DifficultyMult = this.Math.rand(95, 105) * 0.01;
		}
		else
		{
			this.m.DifficultyMult = this.Math.rand(70, 85) * 0.01;
		}

		this.m.Payment.Pool = this.Math.max(125, distance * 4.5 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentLightMult());

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		this.m.Flags.set("Distance", distance);
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"把货运到%direction%方的%objective%，交给收件人%recipient%。走大路需要约%days%"
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
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					if (this.Contract.getDifficultyMult() >= 0.95 && this.World.Assets.getBusinessReputation() > 750 && (!this.World.Ambitions.hasActiveAmbition() || this.World.Ambitions.getActiveAmbition().getID() != "ambition.defeat_mercenaries"))
					{
						this.Flags.set("IsMercenaries", true);
					}
				}
				else if (r <= 15)
				{
					if (this.World.Assets.getBusinessReputation() > 700)
					{
						this.Flags.set("IsEvilArtifact", true);

						if (!this.World.Flags.get("IsCursedCrystalSkull") && this.Math.rand(1, 100) <= 50)
						{
							this.Flags.set("IsCursedCrystalSkull", true);
						}
					}
				}
				else if (r <= 20)
				{
					if (this.World.Assets.getBusinessReputation() > 500)
					{
						this.Flags.set("IsThieves", true);
					}
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"把货运到%direction%方的%objective%，交给收件人%recipient%。走大路需要约%days%"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Destination) && !this.Flags.get("IsStolenByThieves"))
				{
					if (this.Flags.get("IsEnragingMessage"))
					{
						this.Contract.setScreen("EnragingMessage1");
					}
					else
					{
						local isSouthern = this.Contract.m.Destination.isSouthern();

						if (isSouthern)
						{
							this.Contract.setScreen("Success2");
						}
						else
						{
							this.Contract.setScreen("Success1");
						}
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					local parties = this.World.getAllEntitiesAtPos(this.World.State.getPlayer().getPos(), 400.0);

					foreach( party in parties )
					{
						if (!party.isAlliedWithPlayer)
						{
							return;
						}
					}

					if (this.Flags.get("IsMercenaries") && this.World.State.getPlayer().getTile().HasRoad)
					{
						if (!this.TempFlags.get("IsMercenariesDialogTriggered") && this.Contract.getDistanceToNearestSettlement() >= 6 && this.Math.rand(1, 1000) <= 1)
						{
							this.Contract.setScreen("Mercenaries1");
							this.World.Contracts.showActiveContract();
							this.TempFlags.set("IsMercenariesDialogTriggered", true);
						}
					}
					else if (this.Flags.get("IsEvilArtifact") && !this.Flags.get("IsEvilArtifactDone"))
					{
						if (!this.TempFlags.get("IsEvilArtifactDialogTriggered") && this.Contract.getDistanceToNearestSettlement() >= 6 && this.Math.rand(1, 1000) <= 1)
						{
							this.Contract.setScreen("EvilArtifact1");
							this.World.Contracts.showActiveContract();
							this.TempFlags.set("IsEvilArtifactDialogTriggered", true);
						}
					}
					else if (this.Flags.get("IsEvilArtifact") && this.Flags.get("IsEvilArtifactDone"))
					{
						this.Contract.setScreen("EvilArtifact3");
						this.World.Contracts.showActiveContract();
						this.Flags.set("IsEvilArtifact", false);
					}
					else if (this.Flags.get("IsThieves") && !this.Flags.get("IsStolenByThieves") && this.World.State.getPlayer().getTile().Type != this.Const.World.TerrainType.Desert && (this.World.Assets.isCamping() || !this.World.getTime().IsDaytime) && this.Math.rand(1, 100) <= 3)
					{
						local tile = this.Contract.getTileToSpawnLocation(this.World.State.getPlayer().getTile(), 5, 10, [
							this.Const.World.TerrainType.Shore,
							this.Const.World.TerrainType.Ocean,
							this.Const.World.TerrainType.Mountains
						], false);
						tile.clear();
						this.Contract.m.Location = this.WeakTableRef(this.World.spawnLocation("scripts/entity/world/locations/bandit_hideout_location", tile.Coords));
						this.Contract.m.Location.setResources(0);
						this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).addSettlement(this.Contract.m.Location.get(), false);
						this.Contract.m.Location.onSpawned();
						this.Contract.addUnitsToEntity(this.Contract.m.Location, this.Const.World.Spawn.BanditDefenders, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						this.Const.World.Common.addFootprintsFromTo(this.World.State.getPlayer().getTile(), tile, this.Const.GenericFootprints, this.Const.World.FootprintsType.Brigands, 0.75);
						this.Flags.set("IsStolenByThieves", true);
						this.Contract.setScreen("Thieves1");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "EvilArtifact")
				{
					this.Flags.set("IsEvilArtifactDone", true);
				}
				else if (_combatID == "Mercs")
				{
					this.Flags.set("IsMercenaries", false);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "EvilArtifact")
				{
					if (this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).getType() == this.Const.FactionType.OrientalCityState)
					{
						this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "未能交付货物。");
					}
					else
					{
						this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "未能交付货物。");
					}

					this.World.Contracts.removeContract(this.Contract);
				}
				else if (_combatID == "Mercs")
				{
					if (this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).getType() == this.Const.FactionType.OrientalCityState)
					{
						this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "未能交付货物。");
					}
					else
					{
						this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "未能交付货物。");
					}

					this.World.Contracts.removeContract(this.Contract);
				}
			}

		});
		this.m.States.push({
			ID = "Running_Thieves",
			function start()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
				}

				if (this.Contract.m.Location != null && !this.Contract.m.Location.isNull())
				{
					this.Contract.m.Location.getSprite("selection").Visible = true;
				}

				this.Contract.m.BulletpointsObjectives = [
					"跟随盗贼的踪迹并找回你的货物",
					"把货运到%direction%方的%objective%，交给收件人%recipient%。走大路需要约%days%"
				];
			}

			function update()
			{
				if (this.Contract.m.Location == null || this.Contract.m.Location.isNull())
				{
					this.Contract.setScreen("Thieves2");
					this.World.Contracts.showActiveContract();
				}
			}

		});
	}

	function createScreens()
	{
		this.importScreens(this.Const.Contracts.NegotiationDefault);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "谈判",
			Text = "[img]gfx/ui/events/event_112.png[/img]{没等你或他开口，%employer%就把一个不小的板条箱塞进你手里。%SPEECH_ON%瞧瞧，我要送的货这已经找到了人运走了！多妙啊！%SPEECH_OFF%他收起了夸张的表演。%SPEECH_ON%我需要把这东西送到%objective%，一个名叫%recipient%的人在那儿等着它。它看着可能不大，但我愿意付不少克朗确保它完好无损地送达。有兴趣吗？还是说这对你的胳膊来说有点太沉了？%SPEECH_OFF% | 你看到%employer%正在封箱。他飞快地抬眼一瞥，像是被抓了个正着。%SPEECH_ON%佣兵！感谢你的到来。%SPEECH_OFF%他迅速咔哒几声锁好搭扣。然后拍了拍板条箱几下，甚至用身体压了压，仿佛它还需要再多一个结实的搭扣似的。%SPEECH_ON%这批货物必须安全送达%objective%。一个名叫%recipient%的人正等着它。我认为这任务不会很轻松，因为这批货对某些人会不择手段想得到它的人来说相当珍贵，所以我才找上你这样……经验丰富的人。有兴趣为我办这件事吗？%SPEECH_OFF% | 你进入%employer%的房间时，他正和一个仆人给一个箱子钉钉子。%SPEECH_ON%见到你真好，佣兵。请稍等。错了，白痴，钉子要那么拿！我知道之前砸到你拇指了，但不会有第二次了。%SPEECH_OFF%他的仆人不情愿地扶着一颗钉子，而那人则把它敲了进去。完工后，他擦去额头的汗水，看向你。%SPEECH_ON%我需要把这个板条箱送到%objective%，沿大路往%direction%方向大约%days%路程。是送给%recipient%的，你认识的。好吧，也许你不认识他。我知道的是，这或许不完全是你的本行，但我愿意付一大笔克朗请你帮忙。这才是你的本行，对吧？赚钱？%SPEECH_OFF% | %employer%见到你时双手交叠。%SPEECH_ON%这可能是个奇怪的问题，但你有没有兴趣为我送一次货？%SPEECH_OFF%你解释说，只要报酬合适，这样一趟旅程倒是能让你暂时摆脱周遭司空见惯的杀戮与死亡。那人双手一拍。%SPEECH_ON%太好了！可惜，我估计情况不会完全如你所想。这东西重要到足以引起不怀好意的关注，这也是我要雇佣兵的原因。它要送到%objective%，沿大路往%direction%方向离这儿大约%days%路程，一个名叫%recipient%的人在那儿等着它落入他手中。所以说，这没办法让你‘摆脱’日常的工作状态，但如果你有兴趣，报酬会很丰厚。%SPEECH_OFF% | %employer%的手下正围着一小批货物。他们的雇主看到你便把他们都打发走了。%SPEECH_ON%欢迎，欢迎。见到你真好。我需要武装护卫把这批货物送到%objective%一个名叫%recipient%的人手里。我估计像你这样的战团大概需要%days%路程。你对此有多大兴趣？%SPEECH_OFF% | 你进去时，%employer%正把脚翘在桌上。他双手枕在脑后，那副悠闲劲儿让你有点看不惯。%SPEECH_ON%日安，队长。不如暂时放下那些打打杀杀，休息一下如何？%SPEECH_OFF%他对你的反应——也就是毫无反应——挑了挑眉。%SPEECH_ON%呵，我还以为你会迫不及待抓住这机会呢。没关系，刚才是骗你的：我需要你送个特别的包裹给%recipient%，他住在%objective%。这批货无疑已经引来了一些不怀好意的目光，所以我需要你的人帮我盯着它。如果你有兴趣——你也该有兴趣——那我们就谈谈价钱。%SPEECH_OFF% | %employer%招手让你进来。%SPEECH_ON%很好，既然你来了，请随手关上门好吗？%SPEECH_OFF%那人的一个守卫从拐角处探出头来。你微笑着慢慢把他关在门外。转过身，你发现%employer%正走向一扇窗户。他一边说话，一边凝视着窗外。%SPEECH_ON%我需要送某样东西……是个，呃，好吧你不需要知道是什么。我需要把这个‘东西’送给一个叫%recipient%的人。他在%objective%等着它。确保它真正送达至关重要，重要到需要武装护卫护送%days%路程，这就是我找你和你的战团的原因。你怎么说，雇佣兵？%SPEECH_OFF% | 昏暗的烛光勉强照亮房间，你能看见%employer%坐在书桌后，他的影子随着闪烁的烛光在墙上舞动。%SPEECH_ON%如果我付你一大笔钱，你能为我出力吗？我需要将{一个小箱子 | 一件对我很珍贵的东西 | 一件贵重物品}安全送到%objective%的%recipient%手中，需要从这向%direction%走大概%days%的路。有人曾为此互相残杀，所以你必须做好以命相护的准备。%SPEECH_OFF%他停顿了一下，揣摩着你的反应。%SPEECH_ON%我会写一封密封的信，指示我在%objective%的联系人将报酬给你，只要你成功交付货物。你意下如何？%SPEECH_OFF% | 一个仆人请你在原地等待%employer%，他说主人马上就来。于是你等啊，等啊，等啊。最后，就在你准备再次离开时，%employer%猛地推开门冲向你。%SPEECH_ON%这又是谁？那个佣兵？%SPEECH_OFF%他的助手点了点头，%employer%立刻换上了一副笑脸。%SPEECH_ON%哦，能在%townname%见到你真是万分荣幸，尊敬的队长！\n\n我有一批珍贵货物必须尽可能安全、迅速地送达%objective%。你们正是我需要的人选，没有普通强盗胆敢攻击你和你的队伍。\n\n是的，我想雇佣你们负责护送。确保货物送达%recipient%手中，当然，不得绕道。我们能达成一致吗？%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{谈谈价钱吧。 | 多大的生意？}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{不感兴趣。 | 短时间内我们不会去那里。 | 我们不想接这类差事。}",
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
			Text = "[img]gfx/ui/events/event_112.png[/img]{维齐尔的一名市政官带着侍从队伍向你走来。他们正费力搬着一个中等大小的板条箱。%SPEECH_ON%逐币者，维齐尔有事要交给你办。让这些仆人把箱子装进你的行李里，然后运往%objective%的%recipient%，沿%direction%方向走大概%days%路程。%SPEECH_OFF%市政官躬身道。%SPEECH_ON%虽然看似是简单差事，但维齐尔愿意为任务完成支付丰厚报酬。%SPEECH_OFF% | 你在门厅找到正在等候的%employer%。他正听取一排商人的请愿，每个商人都有自己的请求或提议，同时身旁的文书在账册上记录，卷轴在大理石地板上越铺越长。见到你后，维齐尔打了个响指，侧旁一名男子应声上前。%SPEECH_ON%逐币者，大人希望借用你的服务。将这个带标记的板条箱运往%objective%的%recipient%，约%days%路程。抵达后即可领取报酬。%SPEECH_OFF% | 一个戴着孔雀羽毛帽的男子不知从何处冒出来。他手持账册缓步靠近，账册上印着%townname%某位维齐尔及其护卫的徽记。%SPEECH_ON%%employer%希望雇佣你的服务，逐币者。你需要运送一批精美物资——当然已装箱避开你的恶意窥视——秘密送至%direction%方向%days%路程外的%objective%，交给%recipient%。物资送达后，你将在目的地获得酬劳。%SPEECH_OFF%男子将羽毛往后捋了捋，轻轻摇头。%SPEECH_ON%你认为这项提议符合你当前的财务规划吗？%SPEECH_OFF% | 先是信鸽衔着字条给你，上面字条指引你找到一个小男孩，接着男孩带你见仆人，仆人又领你穿过满是裸女的后宫厅堂，最终来到富商房间。%SPEECH_ON%啊，总算到了。我给我那些负债者布置了个小任务，居然要这么长时间才能完成？这事我得查查。%SPEECH_OFF%商人把账册扔给你，同时陷进一堆软垫里。%SPEECH_ON%我，失礼了，是维齐尔需要你将一箱货物运往%direction%方向%days%路程外%objective%的%recipient%。不得打开所述货物，只需送达。倘若你打开箱子，维齐尔必会知晓。相信我，逐币者，维齐尔只愿意听到好消息。所以此刻是我而非大人在此与你交谈。%SPEECH_OFF%真是好大的礼数。}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{谈谈价钱吧。 | 多大的生意？}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{不感兴趣。 | 短时间内我们不会去那里。 | 我们不想接这类差事。}",
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
			ID = "Mercenaries1",
			Title = "在路上……",
			Text = "[img]gfx/ui/events/event_07.png[/img]{行进途中，一伙装备精良的人拦住了你的去路。 | 正朝%objective%行军时，几个人打断了你们安静的旅程，他们列队站定时，武器和盔甲的铿锵声响彻四周。 | 不幸的是，你们的旅程注定不会轻松。一群人挡在了你们前方，显然是要拦住去路。 | 一些武装到牙齿的人现身，构成了一道钢铁屏障。看架势，他们是打定主意不让你们再前进一步。 | 队伍中的几名兄弟停了下来。你走到前面查看发生了什么，结果发现一列装备精良的人挡住了%companyname%的去路。嗯，这下有意思了。}敌方指挥官迈步走上前来，紧握拳头敲击自己的胸口。%SPEECH_ON%{我等正是%mercband%，屹立于你等面前。斩杀过超乎想象的怪物，是这片神弃之地最后的希望！ | 我们是%mercband%！在这片土地上，谁人不知我们是劈颅好手、痛饮豪客、讨女士欢心的行家！ | 站在你面前的，是传奇的%mercband%！正是我们，拯救了%randomtown%，斩杀了伪王！ | 好好见识一下我骄傲的战团，%mercband%！我们曾击退上百兽人，将一座城市从覆灭边缘拯救。你们又有何战绩？ | 你正在和%mercband%的人说话。寻常土匪、肮脏绿皮、钱袋子或是娘们，没有一个能从我们手里溜走！}%SPEECH_OFF%他做完这套耀武扬威的流程后，指着你所携带的货物。%SPEECH_ON%{既然你现在清楚自己的处境了，何不干脆把那批货交出来？ | 我希望你认清自己面对的是谁，可怜的佣兵，这样你才能最大可能地确保你的手下今晚还能躺回自己的床铺。你只需交出货物，我们就不必把你写进%mercband%的战绩里。 | 啊，我打赌你一定很想成为我们历史的一部分，对吧？好吧，好消息是，你只需要不交出那批货，我们就会用剑把你们写进去。当然，只要你把货给我们，你就能躲过我们的‘笔’了。 | 瞧瞧这是谁，%companyname%。虽然我很想把你们加进我们的胜利清单，但咱都是雇佣兵，我愿意给你个机会，你只需交出那批货，我们立马走人。听起来怎么样？}%SPEECH_OFF%{嗯，别的先不说，这打劫的方式倒是挺浮夸的。 | 好吧，至少这表演挺有意思的。 | 你不太理解这种表演的必要性，但毫无疑问，你此刻陷入的新局势非常严峻。 | 虽然你欣赏他们的夸张言辞，但眼前严酷的现实是，这些人绝非儿戏。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "如果你想要，就过来拿吧！",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Mercs";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Mercenaries, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				},
				{
					Text = "这不值得我们拼命。拿上这该死的货物离开吧。",
					function getResult()
					{
						return "Mercenaries2";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Mercenaries2",
			Title = "在路上……",
			Text = "[img]gfx/ui/events/event_07.png[/img]{你不想发生冲突，于是交出了货物。他们接过货物时大笑起来。%SPEECH_ON%明智的选择，佣兵。也许哪天就轮到你威胁别人了。%SPEECH_OFF% | 不管里面是什么，这货物都比不上你弟兄的生命。你交出板条箱，佣兵们接了过去。他们在你离开时嘲笑你。%SPEECH_ON%跟哄妓女一样简单！%SPEECH_OFF% | 此时此地似乎不该为了%employer%的送货服务牺牲你的弟兄。于是你交出了货物。佣兵们接过货物准备离开，他们的指挥官弹给你一枚克朗，硬币旋转着掉进泥里。%SPEECH_ON%给自己买个擦鞋箱吧小子，这行当不适合你。%SPEECH_OFF% | 这些佣兵装备精良，如果为了个天知道装了什么鬼玩意儿的破箱子就赔上弟兄性命的话，你不知道自己以后晚上还能否安睡。于是你点头交出了货物。佣兵团高兴地接过去，他们的指挥官停下来向你尊重地点头回应。%SPEECH_ON%明智的选择。当年我也做了很多这种选择。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "嗯……",
					function getResult()
					{
						this.Flags.set("IsMercenaries", false);
						this.Flags.set("IsMercenariesDialogTriggered", true);

						if (this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).getType() == this.Const.FactionType.OrientalCityState)
						{
							this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "未能交付货物。");
						}
						else
						{
							this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "未能交付货物。");
						}

						local recipientFaction = this.Contract.m.Destination.getFactionOfType(this.Const.FactionType.Settlement);

						if (recipientFaction != null)
						{
							recipientFaction.addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 0.5);
						}

						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BountyHunters1",
			Title = "在路上……",
			Text = "[img]gfx/ui/events/event_07.png[/img]{行进在路上时，你遇到一队赏金猎人。他们的囚犯向你呼喊，声音嘶哑地乞求你们救他。他声称自己是无辜的。赏金猎人则叫你们滚远点找死。 | 你们在路上行进时，遇到一群装备精良的赏金猎人。他们正拖拽着一个从头到脚都被锁链束缚的男子。%SPEECH_ON%你们不会想和这家伙有什么牵连的。%SPEECH_OFF%其中一人说着，同时击打囚犯的小腿后侧。那男子痛叫着，用血淋淋的手脚爬向你们。%SPEECH_ON%他们全是骗子！这些人会杀了我的，就算我什么错都没有！救救我，先生们，求求你们了！%SPEECH_OFF% | 你们遇到一大队赏金猎人，两支队伍相似得堪称古怪，尽管在世上的目的显然不同。他们正在押送一名被铁链锁住、嘴里塞着破布的囚犯。那男子几乎是在哀嚎着向你们呼喊，话语哽咽直到满脸通红。一名赏金猎人吐了口唾沫。%SPEECH_ON%别搭理他，陌生人，继续赶你们的路吧。你我这种人之间最好别有什么麻烦。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "这不关我们的事。",
					function getResult()
					{
						return 0;
					}

				},
				{
					Text = "也许我们可以买下这个囚犯？",
					function getResult()
					{
						return this.Math.rand(1, 100) <= 50 ? "BountyHunters1" : "BountyHunters1";
					}

				},
				{
					Text = "如果你想要，就过来拿吧！",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Mercs";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Mercenaries, 140 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Thieves1",
			Title = "露营时……",
			Text = "[img]gfx/ui/events/event_05.png[/img]{你从小憩中翻身而起，像寻找情人般搜寻那个包裹。但你身边没有情人，也没有货物。你迅速起身，命令队员们集合戒备。%randombrother%跑过来报告，说他已经追踪到从营地离开的脚印。 | 休息时，你听到营地某处传来骚动。冲过去发现%randombrother%脸朝下趴在地上，揉着后脑勺。%SPEECH_ON%对不起长官，我正在撒尿，然后他们突然偷袭了我。还有，他们偷走了包裹。%SPEECH_OFF%你让他重复最后那句话。%SPEECH_ON%天杀的贼偷了货！%SPEECH_OFF%该去追踪那些混蛋，并把东西夺回来了。 | 自然，这趟旅程不可能太平凡。不，这世界还没美好到那种程度。看来窃贼已经带着货物逃跑了。幸运的是，他们留下了大量痕迹——主要是搬运包裹时留下的脚印和拖拽痕迹。应该不难找到…… | 你只想来次安稳的城镇间漫步。然而与%employer%的协议又一次招来了麻烦。窃贼不知怎的溜进营地，偷走了货物。好消息是他们没能完美隐匿行踪：你已发现他们的脚印，追踪起来应该不难。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们跟着他们的足迹走！",
					function getResult()
					{
						this.Contract.setState("Running_Thieves");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Thieves2",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_22.png[/img]{盗贼的血流成了河。你在他们的营地里找到了雇主的货物，锁扣完好无损。这次小插曲没必要让他知道。 | 好了，所有东西都物归原处。%employer%的货物是在一个盗贼抽搐的身体下面找到的。你确保在捅穿他之前先把他踢开。毕竟你可不想弄脏包裹。 | 解决掉最后一名盗贼后，你和队员们散开在匪徒营地中搜寻包裹。%randombrother%很快就找到了，东西还攥在一个死掉的蠢货手里。这名佣兵费力地想掰开尸体的抓握，最后在恼火之下干脆把那混蛋的手臂砍了下来。你取回包裹，在接下来的旅途中把它抱得更紧了些。 | 凝视着倒地盗贼们的尸体，你在想%employer%是否需要知道这事。包裹看起来没问题。上面沾了些血和骨屑，但擦掉就行了。 | 包裹有点磨损，不过没关系。好吧，上面全是血，还有个盗贼剥落的手指卡在其中一个搭扣上。除了这些小问题，一切都完美无缺。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "物归原主。",
					function getResult()
					{
						this.Flags.set("IsThieves", false);
						this.Flags.set("IsStolenByThieves", false);
						this.Contract.setState("Running");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "EnragingMessage1",
			Title = "%objective%里",
			Text = "{墓园笼罩在浓雾中——或者说，是亡者散发出的浓重瘴气。等等……亡者就在其中往你走来！准备战斗！ | 你注意到一块墓碑，基座处的泥土被翻掘开来。泥点像面包屑般一路延伸。没有铁锹……没有人影……顺着痕迹追踪，你遇到了一群呻吟低语的活死人……此刻正用永不满足的饥渴眼神盯着你…… | 一个人影在墓碑丛深处徘徊。他身形摇晃，仿佛随时会倒下。%randombrother%来到你身边摇了摇头。%SPEECH_ON%那可不是活人，长官。有亡灵在活动。%SPEECH_OFF%他话音刚落，远处的那个陌生人缓缓转身，露出空空荡荡的另外半边脸。 | 你发现许多墓穴都已空空如也。不是被挖开，而是从内部被掘开。这绝非盗墓贼所为……}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "EvilArtifact1",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_55.png[/img]{行进途中，你注意到还有别的东西在动：那批货物。箱盖不停跳动，边缘还透出诡异的光芒。%randombrother%凑过来，看了看箱子，又看向你。%SPEECH_ON%要打开看看吗，长官？或者我直接把它扔进最近的池塘里，因为那玩意儿怎么看都不对劲。%SPEECH_OFF%你戳了戳他，问他是不是害怕了。 | 沿着小路行进时，你开始听到%employer%交给你的那个包裹发出低沉的嗡鸣。%randombrother%正站在旁边，用一根棍子戳它。你把他拍开。他赶忙解释。%SPEECH_ON%长官，咱们拖着的这货有点不对劲……%SPEECH_OFF%你仔细看了看。箱盖边缘泛着微弱的光芒。据你所知，火是不能在密闭空间里燃烧的，而能在黑暗中发光的就只有月亮和星星。你担心自己的好奇心快要压过理智了…… | 货物就在你旁边的货车上，随着道路的颠簸和转弯而摇晃。突然，它开始发出嗡鸣，而且你发誓看到箱盖向上浮起了一瞬间。%randombrother%瞥了一眼。%SPEECH_ON%你没事吧，长官？%SPEECH_OFF%他话音刚落，箱盖就猛地向外炸开，卷出一片混杂着色彩、雾气、灰烬、灼热与刺骨严寒的漩涡。你抬起手臂护住自己，等从肘弯间偷瞄时，包裹已完全静止，箱盖也回到了原位。你和那名佣兵交换了一个眼神，然后两人都死死盯住那批货物。这恐怕不止是一次普通的运送任务了…… | 附近传来低沉的嗡鸣。你以为有蜂巢，本能地蹲下，随即发现声音竟来自%employer%交给你的那批货物。箱盖正在左右晃动，撞得本应固定它的搭扣和钉子咯吱作响。%randombrother%看起来有点害怕。%SPEECH_ON%咱们就把它丢这儿吧。那玩意儿绝对不对劲。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我想知道是怎么回事。",
					function getResult()
					{
						return "EvilArtifact2";
					}

				},
				{
					Text = "别碰那个东西。",
					function getResult()
					{
						this.Flags.set("IsEvilArtifact", false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "EvilArtifact2",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_73.png[/img]{好奇心占据了上风。你慢慢撬开箱盖。%randombrother%后退一步抗议道。%SPEECH_ON%我觉得不该碰它，长官。得了吧，你看看这东西。%SPEECH_OFF%你不理他，告诉兄弟们不会有事，随后掀开了箱盖。\n\n结果真出事了。突发的爆炸将你掀翻在地。狰狞的身影与尖啸在你周围盘旋。当幽灵刺入大地时，队员们本能地拿起武器。地面呻吟着隆起土丘。你看见无数手臂破土而出，将腐朽躯体从坑穴中拖拽出来。亡者再度苏醒，它们显然打算扩充自己的队伍！ | 不顾所有人的反对，你撬开了货物。起初什么都没有。只是个空箱子。%randombrother%紧张地干笑。%SPEECH_ON%好吧……看来什么都没有。%SPEECH_OFF%但不可能什么都没有，对吧？%employer%怎么会让你运送空箱子？除非——\n\n你在渐渐消退的耳鸣中醒来。翻身一看，箱子已完全蒸发，只剩纷扬如雪的锯末。%randombrother%冲过来扶起你，拽着你朝队伍跑去。他们指着远处，嘴巴张合，呼喊着……\n\n一群全副武装的人正……蹒跚而来？待看清时，你发现他们手持绘有怪异仪式的旧木盾，盔甲样式前所未见，仿佛由刚入行的匠人所造，却又深得技艺精髓。这些人看起来就像是古代的士兵一样。 | %%randombrother%摇头看着你掀开箱盖。费力撬开后你迅速后撤，准备迎接最坏情况。但里面空无一物。连半点声响都没有。你抽剑在空箱里搅动，想找暗格之类的东西。%randombrother%大笑。%SPEECH_ON%嘿，咱们运的是一箱空气！亏我还觉得这鬼东西沉得要命！%SPEECH_OFF%就在这时，箱子突然浮空旋转，接着又猛砸向地面。它完美地碎裂，悄无声息，干净利落，每块木板如古代石工般铺在草地上。无形幽影从破碎仪式中浮现，扭曲着露出狞笑。%SPEECH_ON%人类啊，重逢真是令人愉悦。%SPEECH_OFF%那声音让你脊背发凉。幽影冲天而起又猛坠而下，刺入大地。不到一秒地面就开始崩裂，无数躯体攀爬而出。 | 箱子如同磁石吸引着你。你毫不犹豫地撬开货物查看。先于视觉的是一股恶臭扑面而来，几乎让你晕眩。有人当场呕吐，另一个阵阵干呕。当你再看箱子时，漆黑烟缕正从中渗出，延伸得又长又远，沿途探查着地面。找到目标后便钻入土中，像鱼饵般将死人骸骨拽出地面。 | 无视几个队员的忧虑，你强行打开包裹。里面堆满头颅，发光的眼睛忽闪着苏醒。下颌噼啪开裂，从静止状态转为发出咔嗒笑声。你急忙关箱，却被无形力量重新推开。你和%randombrother%及另外几人拼命压住箱盖，仿佛被无声风暴抵住。\n\n片刻后你们全被震开，箱盖冲天而起，被一股漆黑灵魂托举升空。它们急速盘旋，梳理大地，随后在%companyname%对面列阵。你惊恐地看着无形灵体开始具现，迷雾般的灵魂凝结成实体骸骨。当然，它们全副武装，开裂的下颌骨仍在发出空洞笑声。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "EvilArtifact";
						p.Music = this.Const.Music.UndeadTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;

						if (this.Flags.get("IsCursedCrystalSkull"))
						{
							this.World.Flags.set("IsCursedCrystalSkull", true);
							p.Loot = [
								"scripts/items/accessory/legendary/cursed_crystal_skull"
							];
						}

						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.UndeadArmy, 120 * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
						this.World.Contracts.startScriptedCombat(p, false, false, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "EvilArtifact3",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_55.png[/img]{战斗结束，你迅速冲回圣物所在处，发现它仍悬浮在空中。%randombrother%跑到你身边。%SPEECH_ON%毁了它，长官，趁它还没造成更多麻烦！%SPEECH_OFF% | 你的队员们并非战场上唯一的幸存者——那件圣物，或者说它残留的脉动能量，正若无其事地漂浮在你最后看见它的地方。这东西是个能量旋绕的球体，时而发出咔嗒声响，时而用一种你不知晓的语言低语。%randombrother%朝它点了点头。%SPEECH_ON%砸了它，长官。砸了它，我们就能摆脱这恐怖玩意儿了。%SPEECH_OFF% | 如此力量不该存于此世！圣物已化作拳头大小的球体。它离地悬浮，发出嗡鸣，恍若吟唱着异界之歌。这东西几乎像是在等候你，如同忠犬等待主人。%SPEECH_ON%长官。%SPEECH_OFF%%randombrother%拽了拽你的肩膀。%SPEECH_ON%长官，求你了，毁掉它。别再带着那东西走了！%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们必须摧毁它。",
					function getResult()
					{
						return "EvilArtifact4";
					}

				},
				{
					Text = "有人花钱请我们把东西送过去，我们打算信守承诺。",
					function getResult()
					{
						this.Flags.set("IsEvilArtifact", false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "EvilArtifact4",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_55.png[/img]{你拔出长剑站在圣物前，剑刃缓缓举过头顶。%SPEECH_ON%别这么做！%SPEECH_OFF%回头一瞥，只见%randombrother%和其他队员正对你怒目而视。黑暗笼罩着他们乃至你视野所及的整个世界。他们的眼睛泛着红光，每说一个字都剧烈脉动。%SPEECH_ON%你将永世燃烧！永世燃烧！毁了它你就将坠入火海！火海！火海！%SPEECH_OFF%你嘶吼着转身挥剑劈向遗物。它应声裂成两半，斑斓的色彩如浪潮般涌回你的世界。当你拄着剑柄喘息时，汗水正从额头不断滴落。回头看见佣兵团的弟兄们都在盯着你。%SPEECH_ON%长官，你没事吧？%SPEECH_OFF%你收剑入鞘点了点头，但有生以来从未感到如此恐惧。%employer%肯定不会高兴，但他和他的怒火都见鬼去吧！ | 就在毁灭遗物的念头闪过脑海时，恐怖的尖叫也如潮水般涌来。妇女儿童凄厉的哭喊声因恐惧而扭曲，仿佛他们正浑身着火向你奔来。数百种语言的尖叫将你淹没，但时而掠过你熟悉的字眼，永远都是同一个词：住手。\n\n你拔出长剑举过头顶。圣物发出嗡鸣震颤。烟雾般的触须从中飘散，野蛮的热浪将你吞没。住手。\n\n你握紧剑柄。\n\n达库尔。耶赫拉。伊姆舒达。佩兹兰特。住手。\n\n你咽了口口水，站稳瞄准。\n\n住手。拉维特。乌拉。奥沙罗。埃布罗。梅特贾卡。住手。住手。住手。住——\n\n利刃精准斩落，未竟之词戛然而止，圣物断成两截坠向地面。你随之跪倒在地，几名弟兄上前将你扶起。%employer%肯定不会满意，但你不禁觉得，自己让这个世界免于遭受本不该见闻的恐怖。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "完成了。",
					function getResult()
					{
						this.Flags.set("IsEvilArtifact", false);

						if (this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).getType() == this.Const.FactionType.OrientalCityState)
						{
							this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "未能交付货物。");
						}
						else
						{
							this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "未能交付货物。");
						}

						local recipientFaction = this.Contract.m.Destination.getFactionOfType(this.Const.FactionType.Settlement);

						if (recipientFaction != null)
						{
							recipientFaction.addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 0.5);
						}

						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "EvilArtifact5",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_55.png[/img]{你摇摇头，又拿来一个板条箱，小心地将漂浮的圣物推进去然后合上箱盖。%employer%给的报酬不少，而你打算完成任务。但不知为何，你不确定这个选择是出于自己的意志，还是这件奇怪遗物的低语在引导你的行动。 | 你找来一个木箱，将其举到圣物上方，迅速合上箱盖。几个佣兵摇了摇头。这或许不是最明智的决定，但不知为何，你感到一种必须完成任务的冲动。 | 理智告诉你们该毁掉这可怕的遗物，但理智再次败下阵来。你拿来一个木箱，将其移到圣物上方，然后合上箱盖，扣紧搭扣。你也不知道自己为何这样做，但当你准备重新上路时，体内却充满了新的活力。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们应该继续前进。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "%objective%里",
			Text = "[img]gfx/ui/events/event_20.png[/img]{你刚进镇子，%recipient%已经在等着了。他匆忙地从你手中接过货物。%SPEECH_ON%哦，哦哦哦，我没想到你真能赶到这儿。%SPEECH_OFF%他脏兮兮的手指在那运货的箱子上跳动。他转身朝一个手下厉声吩咐。那人走上前，递给你一袋克朗。 | 你终于抵达了。%recipient%就站在路中央，双手叠在肚子上，他那厚脸皮的脸上挂着滑头的笑容。%SPEECH_ON%佣兵，我之前可不确定你能成功赶到。%SPEECH_OFF%你费力地提起货物递过去。%SPEECH_ON%哦？为什么这么说？%SPEECH_OFF%那人接过箱子，转交给一个穿长袍的人，后者迅速将其夹在腋下匆匆离去。%recipient%大笑着递给你一袋克朗。%SPEECH_ON%这年头路上不太平，是吧？%SPEECH_OFF%你明白他是在没话找话，只想转移你对刚交付货物的注意力。管他呢，你拿到了报酬，这对你来说就足够了。 | %recipient%迎接了你，他的几个手下赶忙过来接手货物。他拍了拍你的肩膀。%SPEECH_ON%我想旅途还算顺利？%SPEECH_OFF%你懒得细说，直接询问你的报酬。%SPEECH_ON%哈，彻头彻尾的佣兵做派。%randomname%！给这位好汉他应得的报酬！%SPEECH_OFF%%recipient%的一名护卫走过来，递给你一个小箱子，里面装着克朗。 | 一番寻找后，有个男人问你在找谁。你说是%recipient%，他指向附近的一个围场，那里有个男人正骑着一匹看起来十分华贵的马踱步。\n\n你走了过去，那人勒住马，问这是不是%employer%送来的货。你点了点头。%SPEECH_ON%就放你脚边。我会来取的。%SPEECH_OFF%你没照做，而是询问你的报酬。那人叹了口气，朝一个护卫吹了声口哨，护卫急忙跑过来。%SPEECH_ON%确保这位佣兵拿到他应得的报酬。%SPEECH_OFF%最终，你把板条箱放在地上，转身离开。} ",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "受之无愧。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());

						if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getType() == this.Const.FactionType.OrientalCityState)
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "运送了一些货物");
						}
						else
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "运送了一些货物");
						}

						local recipientFaction = this.Contract.m.Destination.getFactionOfType(this.Const.FactionType.Settlement);

						if (recipientFaction != null)
						{
							recipientFaction.addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess * 0.5, "运送了一些货物");
						}

						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Tactical.getEntityByID(this.Contract.m.RecipientID).getImagePath());
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color]克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "%objective%里",
			Text = "[img]gfx/ui/events/event_163.png[/img]{%SPEECH_START%啊，逐币者。%SPEECH_OFF%声音来自附近的小巷。通常这意味着你要被偷走几个硬币，但这次却遇到个要给你钱的男人。%SPEECH_ON%我是%recipient%，那包裹是我的。代我向%employer%问好，或者不问也行，我不在乎。%SPEECH_OFF%男子悄然离去，如来时一般迅速消失。 | %recipient%是个矮壮男子，他佩戴着维齐尔的徽记和标识，那姿态仿佛它们和你刚运来的板条箱一样沉重。%SPEECH_ON%我为维齐尔付出良多，而他用什么回报我？让我来接待一名逐币者。愿镀金者在凝视他的未来时移开视线。%SPEECH_OFF%你对此保持沉默，部分是因为你怀疑这是否是个\"考验\"，看你是否会赞同他而暴露自己是那位尊贵维齐尔的敌人。男子凝视你片刻，随后耸耸肩继续道。%SPEECH_ON%你的报酬在这里。钱币分文不差，不过若你想亲自清点，我也不会介意。啊，我看你已经数起来了。很好。瞧？分文不少。现在走吧，逐币者。%SPEECH_OFF% | 发现%recipient%正对着一小群孩童训话。他迅速锁定你，并以你为例教导孩子们要专心学业，免得落得你这般下场。待孩子们散去后，男子提着钱袋走来。%SPEECH_ON%我的人通报你到了，还说物资完好无损。这是给你的报酬，逐币者。%SPEECH_OFF% | 你走进%recipient%的宅邸，包裹终于送达并被仆从迅速搬走。%recipient%从舒适的座椅上凝视着你，询问旅途是否顺利。你表示闲谈填不饱口袋，随即追问报酬事宜。男子挑起眉毛。%SPEECH_ON%啊，我彬彬有礼的待客之道冒犯到逐币者了吗？我怎敢如此。好吧，你的报酬在角落，按约定分文不少。%SPEECH_OFF% | %recipient%正对着镜子高谈阔论鸟类的本性。当他在镜中瞥见你，转过身来，说话的神态仿佛刚才什么都没发生。%SPEECH_ON%逐币者。维齐尔果然派来个逐币者。我宁愿相信你没敢用眼睛亵渎板条箱里的物资，但你们这种人根本谈不上专业素养。不过你大可相信我的专业素养：报酬在角落，全额付清。%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "受之无愧。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());

						if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getType() == this.Const.FactionType.OrientalCityState)
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "运送了一些货物");
						}
						else
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "运送了一些货物");
						}

						local recipientFaction = this.Contract.m.Destination.getFactionOfType(this.Const.FactionType.Settlement);

						if (recipientFaction != null)
						{
							recipientFaction.addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess * 0.5, "运送了一些货物");
						}

						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Tactical.getEntityByID(this.Contract.m.RecipientID).getImagePath());
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color]克朗"
				});
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		local days = this.getDaysRequiredToTravel(this.m.Flags.get("Distance"), this.Const.World.MovementSettings.Speed, true);
		_vars.push([
			"objective",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.m.Destination.getName()
		]);
		_vars.push([
			"recipient",
			this.m.Flags.get("RecipientName")
		]);
		_vars.push([
			"mercband",
			this.Const.Strings.MercenaryCompanyNames[this.Math.rand(0, this.Const.Strings.MercenaryCompanyNames.len() - 1)]
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Destination.getTile())]
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
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
			}

			if (this.m.Location != null && !this.m.Location.isNull())
			{
				this.m.Location.getSprite("selection").Visible = false;
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive() || !this.m.Destination.isAlliedWithPlayer())
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

		if (this.m.Location != null && !this.m.Location.isNull())
		{
			_out.writeU32(this.m.Location.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		_out.writeU32(this.m.RecipientID);
		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		local location = _in.readU32();

		if (location != 0)
		{
			this.m.Location = this.WeakTableRef(this.World.getEntityByID(location));
		}

		this.m.RecipientID = _in.readU32();

		if (!this.m.Flags.has("Distance"))
		{
			this.m.Flags.set("Distance", 0);
		}

		this.contract.onDeserialize(_in);
	}

});
