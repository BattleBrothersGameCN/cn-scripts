this.escort_envoy_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.escort_envoy";
		this.m.Name = "护送特使";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
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

			if (s.getOwner() == null || s.getOwner().getID() == this.getFaction())
			{
				continue;
			}

			if (s.isIsolated() || !this.m.Home.isConnectedTo(s) || this.m.Home.isCoastal() && s.isCoastal())
			{
				continue;
			}

			candidates.push(s);
		}

		this.m.Destination = this.WeakTableRef(candidates[this.Math.rand(0, candidates.len() - 1)]);
		local distance = this.getDistanceOnRoads(this.m.Home.getTile(), this.m.Destination.getTile());
		this.m.Payment.Pool = this.Math.max(250, distance * 7.0 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult());

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		local titles = [
			"特使",
			"使者"
		];
		this.m.Flags.set("EnvoyName", this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
		this.m.Flags.set("EnvoyTitle", titles[this.Math.rand(0, titles.len() - 1)]);
		this.m.Flags.set("DestinationName", this.m.Destination.getName());
		this.m.Flags.set("Bribe", this.beautifyNumber(this.m.Payment.Pool * this.Math.rand(75, 150) * 0.01));
		this.m.Flags.set("EnemyName", this.m.Destination.getOwner().getName());
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"护送%envoy%%envoy_title%至" + this.Contract.m.Destination.getName() + "，此地在出发地的%direction%方向"
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
				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					if (this.Contract.getDifficultyMult() >= 1.0)
					{
						this.Flags.set("IsShadyDeal", true);
					}
				}

				local envoy = this.World.getGuestRoster().create("scripts/entity/tactical/humans/envoy");
				envoy.setName(this.Flags.get("EnvoyName"));
				envoy.setTitle(this.Flags.get("EnvoyTitle"));
				envoy.setFaction(1);
				this.Flags.set("EnvoyID", envoy.getID());
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.Destination.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.World.getGuestRoster().getSize() == 0)
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Destination))
				{
					this.Contract.setScreen("Arrival");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsShadyDeal"))
				{
					if (!this.Flags.get("IsShadyDealAnnounced"))
					{
						this.Flags.set("IsShadyDealAnnounced", true);
						this.Contract.setScreen("ShadyCharacter1");
						this.World.Contracts.showActiveContract();
					}
					else if (this.World.State.getPlayer().getTile().HasRoad && this.Math.rand(1, 1000) <= 1)
					{
						local enemiesNearby = false;
						local parties = this.World.getAllEntitiesAtPos(this.World.State.getPlayer().getPos(), 400.0);

						foreach( party in parties )
						{
							if (!party.isAlliedWithPlayer)
							{
								enemiesNearby = true;
								break;
							}
						}

						if (!enemiesNearby && this.Contract.getDistanceToNearestSettlement() >= 6)
						{
							this.Contract.setScreen("ShadyCharacter2");
							this.World.Contracts.showActiveContract();
						}
					}
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getID() == this.Flags.get("EnvoyID"))
				{
					this.World.getGuestRoster().clear();
				}
			}

		});
		this.m.States.push({
			ID = "Waiting",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"在" + this.Contract.m.Destination.getName() + "周围等待%envoy%%envoy_title%完事。"
				];
				this.Contract.m.Destination.getSprite("selection").Visible = true;
			}

			function update()
			{
				this.World.State.setUseGuests(false);

				if (this.Contract.isPlayerAt(this.Contract.m.Destination) && this.Time.getVirtualTimeF() >= this.Flags.get("WaitUntil"))
				{
					this.Contract.setScreen("Departure");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"护送%envoy%%envoy_title%回到" + this.Contract.m.Home.getName()
				];
				this.Contract.m.Destination.getSprite("selection").Visible = false;
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				this.World.State.setUseGuests(true);

				if (this.World.getGuestRoster().getSize() == 0)
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getID() == this.Flags.get("EnvoyID"))
				{
					this.World.getGuestRoster().clear();
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
			Text = "[img]gfx/ui/events/event_63.png[/img]{%employer%身边站着个人。你几乎看不清他的脸，每次你想看清时他都刻意躲闪。%SPEECH_ON请放心，这是%envoy%。你不需要看到他的脸。只要护送他到%objective%就行。他要去说服当地人加入我们的事业。当然，%enemynoblehouse%肯定不乐意看到这种事情，所以行动要隐蔽。%SPEECH_OFF%你点头表示理解这种家族间的政治纠葛。%SPEECH_ON%很好佣兵。有兴趣接这活吗？%SPEECH_OFF% | 一个人从%employer%房间的阴影里走出来向你伸手。握手时他自我介绍%SPEECH_ON%我是%employer%手下的%envoy%。我们……%SPEECH_OFF%%employer%插嘴。%SPEECH_ON%我需要你护送这人去%objective%。那里是%enemynoblehouse%的领地，所以要秘密行动。你只要确保他到达目的地，再带他回来领赏。这差事适合你吧？%SPEECH_OFF% | %employer%把一张卷轴拍在你胸口上。%SPEECH_ON%门外有个特使叫%envoy%，他要去%objective%说服他们加入我们。%SPEECH_OFF%你接过卷轴，指出一个显而易见的问题：那是%enemynoblehouse%的领地。%employer%点头。%SPEECH_ON%没错。所以找你而不是我的封臣。没必要引发战争对吧？只要护送%envoy%往返。有兴趣就先谈价钱，然后把卷轴给特使并一起出发。%SPEECH_OFF% | %employer%看着地图问你有没有参与政治活动。你耸肩，他点头%SPEECH_ON%猜到了。偏巧有政治任务交给你，护送%envoy%特使去%objective%做……政治游说，让当地人归顺我们，不是什么需要提心吊胆的差事。那里不是我的地盘，所以才找你这种没人当回事的佣兵护送。无意冒犯。%SPEECH_OFF%你摆手表示不要紧。%employer%继续道。%SPEECH_ON%有兴趣就护送他往返。听起来简单吧？甚至不需要你开口说话！%SPEECH_OFF% | %employer%研究着地图上自家与%enemynoblehouse%的边界，突然一拳捶在对方领土上。%SPEECH_ON%好了佣兵，我需要可靠的人护送特使%envoy%到%objective%——你有点政治知识就知道那不是我的地盘。%SPEECH_OFF%你点头表示明白他的意思。%SPEECH_ON%你负责护送，他负责谈判，再带他回来。你只是一名不隶属于任何家族的跟班，明白？有兴趣就谈报酬。%SPEECH_OFF% | %employer%把一张皱巴巴的纸扔到桌上，明显是份坏消息。%SPEECH_ON%我女儿们要出嫁了，可我的领地太少，收不上来足够的税，没法给她们办场像样的婚礼。%SPEECH_OFF%你不在乎这些事情，让他直接讲重点。%SPEECH_ON%行行行，不说这些没用的了。说正事，我需要你护送我的特使%envoy%去%objective%。他要去说服当地人投靠我们。那小块地方是%enemynoblehouse%的领地，他们要是发现我们在那儿活动肯定不高兴。所以才雇你这个没名没姓的佣兵来照看我的特使。%SPEECH_OFF%这人把双手往腿上一搭。%SPEECH_ON%这差事你感兴趣吗？只要把他送到再带回来就行。钱好赚，简单得很！%SPEECH_OFF% | %employer%读着卷轴突然笑起来，嘴角控制不住地上扬。%SPEECH_ON%好消息，佣兵！%enemynoblehouse%的百姓看来受够他们的统治了！%SPEECH_OFF%你挑起眉毛点头假意附和。他把椅子拖到桌边仔细查看地图，继续说道。%SPEECH_ON%更好的消息：我有个叫%envoy%的特使今天要去%objective%去做点……谈话。路上全是下三滥的毛贼，%enemynoblehouse%的领主更是阴险，所以这人需要保护！这就是你该出场的时候了。你只要把他送到再带回来就行。%SPEECH_OFF% | %employer%身边站着个人。他和你握手自称%envoy%，算是个特使。你问这人什么来头，%employer%很快解释道。%SPEECH_ON%他要去%objective%——那是%enemynoblehouse%的封地。我们说不定能说服当地人归顺我们。既然你现在知道这人和他的任务了，总该明白为什么找你这个佣兵而不是我的封臣了吧。\n\n只要护送他到%objective%，等他把该办的事办完再带回来。事后结账。干不干？%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{谈谈价钱吧。 | 对你来说值多少？ | 报酬如何？}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{你得去别的地方找保镖。 | 我们不想接这类差事。}",
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
			ID = "Arrival",
			Title = "%objective%里",
			Text = "[img]gfx/ui/events/event_20.png[/img]{你们抵达了%objective%。%envoy_title%%envoy%走进一栋建筑，轻轻带上了门。你一只脚蹬在墙上等他回来。几个农民来来往往。鸟儿啁啾。你已经很久没留意过它们的鸣唱了。\n\n看来得等上一阵子。或许该趁这时间补充返程的物资？ | 特使闪身进了%objective%的议事厅。你已安全送达，剩下的就交给他了。有段时间你靠在窗边听里面谈话，这人口齿伶俐，召集人手的能力比你带着几把剑可强多了。特使透过窗户看见你，微微摆手示意你离开。你退到远处等他完事。 | 几个衣着体面的人将你们迎进%objective%。他们问%envoy%%envoy_title%你是不是他的随行人员。他点头确认，又快速对议员们低语几句。对方点头回应，随后众人悄然躲进当地酒馆。你在门外等候。或许该趁此机会补充返程物资？ | %employer%认为%objective%可以倒向他的想法看来没错：当地人已经成群涌上街头。一排守卫站在大宅外用横转的长矛阻挡人群。有个富人探出窗口试图劝散人群，但愤怒的呐喊淹没了他的声音。%envoy%灵巧地穿过人群，与几位披斗篷的议员会合。他们溜进附近建筑，你在外等候。 | %objective%显得相当萧条——街上的农民不是愤愤不平就是懒散度日。这可不是健康村镇该有的景象。%envoy%%envoy_title%走进当地酒馆，一群聚在一起的人谨慎地迎接他。他摆手让你回避，于是你站在门外等他办完事。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "{别耗太久。 | 我们会呆在附近。}",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.World.getGuestRoster().get(0).getImagePath());
				this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(20, 60) * 1.0);
				this.Contract.setState("Waiting");
			}

		});
		this.m.Screens.push({
			ID = "Departure",
			Title = "%objective%里",
			Text = "[img]gfx/ui/events/event_20.png[/img]{过了一阵子特使才走出来。你问他是否遇到麻烦，他说没有。该返回%employer%那里了。 | 门开了，特使迈步而出。他让你带路返回。 | 没过多久特使就回来了。他告诉你事情已办完，需要立即返回%employer%处。 | %envoy%匆忙回到你身边。他说必须尽快返回%employer%那里。 | 特使回来后表示谈话很顺利，要求你尽快护送他回到%employer%处。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "{总算搞定了，出发！ | 怎么这么久？}",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.World.getGuestRoster().get(0).getImagePath());
				this.Contract.setState("Return");
			}

		});
		this.m.Screens.push({
			ID = "ShadyCharacter1",
			Title = "%townname%里",
			Text = "[img]gfx/ui/events/event_51.png[/img]{你正要离开镇子，一名披斗篷的男子前来搭话。他的脸始终藏在兜帽阴影里，你只能偶尔瞥见他的牙齿和尖削的下巴。%SPEECH_ON%时机到来时，你会睁只眼闭只眼吗，佣兵？%SPEECH_OFF%在没等你回答，他便走开了。 | 你正在做离镇准备时，有个男人撞上了你。他没有道歉，反而从黑色长斗篷下窥视着你。%SPEECH_ON%总有一天你得做出选择。留下战斗，或者离开苟活。选第二条路会有金子跟着你，选第一条路只有铁锹埋你……%SPEECH_OFF%你伸手想抓住他，他却退后一步，混入了恰巧经过的人流中。 | 你正准备离开%townname%，一个披深色斗篷的男人来到你身旁。他没有看你，只是开口说道。%SPEECH_ON%我的资助人料到你会出现。%employer%雇佣你是明智之举。不过你还有选择余地，当时机来临……你会走哪条路%SPEECH_OFF%你告诉他去找别人说这些神神叨叨的。 | 刚离开%employer%的住处，一个黑衣人就拦住了你。他扫视你的肩后，低声说%SPEECH_ON%%employer%付得不少，但我认识出价更高的人。时机到了就装作没看见……%SPEECH_OFF%这陌生人后退一步溜到门后。你推门追赶时他已消失，只有个厨工站在那里，{一副 | 一副}什么都没看见的模样。 | 带着%employer%的任务，你准备出发。 一个披斗篷的陌生人趁你整理物资靠近过来。他开口时嗓音沙哑。%SPEECH_ON%很多双眼睛盯着你呢，佣兵。下一步可要走稳了。你还有机会抽身而退。等到时机来临，我们只求你让开条路。%SPEECH_OFF%你拔剑威慑，他却躬身退避，翻飞的斗篷隐入被你突然拔剑惊扰的农民人群中。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "{事情变得有趣起来…… | 看来麻烦正在发酵。}",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "ShadyCharacter2",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_07.png[/img]{行进途中，一伙武装分子突然拦住去路，其中就有先前那个鬼祟人影。他们声称要带走特使，承诺给你%bribe%克朗作为回报。\n\n否则……他们就只能动手抢人了。 | 你正习惯性地听着特使絮叨，暗自希望他独自消失在林间时，武装分子骤然现身。早前见过的陌生人站在队伍里，要求你交出特使，并承诺支付%bribe%克朗。若你拒绝，他们不介意采取更激烈的手段。\n\n在你思索选项时，当你权衡之际，特使难得地保持了沉默。 | 行军路上，一伙武装分子拦停队伍。你认出早前那陌生人正站在其中。他们要求你交出特使，指着一个满满的钱袋，声称里面共有%bribe%克朗，同时也按着腰间武器——显然已做好你拒绝时动用武力的准备。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "既然能白拿克朗，我们又何苦去赚血汗钱？ 成交。",
					function getResult()
					{
						return "ShadyCharacter3";
					}

				},
				{
					Text = "想要人的话，有本事就来抢。",
					function getResult()
					{
						return "ShadyCharacter4";
					}

				}
			],
			function start()
			{
				this.Characters.push(this.World.getGuestRoster().get(0).getImagePath());
				this.Flags.set("IsShadyDeal", false);
			}

		});
		this.m.Screens.push({
			ID = "ShadyCharacter3",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{正当你权衡时，特使凑近低声说道。%SPEECH_ON%你不会让他们带走我的，对吧？%employer%让你保护我可是给了个很高的价码。%SPEECH_OFF%你点头搭着他肩膀轻声回复。%SPEECH_ON%说得对。他开价是很高。 但他们出价更高。%SPEECH_OFF%说罢你将人往前推去。他刚要挣扎，剑锋已截断话音。鲜血泼溅地面，抽剑时带出满地肠脏。神秘人递来钱袋。%SPEECH_ON%合作愉快，佣兵。%SPEECH_OFF% | 你看了看特使，接着又看向神秘人并朝他们点头示意。 他抓住你衣襟哀求。%SPEECH_ON%不，不要！你答应过%employer%会保证我的安全！%SPEECH_OFF%你把人交出去。他们马上割开他的喉咙，他跪倒在地，手指捂着喷血的伤口。杀手们踢踹着逐渐僵直的特使，在哄笑声中送他上路。钱袋落入你手中，递钱者拍你肩膀。%SPEECH_ON%感谢配合，佣兵。不愧是你这行的本色。%SPEECH_OFF% | 你瞥了眼特使并摇头道。%SPEECH_ON%佣兵的本分就是价高者得。%SPEECH_OFF%特使刚要喊叫，有人拿着小弩上前一箭射穿他眉心，箭杆从后脑穿出挂着脑浆。神秘人抛来钱袋。%SPEECH_ON%对大伙来说这事算倒霉还是走运？%SPEECH_OFF%你数着克朗回应。%SPEECH_ON%本来两边都占点，等你的人给特使脑袋开了洞，现在就只剩走运了。%SPEECH_OFF%神秘人歪嘴一笑。%SPEECH_ON%真可惜。我倒喜欢听不同说法，这样才有意思。%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "{这钱好挣。 | 双赢。}",
					function getResult()
					{
						this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().set("Betrayed", true);
						this.World.Assets.addMoney(this.Flags.get("Bribe"));
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "未能保护好特使");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.updateAchievement("NeverTrustAMercenary", 1, 1);
				this.Characters.push(this.World.getGuestRoster().get(0).getImagePath());
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("Bribe") + "[/color]克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "ShadyCharacter4",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_50.png[/img]{你用一只手臂将特使护在身后，另一只手拔出了剑。那个神秘男子点了点头，缓缓退回到自己的战线后方。%SPEECH_ON%真是遗憾，但我此行的任务仍必须完成。我相信你能理解。 %SPEECH_OFF% | 神秘男子伸出一只手，手指蜷曲，仿佛要将使者从你身边拽过去。然而，你却将使者推回了你的战线后方。那陌生人立刻点了点头。%SPEECH_ON%可以理解。但不可通融。我们各有其主，佣兵。你必须忠于你的雇主，而我也必须忠于我的。就让胜者去回报那些将信任托付于我们手中的人吧。%SPEECH_OFF% | 特使向你哀求，但你让他闭嘴，随后转身面向那群杀手。%SPEECH_ON%这位特使必须活着离开这里。%SPEECH_OFF%神秘陌生人点了点头，无声地退入他的战线后方。%SPEECH_ON%我明白。公事公办，而现在，这场公事必须有个结果。%SPEECH_OFF%他的手下们踏步上前，纷纷拔剑出鞘。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Mercs";
						p.Entities = [];
						p.Parties = [];
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Mercenaries, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.World.getGuestRoster().get(0).getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{你带着特使回到%employer%那里。%SPEECH_ON%啊，佣兵，看来你照我说的办了。特使你……？%SPEECH_OFF%%envoy%低身上前对贵族耳语。贵族向后靠了靠，点点头。%SPEECH_ON%好，很好。我们好好谈谈……噢，还有佣兵，你的报酬就在外面等着你。 随便找个卫兵问就是了。%SPEECH_OFF%两人转身离开。你走到大厅，有个壮汉递给你装着%reward_completion%克朗的袋子。 | 回到%employer%处，特使离开你身边，迅速而低声地汇报消息。%employer%点头不语，随后向附近守卫打了个响指。持械守卫上前递给你一个布袋。等你接过钱袋抬头时，贵族和特使早已消失。 | 你平安护送%envoy%归来，特使向你道谢。%employer%却没那么友善，只顾着与那名秘密使者交谈。正当你等着领赏时，一名守卫悄然走近，把木箱塞进你怀里。%SPEECH_ON%这是%reward_completion%克朗。不放心可以数数。%SPEECH_OFF% | 你始终没搞懂%employer%那个鬼鬼祟祟的代表在城里做了什么。特使和雇主一照面就凑近低声交谈。你刚上前想问报酬，守卫就拦住去路，把钱袋塞进你怀里。%reward_completion%克朗如数在内。你对政治没兴趣，很快便离开这密谈的两人。 | %employer%张开双臂迎接你。%SPEECH_ON%哈，你平安把%envoy%带回来了！%SPEECH_OFF%他拥抱了特使，但只和你握手，顺势把一袋克朗塞进你手里。%SPEECH_ON%早知道能信任你，佣兵。现在请……%SPEECH_OFF%他朝门口示意。你转身离去，留那两人继续商谈。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "来之不易。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "成功护送特使");
						this.World.Contracts.finishActiveContract();
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
			Title = "战斗之后",
			Text = "[img]gfx/ui/events/event_60.png[/img]{特使没能活下来。%employer% 虽然能承受零星损失，但对此绝不会感到高兴。下次尽量别再让他失望了。 | 不幸的是，%envoy%%envoy_title%已倒毙在你脚下。对一个被承诺安全庇护的人而言，这是何等悲惨的结局！罢了。往后最好别让%employer%再度失望。 | 呵，瞧瞧：特使死了。 你唯一的任务就是让那人继续喘气。现在，他做不到了。不必与%employer%交谈也能知道，他绝不会对此感到满意。 | 你保证过要保护使者免受伤害。再没有什么比彻底死亡更严重的伤害了，看来你这次的任务失败得相当彻底。 | 保护好特使。让特使活着回来。特使必须活着。嘿，我是特使，我很重要，不能死！\n\n这些话语想必是被当成了耳旁风，因为特使确实已经死了。 | 当整个世界都想要一个人死时，保他活命实属不易。可悲的是，%envoy%%envoy_title%没能走完他的旅途。%employer%不大可能对此人的过世感到高兴。}",
			Image = "",
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "该死的！",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "未能保护好特使");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"objective",
			this.m.Flags.get("DestinationName")
		]);
		_vars.push([
			"bribe",
			this.m.Flags.get("Bribe")
		]);
		_vars.push([
			"envoy",
			this.m.Flags.get("EnvoyName")
		]);
		_vars.push([
			"envoy_title",
			this.m.Flags.get("EnvoyTitle")
		]);
		_vars.push([
			"enemynoblehouse",
			this.m.Flags.get("EnemyName")
		]);
		_vars.push([
			"direction",
			this.m.Destination != null && !this.m.Destination.isNull() ? this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Destination.getTile())] : ""
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.m.Destination.getSprite("selection").Visible = false;
			this.m.Home.getSprite("selection").Visible = false;
			this.World.State.setUseGuests(true);
			this.World.getGuestRoster().clear();
		}
	}

	function onIsValid()
	{
		if (this.World.FactionManager.isCivilWar())
		{
			return false;
		}

		if (this.m.IsStarted)
		{
			if (this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive())
			{
				return false;
			}

			return true;
		}
		else
		{
			local settlements = this.World.EntityManager.getSettlements();
			local hasPotentialDestination = false;

			foreach( s in settlements )
			{
				if (!s.isDiscovered() || s.isMilitary() || s.isIsolated())
				{
					continue;
				}

				if (s.getOwner() == null || s.getOwner().getID() == this.getFaction())
				{
					continue;
				}

				hasPotentialDestination = true;
				break;
			}

			if (!hasPotentialDestination)
			{
				return false;
			}

			return true;
		}
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

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local dest = _in.readU32();

		if (dest != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(dest));
		}

		this.contract.onDeserialize(_in);
	}

});
