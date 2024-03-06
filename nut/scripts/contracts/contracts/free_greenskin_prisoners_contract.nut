this.free_greenskin_prisoners_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		BattlesiteTile = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.free_greenskin_prisoners";
		this.m.Name = "释放囚犯";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.000000;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		if (this.m.BattlesiteTile == null || this.m.BattlesiteTile.IsOccupied)
		{
			local playerTile = this.World.State.getPlayer().getTile();
			this.m.BattlesiteTile = this.getTileToSpawnLocation(playerTile, 6, 12, [
				this.Const.World.TerrainType.Shore,
				this.Const.World.TerrainType.Ocean,
				this.Const.World.TerrainType.Mountains
			], false);
		}

		this.m.Payment.Pool = 1350 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
		local r = this.Math.rand(1, 2);

		if (r == 1)
		{
			this.m.Payment.Completion = 0.750000;
			this.m.Payment.Advance = 0.250000;
		}
		else if (r == 2)
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
					"搜索战场并寻找线索在 %origin% 的 %direction%",
					"释放你找到的任何囚犯"
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
				if (this.Contract.m.BattlesiteTile == null || this.Contract.m.BattlesiteTile.IsOccupied)
				{
					local playerTile = this.World.State.getPlayer().getTile();
					this.Contract.m.BattlesiteTile = this.getTileToSpawnLocation(playerTile, 6, 12, [
						this.Const.World.TerrainType.Shore,
						this.Const.World.TerrainType.Ocean,
						this.Const.World.TerrainType.Mountains
					], false);
				}

				local tile = this.Contract.m.BattlesiteTile;
				tile.clear();
				this.Contract.m.Destination = this.WeakTableRef(this.World.spawnLocation("scripts/entity/world/locations/battlefield_location", tile.Coords));
				this.Contract.m.Destination.onSpawned();
				this.Contract.m.Destination.setFaction(this.Const.Faction.PlayerAnimals);
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.000000);
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 5)
				{
					this.Flags.set("IsSurvivor", true);
				}
				else if (r <= 10)
				{
					this.Flags.set("IsLuckyFind", true);
				}
				else if (r <= 15)
				{
					this.Flags.set("IsAccident", true);
				}
				else if (r <= 35)
				{
					if (this.Contract.getDifficultyMult() > 0.850000)
					{
						this.Flags.set("IsScouts", true);
					}
				}

				r = this.Math.rand(1, 100);

				if (r <= 50)
				{
					this.Flags.set("IsEnemyCamp", true);

					if (this.Math.rand(1, 100) <= 20 && this.Contract.getDifficultyMult() < 1.150000)
					{
						this.Flags.set("IsEmptyCamp", true);
					}
				}
				else
				{
					this.Flags.set("IsEnemyParty", true);
				}

				if (this.Math.rand(1, 100) <= 20)
				{
					this.Flags.set("IsAmbush", true);
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (!this.TempFlags.get("IsBattlefieldReached") && this.Contract.isPlayerAt(this.Contract.m.Destination))
				{
					this.TempFlags.set("IsBattlefieldReached", true);
					this.Contract.setScreen("Battlesite1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsScoutsDefeated"))
				{
					this.Flags.set("IsScoutsDefeated", false);
					this.Contract.setScreen("Battlesite2");
					this.World.Contracts.showActiveContract();
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Scouts")
				{
					this.World.Contracts.removeContract(this.Contract);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Scouts")
				{
					this.Flags.set("IsScoutsDefeated", true);
				}
			}

		});
		this.m.States.push({
			ID = "Pursuit",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"沿着绿皮的足迹远离战场",
					"释放你找到的任何囚犯"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;

					if (this.Flags.get("IsEmptyCamp"))
					{
						this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
					}
				}
			}

			function update()
			{
				if ((this.Contract.m.Destination == null || this.Contract.m.Destination.isNull()) && !this.Flags.get("IsEmptyCamp"))
				{
					this.Contract.setScreen("Battlesite3");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsAmbush") && !this.Flags.get("IsAmbushTriggered") && !this.TempFlags.get("IsAmbushTriggered") && this.Contract.m.Destination.isHiddenToPlayer() && this.Contract.getDistanceToNearestSettlement() >= 5 && this.Math.rand(1, 1000) <= 2)
				{
					this.TempFlags.set("IsAmbushTriggered", true);
					this.Contract.setScreen("Ambush");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsAmbushDefeated"))
				{
					this.Contract.setScreen("AmbushFailed");
					this.World.Contracts.showActiveContract();
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Ambush")
				{
					this.Flags.set("IsAmbushTriggered", true);
					this.World.Contracts.removeContract(this.Contract);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Ambush")
				{
					this.Flags.set("IsAmbushTriggered", true);
					this.Flags.set("IsAmbushDefeated", true);
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				this.Contract.setScreen("EmptyCamp");
				this.World.Contracts.showActiveContract();
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"带着获释的囚犯返回 " + this.Contract.m.Home.getName()
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(null);
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{当你找到%employer%时，他正在倾听一个用嘶哑的声音绝望地说话的农民。显然，绿皮兽袭击了附近的一个村庄，并带走了囚犯。贵族立刻请求你的服务：用一定的价格把人们找回来。 | %employer%在你进入他的房间时正在看一些地图。几个指挥官站在他的身边，拿着棍子指着地图，标记着地形。当他看到你时，贵族立刻召唤你靠近。%SPEECH_ON%我有一个问题，雇佣军。绿皮兽一直在袭击这片土地，我相信你已经注意到了，但是最近我们得到了报告，说他们带走了一些囚犯。我们不确定他们去了哪里，但我们知道他们最后被看到的地方。如果你去那里，我认为你可以找到一些线索，知道他们现在的位置。我希望你对这个任务感兴趣，雇佣兵。%SPEECH_OFF% | 你看到%employer%和一个农民在交谈。几个守卫按住农民的手臂，显然是把他拖到贵族面前。你以为是犯了什么罪，但%employer%只是喜欢和底层人士这样交谈。百姓的消息说绿皮兽袭击了当地区域，带走了一些囚犯。他们留下了足够的线索，如果你愿意接下这个任务，应该不难找到他们。} | %employer% 沉没在他的椅子里。%SPEECH_ON%我的人民开始失去信心。听说那些绿皮兽不仅袭击村庄，还绑架人质，这恐怕更糟糕！但或许如果有人能把那些人带回来，我的人民会重新开始信任我。你这个雇佣军，你会帮忙找到那些可怜的失踪者吗？当然，有适当的报酬。%SPEECH_OFF% | 发现%employer%正在与他的指挥官之一交谈。%SPEECH_ON%我们会把他们送回来，不用担心。%SPEECH_OFF%看到你，贵族迅速告诉你，有一场大规模的绿皮兽战斗，据报有人被俘虏。指挥官走上前，拇指别在腰带上，一把大刀在腰间发出叮当声。%SPEECH_ON%雇佣军，如果你能把那些人带回来，这将是一项巨大的服务。%SPEECH_OFF% | %employer%正在与他的指挥官争吵。%SPEECH_ON%听着，我们负担不起再派出一个队伍。%SPEECH_OFF%指挥官指着你。%SPEECH_ON%那他呢？%SPEECH_OFF%你很快就被告知了情况：有一场大规模的绿皮兽战斗，离这里%direction%，有人被俘虏。%employer%没有足够的人手去寻找他们，需要一个灵活的人来完成工作。 | 你看到%employer%正在看着一张地图，他指着一个地方。%SPEECH_ON%离这里%direction%有一个与一些绿皮战斗的大战。我们有理由相信他们抓住了些囚犯，而我有理由相信你能把他们救回来。%SPEECH_OFF% | 一名士兵拄着拐杖蹒跚地走向你。他的腿伤滴滴答答地往地板上滴血。%SPEECH_ON%嘿，你是%companyname%的吧？ %employer%让我找你。%SPEECH_OFF%他解释说他的部队和绿皮开了一次战役，在%direction%的地方，他们可能劫持了一群囚犯。你问他为什么不治疗。%SPEECH_ON%我，我从战场上逃了。这是我的惩罚。无论如何都没事了，药剂师说我还有一个月就要死了。看见这个吗？很丑不是吗？%SPEECH_OFF%他小心翼翼地抬起了腿，绿色的脓疱在绷带周围涌出。真的很丑。 | %employer% 正在试图从他的狗那里夺回一瓶墨水。%SPEECH_ON%你吞下去就死定了，你这只蠢材，为什么你就不能明白呢？%SPEECH_OFF%贵族看到了你，挺直了身子。%SPEECH_ON%佣兵！在这真是困难的时刻见到你真是太好了。这附近有一场和兽人的战斗 %direction%，我的指挥官报告说野蛮人带走了俘虏！我需要一个像你这样的人帮忙营救这些人。%SPEECH_OFF%当你在思考的时候，那只狗吞下了墨水瓶，立即开始咳嗽。它呕出黑色的呕吐物，一只鹅毛笔轻轻地滑过呕吐物。%employer% 愕然举起双手。%SPEECH_ON% 我花了一个小时找那个！那是我最喜欢的墨水瓶，该死的狗。%SPEECH_OFF% | 你发现 %employer% 正在展开一卷卷轴，一个沉思的文士看着他的肩膀。贵族砰的一声把纸扔在桌子上，然后挥手让你进来。%SPEECH_ON%这里附近有一场大规模的战斗，和兽人 %direction% 的战斗。那些野蛮人带走了俘虏！你能相信吗？%SPEECH_OFF%在你来得及回答之前，%employer% 继续说道。%SPEECH_ON% 看，我没有闲人。但如果这些兽人真的带走了俘虏，那么也许像你这样能力出众的人可以帮助营救他们？%SPEECH_OFF% | 你在门外遇到了一个名叫队长的%employer%的指挥官。他递给你一张写有指示的卷轴。根据报告，一场大战在这里的%direction%结束后绿皮族拿走了一些俘虏。%employer%想把这些人救回来，但是没有多余的士兵可以派去。队长叉起手臂。%SPEECH_ON%如果你想商量，我的大人已经授权我代表他来处理。%SPEECH_OFF% | 你在%employer%的房间外听到了一阵猫叫声，%employer%正在房间里踢一只猫并试图用脚追它。这只猫紧紧地抱住窗帘杆的顶部，死死抓住不肯放手。贵族仰头看着它。%SPEECH_ON%我无法用言语表达我有多恨这该死的东西。%SPEECH_OFF%他转身看到了你。%SPEECH_ON%雇佣兵！你真是我的救星！我需要你做点事情，跟那该死的家伙没关系。我的士兵和绿皮族开战了，在这里的%direction%。报告说，野蛮人抓了一些俘虏，这意味着他们可能被带回来。我认为你，先生，是这项工作的人选。%SPEECH_OFF%那只猫嗷嗷叫着，蹲在它的懒汉上。%employer%转身指着它。%SPEECH_ON%我要你下来！我要你下来！%SPEECH_OFF% | 有一群指挥官站在%employer%周围。在他们面前有一个男人的头。%employer%看着你。%SPEECH_ON%士兵们的一支队伍在这里以%direction%的绿皮兽人接触了。他们失败了，如果你还没有看出来的话。他们还抓了一些俘虏，如果这是真的，我非常希望把那些士兵救回来！我认为你是最适合这个工作的雇佣兵，那么你怎么说？%SPEECH_OFF% | 一个瘦小的孩子站在%employer%身边，画出一张地图，并解释他亲眼目睹的一连串事件：士兵们的一支队伍与%direction%这里的绿皮兽人发生冲突并失败了。野蛮人随后带着俘虏逃走了。%employer%转向你。%SPEECH_ON%好吧，如果这个瘦小的农民所说的是真的，那么我们需要把这些人救回来。雇佣兵，你有兴趣救出我的士兵吗？%SPEECH_OFF% | 你发现%employer%正在和一个哭泣的指挥官交谈。%SPEECH_ON%所以，让我弄清楚，离这里%direction%你遇到了一群绿皮兽，迷失了，逃跑了，看着你的一些士兵被俘虏了？%SPEECH_OFF%指挥官点点头。%employer%向几个卫兵挥了挥手。%SPEECH_ON%这些堕落的懦夫在这里找不到任何奖励，拖走他！而你，佣兵！我需要一个更坚强的人去救回那些俘虏！%SPEECH_OFF%",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{我相信你会为此付出很多。 | 我们来谈谈价钱。 | 如果报酬合适，一切都可以做。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{这不值得。 | 我们还有别的地方要去。}",
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
			ID = "Battlesite1",
			Title = "在战场上…",
			Text = "[img]gfx/ui/events/event_22.png[/img]{你甚至在闻到腥臭味之前就听到了嗡嗡之声。一群昆虫侵袭了一块淤秽的土地，这里曾是绿皮兽人与人类激战的地方。人们拼命想赢，但结果都是失败。你在苍蝇的迷雾中前进，命令%companyname%寻找生还者或线索。 | 尸横遍野，马奄奄一息，一匹野马拼命奔逃。到处都是内脏被掏空的尸块，每一步踏下都是血泊鲜红。%randombrother%捂着鼻子，递上一块布。%SPEECH_ON%我们会追寻线索的，长官，但这肯定不会太顺利。%SPEECH_OFF% | 烟、血和被压成泥的土地。你走遍整个战场，命令雇佣兵四散寻找线索。%randombrother%盯着一个被挑在破叉上的绿皮兽人，用生锈的刀刺穿杀它的人的头骨，他摇了摇头。%SPEECH_ON%对啊，“线索”，似乎我们并不需要再去想这里到底发生了什么吧。%SPEECH_OFF% 你提醒他，绿皮兽人带走了俘虏，%companyname%要去解救他们。 | %randombrother%看着战场。%SPEECH_ON%你确定还有幸存者需要押送吗？%SPEECH_OFF%事实上，这里似乎有一个呈球状的巨大尸体群，浸染着鲜血，让这片土地变得模糊、陌生。尸体歪曲僵硬，兽人的嘴巴张开着发出永恒的咆哮，男女中分离。埋在尸体中的马四蹄朝天，像是扭曲的野兽图腾。你不确定是否有俘虏被带走，但你命令%companyname%开始搜寻。 | 如果有人要从这里抓捕俘虏，就像将恶魔从地狱拖出来一样。看着缠绕着肢体，露出骨头的大量尸体，你根本无法想象谁会活下来。就好像有一大群人和野兽站在一起，然后一个更大的摧毁性巨石就撞到了他们身上，留下的只是你在这里发现的零落尸体。很少能完整保存下来。%randombrother%拿起一块布盖住脸，摆手赶走蚊虫。%SPEECH_ON%好吧，我想我们该开始寻找痕迹了。不能，嗯，保证一定有所发现。%SPEECH_OFF% | 在这里寻找足迹就像在一堆肢解的尸体中寻找针一样困难。%randombrother%双手叉腰，惊讶地笑了起来。%SPEECH_ON%竟然还有人在这场屠杀中活了下来，还抓住了囚犯？%SPEECH_OFF%你耸了耸肩，命令%companyname%开始寻找线索。 | 你感觉到这个地方曾经是情侣和儿童嬉戏的宁静地点。现在，大地已经变成了一片泥泞，死者遍布其中，与他们在混乱的最后创造的足迹一样多。%randombrother%擦了擦额头。%SPEECH_ON%这真是糟糕透了。好吧，我想我们应该四处寻找，看看能否找到任何线索或足迹。%SPEECH_OFF% | 你来到了战场。%randombrother%向后仰了仰，看着眼前的恐怖场景，放声大笑。%SPEECH_ON%我的天啊，这算是什么？你开玩笑吧！%SPEECH_OFF%先是一场战斗，有人、有兽。绝望的激烈斗争，死亡带走了不少士兵。然后是暴雨。践踏过的大地变成了泥泞。血腥的领域成为了一片血腥的战场。现在，你们这些雇佣军，这些目击者，穿过波涛汹涌的深红之中，感受着一种彻底毁灭的残留物。你摇了摇头，开始下令指挥手下。%SPEECH_ON%我们来这里找线索。看看有没有足迹通向别处。无论什么幸存者都会带走囚犯。%SPEECH_OFF% | 你看到的不是尸体，而是碎片。这些碎片暗示着，曾经有一些人和野兽在这里相遇，他们的凶残破坏了所有战士曾经的完整身躯的概念。%randombrother%用一根木棍抬起了一只靴子，结果一只脚露了出来。他摇了摇头。%SPEECH_ON%好吧，我们可以开始查找痕迹了，但谁要是在这里幸存下来，更别说把俘虏带离此地了，我会非常吃惊的。%SPEECH_OFF% | %randombrother%看着战场。%SPEECH_ON%该死。%SPEECH_OFF%你们发现了一场激战的残留物，一堆破碎的绿皮族和人混在一起，构成了一场扭曲、血腥的仪式。马匹站在一旁，用矛盾、耳朵耸立的好奇心探视着这一幕。当你的士兵开始搜查现场以寻找线索时，它们四散奔逃。你下令：%SPEECH_ON%记住，绿皮族俘虏了人！找寻痕迹，士兵们。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "到处搜索！",
					function getResult()
					{
						if (this.Flags.get("IsAccident"))
						{
							return "Accident";
						}
						else if (this.Flags.get("IsLuckyFind"))
						{
							return "LuckyFind";
						}
						else if (this.Flags.get("IsSurvivor") && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
						{
							return "Survivor";
						}
						else if (this.Flags.get("IsScouts"))
						{
							return "Scouts";
						}
						else
						{
							return "Battlesite2";
						}
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Battlesite2",
			Title = "在战场上…",
			Text = "[img]gfx/ui/events/event_22.png[/img]{%randombrother%发现了一串从战场上延伸出去的足迹。%companyname%应该跟着它们走！ | 发现一连串足迹从战场延伸出去。这里有比兽人更小的人类足迹。跟随这些足迹很可能能找到囚犯。 | %randombrother%蹲下来，向你示意。他指着地面上的一些印痕。%SPEECH_ON%这是什么，长官？%SPEECH_OFF%你看到了更小的靴子印痕和更大的脚印。旁边还有一些点缀的小印记。你一一点评着每一个。%SPEECH_ON%人类，兽人，地精。如果我们跟着这些足迹，我们很可能会找到我们的囚犯。%SPEECH_OFF% | 你偶然或者说不偶然地发现了一串大脚印。从那可爱的脚趾和无靴外形来看，这是兽人的足迹。然而，在它们旁边，你立刻认出了其他足迹。%randombrother%过来了。%SPEECH_ON%看起来那是我们要找的对象，长官。跟着这些足迹，我们肯定能找到囚犯。%SPEECH_OFF% | 你蹲下来看着一连串足迹。人类，兽人，地精。全部都是新鲜的，全部都通向战场之外。如果跟随它们，很可能会找到你想要的囚犯。 | 一群兽人和地精的脚印从战场上延伸出去。沿着它们两侧留下了一系列非常新鲜的人类脚印。%randombrother%吐了口唾沫并点了点头。%SPEECH_ON%那就是我们要找的东西。如果我们跟着这些人印，我们也许能找到那些囚犯。虽然他们都像我的奶奶一样死了，而且她死得很惨，被滚石砸死了，但我想还是值得一看。%SPEECH_OFF% | %randombrother% 宣布了一个最相关的发现: 一系列人和兽的脚印，从战场上延伸而出。如果 %companyname% 跟踪它们，那么找到囚犯就不会太远了。 | 一个人拿着草叉走过来，在他踩着草叉的身体支撑着上坡的土地。他喊你过去，你慢慢地走过去。当你靠近时，那个人咧嘴一笑。%SPEECH_ON%你是来找囚犯的，不是吗？%SPEECH_OFF%他夹在牙齿间咀嚼着稻草，指着前方。%SPEECH_ON%那边的泥泞小路上有脚印。我不知道野蛮人为什么会留下他们来去的痕迹，但我想那就是他们被称为野蛮人的原因，对吧？%SPEECH_OFF%你感谢农民的帮助，正如他说的那样，很快就发现了从战场上延伸出去的足迹。 %companyname% 应该跟着这些足迹找到那些囚犯。 | 在搜索战场时，%randombrother%被一个孩子吓到了，他从一个尸体中跳了出来，双手伸展在头两侧，像一棵病态的植物一样活了过来。佣兵拔出了他的武器。%SPEECH_ON%你这个小混蛋要付出代价！%SPEECH_OFF%你叫停了佣兵，并询问孩子他在做什么。小家伙耸了耸肩。%SPEECH_ON%在玩啊。话说，你不想知道那些绿皮族人去哪了吗？%SPEECH_OFF%当然你想知道。孩子带你去了一连串的足迹，人类、兽人和地 goblin 都有。所有的足迹都很新鲜。你叫孩子回家，这里不安全。他翻了翻白眼。%SPEECH_ON%{哦，谢谢你，先生。 | 好啊，先生，不用谢我。我以为我是来这里找乐子的，但我想我真正的目的是等你出现。 | 这太棒了，我以为我已经离开了我妈妈，但她竟然出现在这里了，该死。}%SPEECH_OFF% | 当你正在丧失寻找任何线索的希望时，一位年轻女子拿着篮子经过。她从死者身上捡起布条，并一路拧出其中的血液。你问她是否看到了什么，她点了点头。%SPEECH_ON%当然见过了，我有眼睛呀。不过我还有点脑子，在这附近，大家都在说，您要找那些绿色混蛋带走的囚犯吧。%SPEECH_OFF%你点点头，问她去了哪里，她指了指山下。%SPEECH_ON%你看到那条小路了吗？上面有许多脚印，那些野蛮人留下了大把线索。我个人是不会跟着去的，但您看上去很强壮。说起来，您这是用什么布做的？%SPEECH_OFF%她指着 %companyname% 的旗帜问。你耸耸肩。她也耸了耸肩。%SPEECH_ON%这布挺好看的，如果您在这儿看到类似的布料，可以告诉我哦，我正要做我的婚纱呢。%SPEECH_OFF% | 一名男子踏着小路大步走来，像一个士兵一样摆动着腿，他的臀部挂着一串死鱼。他看到你停下来。%SPEECH_ON%让我猜猜，你在找那些囚犯去哪了，对吧？%SPEECH_OFF% 你点点头，询问他是否见过他们去哪了。他摇了摇头，但指着自己的脚。%SPEECH_ON%不，先生，没有确切的线索。但是这里有足迹。你看，人和绿皮兽的脚印。这可能与他们有关，不是吗？%SPEECH_OFF% 是的。你下令%companyname%准备出发。 | 战场上没有线索，但区域外面确实有：你发现了一系列错落有致的足迹，上面有人和绿皮兽的印记。毫无疑问，这将会通向囚犯，或者至少是那些抓他们的人。 | %randombrother%叫你过去。在他的脚下，有一系列大脚印和几个越来越小的脚印。他们结合成的阵型从战场上延伸出来。佣兵朝你看了一眼。%SPEECH_ON%这些就是囚犯、兽人，还有跟在他们身后的小家伙，地精。%SPEECH_OFF% 你点点头，大声喊出%companyname%准备跟踪足迹。 | %randombrother% 发现了一些足迹，就在战场外面。你过来检查，他依次指向这些足迹的大小。%SPEECH_ON%我认为这些是兽人的，那些是地精的，那些是我们正在寻找的俘虏的。%SPEECH_OFF% 你同意他的评估。如果 %company% 跟着这些足迹，他们很可能会找到俘虏和他们的绑架者。",
			Image = "",
			List = [],
			Options = [
				{
					Text = "走吧!",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						local playerTile = this.World.State.getPlayer().getTile();
						local nearest_goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(playerTile);
						local nearest_orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(playerTile);
						local camp;

						if (nearest_goblins.getTile().getDistanceTo(playerTile) <= nearest_orcs.getTile().getDistanceTo(playerTile))
						{
							camp = nearest_goblins;
						}
						else
						{
							camp = nearest_orcs;
						}

						if (this.Flags.get("IsEnemyParty"))
						{
							local tile = this.Contract.getTileToSpawnLocation(playerTile, 10, 15);
							local party = this.World.FactionManager.getFaction(camp.getFaction()).spawnEntity(tile, "大群绿皮", false, this.Const.World.Spawn.GreenskinHorde, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
							party.getSprite("banner").setBrush(camp.getBanner());
							party.setDescription("一大群绿皮向战场进军。");
							party.setFootprintType(this.Const.World.FootprintsType.Orcs);
							this.Contract.m.UnitsSpawned.push(party);
							party.getLoot().ArmorParts = this.Math.rand(0, 25);
							party.getLoot().Ammo = this.Math.rand(0, 10);
							party.addToInventory("supplies/strange_meat_item");
							this.Contract.m.Destination = this.WeakTableRef(party);
							party.setAttackableByAI(false);
							party.setFootprintSizeOverride(0.750000);
							local c = party.getController();
							c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
							local wait = this.new("scripts/ai/world/orders/wait_order");
							wait.setTime(15.000000);
							c.addOrder(wait);
							local roam = this.new("scripts/ai/world/orders/roam_order");
							roam.setPivot(camp);
							roam.setMinRange(5);
							roam.setMaxRange(10);
							roam.setAllTerrainAvailable();
							roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
							roam.setTerrain(this.Const.World.TerrainType.Shore, false);
							roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
							c.addOrder(roam);
						}
						else
						{
							this.Contract.m.Destination = this.WeakTableRef(camp);
							camp.clearTroops();

							if (this.Flags.get("IsEmptyCamp"))
							{
								camp.setResources(0);
								this.Contract.m.Destination.setLootScaleBasedOnResources(0);
							}
							else
							{
								this.Contract.m.Destination.setLootScaleBasedOnResources(120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());

								if (this.Contract.getDifficultyMult() <= 1.150000 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
								{
									this.Contract.m.Destination.getLoot().clear();
								}

								camp.setResources(this.Math.min(camp.getResources(), 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
								this.Contract.addUnitsToEntity(camp, this.Const.World.Spawn.GreenskinHorde, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
							}
						}

						this.Const.World.Common.addFootprintsFromTo(playerTile, this.Contract.m.Destination.getTile(), this.Const.OrcFootprints, this.Const.World.FootprintsType.Orcs, 0.750000, 10.000000);
						this.Contract.setState("Pursuit");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Battlesite3",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_53.png[/img]{战胜了绿皮族，你走进他们的营地，发现囚犯被关在笼子里并被蒙住了眼睛。你命令雇佣兵开始解救他们。大多数囚犯都认为自己已经死了，他们激动地哭泣着感谢你的救援。这就是平常的工作了。 | 绿皮族被击败了，你迅速走进他们的营地。你发现被囚禁的人在一个帐篷里，挤在一起，没有衣服。被释放的人几乎说不出话，但他们的眼睛告诉了你他们经历了怎样的恐怖。%randombrother%去拿一些毯子来盖住他们，然后回去和你的雇主%employer%一起回归。 | 绿皮族已经被解决，现在你和你的人开始搜寻他们遗弃的营地。你听到一个帐篷里有人尖叫。%randombrother%揭开门帘，看到一个地精在一群挤在一起的裸体男人面前挥舞着热铁。这个雇佣军在一次攻击中便猛砍了那个地精的头，甚至还没有反应。囚犯们感谢你的救援。你的雇主%employer%应该很高兴至少有一些人能平安回家。} | 绿皮兽人被击败了，你和%companyname%战团冲进了他们的营地。在那里，你发现一个地精正在戳弄一名死于酷刑的男子。%randombrother%抓住了那个毫不知情的地精，将一把刀子插入了它的后脑。你跟随着血迹进入了一个附近的帐篷，发现一群被蒙着眼睛的男人挤在一起。他们听到你的声音就后退，但你很快就表明你来这里是来帮助他们的。这些可怜的灵魂经历了许多。把他们送回给你们的雇主%employer%和他们的家人应该会有很好的恢复效果。 | 任何一个绿皮兽人打赢这场战斗的念头都已经被埋葬了：那些野蛮人已经完全死亡了。\n\n您命令士兵开始搜索他们的营地，以尝试找到囚犯。不久，%randombrother%便在一顶帐篷下发现了囚犯。他们被殴打和拷问，但还活着。一些人说了谢谢，大多数人则向古老的神灵表示感谢。可恶的神明再次抢走了你的风头。无论如何，你的雇主%employer%将很满意。 | %company=战团%很容易就击败了绿皮兽人并迅速冲进了他们的废弃营地。那里的恐惧超出了想象。有人被穿着肉串扔在地上，还有人被用巨大的桩子挑在空中。幸运的是，在所有这些黑暗中仍有一点光明：您正在寻找的囚犯已被找到。他们被严重殴打，但还活着。 | 绿皮兽人已经被打败。您冒险进入他们的营地，发现一些新鲜血迹的恐怖。人们被剥皮后挂在扭曲的荆棘和树枝架子上。灰色的身体被剖开，他们消瘦而扭曲的脸依然见证了最丑陋的被毁灭过程。更多的人被发现被捆绑在浅覆盖着泡沫的水中，头朝下，重石放在他们的背上，以至于他们无法呼吸而沉入水底。\n\n不仅你在担心是否有生还者，你内心深处甚至希望没有任何一个幸存者。这种恐怖不应该被延续下去。然而，%randombrother% 招手让你到帐篷里。里面，几个被剥光衣服的囚犯缩在一起，害怕地躲避着你的存在。你命令 %companyname% 帮助这些人穿上衣服，喂饱喝足，为送回你们的雇主 %employer% 做好准备。 | %companyname% 相对轻松地打败了绿皮兽人，钻进了他们的营地。那里有人类被制成神圣图腾，由闪耀的骨头构成的巨型方尖碑，以及倾斜的头骨山。%randombrother% 叫你到一个山羊皮帐篷里。你匆忙赶到，发现那里有几个囚犯，每个人都被放在一个由紧密折叠的金属刺构成的笼子里。每个人都被小心地释放出来，每个人都讲述了他们所经历的恐怖。你向这些人保证他们会被送回家中。 | 在打败绿皮兽人后，你迅速冲进了他们的营地，寻找囚犯。他们被锁在一条长长的黑色链条上。一个体弱多病、眼睛斜视、手弱脚软的兽人正试图劫持这些人。%randombrother%冲了过去，用棍子猛击那只兽人的脑袋。它倒在地上，翻了个身，背部瘤状。畸形的生物发出了学识不足的怒吼，一种比野蛮兽人语言更为变态的语言。%randombrother% 犹豫了一会儿，只有那兽人的双眼见证了一个它从未理解的世界，然后，他咬紧牙关砸碎了那生物的头。\n\n你释放了囚犯并得知他们差点被本部落的白痴抓走。无论如何，他们现在安全了，%employer%会非常高兴他们回来了！ | 绿皮族已经被打败，囚犯们从野蛮人的营地被迅速解救出来。每个囚犯都有自己的恐怖故事，即使是那些沉默不语的人也是如此。你的雇主 %employer% 一定会很高兴。 | 你的雇主 %employer% 可能没有相信这会发生，但是在击败绿皮族并进入他们的营地后，你成功解救了囚犯！他们的健康状况并不是很好，但看到%companyname%，而不是一个拿着火炬或行刑斧的兽人，无疑提高了他们的士气。 | 在击败绿皮族后，%companyname% 快速赶到野蛮人的营地。在那里，你发现囚犯被绳索拴着，绑在一个逼熊柱上。一个死掉的熊和几个被可怕的撕咬虐待得面目全非的人躺在泥中。幸存者们显然是用自己的双手杀死了那只熊。应该尽快将他们带回%townname%交给你的雇主。 | %companyname%打败了绿皮族，并赶到野蛮人的营地寻找囚犯。你不确定这些士兵是否适合再次参战，但希望你的雇主 %employer% 无论如何都会好好照顾他们。",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们已经得到了我们想要的东西。是时候返回%townname%了！",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Scouts",
			Title = "在战场上…",
			Text = "[img]gfx/ui/events/event_49.png[/img]{在搜索线索时踩着尸体四处走动，突然被一群绿皮兽人袭击了！他们可能是为了回来搜刮战场。你迅速命令士兵进入阵型，野蛮人也这么做。 | 一支绿皮小分队意图搜刮战场，但却偶然发现了%companyname%。为战争做好准备! | 在搜寻线索时，一小群绿皮兽人走进了%companyname%，他们可能只是为了搜刮财物，但现在你将把他们加入尸体的行列！ | %companyname%正在寻找线索，当一个寻宝队伍返回战场时！ | 你翻了一个身子，在那里一只地精盯着你。你试图把身子翻过来，但它却吼了一声抓住了你的脚。他还没有死！仔细一看，你会看到瞪大眼睛的兽人盗匪盯着你。地精尖叫着撤退，你也迅速后退，下令%companyname%进入阵型。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "Scouts";
						p.Music = this.Const.Music.GoblinsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						local nearest_goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(tile);
						local nearest_orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(tile);
						local camp;

						if (nearest_goblins.getTile().getDistanceTo(tile) <= nearest_orcs.getTile().getDistanceTo(tile))
						{
							camp = nearest_goblins;
						}
						else
						{
							camp = nearest_orcs;
						}

						p.EnemyBanners.push(camp.getBanner());
						p.Entities = [];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.GreenskinHorde, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivor",
			Title = "在战场上…",
			Text = "[img]gfx/ui/events/event_22.png[/img]{%randombrother%正在搜寻尸体，突然他往后一跳。%SPEECH_ON%长官！我们在这发现了一个活人！%SPEECH_OFF%你赶紧跑过去，看到一个男人从一堆残肢中爬了出来。他颤巍巍地站了起来，一张浸满鲜血的脸抵抗着光线。这个男人说他曾经参加战斗，而且他有意愿结束这场战争。显然，他愿意免费加入%companyname%战团！ | 正在搜索战场残留物的时候，你突然听到一个人在尸体下面尖叫。%randombrother%开始拨开尸体，直到你看到一个男人的脸冲着你咧嘴一笑。%SPEECH_ON%曾几何时，我以为我会死在这里。%SPEECH_OFF%你问他是否参加过这场战斗，他回答参加过。他伸出一只手，你把他从尸堆中拉了出来。他除去身上的血迹，注意到了%companyname%的旗帜，问你是否还有位置容纳他。%SPEECH_ON%我有一些未完成的事情，我相信你会理解的。%SPEECH_OFF% | 你曾经误以为这里只有死人：%randombrother%在尸体堆下面发现了一个幸存者。你前去见他，他站在被杀死的人的尸体上摇摇欲坠。他眯起眼睛，试图确定自己的位置。%SPEECH_ON%啊，我认得那个纹章。你们是%companyname%。那么，先生们，我在这里没有其他事可以做了，而我从来不太喜欢收拾麻烦。我可以加入你们吗？%SPEECH_OFF% | 一个幸存者从一个兽人战士腋窝里探出头来。他喘着气，%randombrother%和你帮他拖了出来。%randombrother%给了他一杯水，你问是否有其他幸存者。他耸了耸肩。%SPEECH_ON%他们有一段时间在尖叫，但现在他们不叫了。说起来，你们是%companyname%吗？%SPEECH_OFF%这个人擦了擦嘴，指着战团旗帜点了点头。你也点了点头。他又喝了一口。%SPEECH_ON%好吧，雇佣军，对我来说，这里没有任何东西了。我希望问一下，也许可以加入你们的战团吗？%SPEECH_OFF% | 你们发现了一个幸存者！一个男人从堆积的尸体中爬出来，就像一条蠕虫从一个腐烂的苹果篮子里钻出来一样。他擦拭着脸上的血和灰色污渍，笑了起来。%SPEECH_ON%我一直呆在下面想着绿皮族会回来，但看到你们我真是眼前一亮啊，太好了！%SPEECH_OFF%当 %randombrother% 递给他一杯水喝的时候，你问他是否还有其他幸存者。他点了点头。%SPEECH_ON%是啊，他们被俘虏了，老天爷知道他们到底怎么样了。说起来，如果那是%companyname%的标记，我能加入这个队伍吗？你们肯定已经注意到了，这里对我来说没什么意义。%SPEECH_OFF% | 一个人从死尸中站起来，仿佛他一直在等你。 %randombrother% 吓得后退，拔出武器。那个幸存者友好地挥手。%SPEECH_ON%我必须承认，我没有料到你们会来。我本以为兽人会是回来掠夺这里剩下的东西的。喏，你们那是 %companyname% 的旗帜吧？%SPEECH_OFF%你告诉他是。他鼓掌走过来，在头骨和碎肢的间隙中蹒跚，将脚滑进充满血液的泥坑。%SPEECH_ON%真是走运啊！我正需要一套新的装备，如果不麻烦的话，我想加入你们战团！%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "欢迎加入 %companyname%！",
					function getResult()
					{
						this.World.getPlayerRoster().add(this.Contract.m.Dude);
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude.onHired();
						this.Contract.m.Dude = null;
						return "Battlesite2";
					}

				},
				{
					Text = "这里无事发生，赶快离开。",
					function getResult()
					{
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude = null;
						return "Battlesite2";
					}

				}
			],
			function start()
			{
				local roster = this.World.getTemporaryRoster();
				this.Contract.m.Dude = roster.create("scripts/entity/tactical/player");
				this.Contract.m.Dude.setStartValuesEx(this.Const.CharacterVeteranBackgrounds);
				this.Contract.m.Dude.setHitpointsPct(0.600000);

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).setArmor(this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).getArmor() * 0.330000);
				}

				if (this.Contract.m.Dude.getTitle() == "")
				{
					this.Contract.m.Dude.setTitle("幸存者");
				}

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Accident",
			Title = "在战场上…",
			Text = "[img]gfx/ui/events/event_22.png[/img]{穿越战场不是最安全的事情，%hurtbro% 受伤了。 | %hurtbro% 滑倒了并摔在了一堆武器上。自然，他有些受伤了。 | 不幸的是，%hurtbro% 在血泊中滑倒并摔倒在一个兽人战士张开的嘴里。他受了一些伤。 | 战斗结束后，战场仍然很危险： %hurtbro% 滑倒了并跌倒了。只是受了点轻伤，他会没事的。 | 你知道其中一个白痴最终会滑倒：%hurtbro% 把脚放在一个盾牌上，盾牌很快就滑下了一堆尸体。他滑到了一堆武器上，为此遭受了明显的后果。 | %hurtbro% 大喊。%SPEECH_ON% 嘿，看这个！%SPEECH_OFF%他跳到盾牌上，开始在一堆尸体上滑行。不幸的是，一只巨大的兽人手夹住了盾牌，使他旋转一个圆圈。他向后飞出盾牌，落在一堆武器上。他痛苦地呻吟。%randombrother% 大声说道。%SPEECH_ON%{我看到你在那里干了什么。 | 这里没有女人可以打动，白痴。}%SPEECH_OFF% | %hurtbro% 拿起一把生锈的兽人刀，尝试使用它。不幸的是，他绊倒在它的前任所有者上，并在跌倒时割伤了自己。这个白痴会随时间愈合。 | 你看着 %hurtbro% 拿起并测试各种兽人武器。就在你转过身去的一瞬间，这个可恶的傻瓜竟伤了自己。当你回过头去看到他弯着腰痛苦呻吟时，他的伤并不严重，但是该死的，你希望这些白痴能更加小心。 | 尽管你告诉这些人要小心，%hurtbro% 还是不小心滑倒跌在一个兽人脸上，这可能和跌倒在一件真正的武器上并没有什么区别。他很受伤，但他会活下来。 | %hurtbro% 拿起一个小的地精并像掌中木偶一样玩弄。绿皮精灵的灵魂一定被冒犯到，因为那个佣兵滑倒在一个弃置的盾牌上倒飞了出去，死亡的地精在空中飞旋。这个雇佣兵受伤了，但他会活下来。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "请更加小心。",
					function getResult()
					{
						this.Contract.m.Dude = null;
						return "Battlesite2";
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local bro = brothers[this.Math.rand(0, brothers.len() - 1)];
				local injury = bro.addInjury(this.Const.Injury.Accident1);
				this.Contract.m.Dude = bro;
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = bro.getName() + " 遭受 " + injury.getNameOnly()
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "LuckyFind",
			Title = "在战场上…",
			Text = "[img]gfx/ui/events/event_22.png[/img]{你觉得这些士兵在搜索战场时不会发现什么，但似乎%randombrother%找到了一件强大的武器！ | 在搜索战场的残骸时，%randombrother%发现了一件特别精美的武器，奇迹般地完好无损！ | 找到了一件强大的武器！%randombrother%高兴地向所有人展示。 | %randombrother%开始搜寻一堆武器。你告诉他不要乱抓，以免伤及自己。他突然挺直身子，手里拿着一件奇怪的战争遗物。%SPEECH_ON%啊哈，现在你怎么看，长官？%SPEECH_OFF%好吧，这次他赢了。 | 你警告士兵们要继续警惕可能离开战场的敌人，但%randombrother%开始在一堆尸体中翻找着要掠夺的东西。就在你准备告诉他他有可能会伤害自己时，他突然站起身，手里拿着一件非常棒的武器。你给了他一个大拇指。%SPEECH_ON%干得好，雇佣军！%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "找到了不错。",
					function getResult()
					{
						return "Battlesite2";
					}

				}
			],
			function start()
			{
				local item;
				local r = this.Math.rand(1, 10);

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/greatsword");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/weapons/greataxe");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/weapons/billhook");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/weapons/noble_sword");
				}
				else if (r == 5)
				{
					item = this.new("scripts/items/weapons/warbrand");
				}
				else if (r == 6)
				{
					item = this.new("scripts/items/weapons/two_handed_hammer");
				}
				else if (r == 7)
				{
					item = this.new("scripts/items/weapons/greenskins/orc_axe_2h");
				}
				else if (r == 8)
				{
					item = this.new("scripts/items/weapons/greenskins/orc_cleaver");
				}
				else if (r == 9)
				{
					item = this.new("scripts/items/weapons/greenskins/named_orc_cleaver");
				}
				else if (r == 10)
				{
					item = this.new("scripts/items/weapons/greenskins/named_orc_axe");
				}

				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "你获得了" + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Ambush",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_48.png[/img]{你跟着足迹前进，突然一只绿皮兽从灌木丛中站了起来，尖叫着。更多的绿皮兽从四周冲出来。这是一个伏击！ | 你跟着足迹走，但注意到了一些不对劲。蹲下来，你开始打扫足迹上的灰尘和树叶。它指向相反的方向。留下这些痕迹的人已经折回去了，这意味着……\n\n\"%randombrother%补充了你的想法，指着前方尖叫。%SPEECH_ON%伏击！绿皮族人！%SPEECH_OFF% | 你来到一个分叉的轨迹，突然分叉成随机的方向。沿着它们的轨迹走，你意识到他们消失在环绕道路的灌木丛中。你叹了口气，命令你的士兵准备战斗。你话音刚落，一群绿皮族人就从伏击处涌出！ | 事情并不像看起来那样...就在你心里这样想的时候，一个瞪大眼睛和晒黑了的%randombrother%大喊出来。%SPEECH_ON%这是一个陷阱！%SPEECH_OFF%绿皮族人从四周的灌木丛中涌出。这是一个伏击！你迅速命令你的士兵排成阵型。 | 这些轨迹很容易跟踪，如果你诚实的话，几乎太容易了——在这个想法还没有完结之前，一只绿皮族人就从树丛里跳了出来，咆哮着。在道路对面，更多的绿皮族人也在做同样的事情。这是个设局！准备战斗！ | 你发现轨迹分叉了。一些直通前方，而其他的则分叉并向道路两侧的灌木丛伸展。这不需要一个天才就能意识到正在发生的事情：你命令你的士兵排成阵型。按预定计划，一群群的绿皮族人从灌木丛中尖叫着向%companyname%发起了突袭。准备战斗！ | 在你脚下，足迹消失了，你知道这意味着什么。提高嗓音，你向手下下达命令，让他们排成队形。兽人从灌木丛中涌出来，尖叫着。这是个伏击！ | 足迹在前方继续，但你注意到旁边的土地被扰动过。你命令士兵停下来，蹲下来调查。当你掀起叶子和泥土时，你慢慢地发现足迹实际上是朝着相反的方向。兽人已经回头了...%randombrother%大叫道。%SPEECH_ON%伏击！伏击！%SPEECH_OFF%你转过身，看到野蛮人手持武器，凶猛地从灌木丛中涌出来。迅速接管指挥，你命令你的士兵排成队形。准备战斗！}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "Ambush";
						p.Music = this.Const.Music.GoblinsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						local nearest_goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(tile);
						p.EnemyBanners.push(nearest_goblins.getBanner());
						p.Entities = [];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.GoblinRaiders, 125 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "AmbushFailed",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_53.png[/img]{伏击已经被打败，你带领雇佣兵们进入绿皮兽人的营地，发现被关押的人们都被关在笼子里并蒙着眼睛。你下令开始释放他们。大多数囚犯认为自己已经死了，他们哭了出来并感谢你救了他们的命。这只是一天的工作。 | 绿皮兽人的伏击失败，你进入他们的营地。潜伏的兽人迅速逃走，什么都不带。你发现囚犯在一个帐篷里挤在一起，没有穿衣服。%randombrother%去拿一些毛毯来覆盖他们，为返回%employer%准备。这些获救的人几乎无法说话，但他们的眼睛告诉了很多关于他们所经历的恐怖。 | 伏击已经结束，你和手下开始搜索绿皮兽人的营地。你立即听到帐篷里有人开始尖叫。%randombrother%拉开帘子，看到一个地精在一群蜷缩着、赤裸着的男人前挥舞着火热的铁器。雇佣兵用一刀斩了这个怪物的头。囚犯们大喊着，感谢你解救他们的命。%employer%应该很高兴至少有一些他的员工将回家。 | 伏击解决后，你和%companyname%冲进兽人的营地。你们发现一个地精在戳弄着一个明显被酷刑致死的人。%randombrother%抓住毫不知情的地精并将其殴打致死。你搜索附近的帐篷，找到了一群蒙着眼睛蜷缩在角落里的男人。他们避开你的声音，但很快就明确表示你是来帮助他们的。这些可怜的人经历了很多。将他们送回%employer%和家园应该会有一个良好的恢复。 | 兽人们对战斗的任何期望都已破灭：这些野蛮人已经死了。\n\n你命令士兵们开始搜索他们的营地，试图找到囚犯。不久，%randombrother%在一顶帐篷下找到了那些被殴打和折磨过的人。他们虽然受伤，但是能活下来。有些人感谢你，其他人则感谢旧神们。该死的神明又一次在你的功劳上偷了风头。无论如何，%employer%会非常高兴。 | %companyname%战团迅速摆脱了伏击，冲进兽人已经放弃的营地。你发现了一个男人正在火堆上转着，另一个则被悬挂在树上脚被砍掉。尖叫声引起了你的注意，你发现其余的人挤在附近的帐篷里，乞求水。你的士兵开始发水，给他们治疗伤口。他们需要能够行走才能回到%employer%和他们的家园。 | 伏击已经被消灭，你迅速搜索了兽人的营地。你找到了一些散兵，包括一只试图带着一捆战利品头骨逃走的地精。%randombrother%让这个野蛮的地精为它丑陋的贪婪而付出了代价，也就是丧失了它自己的头颅。\n\n很快你就发现了被困的囚犯蜷缩在羊皮帐篷下。一个人大喊起来。%SPEECH_ON%我知道古神会回应我们的祷告！%SPEECH_OFF%你问古神是否会解除他们的约束。那个好奇的哲学问题没有被回答，因为 %randombrother% 冲了进来，解救了囚犯。无论是谁或者什么人负责营救，最终 %employer% 都会为他们的解救感到高兴。 | 你和%companyname%一起扫过了敌人的营地，把每个剩余的敌人都杀死。囚犯们被从地面上的一个坑中解救出来，看起来他们在那里呆了几天，必须在那里大小便。他们亲吻着地面，感谢你的解救。%employer% 应该会对这个结果感到高兴。 | 伏击已经处理了，但囚犯们呢？你迅速冲进废弃的敌人营地，发现囚犯被绑在一系列的柱子上。不幸的是，最远端的那个人已经被酷刑致死。根据他仍在渗血的伤口来判断，你来得有点晚了。但是，其他的囚犯一个接一个地在你脚下亲吻地面。然而，现在不是感觉良好的时候。%employer% 将以他自己的感谢作为回报，给你一大堆克朗作为奖励。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我们已经得到了我们想要的东西。是时候返回%townname%了！",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "EmptyCamp",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_53.png[/img]{你挥舞着武器跑进了兽人的营地，但发现整个地方都被遗弃了。一锅炖菜被倒翻了，有一些新鲜的火焰表明他们匆忙离开了。%randombrother%带着民众来到了一个山羊皮的帐篷，发现被囚禁的人紧紧地挤在一起。他们见到你，便欣喜若狂地崇拜着诸神。%employer%肯定会对此次行动感到满意，而你则对兽人没有进行抵抗而放弃营地感到高兴。 | 兽人的营地被弃置了。你发现了一只烤猪的残骸以及倒翻的烩菜坐。他们肯定是匆忙离开了。\n\n%randombrother% 叫你过去。囚犯们被困在一个水深半身的地洞里。一个带刺的木门挡着他们出去，虽然它被染血的衣服缠住了，这表明至少有一个人试图逃走。你迅速抬起盖子，帮助他们出来。你往下看，发现一具尸体漂浮在水中。他们并不全部回来，但%employer%应该对这几个幸存的人感到非常满意。 | 你冲进绿皮族的营地，发现帐篷都翻了，有很多脚步声往远处走去。他们匆忙离开了这里。%randombrother% 笑了。%SPEECH_ON%看来他们知道%companyname%要来了。%SPEECH_OFF%突然，一个声音从帐篷中传出来，尖叫着。你赶紧跑过去，发现一个人在歇斯底里地躺在地上，一群蒙着眼睛的人挤在角落里。囚犯们。缺少手指、脚趾、眼睛、鼻子、肢体，与绿皮族在一起度过的时间。你摇了摇头，命令士兵们开始分发医疗用品。%employer%会为他们还活着而感到高兴，但这些人肯定是永远被摧毁了。 | 兽人的营地空无一人。几只黑鸟在一些洒落的炖菜上叽叽喳喳地叫着，而野狗们一看到你就四处逃窜。你的人开始搜索留下来的羊皮帐篷。除了你的脚突然比该有的深陷了一点，什么都找不到。你蹲下来扫掉伪装，发现一个陷阱门。抬起来，你发现这是兽人们把井口改造成了一个垂直的监狱。囚犯们挤在一起，看上去像火柴，脸上是枯萎的、水浸过的表情。%randombrother% 俯身向下看了一眼，咕哝了一声。%SPEECH_ON%好的，他们还活着。我去拿绑绳子。%SPEECH_OFF% | 营地外留下了足迹。从它们的间距和垃圾的分布来看，他们很匆忙。%randombrother% 喊你过去。他站在帐篷外面，拉开帘子。当你到那里的时候，你看到它被用来关押囚犯。他们都赤身裸体地躺在地上，耳朵里插着树枝，眼睛被蒙上了。看起来他们被打得不敢动弹，除非被要求。角落里堆着人类的残肢，看起来有些东西开始用他们的头骨制作原始艺术品。你摇了摇头。%SPEECH_ON%释放他们并给他们水。%employer% 或许希望这些人能够平安回来，但这正是我预期中的情况。%SPEECH_OFF% | 兽人们已经放弃了他们的营地。你不确定为什么，但最有可能的是他们的侦察员发现了你们的战团并做出了逃跑的商业决策。\n\n命令士兵们寻找囚犯，不久便找到了他们：一顶山羊皮帐篷，里面的人被束缚着，脸部被埋在土中。他们只有吸管可以呼吸。%randombrother% 快速走过去，开始把他们的头从地里掏出来。每个人的脸都因为缺氧而变得紫色，但他们还活着，煎熬结束了。%employer% 应该会高兴看到他们回来。 | 营地是空的。%randombrother% 捡起一个倒掉的大锅，从里面滴出的杂物多于烩菜。他摇了摇头。%SPEECH_ON%火势依然在燃烧。他们匆忙离开了。%SPEECH_OFF%你点点头，命令士兵们四处查找囚犯。话音刚落，你便听到有人从附近的帐篷里尖叫。走进帐篷，你发现那些囚犯——或幸存下来的人。房间的一侧是被赤身露体的人挤在一起。另一侧有一滩血，一个刑柱，一把沾染着鲜血的木槌以及几个像用来做书签一样被掐掉头部的尸体。%employer% 将不能拿回他的所有人。 | 进入兽人的营地，{你发现一个地精正在将骨头装进行囊里。它很快放下了东西。%randombrother% 奔过去，在它身上刺了一刀。 | 你发现一个瘫坐在柱子旁的瘦弱兽人。他呼吸急促，但在%randombrother%敏捷地一击下，他不再呼吸。} 部落中的其他人似乎已经撤走，这个绿皮兽人是最后留下的。你在一个帐篷里找到了囚犯，他们被蒙上眼睛，有些人的手指或脚趾已经被割掉了。%employer%一定会很高兴。 | 难民营已经被遗弃，但囚犯留了下来。你营救了他们，或营救他们所剩无几的活口：有些人已经被割掉了手指和脚趾，有些人通过他们的鼻子开的洞呼吸。但他们还活着，这才是最重要的，对吧？ | 你来到一个匆忙遗弃的营地。绿皮族很可能看到了%companyname%的到来，明智地决定在仍有时间的时候离开。囚犯们幸运地还活着。他们感谢上古之神，像面前的先知一样向你鞠躬。你给可怜的幸存者准备好水，准备返回%employer%那里。 | 在营地发现了一只兽人，它正在一个囚笼旁休息，囚笼里关着一些囚犯。其中一个囚犯用链子勒住兽人的脖子，拉着它往囚笼的铁栏杆上挤，狱警和囚犯陷入了最具讽刺意味的斗争。%randombrother% 冲过去，用刀子刺瞎了兽人的眼睛并解救了这些人。囚犯们冲出囚笼，对着大地磕头致谢，跳跃着欢庆。一个晕头转向的男人解释说，兽人们匆匆离开了，看起来他们非常害怕。你点点头，看了看 %companyname% 的徽章，%SPEECH_ON%他们害怕是对的。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我们已经得到了我们想要的东西。是时候返回%townname%了！",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer%欢迎您进他的房间。%SPEECH_ON%我看了一眼俘虏的情况。不过只剩下些许了。他们情况很糟糕，但你做的很好。%reward_completion%克朗，是这样的吗？%SPEECH_OFF% | %employer%正站在房间里，偶尔望向窗外。楼下，俘虏们正在接受治疗。他摇了摇头。%SPEECH_ON%我真的没有想到那些可怜的灵魂中会有一个活下来。你表现得很好，佣兵。%SPEECH_OFF%他把一只裹着%reward_completion%克朗的口袋向你滑去。 | 你发现%employer%正在亲自喂养俘虏。他向他们说出慈祥的话语。看到你，他把任务转交给了一个仆人，并把你带到了一旁。%SPEECH_ON%听着，我知道这些人现在已经毫无价值了。兽人们没有杀他们，他们转瞬间就失去了这个世界的意义。但没关系，你完成了我的要求。在那位守卫那里会有%reward_completion%克朗的酬劳。我不知道你是如何做到的，佣兵。日复一日的。但我很感激你的服务。%SPEECH_OFF%} | %employer%透过薄薄的窗帘凝视窗外，虚淡的影子被微弱地照亮。楼下，获救的囚犯正在接受治疗。他摇摇头并走到桌前。%SPEECH_ON%看到那些人们这样真让人伤心。%SPEECH_OFF%他拿出一个%sreward_completion%克朗的包袱放在你旁边，继续说道。%SPEECH_ON%但是，卖剑士，你把他们带回了家，这才是最重要的。谁都不配在野蛮人的营地里死去。%SPEECH_OFF% | %employer%正在看一系列的卷轴。一名抄写员站在他身边，用拇指和食指滚动一个珠子并凝视着。他们俩看着你走进了房间。你汇报说囚犯已经被营救。贵族放下一份卷轴，然后示意抄写员立即给你支付了%sreward_completion%克朗的报酬。%employer%拍了拍手。%SPEECH_ON%我希望这些人都平安无事。%SPEECH_OFF%当你要开口表明有些人没有回来时，贵族打断了你。%SPEECH_ON%我不需要演讲，卖剑士。我有工作要做。%SPEECH_OFF%抄写员微笑着把你领出了房间。 | 囚犯被带到一个治疗师那里，治疗师努力修复他们可怕的伤口。不幸的是，看不见的伤痕将在他们余生中真正困扰着这些人。%employer%似乎很高兴。%SPEECH_ON%他们回来了是件好事。我当时简直不敢想他们会回来。你的才能真是独一无二，雇佣兵。%SPEECH_OFF%也许是独一无二的，但并不比其他雇佣军公司好到哪去：你要求得到你的报酬。贵族听到这话，立刻拍打手指。一个守卫立刻走过来，带着%reward_completion%克朗。 | 你护送被解救的人回到%townname%。%employer%站在阳台上鼓掌。%SPEECH_ON%好极了！好极了！护卫！%SPEECH_OFF%一个披甲的人带着%reward_completion%克朗的袋子冲向你。 | 被解救的囚犯被一群年迈的治疗师照顾，他们自己看上去就像是生活在绿皮兽营地里一样。这些受伤的战士受到他们先辈的照顾。%employer%似乎很高兴，亲自递给你%reward_completion%克朗的袋子。%SPEECH_ON%你知道吗，我们贵族在那些人是否能活着回来上打了一些赌。我打赌你会成功的。我挣到的钱比我刚刚付给你的还多！这不是很搞笑吗？%SPEECH_OFF% | 你和%employer%一起看着被救出来的囚犯被带进药店。贵族失望地耸了耸肩。%SPEECH_ON%那真是狗屎运。%SPEECH_OFF%这不是你预料中的反应。他俯身小声解释道。%SPEECH_ON%我们之前打了赌，那些人会不会回来。你的好工作让我输了很多克朗。%SPEECH_OFF%你点点头，伸出一只手。%SPEECH_ON%那么，你又要输掉%reward_completion%克朗了。%SPEECH_OFF% | %employer%冲着你露出笑容，拿着一个装满%reward_completion%克朗的小口袋迎接你。%SPEECH_ON%我们之前预料失败的结果，佣兵。我，其他贵族以及城里的人都以为那些人不会回来，可是他们回来了。%SPEECH_OFF% | %employer%亲自照顾被救出来的囚犯，贵族们分发水、食物和绷带，看起来是为了公众形象而做，而不是出于真心。%employer%看见了你，走了过来，用手背擦了擦你的袖子。%SPEECH_ON%呃，他们中的一个往我身上流血了。这是你的%reward_completion%克朗，佣兵。我没想到你能做到，但这里就是他们。说实话，我不太需要它们，不过重在心意吧。%SPEECH_OFF%奇怪的是，你感到有必要告诉他要少说几句实话。 | 你帮助被救出的囚犯穿过%townname%的城门。%employer%与一队卫兵在药店台阶上等待。他们帮助这些人前去治疗。贵族派一个文书过来，送来一个装有%reward_completion%克朗的小包。 | 你在房间里找到了%employer%。一位相当瘦的女子在恪尽职守地用研钵和研杵捣碎着叶子。没看到你，她转向贵族，提着碗说道。%SPEECH_ON%这能帮助它增强作用。%SPEECH_OFF%%employer%肩头张望，看到了你，并跳起身来% SPEECH_ON%佣兵！很高兴见到你！我猜囚犯们已经被解救了？%SPEECH_OFF%你向他汇报了所有发生的事情。贵族派遣那位女子，给你带来了一个装有%reward_completion%克朗的袋子。%SPEECH_ON%我的夫人，把这个奖赏给这个人。%SPEECH_OFF% | 你领着被救出的囚犯穿过%townname% 的城门。一群女人在那里等候着，妻子们伸出双臂拥抱着他们的丈夫，寡妇们跪倒在地。\n\n%employer%走过来，一只手搂住一位女士。他看了一眼场景。%SPEECH_ON%非常悲伤。说，你的奖励是什么，%reward_completion%克朗？%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "从绿皮那释放囚犯");
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
	}

	function onPrepareVariables( _vars )
	{
		if (this.m.BattlesiteTile == null || this.m.BattlesiteTile.IsOccupied)
		{
			local playerTile = this.World.State.getPlayer().getTile();
			this.m.BattlesiteTile = this.getTileToSpawnLocation(playerTile, 6, 12, [
				this.Const.World.TerrainType.Shore,
				this.Const.World.TerrainType.Ocean,
				this.Const.World.TerrainType.Mountains
			], false);
		}

		_vars.push([
			"location",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.m.Destination.getName()
		]);
		_vars.push([
			"dude_name",
			this.m.Dude == null ? "" : this.m.Dude.getNameOnly()
		]);
		_vars.push([
			"hurtbro",
			this.m.Dude == null ? "" : this.m.Dude.getName()
		]);

		if (this.m.Destination == null)
		{
			_vars.push([
				"direction",
				this.m.BattlesiteTile == null ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.BattlesiteTile)]
			]);
		}
		else
		{
			_vars.push([
				"direction",
				this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Destination.getTile())]
			]);
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
				this.m.Destination.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isGreenskinInvasion())
		{
			return false;
		}

		return true;
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
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		this.contract.onDeserialize(_in);
	}

});
