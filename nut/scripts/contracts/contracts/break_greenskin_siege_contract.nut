this.break_greenskin_siege_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Troops = null,
		IsPlayerAttacking = true,
		IsEscortUpdated = false
	},
	function create()
	{
		this.contract.create();
		local r = this.Math.rand(1, 100);

		if (r <= 70)
		{
			this.m.DifficultyMult = this.Math.rand(90, 105) * 0.010000;
		}
		else
		{
			this.m.DifficultyMult = this.Math.rand(115, 135) * 0.010000;
		}

		this.m.Type = "contract.break_greenskin_siege";
		this.m.Name = "突破重围";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.000000;
		this.m.MakeAllSpawnsResetOrdersOnContractEnd = false;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		if (this.m.Home == null)
		{
			this.setHome(this.World.State.getCurrentTown());
		}

		this.m.Flags.set("ObjectiveName", this.m.Origin.getName());
		local nearest_orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(this.m.Origin.getTile());
		this.m.Flags.set("OrcBase", nearest_orcs.getID());
		local nearest_goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(this.m.Origin.getTile());
		this.m.Flags.set("GoblinBase", nearest_goblins.getID());
		this.m.Payment.Pool = 1500 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.750000;
			this.m.Payment.Advance = 0.250000;
		}
		else
		{
			this.m.Payment.Completion = 1.000000;
		}

		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"前往 %objective%",
					"打破绿皮的围城"
				];

				if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.IntroChance)
				{
					this.Contract.setScreen("Intro");
				}
				else
				{
					this.Contract.setScreen("Task");
				}
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local okLocations = 0;

				foreach( l in this.Contract.m.Origin.getAttachedLocations() )
				{
					if (l.isActive())
					{
						okLocations = ++okLocations;
					}
				}

				if (okLocations < 3)
				{
					foreach( l in this.Contract.m.Origin.getAttachedLocations() )
					{
						if (!l.isActive() && !l.isMilitary())
						{
							l.setActive(true);
							okLocations = ++okLocations;

							if (okLocations >= 3)
							{
								break;
							}
						}
					}
				}

				local faction = this.World.FactionManager.getFaction(this.Contract.getFaction());
				local party = faction.spawnEntity(this.Contract.getHome().getTile(), this.Contract.getHome().getName() + " 战团", true, this.Const.World.Spawn.Noble, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.getSprite("banner").setBrush(faction.getBannerSmall());
				party.setDescription("为地方领主服务的职业军人。");
				this.Contract.m.Troops = this.WeakTableRef(party);
				party.getLoot().Money = this.Math.rand(50, 200);
				party.getLoot().ArmorParts = this.Math.rand(0, 25);
				party.getLoot().Medicine = this.Math.rand(0, 5);
				party.getLoot().Ammo = this.Math.rand(0, 30);
				local r = this.Math.rand(1, 4);

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

				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				local move = this.new("scripts/ai/world/orders/move_order");
				move.setDestination(this.Contract.getOrigin().getTile());
				c.addOrder(move);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
				}

				this.World.State.setEscortedEntity(this.Contract.m.Troops);
			}

			function update()
			{
				if (this.Flags.get("IsContractFailed"))
				{
					this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
					this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "战团撕毁了合同");
					this.World.Contracts.finishActiveContract(true);
					return;
				}

				if (this.Contract.m.Troops != null && !this.Contract.m.Troops.isNull())
				{
					if (!this.Contract.m.IsEscortUpdated)
					{
						this.World.State.setEscortedEntity(this.Contract.m.Troops);
						this.Contract.m.IsEscortUpdated = true;
					}

					this.World.State.setCampingAllowed(false);
					this.World.State.getPlayer().setPos(this.Contract.m.Troops.getPos());
					this.World.State.getPlayer().setVisible(false);
					this.World.Assets.setUseProvisions(false);
					this.World.getCamera().moveTo(this.World.State.getPlayer());

					if (!this.World.State.isPaused())
					{
						this.World.setSpeedMult(this.Const.World.SpeedSettings.FastMult);
					}

					this.World.State.m.LastWorldSpeedMult = this.Const.World.SpeedSettings.FastMult;
				}

				if ((this.Contract.m.Troops == null || this.Contract.m.Troops.isNull() || !this.Contract.m.Troops.isAlive()) && !this.Flags.get("IsTroopsDeadShown"))
				{
					this.Flags.set("IsTroopsDeadShown", true);
					this.World.State.setCampingAllowed(true);
					this.World.State.setEscortedEntity(null);
					this.World.State.getPlayer().setVisible(true);
					this.World.Assets.setUseProvisions(true);

					if (!this.World.State.isPaused())
					{
						this.World.setSpeedMult(1.000000);
					}

					this.World.State.m.LastWorldSpeedMult = 1.000000;
					this.Contract.setScreen("TroopsHaveDied");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerNear(this.Contract.m.Origin, 1200))
				{
					if (this.Contract.m.Troops == null || this.Contract.m.Troops.isNull())
					{
						this.Contract.setScreen("ArrivingAtTheSiegeNoTroops");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.m.Troops.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(true);
						this.Contract.setScreen("ArrivingAtTheSiege");
						this.World.Contracts.showActiveContract();
					}

					this.World.State.setCampingAllowed(true);
					this.World.State.setEscortedEntity(null);
					this.World.State.getPlayer().setVisible(true);
					this.World.Assets.setUseProvisions(true);

					if (!this.World.State.isPaused())
					{
						this.World.setSpeedMult(1.000000);
					}

					this.World.State.m.LastWorldSpeedMult = 1.000000;
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Flags.set("IsContractFailed", true);
			}

		});
		this.m.States.push({
			ID = "Running_BreakSiege",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"摧毁任何绿皮的攻城车",
					"消灭在 %objective% 附近的所有绿皮"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = false;
				}

				foreach( id in this.Contract.m.UnitsSpawned )
				{
					local e = this.World.getEntityByID(id);

					if (e != null)
					{
						e.getSprite("selection").Visible = true;

						if (e.getFlags().has("SiegeEngine"))
						{
							e.setOnCombatWithPlayerCallback(this.onCombatWithSiegeEngines.bindenv(this));
						}
					}
				}
			}

			function update()
			{
				if (this.Contract.m.UnitsSpawned.len() == 0)
				{
					this.Contract.setScreen("TheAftermath");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.m.Origin == null || this.Contract.m.Origin.isNull() || !this.Contract.m.Origin.isAlive())
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatWithSiegeEngines( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
				local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
				p.Music = this.Const.Music.GoblinsTracks;
				p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Edge;
				p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
				p.EnemyBanners = [
					this.World.getEntityByID(this.Flags.get("GoblinBase")).getBanner()
				];
				this.World.Contracts.startScriptedCombat(p, this.Contract.m.IsPlayerAttacking, true, true);
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"返回" + this.Contract.m.Home.getName()
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = false;
				}

				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success1");
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% 递给你一杯酒.%SPEECH_ON%喝了它.%SPEECH_OFF%你几乎可以从他的呼吸中嗅到不太好的消息。你一口气喝下了这杯酒，向那个人点了点头。他向你点了点头。%SPEECH_ON%绿皮兽人正在这个地区肆虐，他们计划夺取 %objective%。%SPEECH_OFF%他又倒了一杯酒，一口喝掉，然后又倒了一杯。%SPEECH_ON%如果这个地方被攻陷，那么我们可以假设整个地区都会跟着崩溃。不知道你对于十年前这些畜生侵袭的事情了解多少，但附近没有几个人希望再次看到这种情况的发生。现在，我的间谍告诉我围攻刚刚开始，绿皮兽人不处于全面战斗状态，这意味着我们现在可以攻击并摆脱控制。如果你有兴趣，我真心希望你有，我需要你去那里并打破围攻！%SPEECH_OFF% | 警卫们围着%employer%。他们的头盔已经卸下，头上满是汗水，有些人在盔甲中颤抖。%employer%在绝望的人群中看到了你，向你招手示意前来。%SPEECH_ON%佣兵！我有一些……特别可怕的消息。也许你已经听说过，但我会快速地概括一下：绿皮魔可能已经入侵了这个地区，并威胁要夺取%objective%。他们目前正在围攻该地区，但是报告称绿皮们还没有充分的实力。我需要你去那里，打破局势，以免事情失控。%SPEECH_OFF% | %employer% 身边站着几名抄写员，轮流低声私语，贵族只是点头应答。最终，%employer% 将注意力转向了你。%SPEECH_ON%雇佣兵，你参与过攻城战吗？%objective%地区目前被绿皮族围攻。在他们占领这个地方之前，我们没多少时间，然后也许会占领整个该死的地区！此后……我相信你知道十年前发生了什么。%SPEECH_OFF% 抄写员们齐头并进，低头行礼。%employer% 继续道。%SPEECH_ON%那么，你有兴趣参与一些军事行动吗？%SPEECH_OFF% | %employer%（雇主）面带担忧地欢迎您。%SPEECH_ON%雇佣兵，我们有些时候很困难，我们需要您的帮助呀！%objective%（任务目标）已经被绿皮兽人围攻了，我没有足够的士兵去突围。但我相信你有能力完成这个任务。你行吗？我会付给你丰厚的报酬。%SPEECH_OFF% | %employer%双臂交叉，站在桌前。他的肩膀紧皱着，就像一只盯着猎物的乌鸦。他摇了摇头。%SPEECH_ON%佣兵，我需要更多的人手来帮忙抵抗包围%objective%的兽人军队。你能胜任吗？我需要现在就知道。%SPEECH_OFF% | %employer%一见到你就站了起来，额头上挂着汗珠，脸上挤出一个急促地侧面微笑。%SPEECH_ON%雇佣兵！很高兴你来了！有消息传来，绿皮怪围攻了%objective%，我需要你的帮助！你有兴趣吗？要快点做出决定。%SPEECH_OFF% | 你发现%employer%深深埋在他的椅子里，好像他希望椅背会永久地关闭并将他永远隔离在这个世界之外。他懒散地朝桌子上的一张地图做出手势。%SPEECH_ON%好消息是，绿皮族回来了，他们正在围攻%objective%。我需要尽可能多的人前往那里并解围。薪酬是适宜的，你们愿意吗？%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{你认为 %objective% 值多少钱？ | 打破围城是 %companyname% 能做的事。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{这不值得。 | 我们还有其他任务。}",
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
			ID = "PreparingForBattle",
			Title = "在%townname%…",
			Text = "[img]gfx/ui/events/event_78.png[/img]{你走出%employer%的地方，准备好战团。周围的骑士和士兵在四处奔走。其中一些人围绕着圣洁的人默默无声地准备着死亡。%SPEECH_ON%必须先订好位置。%SPEECH_OFF%%randombrother%加入你的队伍。他冲你咧嘴一笑。%SPEECH_ON%怎么，太阴暗了吗？%SPEECH_OFF% | 在%employer%的住所外，有士兵在四处奔忙。一些人把供应品放入马车的后面，其他人则在磨利他们的武器，而一些侍从则带着一大堆盔甲来回穿梭。你走到你的队伍面前，命令他们准备好。%randombrother%向忙碌的人群点了点头。%SPEECH_ON%我想我们这次会有朋友与我们同行吧？%SPEECH_OFF% | 在%employer%的房间外有士兵，大厅里也有士兵。你走过惊恐的妇女和儿童以及宁愿失聪的盲老人的房间。在外面，你必须穿过一群侍从的热闹人群，他们带着武器和盔甲。%companyname%在等待你。%SPEECH_ON%让我们出发吧。这些人必须准备战斗，但我们只是走过而已，对吧伙计们？%SPEECH_OFF% | 离开%employer%的地方后，你发现%randombrother%正在等你。他正看着四周忙碌的战争准备：侍从们穿着盔甲忙着奔跑，士兵们往马车里装备，神圣的教士们暂时平息着年轻士兵的恐惧。你告诉你的佣兵准备好行装，你们将跟随这些士兵们一起突围。 | 你走出去发现%employer%的士兵正在准备战争。他们正在把装备装上马车，而一位神圣的教士正在他们中间走动。女性、儿童和老人站在路边。%companyname%正尽责地站着。你走过去告诉他们手头的任务。 | 走出去后，你发现%employer%的士兵正在准备战争。儿童们在那里奔跑，玩耍，充满对战争的无知而欢笑。有些女性已经失去了丈夫，或者失去了两个，她们更加沉思。你走过队伍去找%companyname%，并告诉他们任务的细节。 | %employer% 的士兵已经准备好战斗了。年轻人紧张不安，用虚假的勇气和不情愿的笑容掩饰他们的恐惧。老兵们继续执行他们的任务，他们的脸上显示出知道那些从未归来的老战友的人。而那些疯狂的、眼中冒血的家伙们，在即将到来的战争前几乎早早地感到兴奋。你穿过他们，去通知 %companyname% 需要做什么。 | 当你走出来时，你发现 %employer% 的军队士兵正在准备行军。武器散乱在一堆里供士兵们自由挑选。这是一个奇怪的景象，显示出缺乏组织。可能不是最好的信号，但你将其置于身后，去通知 %companyname% 完成新的合同任务。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们走！",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TroopsHaveDied",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_22.png[/img]所有贵族士兵在赶往攻城时都已经阵亡了。他们死了总比你死好。%companyname%继续前进，走向%objective%。",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们必须继续。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ArrivingAtTheSiege",
			Title = "临近 %objective%…",
			Text = "[img]gfx/ui/events/event_68.png[/img]{你终于来到了围困现场。绿皮兽人包围了%objective%，你看着他们的攻城器械向空中发射着燃烧的石头。半个城镇已经被火焰吞噬，你看到小小的人影匆忙地跑来跑去扑灭火势。贵族士兵的中尉命令你前去攻击攻城器械，然后重新汇合并消灭剩余的敌人。 | %objective%看起来更像是一个巨大的篝火而不是一个城镇。你看着绿皮兽人的攻城器械发射出狂暴的轰炸，天空中充满了黑色的石头、死牛和燃烧的木材。贵族士兵的中尉命令你摧毁攻城器械。他和他的士兵将攻击绿皮兽人军队的主力部队，然后你们两个将重新汇合消灭任何残存的敌人。 | %objective%仍然坚持着，围困还在继续。看起来你们来得正是时候，因为绿皮兽人从攻城器械中发射出的破坏力如此之大，可能几个小时后就没有城镇了。看着这一幕，贵族士兵的中尉命令你侧翼攻击并摧毁攻城武器。他和他的士兵将攻击兽人军队的主要部队，然后你们一起重新汇合，消灭任何幸存者。 | 你先是听到轰击声，然后才看到了轰击。围绕%objective%的绿色野蛮人周围有着敌军攻城器械，正在猛烈地攻击，投石车、投尸器、尸体包扔过来，什么都用得上。\n\n高贵士兵的队长跟你介绍了他的计划。你需要从侧翼攻击攻城器械。他和他的士兵将攻击绿皮兽军的中心，成功后，你们两个将重新联合并消灭其余的敌人。 | 一名年轻的女子被发现在路上和一群孩子蜷缩在一起，就像冬天里的狼崽子。干血粘在她的头侧，但她用几缕凌乱的头发掩盖住了。她解释说，如果你要%objective%，你必须赶紧。绿皮族已经设置了他们的攻城武器，并发起了疯狂的轰击。你和高贵士兵继续前进，把女子留下一些面包来喂孩子们。\n\n攀登过下一个山丘，你看到了一个证明难民所说的故事的景象。贵族士兵的队长迅速下达命令。你和%companyname%将进攻攻城器械，而士兵们则进攻绿皮兽人军队的核心。完成这些任务后，你们将会汇合，消灭任何残留的敌人。 | 你和士兵们翻过了最近的山丘来到达%objective%。城镇还在那里，但它更接近于一堆废墟，而不是一个村庄。绿皮兽人肯定已经用他们简陋的攻城器械轰击它有一段时间了，而他们似乎并没有打算就此停止。\n\n贵族战士的队长命令你去迂回敌人，攻击攻城武器。与此同时，士兵们将攻击敌军的核心部队。完成两项任务后，你将会会合士兵们摧毁剩余的敌军残部。 | 你发现一个老人正在沿着路推一辆手推车。在车上，是一名双腿破碎的年轻人。他昏迷了过去，双手还紧握着破碎的膝盖。老人说%objective%就在附近的山丘上，那里正在遭受攻击。所以如果你要采取行动，最好赶紧去。%companyname%和士兵们前进了，留下老人独自继续前行。\n\n长老没有说谎： %objective% 被烧毁，正慢慢地变成废墟，被一堆野蛮的攻城器械围攻。见到这一幕，贵族士兵们的中尉迅速制定了一个行动计划： %companyname% 将从侧面攻击攻城器械，而士兵们则与大部分的绿皮兽人作战。一旦两项任务完成，您们将重聚并消灭剩余的敌人。 | 你发现一群野狗沿着道路奔跑。他们远离你的小组，但你注意到他们的尾巴紧贴着腿，头低垂。他们快速地路过你，没有停顿。\n\n翻过下一个山头，你看到混乱的原因：绿皮兽人正在用简陋的攻城机械无情轰击%objective%。部队队长点头表示同意，并迅速下达命令。%companyname%将侧翼进攻并直接摧毁攻城武器。完成任务后，你们需要绕回来与士兵汇合，然后继续前进。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "做好准备战斗！",
					function getResult()
					{
						this.Contract.setState("Running_BreakSiege");
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.spawnSiege();
			}

		});
		this.m.Screens.push({
			ID = "ArrivingAtTheSiegeNoTroops",
			Title = "临近 %objective%…",
			Text = "[img]gfx/ui/events/event_68.png[/img]{你终于看到了%objective%，并且它处于极度危险之中。城镇正在遭受一连串的绿皮兽攻城战争机器的轰炸。你下令%companyname%准备行动：你将侧翼包抄敌军，并直接攻击这些攻城机械。 | 所有的贵族士兵都已经死亡，你独自到达%objective%。还是有绿皮兽在继续轰击这个可怜的城镇，使用拼凑的攻城武器。你决定最好的行动方案是侧翼包抄野蛮人并攻击他们的攻城机械。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "做好准备战斗！",
					function getResult()
					{
						this.Contract.setState("Running_BreakSiege");
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.spawnSiege();
			}

		});
		this.m.Screens.push({
			ID = "SiegeEquipmentAhead",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_68.png[/img]{绿皮族已经在附近集结了一些攻城武器。你必须摧毁它们来帮助解除围城！ | 你的部队发现附近有几件攻城器械。绿皮族准备发动进攻！摧毁这些武器将有助于解除围城！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "开战！",
					function getResult()
					{
						this.Contract.getActiveState().onCombatWithSiegeEngines(null, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Shaman",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_48.png[/img]{你走近了包围着的地精，看到了一个独特的身影站在他们的队伍之中。那是一个萨满。你告诉你的队员为之做好充分准备。 | 一个独特的身影在地精中脱颖而出。你看到它用那可怕的语言发出命令。这个污秽的东西被奇怪的植物缠绕着，并佩戴着动物骨头的项链。%SPEECH_ON%那是一个萨满。%SPEECH_OFF% %randombrother%加入了我们的一方说道。%SPEECH_ON%我会提醒其他人的。%SPEECH_OFF% | %randombrother%从侦查中返回。他分享了一个消息，即有一个地精萨满在入侵的绿皮兽人组内。那个人似乎相当恼火。%SPEECH_ON%我喜欢杀掉这些地精，但这次他们会给我们带来真正的头疼。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "开战！",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Warlord",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_49.png[/img]{当你临近围攻的绿皮兽人时，你会注意到一个几乎无法忽视的东西：一位兽人督军高大威猛。这个恶心的东西的盔甲在它转身喊叫着命令它的兽人战士时闪闪发光，鼓舞着他们的狂热。你让%randombrother%散布消息并准备士兵。 | 当你走近包围营地时，你会认出那高大的残暴的兽人督军的身影。即使在这样的距离，你也能听到他朝着手下怒吼的声音。这场战斗爆发的越来越扣人心弦。 | 你临近绿皮兽人的营地时，只听到清晰的兽人督军的咆哮。他用那种令人讨厌的语言大声喊出命令。他的出现让任务稍稍更有挑战，你通知士兵这一点。 | %randombrother%从侦查任务归来，他说有一个兽人督军在绿皮兽人的营地里。虽然是个坏消息，但现在知道并做好准备总比事先一无所知然后惊讶地被攻击强。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "开战！",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TheAftermath",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_22.png[/img]{战斗结束了，绿皮兽人从战场上溃败了。%objective%获救了，%employer%应该会很高兴的。你跨过了成堆的尸体，无论是人还是兽，集合你的士兵返回。 | 战场上到处都是尸体，许多苍蝇已经开始围绕和繁忙起来。你集合你的士兵，准备回到%employer%拿取报酬。 | %objective%得救了！嗯，尽管只剩下一点。士兵和绿皮兽人，活着的和垂死挣扎的，充斥着地面到你视线能够触及的地方。这是一个残酷的景象，新鲜血淋淋的。你下令%companyname%准备返回%employer%拿取报酬。 | 成堆的尸体，两三个，甚至四个尸体堆成一堆。幸存者被埋在这些死人下面，尽管仍在地面上，也深埋了六英尺深。这是一个可怕的景象，更加令人不安的是，重伤和垂死的人们呼救声不断。在尸体和血肉之海中发现他们就像是在浩渺黑暗的海洋上寻找漂浮的水手。你转身离开这个景象，集合%companyname%的士兵。%employer%应该很期待你们的回归。 | 战斗胜利结束，你看着长矛手们小心地在战场上踱步。他们用长兵器的优势去安全地处理任何还躺在地上的绿皮兽人。其余的贵族士兵都倒在地上，喝水，洗掉脸上的血迹。你没有时间休息，快速召集你的雇佣兵回到%employer%。 | 血浑浊了大地，你的靴子深深陷入泥潭。尸体散落在周围，身体变得陌生，肢体被扯落并遍地散开。断头之处，双目中凝结着惊恐之色。折断的箭矢，打碎的长矛，无人问津的剑。碎裂铠甲在脚下发出嘎吱声。这场战斗可谓是煞费苦心，对所有人，这场战斗都留下了深深的印记。\n\n成功拯救了%objective%后，你慢慢地召集%companyname%返回%employer%领取丰厚的报酬。 | 战斗结束后，高尚的士兵们没有浪费时间，开始砍下他们能找到的每一个绿皮兽人的脑袋。他们将这些头颅刺在长矛上，并高高举起，仿佛在模仿刚刚被他们消灭的野蛮人的残暴行径。你没有时间参与这样的戏剧性演出。%objective%已经得救，这是你将获得报酬的原因。%companyname%迅速集结，准备返回%employer%。 | 战斗结束后，你小心翼翼地穿过战场。每一个尸体都诉说着它们的故事。有些人被人从背面刺杀，有些人失去了头颅，他们的故事将会在别的地方讲述，还有些人的肠子被挖了出来，他们紧紧地抱着它们，震惊地看着自己所见证的不该被看见的事情。与众无异，只是不同的地方而已。最重要的是%objective%仍然屹立不倒。你召集%companyname%返回%employer%领取报酬。 | %randombrother% 走到你身边。他拿着一个兽人的头，但是很快就把它扔掉了，好像已经过了新奇的感觉。他把双手放在臀部，点点头看着战场。%SPEECH_ON%好吧，这算是点收获了。%SPEECH_OFF%尸体散落在地上，有时候会堆叠成三四层。脚肢上撕裂的伤口，苍白的脸庞和渗出的鲜血。士兵们穿过这一切，他们的脚下踩着汇集成河流的鲜血，像是在小溪里行进一般。%objective% 看起来还在远方燃烧，但这已经足够了。%companyname% 现在应该返回 %employer% 领取报酬。 | 围攻已经解除，尽管绿皮族不是自愿放弃的。死去的人和野兽散落在你眼前的整片土地上，没有多少可以想象的场景被留给你。%randombrother% 走到你身边。他揭起一块绿色的肉，像拧湿的抹布一样向外甩了一下。%SPEECH_ON%战斗真是一场壮观的厮杀，长官。%SPEECH_OFF%你点点头，命令他准备部队。%employer% 听到 %objective% 已经被保存下来一定会非常高兴的。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "胜利！",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{你带着一些下属回到了%employer%的面前，他们报告了最新的消息。你的雇主很快点了点头，递给你一个大麻袋的克朗。在你离去的时候，他的下属们都有些嫉妒地看着你。 | 围城被攻破，你向%employer%报告了这个消息。他点了点头，并给了你一个装满克朗的小口袋。%SPEECH_ON%他们会传颂你的。我是说，那些还未诞生的人们。%SPEECH_OFF% | 你向%employer%传递了被攻坚散的消息。他站起来和你握手。%SPEECH_ON%靠着古老的神，你今天的服务永远不会被忘记！%SPEECH_OFF%但是你心里却想着这些话说给一个现在只有骨头和灰尘的人听过。不过你还是拿到了报酬，将遗产和历史留给哲学家。 | %employer% 欣然欢迎您的回归，他立刻站起来，差点绊倒了一只狗。%SPEECH_ON%雇佣军，我已经听到了这个好消息！围城已被解除，您确实赚了一笔不小的报酬！%SPEECH_OFF% 他将沉重的箱子放在桌子上，您接过去，数着克朗，然后离开了。 | 当你进入时，%employer%正在他的桌子后面坐着。%SPEECH_ON%进来吧，“英雄”。你希望下一个记录在案的是什么？%SPEECH_OFF%你问他他在说什么。%SPEECH_ON%请不要这么谦虚，雇佣兵。你所完成的事情值得那些甚至未出生的人口传颂！%SPEECH_OFF%你点点头。%SPEECH_ON%嗯，好吧，那很不错。我的钱呢？%SPEECH_OFF%你的雇主嘴唇紧抿。他也点了点头，递给你一个提包。%SPEECH_ON%我相信你是一个任务众多的人，但这个任务对我们来说意义重大！%SPEECH_OFF% | 当你进入时，%employer%低头看着他的脚。有人藏在他的桌子下面，他没有试图掩盖他的情妇。%SPEECH_ON%欢迎回来，佣兵！你的薪水在那个角落里。那个角落，那边的角落。别试图偷看。%SPEECH_OFF%你拿到报酬，朝门口走去。%employer%向你喊叫，并竖起了大拇指。%SPEECH_ON%顺便说一句，干得好。%SPEECH_OFF%你点了点头，离开了。 | 你带着一些队长们进入%employer%的房间。他们看到你们后立即站起来，但很快就挥手让他的士兵们出去。他们听从了他的指示，懒洋洋地离开了。你摇了摇头。%SPEECH_ON%他们也参加了战斗。%SPEECH_OFF%%employer%把你打发走。%SPEECH_ON%他们当然参加了战斗，而且他们已经在薪水名单上了。不过，你是按合同雇佣的，合同已经履行完毕。顺便说一句，那些人不要看到我给你的薪水，这样也许更好。%SPEECH_OFF%你拿到了你的报酬，那是足以引起嫉妒的数额，你在走出大厅的路上藏起来了。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "%objective% 安全了。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "打破了围攻 " + this.Flags.get("ObjectiveName"));
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isGreenskinInvasion())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCriticalContract);
						}

						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了 [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] 克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "%objective% 附近",
			Text = "[img]gfx/ui/events/event_68.png[/img]{你花费的时间太久了，现在%objective%已经被毁了。绿皮族使用了震惊战术冲破了城墙，从漂来的臭味不难发现城内所有人都已被屠杀。 | %companyname%没有及时解围导致%objective%付出了代价。他们本以为你会拯救他们，但却让他们失望了。如果有好消息的话，那就是没有人幸存下来诉说你的失败。然而你的雇主：%employer%则是另一回事。这位贵族毫无疑问会对你的无为愤怒。 | %objective%已经被破城而入了！兽人使用了可怕的战争机器摧毁了城墙。凶残的绿皮族涌入城镇，杀害了一切可以杀害的人，将一切可以抓的人掳到诸神都不知道的地方。你的雇主：%employer%对你的失败感到非常愤怒！ | 你没有及时解围%objective%！绿皮族击破了城门，城镇已经消失。考虑到%employer%的付费目标与之相反，可以肯定他对这一进展感到不满。 | 你在混乱中没有完成你的工作，导致%objective%被绿皮族攻陷！愿众神怜悯城民，但不要期望你的雇主%employer%会对这个结果感到满意。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "%objective% 陷落了。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, function ()
						{
							return this.RenderTemplate("未能突破针对%s的围攻", this.Flags.get("ObjectiveName"));
						}());
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function spawnSiege()
	{
		if (this.m.Flags.get("IsSiegeSpawned"))
		{
			return;
		}

		this.m.SituationID = this.m.Origin.addSituation(this.new("scripts/entity/world/settlements/situations/besieged_situation"));
		local originTile = this.m.Origin.getTile();
		local orcBase = this.World.getEntityByID(this.m.Flags.get("OrcBase"));
		local goblinBase = this.World.getEntityByID(this.m.Flags.get("GoblinBase"));
		local numSiegeEngines;

		if (this.m.DifficultyMult >= 1.150000)
		{
			numSiegeEngines = this.Math.rand(1, 2);
		}
		else
		{
			numSiegeEngines = 1;
		}

		local numOtherEnemies;

		if (this.m.DifficultyMult >= 1.250000)
		{
			numOtherEnemies = this.Math.rand(2, 3);
		}
		else if (this.m.DifficultyMult >= 0.950000)
		{
			numOtherEnemies = 2;
		}
		else
		{
			numOtherEnemies = 1;
		}

		for( local i = 0; i < numSiegeEngines; i = ++i )
		{
			local tile;
			local tries = 0;

			while (tries++ < 500)
			{
				local x = this.Math.rand(originTile.SquareCoords.X - 2, originTile.SquareCoords.X + 2);
				local y = this.Math.rand(originTile.SquareCoords.Y - 2, originTile.SquareCoords.Y + 2);

				if (!this.World.isValidTileSquare(x, y))
				{
					continue;
				}

				tile = this.World.getTileSquare(x, y);

				if (tile.getDistanceTo(originTile) <= 1)
				{
					continue;
				}

				if (tile.Type == this.Const.World.TerrainType.Ocean)
				{
					continue;
				}

				if (tile.IsOccupied)
				{
					continue;
				}

				break;
			}

			local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).spawnEntity(tile, "攻城车", false, this.Const.World.Spawn.GreenskinHorde, this.Math.rand(100, 120) * this.getDifficultyMult() * this.getScaledDifficultyMult());
			this.m.UnitsSpawned.push(party.getID());
			party.setDescription("一大群绿皮和他们的攻城车。");
			local numSiegeUnits = this.Math.rand(3, 4);

			for( local j = 0; j < numSiegeUnits; j = ++j )
			{
				this.Const.World.Common.addTroop(party, {
					Type = this.Const.World.Spawn.Troops.GreenskinCatapult
				}, false);
			}

			party.updateStrength();
			party.getLoot().ArmorParts = this.Math.rand(0, 15);
			party.getLoot().Ammo = this.Math.rand(0, 10);
			party.addToInventory("supplies/strange_meat_item");
			party.getSprite("body").setBrush("figure_siege_01");
			party.getSprite("banner").setBrush(goblinBase != null ? goblinBase.getBanner() : "banner_goblins_01");
			party.getSprite("banner").Visible = false;
			party.getSprite("base").Visible = false;
			party.setAttackableByAI(false);
			party.getFlags().add("SiegeEngine");
			local c = party.getController();
			c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
			c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
			local wait = this.new("scripts/ai/world/orders/wait_order");
			wait.setTime(9000.000000);
			c.addOrder(wait);
		}

		local targets = [];

		foreach( l in this.m.Origin.getAttachedLocations() )
		{
			if (l.isActive() && l.isUsable())
			{
				targets.push(l);
			}
		}

		if (targets.len() == 0)
		{
			foreach( l in this.m.Origin.getAttachedLocations() )
			{
				if (l.isUsable())
				{
					targets.push(l);
				}
			}
		}

		for( local i = 0; i < numOtherEnemies; i = ++i )
		{
			local tile;
			local tries = 0;

			while (tries++ < 500)
			{
				local x = this.Math.rand(originTile.SquareCoords.X - 4, originTile.SquareCoords.X + 4);
				local y = this.Math.rand(originTile.SquareCoords.Y - 4, originTile.SquareCoords.Y + 4);

				if (!this.World.isValidTileSquare(x, y))
				{
					continue;
				}

				tile = this.World.getTileSquare(x, y);

				if (tile.getDistanceTo(originTile) <= 1)
				{
					continue;
				}

				if (tile.Type == this.Const.World.TerrainType.Ocean)
				{
					continue;
				}

				break;
			}

			local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).spawnEntity(tile, "大群绿皮", false, this.Const.World.Spawn.GreenskinHorde, this.Math.rand(90, 110) * this.getDifficultyMult() * this.getScaledDifficultyMult());
			this.m.UnitsSpawned.push(party.getID());
			party.setDescription("一大群绿皮向战场进军。");
			party.getLoot().ArmorParts = this.Math.rand(0, 15);
			party.getLoot().Ammo = this.Math.rand(0, 10);
			party.addToInventory("supplies/strange_meat_item");
			party.getSprite("banner").setBrush(orcBase != null ? orcBase.getBanner() : "banner_orcs_01");
			local c = party.getController();
			local raidTarget = targets[this.Math.rand(0, targets.len() - 1)].getTile();
			c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
			local raid = this.new("scripts/ai/world/orders/raid_order");
			raid.setTime(30.000000);
			raid.setTargetTile(raidTarget);
			c.addOrder(raid);
			local destroy = this.new("scripts/ai/world/orders/destroy_order");
			destroy.setTime(60.000000);
			destroy.setSafetyOverride(true);
			destroy.setTargetTile(originTile);
			destroy.setTargetID(this.m.Origin.getID());
			c.addOrder(destroy);
		}

		if (this.m.Troops != null && !this.m.Troops.isNull())
		{
			local c = this.m.Troops.getController();
			c.clearOrders();
			local intercept = this.new("scripts/ai/world/orders/intercept_order");
			intercept.setTarget(this.World.getEntityByID(this.m.UnitsSpawned[this.m.UnitsSpawned.len() - 1]));
			c.addOrder(intercept);
			local guard = this.new("scripts/ai/world/orders/guard_order");
			guard.setTarget(originTile);
			guard.setTime(120.000000);
		}

		this.m.Origin.spawnFireAndSmoke();
		this.m.Origin.setLastSpawnTimeToNow();
		this.m.Flags.set("IsSiegeSpawned", true);
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"objective",
			this.m.Flags.get("ObjectiveName")
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
				this.World.setSpeedMult(1.000000);
			}

			this.World.State.m.LastWorldSpeedMult = 1.000000;

			if (!this.m.Flags.get("IsSiegeSpawned"))
			{
				this.spawnSiege();
			}

			foreach( id in this.m.UnitsSpawned )
			{
				local e = this.World.getEntityByID(id);

				if (e != null && e.isAlive())
				{
					e.setAttackableByAI(true);

					if (e.getFlags().has("SiegeEngine"))
					{
						local c = e.getController();
						c.clearOrders();
						local wait = this.new("scripts/ai/world/orders/wait_order");
						wait.setTime(120.000000);
						c.addOrder(wait);
					}
				}
			}

			if (this.m.Origin != null && !this.m.Origin.isNull())
			{
				this.m.Origin.getSprite("selection").Visible = false;
			}

			if (this.m.Home != null && !this.m.Home.isNull())
			{
				this.m.Home.getSprite("selection").Visible = false;
			}
		}

		if (this.m.Origin != null && !this.m.Origin.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Origin.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(2);
			}
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isGreenskinInvasion())
		{
			return false;
		}

		local numAttachments = 0;

		foreach( l in this.m.Origin.getAttachedLocations() )
		{
			if (l.isActive() && l.isUsable())
			{
				numAttachments = ++numAttachments;
			}
		}

		if (numAttachments < 2)
		{
			return false;
		}

		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Troops != null && !this.m.Troops.isNull())
		{
			_out.writeU32(this.m.Troops.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local troops = _in.readU32();

		if (troops != 0)
		{
			this.m.Troops = this.WeakTableRef(this.World.getEntityByID(troops));
		}

		this.contract.onDeserialize(_in);
	}

});
