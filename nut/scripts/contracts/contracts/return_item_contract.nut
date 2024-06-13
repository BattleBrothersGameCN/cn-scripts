this.return_item_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		IsPlayerAttacking = true
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.return_item";
		this.m.Name = "带回物品";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 400 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		local items = [
			"稀有钱币收藏",
			"仪式手杖",
			"丰产神像",
			"黄金护身符",
			"秘法知识之书",
			"保险箱",
			"恶魔雕像",
			"水晶颅骨"
		];
		local r = this.Math.rand(0, items.len() - 1);
		this.m.Flags.set("Item", items[r]);
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"沿着%townname%附近的踪迹前进",
					"将%item%带回%townname%。"
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

				if (r <= 15)
				{
					if (this.Contract.getDifficultyMult() >= 0.95)
					{
						this.Flags.set("IsNecromancer", true);
					}
				}
				else if (r <= 30)
				{
					this.Flags.set("IsCounterOffer", true);
					this.Flags.set("Bribe", this.Contract.beautifyNumber(this.Contract.m.Payment.getOnCompletion() * this.Math.rand(100, 300) * 0.01));
				}
				else
				{
					this.Flags.set("IsBandits", true);
				}

				this.Flags.set("StartDay", this.World.getTime().Days);
				local playerTile = this.World.State.getPlayer().getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 10, [
					this.Const.World.TerrainType.Mountains
				]);
				local party;
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).spawnEntity(tile, "盗贼", false, this.Const.World.Spawn.BanditRaiders, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.setDescription("一群盗贼和土匪。");
				party.setFootprintType(this.Const.World.FootprintsType.Brigands);
				party.setAttackableByAI(false);
				party.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				party.setFootprintSizeOverride(0.75);
				this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.GenericFootprints, this.Const.World.FootprintsType.Brigands, 0.75);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_bandits_0" + this.Math.rand(1, 6));
				local c = party.getController();
				local wait = this.new("scripts/ai/world/orders/wait_order");
				wait.setTime(9000.0);
				c.addOrder(wait);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"沿着%townname%%direction%边的踪迹前进",
					"将%item%带回%townname%。"
				];

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onTargetAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull())
				{
					if (this.Flags.get("IsCounterOffer"))
					{
						this.Contract.setScreen("CounterOffer1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("BattleDone");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Return");
					}
				}
				else if (this.World.getTime().Days - this.Flags.get("StartDay") >= 3 && this.Contract.m.Target.isHiddenToPlayer())
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (!this.Flags.get("IsAttackDialogTriggered"))
				{
					if (this.Flags.get("IsNecromancer"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
						this.Contract.setScreen("Necromancer");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
						this.Contract.setScreen("Bandits");
						this.World.Contracts.showActiveContract();
					}
				}
				else
				{
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"将%item%带回%townname%。"
				];
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer%不安地走来走去，一边解释他的烦恼。%SPEECH_ON%我这里发生了一桩明目张胆的盗窃案！卑鄙的强盗偷走了我的%itemLower%，这对我来说价值不可估量。我恳求你追捕那些盗贼，把那件东西还给我%SPEECH_OFF%他将声音降低到一个更为坚决的语气。%SPEECH_ON%你不仅会获得丰厚的薪酬，还会让%townname%善良人们的担心烟消云散！%SPEECH_OFF% | %employer%正在读许多卷轴中的一卷。他愤怒地把它丢到另一堆卷轴里。%SPEECH_ON%%townname%的居民为此事感到愤怒，他们很有理由这么做。你知道吗？一名强盗，可能是与其他流浪汉勾结的，设法从我们身边偷走了我的%itemLower%？那东西对于我来说价值无穷，而且……对于人民来说也一样，当然了。%SPEECH_OFF%你耸耸肩。%SPEECH_ON%所以你想要我替你去把它弄回来？%SPEECH_OFF%他指出手指。%SPEECH_ON%没错，聪明的佣兵！这就是我想要你做的。跟随那些贼的足迹并夺回属于我……镇子的那东西！%SPEECH_OFF% | %employer%正在转动手里的苹果。他似乎对它很失望，好像他希望它是别的东西，比如一件有价值的小饰品，或者只是一种更美味的水果。%SPEECH_ON%你曾经失去过你所爱的东西吗？%SPEECH_OFF%你耸耸肩回答。%SPEECH_ON%曾经有个女孩……%SPEECH_OFF%男人摇了摇头。%SPEECH_ON%不，不是什么女人。更重要的。因为我有！盗贼偷走了我的%itemLower%。他们如何越过我的警卫，好吧我是很难理解。但是我知道只要我让你出手，我就可以把我应得的东西拿回来。是这样的吗？还是我对你的服务质量有误解？%SPEECH_OFF% | 一条狗在%employer%的脚边打着鼾。他倾身轻轻抚摸猎犬的耳后。%SPEECH_ON%我听说你很擅长找人，佣兵。还有……解决问题。%SPEECH_OFF%你点点头。毕竟，这是实话。%SPEECH_ON%好……很好……我有个任务给你。一个简单的任务。有件对我而言很有价值的东西被偷了，我的%itemLower%。我需要你找到偷走它的人，杀了他们，当然，然后把东西带回来。%SPEECH_OFF% | 一只鸟立在%employer%的窗户上。那人坐着，指着它。%SPEECH_ON%我想知道他们是不是这样进来的。我是说强盗。我想他们一定是从窗户溜进来的，然后又从那出去。他们就是这样把我的%itemLower%偷走的。%SPEECH_OFF%那人慢慢站起来，大步穿过房间。他蹲下身子，准备扑向那只鸟，但是在他还没有做出反应的时候，那只生物已经四散逃开了。%SPEECH_ON%该死。%SPEECH_OFF%他回到座位上，擦了擦手，好像他在试图伏击鸟类时出了一身汗。%SPEECH_ON%我的任务很简单，佣兵。把我的财产弄回来。还有，杀了强盗，如果你不介意。%SPEECH_OFF% | 灰尘覆盖了%employer%的桌子，但是上面有个突兀的干净之处。他向那示意。%SPEECH_ON%那是我的%itemLower%曾经摆着的地方。如果你看不出来，说明它已经不见了。%SPEECH_OFF%你点头。它看起来确实不见了。%SPEECH_ON%带走它的盗贼应该很好追踪。他们在晚上盘算得不错，那些强盗，但是他们在白天犯了很多错。脚印，乱花的克朗……你应该能够轻松地追踪到它们。%SPEECH_OFF%他用严厉的眼神看着你。%SPEECH_ON%你明白吗，雇佣兵？我想要你去夺回我的财产。我要把它摆在该摆的地方。而且……我要那些盗贼死在泥里。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{对你来说值多少？ | 谈谈报酬吧。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{这听起来不像是适合我们的工作。 | 我不这么认为。}",
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
			ID = "Bandits",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_80.png[/img]{是强盗们！跟你的雇主猜的一样。他们看起来很害怕，或许是知道%employer%雇人花的钱将化成怒火降临在他们身上。 | 啊，这些小偷再普通不过 —— 只不过是一群流浪汉和强盗。当你命令你的手下攻击时，他们也拿起了武器。 | 一伙强盗拖着你雇主的财物游荡是被你撞了个正着。他们似乎对你能找到这里有些意外，不打算浪费口舌，他们拿起了武器，而你命令%companyname%发起冲锋。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Necromancer",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_76.png[/img]{这里有强盗，正如预期的那样，但是他们正在把 %itemLower% 交给一个穿着深色破烂衣服的人。 你的存在，毫不意外的，中止了交易并且强盗和阴森的人都拿起了武器。 | 你看到强盗把 %employer%的财产交易给一个看起来像是亡灵巫师的人！ 或许他想要它来对雇主家族施什么邪恶巫术。 某种程度上来说，这不是那么坏…但是，他花钱雇你是来干活的。冲锋！ | %employer%的财产被强盗卖给了一个惨败的黑衣人！ 他在那些人面前瞪着你，他呆滞的黑眼瞬间聚焦在了你的战团上。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						this.Const.World.Common.addTroop(this.Contract.m.Target, {
							Type = this.Const.World.Spawn.Troops.Necromancer
						});
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CounterOffer1",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_76.png[/img]{你把剑上的血擦干净，然后去拿那东西。当你弯腰捡起它时，你发现一个男人在远处看着你。他走了出来，两只手搭在一起，袖子很长。%SPEECH_ON%看来你杀了我赞助人的手下。%SPEECH_OFF%收起剑，你向那人点点头。他继续道。%SPEECH_ON%我的赞助人花了大价钱来获得那个宝物。看起来他的报酬没法被接受了，所以也许我可以直接和你谈谈。我出价%bribe%克朗买下它。%SPEECH_OFF%那……是不少钱。然而，如果你决定接受……%employer%不会高兴。 | 战斗后，一个人从林线出现，拍手。%SPEECH_ON%我给了这些人不少钱，但是看起来我应该付给你。 现在这些强盗都死了，我可以这么做！%SPEECH_OFF%在你用剑刺穿他之前，你告诉他快点说到点上。 他向宝物示意。%SPEECH_ON%我会付你 %bribe% 克朗买下它。 这些钱本来是要给盗贼的，还有再加上一点。怎么样？%SPEECH_OFF%%employer% 不会默默接受你的背叛，但是钱不少… | 战斗结束了，你捡起 %itemLower% 检查它。 这真的值得这么多人命吗？%SPEECH_ON%我知道你在想什么，佣兵。%SPEECH_OFF%声音传来。 你拔剑指向不知从哪里冒出来的陌生人。%SPEECH_ON%你在想，会不会有什么人付你一大笔钱去偷那个宝物？ 如果那个人给我非常大一笔钱会怎么样？ 或许...比雇你来取回它的人更多的钱。%SPEECH_OFF%你放下武器并点头。%SPEECH_ON%有趣的想法。%SPEECH_OFF%他微笑着。%SPEECH_ON%%bribe% 克朗。这是我愿意付你的钱。 那是盗贼的部分还有额外加的。 不错的交易。 当然，你的雇主会非常不开心，但是…好吧，这里不是我在做决定。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我一看就知道是好买卖。把克朗拿来。",
					function getResult()
					{
						this.updateAchievement("NeverTrustAMercenary", 1, 1);
						return "CounterOffer2";
					}

				},
				{
					Text = "我们被雇来夺回它，而那就是我们要做的事。",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CounterOffer2",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_76.png[/img]你将%itemLower%交出，陌生人递给你一个沉甸甸的背包。交易完成了。可以肯定的是，%employer%，也就是你的雇主，不会对此感到高兴。",
			Image = "",
			List = [],
			Options = [
				{
					Text = "好酬劳。",
					function getResult()
					{
						this.World.Assets.addMoney(this.Flags.get("Bribe"));
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "没能取回被盗的" + this.Flags.get("Item"));
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
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("Bribe") + "[/color]克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "BattleDone",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_22.png[/img]{战斗结束，你从敌人手中夺回了%itemLower%并准备回去找%employer%。他看到你的成功一定会很高兴！ | 那些偷走%itemLower%的人都死了，谢天谢地你能找到物品本身。%employer%对你的工作成果肯定会很开心。 | 好，你找到了那些为偷窃%itemLower%负责的小偷并解决了他们。现在你只需要把%itemLower%交回%employer%的手上并收取报酬！ | 战斗结束了而且%itemLower%很轻易就在你敌人的尸体间找到了。你应该把它还给%employer%以获取你应得的报酬！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们去收报酬吧。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer%从你手里接过%itemLower%，紧紧地抱在怀里，仿佛他找回了一个走失的孩子。光是看着他的宝物他的眼睛就泛出泪来。%SPEECH_ON%谢谢你，佣兵。这对我意义重大……我是说，额，对城镇。我们感谢你！%SPEECH_OFF%他在你盯着他看时停顿了一下。他的目光转向房间的一个角落。%SPEECH_ON%我们的……谢意，佣兵…%SPEECH_OFF%卫兵打开一个大木箱。你数了数克朗然后离开了。 | 当你回去找%employer%时他正在耍笼子里的一只鸟。%SPEECH_ON%啊，佣兵回来了……然后？%SPEECH_OFF%你举起宝物然后把它放在他的办公桌上。他拿起它，旋转，点头，然后收了起来。%SPEECH_ON%好极了。对于你的辛勤劳动……%SPEECH_OFF%他向一个装满克朗的箱子挥了挥手。 | %employer%把他的腿放在两只狗身上，它们相互叠在一起，都已经昏昏欲睡。%SPEECH_ON%这些野兽可以撕裂我的喉咙，但是……看看他们。这是怎么发生的？我甚至没有训练他们。别人做的。我对他们而言是陌生人，但是他们就这么让我压着。%SPEECH_OFF%你把宝物放在他的桌子上滑过去。他向前倾身，拿起它，然后把它放在桌子下面。他的手收上来时拿着一个小背包。他把包扔了过来。%SPEECH_ON%正如我们谈好的。干得好，佣兵。%SPEECH_OFF% | 当你进入%employer%的房间时，有一大群守卫在围着他。有那么一瞬，你怀疑自己碰巧撞上了场兵变，但是他们散开了，留下骰子和纸牌。%employer%挥手欢迎你进去。%SPEECH_ON%来，来。我刚刚损失了不少克朗，佣兵。或许你带了些能减轻我痛苦的东西……？%SPEECH_OFF%你掏出%itemLower%握在手中。那人小心翼翼地接过。%SPEECH_ON%好……非常好……你的报酬，当然，在这里。%SPEECH_OFF%他在椅子上转过身来，递上一背包的克朗。他似乎被宝物迷住了，不再说话。 | %employer%笑着看你进入房间。%SPEECH_ON%卖剑的，卖剑的，你能把你胜利的消息卖给我吗？%SPEECH_OFF%你拿出宝物并放在它的桌上。%SPEECH_ON%行。%SPEECH_OFF%那人突然坐直了身子，拿走了东西。他转身对着你，使自己平静下来，恢复镇静。%SPEECH_ON%好。你干的很好。非常好。%reward_completion%克朗，正如承诺的那样。%SPEECH_OFF%他递过来一袋钱币。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "受之无愧。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "取回了被盗的" + this.Flags.get("Item"));
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
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_75.png[/img]{你伏身地面，手摸了摸，让一些灰尘从你的手指中过滤。 但是只有土－没有路过它的脚印。 实际上，你已经有一段时间没看到脚印了。%randombrother% 靠近你，蹲下来耸肩。%SPEECH_ON%先生，我想我们跟丢了。%SPEECH_OFF%你点头。%employer% 不会很高兴，但事实就是这样。 | 你跟着偷 %itemLower% 的人足迹好一段时间，但是线索断了。 你经过的路人不知道任何事情，而且地面上没有可以追踪的足迹。 不管怎么说，%itemLower% 丢了。%employer% 对此不会满意的。 | 一个足迹放时间长了就会被另一个覆盖。 然后另一个。还有另一个。 你花了很长时间追踪偷了 %itemLower% 的盗贼而世界的线路，一如既往的繁忙，覆盖了他们的足迹。 你现在没机会找到他们了而且 %employer% 会非常生气。 | %itemLower%的盗贼们的足迹消失了。 最后一组足迹把你带到了一个农庄，而且他们看起来不像是小偷，他们也不认识上述人。%employer% 对于丢失他的物品不会很开心，但是你现在也做不了什么。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "该死的合同！",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "没能取回被盗的" + this.Flags.get("Item"));
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
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Target.getTile())]
		]);
		_vars.push([
			"item",
			this.m.Flags.get("Item")
		]);
		_vars.push([
			"itemLower",
			this.m.Flags.get("Item").tolower()
		]);
		_vars.push([
			"bribe",
			this.m.Flags.get("Bribe")
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Target != null && !this.m.Target.isNull())
		{
			_out.writeU32(this.m.Target.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});
