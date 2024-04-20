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
					"追捕野蛮人国王和他的战团",
					"据最新报告，他最后一次出没在%region%地区，在你的%direction%边"
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
				party.setDescription("一个强大的野蛮部落的战斗部，由自称为野蛮人国王的人联合起来。");
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
					"追捕野蛮人国王和他的战团",
					"他的战团最后在%region%附近被发现，在你%direction%边的%terrain%，靠近%nearest_town%"
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
					"和野蛮人国王一起旅行，共同面对更大的威胁"
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
					Text = "{我们来谈谈多少克朗？ | 这可不是一件小事。 | 我需要更合适的价格。 | 像这样的工作需要更高的报酬。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{我们不打算受聘于军队。 | 那不是我们要找的工作。 | 我不会让战团冒险对付这样的敌人。}",
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
			Text = "{[img]gfx/ui/events/event_59.png[/img]一群难民经过战团。 有传言说野蛮人国王在 %distance% %direction%。路上的许多人都来自 %nearest_town%，他们似乎对等待野蛮人的到来毫无兴趣。 | [img]gfx/ui/events/event_41.png[/img]一个商人驾驶者一辆空的商队货车与战团交叉而过。 尽管他没什么可兜售的，但他确实说道路上传递着野人自称国王的谣言。 他说野蛮人就在你所处位置的 %direction%，%region% 周围。他点头示意你走这条路。%SPEECH_ON%如果你想走那条路，那就把他们应得的一切都给他们。%SPEECH_OFF% | [img]gfx/ui/events/event_94.png[/img]发现一个半裸的男人盘腿坐在路边。 他说，一个有军队的原始人烧了他的农场，侮辱了妇女，把所有带把儿的人都杀了。%SPEECH_ON%我躲在灌木丛里，双手捂着嘴活了下来。%SPEECH_OFF%那人擦了擦他的鼻子。%SPEECH_ON%我看见你拿着武器。 如果你找这个野蛮人，我可以告诉你，他们好像是在这里的 %direction%，在 %terrain% %distance% 那里就是 %region%。%SPEECH_OFF% | [img]gfx/ui/events/event_94.png[/img]你发现了一个小村庄被烧毁的遗迹。 它的一些幸存者留下来，他们的形状就像从被毁的房子里飘出的烟一样。 一种说法是，一个装作国王姿态的人来了，在前往 %direction% 之前杀死了所有他们抓到的人。 | [img]gfx/ui/events/event_60.png[/img]你遇到过很多翻了的货车或燃烧的载重货车。 他们都被抢劫一空，所有的货物都不见了，只有货主的尸体还在。 有几个孩子在这样的废墟上捡东西。 当你问他们是谁干的时，一个厚脸皮的男孩大声说。%SPEECH_ON%从北方来的野蛮人，但他们现在正在 %direction%。 我看见他们了。我敢打赌，那里是 %terrain%，%distance%。 %SPEECH_OFF%他抠了抠他的鼻子。%SPEECH_ON%顺便说一句，他们是杀手。 有点像你的那种，但更大。可能更强。%SPEECH_OFF% | [img]gfx/ui/events/event_76.png[/img]%employer% 的侦查员在路上遇见你。 他报告说野蛮人国王被发现在 %region% %direction% 方向的 %terrain%。他是 %distance%。你问侦查员愿不愿意和你一起战斗，那人笑了。%SPEECH_ON%不，先生，我这样很好。 我来回跑，侦查，然后报告。 就像是我在两个妓女之间那样的奔波。 这是一个美好的生活，我不需要为了你的佣兵工作毁了它！%SPEECH_OFF%足够好了。 | [img]gfx/ui/events/event_132.png[/img]%randombrother% 首先发现它们。 有小规模冲突的迹象，烧焦的尸体，褪色的脚印和载重货车的痕迹，很明显有一支军队经过这里。%SPEECH_ON%看来他们在战斗结束后已经向 %direction% 前进了，队长。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们在追踪他。",
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{现在毫无疑问。 你所遇到的种种迹象，以及人们给你的所有消息，你终于确切地知道了野蛮人国王和他的作战人员的去向。 唯一剩下的就是和他对质。}",
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
			Text = "[img]gfx/ui/events/event_135.png[/img]{野蛮人国王带着他的作战人员来到战场，一群体型硕大的恶棍、咆哮的战士、窘迫的奴隶和嚎叫的女人。 这是一支由一个人组织起来的军队，他从这片土地上收集了每一点资源，每一寸优势，并且还汇集了文明社会的东西，就像一个简单的雪球可能变成雪崩一样。 你让士兵们准备战斗。 | 野蛮人国王的战团在陆地上穿梭，丝毫没有训练的痕迹，甚至连队形都没有。 但你知道，只要野人挥挥手，他就可以向他的敌人发动杀人犯式的群攻，他们有足够的屠杀来克服任何缺乏凝聚力的情况。 你让士兵们准备战斗。 | 野蛮人的军队就像是狂热的精神恍惚的那样，在地平线上成形，就像来自大陆角落的旅行者，不穿任何制服或盔甲，而嘲笑他们征服的那些人。 战士们的胳膊上裹着婚纱，没有地位的人身上装饰着皇家色彩的长外套，有些人穿着肋骨，骨头咔嚓咔嚓作响，好像是再一次的抢劫。 他们不过是恐怖的农夫，村庄是他们的庄稼，战争是他们收获的季节。\n\n你一看见就摇了摇头，让士兵们准备战斗。}",
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
			Text = "[img]gfx/ui/events/event_145.png[/img]{野蛮人国王死了。 虽然他把自己装扮成皇室那样，但他和他的任何一个子民一样躺在死者中间。 野蛮的。原始的。 他的身体适应力很强，装备着一些交战、掠夺和破坏的装备。 他没有什么特别之处。 你用剑砍向他的脖子，用靴子把他的头踢了下来。%randombrother% 将沉重的头部放入小背包。 你命令这些人尽他们所能地清理干净，然后准备回去找 %employer%。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{%companyname% 获胜了！ | 胜利！}",
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
			Text = "[img]gfx/ui/events/event_136.png[/img]{你发现了野蛮人国王，但却是赌出来的。 野蛮人国王和一位长者跨过田野亲自迎接你。 你出去看他们，进行交涉。 野蛮人国王说话，长老翻译。%SPEECH_ON%我们来这里不是为了征服，而是为了打败数量巨大的亡者。%SPEECH_OFF%你怀疑翻译有误，请他们解释。 国王和长老继续道。%SPEECH_ON%死亡离开了这片土地，如果没有死亡，一个被杀的人将迷失在世界之间，并将再次崛起。 一大群亡者，这些亡灵正在行军。 我们不是为你或你的贵族而来。 你若帮助我们除灭他们，我们就离开此地，不再搅扰你的百姓。只是这些亡者。%SPEECH_OFF%%randombrother% 倾身低语。%SPEECH_ON%我们当然可以加入他们，但我们也可以现在就攻击他们。 他们显然没有全力以赴，不管他们在这里说什么，事实是他们一直在蹂躏土地，因为他们是原始的野蛮人，先生，强暴和掠夺正是他们的血液。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们会攻击他们并消灭这个所谓的北方国王。",
					function getResult()
					{
						return "AGreaterThreat2";
					}

				},
				{
					Text = "我们会和他们一起向亡者进军。",
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
			Text = "[img]gfx/ui/events/event_136.png[/img]{你朝长老点头吐口水。%SPEECH_ON%我们走过被烧的房子，强奸的女人，和被杀的男人，只是为了找到你的遗憾，现在你想联合起来吗？ 我们不是盟友。我们不是朋友。 告诉你所谓的“国王”向你的诸神祈祷…%SPEECH_OFF%长老举起手来，用他们的方言与王说话。 两个人点头，转身离开。%randombrother% 笑了笑。%SPEECH_ON%简洁是轻蔑的灵魂，队长。%SPEECH_OFF%你告诉那个人回到战场上，为预先的战斗做准备。}",
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
			Text = "[img]gfx/ui/events/event_136.png[/img]{你向长老点头。%SPEECH_ON%好吧，我们会和你一起努力对付这个更大的威胁。%SPEECH_OFF%长老微笑着，搓着大拇指，用母语说了几句话。 野蛮人国王用拳头猛击他的胸部，然后用拳头猛击你的肩膀，然后用手划过天空。 长老笑着解释道。%SPEECH_ON%所以我们一起战斗，但如果我们倒下，他就不会像亡灵一样与你战斗。 如果被杀，国王会发现自己已经死了，把镰刀放在自己的脖子上。%SPEECH_OFF%}",
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
				local party = this.World.FactionManager.getFaction(nearest_undead.getFaction()).spawnEntity(tile, "亡者", false, this.Const.World.Spawn.UndeadArmy, 260 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
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
			Text = "[img]gfx/ui/events/event_73.png[/img]{野蛮人没有说谎：长老已经派出了一支军队。 它是一支由腐烂的面孔和生锈的盔甲组成的军队，是一大群叹息着、呻吟的怪物，光落在它们身上，立刻就消失了。 这无疑是一支黑暗的军队。 如果你或是野蛮人单独战斗，你肯定会输，但在一起你可能还有机会！}",
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
			Text = "[img]gfx/ui/events/event_136.png[/img]{古代的死者最终被杀。 当你的人和原始人在田野里挑选时，野蛮人国王和长老来到你身边。 这位大块头勇士点头咕哝，长老翻译。%SPEECH_ON%他说你做得很好，非常好，他希望像你自己和你的战团这样的人能和他并肩作战，但他明白这是不可能的。 我们生活在一个由许多世界组成的迷宫里，在这个迷宫里，我们都会留下来，迷失，有时会听到彼此的喊叫，永远没有足够的时间互相了解。 他说谢谢。他祝你好运。%SPEECH_OFF%你问向长老，问他是不是从一个简单的咕噜声中得到了这些。长老笑了。%SPEECH_ON%咕噜声，是的，还有一生的友谊。 祝你好运，持剑的人。%SPEECH_OFF%长老递给你一顶角盔，就是你见过野蛮人国王自己有时戴的那顶。 他什么也没说，只拍了拍胸口，指着天空，就这样。}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "杀了一个自称的野蛮人国王");
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
					text = "你获得了 [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] 克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_31.png[/img]{%employer% 不情愿地欢迎你。%SPEECH_ON%你知道我到处都有侦察员和密探，不是吗？%SPEECH_OFF%好的。 “野蛮人国王”不会再打扰土地了。 你的雇主用手指敲了几下然后点头。%SPEECH_ON%你的诚实令人耳目一新，尽管我不得不说那人和他的战团还活着是很不幸的。 也就是说，所有的汇报都表明他们要离开了，所以我想你的工作还是一样的，不管你是不是一个肥胖的无信仰之人。这是你约定的报酬。%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "解决了一个自称是野蛮人国王的威胁");
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
					text = "你获得了 [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] 克朗"
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
