this.defend_settlement_bandits_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Reward = 0,
		Kidnapper = null,
		Militia = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.defend_settlement_bandits";
		this.m.Name = "保卫定居点";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 5.0;
		this.m.MakeAllSpawnsResetOrdersOnContractEnd = false;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 700 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"保卫%townname%及其郊区免受掠夺"
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
				local nearestBandits = this.Contract.getNearestLocationTo(this.Contract.m.Home, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getSettlements());
				local nearestZombies = this.Contract.getNearestLocationTo(this.Contract.m.Home, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getSettlements());

				if (nearestZombies.getTile().getDistanceTo(this.Contract.m.Home.getTile()) <= 20 && nearestBandits.getTile().getDistanceTo(this.Contract.m.Home.getTile()) > 20)
				{
					this.Flags.set("IsUndead", true);
				}
				else
				{
					local r = this.Math.rand(1, 100);

					if (r <= 20)
					{
						this.Flags.set("IsKidnapping", true);
					}
					else if (r <= 40)
					{
						if (this.Contract.getDifficultyMult() >= 0.95)
						{
							this.Flags.set("IsMilitia", true);
						}
					}
					else if (r <= 50 || this.World.FactionManager.isUndeadScourge() && r <= 70)
					{
						if (nearestZombies.getTile().getDistanceTo(this.Contract.m.Home.getTile()) <= 20)
						{
							this.Flags.set("IsUndead", true);
						}
					}
				}

				local number = 1;

				if (this.Contract.getDifficultyMult() >= 0.95)
				{
					number = number + this.Math.rand(0, 1);
				}

				if (this.Contract.getDifficultyMult() >= 1.1)
				{
					number = number + 1;
				}

				local locations = this.Contract.m.Home.getAttachedLocations();
				local targets = [];

				foreach( l in locations )
				{
					if (l.isActive() && !l.isMilitary() && l.isUsable())
					{
						targets.push(l);
					}
				}

				number = this.Math.min(number, targets.len());
				this.Flags.set("ActiveLocations", targets.len());

				for( local i = 0; i != number; i = ++i )
				{
					local party;

					if (this.Flags.get("IsUndead"))
					{
						party = this.Contract.spawnEnemyPartyAtBase(this.Const.FactionType.Zombies, this.Math.rand(80, 110) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					}
					else
					{
						party = this.Contract.spawnEnemyPartyAtBase(this.Const.FactionType.Bandits, this.Math.rand(80, 110) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					}

					party.setAttackableByAI(false);
					local c = party.getController();
					c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
					c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
					local t = this.Math.rand(0, targets.len() - 1);

					if (i > 0)
					{
						local wait = this.new("scripts/ai/world/orders/wait_order");
						wait.setTime(4.0 * i);
						c.addOrder(wait);
					}

					local move = this.new("scripts/ai/world/orders/move_order");
					move.setDestination(targets[t].getTile());
					c.addOrder(move);
					local raid = this.new("scripts/ai/world/orders/raid_order");
					raid.setTime(40.0);
					raid.setTargetTile(targets[t].getTile());
					c.addOrder(raid);
					targets.remove(t);
				}

				this.Contract.m.Home.setLastSpawnTimeToNow();
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.World.FactionManager.getFaction(this.Contract.getFaction()).setActive(false);
			}

			function update()
			{
				if (this.Contract.m.UnitsSpawned.len() == 0 || this.Flags.get("IsEnemyHereDialogShown"))
				{
					local isEnemyGone = true;

					foreach( id in this.Contract.m.UnitsSpawned )
					{
						local p = this.World.getEntityByID(id);

						if (p != null && p.isAlive() && p.getDistanceTo(this.Contract.m.Home) <= 1200.0)
						{
							isEnemyGone = false;
							break;
						}
					}

					if (isEnemyGone)
					{
						if (this.Flags.get("HadCombat"))
						{
							this.Contract.setScreen("ItsOver");
							this.World.Contracts.showActiveContract();
						}

						this.Contract.setState("Return");
						return;
					}
				}

				if (!this.Flags.get("IsEnemyHereDialogShown"))
				{
					local isEnemyHere = false;

					foreach( id in this.Contract.m.UnitsSpawned )
					{
						local p = this.World.getEntityByID(id);

						if (p != null && p.isAlive() && p.getDistanceTo(this.Contract.m.Home) <= 700.0)
						{
							isEnemyHere = true;
							break;
						}
					}

					if (isEnemyHere)
					{
						this.Flags.set("IsEnemyHereDialogShown", true);

						foreach( id in this.Contract.m.UnitsSpawned )
						{
							local p = this.World.getEntityByID(id);

							if (p != null && p.isAlive())
							{
							}
						}

						if (this.Flags.get("IsUndead"))
						{
							this.Contract.setScreen("UndeadAttack");
						}
						else
						{
							this.Contract.setScreen("DefaultAttack");
						}

						this.World.Contracts.showActiveContract();
					}
				}
				else if (this.Flags.get("IsKidnapping") && !this.Flags.get("IsKidnappingInProgress") && this.Contract.m.UnitsSpawned.len() == 1)
				{
					local p = this.World.getEntityByID(this.Contract.m.UnitsSpawned[0]);

					if (p != null && p.isAlive() && !p.isHiddenToPlayer() && !p.getController().hasOrders())
					{
						local c = p.getController();
						c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(true);
						c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(true);
						this.Contract.m.Kidnapper = this.WeakTableRef(p);
						this.Flags.set("IsKidnappingInProgress", true);
						this.Flags.set("KidnappingTooLate", this.Time.getVirtualTimeF() + 60.0);
						this.Contract.setScreen("Kidnapping1");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Kidnapping");
					}
				}

				if (this.Flags.get("IsMilitia") && !this.Flags.get("IsMilitiaDialogShown"))
				{
					this.Flags.set("IsMilitiaDialogShown", true);
					this.Contract.setScreen("Militia1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Flags.set("HadCombat", true);
			}

			function onCombatVictory( _combatID )
			{
				this.Flags.set("HadCombat", true);
			}

		});
		this.m.States.push({
			ID = "Kidnapping",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"营救俘虏",
					"返回" + this.Contract.m.Home.getName()
				];
				this.Contract.m.Home.getSprite("selection").Visible = false;
				this.World.FactionManager.getFaction(this.Contract.getFaction()).setActive(false);

				if (this.Contract.m.Kidnapper != null && !this.Contract.m.Kidnapper.isNull())
				{
					this.Contract.m.Kidnapper.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.m.Kidnapper == null || this.Contract.m.Kidnapper.isNull() || !this.Contract.m.Kidnapper.isAlive())
				{
					if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() <= 5.0)
					{
						this.Flags.set("IsKidnapping", false);
						this.Contract.setScreen("Kidnapping2");
					}
					else
					{
						this.Contract.setScreen("Kidnapping3");
					}

					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (this.Contract.m.Kidnapper.isHiddenToPlayer() && this.Time.getVirtualTimeF() > this.Flags.get("KidnappingTooLate"))
				{
					this.Contract.setScreen("Kidnapping3");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Flags.set("HadCombat", true);
			}

			function onCombatVictory( _combatID )
			{
				this.Flags.set("HadCombat", true);
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
				this.World.FactionManager.getFaction(this.Contract.getFaction()).setActive(true);

				if (this.Contract.m.Kidnapper != null && !this.Contract.m.Kidnapper.isNull())
				{
					this.Contract.m.Kidnapper.getSprite("selection").Visible = false;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					local locations = this.Contract.m.Home.getAttachedLocations();
					local numLocations = 0;

					foreach( l in locations )
					{
						if (l.isActive() && !l.isMilitary() && l.isUsable())
						{
							numLocations = ++numLocations;
						}
					}

					if (numLocations == 0 || this.Flags.get("ActiveLocations") - numLocations >= 2)
					{
						if (this.Flags.get("IsKidnapping") && this.Flags.get("IsKidnappingInProgress"))
						{
							this.Contract.setScreen("Failure2");
						}
						else
						{
							this.Contract.setScreen("Failure1");
						}
					}
					else if (this.Flags.get("ActiveLocations") - numLocations >= 1)
					{
						if (this.Flags.get("IsKidnapping") && this.Flags.get("IsKidnappingInProgress"))
						{
							this.Contract.setScreen("Success4");
						}
						else
						{
							this.Contract.setScreen("Success2");
						}
					}
					else if (this.Flags.get("IsKidnapping") && this.Flags.get("IsKidnappingInProgress"))
					{
						this.Contract.setScreen("Success3");
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer%正望着窗外。他招手让你过去。%SPEECH_ON%看看那些人。%SPEECH_OFF%楼下聚集着一群人，为这事那事哀嚎着。%SPEECH_ON%土匪在这一带游荡有些时日了，民众相信他们即将大举进攻我们。%SPEECH_OFF%那人拉上窗帘，走去点燃一支蜡烛。他对着烛火说话，气息拂动着火苗。%SPEECH_ON%我们需要你保护我们，雇佣兵。如果你能阻止这些土匪，你会得到丰厚的报酬。有兴趣吗？%SPEECH_OFF% | 一些农民在房间外的大厅徘徊。你能听到他们紧张的叫喊声。%employer%倒了杯酒，用颤抖的手抿了一口。%SPEECH_ON%我就直说了，佣兵。我们收到很多很多报告，说土匪即将袭击这个镇子。如果你想知道，这些报告来自死去的妇女和儿童。显然，我们没有理由怀疑这些报告的严重性。所以，问题是，你会保护我们吗？%SPEECH_OFF% | %employer%正看着桌上的一些文件。你坐下问他想要什么。%SPEECH_ON%你好啊，佣兵。我们有个问题，我觉得你会……特别擅长处理。%SPEECH_OFF%你让他直说，他便直奔主题。%SPEECH_ON%土匪烧毁了镇外的一些房屋和棚舍。有消息说他们正在准备一场更猛烈、更大胆的进攻。我需要你在这里阻止他们。你觉得你能胜任这份工作吗？%SPEECH_OFF% | %employer%背对着你，凝视着他的书架。他语气低沉地说。%SPEECH_ON%没多少人能读懂这些书，真可惜。也许如果他们能读懂，我们的问题就会消失。或者也许只会变得更糟。%SPEECH_OFF%他摇摇头转过身来。%SPEECH_ON%我们有一伙土匪很快就要来找我们麻烦了。我需要你，佣兵，来阻止他们。我的书肯定他妈做不到。如果报酬合适——我保证会合适——你来吗？%SPEECH_OFF% | %employer%手里拿着两张纸。上面画着人脸。%SPEECH_ON%我们前几天抓住了这两个。绞死了他们，烧了尸体。%SPEECH_OFF%你耸耸肩。%SPEECH_ON%恭喜？%SPEECH_OFF%那人并不觉得好笑。%SPEECH_ON%现在我们得到消息，他们的土匪同伙要来报复我们！而且，没错，我们需要你帮忙击退他们。有兴趣吗？%SPEECH_OFF% | 你在%employer%的房间里安顿下来，坐进椅子，手沿着木框摩挲。是上好的橡木。坐在上面简直值了。%SPEECH_ON%很高兴你觉得舒服，佣兵，但我可一点都不舒服。我们收到很多很多警告，说一大群土匪即将袭击我们的镇子。我们相当缺乏防御力量，但不缺钱。显然，这就是你出场的时候了。有兴趣吗？%SPEECH_OFF% | %employer%把杯子猛摔在墙上。杯子碎裂，旋转着四散飞溅，葡萄酒的斑点溅到你脸上。%SPEECH_ON%流寇！土匪！强盗！没完没了！%SPEECH_OFF%他心不在焉地递给你一张餐巾。%SPEECH_ON%现在我得到消息，一大群这样的暴徒要来把这个镇子烧成平地！好吧，我给他们准备了点东西：就是你。你怎么说，佣兵？你会保卫我们吗？%SPEECH_OFF% | 在%employer%房间外就能听到几个悲痛妇女的哀嚎。他转向你。%SPEECH_ON%听到了吗？这就是土匪过来时会发生的事情。他们偷窃，他们强奸，他们杀人。%SPEECH_OFF%你点点头。毕竟，这就是土匪的行事方式。%SPEECH_ON%现在偏远地区的一些农民说，那些暴徒正在准备对我们村庄发动大规模袭击。你必须做点什么来帮助我们，佣兵。呵，我当然说的是‘必须’。我真正的意思是我们会付钱请你帮助我们……%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{%townname%准备拿多少钱买个安生？ | 这值得你出大价钱，对吧？}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{恐怕你得靠自己了。 | 我们有更重要的事情要做。 | 祝你好运，但我们不会掺和此事。}",
					function getResult()
					{
						if (this.Math.rand(1, 100) <= 60)
						{
							this.World.Contracts.removeContract(this.Contract);
							return 0;
						}
						else
						{
							return "Plea";
						}
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Plea",
			Title = "谈判",
			Text = "[img]gfx/ui/events/event_43.png[/img]{当你拒绝了%employer%正准备离开时，走到外面却发现一群农民围站在那里。每人手里都捧着些稀奇古怪的东西，都是平民们能尽力凑出来的那种财富：鸡、廉价的项链、破旧的衣服、生锈的铁匠工具，林林总总说也说不完。其中一人走上前来，腋下各夹着一只鸡。%SPEECH_ON%求求你！你不能走！你必须帮助我们！%SPEECH_OFF%%randombrother%笑了起来，但你不得不承认，这些可怜人确实知道如何拨动一两下心弦。也许你还是该留下来帮忙？ | 当你离开%employer%时，走到外面发现一个妇人站在那里，她的一大群孩子在她腿边乱窜，还有一个婴儿正吮吸着她的乳头。%SPEECH_ON%佣兵，求求你，你不能就这样丢下我们！这个镇子需要你！孩子们需要你！%SPEECH_OFF%她顿了顿，然后拉下衣服的另一边，露出了相当香艳诱人的诱惑。%SPEECH_ON%我需要你……%SPEECH_OFF%你抬起一只手，既是为了阻止她，也是想要擦擦突然冒汗的额头。也许帮帮这对，呃，可怜人，终究不是什么坏事？ | 正准备离开%townname%，一只小狗跑过来，一边叫一边舔你的靴子。一个更小的孩子在后面追。孩子扑到小狗身上，用胳膊搂住它乱糟糟的毛。%SPEECH_ON%哦，{马利 | 耶拉 | 乔乔}，我太爱你了！%SPEECH_OFF%土匪屠杀这孩子和他的宠物的景象在你脑海中一闪而过。你还有比对付普通毛贼、扮演警长和治安官更好的事情要做，但那狗不停地舔着男孩的脸，而孩子看起来是那么快乐。%SPEECH_ON%哈哈！我们会永远永远一起活下去的，对吧？永远永远！%SPEECH_OFF%真该死。 | 当你离开%employer%的住所时，一个男人向你走来。%SPEECH_ON%先生，我听说您拒绝了那个人的提议。真是可惜，这就是我想说的。我原以为这世上还有很多好人，但看来我想错了。祝你一路顺风，我真心希望你在旅途中会为我们祈祷。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = false,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{见鬼，我们不能不管这些人。 | 行，行，我们不会离开%townname%。至少说一下报酬吧。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{我相信你们能挺过去的。让开。 | 我不会为了救几个饿肚皮的农民，就让%companyname%去冒险。}",
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
			ID = "UndeadAttack",
			Title = "%townname%附近",
			Text = "[img]gfx/ui/events/event_29.png[/img]{在你站岗时，一个疯狂的农民向你跑来。他张着嘴，上气不接下气。双手撑在膝盖上，他几乎是把话吐了出来：%SPEECH_ON%死人……他们来了！%SPEECH_OFF%越过他望去，你确实看到一群苍白的生物在远处蹒跚而行。 | 这里没有土匪，只有亡灵！在你等待暴徒和恶棍冲进镇子时，你却看到一大群步履蹒跚的生物正朝你们走来。目标变了不代表合同也变了——做好准备！ | 镇教堂的警钟响起。你一边听着钟声，一边注视着地平线。钟声持续响着。一个当地人站在你身边。%SPEECH_ON%一响……两响……三响……四响……%SPEECH_OFF%他开始冒汗。当钟声最终敲响最后一下时，他瞪大了眼睛。%SPEECH_ON%这是……这不可能。%SPEECH_OFF%你问他到底在害怕什么。他向后退去。%SPEECH_ON%死者复活了！%SPEECH_OFF%太好了，你还以为这份合同会很简单。 | 呻吟着，哀嚎着，亡灵蹒跚着进入了视野。这里没有土匪——也许这些肮脏的生物把他们吃掉了——但合同没有作废：保护镇子！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "DefaultAttack",
			Title = "%townname%附近",
			Text = "[img]gfx/ui/events/event_07.png[/img]发现强盗了！准备战斗，保护城镇！",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ItsOver",
			Title = "%townname%附近",
			Text = "[img]gfx/ui/events/event_22.png[/img]{战斗结束了，弟兄们闲适地享受着难得的喘息。%employer%在镇里等着你回去。 | 战斗结束后，你审视着散落战场的尸体。景象惨不忍睹，但不知为何却激发出你的活力。这尸积如山的惨状只是提醒着你，你尚有余力不去向这个恐怖的世界屈服。像%employer%那样的人真该来亲眼看看，但他不会来的，所以你得去见他。 | 血肉与骸骨遍布原野，几乎难以分辨其原本所属。黑兀鹫在头顶盘旋，阴影在尸体上流动，这些鸟儿正等待哀悼者散去。%randombrother%来到你身边，询问是否该启程返回%employer%那里了。你将战场的景象抛在身后，点了点头。 | 死者的残骸呈现出一种诡异的安详。仿佛这才是他们天然的状态，僵硬且陷入永恒的沉寂，而他们整个生命不过是一场短暂的偶然，如今终于走到了尽头。%randombrother%上前来问你还好吗。说实话，你也不确定，只简单地回答该去见%employer%了。 | 扭曲的人形与歪斜的尸骸遍布大地，因为战争从不给予死者选择如何安息的权利。那些脱离躯体的头颅看上去最为安详，因为在战斗中，任何人或野兽都无暇细细砍断脖颈，那只能来自于最快最利的刀锋。你的一部分渴望能如此瞬间了结，但另一部分却希望有机会能与杀死你的敌人同归于尽。\n\n%randombrother%来到你身边请求指示。你转身离开这片战场，命令%companyname%准备返回%employer%处。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们回城镇中心去！",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ItsOverDidNothing",
			Title = "%townname%附近",
			Text = "[img]gfx/ui/events/event_30.png[/img]空气中弥漫着硝烟，以及木头燃烧和生计焚毁的刺鼻气味。%townname%的民众将全部希望寄托于雇佣%companyname%，这是一个致命的错误。",
			Image = "",
			List = [],
			Options = [
				{
					Text = "出岔子了……",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Militia1",
			Title = "%townname%里",
			Text = "[img]gfx/ui/events/event_80.png[/img]{在准备保卫%townname%时，当地民兵已来到你身边。他们听从你的指挥，只请求你将他们派往你认为最需要的地方。 | 看来当地民兵已加入战斗！这是一支杂牌军，但依然能派上用场。现在的问题是，该把他们派往何处？ | %townname%的民兵已加入战斗！虽然是一支装备简陋的杂牌队伍，但他们斗志昂扬，誓要保卫家园。他们听从你的指挥，相信你会将他们派往最需要的地方。 | 你并非孤军奋战！%townname%的民兵已与你汇合。他们求战心切，询问你哪里最需要他们。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "入列，我会直接指挥你们。",
					function getResult()
					{
						return "Militia2";
					}

				},
				{
					Text = "前往并保卫%townname%的城镇中心。",
					function getResult()
					{
						local home = this.Contract.m.Home;
						local party = this.World.FactionManager.getFaction(this.Contract.getFaction()).spawnEntity(home.getTile(), home.getName() + "的民兵", false, this.Const.World.Spawn.Militia, home.getResources() * 0.7, this.Contract.getMinibossModifier());
						party.getSprite("banner").setBrush(home.getBanner());
						party.setDescription("用生命保卫家园的勇士。农夫、工匠、手艺人——唯独没有真正的士兵。");
						party.setFootprintType(this.Const.World.FootprintsType.Militia);
						this.Contract.m.Militia = this.WeakTableRef(party);
						local c = party.getController();
						local guard = this.new("scripts/ai/world/orders/guard_order");
						guard.setTarget(home.getTile());
						guard.setTime(300.0);
						local despawn = this.new("scripts/ai/world/orders/despawn_order");
						c.addOrder(guard);
						c.addOrder(despawn);
						return 0;
					}

				},
				{
					Text = "前往并保卫%townname%的郊区。",
					function getResult()
					{
						local home = this.Contract.m.Home;
						local party = this.World.FactionManager.getFaction(this.Contract.getFaction()).spawnEntity(home.getTile(), home.getName() + "的民兵", false, this.Const.World.Spawn.Militia, home.getResources() * 0.7, this.Contract.getMinibossModifier());
						party.getSprite("banner").setBrush(home.getBanner());
						party.setDescription("用生命保卫家园的勇士。农夫、工匠、手艺人——唯独没有真正的士兵。");
						party.setFootprintType(this.Const.World.FootprintsType.Militia);
						this.Contract.m.Militia = this.WeakTableRef(party);
						local c = party.getController();
						local locations = home.getAttachedLocations();
						local targets = [];

						foreach( l in locations )
						{
							if (l.isActive() && !l.isMilitary() && l.isUsable())
							{
								targets.push(l);
							}
						}

						local guard = this.new("scripts/ai/world/orders/guard_order");
						guard.setTarget(targets[this.Math.rand(0, targets.len() - 1)].getTile());
						guard.setTime(300.0);
						local despawn = this.new("scripts/ai/world/orders/despawn_order");
						c.addOrder(guard);
						c.addOrder(despawn);
						return 0;
					}

				},
				{
					Text = "去躲起来，别碍事。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Militia2",
			Title = "%townname%里",
			Text = "[img]gfx/ui/events/event_80.png[/img]既然你决定要指挥部分当地人，他们前来请示该如何武装自己，以应对即将到来的战斗。",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿上弓，你们呆在后方射箭。",
					function getResult()
					{
						for( local i = 0; i != 4; i = ++i )
						{
							local militia = this.World.getGuestRoster().create("scripts/entity/tactical/humans/militia_guest_ranged");
							militia.setFaction(1);
							militia.setPlaceInFormation(19 + i);
							militia.assignRandomEquipment();
						}

						return 0;
					}

				},
				{
					Text = "拿上剑和盾，你们将在前线战斗。",
					function getResult()
					{
						for( local i = 0; i != 4; i = ++i )
						{
							local militia = this.World.getGuestRoster().create("scripts/entity/tactical/humans/militia_guest");
							militia.setFaction(1);
							militia.setPlaceInFormation(19 + i);
							militia.assignRandomEquipment();
						}

						return 0;
					}

				},
				{
					Text = "你们可以随意武装。",
					function getResult()
					{
						for( local i = 0; i != 4; i = ++i )
						{
							local militia;

							if (this.Math.rand(0, 1) == 0)
							{
								militia = this.World.getGuestRoster().create("scripts/entity/tactical/humans/militia_guest");
							}
							else
							{
								militia = this.World.getGuestRoster().create("scripts/entity/tactical/humans/militia_guest_ranged");
							}

							militia.setFaction(1);
							militia.setPlaceInFormation(19 + i);
							militia.assignRandomEquipment();
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "MilitiaVolunteer",
			Title = "%townname%附近",
			Text = "[img]gfx/ui/events/event_80.png[/img]{战斗结束了，一名参与防守的民兵来到你面前，向你深深鞠躬，并献上他的剑。%SPEECH_ON%长官，我在%townname%的时光已经结束。但%companyname%的战斗力真是令人惊叹。如果你允许，长官，我十分渴望能与你和你的战士们并肩作战。%SPEECH_OFF% | 战斗结束后，一名来自%townname%的民兵表示，他很乐意加入%companyname%。一部分原因是他对这支战团的战斗力印象深刻，另一部分原因则是被征召参与城镇防守既赚不到钱又损害身体。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "欢迎加入%companyname%！",
					function getResult()
					{
						return 0;
					}

				},
				{
					Text = "你不适合来我们战团。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Kidnapping1",
			Title = "%townname%附近",
			Text = "[img]gfx/ui/events/event_30.png[/img]{在你保持警戒防备土匪时，一个农民前来告诉你，一伙暴徒袭击了附近，并掳走了一群人质。你难以置信地摇摇头。他们是怎么溜进来得手的？那个平民也摇着头。%SPEECH_ON%我以为你们是来帮我们的。你们为什么什么都没做？%SPEECH_OFF%你问土匪是否已经逃远。农民摇了摇头。看来你还有机会把他们追回来。 | 一个衣衫褴褛、拿着断草叉的男人冲到你的队伍前。他瘫倒在地，在你脚边哀嚎。%SPEECH_ON%土匪来了！你们在哪儿？他们杀了人……放火烧了一些……还……还抓走了一些人！求求你，去救救他们！%SPEECH_OFF%你看向%randombrother%，点了点头。%SPEECH_ON%让兄弟们准备好。我们得在这些恶棍完全逃脱前追上他们。%SPEECH_OFF% | 你紧盯着地平线，搜寻任何强盗或土匪的踪迹或声响。突然，%randombrother%带着一名女子来到你身边。她讲述道，暴徒已经发动了袭击，杀死了大量农民，并把没杀死的人都掳走了。那名佣兵点了点头。%SPEECH_ON%看来他们从我们眼皮底下溜过去了，长官。%SPEECH_OFF%你现在只有一个选择——去把那些人救回来！ | 你在%townname%附近驻扎，等待着土匪的袭击。你以为这会很轻松，但一个突然出现的疯狂平民表明情况并非如此。那农民解释说，掠夺者已经袭击了外围地区。他们屠杀了所有能杀的人，然后掳走了几个男人、女人和孩子。那人不知是喝醉了还是吓坏了，含糊地恳求着。%SPEECH_ON%把……把他们救回来，好吗？%SPEECH_OFF% | 在你保持警戒时，几个愤怒的农民走上大路，带着暴民的怒火向你涌来。%SPEECH_ON%我以为我们付钱是让你们保护我们的！你们当时在哪儿！%SPEECH_OFF%他们浑身是血。有些人衣不蔽体。一个女人袒露着一只乳房，愤怒到顾不上得体与否。你问这群人他们在说什么。一个男人，将手杖紧紧抱在胸前，解释说袭击者和暴徒已经攻击了附近的一个小村落。他们屠杀了眼前的一切，然后，在杀戮欲得到满足后，尽可能多地抓了俘虏。\n\n你点了点头。%SPEECH_ON%我们会把他们救回来的。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "追上他们！",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Kidnapping2",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_22.png[/img]{你收剑入鞘，命令%randombrother%去释放囚犯。一连串茫然无措的农民从皮绳、锁链和狗笼中被解救出来。他们感谢你的及时到来，以及你给予那些土匪的制裁。 | 土匪被尽数歼灭。你派手下尽力搜寻并解救每一个农民。他们聚在一起，拥抱哭泣，为从这场可怕磨难中幸存下来而欣喜若狂。 | 在杀掉周围最后一个土匪后，你命令战团去释放流寇抓走的人质。他们轮流来到你面前，有的亲吻你的手，有的亲吻你的脚。你只告诉他们返回%townname%。你自己也会很快赶到。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "看起来结束了。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Kidnapping3",
			Title = "%townname%附近",
			Text = "[img]gfx/ui/events/event_53.png[/img]{不幸的是，土匪挟持着人质逃脱了。愿诸神此刻与那些可怜的灵魂同在。 | 你没能做到——你没能救出那些可怜的农民。现在只有诸神知道他们会遭遇什么。 | 可悲的是，掠夺者带着他们掳掠的人口逃脱了。那些可怜人现在只能自求多福了。然而，你所听闻的种种传闻都表明，他们绝不会有什么好下场。 | 土匪逃脱了，囚犯也一同被带走了。你不知道那些人如今会遭遇什么，但你知道绝不会是好事。奴役。折磨。死亡。你不确定哪一个才是最糟的。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{这种事情肯定会让%townname%的人不满…… | 或许能把他们赎买回来……}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{你回到%employer%那里，一脸理所当然的得意。%SPEECH_ON%事情办完了。%SPEECH_OFF%他点点头，晃动着酒杯，但并没有递过来的意思。%SPEECH_ON%是的。镇子永远感激你的帮助。他们也在……金钱上表示了感激。%SPEECH_OFF%他朝房间角落示意。你看到那里有一袋克朗。%SPEECH_ON%我们约定的%reward%克朗。再次感谢，佣兵。 | %employer%拿着一杯酒欢迎你的归来。%SPEECH_ON%喝了吧，佣兵，这是你应得的。%SPEECH_OFF%这味道……很特别。如果高傲能成为一种味道，那这就是。你的雇主绕过他的桌子，兴高采烈地坐下。%SPEECH_ON%你果然如承诺的那样保护了镇子！我印象深刻。%SPEECH_OFF%他点点头，用酒杯指向一个木箱。%SPEECH_ON%非、常、印、象、深、刻。%SPEECH_OFF%你打开箱子，发现里面满是金克朗。 | %employer%欢迎你进入他的房间。%SPEECH_ON%我可是从我的窗户看着呢，你知道吗？全看见了。嗯，大部分吧。我想，是那些精彩的部分。%SPEECH_OFF%你挑起一边眉毛。%SPEECH_ON%哦，别那么看着我。善于享受可不是什么污点。我们还活着，对吧？我们这些善良人。%SPEECH_OFF%你的另一边眉毛也挑了起来。%SPEECH_ON%好吧……总之，你的报酬，如约奉上。%SPEECH_OFF%那人递过来一个装着%reward%克朗的箱子。 | 当你回到%employer%那里时，发现他的房间几乎已经打包完毕，一切都准备好要搬走了。你带着几分幽默的关切问道。%SPEECH_ON%准备去什么地方吗？%SPEECH_OFF%那人安稳地坐进他的椅子。%SPEECH_ON%我之前的确怀疑过你的能力，佣兵。这能怪我吗？不过话说回来，你倒是不必怀疑我的支付能力。%SPEECH_OFF%他的手在桌面上挥过。角落那里放着一个行囊，鼓鼓囊囊地装满了硬币。%SPEECH_ON%商量好的%reward%克朗。%SPEECH_OFF% | 你进去时，%employer%从椅子上站起身来。他鞠了一躬，带着些难以置信，但又很真诚。他把头歪向窗户，窗外传来快乐农民们的嗡嗡嘈杂声。%SPEECH_ON%你听到了吗？这是你挣得的，雇佣兵。这里的民众现在爱上你了。%SPEECH_OFF%你点点头，但普通人的爱戴可不是你来此的目的。%SPEECH_ON%我还挣得了什么？%SPEECH_OFF%%employer%笑了。%SPEECH_ON%真是个直接的人。我敢说这就是你的……过人之处。当然，你还挣得了这个。%SPEECH_OFF%他把一个木箱重重放在桌上并打开插销。金克朗的光芒温暖了你的心。 | 你进去时，%employer%正凝视着窗外。他几乎处于一种出神的状态，头低低地靠在手上。你打断了他的思绪。%SPEECH_ON%在想我？%SPEECH_OFF%那人轻笑一声，开玩笑似的捂住胸口。%SPEECH_ON%你真是我梦中情人啊，佣兵。%SPEECH_OFF%他穿过房间，从书架上取下一个箱子。放在桌上时他打开了插销。一堆耀眼的金克朗直勾勾地盯着你。%employer%咧嘴一笑。%SPEECH_ON%看来我们知道你的梦中情人是谁了。%SPEECH_OFF% | 你进去时，%employer%正在他的书桌前。%SPEECH_ON%我看到不少场面。杀戮，死亡。%SPEECH_OFF%你坐了下来。%SPEECH_ON%希望你喜欢这场表演。不过，观看可不是免费的。%SPEECH_OFF%那人点点头，拿起一个行囊递过来。%SPEECH_ON%我倒愿意为返场表演付钱，但我不确定%townname%还想再来一次。%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{%companyname%正需要这笔钱。 | 这钱可不好挣。}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "抵御强盗，保卫城镇");
						this.World.Contracts.finishActiveContract();

						if (this.Flags.get("IsUndead") && this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
						}

						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color]克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_30.png[/img]{%employer%对你的归来表示欢迎，同时指向窗外。%SPEECH_ON%看见了吗？那边，远处。%SPEECH_OFF%你走到他身边。他问道。%SPEECH_ON%你看到什么了？%SPEECH_OFF%地平线上有烟。你如实相告。%SPEECH_ON%对，烟。我雇你不是为了让那些土匪点火放烟的，明白吗？当然……镇子大部分完好无损……%SPEECH_OFF%他把一个钱袋重重塞进你怀里。%SPEECH_ON%干得好，佣兵。只是……还不够好。%SPEECH_OFF% | 你回到%employer%那里，他看起来悲喜交加，介于醉与醒之间。这可不是你想看到的表情。%SPEECH_ON%你做得不错，佣兵。有消息说你把那帮土匪彻底摆平了。但也有消息说他们烧毁了我们外围的部分地区。%SPEECH_OFF%你点点头。对于无法掩盖的事情，撒谎毫无意义。%SPEECH_ON%你会拿到报酬，但你必须明白，重建那些地区需要钱。很显然，这些费用将从你的口袋里出……%SPEECH_OFF% | 你回来时，%employer%正瘫坐在他的座位上。%SPEECH_ON%%townname%里大部分人都很高兴，但有一些人不高兴。你能猜到是哪些人不高兴吗？%SPEECH_OFF%土匪确实摧毁了部分外围地区，但很显然他不需要你回答。%SPEECH_ON%我需要资金来重建那些掠夺者得手的区域。我相信你明白，为什么你收到的报酬会因此变少……%SPEECH_OFF%你耸耸肩。事已至此。 | %employer%正在他的书架前。他取下一本书，转身并同时将其打开，动作一气呵成。他把书摊在桌上。%SPEECH_ON%上面有些数字。我敢肯定你看不懂，但它们的意思是：土匪成功摧毁了本镇的部分地区，现在我需要钱来帮助重建。不幸的是，我手头没有那么多克朗来做这件事。我相信你理解这困境。%SPEECH_OFF%你点点头。%SPEECH_ON%所以要从你的报酬里扣。%SPEECH_OFF%随后他张开手在桌面上滑过，将你的注意力引向一个行囊。争论报酬毫无意义。你拿起钱袋，转身离开。}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{这只有说好的一半！ | 事已至此……}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() / 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractPoor, "抵御强盗，保卫城镇");
						this.World.Contracts.finishActiveContract();

						if (this.Flags.get("IsUndead") && this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
						}

						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() / 2;
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color]克朗"
				});
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success3",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{你回到%employer%那里，一脸理所当然的得意。%SPEECH_ON%事情办完了。%SPEECH_OFF%他点点头，晃动着酒杯，但并没有递过来的意思。%SPEECH_ON%是的。镇子永远感激你的帮助。他们也在……金钱上表示了感激。%SPEECH_OFF%他朝房间角落示意。你看到那里有一袋克朗。%SPEECH_ON%我们约定的%reward%克朗。再次感谢，佣兵。哦还有，呃，那些农民真可惜……%SPEECH_OFF% | %employer%拿着一杯酒欢迎你的归来。%SPEECH_ON%喝了吧，佣兵，这是你应得的。%SPEECH_OFF%这味道……很特别。如果高傲能成为一种味道，那这就是。你的雇主绕过他的桌子，兴高采烈地坐下。%SPEECH_ON%你果然如承诺的那样保护了镇子！我印象深刻。%SPEECH_OFF%他点点头，用酒杯指向一个木箱。%SPEECH_ON%非、常、印、象、深、刻。%SPEECH_OFF%你打开箱子，发现里面满是金克朗。%SPEECH_ON%那些被掳走的农民真是遗憾。我相应地做了一些调整……%SPEECH_OFF% | %employer%欢迎你进入他的房间。%SPEECH_ON%我可是从我的窗户看着呢，你知道吗？全看见了。嗯，大部分吧。我想，是那些精彩的部分。%SPEECH_OFF%你挑起一边眉毛。%SPEECH_ON%哦，别那么看着我。善于享受可不是什么污点。我们还活着，对吧？我们这些善良人。%SPEECH_OFF%你的另一边眉毛也挑了起来。%SPEECH_ON%好吧……总之，你的报酬，如约奉上。我听说有几个农民被带走了。我扣掉了一些。那笔钱会交给幸存者。%SPEECH_OFF%那人递过来一个装着%reward%克朗的箱子。 | 当你回到%employer%那里时，发现他的房间几乎已经打包完毕，一切都准备好要搬走了。你带着几分幽默的关切问道。%SPEECH_ON%准备去什么地方吗？%SPEECH_OFF%那人安稳地坐进他的椅子。%SPEECH_ON%我之前的确怀疑过你的能力，佣兵。这能怪我吗？不过话说回来，你倒是不必怀疑我的支付能力。%SPEECH_OFF%他的手在桌面上挥过。角落那里放着一个行囊，鼓鼓囊囊地装满了硬币。%SPEECH_ON%比约定的少了几克朗。你知道那些被土匪掳走的农民会有什么下场吧？没错，我减少你的报酬是有原因的。%SPEECH_OFF% | 你进去时，%employer%从椅子上站起身来。他鞠了一躬，带着些难以置信，但又很真诚。他把头歪向窗户，窗外传来快乐农民们的嗡嗡嘈杂声。%SPEECH_ON%你听到了吗？这是你挣得的，雇佣兵。这里的民众现在爱上你了。%SPEECH_OFF%你点点头，但普通人的爱戴可不是你来此的目的。%SPEECH_ON%我还挣得了什么？%SPEECH_OFF%%employer%笑了。%SPEECH_ON%真是个直接的人。我敢说这就是你的……过人之处。当然，你还挣得了这个。嗯，稍微少一点。你放任土匪掳走了那些农民，这算是件糟心事，对吧？%SPEECH_OFF%他把一个木箱重重放在桌上并打开插销。金克朗的光芒温暖了你的心。 | 你进去时，%employer%正凝视着窗外。他几乎处于一种出神的状态，头低低地靠在手上。你打断了他的思绪。%SPEECH_ON%在想我？%SPEECH_OFF%那人轻笑一声，开玩笑似的捂住胸口。%SPEECH_ON%你真是我梦中情人啊，佣兵。%SPEECH_OFF%他穿过房间，从书架上取下一个箱子。放在桌上时他打开了插销。一堆耀眼的金克朗直勾勾地盯着你。%employer%咧嘴一笑，但笑容来得快也去得快。%SPEECH_ON%比预期的要少一点？那些你让土匪掳走的农民的幸存家属会得到那份。我相信你能理解。%SPEECH_OFF% | 你进去时，%employer%正在他的书桌前。%SPEECH_ON%我看到不少场面。杀戮，死亡。%SPEECH_OFF%你坐了下来。%SPEECH_ON%希望你喜欢这场表演。不过，观看可不是免费的。%SPEECH_OFF%那人点点头，拿起一个行囊递过来。%SPEECH_ON%我倒愿意为返场表演付钱，但我不确定%townname%还想再来一次。当然，那些被袭击者带走的可怜人可不想有现在的下场。%SPEECH_OFF%你朝袋子里瞥了一眼，发现比预期的少了几克朗。}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{这只有说好的一半！ | 事已至此……}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() / 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractPoor, "抵御强盗，保卫城镇");
						this.World.Contracts.finishActiveContract();

						if (this.Flags.get("IsUndead") && this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
						}

						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() / 2;
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color]克朗"
				});
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success4",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_30.png[/img]{%employer%对你的归来表示欢迎，同时指向窗外。%SPEECH_ON%看见了吗？那边，远处。%SPEECH_OFF%你走到他身边。他问道。%SPEECH_ON%你看到什么了？%SPEECH_OFF%地平线上有烟。你如实相告。%SPEECH_ON%对，烟。我雇你不是为了让那些土匪点火放烟的，明白吗？当然……镇子大部分完好无损……%SPEECH_OFF%他把一个钱袋重重塞进你怀里。%SPEECH_ON%干得好，佣兵。只是……还不够好。可惜了那些被土匪掳走的可怜农民。%SPEECH_OFF% | 你回到%employer%那里，他看起来悲喜交加，介于醉与醒之间。这可不是你想看到的表情。%SPEECH_ON%你做得不错，佣兵。有消息说你把那帮土匪彻底摆平了。但也有消息说他们烧毁了我们外围的部分地区。%SPEECH_OFF%你点点头。对于无法掩盖的事情，撒谎毫无意义。%SPEECH_ON%你会拿到报酬，但你必须明白，重建那些地区需要钱。还有你让袭击者绑架的那些可怜人怎么办？他们的家属也会需要帮助。很显然，这些费用将从你的口袋里出……%SPEECH_OFF% | 你回来时，%employer%正瘫坐在他的座位上。%SPEECH_ON%%townname%里大部分人都很高兴，但有一些人不高兴。你能猜到是哪些人不高兴吗？%SPEECH_OFF%土匪确实摧毁了部分外围地区，但很显然他不需要你回答。%SPEECH_ON%我需要资金来重建那些掠夺者得手的区域。我还需要克朗来帮助那些你没能救下的农民的幸存家属。我相信你明白，为什么你收到的报酬会因此变少……%SPEECH_OFF%你耸耸肩。事已至此。 | %employer%正在他的书架前。他取下一本书，转身并同时将其打开，动作一气呵成。他把书摊在桌上。%SPEECH_ON%上面有些数字。我敢肯定你看不懂，但它们的意思是：土匪成功摧毁了本镇的部分地区，现在我需要钱来帮助重建。不幸的是，我手头没有那么多克朗来做这件事。我相信你理解这困境。%SPEECH_OFF%你点点头。%SPEECH_ON%所以要从你的报酬里扣。还有你让土匪掳走的那些农民呢？他们还有家人。还有幸存者。他们也会从我们的‘协议’中分走一份。%SPEECH_OFF%随后他张开手在桌面上滑过，将你的注意力引向一个行囊。争论报酬毫无意义。你拿起钱袋，转身离开。}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{这只有说好的一半！ | 事已至此……}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() / 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(0);
						this.World.Contracts.finishActiveContract();

						if (this.Flags.get("IsUndead") && this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
						}

						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() / 2;
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color]克朗"
				});
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_30.png[/img]{你走进%employer%的房间，他让你随手关门。就在门闩咔哒一声合上时，那人劈头盖脸对你就是一通污言秽语，你根本记不清都骂了些什么。冷静下来后，他的声音——和用词——恢复了某种程度的正常。%SPEECH_ON%我们的外围地区全被毁了。你以为我付钱是让你干嘛的？给我滚出去。%SPEECH_OFF% | 你进去时，%employer%正仰头猛灌葡萄酒。窗外传来愤怒农民们吵嚷的喧闹声。%SPEECH_ON%听见了吗？如果我付钱给你，他们会要了我的命，佣兵。你只有一个任务，一个任务！保护这个镇子。而你做不到。所以现在你可以免费做一件事：立刻从我眼前消失。%SPEECH_OFF% | %employer%双手紧握，撑在桌上。%SPEECH_ON%你到底指望在这里得到什么？我很惊讶你居然还敢回来见我。半个镇子都在燃烧，另外半个已经烧成了灰。我花钱不是雇你来看戏的，佣兵。立刻给我滚出去。%SPEECH_OFF% | 当你回到%employer%那里时，他正端着一杯麦酒。他的手在发抖。他的脸涨得通红。%SPEECH_ON%我现在是用尽了全部力气才没把这玩意儿泼到你脸上。%SPEECH_OFF%为防万一，那人还是一大口灌完了酒。他把杯子重重砸在桌上。%SPEECH_ON%这个镇子指望你保护他们。结果呢，那些土匪像他妈度假一样涌进了外围！我来这不是给掠夺者提供乐子的，佣兵。赶紧给我滚出去！%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{该死的农民！ | 早知道就多要一些酬金了…… | 该死的！}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "未能成功抵御强盗的进攻。");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Failure2",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_30.png[/img]{你走进%employer%的房间，他让你随手关门。就在门闩咔哒一声合上时，那人劈头盖脸对你就是一通污言秽语，你根本记不清都骂了些什么。冷静下来后，他的声音——和用词——恢复了某种程度的正常。%SPEECH_ON%我们的外围地区全被毁了，还有一堆人被掳走。你以为我付钱是让你干嘛的？给我滚出去。%SPEECH_OFF% | 你进去时，%employer%正仰头猛灌葡萄酒。窗外传来愤怒农民们吵嚷的喧闹声。%SPEECH_ON%听见了吗？如果我付钱给你，他们会要了我的命，佣兵。你只有一个任务，一个任务！保护这个镇子。而你做不到。见鬼，你连救出那些被掳走的农民都做不到！所以现在你可以免费做一件事：立刻从我眼前消失。%SPEECH_OFF% | %employer%双手紧握，撑在桌上。%SPEECH_ON%你到底指望在这里得到什么？我很惊讶你居然还敢回来见我。半个镇子都在燃烧，另外半个已经烧成了灰。甚至还有幸存的民众跟我说他们的家属被绑架了！你知道那些被掳走的人会是什么下场吗？我花钱不是雇你来看戏的，佣兵。立刻给我滚出去。%SPEECH_OFF% | 当你回到%employer%那里时，他正端着一杯麦酒。他的手在发抖。他的脸涨得通红。%SPEECH_ON%我现在是用尽了全部力气才没把这玩意儿泼到你脸上。%SPEECH_OFF%为防万一，那人还是一大口灌完了酒。他把杯子重重砸在桌上。%SPEECH_ON%这个镇子指望你保护他们。结果呢，那些土匪像他妈度假一样涌进了外围！我来这不是给掠夺者提供乐子的，佣兵。赶紧给我滚出去！%SPEECH_OFF% | 你刚踏进%employer%的房间，他就大声笑了起来。外围地区全毁了。%townname%的民众乱成一团——至少那些还活着的、能发火的人是如此。更过分的是什么？你竟然让一些镇民被这些怪物抓走了！%SPEECH_OFF%那人摇着头，用手指向门口。%SPEECH_ON%我不知道你指望我付钱给你干什么，但绝不是为了这种结果。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{该死的农民！ | 早知道就多要一些酬金了…… | 该死的！}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "未能成功抵御强盗的进攻。");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"reward",
			this.m.Reward
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			local s = this.new("scripts/entity/world/settlements/situations/raided_situation");
			s.setValidForDays(4);
			this.m.SituationID = this.m.Home.addSituation(s);
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.World.FactionManager.getFaction(this.getFaction()).setActive(true);
			this.m.Home.getSprite("selection").Visible = false;

			if (this.m.Kidnapper != null && !this.m.Kidnapper.isNull())
			{
				this.m.Kidnapper.getSprite("selection").Visible = false;
			}

			if (this.m.Militia != null && !this.m.Militia.isNull())
			{
				this.m.Militia.getController().clearOrders();
			}

			this.World.getGuestRoster().clear();
		}
	}

	function onIsValid()
	{
		local nearestBandits = this.getNearestLocationTo(this.m.Home, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getSettlements());
		local nearestZombies = this.getNearestLocationTo(this.m.Home, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getSettlements());

		if (nearestZombies.getTile().getDistanceTo(this.m.Home.getTile()) > 20 && nearestBandits.getTile().getDistanceTo(this.m.Home.getTile()) > 20)
		{
			return false;
		}

		local locations = this.m.Home.getAttachedLocations();

		foreach( l in locations )
		{
			if (l.isUsable() && l.isActive() && !l.isMilitary())
			{
				return true;
			}
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.m.Flags.set("KidnapperID", this.m.Kidnapper != null && !this.m.Kidnapper.isNull() ? this.m.Kidnapper.getID() : 0);
		this.m.Flags.set("MilitiaID", this.m.Militia != null && !this.m.Militia.isNull() ? this.m.Militia.getID() : 0);
		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.contract.onDeserialize(_in);
		this.m.Kidnapper = this.WeakTableRef(this.World.getEntityByID(this.m.Flags.get("KidnapperID")));
		this.m.Militia = this.WeakTableRef(this.World.getEntityByID(this.m.Flags.get("MilitiaID")));
	}

});
