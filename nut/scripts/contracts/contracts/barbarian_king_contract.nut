this.barbarian_king_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Threat = null,
		LastHelpTime = 0.0,
		IsPlayerAttacking = false,
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

		this.m.Type = "contract.barbarian_king";
		this.m.Name = "野蛮人国王";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 5.0;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 1700 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"猎杀野蛮人国王和他的战团",
					"据最新报告，他最后一次出没，是在%region%地区，在你%direction%边"
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
				local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians);
				local nearest_base = f.getNearestSettlement(this.World.State.getPlayer().getTile());
				local party = f.spawnEntity(nearest_base.getTile(), "蛮王", false, this.Const.World.Spawn.Barbarians, 125 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.setDescription("一个强大的野蛮部落战团，集结在野蛮人国王旗下。");
				party.getSprite("body").setBrush("figure_wildman_04");
				party.setVisibilityMult(2.0);
				this.Contract.addUnitsToEntity(party, this.Const.World.Spawn.BarbarianKing, 100);
				this.Contract.m.Destination = this.WeakTableRef(party);
				party.getLoot().Money = this.Math.rand(150, 250);
				party.getLoot().ArmorParts = this.Math.rand(10, 30);
				party.getLoot().Medicine = this.Math.rand(3, 6);
				party.getLoot().Ammo = this.Math.rand(10, 30);
				party.addToInventory("supplies/roots_and_berries_item");
				party.addToInventory("supplies/dried_fruits_item");
				party.addToInventory("supplies/pickled_mushrooms_item");
				party.getSprite("banner").setBrush(nearest_base.getBanner());
				party.setAttackableByAI(false);
				local c = party.getController();
				local patrol = this.new("scripts/ai/world/orders/patrol_order");
				patrol.setWaitTime(20.0);
				c.addOrder(patrol);
				this.Contract.m.UnitsSpawned.push(party.getID());
				this.Contract.m.LastHelpTime = this.Time.getVirtualTimeF() + this.Math.rand(10, 40);
				this.Flags.set("HelpReceived", 0);
				local r = this.Math.rand(1, 100);

				if (r <= 15)
				{
					this.Flags.set("IsAGreaterThreat", true);
					c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives.clear();
				this.Contract.m.BulletpointsObjectives = [
					"猎杀野蛮人国王和他的战团",
					"他的战团最后现身在%region%附近，位于你%direction%边的%terrain%，靠近%nearest_town%"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onCombatWithKing.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					this.Contract.setState("Return");
				}
				else if (!this.Contract.isPlayerNear(this.Contract.m.Destination, 600) && this.Flags.get("HelpReceived") < 4 && this.Time.getVirtualTimeF() >= this.Contract.m.LastHelpTime + 70.0)
				{
					this.Contract.m.LastHelpTime = this.Time.getVirtualTimeF() + this.Math.rand(0, 30);
					this.Contract.setScreen("Directions");
					this.World.Contracts.showActiveContract();
				}
				else if (!this.Contract.isPlayerNear(this.Contract.m.Destination, 600) && this.Flags.get("HelpReceived") == 4)
				{
					this.Contract.setScreen("GiveUp");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatWithKing( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;

				if (!_dest.isInCombat() && !this.Flags.get("IsKingEncountered"))
				{
					this.Flags.set("IsKingEncountered", true);

					if (this.Flags.get("IsAGreaterThreat"))
					{
						this.Contract.setScreen("AGreaterThreat1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("Approach");
						this.World.Contracts.showActiveContract();
					}
				}
				else
				{
					this.Flags.set("IsAGreaterThreat", false);
					_dest.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(true);
					local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					properties.Music = this.Const.Music.BarbarianTracks;
					this.World.Contracts.startScriptedCombat(properties, this.Contract.m.IsPlayerAttacking, true, true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_GreaterThreat",
			function start()
			{
				this.Contract.m.BulletpointsObjectives.clear();
				this.Contract.m.BulletpointsObjectives = [
					"和野蛮人国王同行，共同面对更大的威胁"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.setFaction(2);
					this.World.State.setEscortedEntity(this.Contract.m.Destination);
				}
			}

			function update()
			{
				if (this.Flags.get("IsContractFailed"))
				{
					if (this.Contract.m.Threat != null && !this.Contract.m.Threat.isNull())
					{
						this.Contract.m.Threat.getController().clearOrders();
					}

					if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
					{
						this.Contract.m.Destination.getController().clearOrders();
						this.Contract.m.Destination.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getID());
					}

					this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
					this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "战团撕毁了合同");
					this.World.Contracts.finishActiveContract(true);
					return;
				}

				if (this.Contract.m.Threat == null || this.Contract.m.Threat.isNull() || !this.Contract.m.Threat.isAlive())
				{
					this.Contract.setScreen("AGreaterThreat5");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					if (!this.Contract.m.IsEscortUpdated)
					{
						this.World.State.setEscortedEntity(this.Contract.m.Destination);
						this.Contract.m.IsEscortUpdated = true;
					}

					this.World.State.setCampingAllowed(false);
					this.World.State.getPlayer().setPos(this.Contract.m.Destination.getPos());
					this.World.State.getPlayer().setVisible(false);
					this.World.Assets.setUseProvisions(false);
					this.World.getCamera().moveTo(this.World.State.getPlayer());

					if (!this.World.State.isPaused())
					{
						this.World.setSpeedMult(this.Const.World.SpeedSettings.FastMult);
					}

					this.World.State.m.LastWorldSpeedMult = this.Const.World.SpeedSettings.FastMult;
				}

				if (this.Contract.isPlayerAt(this.Contract.m.Threat))
				{
					this.Contract.setScreen("AGreaterThreat4");
					this.World.Contracts.showActiveContract();
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
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Flags.set("IsContractFailed", true);
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"返回" + this.Contract.m.Home.getName()
				];
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Flags.get("IsAGreaterThreat"))
					{
						this.Contract.setScreen("Success2");
					}
					else
					{
						this.Contract.setScreen("Success1");
					}

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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer%用手指转着一顶单薄的王冠。它一看就不是贵重金属做的，但毫无疑问是哪里来的王冠。他上下打量着你，那金属片在他的指尖晃来晃去。%SPEECH_ON%我早就该预料到的。人们追求权力，野蛮人也不例外。%SPEECH_OFF%他让王冠滑落到指关节上，无生气地垂在那里。%SPEECH_ON% %direction%方%region%的野蛮人正在所谓国王的麾下联合起来。一个强大又无耻的蛮子，威胁要召集一大群人，此后，嗯，我猜他想要向南扩张领地。我要你到那里去，找到这个人，干掉他。%SPEECH_OFF% | %employer%的仆人把你带到了一片菜园里。他正在那里照看番茄。他用羊毛剪修枝剪叶，为自己的好手艺频频点头。他散漫地说道。%SPEECH_ON%侦察兵告诉我，北方蛮人正在%region%附近集结军队。一帮野蛮人傻子凑到一块儿并不是什么稀奇事，但我相信这次他自称为王。至于国王们，哼，他们可不满足于自己的东西。他们想把别人的东西都纳入自己的统治，包括我的。%SPEECH_OFF%他顿了顿，朝你点头示意。%SPEECH_ON%我要你去%region%找到这所谓的蛮王，干掉他。这活不简单，但相应也有丰厚的报酬。%SPEECH_OFF% | %employer%手下的军士围在他身旁。他们对你嗤之以鼻，但%employer%自有决断。%SPEECH_ON%啊，佣兵，我确信你就是我要找的人。%region%的一位野蛮人自称天命。他甚至搞来了一顶王冠，虽然那东西八成是兽骨和鹿角做的，但其形制和意味才是关键。不光是对他，对我们也是一样。我们不能让他活着。我要你找到这原始人，在他集结起一支大到我的手下无法处理的军队前干掉他。%SPEECH_OFF% | %employer%准备了一扎麦酒，为你接风。他自己则用高脚杯倒了杯葡萄酒。%SPEECH_ON%我把你叫来，为的是杀掉，非杀不可%region%的一名原始人。他自称时国王，呵呵，所有野蛮人的宗主。虽然我对他的王权法统不屑一顾，但这显然是萌芽中的威胁，我不能坐以待毙，放任这野蛮人统揽各个村庄，召集起一支军队。我要你找到他，杀了他。这活不简单，但相应也有丰厚的报酬。%SPEECH_OFF%你怀疑他想用麦酒灌得你放松警惕，好让你接受这个荒唐的任务| %employer%拿着一对儿鹿角，角的冠枝完好无缺。他把它放在桌上，角正直的立了起来，仿佛还长着鹿身上。%SPEECH_ON%风传野蛮人正在%region%集结军队。这畜生自封为王，要是他真把这帮原始人拉拢到麾下，就会形成一股不能小瞧的势力。放着不管，咱们都得玩完，臭咯。%SPEECH_OFF%他把鹿角打翻，角尖着地，发出空洞的断裂声。%SPEECH_ON%所以我把你叫来，佣兵。我要你找到这个野蛮人，在他脑子里长出不被推翻的方法之前干掉他%SPEECH_OFF% | %employer%撅着嘴坐在椅子上。他拿着把匕首划来划去，把桌子划出一道道凹痕。%SPEECH_ON%我和部署在%direction%方的侦察员一个个失去了联络。幸存者们陆续返回，带来了野蛮人在%region%称王的消息。一个野蛮人自封为这群原始人的王，需要我告诉你问题的严重性吗。%SPEECH_OFF%你说，你能想象他夜不能寐的样子。%employer%笑了。%SPEECH_ON%没错，所以我有用于你这样魁梧、善良又文明开化的雇佣兵。我要你去找的这位所谓的国王，在他带着那群白痴在他的旗帜下行军之前干掉他%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{多大的生意？ | 这可不是件小事。 | 只要价钱合适。 | 这恐怕要多花点。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{我们可不打算对付一整支军队。 | 那不是我们要找的工作。 | 我不会让战团冒险对付这样的敌人。}",
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
			ID = "Directions",
			Title = "在途中……",
			Text = "{[img]gfx/ui/events/event_59.png[/img]一大群难民从战团边经过。有传言说野蛮人国王在%direction%方%distance%。路上的许多人都来自%nearest_town%，他们可不会坐以待毙，等着一群野蛮人淹没他们。 | [img]gfx/ui/events/event_41.png[/img]一个商人驾着一辆空货车经过。他没什么可兜售的，但他确实听到了自称为国王的野蛮人的传言。他说野蛮人就在%direction%的%region%附近。他扬起头示意你要走的路。%SPEECH_ON%如果你确实要往那儿去，就好好教训一下这帮原始人混蛋。%SPEECH_OFF% | [img]gfx/ui/events/event_94.png[/img]一个半裸的男人盘腿坐在路边。他说，野蛮人带着一支军队烧了他的农场，侮辱了妇女，杀了所有带把儿的人。%SPEECH_ON%我躲在灌木丛里，捂着嘴活了下来。%SPEECH_OFF%那人擦了擦他的鼻子。%SPEECH_ON%我看见你们带着武器。如果你是来找这野蛮人的，我可以告诉你，他们沿着%direction%方的%terrain%往%distance%的%region%去了。%SPEECH_OFF% | [img]gfx/ui/events/event_94.png[/img]你发现了一个小村庄被烧毁的遗迹。一些幸存者留了下来，他们形容枯槁，就像烧毁房子里冒出来的烟。其中一个人说，一个国王样子的人杀了所有人，抢走了不少东西，往%direction%去了。 | [img]gfx/ui/events/event_60.png[/img]在路上，你碰到了翻倒和烧着的马车。车上的东西被抢掠一空，只剩下原主人的尸体。有几个孩子在这片的废墟上翻找着。你问他们是谁干，一个厚脸皮的男孩大声说。%SPEECH_ON%从北方来的野蛮人，往%direction%去了。我亲眼所见。我敢打赌，那里是%terrain%，离这儿%distance%。%SPEECH_OFF%他抠了抠他的鼻子。%SPEECH_ON%顺便说一句，他们是杀手。跟你有点像，但更大。说不定更强壮。%SPEECH_OFF% | [img]gfx/ui/events/event_76.png[/img]路上，你碰到了%employer%的侦察员。他报告在%direction%方%terrain%的%region%附近目击到了野蛮人国王。距离%distance%。你问他愿不愿意和你一起战斗，他笑了。%SPEECH_ON%不，先生，我这样很好。我到处跑跑，侦察，看到什么就报告什么。任务间隙去找一两个妓女。多美好的生活啊，你们佣兵的活法会毁了它！%SPEECH_OFF%好吧。 | [img]gfx/ui/events/event_132.png[/img]是%randombrother%先发现了它们。遭遇战的痕迹，烧焦的尸体，变浅的脚印和车辙印，显然有军队从这里经过经过。%SPEECH_ON%看来战斗结束后他们往%direction%去了，队长。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们跟上。",
					function getResult()
					{
						this.Flags.increment("HelpReceived", 1);
						this.Contract.getActiveState().start();
						this.World.Contracts.updateActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "GiveUp",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_45.png[/img]{毫无疑问，有了你所遇到的种种迹象，以及人们给你的那些消息，你终于确切地掌握了野蛮人国王和他战团的动向。只差和他当面对质。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "加快脚步。",
					function getResult()
					{
						this.Flags.increment("HelpReceived", 1);
						this.Contract.m.Destination.setVisibleInFogOfWar(true);
						this.World.getCamera().moveTo(this.Contract.m.Destination);
						this.Contract.getActiveState().start();
						this.World.Contracts.updateActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Approach",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_135.png[/img]{野蛮人国王带着他的战团来到战场，这支队伍由一群体型硕大的恶棍、咆哮的战士、怯懦的奴隶和嚎叫的女人组成。这支军队从这片土地上攫取了一切资源，一切可以利用的东西，像雪球会演变成雪崩一样，也必将攫取文明本身。你让士兵们做好战斗准备。 | 野蛮人国王的战团在陆地上涌动，丝毫没有受训的影子，甚至没有像样的队形。但你知道，只消那野人一挥手，他就可以向他的敌人派出一群杀手，一群杀戮能力足以弥补缺乏的凝聚力的杀手。 你让士兵们做好战斗准备。 | 野蛮人的战团像是高烧时的梦境里会出现的东西，来自大陆各个角落的旅行者在地平线上现身，他们不穿任何制服或盔甲，而是穿着征服的那些人的衣服。 战士们的胳膊上裹着婚纱，没有地位的人身上披着皇家色彩的长衣，有些人穿着肋骨，走起来喀哒作响，看来是最后一批抢掠的人。 他们不过是恐怖的农夫，村庄是他们的庄稼，战争不过是不分季节的收获。\n\n看到这一幕，你摇了摇头，让士兵们做好战斗准备。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						this.Contract.getActiveState().onCombatWithKing(this.Contract.m.Destination, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_145.png[/img]{野蛮人国王死了。虽然他给自己安上了贵族的头衔，他还是和他的同胞死在了一起。野蛮。原始。除了身体更壮实，和一些靠战争、掠夺和暴力得来的装备以外，他也没有什么特别之处。你用剑砍向他的脖子，用靴子把他的头踢了下来。%randombrother%将沉重的头装进小包里。你命令你的人好好打扫战场，准备向%employer%复命。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{%companyname%的胜利！ | 胜利！}",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.setState("Return");
			}

		});
		this.m.Screens.push({
			ID = "AGreaterThreat1",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_136.png[/img]{你找到了野蛮人国王，却开始了交涉。野蛮人国王和一位长者亲自跨过田野来见你。虽然有悖常识，你还是走出去见他们。野蛮人国王说话，长老翻译。%SPEECH_ON%我们来这里不是为了征服，而是为了打败数量巨大的“不往生者”。%SPEECH_OFF%你怀疑翻译有误，请他们解释。国王和长老继续道。%SPEECH_ON%死神离开了这片土地，没有了他的引导，被杀的人将迷失在此界和彼界之间，再次复活。一大群不往生者，不死者，正在行军。我们并非是为你或你的贵族而来。你若帮助我们除灭他们，我们就离开此地，不再搅扰你的百姓。只是对付这些不往生者。%SPEECH_OFF%%randombrother%倾身低语。%SPEECH_ON%我们当然可以加入他们，但我们也可以现在就攻击他们。他们显然疏于应战，不管说了什么，他们肯定是想在这片土地上作乱，因为他们是原始的野蛮人，长官，奸淫掳掠是他们的天性。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们会正面进攻，消灭这个所谓的北方国王。",
					function getResult()
					{
						return "AGreaterThreat2";
					}

				},
				{
					Text = "我们和他们一起向“不往生者”进军。",
					function getResult()
					{
						return "AGreaterThreat3";
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "AGreaterThreat2",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_136.png[/img]{你朝长老吐了口口水，点了点头。%SPEECH_ON%我们走过被烧的房子，被强奸的妇女，和被杀害的男人，只为了找到你们这些可怜虫，现在你想联合起来？我们不是盟友。我们不是朋友。告诉你所谓的“国王”，向你的破神祈祷去吧…%SPEECH_OFF%长老举起手来，用他们的语言与王对话。 两个人点头，转身离开。%randombrother%笑了笑。%SPEECH_ON%队长，简短有力才是骂人的精髓。%SPEECH_OFF%你让他回到战线里，为接下来的战斗做好准备。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "准备战斗。",
					function getResult()
					{
						this.Flags.set("IsAGreaterThreat", false);
						this.Contract.getActiveState().onCombatWithKing(this.Contract.m.Destination, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "AGreaterThreat3",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_136.png[/img]{你向长老点头。%SPEECH_ON%好吧，我们会和你一起对付这个更大的威胁。%SPEECH_OFF%长老微笑着，拇指搓在一起，说了几句他们的话。 野蛮人国王用拳头拍了拍自己的胸部，又敲了敲你的肩膀，用手划过天空。长老笑着解释道。%SPEECH_ON%那我们就一起战斗，如果我们倒下，不必担心他变成不死者对付你。被杀了的话，国王会自己找到死神，把他的镰刀放在自己的脖子上。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "准备进军。",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				local playerTile = this.World.State.getPlayer().getTile();
				local nearest_undead = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getNearestSettlement(playerTile);
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 9, 15);
				local party = this.World.FactionManager.getFaction(nearest_undead.getFaction()).spawnEntity(tile, "不往生者", false, this.Const.World.Spawn.UndeadArmy, 260 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.getSprite("banner").setBrush(nearest_undead.getBanner());
				party.setDescription("一大群行尸，向活人索取曾属于他们的东西。");
				party.setSlowerAtNight(false);
				party.setUsingGlobalVision(false);
				party.setLooting(false);
				this.Contract.m.UnitsSpawned.push(party);
				this.Contract.m.Threat = this.WeakTableRef(party);
				party.setAttackableByAI(false);
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local wait = this.new("scripts/ai/world/orders/wait_order");
				wait.setTime(99999);
				c.addOrder(wait);
				this.Contract.m.Destination.setFaction(2);
				this.Contract.m.Destination.getSprite("selection").Visible = false;
				this.Contract.m.Destination.setOnCombatWithPlayerCallback(null);
				c = this.Contract.m.Destination.getController();
				c.clearOrders();
				local move = this.new("scripts/ai/world/orders/move_order");
				move.setDestination(party.getTile());
				c.addOrder(move);
				this.Contract.setState("Running_GreaterThreat");
			}

		});
		this.m.Screens.push({
			ID = "AGreaterThreat4",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_73.png[/img]{野蛮人没有说谎：一支古代军队已经被派来了。 他们有着腐朽的面孔和生锈的盔甲，是一大群叹息着、呻吟的怪物，光落在它们身上，也会立即消失。这无疑是一支黑暗的军队。如果是你或野蛮人单独应战，都必败无疑，但团结起来，你们还有一线生机！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "准备战斗。",
					function getResult()
					{
						this.World.Contracts.showCombatDialog(false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "AGreaterThreat5",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_136.png[/img]{古代的死者最终被打败。你的人和野蛮人打扫战场的时候，野蛮人国王和长老来到你身边。这位大块头勇士点头咕哝，长老翻译。%SPEECH_ON%他说你做得很好，非常好，他希望像你和你的战团这样的人能和他并肩作战，但他明白这是不可能的。我们生活在一个由许多世界组成的迷宫里，在这个迷宫里，我们都会驻足，迷失，有时会听到彼此的喊叫，却永远没有足够的时间互相了解。他说谢谢。他祝你好运。%SPEECH_OFF%你问长老，一声咕哝就能表达这么多意思吗。长老笑了。%SPEECH_ON%一声咕哝，没错，还有一生的友谊。 祝你好运，剑客。%SPEECH_OFF%长老递给你一顶角盔，正是野蛮人国王戴着的那顶。他什么也没说，只是拍了拍胸口，把手指指向天空。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "再会，国王。",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull() && this.Contract.m.Destination.isAlive())
				{
					this.Contract.m.Destination.die();
					this.Contract.m.Destination = null;
				}

				local item = this.new("scripts/items/helmets/barbarians/heavy_horned_plate_helmet");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "你获得了" + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_31.png[/img]{%employer%把野蛮人国王的头从袋子里倒了出来。它不受拘束地翻滚，把高脚杯撞得到处都是，叮当作响。就算死了，也不妨碍蛮子成为混乱之源%SPEECH_ON%谢谢你，佣兵。%SPEECH_OFF%你的雇主说道。他自顾自地点着头，把那头颅摆正，立了起来。%SPEECH_ON%真是个丑杂种，看看这些牙，看呐！上边全是洞，真恶心。%SPEECH_OFF%你让他付钱，他如约照做了。但他还是摇着头，呲着牙，做出剔牙的样子。%SPEECH_ON%你怎么清洁牙齿，用绳子？%SPEECH_OFF%耸了耸肩，你向门外走去。就不忙着告诉%employer%，你们对这天杀的头做的第一件事，就是用刀子把它嘴里的金子撬了出来。 | 你把野蛮人国王的头丢在%employer%的桌子上。他瞪了瞪它，又瞪了瞪你。%SPEECH_ON%这他妈是我见过最大的头。%SPEECH_OFF%你点点头，向他索要报酬。他把野蛮人的脸推来推去，像个窥探野蛮人秘密的巫师。%SPEECH_ON%我敢打赌，食人魔的传说就是这么来的。比如一个小孩看见这等丑东西，一下子想象力迸发，所谓的怪物就诞生了。%SPEECH_OFF%要是真这么简单就好了。 | 即便没有了他庞大的身躯，野蛮人国王的头颅现身在%employer%面前时，还是引起了轰动。一群贵族和仆人对它的大小发出了惊叹。一个穿着黑袍的人很快给了你应得的钱。%employer%把头扔在空中，掂了掂分量。%SPEECH_ON%旧神啊，这可真沉！喂，%randomname%。%SPEECH_OFF%一位仆人上前。你的雇主笑了。%SPEECH_ON%拿根长矛来，我要把这骇人的头举到天堂上去。%SPEECH_OFF%对野蛮人来说，是个合适的结局。 | 野蛮人国王的头刚被交给%employer%，就成了一件玩物。贵族的孩子在石头地板上踢着它滚来滚去，征服了高脚杯的高墙和餐盘的堡垒。一条狗追着头来回地蹦跳着，吠叫着。%employer%拍了拍你的肩膀。%SPEECH_ON%干的相当不错，佣兵。我说真的。我的侦察兵告诉我，你们打的天昏地暗，简直和原始人一样疯狂。但我觉得这只是无奈之举，对吧。野人对野人？太在意文明可无法抗衡这种野蛮。%SPEECH_OFF%一个孩子正踢中国王面门，踢断了下巴，撞在牙齿上撞破了脚。孩子尖声求救，也许是护主心切，那条狗跨在头上，咬着脖子上的气管，把头拖来拖去。%employer%又笑了。%SPEECH_ON%你的报酬在外面，一分不差。%SPEECH_OFF% | 一个穿着骑士甲的人从你手中夺走了野蛮人国王的头。你立刻抽出了剑，%employer%跳到你们中间，扑灭了械斗的苗头。%SPEECH_ON%喂，没事的，佣兵。你的报酬，和说好的一样。%SPEECH_OFF%他递给你一包克朗，却把头交给了身后穿黑斗篷的人。你点头问他们对这头有何打算。%employer%笑了。%SPEECH_ON%我就直说了，还有场酒会等着我呢，佣兵，而且我渴极了。%SPEECH_OFF%他快步从你身边走过。你没看到哪儿有麦酒，或是别的什么饮料，他只是跟在斗篷人后面走了。 | %employer%像只猫一样，恶狠狠地盯着野蛮人国王的头。%SPEECH_ON%有意思，我要把它做成标本，放在我的壁炉上。%SPEECH_OFF%听到他有些言语失当，你提醒雇主，那是颗人头。%employer%耸了耸肩%SPEECH_ON%那又怎么了，它是个怪物。把它搞定加深了我对“文明和野蛮不共戴天”的理解。还有什么事吗？对我还有意见？%SPEECH_OFF%撅起了嘴，你向他索要报酬。他手指着墙角。%SPEECH_ON%在那边的包里。干得不错，佣兵，但别跟我这么说话。多好的一天啊。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "受之无愧。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "杀死自封的野蛮人国王");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				local money = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color]克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_31.png[/img]{%employer%不情愿地欢迎你。%SPEECH_ON%你知道我的眼线遍布各地，对吧？%SPEECH_OFF%你举起你的手，告诉他你无意撒谎。所谓的“野蛮人国王”不会再袭扰这片土地了。你的雇主用手指轻敲了几下桌子，点了下头。%SPEECH_ON%你的诚实令人耳目一新，但我不得不说，如果他和他的战团还活着，那可算不得什么好事。不过，所有的线报都表明，他们走了，所以我想你的工作还是完成了，不管你是不是脑满肠肥的异教徒。给你报酬，和约好的一样。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "受之无愧。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "解除了自封为野蛮人国王的威胁");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				local money = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color]克朗"
				});
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		if (this.m.Destination != null && !this.m.Destination.isNull() && this.m.Destination.isAlive())
		{
			local distance = this.World.State.getPlayer().getTile().getDistanceTo(this.m.Destination.getTile());
			distance = this.Const.Strings.Distance[this.Math.min(this.Const.Strings.Distance.len() - 1, distance / 30.0 * (this.Const.Strings.Distance.len() - 1))];
			local region = this.World.State.getRegion(this.m.Destination.getTile().Region);
			local settlements = this.World.EntityManager.getSettlements();
			local nearest;
			local nearest_dist = 9999;

			foreach( s in settlements )
			{
				local d = s.getTile().getDistanceTo(this.m.Destination.getTile());

				if (d < nearest_dist)
				{
					nearest = s;
					nearest_dist = d;
				}
			}

			_vars.push([
				"region",
				region.Name
			]);
			_vars.push([
				"nearest_town",
				nearest.getName()
			]);
			_vars.push([
				"distance",
				distance
			]);
			_vars.push([
				"direction",
				this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Destination.getTile())]
			]);
			_vars.push([
				"terrain",
				this.Const.Strings.Terrain[this.m.Destination.getTile().Type]
			]);
		}
		else
		{
			local nearest_base = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getNearestSettlement(this.World.State.getPlayer().getTile());
			local region = this.World.State.getRegion(nearest_base.getTile().Region);
			_vars.push([
				"region",
				region.Name
			]);
			_vars.push([
				"nearest_town",
				""
			]);
			_vars.push([
				"distance",
				""
			]);
			_vars.push([
				"direction",
				this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(region.Center)]
			]);
			_vars.push([
				"terrain",
				this.Const.Strings.Terrain[region.Type]
			]);
		}
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
			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		return true;
	}

	function onIsTileUsed( _tile )
	{
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

		if (this.m.Threat != null && !this.m.Threat.isNull())
		{
			_out.writeU32(this.m.Threat.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local obj = _in.readU32();

		if (obj != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(obj));
		}

		obj = _in.readU32();

		if (obj != 0)
		{
			this.m.Threat = this.WeakTableRef(this.World.getEntityByID(obj));
		}

		this.contract.onDeserialize(_in);
	}

});
