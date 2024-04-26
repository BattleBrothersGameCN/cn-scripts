this.barbarian_king_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Threat = null,
		LastHelpTime = 0.000000,
		IsPlayerAttacking = false,
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

		this.m.Type = "contract.barbarian_king";
		this.m.Name = "野蛮人国王";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 5.000000;
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
					"猎杀野蛮人国王和他的战团",
					"据最新报告，他最后一次出没在%region%地区，在你%direction%边"
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
				party.setVisibilityMult(2.000000);
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
				patrol.setWaitTime(20.000000);
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
					"他的战团最后现身在%region%附近，位于你%direction%边的%terrain%上，靠近%nearest_town%"
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
				else if (!this.Contract.isPlayerNear(this.Contract.m.Destination, 600) && this.Flags.get("HelpReceived") < 4 && this.Time.getVirtualTimeF() >= this.Contract.m.LastHelpTime + 70.000000)
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
					this.World.setSpeedMult(1.000000);
				}

				this.World.State.m.LastWorldSpeedMult = 1.000000;
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% 在他的手指上顶着一个罐状物。 这是一块看上去很便宜的金属，但毫无疑问是某处的王冠。 他上下打量着你，罐状物在他的手指上来回晃动。%SPEECH_ON%我想我应该看到。 人们寻求权力，那些从野蛮人身上割下来的衣服上也可以看出来。%SPEECH_OFF%他让王冠滑落到他的指关节上，无力地垂在那里。%SPEECH_ON%在一个所谓的国王的领导下，野蛮人在 %direction% 那里地处 %region% 联合起来。. 一个野人，如此强壮也很肮脏，他威胁要组织一大群人，在那之后，好吧，我想他会想扩大他的领域南部。 我要你去这个地区，找到这个人，把他砍倒。%SPEECH_OFF% | %employer%的一个仆人把你带到一个花园，在那里你发现那个男人正在照料一株西红柿。. 他正在用山羊剪刀修剪它，并点头示意他自己动手。 他说话很松散。%SPEECH_ON%我的侦察兵告诉我在 %region% 的一个北方野人正在集结一支军队。. 一个白痴对那些原始人来说并不是太不寻常，但我相信这个人正在宣称自己是国王。 国王们，好吧，他们希望成为宗主国，而不仅仅是他们现在所得到的。 他们想要别人的东西。包括我的。%SPEECH_OFF%那人停下来向你点头。%SPEECH_ON%我要你去 %region% 地区，找到这个所谓的野蛮国王，杀了他。. 这不容易，但你会得到很好的报酬。%SPEECH_OFF% | %employer% 与他的副官在一起。 他们对你嗤之以鼻，但 %employer% 无视他们的判断，他做出自己的判断。%SPEECH_ON%唉，佣兵，我真的相信你这种人正是我要找的人。 %region% 的一个野蛮人封自己为国王。 他甚至戴着某种皇冠，可能是用骨头和鹿角做的，但重要的是它的形状和用途。 不仅对他很重要，对我们也很重要。 我们不能让他活下去。 我要你去找原始人，在他集结的军队大到我的副官们对付不了的时候干掉他。%SPEECH_OFF% | %employer% 用一杯啤酒欢迎你。 他自己也在享受一杯酒。%SPEECH_ON%我把你带到这里是因为在 %region% 区域有一个原始人需要杀死。. 他自称国王，呵呵，是野蛮人的宗主。 好吧，虽然我一点也不尊重他的皇室权威，但当我看到一个威胁时，我知道它正处于萌芽状态。 我不希望等到这个野蛮人把村子集合起来，召集一支军队。 我要你找到他然后杀了他。 这不容易，但你会得到很好的报酬。%SPEECH_OFF%你现在想知道他是不是故意让你放松，让你接受这个荒谬的任务。 | %employer% 拿着一对鹿角，鹿冠还在那里。 当他把它放在办公桌上时，它笔直地立着，好像还依附在那里。%SPEECH_ON%有消息说，%region% 的野蛮人正在集结军队。 他宣称自己是国王，如果他能在他的旗帜下带领那些原始人，那么毫无疑问，他将成为一个强大的混蛋。 这也意味着如果他不被照顾的话，我们的下场可能就会非常糟糕。%SPEECH_OFF%那人锤向鹿角，它中空的部分发出咔嗒声。%SPEECH_ON%所以这就是你来这里的目的，佣兵。 我需要你找到这个野蛮人，在他对自己的身份和宗主地位有任何明智的想法之前，把他干掉。%SPEECH_OFF% | %employer% 坐在椅子上撅着嘴。 他在用匕首指来指去，匕首的尖端预示着有人潜入他的办公桌。%SPEECH_ON%我的侦察兵去了 %direction% 不久前就开始消失了。 然后幸存者们陆续进来，讲述了一个野蛮人宣称自己是 %region% 的国王的故事。现在，我需要想象一下，一个野人要成为一大群原始人的统治者有什么问题吗？%SPEECH_OFF%你告诉他你可以想象它会让他夜不能寐。%employer% 咧嘴笑道。%SPEECH_ON%是的，确实如此。 所以我需要一个像你这样的人，一个魁梧，善良，文明的佣兵。 我要你去找这个所谓的国王，在他让那些该死的白痴在他的旗帜下行进之前杀了他。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{我们谈的是多大的生意？ | 这可不是件小事。 | 只要价格合适。 | 这恐怕要多花点。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{我们不打算对付一整支军队。 | 那不是我们要找的工作。 | 我不会冒险让战团对付这样的敌人。}",
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
					Text = "我们应该快点。",
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
				party.setDescription("一大群行尸，向活着的人索取曾经属于他们的东西。");
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
			Text = "[img]gfx/ui/events/event_136.png[/img]{古代的死者最终被打败。你的人和野蛮人打扫战场的时候，野蛮人国王和长老来到你身边。这位大块头勇士点头咕哝，长老翻译。%SPEECH_ON%他说你做得很好，非常好，他希望像你和你的战团这样的人能和他并肩作战，但他明白这是不可能的。我们生活在一个由许多世界组成的迷宫里，在这个迷宫里，我们都会驻足，迷失，有时会听到彼此的喊叫，却永远没有足够的时间互相了解。他说谢谢。他祝你好运。%SPEECH_OFF%你问长老，一声咕哝就能表达这么多意思吗。长老笑了。%SPEECH_ON%一声咕哝，没错，还有一生的友谊。 祝你好运，剑客。%SPEECH_OFF%长老递给你一顶角盔，正是野蛮人国王戴着的那顶。他什么也没说，只是拍了拍胸口，把手指指着天空。}",
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
			Text = "[img]gfx/ui/events/event_31.png[/img]{%employer% 把野蛮人国王的头从袋子里倒出来。 它自由地翻滚，撞翻了一盘酒杯，酒杯四处散落，噼啪作响。 即使是死了，野蛮人也是混乱的传播者。%SPEECH_ON%谢谢你，佣兵。%SPEECH_OFF%你的雇主说着，他一边点头一边把头伸直，并把它歪到脖子的翻边上。%SPEECH_ON%他是个丑八怪，不是吗？ 看看那些牙齿。看看他们！ 那些牙齿上有洞。真恶心。%SPEECH_OFF%你告诉那个人付钱给你，他照着约定的做了。 但他不停地摇头，露出自己的牙齿，模仿要啄食它们。%SPEECH_ON%你怎么能那样刷牙？用绳子吗？%SPEECH_OFF%耸耸，你把头伸到门外，不想告诉 %employer% 你的人对那该死的头做的第一件事就是把金子从嘴里掏出来。 | 你把野蛮人国王的头丢到了 %employer%的桌子上。 他盯着它，然后盯着你。%SPEECH_ON%那是我见过的最大的脑袋。%SPEECH_OFF%点头，你要求你的报酬，并以适当的金额交付。 你的雇主开始推着野人的脸转来转去，好像他是一个想偷他的秘密的巫师。%SPEECH_ON%我敢打赌这就是食人魔的故事的来源，是吗？ 就像一个孩子看到这个丑陋的东西就在那里，他的想象力被点燃，于是怪物诞生了。%SPEECH_OFF%要是事情这么简单就好了。 | 即使没有它庞大的身体，野蛮人国王的头颅在给 %employer% 展示时也会引起轰动。一大群贵族和仆人哎哟着。 一个穿黑袍的人很快就会把欠你的钱给你。%employer% 亲自抬起头，将其抛向空中，以便称重。%SPEECH_ON%旧神啊，它真的很重！哦 %randomname%。%SPEECH_OFF%仆人向前走。你的雇主笑了。%SPEECH_ON%给我拿条梭子鱼。我们要把这个恐怖的脑袋举到天上去。%SPEECH_OFF%适合野蛮人的地方。 | 就在给 %employer% 野蛮人国王的头后不久，它就被用作玩物。 贵族的孩子们在石头地板上来回滚动，野蛮人的头撞倒了高脚杯的墙壁和盛着餐盘的堡垒。 狗在来回追踪头部时吠叫。%employer% 拍拍你的肩膀。%SPEECH_ON%出色的工作，佣兵。确实。 我的侦察兵告诉我，这是一场地狱般的战斗，你自己也几乎像个原始人。 但我想这就是它必须要做的，对吧？ 一个野蛮人和一个野蛮人战斗？ 这种至高无上的精神不能用我们文明的方式来遏制！%SPEECH_OFF%其中一个孩子踢国王的脸，打断了他的下巴，把孩子的脚砍在了牙齿上。 孩子尖叫着求救，也许是为了保护主人，狗趴在头上，开始用脖子把它甩来甩去。%employer% 再次笑了。%SPEECH_ON%你的报酬在外面等着你。 全部都在，如同约定的。%SPEECH_OFF% | 一个身穿骑士盔甲的人从你身上夺走了野蛮人国王的头。 你立即就要拔剑，但是 %employer% 跳进来制止了将要开始的暴力。%SPEECH_ON%唔，佣兵，这很好。 你的报酬，如同约定的。%SPEECH_OFF%那人递给你一袋克朗，你却看见在他身后，有人把头给了一个身穿黑斗篷的人。 你点头问他们打算怎么处理。%employer% 咧嘴笑道。%SPEECH_ON%坦白地说，大杯啤酒在等我，佣兵，我很渴。%SPEECH_OFF%那人很快从你身边走过。 你看不到任何啤酒，也看不到任何饮料，他只是穿着斗篷跟着那个人。 | %employer% 盯着野蛮人国王的头，就像猫会卑鄙地盯着任何不是自己的东西。%SPEECH_ON%很有趣。我想我会把它塞进衣服里。%SPEECH_OFF%说话有点不合时宜，你会提醒你的雇主，他指的是一个男人的头。%employer% 耸肩。%SPEECH_ON%所以？这是一个怪兽。 文明与野蛮之间是不可能共存的。 好好照顾它，我会考虑下现实。 你会怎么做？再给我个建议？%SPEECH_OFF%撅着嘴，你索要你的报酬。 那人指着拐角。%SPEECH_ON%在那里的袋子里。 你做的很好，佣兵，但不要再这样对我说话了。很好的一天。%SPEECH_OFF%}",
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
			distance = this.Const.Strings.Distance[this.Math.min(this.Const.Strings.Distance.len() - 1, distance / 30.000000 * (this.Const.Strings.Distance.len() - 1))];
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
				this.World.setSpeedMult(1.000000);
			}

			this.World.State.m.LastWorldSpeedMult = 1.000000;
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
