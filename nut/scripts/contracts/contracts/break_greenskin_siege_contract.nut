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
			this.m.DifficultyMult = this.Math.rand(90, 105) * 0.01;
		}
		else
		{
			this.m.DifficultyMult = this.Math.rand(115, 135) * 0.01;
		}

		this.m.Type = "contract.break_greenskin_siege";
		this.m.Name = "解围";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
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
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
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
					"前往%objective%",
					"打破绿皮的围攻"
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
				local party = faction.spawnEntity(this.Contract.getHome().getTile(), this.Contract.getHome().getName() + "战团", true, this.Const.World.Spawn.Noble, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.getSprite("banner").setBrush(faction.getBannerSmall());
				party.setDescription("听命于当地领主的职业军人。");
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

				this.World.State.setEscortedEntity(this.Contract.m.Troops, true);
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
						this.World.State.setEscortedEntity(this.Contract.m.Troops, true);
						this.Contract.m.IsEscortUpdated = true;
					}

					this.World.State.setCampingAllowed(false);
					this.World.State.getPlayer().setPos(this.Contract.m.Troops.getPos());
					this.World.State.getPlayer().setVisible(false);
					this.World.Assets.setUseProvisions(false);
					this.World.getCamera().moveTo(this.World.State.getPlayer());
				}

				if ((this.Contract.m.Troops == null || this.Contract.m.Troops.isNull() || !this.Contract.m.Troops.isAlive()) && !this.Flags.get("IsTroopsDeadShown"))
				{
					this.Flags.set("IsTroopsDeadShown", true);
					this.World.State.setCampingAllowed(true);
					this.World.State.setEscortedEntity(null);
					this.World.State.getPlayer().setVisible(true);
					this.World.Assets.setUseProvisions(true);
					this.World.State.resetSpeedToNormal();
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
					this.World.State.resetSpeedToNormal();
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
					"摧毁所有绿皮攻城器",
					"消灭%objective%周边的所有绿皮"
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer%递给你一杯酒。%SPEECH_ON%干了。%SPEECH_OFF%你几乎能从他呼吸中嗅到坏消息的味道。你将酒一饮而尽，朝那人点了点头。他也点头回应。%SPEECH_ON%绿皮正在这片区域肆虐，看样子他们打算拿下%objective%。%SPEECH_OFF%他又倒了一杯酒，喝干，然后再倒一杯。%SPEECH_ON%如果它陷落了，那我想我们可以认为这个区域的其余部分也会随之完蛋。我不知道你是否清楚十年前这些绿皮来袭时发生了什么，但这附近没多少人想再看重演一遍。现在，我的探子告诉我围城刚刚开始，绿皮还没有完全集结，意味着我们可以现在就进攻，在局势失控之前打破围城。如果你有兴趣——旧神在上，我真心希望你有——那么我需要你去那里，解除围城！%SPEECH_OFF% | 守卫们围在%employer%身边。他们摘下了头盔，满头大汗，有些人在盔甲里瑟瑟发抖。%employer%透过这群绝望的人看到了你，招手让你上前。%SPEECH_ON%佣兵！我有一些……特别糟糕的消息。或许你已经听说了，但时间紧迫我就长话短说：绿皮可能已经入侵了这个区域，并且他们正威胁要拿下%objective%。他们目前正在围城，但报告说绿皮还没完全集结。我需要你去那里，在局势失控之前打破围城。%SPEECH_OFF% | %employer%身边站着几位书记员。他们轮流低语，贵族则对他们说的一切都只是点头。最终，%employer%将注意力转向你。%SPEECH_ON%佣兵，你以前打破过围城吗？本地区的%objective%目前正被绿皮围困。我们的时间不多了，他们很快就会攻占那里，然后可能拿下整个地区！在那之后……嗯，我相信你知道十年前发生了什么。%SPEECH_OFF%书记员们齐刷刷地点头并低下脑袋。%employer%继续说道。%SPEECH_ON%那么你怎么说，对军事行动感兴趣吗？%SPEECH_OFF% | %employer%面带忧色地迎接你。%SPEECH_ON%我们有点麻烦，佣兵，我们需要你的帮助！%objective%已被绿皮围困，而我自己没有足够的兵力去独自解围。但我觉得你能胜任这个任务。你能吗？报酬会很丰厚。%SPEECH_OFF% | %employer%双臂撑在桌上站着。他耸着肩膀，像一只乌鸦俯视着猎物。他摇了摇头。%SPEECH_ON%佣兵，我需要更多人马来帮忙击退围困%objective%的绿皮大军。你能胜任吗？我现在就需要知道。%SPEECH_OFF% | 你一进去，%employer%就站了起来。他脸上带着汗，挤出一个慌乱又勉强的微笑。%SPEECH_ON%佣兵！太、太高兴你来了！有消息说绿皮已经围困了%objective%，我需要你的帮助！你有没有兴趣？你最好尽快决定。%SPEECH_OFF% | 你发现%employer%深陷在他的椅子里，仿佛希望椅背能合上，将他永远隔绝出这个世界。他懒洋洋地朝桌上一张地图指了指。%SPEECH_ON%嗯，消息是绿皮回来了，他们正在围困%objective%。我需要尽可能多的人手去那里解围。报酬会相当可观，你加入吗？%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{救下%objective%值多少？ | %companyname%的能力足以解围。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{这事不划算。 | 我们还有其他任务。}",
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
			Title = "%townname%里……",
			Text = "[img]gfx/ui/events/event_78.png[/img]{你走出%employer%的住所，开始整备战团。周围到处都是跑来跑去的骑士和士兵。其中一些人围在神职人员周围，无声地为死亡做准备。%SPEECH_ON%他们正在天堂订位子呢。%SPEECH_OFF%%randombrother%凑到边上，冲你促狭地咧嘴一笑。%SPEECH_ON%怎么，太阴暗了吗？%SPEECH_OFF% | %employer%的宅邸外，士兵们四处奔忙。一些人正把补给品搬上马车，剩下的则在磨砺他们的武器，还有个把侍从，抱着大堆盔甲来回穿梭。你走到队伍前，命令他们准备好。%randombrother%向忙碌的人群点了点头。%SPEECH_ON%看来这次我们有伴儿了。%SPEECH_OFF% | %employer%的房间外有士兵，大厅里也有士兵。走过的房间里，里面是惊恐的妇孺和恨不得自己耳聋的瞎眼老人。到了外面，你不得不费力穿过一群忙碌的侍从，他们正抱着武器盔甲来回穿梭。%companyname%正等着你。%SPEECH_ON%我们出发吧。这儿的人还得准备好才能打仗，但我们早就准备好了，对吧伙计们？%SPEECH_OFF% | 离开%employer%的地方，你发现%randombrother%正等着你。他正看着四周繁忙的战前准备：抱着武器盔甲奔跑的侍从、往马车上搬运补给品的士兵、以及暂时安抚着年轻士兵恐惧的神职人员。你告诉你的佣兵做好准备，你们将跟随这些士兵出发去解围。 | 你走到外面，看到%employer%的士兵正为战斗准备。他们正把装备装上马车，一位神职人员正在他们中间走动。妇女、儿童和老人站在路边。%companyname%的成员正尽责地列队等候。你走过去告诉他们手头的任务。 | 走出去后，你发现%employer%的士兵正整装待发。儿童们肆意奔跑，欢笑，玩着打仗游戏，全然不知真正的战争就要来了。妇女们则显得忧虑得多，其中一些已经失去过一两个丈夫。你穿过行进的队伍找到%companyname%，告诉他们任务的细节。 | %employer%的士兵们正在为战争做准备。年轻人很紧张，用强装的勇气和勉强的笑声掩饰恐惧。老兵们埋头做自己的事，脸上显出对昔日从未归来的老战友的思念。而那些疯狂的、瞪大眼睛、嗜血成性的人，对即将到来的战争前景则带着令人不安的兴奋。你经过他们所有人，去告知%companyname%他们必须完成的任务。 | 当你走出来时，你发现%employer%的军队正为行军做准备。武器堆成一大摊，士兵在里面挑挑拣拣。这种怪象显示了组织度的缺乏。这不是个好兆头，但你把它抛在脑后，告诉%companyname%他们的新合同。}",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]贵族军队的所有人都死在了赶赴围城阵地的路上。总比你死了强。%companyname%继续向%objective%进军。",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们必须前进。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ArrivingAtTheSiege",
			Title = "%objective%附近……",
			Text = "[img]gfx/ui/events/event_68.png[/img]{你终于抵达了围城战场。绿皮包围了%objective%，你看着他们的战争机器将燃烧的石头抛向空中。半个城镇似乎已经起火，你能看到微小的人影来回奔跑试图灭火。贵族军队的指挥官命令你去攻击那些攻城器械。之后你们再会合，清剿任何残存的野人。 | %objective%看起来更像一个巨大的篝火，而不是一个城镇。你看着绿皮的攻城器械发动猛烈轰击，天空中充斥着黑色的石头、死牛和燃烧的木材。贵族军队的指挥官命令你摧毁那些攻城器械。他和他的手下将攻击绿皮军队的主力，然后你们两队再会合，消灭任何残敌。 | 围城仍在激烈进行，%objective%看来还在坚守。你们似乎来得正是时候，因为绿皮正用他们的攻城器械倾泻着巨量的破坏，再过几个小时恐怕城镇就不剩什么了。目睹此景，贵族军队的指挥官命令你们侧翼包抄，摧毁那些攻城武器。他和他的士兵将攻击敌军的核心，然后你们再会合，屠杀任何幸存者。 | 你先是听到轰击声，然后才看到了轰击。攻城弹的呼啸声如同狂风般划过空气，它们坠地时的撞击声则是最残酷的终曲。最终，你们登上山顶，看清了%objective%的全貌。它被绿皮包围着，他们的攻城器械正在笨拙而猛烈地运作，发射石头、死牛、成捆的人类尸体——任何这些杂种能搞到手的东西。\n\n贵族军队的指挥官向你提出了他的计划。你们负责侧翼包抄并攻击攻城器械。他和他的士兵将攻击绿皮军队的中心，一旦成功，你们两队再会合，歼灭所有残余敌人。 | 你们在路上发现一个年轻女子，一群孩子像严冬里的狼崽一样紧紧依偎着她。她头侧凝结着干涸的血迹，虽然她用一绺缠结的头发巧妙地遮掩着。她解释说，如果你们要去%objective%，必须抓紧时间。绿皮已经架起了攻城武器，正在发动猛烈的轰击。你和贵族军队继续前进，给那女人留下一袋面包喂养孩子们。\n\n登上下一座山丘，眼前的景象证实了难民的描述。贵族军队的指挥官迅速下达命令。你和%companyname%负责攻击攻城器械，而士兵们则攻击绿皮军队的主力。一旦这两项任务完成，你们将汇合，歼灭任何残敌。 | 你和贵族军队登上了最靠近%objective%的山丘。城镇还在，但该死的，它现在更像一堆废墟。绿皮肯定用他们那些简陋的攻城器械轰击了好一阵子了，而且他们看起来丝毫没有要停下的意思。\n\n贵族军队的指挥官命令你们侧翼包抄野蛮人，攻击他们的攻城武器。同时，士兵们将攻击敌军的主力。两项任务完成后，你们将再次会合，消灭所剩无几的散兵游勇。 | 你们发现一个老人正沿路推着一辆手推车。车斗里躺着一个双腿被压碎的年轻人。他已经昏了过去，双手仍紧抓着破碎的膝盖。老人说%objective%就在最近那座山丘那边，正遭受攻城武器的轰击，所以如果你们要采取行动，最好快点。%companyname%和士兵们继续前进，留下老人独自缓慢前行。\n\n老人没有说谎：%objective%正在燃烧，在一大群攻城器械的攻击下正慢慢化为瓦砾。亲眼目睹后，贵族军队的指挥官迅速制定了一个行动方案：%companyname%负责侧翼包抄并攻击攻城武器，而士兵们则对付绿皮军队的主力。两项任务完成后，你们将再次会合，杀死任何还活着的东西。 | 你们遇到一大群野狗沿路奔跑。它们避开了你们的队伍，但你注意到它们夹着尾巴，低着头。它们没有停下，迅速地与你们擦身而过。\n\n 登上下一座山丘，你看到了混乱的根源：绿皮正用一排排简陋的攻城器械无情地轰击着%objective%。贵族军队的指挥官对此点了点头，迅速厉声下达命令。%companyname%将侧翼包抄，直接攻击那些攻城武器。完成后，你们要绕回来与士兵会合，并从那里继续推进。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "做好战斗准备！",
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
			Title = "%objective%附近……",
			Text = "[img]gfx/ui/events/event_68.png[/img]{你终于看到了%objective%，它已岌岌可危。城镇正受到绿皮攻城器的连环轰炸。你命令%companyname%准备行动：你们将从侧翼包抄敌军，直接攻击这些攻城器。 | 在贵族军队全员阵亡后，你独自抵达了%objective%。绿皮还在城镇周围，用拼凑的攻城器轰击着它。你决定包抄这些野人，攻击他们的攻城器。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "做好战斗准备！",
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
			Text = "[img]gfx/ui/events/event_68.png[/img]{绿皮已在附近组装了一些攻城器械。你必须摧毁它们以解除围城！ | 你的手下在附近发现了几件攻城器械。绿皮必定在准备发动突击！你要摧毁它们以解除围城！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "接敌！",
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
			Text = "[img]gfx/ui/events/event_48.png[/img]{你走向围城的地精，在队伍中看到了一个独特的身影。那是地精萨满。你让手下做好充分准备。 | 一个独特的身影矗立在地精当中。它用自以为是语言的骇人声音发号施令。这邪性家伙身上绕着奇怪的植物，还戴着一串似乎是动物骨头做成的项链。%SPEECH_ON%那是个萨满。%SPEECH_OFF%%randombrother%凑近了说道。%SPEECH_ON%我会提醒其他人的。%SPEECH_OFF% | %randombrother%的侦察结束了。他带来消息说，攻城队伍中有一名地精萨满。那人似乎相当恼火。%SPEECH_ON%我喜欢杀地精，但这次恐怕要头疼了。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "接敌！",
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
			Text = "[img]gfx/ui/events/event_49.png[/img]{当你接近围城的绿皮时，你发现了一个几乎不可能忽视的存在：一名高大威猛的兽人军阀。那丑恶家伙的盔甲在其转身用兽人语咆哮着下令时闪闪发光，刺激着它的绿皮同伙陷入一种狂暴、口沫横飞的狂热之中。你让%randombrother%将消息传开，并让兄弟们做好准备。 | 走近围城营地的同时，你认出了兽人军阀那高大残暴的身影。即使在这么远的距离，你也能听到他朝着手下怒吼的声音。这场战斗越来越扣人心弦了。 | 你朝绿皮的营地走去，只听到兽人军阀独特的咆哮声。他用那令人作呕且相当响亮的语言高声下达命令。他的出现让任务稍稍棘手了一点，你把这个情况告知了弟兄们。 | %randombrother%侦察归来，说绿皮营地里有个兽人军阀。虽然是个坏消息，但提前知道并做好准备，总比临阵被打个措手不及要好。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "接敌！",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{战斗结束了，绿皮已被逐出战场。%objective%得救了，%employer%肯定会非常满意。你踏过堆积如山的人类或野兽尸体，召集你的手下准备返回。 | 尸体遍布战场，成群的苍蝇已开始聚集忙碌。你集结手下，准备返回%employer%处领取报酬。 | %objective%得救了！嗯，至少剩下的部分得救了。士兵和绿皮，死者与垂死者，铺满了目光所及之地。景象残酷，且如此新鲜。你命令%companyname%准备返回%employer%处领取报酬。 | 尸堆叠了两层、三层，有时甚至四层高。被压在这些死者之下的幸存者，虽在地面却如同身处三尺之下。这景象相当骇人，而伤者和垂死者的呼救声更是凄厉。在肢骸的海洋中寻找他们，如同试图在黑暗的海洋中找到一名漂浮的水手。你转身离开这场景，召集%companyname%的成员。%employer%应该正高兴地等着你们归来。 | 战斗胜利结束，你看着持长戟的士兵小心翼翼地穿行战场。他们用长兵器的优势去安全地处理任何还躺在地上的受伤绿皮。其余的士兵瘫坐在地上，喝水并洗去脸上的血迹。你没时间这样休息，迅速召集你的佣兵返回%employer%处。 | 血污浸染大地，你的靴子深陷泥泞。尸体四处横陈，身躯已难以辨认，肢体分离，散落在远离主人的地方。断首处处，双眼凝固着惊骇。断裂的箭矢、破碎的长矛、遗弃的刀剑。碎裂的盔甲碎片在脚下咯吱作响。这真是场恶战，无疑给所有后来者留下了触目惊心的印记。\n\n既然%objective%已经获救，你慢慢召集%companyname%，准备返回%employer%处领取丰厚的报酬。 | 战斗结束，士兵们毫不耽搁地砍下他们能找到的每一个绿皮的脑袋。他们将头颅插在长矛上高高举起。这行径无疑是在模仿他们刚刚解决的兽人。你没时间搞这种戏码。%objective%得救了，这是你领取报酬的理由。%companyname%迅速集合，准备返回%employer%处。 | 战斗结束，你小心翼翼地穿过战场。每具尸体都在诉说着它的由来。有些背后中剑，有些身首异处，还有些被开膛破肚，被发现时紧抓着自己的内脏，脸上带着目睹了不该看之物的惊骇表情。没什么新鲜的，都一样，只是地点不同。最重要的是%objective%依然屹立。你召集%companyname%返回%employer%处领取报酬。 | %randombrother%来到你身边。他拎着一个绿皮的脑袋，但很快把它扔了，仿佛那点新鲜感刚刚消失。他双手叉腰，对着战场点了点头。%SPEECH_ON%呵，够劲。%SPEECH_OFF%尸体，有时堆叠三四层高，散落一地。肢体扭曲，面容紧绷，能听到血液流淌的声音。士兵们穿行其间，他们的腿搅动起积聚血液的大片飞沫，仿佛在涉过溪床。%objective%，或许仍在燃烧，但依然矗立在远方，这对你来说才是最重要的。%companyname%现在该返回%employer%处领取报酬了。 | 围城已经解除，尽管绿皮并非自愿放弃。死去的士兵和野兽铺满了你目光所及的土地，无疑也如实填满了更远处的敌方。%randombrother%来到你身边。他从肩上拎起一条绿色的肉条，像甩湿布一样把它甩掉。%SPEECH_ON%真是场恶战，头儿。%SPEECH_OFF%你点点头，命令他让兄弟们做好准备。%employer%听到%objective%已得救的消息，应该会非常高兴。}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{你返回到%employer%那里，身后跟着他的几位指挥官。他们汇报了情况，你的雇主迅速点了点头，递给你一大袋克朗。在你离开时，他的指挥官们向你投来些许嫉妒的目光。 | 围城已被解除，你向%employer%报告了这一消息。他点点头，给了你一袋克朗。%SPEECH_ON%你的美名会流传下去的。当然还得等上一段时间。%SPEECH_OFF% | 你告知%employer%围城已被解除的消息。他站起身与你握手。%SPEECH_ON%旧神在上，你今日的功绩必将被永世铭记！%SPEECH_OFF%但你心里却在想，这句一模一样的话，是否也曾对某个如今已化为枯骨尘埃的人说过。你依然收下了报酬，把传承与历史留给哲学家们去思考。 | %employer%热情地欢迎你的归来，他猛地站起身，差点被自己的一条狗绊倒。%SPEECH_ON%佣兵，我已经听到这个好消息了！围城已解，你确实值得一份丰厚的报酬！%SPEECH_OFF%他将一个沉重的箱子搬到桌上。你接过箱子，清点了克朗，然后便告辞了。 | 你进去时，%employer%正坐在他的桌子后面。%SPEECH_ON%进来吧，‘英雄’。他们该在你的名字旁边刻上什么好呢？%SPEECH_OFF%你问他到底在说什么。%SPEECH_ON%佣兵，拜托。别这么谦虚，你的成就是值得后辈传颂的！%SPEECH_OFF%你点点头。%SPEECH_ON%是啊，当然。这很好，都没错。我的钱在哪儿？%SPEECH_OFF%你的雇主抿紧了嘴唇。他也点点头，把袋子递了过来。%SPEECH_ON%我确信你是干大事的人。这次任务对你来说不算什么，但对我们却意义重大！%SPEECH_OFF% | 你进去时，%employer%正低头看着自己的脚。他的桌子底下有人，而他并未试图隐藏他的情妇。%SPEECH_ON%欢迎回来，佣兵！你的报酬在角落里。那个角落，那边。别想偷看。%SPEECH_OFF%你拿到报酬，朝门口走去。%employer%朝你喊了一声，大拇指坚定地翘向空中。%SPEECH_ON%顺便说一句，干得好。%SPEECH_OFF%你点点头离开了。 | 你走进%employer%的房间，他的几位指挥官紧跟着你。此人一看到你们这帮人就站了起来，但迅速挥手让他的士兵出去。他们服从命令，慢吞吞地离开了。你摇了摇头。%SPEECH_ON%他们也参与战斗了。%SPEECH_OFF%%employer%对你摆摆手。%SPEECH_ON%他们当然参与战斗了，但他们早就领过军饷了。而你，是按合同办事，现在合同履行完毕了。顺便说一句，别让那些人看到我付给你多少，或许才是最好的。%SPEECH_OFF%你收下了报酬。这数目绝对会引人嫉妒，你在走出大厅时把它藏了起来。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "%objective%得救了。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "从围攻中拯救了" + this.Flags.get("ObjectiveName"));
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
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color]克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "%objective%周边",
			Text = "[img]gfx/ui/events/event_68.png[/img]{你耽搁了太久，如今%objective%已化为一片废墟。绿皮以闪电般的恐怖战术攻破了城墙。顺着风飘来的气味足以让人意识到，里面的所有人已被屠戮殆尽。 | %companyname%没能及时解围，%objective%为此付出了代价。他们本以为你会拯救他们，但你却让他们失望了。如果说有什么好消息，那就是没人能幸存下来诉说你的失败。怎么应付雇主%employer%就是另一码事了。毫无疑问，这位贵族会对你的无所作为感到愤怒。 | %objective%被攻破了！兽人驾驭着可怕的战争机器摧毁了城墙。凶残的绿皮涌入城镇，杀害了一切敢于挡路的人，或者将人掳到了鬼知道是哪的地方。你的雇主%employer%对你的失败非常愤怒！ | 你没能及时为%objective%解围！绿皮冲破了城门，把城镇夷为平地。考虑到这和%employer%付费的目的相反，可以肯定，他对事情发展成这样感到不满。 | 你磨磨蹭蹭不务正业，致使%objective%被绿皮攻陷！愿众神怜悯其中居民，但不要指望你的雇主%employer%会对这个结果感到满意。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "%objective%陷落了。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, function ()
						{
							return this.RenderTemplate("未能解%s之围", this.Flags.get("ObjectiveName"));
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

		if (this.m.DifficultyMult >= 1.15)
		{
			numSiegeEngines = this.Math.rand(1, 2);
		}
		else
		{
			numSiegeEngines = 1;
		}

		local numOtherEnemies;

		if (this.m.DifficultyMult >= 1.25)
		{
			numOtherEnemies = this.Math.rand(2, 3);
		}
		else if (this.m.DifficultyMult >= 0.95)
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

			local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).spawnEntity(tile, "攻城器", false, this.Const.World.Spawn.GreenskinHorde, this.Math.rand(100, 120) * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
			this.m.UnitsSpawned.push(party.getID());
			party.setDescription("带着攻城器的绿皮军团。");
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
			wait.setTime(9000.0);
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

			local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).spawnEntity(tile, "绿皮军团", false, this.Const.World.Spawn.GreenskinHorde, this.Math.rand(90, 110) * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
			this.m.UnitsSpawned.push(party.getID());
			party.setDescription("奔赴战场的绿皮军团。");
			party.getLoot().ArmorParts = this.Math.rand(0, 15);
			party.getLoot().Ammo = this.Math.rand(0, 10);
			party.addToInventory("supplies/strange_meat_item");
			party.getSprite("banner").setBrush(orcBase != null ? orcBase.getBanner() : "banner_orcs_01");
			local c = party.getController();
			local raidTarget = targets[this.Math.rand(0, targets.len() - 1)].getTile();
			c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
			local raid = this.new("scripts/ai/world/orders/raid_order");
			raid.setTime(30.0);
			raid.setTargetTile(raidTarget);
			c.addOrder(raid);
			local destroy = this.new("scripts/ai/world/orders/destroy_order");
			destroy.setTime(60.0);
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
			guard.setTime(120.0);
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
			this.World.State.resetSpeedToNormal();

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
						wait.setTime(120.0);
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
