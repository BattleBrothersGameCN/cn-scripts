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
		this.m.Name = "解救俘虏";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
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
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else if (r == 2)
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
					"在%origin%的%direction%边搜索战场并寻找线索",
					"解救你找到的任何囚犯"
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
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
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
					if (this.Contract.getDifficultyMult() > 0.85)
					{
						this.Flags.set("IsScouts", true);
					}
				}

				r = this.Math.rand(1, 100);

				if (r <= 50)
				{
					this.Flags.set("IsEnemyCamp", true);

					if (this.Math.rand(1, 100) <= 20 && this.Contract.getDifficultyMult() < 1.15)
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
					"追踪远离战场的绿皮足迹",
					"解救你找到的任何囚犯"
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
					"带着获释的囚犯返回" + this.Contract.m.Home.getName()
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer%正侧耳倾听一个农民用嘶哑的声音绝望地求助。显然，绿皮袭击了附近的村庄并掳走了一些人。这位贵族立刻征召你的服务：把那些人带回来……当然，是有偿的。 | 你进入%employer%的房间时，他正盯着一些地图。几位指挥官站在他身旁，用棍子在纸质的地形图上划线和标记。看到你，贵族立刻招手让你靠近。%SPEECH_ON%我有个麻烦，佣兵。绿皮一直在袭击这片土地，我相信你也注意到了，但最近我们接到报告说他们抓了一些人。我们不完全确定他们去了哪里，但我们知道他们最后出现的位置。如果你去那里，我想你能找到他们现在位置的线索。我希望这能引起你的兴趣，佣兵。%SPEECH_OFF% | 你看到%employer%和一个农民交谈。几个守卫抓着农民的手臂，显然是把他拖到贵族面前的。你以为是犯了什么罪，但其实这只是%employer%偏好的与底层人谈话的方式。这个平民带来的消息是，绿皮袭击了本地一个地区并抓走了一些人。他们留下了足够的线索，找到他们应该不会太难，当然，前提是你愿意接下这个任务。 | 只见%employer%瘫坐在他的椅子上。%SPEECH_ON%我的人民正在对我失去信心。有消息说绿皮不只是袭击村庄，还抓俘虏，我觉得这某种程度上更糟！但也许如果有人能把那些人带回来，我的人民会重新开始信任我。你觉得呢，佣兵，你愿意帮忙找回那些可怜的失踪者吗？当然，报酬会付足的。%SPEECH_OFF% | %employer%正在和他的一位指挥官谈话。%SPEECH_ON%我们会把他们救回来的，你别担心。%SPEECH_OFF%看到你，贵族立刻告诉你，之前和绿皮发生了一场大战，根据报告，有人被掳走了。指挥官上前一步，拇指插在腰带里，身边一把大剑哐当作响。%SPEECH_ON%佣兵，如果你能把那些人带回来，那将是莫大的功劳。%SPEECH_OFF% | %employer%正在和他的一位指挥官争论。%SPEECH_ON%听着，我们派不出更多的人手了。%SPEECH_OFF%指挥官指向你。%SPEECH_ON%那他呢？%SPEECH_OFF%你很快得知了情况：在%direction%方向发生了一场与绿皮的大战，有人被掳走了。%employer%没有足够的人手出去寻找他们，需要像你这样机动灵活的人来办这件事。 | %employer%正在看地图。他指着一个地点。%SPEECH_ON%在%direction%方向发生了一场和绿皮的大战。我们有理由相信他们抓了俘虏——而我也有理由相信你能把他们带回来。%SPEECH_OFF% | 一名士兵拄着拐杖蹒跚地走向你。他的腿正滴滴答答地往地板上滴着液体。%SPEECH_ON%嘿，你是%companyname%的人，对吧？%employer%让我来接你。%SPEECH_OFF%他解释说，他的手下在%direction%边和绿皮打了一场，绿皮可能掳走了一些人。你问这个人为什么没有接受治疗。%SPEECH_ON%我，呃，从战场上逃跑了。这就是我的惩罚。反正也没关系了，药师说我活不过这个月了。看到没？挺恶心的吧？%SPEECH_OFF%他小心翼翼地抬起腿。绷带周围全是绿色的脓疱。确实相当恶心。 | %employer%正试图从他的狗那里夺回一个墨水瓶。%SPEECH_ON%你吞下去就死定了，你这蠢狗怎么就不明白？%SPEECH_OFF%贵族看到你，直起身来。%SPEECH_ON%佣兵！见到你真好，现在真是危急时刻。在%direction%边发生了一场和绿皮的战斗，我的指挥官报告说那些绿皮掳走了一些人！我需要你这样的人来帮忙把人救回来。%SPEECH_OFF%就在你考虑的时候，狗吞下了墨水瓶，并立即开始作呕。它吐出了一股发黑的呕吐物。一支羽毛笔轻柔地滑落在呕吐物旁边。%employer%难以置信地举起双手。%SPEECH_ON%我找了一个小时！那是我最喜欢的笔，你这该死的狗。%SPEECH_OFF% | %employer%手中捧着一个卷轴。他认真地读着，一位抄写员在他身后边看边思索。贵族把纸猛地拍在桌子上，招手让你进去。%SPEECH_ON%在%direction%方向发生了一场和绿皮的大战，那些绿皮抓了俘虏！俘虏，你能相信吗？%SPEECH_OFF%没等你回答，%employer%就继续说道。%SPEECH_ON%听着，我抽不出人手，但如果绿皮真的抓了俘虏，那么也许像你这样有能力的人可以帮忙把他们救回来？%SPEECH_OFF% | %employer%的一位指挥官在他房间门外迎接你。他递给你一个写有指令的卷轴。根据报告，在%direction%的一场大战以绿皮掳走幸存者告终。%employer%有意救回那些人，但没有多余的士兵可以去营救他们。指挥官交叉双臂。%SPEECH_ON%如果你想讨价还价，大人已授权我来回复。%SPEECH_OFF% | %employer%在房间里追着踢一只猫，直到那猫跳上了天花板，紧紧抓住窗帘杆的顶端。贵族抬头盯着它。%SPEECH_ON%我都找不到合适的词来表达我有多恨那该死的东西。%SPEECH_OFF%他转身看到你。%SPEECH_ON%佣兵！来得好！我有事要办，不，和那该死的小畜生无关。我的士兵在%direction%和绿皮打了一仗。报告说那些绿皮抓了俘虏，这意味着他们有可能被救回来。而我认为你，先生，正是办这事的人选。%SPEECH_OFF%猫喵喵叫着，蹲伏下来。%employer%猛地转身，用手指着它。%SPEECH_ON%给我跳下来！给我跳！%SPEECH_OFF% | 一群指挥官围站在%employer%身边。他们面前的桌子上还放着一颗人头。%employer%看着你。%SPEECH_ON%一队士兵在%direction%与绿皮遭遇了。他们输了，这你应该能看出来。绿皮还抓了俘虏，如果这是真的，我非常希望能把那些人救回来！我认为你是这份工作的完美人选，佣兵，你觉得呢？%SPEECH_OFF% | 一个瘦削的孩子站在%employer%旁边，画着一幅地图，解释他亲眼目睹的一系列事件：一队士兵在%direction%与绿皮发生冲突并战败了。然后绿皮抓走了幸存者。%employer%转向你。%SPEECH_ON%好吧，如果这个骨瘦如柴的农民说的是真的，那么我们需要把那些人救回来。佣兵，你觉得呢？你有兴趣救回我的士兵吗？ | 你看到%employer%正在对一个哭泣的指挥官说话。%SPEECH_ON%所以，让我理清一下。在%direction%，你遇到一群绿皮，打输了，逃跑了，还眼睁睁看着你的一些手下被俘？%SPEECH_OFF%指挥官点了点头。%employer%向一些守卫挥手。%SPEECH_ON%可耻的懦夫在这厅堂里得不到奖赏，把他带走！而你，佣兵！我需要一个意志更坚强的人去那里把那些囚犯救回来！%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{想必你出价不低。 | 谈谈价钱吧。 | 价钱合适，一切好说。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{这事不划算。 | 我们还有别的地方要去。}",
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
			Title = "在战场上……",
			Text = "[img]gfx/ui/events/event_22.png[/img]{苍蝇的嗡鸣如此响亮，甚至在你闻到它们忙碌的对象之前就先听到了。一大群昆虫降临在这片污秽之地，一个恐怖的瘟疫点，人类与绿皮在此交锋，人人渴望胜利却最终罗德惨败。你挥手拨开蝇群形成的迷雾，命令%companyname%开始搜寻幸存者或线索。 | 尸体堆叠着尸体。马匹四处散落。一匹正惊惶地奔向远方，狂野地腾跃着。内脏外露的气味弥漫。每一步踏下都是鲜红血泊。%randombrother%用布捂住鼻子走过来。%SPEECH_ON%我们会开始寻找线索，头儿，但这会很难熬。%SPEECH_OFF% | 硝烟、血液、泥土混合化为泥泞。你在战场上四处走动，命令佣兵们散开寻找线索。%randombrother%盯着一个被插在断裂草叉尖上的绿皮，那兽人自己也用一把生锈的刀刺穿了杀死它的人的头颅。他摇了摇头。%SPEECH_ON%呵，‘线索’，搞得我们好像还不知道这里发生了什么似的。%SPEECH_OFF%你提醒他绿皮抓走了俘虏，而%companyname%是来救他们的。 | %randombrother%看着战场。%SPEECH_ON%你确定真有人活了下来被抓走吗？%SPEECH_OFF%确实，仿佛一个巨大的尸球砸碎了大地，将其变得血迹斑斑、面目全非。尸体以各种方式扭曲僵硬，兽人张着大嘴发出永恒的咆哮，男男女女被撕成碎片。马匹埋在尸堆中，腿像扭曲的兽性狂怒图腾般剪影般刺向天空。你不确定是否有俘虏被抓走，但还是命令%companyname%开始搜寻。 | 要从这里抓捕俘虏，简直就像将恶魔从地狱拖出来一样，看着那些肢体纠缠、白骨支棱的尸堆，你根本无法想象有人能幸存下来。仿佛一大群人与野兽曾站在一起，然后一颗由毁灭构成的巨大滚石碾过他们所有人，留下的残骸就是你眼前所见。几乎没几个能称得上是完整的。%randombrother%拿了块布捂住脸，低头看了看，挥手赶开脸上的苍蝇。%SPEECH_ON%好吧，我想我们这就开始找足迹。不过，呃，不能保证有什么发现。%SPEECH_OFF% | 在这里寻找足迹，犹如在断肢构成的干草堆里找一根针。%randombrother%双手叉腰，难以置信地笑了起来。%SPEECH_ON%真有人从这烂摊子里活下来了，而且还有心思抓俘虏？%SPEECH_OFF%你耸耸肩，命令%companyname%搜寻线索。 | 你能感觉到这地方曾是私奔恋人和嬉戏孩童的宁静去处。如今大地已化为泥泞，死者遍布其上，数量之多犹如他们在混乱终结时留下的脚印。%randombrother%擦了擦额头。%SPEECH_ON%真够糟糕的。好吧，我想我们会四处翻找，看能不能找到什么足迹或线索。%SPEECH_OFF% | 你们来到了战场。%randombrother%向后一仰，对着眼前的绝对恐怖大笑起来。%SPEECH_ON%诸神啊，这到底是怎么回事？你肯定在开玩笑！%SPEECH_OFF%先是一场战斗，人与兽绝望地激烈斗争，死亡带走了不少士兵。然后是暴雨。践踏过的大地变成了泥泞。染血的田野变成了字面意义上的血池。现在，你们这些佣兵，以目击者的身份正跋涉在泛起泡沫的猩红中，统计着这彻底毁灭后的残余。你摇摇头，开始向手下下达命令。%SPEECH_ON%我们是来找线索的。寻找任何离开的足迹。从这里幸存下来的绿皮肯定带走了俘虏。%SPEECH_OFF% | 你看到的与其说是尸体，不如说是零件。一堆零碎的暗示，表明在某个时间、某一天，一群人与野兽在此相遇，并在他们的野蛮中，抹去了这些战士作为完整个体的概念。%randombrother%用棍子挑起一只靴子，一只脚滑了出来。他摇了摇头。%SPEECH_ON%好吧，我们可以开始找足迹了，但要是真有人从这儿活下来，而且还抓走了俘虏，我绝对会震惊死的。%SPEECH_OFF% | %randombrother%看着战场。%SPEECH_ON%见鬼了。%SPEECH_OFF%你们看到了一场战斗的残迹，一堆支离破碎的绿皮和人类纠缠在一起，像一场扭曲血腥的仪式。马匹站在一旁，带着矛盾而又竖起耳朵的好奇心探看着这一幕。当你的手下开始在现场翻找线索时，它们散开了。你大声下令。%SPEECH_ON%记住，绿皮抓了俘虏！寻找足迹，弟兄们。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "四处找找！",
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
			Title = "在战场上……",
			Text = "[img]gfx/ui/events/event_22.png[/img]{%randombrother%发现了一串离开此地的足迹。%companyname%应该跟着走！ | 发现了一串从战场延伸出去的足迹。在更大的兽人脚印中夹杂着较小的人类脚印。如果跟上它们，你很可能会找到囚犯。 | %randombrother%蹲低身子，招手让你过去。他指着地上的某些印记。%SPEECH_ON%头儿，那些看起来像什么？%SPEECH_OFF%你看到几组较小的靴印和更大得多的脚印。旁边还有一连串小点般的足迹。你依次指着并判断。%SPEECH_ON%人类，兽人，地精。我说如果我们跟上这些，说不定就能找到那些囚犯。%SPEECH_OFF% | 你偶然发现，或者说踩进了一串巨大的脚印。根据粗大的脚趾和没穿鞋的形状判断，这些是兽人的脚印。然而，旁边还有你一眼就能认出的足迹。%randombrother%走过来。%SPEECH_ON%看来这就是我们的线索了，头儿。我们跟着走，囚犯们离好日子就不远了。%SPEECH_OFF% | 你蹲下身查看一串足迹。人类、兽人、地精的。都很新鲜，都从战场延伸出去。如果跟上它们，很可能带你找到你追寻的囚犯。 | 一大群兽人和地精的脚印从战场延伸出去。沿着它们两侧是一串人类脚印，都非常新鲜。%randombrother%吐了口唾沫点点头。%SPEECH_ON%这就是我们要找的人，跟着走，说不定就能找到那些囚犯。我是说，他们可能都像我奶奶一样死透了，但我觉得还是值得找找看。%SPEECH_OFF% | %randombrother%指出了一个有意义的发现：一串人与野兽的足迹从战场延伸出去。如果%companyname%跟着走，应该很快就能找到囚犯。 | 一个拿着干草叉的男人从那边过来，他把叉子齿那头扎进土里，像撑帐篷杆一样把自己支在山坡上。他朝你喊话让你过去，你慢慢走了过去。当你走近时，那人咧嘴笑了。%SPEECH_ON%你们在找那些被抓走的人，对吧？%SPEECH_OFF%他在牙齿和本该有牙齿的地方转动着一根扫帚草。他指着说。%SPEECH_ON%那边泥路上有脚印。不知道那些野人为啥留下他们走路的痕迹，不过我猜这就是为啥管他们叫野人吧，嗯。%SPEECH_OFF%你感谢了农民的帮助，并且正如他所说，很快发现了从战场延伸出去的足迹。%companyname%应该循着它们去寻找囚犯。 | 在战场上搜索时，%randombrother%被一个小孩吓了一跳，那孩子从一具尸体后面跳出来，双手在脑袋两边张开，像某种病态的植物活过来要吃人似的。佣兵拔出了武器。%SPEECH_ON%我要给你点颜色瞧瞧，小兔崽子！%SPEECH_OFF%你拦住佣兵，问那孩子在干什么。小家伙耸耸肩。%SPEECH_ON%玩呗。我说，你们不会想知道那些绿皮去哪儿了吧？%SPEECH_OFF%你当然想知道。孩子带你看到一串足迹，有人类的、兽人的和地精的。都很新鲜。你告诉孩子回家去，这儿不安全。他翻了个白眼。%SPEECH_ON%{天哪，你这‘谢谢’可真是够意思的，先生。 | 哼，不用客气，先生。 | 我以为我出来是玩的，结果我真正的目的是在这等你啊。 | 哦，太好了，我还以为我躲开我娘了呢，结果这里又来一个，烦死了。} | 当你开始对找到线索失去希望时，一个年轻女子提着篮子走了过来。她正从死者身上捡拾布条，一边走一边拧干血迹。你问她是否看到了什么。她点点头。%SPEECH_ON%是啊我当然看到了，我有眼睛，不是吗？我脑袋里也有点东西，而且很明显，先生，你在找那些绿皮杂种带走的人。%SPEECH_OFF%你点点头，问他们去哪儿了。她指着一座小山下面。%SPEECH_ON%看到那条小径了吗？里面有脚印。那些野人要去哪儿一眼就能看出来。我是不会跟过去的，但你看起来是结实可靠的那种。我说，那是什么料子？%SPEECH_OFF%她指着%companyname%的旗帜。你耸耸肩。她也耸耸肩。%SPEECH_ON%嗯，挺不错的。如果你在这儿看到类似的东西，告诉我，好吗？我在给我自己做结婚礼服呢。%SPEECH_OFF% | 一个男人踏着重步走上一条小路，像士兵一样甩着腿，一串死鱼在他腰间晃荡。他看到你停了下来。%SPEECH_ON%让我猜猜，你们在找那些人被抓去哪儿了，对吧？%SPEECH_OFF%你点点头，问他是否看到他们去哪儿了。他摇摇头，但指着自己的脚下。%SPEECH_ON%不知道。但这儿就有脚印。看，人类和绿皮的。这可能跟他们有关，你觉得吗？%SPEECH_OFF%确实有关。你命令%companyname%准备出发。 | 战场上没有任何线索，但紧邻战场的区域有：你发现一串交错着人类和绿皮脚印的踪迹。无疑它们将通向被抓走的人，或者至少是通向抓走他们的人。 | %randombrother%叫你过去。他脚下是一串大脚印和几串越来越小的脚印。它们组合成从战场延伸出去的队形。佣兵瞥了你一眼。%SPEECH_ON%绝对没错，那些是囚犯，那些是兽人，那些点缀在旁边的小脚印则是地精的。%SPEECH_OFF%你点点头，朝%companyname%大喊准备跟上足迹。 | %randombrother%在战场外围发现了一些足迹。你过来检查，他依次指着不同尺寸的脚印。%SPEECH_ON%我觉得那些是兽人的，那些是地精的，而那些，那些就是我们要找的囚犯。%SPEECH_OFF%你同意他的判断。如果%companyname%跟上这些足迹，他们很可能找到囚犯和抓他们的人。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "走吧！",
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
							local party = this.World.FactionManager.getFaction(camp.getFaction()).spawnEntity(tile, "绿皮军团", false, this.Const.World.Spawn.GreenskinHorde, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
							party.getSprite("banner").setBrush(camp.getBanner());
							party.setDescription("奔赴战场的绿皮军团。");
							party.setFootprintType(this.Const.World.FootprintsType.Orcs);
							this.Contract.m.UnitsSpawned.push(party);
							party.getLoot().ArmorParts = this.Math.rand(0, 25);
							party.getLoot().Ammo = this.Math.rand(0, 10);
							party.addToInventory("supplies/strange_meat_item");
							this.Contract.m.Destination = this.WeakTableRef(party);
							party.setAttackableByAI(false);
							party.setFootprintSizeOverride(0.75);
							local c = party.getController();
							c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
							local wait = this.new("scripts/ai/world/orders/wait_order");
							wait.setTime(15.0);
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

								if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
								{
									this.Contract.m.Destination.getLoot().clear();
								}

								camp.setResources(this.Math.min(camp.getResources(), 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
								this.Contract.addUnitsToEntity(camp, this.Const.World.Spawn.GreenskinHorde, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
							}
						}

						this.Const.World.Common.addFootprintsFromTo(playerTile, this.Contract.m.Destination.getTile(), this.Const.OrcFootprints, this.Const.World.FootprintsType.Orcs, 0.75, 10.0);
						this.Contract.setState("Pursuit");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Battlesite3",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_53.png[/img]{绿皮被击败后，你进入他们的营地，发现囚犯们被关在笼子里，蒙着眼睛。你命令佣兵们开始释放他们。大多数囚犯以为自己已经死定了，纷纷崩溃流泪，感谢你的救援。说真的，这不过是你的日常工作罢了。 | 绿皮已被击败，你迅速进入他们的营地，并在在一个帐篷里找到了囚犯。他们赤身裸体地挤在一起。这些被释放的人几乎说不出话，但他们的眼睛诉说了他们经历的恐怖。%randombrother%去找了些毯子给他们披上，以便返回你的雇主%employer%那里。 | 绿皮被处理掉了，你和你的手下开始搜查他们废弃的营地。你立刻听到一个帐篷里传来人们的尖叫声。%randombrother%掀开门帘，看到一个地精在一群蜷缩着的裸体男人面前挥舞着烧红的烙铁。这名佣兵在那生物甚至还没意识到自己命运逆转之前，就一剑削掉了它的脑袋。囚犯们哭喊着感谢你的救援。你的雇主%employer%应该会非常高兴，至少他的一部分人能回家了。 | 绿皮被击败后，你和%companyname%冲进了他们的营地。在那里你发现一个地精正在戳弄一个因折磨而死的男人。%randombrother%抓住那个毫无察觉的地精，将刀刃从它后脑勺插了进去。你顺着血迹走进附近的一个帐篷，发现一群被蒙住眼睛的男人蜷缩在一起。他们听到你的声音向后退缩，但你很快表明你是来帮助他们的。这些可怜的人经历了太多。把他们送回你的雇主%employer%那里，送回他们的家，应该能让他们好好恢复。 | 绿皮任何取胜的机会都已烟消云散：那些野人死得透透的了。\n\n你命令手下开始搜查他们的营地，试图找到囚犯。没过多久，%randombrother%就找到了蜷缩在帐篷底下的人。他们被鞭打和折磨过，但能活下来。有几个感谢你，而其他大多数人则感谢旧神。该死的神明又抢了你的风头。无论如何，你的雇主%employer%会非常满意的。 | %companyname%轻松解决了绿皮，并迅速冲进了他们废弃的营地。那里的恐怖景象超乎想象。有人被串在烤肉叉上，还有人被巨大的木桩刺穿，像帐篷杆一样支向天空。谢天谢地，在这片黑暗中仍有一线光明：你们找到了要寻找的囚犯。他们被打得很惨，但还活着。 | 绿皮已被击败。你冒险进入他们的营地，发现恐怖景象还泛着新鲜的血红色。被剥皮的人体被挂在扭曲的荆棘和树枝构成的架子上。灰色的尸体被开膛破肚，他们憔悴扭曲的面容仍见证着那无比怪诞的毁灭。更多的人在一条浅沟里被发现，被绑着面朝下按在泛起白沫的水中，巨大的石块压在他们的背上，让他们在不到一尺深的水中溺毙。\n\n你不只担心没有幸存者，甚至内心深处希望没有幸存者。这样的恐怖本不该被延续下去。不幸的是，%randombrother%招呼你到一个帐篷去。里面，几个囚犯蜷缩在一起，赤身裸体，因你的出现而畏缩。你命令%companyname%给这些人穿上衣服，提供食物和水，以便返回你的雇主%employer%那里。 | %companyname%相对轻松地击败了绿皮，并潜入了他们的营地。在那里你发现人类被做成了宗教图腾，巨大的方尖碑由闪亮的骨头制成，还有歪斜头骨堆成的石冢。%randombrother%叫你到其中一个山羊皮帐篷去。你冲过去，在那里找到了几个囚犯，每个都被关在由紧密折叠的金属倒刺制成的笼子里。每个人都被小心地释放出来，每个人都倾诉了他们所忍受的恐怖。你向这些人保证，他们将被送回各自的家人身边。 | 一个眼睛歪斜、双手畸形的虚弱兽人正试图带着这些人溜走。%randombrother%冲上前去，用棍棒猛击那绿皮的后脑勺。它倒在地上，翻了个身，露出臃肿的背部。那畸形扭曲的生物发出一种未开化的叫喊，某种甚至比粗野的兽人语更迟钝的语言。%randombrother%犹豫了片刻，那兽人的眼睛只是看着一个它从未理解的世界，然后这人咬紧牙关，砸碎了那生物的脑袋。\n\n你释放了囚犯，他们解释说差点被这个可能是部落白痴的家伙运走。无论如何，他们现在得救了，%employer%会非常高兴他们能回来！ | 绿皮已被击败，囚犯们很快从他们的营地中被救出。每个囚犯都有一个恐怖的故事要讲述，即使是那些一言不发的人也是如此。你的雇主%employer%会非常满意。 | 你的雇主%employer%可能并不期待有这结果，但在击败绿皮并冲进他们的营地后，你成功救出了囚犯！他们的健康状况不是最好，但看到%companyname%而不是拿着火把或刽子手斧的兽人，无疑大大提振了他们的精神。 | 击败绿皮后，%companyname%迅速冲向他们的营地。在里面你发现囚犯们被绳子拴在一根斗熊柱上。一头死熊躺在泥地里，旁边还有几个被凶狠撕咬过的男人。那些幸存者显然徒手杀死了那头野兽，应该尽快把他们带回你在%townname%的雇主那里。 | %companyname%战胜了绿皮，并急忙在他们的营地中寻找囚犯。你不确定这些士兵是否还能再次适合战斗，但希望你的雇主%employer%无论如何都愿意善待他们。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们已经找到要找的东西了。是时候回%townname%去了！",
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
			Title = "在战场上……",
			Text = "[img]gfx/ui/events/event_49.png[/img]{你正在尸体间四处走动寻找线索，突然遭到了一群绿皮的袭击！他们很可能是回来掠夺战利品的。你迅速命令战士们结阵接敌，而那些绿皮也同样摆开了架势。 | 一支意图搜刮战场的绿皮小队意外撞上了%companyname%。准备战斗！ | 正当你在这片区域搜索线索时，一小队绿皮闯入了%companyname%的视线。他们很可能只是回来搜刮战利品的，但现在，你要把他们也添进这尸堆之中！ | %companyname%正在搜寻线索，一支绿皮搜刮队伍却返回了战场！ | 你翻开一具尸体，一个地精正对你咧着嘴。你试图把这具尸体也踢开，不料它却咆哮着抓住了你的脚。它没死！抬头一看，你看到一群同样惊讶的绿皮清道夫正瞪着你。地精尖叫着后退，你也迅速后撤，同时命令%companyname%组成阵型。}",
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
			Title = "在战场上……",
			Text = "[img]gfx/ui/events/event_22.png[/img]{%randombrother%正在尸体堆里翻找，突然他向后一跳。%SPEECH_ON%头儿！这儿有个活的！%SPEECH_OFF%你冲过去，看到一个人正从一堆残肢中爬出来。他颤巍巍地站直身子，那张浸透血污的脸背着阳光。那人声称他参与了这场战斗——并且他决意要战斗到底。显然，他愿意免费加入%companyname%！ | 在战场残骸中搜索时，你突然听到尸体堆下传来一个人的喊叫。%randombrother%把尸体扒开，你看到一张男人的脸正朝上对着你们咧嘴笑。%SPEECH_ON%旧神在上，我还以为我要死在下面了。%SPEECH_OFF%你问他是否参加了战斗，他说是的。他伸出一只手，你把他从尸堆里拉了出来。他出来时刮掉肩膀上的血污。看到%companyname%的旗帜，他问你们是否还能多收一个人。%SPEECH_ON%我还有点未了之事，我相信你懂的。%SPEECH_OFF% | 你之前误以为这里除了死人什么都没有：%randombrother%发现了一个埋在尸堆下的幸存者。你去见他，那是一名战士，正摇摇晃晃地站在阵亡者的尸体上。他定睛看清周围后，眯起了眼睛。%SPEECH_ON%啊，我认得那个徽记。你们是%companyname%。好吧，先生们，我在这儿没啥牵挂了，而且我从来就不太喜欢收拾烂摊子。我说，加入你们这帮家伙怎么样？%SPEECH_OFF% | 一名幸存者从一个兽人战士的腋窝下探出头来。他喘着粗气，%randombrother%和你帮忙把他拖了出来。%randombrother%给他喝了点水，你问他是否还有其他幸存者。他耸耸肩。%SPEECH_ON%嗯，他们叫唤了一阵子，但现在没声了。我说，你们是%companyname%的人吗？%SPEECH_OFF%那人擦了擦嘴，伸手指了指战团的旗帜。你点头。他也点点头，又喝了一口水。%SPEECH_ON%好吧，佣兵们，我在这儿可啥都没有了。希望这要求不算过分，不过，也许我能加入你们的战队？%SPEECH_OFF% | 你们发现了一个幸存者！一个人从尸堆里爬出来，就像虫子从一篮子烂苹果里扭出来一样。他擦去脸上的血和灰色的秽物，大笑起来。%SPEECH_ON%我在下面还以为绿皮回来了，但看到你们这帮家伙真是太好了，老天！%SPEECH_OFF%当%randombrother%递水给他喝时，你问他是否还有其他幸存者。他点点头。%SPEECH_ON%有啊，他们被俘虏了，只有旧神才知道他们怎么样了。我说，如果我没看错，那是%companyname%的徽记吧，你们介意我加入战团吗？我敢肯定你们也注意到了，这儿可没我啥事了。%SPEECH_OFF% | 一个男人从死尸堆中站起来，仿佛他一直就在等你们似的。%randombrother%吓得向后一跳，拔出了武器。幸存者友好地挥了挥手。%SPEECH_ON%我必须承认，我没料到是你们。我还以为会是绿皮回来洗劫这里剩下的东西呢。我说，你们打的那是%companyname%的旗帜吗？%SPEECH_OFF%你告诉他没错。他拍着手走上前来，一路跌跌撞撞地踩过骷髅和断肢，双脚在积血的泥坑里打滑。%SPEECH_ON%太走运了！我正需要找个新东家，如果不麻烦的话，我很乐意加入咱们战团！%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "欢迎加入%companyname%！",
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
					Text = "想都别想，赶紧走开。",
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
				this.Contract.m.Dude.setHitpointsPct(0.6);

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
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).setArmor(this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).getArmor() * 0.33);
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
			Title = "在战场上……",
			Text = "[img]gfx/ui/events/event_22.png[/img]{在战场上搜刮可不是什么安全的活，%hurtbro%把自己弄伤了，应验了这条真理。 | %hurtbro%滑了一跤，摔在了一堆武器上。自然，他受了点伤。 | 不幸的是，%hurtbro%在浸满血污的泥地上滑倒，脸朝下摔在了一个兽人战士大张的嘴上。他受了一些伤。 | 战场在战斗结束很久后依然危险：%hurtbro%滑倒摔了一跤。只是些磕碰，他会没事的。 | 你早知道这些傻瓜里会有人滑倒：%hurtbro%把脚踩在一面盾牌上，那盾牌立刻顺着尸堆滑了下去。他直接滑进了一堆武器里，并为此付出了肉眼可见的代价。 | %hurtbro%大喊。%SPEECH_ON%嘿，看我的！%SPEECH_OFF%他跳上一面盾牌，开始沿着尸堆往下滑。不幸的是，一只巨大的兽人手掌撞到了盾牌，让他转着圈飞了出去，摔在了一堆武器上。他痛苦地呻吟着。%randombrother%喊道。%SPEECH_ON%{我瞧见你玩脱了。 | 这儿可没娘们儿给你显摆，你这白痴。}%SPEECH_OFF% | %hurtbro%捡起一把生锈的兽人刀，试着耍弄一下。不幸的是，他被这刀的前主人绊倒，在摔倒时割伤了自己。这白痴过段时间会痊愈的。 | 你看着%hurtbro%正捡起各种兽人武器并试着挥舞。就转开视线那么一会儿，这该死的傻瓜就把自己弄伤了。你转回身看到他蜷缩着身子痛苦呻吟。伤得不重，但你真希望这些白痴能更小心点。 | 尽管你告诉弟兄们要小心，%hurtbro%还是滑倒了，摔在了一个兽人的脸上，这跟他滑倒摔在真正的武器上也没什么两样。他受伤了，但能死不了。 | %hurtbro%拎起一个小地精，像操纵木偶一样摆弄着。这绿皮亡魂必定觉得受到了冒犯，因为这名佣兵踩到一面被丢弃的盾牌滑倒了，整个人向后飞了出去，那死地精也在空中翻着跟头。这名佣兵受伤了，但死不了。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "多加小心。",
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
			Title = "在战场上……",
			Text = "[img]gfx/ui/events/event_22.png[/img]{你原以为手下在战场上翻找不会有什么收获，但看来%randombrother%居然找到了一件强大的武器！ | 在搜寻战场遗迹时，%randombrother%发现了一件制作尤其精良的武器，它竟在大战中完好无损地保存了下来！ | 找到了一件强大的武器！%randombrother%兴奋地把它举起来给大家看。 | %randombrother%开始在一堆武器里翻捡。你告诉他赶紧停下，免得伤到自己丢掉一条胳膊。他突然直起身来，手里拿着一件看起来有些古怪的战斗遗物。%SPEECH_ON%哦耶，现在你怎么说，长官？%SPEECH_OFF%好吧，这次算他赢了。 | 你警告队员们要留意离开战场的踪迹，但%randombrother%却开始在尸堆里翻找战利品。就在你准备告诉他这样会受伤时，他猛地直起身，手里拿着一把非常精美的武器。你对他竖起了大拇指。%SPEECH_ON%干得好，佣兵！%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "不错的发现。",
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
			Text = "[img]gfx/ui/events/event_48.png[/img]{你正沿着踪迹前进，一个绿皮突然尖叫着从灌木丛中站了出来。更多的绿皮从你四周冲了出来。是埋伏！ | 你跟着踪迹前进，但察觉到有些不对劲。你蹲下身，开始扫开一条踪迹上的灰尘和树叶。它指向了相反的方向。留下这些痕迹的人折返了，这意味着……\n\n%randombrother%替你说完了想法，他指着前方大喊。%SPEECH_ON%埋伏！是绿皮！%SPEECH_OFF% | 你遇到了一对踪迹，它们突然向随机方向分岔。顺着它们的痕迹追踪，你发现它们消失在了道路两旁的灌木丛中。你叹了口气，命令手下准备战斗。话音未落，一群绿皮就开始从埋伏处涌了出来！ | 事情并不像看上去那么简单……正当你这么想时，眼睛瞪得老大的%randombrother%大喊起来。%SPEECH_ON%是陷阱！%SPEECH_OFF%绿皮从周围的灌木丛中不断涌出。是埋伏！你迅速命令你的手下组成战斗阵型。 | 踪迹很容易跟踪，老实说有些容易得过头——还没等这个念头转完，一个绿皮就从灌木丛中跳出来发出低吼。在路对面，更多的绿皮也做出了同样的举动。这是个圈套！准备战斗！ | 你注意到踪迹出现了分岔。一些继续笔直向前，而另一些则分叉开来，延伸进路旁的灌木丛。就算不是天才也能意识到是什么情况：你向手下大声发出命令，让他们组成战斗阵型。仿佛接到信号一般，成群结队的绿皮尖叫着从灌木丛中冲出，伏击%companyname%。准备战斗！ | 踪迹在你脚下消失了，你很清楚这意味着什么。你提高嗓门，向手下大声发出命令，让他们组成战斗阵型。绿皮们开始像女妖一样尖叫着从灌木丛中涌出。是埋伏！ | 踪迹继续向前延伸，但你注意到踪迹旁边有泥土被扰动的迹象。你命令队伍停下，蹲下身仔细查看。你扫开树叶和泥土，慢慢揭开了实际上是朝相反方向行进的踪迹。绿皮们折返了……%randombrother%尖叫起来。%SPEECH_ON%埋伏！是埋伏！%SPEECH_OFF%你转身看到那些绿皮凶狠地高举着武器从灌木丛中涌出。你迅速开始指挥，命令你的手下组成战斗阵型。准备战斗！}",
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
			Text = "[img]gfx/ui/events/event_53.png[/img]{伏击被击败后，你进入他们的营地，发现囚犯们被关在笼子里，蒙着眼睛。你命令佣兵们开始释放他们。大多数囚犯以为自己已经死定了，纷纷崩溃流泪，感谢你的救援。说真的，这不过是你的日常工作罢了。 | 绿皮的伏击失败了，于是你进入他们的营地。任何潜伏的绿皮都迅速逃跑，抛弃了一切。你在一个帐篷里找到了囚犯，他们赤身裸体地挤在一起。%randombrother%去找了些毯子给他们披上，以便返回%employer%那里。这些被释放的人几乎说不出话，但他们的眼睛诉说了他们经历的恐怖。 | 伏击已经结束，你和你的手下开始搜查他们废弃的营地。你立刻听到一个帐篷里传来人们的尖叫声。%randombrother%掀开门帘，看到一个地精在一群蜷缩着的裸体男人面前挥舞着烧红的烙铁。这名佣兵在那生物甚至还没意识到自己命运逆转之前，就一剑削掉了它的脑袋。囚犯们哭喊着感谢你的救援。你的雇主%employer%应该会非常高兴，至少他的一部分人能回家了。 | 伏击被击败后，你和%companyname%冲进了他们的营地。在那里你发现一个地精正在戳弄一个因折磨而死的男人。%randombrother%抓住那个毫无察觉的地精，将刀刃从它后脑勺插了进去。你顺着血迹走进附近的一个帐篷，发现一群被蒙住眼睛的男人蜷缩在一起。他们听到你的声音向后退缩，但你很快表明你是来帮助他们的。这些可怜的人经历了太多。把他们送回你的雇主%employer%那里，送回他们的家，应该能让他们好好恢复。 | 绿皮任何取胜的机会都已烟消云散：那些野人死得透透的了。\n\n你命令手下开始搜查他们的营地，试图找到囚犯。没过多久，%randombrother%就找到了蜷缩在帐篷底下的人。他们被鞭打和折磨过，但能活下来。有几个感谢你，而其他大多数人则感谢旧神。该死的神明又抢了你的风头。无论如何，你的雇主%employer%会非常满意的。 | %companyname%解决了伏击，并迅速冲进绿皮部落废弃的营地。你发现一个人被串在烤肉叉上，在火上烤着。另一个被吊在树上，双脚被砍断。尖叫声将你的注意力引向附近的一个帐篷，在那里你找到了其余的人，他们蜷缩在一起，乞求着水。你的手下开始分发水并处理他们的伤口。他们需要能够走路才能回到%employer%和他们的家。 | 伏击已经被击垮，你迅速清扫了绿皮的营地。你发现了一些掉队的绿皮，包括一个正试图带着一捆战利品头骨溜走的地精。%randombrother%让那它为自己那可怕的贪婪付出了生命的代价。\n\n没过多久，你就在一个羊皮帐篷下找到了蜷缩在一起的囚犯。其中一个喊道。%SPEECH_ON%我就知道旧神会回应我们的祈祷！%SPEECH_OFF%你问旧神是否也会解开他们的绑绳。这个好奇的、带有哲学意味的问题没有得到回答，因为%randombrother%冲进来释放了囚犯。最终，无论谁或什么该为他们的获救负责，%employer%都会很高兴见到他们。 | 解决掉伏击后，你和%companyname%清扫了他们的营地，杀死了你们发现的所有掉队绿皮。囚犯们从一个地坑里被释放出来，他们似乎已经在里面拉撒了好几天。他们亲吻着大地，感谢你的救援。%employer%应该会对这个结果非常满意。 | 伏击已被解决，但囚犯们怎么样了？你迅速冲进被遗弃的绿皮营地，发现囚犯们被绑在一排柱子上。不幸的是，最远端的那个人已经被折磨致死。从他仍在流血的伤口判断，你来得稍微晚了一点。不过，其余的囚犯狂喜地尖叫起来。他们一个接一个地亲吻着你脚下的土地。然而，现在还不是自我感觉良好的时候。%employer%正等着你，还有他的谢意：一大堆克朗。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我们已经找到要找的东西了。是时候回%townname%去了！",
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
			Text = "[img]gfx/ui/events/event_53.png[/img]{你举着武器冲进绿皮的营地，却发现整个地方已被遗弃。被打翻的炖锅，还有新鲜篝火痕迹都表明他们离开得相当匆忙。%randombrother%打开一个山羊皮帐篷，发现囚犯们蜷缩在一起。他们一看到你们就赞美起旧神。%employer%会对这个结果感到满意，而你也乐于见到绿皮不战而退。 | 绿皮的营地已被遗弃。你发现坑里剩下烧焦的猪残骸，还有一些被打翻的炖菜。他们肯定是匆忙离开的。\n\n%randombrother%叫你过去。囚犯们在一个地洞里，水淹到了他们的腰部。一道带刺的木门阻止他们出来，不过门上缠着血衣，表明至少有人尝试过。你迅速抬起盖子帮助他们出来。你低头看到一具尸体漂浮在水面上。不是所有人都能回来，但%employer%应该会对这几名幸运儿感到非常高兴。 | 你冲进绿皮的营地，发现帐篷全都东倒西歪，大量脚印仓促地通向远方。他们匆忙放弃了这里。%randombrother%大笑。%SPEECH_ON%看来他们知道%companyname%要来了。%SPEECH_OFF%突然，一个帐篷里爆发出声音，尖叫和大喊。你冲过去发现一个男人歇斯底里地瘫在地上，而一群被蒙住眼睛的男人蜷缩在角落。是囚犯们。缺失的手指、脚趾、眼睛、鼻子、肢体……都是被绿皮俘虏了一段时间的证明。你摇摇头，命令手下开始分发物资照料他们。%employer%会为他们还活着而高兴，但这些人无疑已经永远地垮掉了。 | 绿皮的营地空无一人。几只黑鸟在为洒出的炖菜争吵打斗，野狗一见到你们就溜走了。你的手下开始搜查留下的山羊皮帐篷。什么都没找到，直到你的脚突然踩得比其他地方更深。你蹲下身，拨开伪装，露出一个活板门。掀开后，你发现绿皮把一口竖井改造成了一个非常垂直的牢房。囚犯们像引火物一样挤在一起，用憔悴、被水浸泡的脸仰头迎接光线。%randombrother%向下看了看，咕哝道。%SPEECH_ON%嗯，他们还活着。我去找些绳子来。%SPEECH_OFF% | 脚印从营地向外延伸。根据间距和散落的垃圾判断，他们走得很匆忙。%randombrother%向你喊叫。他站在一个帐篷外，掀开着门帘。你到那儿后，看到这个帐篷里关押着囚犯。他们全都赤身裸体躺在地上，耳朵塞着树枝，眼睛被蒙住。看来他们被打怕了，不敢乱动。角落里有一堆人体残肢，看起来有什么东西曾拿他们的头骨做原始艺术品。你摇了摇头。%SPEECH_ON%放了他们，给他们水喝。%employer%或许还指望这些人都能完好无损地回来，但我觉得能有这个样子都算好了。%SPEECH_OFF% | 绿皮已经放弃了他们的营地。你不确定原因，但很可能是他们的侦察兵发现了战团，于是做了个明智的决定，趁还能走的时候溜了。\n\n手下们奉命寻找囚犯，很快就找到了：一个山羊皮帐篷里，一群人双手被绑，蜷缩在一根柱子下，脸埋在土里，嘴里叼着一根吸管以供呼吸。%randombrother%急忙过去，把他们的头从土里弄出来。每个人都脸色发紫，喘着粗气，但他们还活着，折磨结束了。%employer%应该会很高兴看到他们回来。 | 营地空无一人。%randombrother%捡起一个打翻的大锅，里面漏出的污水比炖菜还多。他扔下锅，摇了摇头。%SPEECH_ON%篝火还在噼啪作响。他们走得很匆忙。%SPEECH_OFF%你点点头，命令手下散开寻找囚犯。话音未落，你就听到附近一个帐篷传来尖叫。在里面，你找到了囚犯——或者说还活着的俘虏。房间一边，活人赤身裸体地蜷缩着。另一边，你看到一滩血、一个行刑砧、一把染红的木槌，以及几具脑袋被切下的尸体，像用作书签的花一样。%employer%没法把他所有的人都接回去了。 | 你走进绿皮的营地，{发现一个地精正把骨头铲进背包。它迅速丢下了东西。%randombrother%追上去，一刀解决了它。 | 你发现一个受伤的兽人靠在一根柱子上。他呼吸沉重，但%randombrother%迅速一刀刺去，确保他彻底断了气。} 营地的其余部分似乎已被遗弃，这个绿皮是最后一个留下的。你在一个帐篷里找到了囚犯。他们被蒙住了眼睛，有几个缺了手指或脚趾。%employer%会非常满意。 | 营地已被遗弃，但囚犯被留下了。你救了他们，或者说救了他们的残躯：有些人的手指和脚趾被切除了，另一些人通过曾经有鼻子盖住的孔洞呼吸。但他们还活着。这才是最重要的，对吧？ | 你进入一个被匆忙遗弃的营地。绿皮很可能看到了%companyname%的到来，于是明智地决定趁还能走时离开。谢天谢地，囚犯们被找到时还活着。他们感谢旧神，并像乞丐在先知面前一样向你鞠躬。你给这些可怜的幸存者喝了水，并准备返回%employer%那里。 | 营地里发现了一个落单的兽人。它之前靠在关押囚犯的笼子旁休息。其中一个囚犯用链子套住了那绿皮的脖子，正把它往栏杆上勒，看守与囚犯陷入了一场极具讽刺意味的搏斗。%randombrother%冲过去，一刀刺穿兽人的眼睛，并释放了那些人。囚犯们冲出笼子，亲吻着大地，高兴得跳起来。一个兴奋得头晕目眩的人解释说，绿皮是匆忙离开的，而且他们似乎非常害怕。你点点头，用拇指朝肩后指了指%companyname%的徽记。%SPEECH_ON%他们怕得对。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我们已经找到要找的东西了。是时候回%townname%去了！",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer%将你迎进他的房间。%SPEECH_ON%我仔细看了看那些俘虏。还活着的俘虏。他们状况很糟，但你干得不错。%reward_completion%克朗，对吧？%SPEECH_OFF% | %employer%在房间里踱步，偶尔望向窗外。下面，囚犯们正在接受照料。他摇了摇头。%SPEECH_ON%我真的没想到这些可怜人里哪怕能有一个回来。你干得好，佣兵。%SPEECH_OFF%他将装有%reward_completion%克朗的钱袋滑到你面前。 | %employer%亲自给囚犯喂食。他和蔼地对他们说话。看到你后，他把工作交给一个仆人，将你拉到一边。%SPEECH_ON%听着，我知道那些人现在基本都废了。绿皮没杀了他们，但也跟杀了差不多。他们的身体还在撑着，但灵魂已经破碎了。不过这没关系。你完成了我的要求。站在那边的守卫会给你%reward_completion%克朗。我不知道你是怎么做到的，佣兵。日复一日地干这个。但我感谢你的服务。%SPEECH_OFF% | %employer%凝视着窗外，他模糊的身影被透过薄窗帘的微光照亮。楼下，被释放的囚犯正在接受照料。他摇摇头，走到他的书桌旁。%SPEECH_ON%看到他们变成这样真让人难过。%SPEECH_OFF%他取出装有%reward_completion%克朗的袋子推给你，继续说道。%SPEECH_ON%但你把他们带回家了，佣兵，这才是最重要的。谁都不该死在野人的营地里。%SPEECH_OFF% | %employer%正在查看一系列卷轴。一位抄写员站在他身旁，一边低头看着他，一边用手指捻动一颗珠子。你进房间时两人都抬头看向你。你报告说囚犯已被救出。这位贵族放下卷轴，然后向抄写员点头示意，后者立刻付给你%reward_completion%克朗。%employer%拍了拍手。%SPEECH_ON%我希望那些人都平安回来了。%SPEECH_OFF%当你张口想说有些人没能回来时，贵族打断了你。%SPEECH_ON%我不需要听汇报，佣兵。我还有工作要忙。%SPEECH_OFF%抄写员温和地笑着将你送了出去。 | 囚犯们被带到一位医师那里，后者正努力治愈他们可怕的伤口。不幸的是，在余生里真正折磨这些人是那些看不见的伤口。不过%employer%看起来很高兴。%SPEECH_ON%能让他们回来真好。我之前真没想到他们还能回家。你的本事数一数二，佣兵。%SPEECH_OFF%也许是数一数二，但和其他佣兵团也没什么不同：你开口要你的报酬。这提醒了贵族，他打了个响指。一名守卫立刻带着%reward_completion%克朗走了过来。 | 你护送救出的人进入%townname%。%employer%站在阳台上鼓掌。%SPEECH_ON%好极了，好极了！守卫！%SPEECH_OFF%一名披甲士兵匆忙给你送来一袋%reward_completion%克朗。 | 救出来的囚犯被交给一群老医师照料，这些老人自己看起来也像是在绿皮营地里囚禁过一样。受伤的战士由他们的前辈照顾着。%employer%看起来高兴极了，亲自递给你一袋%reward_completion%克朗。%SPEECH_ON%你知道，我们贵族之间就这些人能否活着回来打了赌。我赌了你赢，佣兵。我就知道你能做到！我赚的钱比刚付给你的还多！这是不是很好笑？%SPEECH_OFF% | 你和%employer%看着救出来的囚犯被领进一家药剂店。贵族失望地耸耸肩。%SPEECH_ON%哎，天杀的。%SPEECH_OFF%这可不是你期待的反应。他俯身过来，压低声音解释。%SPEECH_ON%我们就这些人能不能回来打了赌。你的出色工作让我损失了好多克朗，佣兵。%SPEECH_OFF%你点点头，伸出一只手。%SPEECH_ON%那么，现在是你再损失%reward_completion%克朗的时候了。%SPEECH_OFF% | %employer%在他的门口迎接你，带着满脸笑容和一个装有%reward_completion%克朗的小袋子迎接你。%SPEECH_ON%我们原本都以为没希望了，佣兵。我，其他贵族，镇民们。没人认为这些人还能回来，然而，他们回来了。%SPEECH_OFF% | %employer%亲自监督获救的囚犯得到照料，这位贵族分发着水、食物和绷带。这举动看起来更多是为了作秀而非出于真心。%employer%看到你，走了过来，用手背在你的袖子上擦了擦。%SPEECH_ON%呃，他们中有个人把血弄到我身上了。这是你的%reward_completion%克朗，佣兵。没想到你真能办到，但他们确实回来了。老实说，我怀疑他们对我没什么用了，但心意才是最重要的。%SPEECH_OFF%奇怪的是，你忍不住想告诉他别这么“诚实”。 | 你帮助获救的囚犯穿过%townname%的大门。%employer%带着一队守卫在一家药剂店的台阶上等候。他们协助那些人接受治疗。贵族派了一个抄写员给你送来装有%reward_completion%克朗的钱袋。 | 你在%employer%的房间里找到他。一个相当苗条的女人正尽职地用研钵和杵碾碎叶子。她没看到你进来，而是转向贵族并递出碗。%SPEECH_ON%这个应该能帮它立起来。%SPEECH_OFF%%employer%从她肩头看到你，跳了起来。%SPEECH_ON%佣兵！见到你真好！我想囚犯已经救出来了？%SPEECH_OFF%你汇报了发生的一切。贵族示意那个女人拿%reward_completion%克朗给你。%SPEECH_ON%把报酬给这位先生，亲爱的女士。%SPEECH_OFF% | 你带领被救的囚犯穿过%townname%的大门。一群女人在等待他们，妻子们拥抱她们的丈夫，寡妇们则瘫跪在地。\n\n%employer%走了过来，双臂各挽着一位女士。他看着眼前的景象点了点头。%SPEECH_ON%真令人悲伤。对了，你的报酬是多少来着，%reward_completion%克朗？%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "从绿皮手下解救囚犯");
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
