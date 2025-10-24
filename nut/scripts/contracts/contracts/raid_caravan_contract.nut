this.raid_caravan_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		LastCombatTime = 0.0
	},
	function setEnemyNobleHouse( _h )
	{
		this.m.Flags.set("EnemyNobleHouse", _h.getID());
	}

	function create()
	{
		this.contract.create();
		this.m.Type = "contract.raid_caravan";
		this.m.Name = "劫掠商队";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 800 * this.getPaymentMult() * this.getDifficultyMult() * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		local myTile = this.World.State.getPlayer().getTile();
		local enemyFaction = this.World.FactionManager.getFaction(this.m.Flags.get("EnemyNobleHouse"));
		local settlements = enemyFaction.getSettlements();
		local lowest_distance = 99999;
		local highest_distance = 0;
		local best_start;
		local best_dest;

		foreach( s in settlements )
		{
			if (s.isIsolated())
			{
				continue;
			}

			local d = s.getTile().getDistanceTo(myTile);

			if (d < lowest_distance)
			{
				lowest_distance = d;
				best_dest = s;
			}

			if (d > highest_distance)
			{
				highest_distance = d;
				best_start = s;
			}
		}

		this.m.Flags.set("InterceptStart", best_start.getID());
		this.m.Flags.set("InterceptDest", best_dest.getID());
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"劫掠从%start%前往%dest%的商队",
					"返回%townname%"
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
				this.Flags.set("Survivors", 0);

				if (r <= 10)
				{
					this.Flags.set("IsBribe", true);
					this.Flags.set("Bribe1", this.Contract.beautifyNumber(this.Contract.m.Payment.Pool * (this.Math.rand(70, 150) * 0.01)));
					this.Flags.set("Bribe2", this.Contract.beautifyNumber(this.Contract.m.Payment.Pool * (this.Math.rand(70, 150) * 0.01)));
				}
				else if (r <= 15)
				{
					if (this.Contract.getDifficultyMult() >= 1.0)
					{
						this.Flags.set("IsSwordmaster", true);
					}
				}
				else if (r <= 20)
				{
					if (this.Contract.getDifficultyMult() >= 1.0)
					{
						this.Flags.set("IsUndeadSurprise", true);
					}
				}
				else if (r <= 25)
				{
					this.Flags.set("IsWomenAndChildren", true);
				}
				else if (r <= 35)
				{
					this.Flags.set("IsCompromisingPapers", true);
				}

				local enemyFaction = this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse"));
				local best_start = this.World.getEntityByID(this.Flags.get("InterceptStart"));
				local best_dest = this.World.getEntityByID(this.Flags.get("InterceptDest"));
				local party = enemyFaction.spawnEntity(best_start.getTile(), "商队", false, this.Const.World.Spawn.NobleCaravan, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.getSprite("base").Visible = false;
				party.getSprite("banner").setBrush(enemyFaction.getBannerSmall());
				party.setMirrored(true);
				party.setVisibleInFogOfWar(true);
				party.setImportant(true);
				party.setDiscovered(true);
				party.setDescription("一支有武装护卫的商队，在定居点间运送值得保护的货物。");
				party.setFootprintType(this.Const.World.FootprintsType.Caravan);
				party.getFlags().set("IsCaravan", true);
				party.setAttackableByAI(false);
				party.getFlags().add("ContractCaravan");
				this.Contract.m.Target = this.WeakTableRef(party);
				this.Contract.m.UnitsSpawned.push(party);
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

				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local move = this.new("scripts/ai/world/orders/move_order");
				move.setDestination(best_dest.getTile());
				move.setRoadsOnly(true);
				local despawn = this.new("scripts/ai/world/orders/despawn_order");
				c.addOrder(move);
				c.addOrder(despawn);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onTargetAttacked.bindenv(this));
					this.Contract.m.Target.setVisibleInFogOfWar(true);
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull())
				{
					if (this.Flags.get("IsWomenAndChildren"))
					{
						this.Contract.setScreen("WomenAndChildren1");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsCompromisingPapers"))
					{
						this.Contract.setScreen("CompromisingPapers1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setState("Return");
					}
				}
				else if (this.Contract.isEntityAt(this.Contract.m.Target, this.World.getEntityByID(this.Flags.get("InterceptDest"))))
				{
					this.Contract.setScreen("Failure3");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Target))
				{
					this.onTargetAttacked(this.Contract.m.Target, false);
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (!this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);

					if (this.Flags.get("IsBribe"))
					{
						this.Contract.setScreen("Bribe1");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsSwordmaster"))
					{
						this.Contract.setScreen("Swordmaster");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsUndeadSurprise"))
					{
						this.Contract.setScreen("UndeadSurprise");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.onTargetAttacked(_dest, true);
					}
				}
				else if (this.Time.getVirtualTimeF() >= this.Contract.m.LastCombatTime + 5.0)
				{
					local enemyFaction = this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse"));
					enemyFaction.setIsTemporaryEnemy(true);
					this.Contract.m.LastCombatTime = this.Time.getVirtualTimeF();
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
				}
			}

			function onActorRetreated( _actor, _combatID )
			{
				if (!_actor.isNonCombatant() && _actor.getFaction() == this.Flags.get("EnemyNobleHouse") && this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("Survivors", this.Flags.get("Survivors") + 1);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Contract.m.LastCombatTime = this.Time.getVirtualTimeF();
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"返回%townname%"
				];
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Flags.get("IsCompromisingPapers"))
					{
						if (this.Flags.get("IsExtorting"))
						{
							this.Contract.setScreen("CompromisingPapers2");
							this.World.Contracts.showActiveContract();
						}
						else
						{
							this.Contract.setScreen("CompromisingPapers3");
							this.World.Contracts.showActiveContract();
						}
					}
					else if (this.Flags.get("Survivors") == 0)
					{
						this.Contract.setScreen("Success1");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Math.rand(1, 100) > this.Flags.get("Survivors") * 15)
					{
						this.Contract.setScreen("Failure1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("Failure2");
						this.World.Contracts.showActiveContract();
					}
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{你坐下时，%employer%在你面前摊开一张地图。他的手指划过一条绘制粗糙的道路。%SPEECH_ON%有一支商队走这条路线。我需要你袭击它，但是等等！%SPEECH_OFF%他竖起那根手指。%SPEECH_ON%我需要这事看起来像是强盗干的。绝不能有人知道是我下令毁了它，明白吗？%SPEECH_OFF% | %employer%解释说需要摧毁一支商队。你询问像他这样的贵族为何会放出这种工作，但这人却语焉不详。他的主要要求很简单：摧毁商队，杀光所有人。必须让现场看起来像是{强盗 | 匪徒 | 流寇 | 绿皮}干的，不然他的声誉可能被玷污。%SPEECH_ON%最后那部分听明白了吗，佣兵？你当然明白了。你是个聪明人，对吧？%SPEECH_OFF% | 你坐下时，%employer%从书架上取下一本大书在你面前打开。书的宽度几乎覆盖了整个桌面，书页上满是极其详尽的地图。这位贵族指着其中一幅地形图上的一条线。%SPEECH_ON%我需要摧毁的商队走的就是这条路线。别多问，毁掉商队就是了。还有，我唯一的要求就是让这事看起来像是强盗干的，明白吗？不能让人知道命令是我这里发出的。这对你来说可行吗？%SPEECH_OFF% | %employer%与你握手表示欢迎，但当你想抽回手时他却握紧了。%SPEECH_ON%我接下来要说的话绝不能传出这个房间，明白吗？%SPEECH_OFF%你点了点头，他这才松手。%SPEECH_ON%很好。我需要摧毁一支商队，但是……绝不能让人知道是你们这些佣兵干的。如果他们知道了，很容易就会追查到我这里。我需要这事看起来像是强盗干的。不能留任何活口，明白吗？%SPEECH_OFF%你耸耸肩，仿佛在说“小菜一碟”。%SPEECH_ON%很好，那么我们就算达成协议了？%SPEECH_OFF% | 当你在%employer%的书房坐下时，一个陌生人从你身后进来，对着这位贵族耳语了几句。随后，这个神秘男子就转身离开了。%employer%站起身给自己倒了杯葡萄酒，并没给你倒。%SPEECH_ON%我需要摧毁一支商队，但这事需要做得足够隐秘。绝不能让人知道是我，%employer%，指使你这么干的。不，这是强盗干的，那些混蛋……明白吗？你懂我的意思吗？如果你懂了，我们来谈谈价钱。%SPEECH_OFF% | 你坐下时，%employer%询问你对强盗的勾当有多熟悉。你表示他们的生活跟你自己也没太大不同，只不过你更聪明，而且能接触到比抢劫农民收入更高的差事。%employer%点点头。%SPEECH_ON%很好，因为我需要你假扮一天强盗，去摧毁一支商队。不能留任何活口。绝不能让人知道是你这种佣兵干的。明白吗？如果明白了，我们来谈谈价钱。%SPEECH_OFF%}",
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
					Text = "{听起来这活不适合我们。 | 我觉得还是免了吧。}",
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
			ID = "Bribe1",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_41.png[/img]{你们正在逼近商队，一名护卫发现了你们，所有人立刻拔出了武器。一个男人高举双手边跑边喊，要求双方都放下武器。他手里拿着个沉甸甸的钱袋，装着%bribe%克朗，说只要你们放他们走，这钱就归你们了。你大声质疑，既然可以把他们全杀了再拿走钱，为什么还要接受贿赂。那人耸耸肩。%SPEECH_ON%这个嘛，反正我们也不会任人宰割，拿了钱走人，你们也省得“杀”我们了。拿着钱走吧，佣兵。%SPEECH_OFF% | 当你的手下接近商队时，一名护卫发现了你们并吹响了号角，提醒其他人你们的出现。很快，一整支武装护卫队就严阵以待地站在你们面前。车队头领穿过他们的防线，高举双手。%SPEECH_ON%都别动手！佣兵，我想跟你做个交易。你拿走这袋%bribe%克朗然后离开，今天就没人需要死在这里。%SPEECH_OFF%你刚想开口回应，那人竖起一根手指继续说。%SPEECH_ON%喂，想清楚点，佣兵。你们已经失去突袭优势了，我雇这些人来保护车队不是没有道理的——他们跟你们一样，都是狠角色。%SPEECH_OFF% | 你的手下正在逼近，商队的毁灭似乎近在眼前。不幸的是，你眼睁睁看着一名佣兵失足踩到一根滚动的树枝，滑倒后滚下了一个小山坡。这阵响动足以惊动整个车队，你看着武装护卫们蜂拥而出迎战你们。他们的头目跑到两军之间，高举双臂。%SPEECH_ON%等等。先别急。在咱们开始打打杀杀之前，先说几句话如何？我这儿有%bribe%克朗。%SPEECH_OFF%那人举起一个钱袋朝你们晃了晃。%SPEECH_ON%你拿走这个，走人，咱们就各走各路。没必要非得拼个你死我活，对吧？要我说这买卖挺划算，佣兵，毕竟你们已经没了偷袭的优势——接下来可就是硬碰硬了。你觉得如何？%SPEECH_OFF% | 就在你以为手下即将对商队发动袭击时，一个看守货车的护卫发现了他们。他急忙冲向警钟，就在钟被敲响的同时，%randombrother%砸碎了他的脑袋。不幸的是，大量其他护卫已经蜂拥而出，举起了武器。他们的头领站在一旁，按住队伍不让他们冲锋。%SPEECH_ON%喂，弟兄们！先别急。也许咱们可以商量个不那么……暴力的方式来解决眼下这事。%SPEECH_OFF%他瞥了一眼那个脑袋开花的护卫。%SPEECH_ON%呃，至少对我们剩下的人是这样。我手里有%bribe%克朗。伏击者、刺客，随你怎么称呼自己，拿着钱走人，这钱就是你的了。我建议你最好照做——你们已经没了偷袭的先手，而我花大价钱雇这些人来看守我的货物，明白吗？%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{就这样吧。把钱给我。 | 这很合理，我们接受。}",
					function getResult()
					{
						return "Bribe2";
					}

				},
				{
					Text = "别见怪，但这支商队必须要烧成灰——连你一起。",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Bribe2",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_41.png[/img]{你正要离开，商队头领抓住了你的胳膊。%SPEECH_ON%嘿，我有点好奇，而且我打赌你能满足我的好奇。%SPEECH_OFF%你恼怒地把胳膊从他手里抽回来。他道了歉，但马上切入正题。%SPEECH_ON%我想知道到底是谁派你来的。再多加%bribe2%克朗塞进你那包里，让我耳朵听听这消息，你觉得怎样？%SPEECH_OFF% | 在你离开前，商队头领叫住了你。%SPEECH_ON%我有点事儿琢磨不透，佣兵，而且我知道你有答案：谁派你来的？%SPEECH_OFF%你环顾四周。他笑了，拍拍你的肩膀。%SPEECH_ON%明摆着我不可能白要答案。在你那包里再多塞%bribe2%克朗怎么样？就换几个字，拼出个所谓的‘名字’。所以，把那个名字告诉我吧，佣兵。%SPEECH_OFF% | 头领在你离开前喊住了你。他抱着胳膊，百无聊赖地踢着石子。%SPEECH_ON%要知道，我还不能就这么放你走。有些要紧消息我想打听，而且我愿意再多扔%bribe2%克朗到那个钱袋里，就为买这个消息。%SPEECH_OFF%你环顾四周，确认没有埋伏等着你。然后转回头对那人点了点头。%SPEECH_ON%你想知道是谁派我来的。%SPEECH_OFF%头领咧嘴一笑，双手一拍。%SPEECH_ON%好家伙，你这人一点就通！没错！我正是想知道这个！%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{那就把克朗给我吧。 | 行吧，反正到这一步也没啥差别了。 | 好买卖这下更划算了。}",
					function getResult()
					{
						return "Bribe3";
					}

				},
				{
					Text = "我绝不会这样败坏我们的名声，我们这就离开。",
					function getResult()
					{
						return "Bribe4";
					}

				}
			],
			function start()
			{
				this.World.Assets.addMoney(this.Flags.get("Bribe1"));
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail * 2);
				this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("Bribe1") + "[/color]克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "Bribe3",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_41.png[/img]{你收下额外的克朗塞进包里，然后对头领说出了那个名字：%employer%。他像含着一颗毒坚果般在嘴里品味着这个名字。%SPEECH_ON%%employer%。%employer%！呸，这名字。%employer%，简直像是……算了，我就不用突然涌上心头的那些粗鄙之词来烦你了。谢谢你，佣兵，就此别过。%SPEECH_OFF%你点头告辞。 | 你把额外的克朗收入囊中，然后把关键词告诉了头领：%employer%。那人一听就笑了，连连点头，仿佛早有所料。%SPEECH_ON%你做得不错，佣兵。不过今天可真够受的，对吧？起初你来这儿是要取我性命，几分钟后我们却如此友好地分道扬镳。你真是个天生的生意人。可惜你选择把这份才能用在刀剑而不是笔墨上。再见，一路顺风。%SPEECH_OFF% | {要么不做，要么做绝。 | 一不做二不休。} 你接受他的提议，把%employer%的勾当全抖了出来。商队头领郑重地点点头。%SPEECH_ON%要知道，我们生意人虽不像你们舞刀弄枪，但相信我，这行当同样凶险。一路顺风，佣兵。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "不用杀人就能拿钱。这种差事我倒是愿意多接一些。",
					function getResult()
					{
						this.World.Contracts.removeContract(this.Contract);
						return 0;
					}

				}
			],
			function start()
			{
				this.World.Assets.addMoney(this.Flags.get("Bribe2"));
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail * 2);
				this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().set("Betrayed", true);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("Bribe2") + "[/color]克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "Bribe4",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_41.png[/img]{你让那人滚开，他已经够走运了。对方点头表示同意，但他紧绷的神情已经充分表明了他对你拒绝的态度。 | 你摇了摇头。%SPEECH_ON%我可以放你走，但不能再进一步了。我还需要%employer%提供的工作，懂吗？%SPEECH_OFF%对方点了点头。%SPEECH_ON%明智的决定，虽然对我来说显然不太妙。不过我理解你，佣兵。愿旧神保佑你旅途平安。若他日再见，希望是在更友好的情形下！%SPEECH_OFF% | 背叛%employer%可能不是个好主意，你这么告诉了对方。他理解地点点头。%SPEECH_ON%好吧，既然如此。你保留底牌我也不能怪你，但说真的，我还是希望你能亮出来。一路顺风，佣兵。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们走！",
					function getResult()
					{
						this.World.Contracts.removeContract(this.Contract);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Swordmaster",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_35.png[/img]{正当你准备袭击商队时，%randombrother%来到你身边，指向车队中的一个人。%SPEECH_ON%知道那是谁吗？%SPEECH_OFF%你摇了摇头。%SPEECH_ON%那是%swordmaster%。%SPEECH_OFF%你眯起眼睛仔细打量，看到的只是个相貌普通的男人。这位佣兵解释说，那是个有名的剑术大师，死在他手上的人不计其数。他挠了挠鼻头吐了口唾沫。%SPEECH_ON%还想动手吗？%SPEECH_OFF% | 你用望远镜仔细观察商队，发现了一张熟悉的面孔：%swordmaster%。几年前你在%randomtown%的斗技大会上见过他参赛。如果没记错的话，他当时一只手绑在背上就赢了比赛。任何在步战中与他交手的人，都很快被他精湛的剑术斩杀。这家伙很危险，得小心应对。 | 侦察车队时，你看到一张似曾相识的脸。%randombrother%凑过来，正用匕首剔指甲。%SPEECH_ON%那是%swordmaster%，那个剑术大师。他今年已经杀了二十个人了。%SPEECH_OFF%身后传来一个粗哑的声音：%SPEECH_ON%我听说是五十个！可能六十个。现实点说四十五个……%SPEECH_OFF%看来这支商队的护卫里有个极其危险的对手……}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						this.Const.World.Common.addTroop(this.Contract.m.Target, {
							Type = this.Const.World.Spawn.Troops.Swordmaster
						}, true, this.Contract.getDifficultyMult() >= 1.1 ? 5 : 0);
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "UndeadSurprise",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_29.png[/img]{你下令进攻，手下们大踏步地冲了出去。商队护卫已经朝你们跑来，但个个面露惧色。他们身后还跟着一大群怪模怪样的生物。可以肯定这将会是一场最诡异的遭遇战…… | 当%companyname%拔出武器冲向商队时，几名弟兄放慢脚步指出：有支更庞大的队伍正从另一侧逼近车队。你停步细看，发现一大群亡灵正在朝这个位置集结！ | 看来这事没想的那么容易：当手下开始袭击商队时，%randombrother%发现一大群恐怖的亡灵正从另一侧逼近！不管是亡灵还是将死之人，都无所谓。你来这儿就是要替%employer%办事。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						local enemyFaction = this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse"));
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos(), true);
						p.CombatID = "UndeadSurprise";
						p.Music = this.Const.Music.UndeadTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.TemporaryEnemies = [
							this.Flags.get("EnemyNobleHouse")
						];
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];
						p.EnemyBanners = [
							enemyFaction.getBannerSmall(),
							this.Const.ZombieBanners[0]
						];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Necromancer, 100 * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "WomenAndChildren1",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_97.png[/img]{当你的手下清理战场上的伤员时，%randombrother%带着一队妇女儿童来到你面前。你举起剑问这是怎么回事。%SPEECH_ON%看起来他们带着家人一起来了。您要我们怎么处理？%SPEECH_OFF%如果放他们走，很可能会泄露你们在此的消息。如果杀了他们……这恐怕会让任何有良知的人都难以承受…… | 战斗获胜后，你的手下分散开来收集战利品，并确保每个商队护卫都死透了。不幸的是，不是所有人都死了。一群妇女儿童从战斗的废墟中现身，像受伤的野狗般虚弱地慢慢靠近。有些人浑身是血，有些则没被战斗波及。%randombrother%询问该如何处置他们。%SPEECH_ON%我们或许该放他们走，毕竟……看看他们这样子。但是……他们可能会说出去。你知道女人都管不住嘴。%SPEECH_OFF%佣兵紧张地笑了笑。一名妇女紧紧捂住胸口：%SPEECH_ON%我们发誓绝不会告诉任何人！%SPEECH_OFF% | 战斗结束后，你在商队废墟中发现了一群妇女儿童。她们缓步靠近，似乎明白如果逃跑反而会给你们追击的理由。一名将婴儿紧抱在胸前的妇女哀求道：%SPEECH_ON%求求你们，你们已经造成了太多伤害和痛苦。我们的父亲、丈夫、兄弟，都已经被你们杀光了。这还不够吗？放我们走吧。%SPEECH_OFF%%randombrother%吐了口唾沫：%SPEECH_ON%那些孩子看见了我们干的事。他们长大也会记得。至于那些女人，哼，她们肯定会到处说。她们就爱这样。%SPEECH_OFF%他望向你，手指搭在半出鞘的刀上：%SPEECH_ON%你要我们怎么做，长官？%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们收钱就是来干这个的——一个不留。",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-5);
						return "WomenAndChildren2";
					}

				},
				{
					Text = "不管了——放他们走。",
					function getResult()
					{
						this.World.Assets.addMoralReputation(2);
						this.Flags.set("Survivors", this.Flags.get("Survivors") + 3);
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "WomenAndChildren2",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_60.png[/img]{你向%randombrother%点了点头。他大步上前，手起刀落便削掉了一个女人的头颅。血色喷泉汹涌而出，她的孩子们被鲜血糊住了眼睛，甚至没看见接踵而至的刀锋。当你的兄弟们在这群惊惧的平民中砍杀时，惨叫声逐渐平息，最终只剩下零星的呜咽。你的手下仔细检查着成果，直到所有受害者都归于寂静，空气中只余血水滴答。 | 你手一挥下达了命令。%randombrother%瞬间将刀刃捅进一个孩子的面门，把幼小身躯钉回母亲怀抱，随即向上划开也夺走了她的性命。其余人手散开行动，有人略显迟疑，有人却带着近乎虔诚的勤勉继续着屠杀。\n\n当凄厉尖叫充斥空气时，你感觉到有些佣兵纯粹是为了驱散脑中的噪音而疯狂砍杀。暴力吞噬了一切，这场疯狂的狂欢让你无从判断这究竟是人类行为的巅峰还是深渊——所有意义都在事件中迷失，从今到古的所有语言，都找不到词汇来描述此情此景。这仅仅是一桩发生了的事。 | 不幸的是，不能留任何活口。你厉声下令，佣兵们立即执行。一个女人走近，似乎听错了你的话，询问去最近城镇怎么走。%randombrother%用石头砸烂她的脑袋作为回答。受惊的孩子们四散奔逃，让你想起当年猎兔的日子。身手最敏捷的佣兵追了上去，其余人则留下来迅速解决他们的父母。这景象确实惨不忍睹。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "虽然不是什么光彩的差事，但收钱办事罢了。",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CompromisingPapers1",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_60.png[/img]{商队还在燃烧，你的手下在残骸中翻找。%randombrother%拿着一些文件来找你。%SPEECH_ON%长官，这些可能有点意思。%SPEECH_OFF%你展开其中一份读了起来。看来%employer%袭击这支特定车队有着非常、非常不可告人的动机。要是有人发现了这些细节，那可就糟糕了…… | 货车仍在燃烧，你走到一个木箱前一脚踢开。卷轴弹射出来，在风中展开飘散。你抓住一份读了起来。这是关于%employer%领地收入——或者说欠收——的报告。这东西似乎是用来揭露此人财政状况窘境的。如果你愿意，大可用这个来对付他…… | 你在商队废墟中发现了一批文件。其中一份卷轴揭露了关于%employer%的某个秘密，而他很可能知道这东西就在车队里。这肯定是他让你袭击车队的原因……但同样也能用来对付他。你怀疑他根本没料到这东西会落到你手里。毕竟，你只是个愚蠢的佣兵……}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "和其他东西一起烧掉",
					function getResult()
					{
						this.Flags.set("IsCompromisingPapers", false);
						this.Contract.setState("Return");
						return 0;
					}

				},
				{
					Text = "把它们交给雇主以示忠诚",
					function getResult()
					{
						this.Flags.set("IsCompromisingPapers", true);
						this.Contract.setState("Return");
						return 0;
					}

				},
				{
					Text = "得让我们的雇主多花一笔钱买回这些东西。",
					function getResult()
					{
						this.Flags.set("IsCompromisingPapers", true);
						this.Flags.set("IsExtorting", true);
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CompromisingPapers2",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_63.png[/img]{你回来见到%employer%，举起那些文件。他几乎立刻认出了某卷轴上的封印。%SPEECH_ON%这……这是什么东西？%SPEECH_OFF%你正要放下文件解释，这人却猛地扑来想抢夺。你及时后撤让他扑了个空。他直起身子，强作镇定。%SPEECH_ON%好吧佣兵。我明白你的意思了。还想要多少？%SPEECH_OFF%门关上后，你们两人开始密谈。 | %employer%端着两杯酒转身迎接你，但笑容很快凝固。%SPEECH_ON%你手里拿的什么？从哪儿弄来的？%SPEECH_OFF%你将一份罪证文件收好，点头回应。%SPEECH_ON%我想你很清楚我从哪儿弄来的。也很清楚接下来会怎样。现在……咱们谈谈生意如何？%SPEECH_OFF%那人灌下一杯酒，又把另一杯一饮而尽。%SPEECH_ON%行吧。把门关上。%SPEECH_OFF% | 你走进%employer%的房间，将罪证文件甩在他桌上。他瞥了一眼突然大笑。%SPEECH_ON%真是天大的失误！%SPEECH_OFF%他把文件揉成一团塞到桌下。你冷笑着又取出一叠卷轴。%SPEECH_ON%你觉得我是蠢货吗？%SPEECH_OFF%他慌忙掏出刚塞的纸团细看，发现你只放了一页原件，其余都是白纸。你咧嘴笑着摆明条件：%SPEECH_ON%既然知道这些对你多重要，咱们谈谈价钱——好让你拿回‘全部’文件，如何？%SPEECH_OFF%那人郑重地坐下点头，取出私藏的钱袋放在桌上，随后指向门口：%SPEECH_ON%请关门。%SPEECH_OFF% | 你刚回来，%employer%立刻注意到你携带文件上的封印。他原本屋里有几名护卫，却匆忙支开他们去花园赶兔子。关上门后他转向你：%SPEECH_ON%看来是瞒不住了。%SPEECH_OFF%你点头认可。他舔了舔嘴唇也点头回应：%SPEECH_ON%行。这些文件的内容绝不能外传。开个价吧。%SPEECH_OFF%你抬腿架在他桌沿坐下，把文件放在身旁十指交握，咧嘴笑道：%SPEECH_ON%卖价取决于买家愿意出多少——不是吗，贵族老爷？%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "终于拿到报酬了。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() * 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail * 2, "敲诈勒索");
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
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() * 2 + "[/color]克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "CompromisingPapers3",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_63.png[/img]{你回到%employer%那里，他转向你，看起来怒气冲冲。%SPEECH_ON%你知道外面的人都在议论你干的好事吧？%SPEECH_OFF%你微笑着举起那些罪证文件。%SPEECH_ON%难道你宁愿他们议论这个？%SPEECH_OFF%那人倒吸着凉气瘫坐回椅子上。%SPEECH_ON%好吧，你是要勒索我吗？%SPEECH_OFF%你把文件放在他桌上，摆了摆手。%SPEECH_ON%我有这么想过，但我不是见利忘义的人。%SPEECH_OFF% | %employer%招手让你进他房间。%SPEECH_ON%那些乡巴佬都在谈论你。商队里有人逃掉了，他们一边喘气一边迫不及待地到处说自己的遭遇。%SPEECH_OFF%你点头表示同意。%SPEECH_ON%这完全可以理解。%SPEECH_OFF%那人低吼着伸手指责，但你用那些罪证文件直指他面前。他顿时僵住，陷入尴尬的沉默。%SPEECH_ON%我……我明白了……你是想要加钱吗？%SPEECH_OFF%你把文件扔给他。%SPEECH_ON%不。你忘记我的一个失误，我忘记你的一个把柄。很公平，对吧？%SPEECH_OFF%那人急忙把文件塞进外套，点了点头。 | 你你发现%employer%正在打理他的花园。几个卫兵站在不远处，你怀疑那些逗留的农民里有一个其实是伪装的卫兵。%SPEECH_ON%佣兵！见到你真好，除了一点点小事。%SPEECH_OFF%他招手让你靠近，压低声音说。%SPEECH_ON%你让商队的一些人逃掉了。我不记得协议里有这一条。%SPEECH_OFF%你举起那些罪证文件。%SPEECH_ON%我也不记得协议里有这一条。%SPEECH_OFF%%employer%恶狠狠地瞪回来，随即整理表情以免卫兵起疑。%SPEECH_ON%好吧，我收下这些，然后忘记有活口逃了出来的糟心事，行了吧？%SPEECH_OFF%你把文件递了过去。}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "来之不易。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "取得了罪证文件");
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
			ID = "Success1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{你回去向%employer%报告成功的消息。他的欢迎很热情——递过来一袋沉甸甸的克朗。%SPEECH_ON%干得好佣兵。你，呃，在当时有没有看到别的什么？%SPEECH_OFF%这是个奇怪的问题，但你没深究。你告诉他事情的结果正如所见。他点点头，匆匆道谢后就回去忙自己的事了。 | 你回去时%employer%正站在窗边。他喝着一杯葡萄酒，在杯中也在口中来回漱荡。%SPEECH_ON%我的小鸟们告诉我商队被摧毁了。他们唱的小调儿对不对呢？%SPEECH_OFF%你点头确认了这个消息。他递过来一箱克朗，感谢你的服务，然后又回到了窗边。离开前你瞥见他脸上闪过一丝狡黠的笑容。 | 你回去时%employer%正在抚摸一条狗。他的手在毛发中微微发抖。%SPEECH_ON%我想车队已经被摧毁了吧？%SPEECH_OFF%你向他汇报了细节。他点点头，但抚摸的手停了下来。%SPEECH_ON%你有没有碰巧……发现什么有趣的东西？%SPEECH_OFF%你仔细回想，但想不出有什么不寻常的。这人咧嘴一笑，继续抚摸他的狗。%SPEECH_ON%感谢你的服务，佣兵。%SPEECH_OFF% | 你进房间时%employer%正在写字。他匆忙放下羽毛笔站起身来。%SPEECH_ON%那么它被摧毁了？我是说，那个商队。%SPEECH_OFF%你汇报了“服务”的结果。他大笑起来，双手一拍。%SPEECH_ON%太棒了！真是太棒了，佣兵！你根本不知道你今天的工作对我意味着什么。当然，你的报酬，如约奉上……%SPEECH_OFF%他递过来一袋%reward_completion%克朗。钱一分不少，但你不禁纳闷为什么这人会对一件看似普通的事如此兴奋……你是不是错过了什么？ | 你回去时%employer%正在和他的议会成员谈话。他把他们赶了出去。这景象很奇特——看着这些权贵给一个杂牌佣兵让路。你汇报商队被毁的消息时不由得挺直了腰板。%SPEECH_ON%谢谢你，佣兵。这正是我一直等待的消息。当然，还有你的报酬……%SPEECH_OFF%他把一个木箱搬到桌上推过来。箱子重得在桌面上留下了痕迹。%SPEECH_ON%%reward_completion%克朗，我们商量好的。%SPEECH_OFF%你很好奇为什么这个贵族会支开他的议员来接待一个佣兵，但决定不再深想。}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "摧毁了一支商队");
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
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_45.png[/img]{你回来时看到%employer%坐在桌边，胳膊肘支在桌沿，前臂竖起，大拇指几乎按进了额头。他双手猛地落下，开口道：%SPEECH_ON%你居然……让他们活下来了……%SPEECH_OFF%你竖起一根手指辩解：不是所有人都活着。%SPEECH_ON%旧神在上，老子雇你是为了什么？%SPEECH_OFF%他停下来，然后耸耸肩。%SPEECH_ON%行吧，我给你约定报酬的一半。你确实把车队毁了，这点我承认。%SPEECH_OFF% | %employer%把脚翘在桌上迎接你的归来。你注意到他靴子上有血迹。%SPEECH_ON%那么，佣兵，给我解释一下我雇你是来干什么的？%SPEECH_OFF%他伸手做了个“请讲”的动作。你说明自己被雇来摧毁商队且不留活口。这人突然竖起手指：%SPEECH_ON%把最后那半句话重复一遍。%SPEECH_OFF%你照做了。他露出得意的笑容，但随即因你的失败而收敛了笑意。%SPEECH_ON%行了，你没做到我要求的。没关系。你……好歹做到了一部分。商队确实毁了……%SPEECH_OFF%他扔给你一个钱袋。里面只有约定的一半报酬。你觉得有总比没有强。 | 你回来时%employer%正在和护卫说话。他挥手让几个人退下，却让块头最大的那个留在原地。你进门时他死死盯着你。你拖过%employer%的一把椅子，他却让你站着。%SPEECH_ON%我很快就说完了。你没完成我交代的事，佣兵。现在到处都有人在议论，议论你干的好事。既然我之前让你不留一个目击者，为什么现在会有人对你的事情嚼舌呢？有点意思，不是吗？我想这是因为你没把那些目击者全干掉，也就是说你没做到我要求的事。%SPEECH_OFF%他顿了顿，用指节揉着额头。%SPEECH_ON%这样吧，我给你约定报酬的一半。一半归你因为毁了商队，一半归我因为得花钱善后。希望你没意见。%SPEECH_OFF%护卫在门口斜眼盯着。你点头接受了报酬。 | %employer%招手让你进去。他和一个看起来随时准备攥写记录的书记员站在一起。你的雇主抱着胳膊：%SPEECH_ON%到处都有人在议论你干的事……%SPEECH_OFF%他朝书记员示意，但奇怪的是书记员并没有开始记录。%SPEECH_ON%我得花点钱封住他们的嘴，明白吗？所以这意味着你只能拿到约定报酬的一半。%SPEECH_OFF%年长的书记员咧嘴笑了。你注意到他手指上有枚戒指，看起来是新打的。%employer%几乎要破口大骂，但书记员什么都没记录，你把这当作好迹象。你拿了报酬便离开了。 | 你到达时，一群嬉皮笑脸的人正从%employer%的房间离开。他让你随手关门，但一名护卫抢先走了进来。护卫和%employer%交换了眼神并点头示意，随后你关上了门。你的雇主开门见山：%SPEECH_ON%认得刚才出去的那些人吗？他们就是查清你干了好事的主。你知道我得花多少克朗才能封住他们的嘴吗？你知道这些钱是从哪儿出的吗？%SPEECH_OFF%你耸耸肩。他继续说道：%SPEECH_ON%当然是你的报酬。你只能拿一半。明白为什么吗？%SPEECH_OFF%你点点头。生意就是生意。当你转身离开时，%employer%叫住你。%SPEECH_ON%别妄想靠杀掉那些人把另一半报酬拿回去，佣兵！%SPEECH_OFF%该死。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "事态可能更糟……",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() / 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "摧毁商队时遗漏了一些活口");
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
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() / 2 + "[/color]克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "Failure2",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_45.png[/img]{你回来时看到%employer%坐在桌边，胳膊肘支在桌沿，前臂竖起，大拇指几乎按进了额头。他双手猛地落下，开口道：%SPEECH_ON%你居然……让他们活下来了……%SPEECH_OFF%你竖起一根手指辩解：不是所有人都活着。%SPEECH_ON%旧神在上，老子雇你是为了什么？%SPEECH_OFF%他顿了顿，随即勃然大怒：%SPEECH_ON%现在说这些有个屁用？你放跑的人多得让这该死的村子全都在议论纷纷。趁我还没叫护卫收拾你，赶紧滚出我的视线！%SPEECH_OFF% | %employer%把脚翘在桌上迎接你的归来。你注意到他靴子上有血迹。%SPEECH_ON%那么，佣兵，给我解释一下我雇你是来干什么的？%SPEECH_OFF%他伸手做了个“请讲”的动作。你说明自己被雇来摧毁商队且不留活口。这人突然竖起手指：%SPEECH_ON%把最后那半句话重复一遍。%SPEECH_OFF%你照做了。他露出得意的笑容：%SPEECH_ON%很好，你没做到我要求的。所以你还来这里干什么？是要我喊护卫过来，还是你自己识相点滚蛋？因为你我已经没什么好谈的了。%SPEECH_OFF% | 你回来时%employer%正在和护卫说话。他挥手让几个人退下，却让块头最大的那个留在原地。你进门时他死死盯着你。\n\n你拖过%employer%的一把椅子，他却让你站着。%SPEECH_ON%我很快就说完了。你没完成我交代的事，佣兵。现在到处都有人在议论，议论你干的好事。既然我之前让你不留一个目击者，为什么现在会有人对你的事情嚼舌呢？有点意思，不是吗？我印象里，死掉的目击者根本不会开口说话，这让我相信这些目击者还活得好好的。这就更有意思了，因为这可不是我付钱让你干的事。现在，在我让这位护卫拔剑捅穿你之前，你为什么不直接转身滚出我的视线呢？%SPEECH_OFF% | 你到达时，一群嬉皮笑脸的人正从%employer%的房间离开。他让你随手关门，但一名护卫抢先走了进来。护卫和%employer%交换了眼神并点头示意，随后你关上了门。你的雇主开门见山：%SPEECH_ON%认得刚才出去的那些人吗？他们就是查清你干了好事的主。你知道我得花多少克朗才能封住他们的嘴吗？你知道这些钱是从哪儿出的吗？%SPEECH_OFF%你耸耸肩。他继续说道：%SPEECH_ON%当然是你的报酬。为了让这群混蛋闭嘴，我可真是花了笔大价钱。%SPEECH_OFF%你点点头。生意就是生意，而这次你一分也拿不到。当你转身离开时，%employer%叫住你：%SPEECH_ON%别妄想靠杀掉那些人把报酬拿回去，佣兵！%SPEECH_OFF%该死。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "去他的合同！",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "摧毁商队时遗漏了一些活口");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Failure3",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_75.png[/img]{在等候商队时，两名旅人从车队目的地的方向走来。他们详细描述了一辆货车，无疑正是你们奉命猎杀的目标。没必要回去见%employer%了。 | 路上听到的消息暗示，你们要猎杀的那支商队已经溜走并抵达了目的地。战团不必再去见%employer%了。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "去他的合同！",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "没能摧毁商队");
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
			"bribe",
			this.m.Flags.get("Bribe1")
		]);
		_vars.push([
			"bribe2",
			this.m.Flags.get("Bribe2")
		]);
		_vars.push([
			"start",
			this.World.getEntityByID(this.m.Flags.get("InterceptStart")).getName()
		]);
		_vars.push([
			"dest",
			this.World.getEntityByID(this.m.Flags.get("InterceptDest")).getName()
		]);
		_vars.push([
			"swordmaster",
			this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]
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
		if (this.World.FactionManager.isGreaterEvil())
		{
			return false;
		}

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
