this.confront_warlord_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		local r = this.Math.rand(1, 100);

		if (r <= 70)
		{
			this.m.DifficultyMult = this.Math.rand(95, 105) * 0.01;
		}
		else
		{
			this.m.DifficultyMult = this.Math.rand(115, 135) * 0.01;
		}

		this.m.Type = "contract.confront_warlord";
		this.m.Name = "挑战兽人军阀";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 1800 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
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

		this.m.Flags.set("Score", 0);
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"摧毁任何绿皮队伍和营地来引出他们的军阀",
					"杀死兽人军阀"
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
				this.Flags.set("MaxScore", 10 * this.Contract.getDifficultyMult());
				this.Flags.set("LastRandomTime", 0.0);
				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					this.Flags.set("IsBerserkers", true);
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
			}

			function update()
			{
				if (this.Flags.get("Score") >= this.Flags.get("MaxScore"))
				{
					this.Contract.setScreen("FinalConfrontation1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("JustDefeatedGreenskins"))
				{
					this.Flags.set("JustDefeatedGreenskins", false);
					this.Contract.setScreen("MadeADent");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("LastRandomTime") + 300.0 <= this.Time.getVirtualTimeF() && this.Contract.getDistanceToNearestSettlement() >= 5 && this.Math.rand(1, 1000) <= 1)
				{
					this.Flags.set("LastRandomTime", this.Time.getVirtualTimeF());
					this.Contract.setScreen("ClosingIn");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsBerserkersDone"))
				{
					this.Flags.set("IsBerserkersDone", false);

					if (this.Math.rand(1, 100) <= 50)
					{
						this.Contract.setScreen("Berserkers3");
					}
					else
					{
						this.Contract.setScreen("Berserkers4");
					}

					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsBerserkers") && !this.TempFlags.has("IsBerserkersShown") && this.Contract.getDistanceToNearestSettlement() >= 7 && this.Math.rand(1, 1000) <= 1)
				{
					this.TempFlags.set("IsBerserkersShown", true);
					this.Contract.setScreen("Berserkers1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onLocationDestroyed( _location )
			{
				local f = this.World.FactionManager.getFaction(_location.getFaction());

				if (f.getType() == this.Const.FactionType.Orcs || f.getType() == this.Const.FactionType.Goblins)
				{
					this.Flags.set("Score", this.Flags.get("Score") + 4);
					this.Flags.set("JustDefeatedGreenskins", true);
				}
			}

			function onPartyDestroyed( _party )
			{
				local f = this.World.FactionManager.getFaction(_party.getFaction());

				if (f.getType() == this.Const.FactionType.Orcs || f.getType() == this.Const.FactionType.Goblins)
				{
					this.Flags.set("Score", this.Flags.get("Score") + 2);
					this.Flags.set("JustDefeatedGreenskins", true);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Berserkers")
				{
					this.Flags.set("IsBerserkersDone", true);
					this.Flags.set("IsBerserkers", false);
					this.Flags.set("Score", this.Flags.get("Score") + 2);
				}
			}

		});
		this.m.States.push({
			ID = "Running_Warlord",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"杀死兽人军阀"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onCombatWithWarlord.bindenv(this));
				}

				this.Flags.set("IsWarlordEncountered", false);
			}

			function update()
			{
				if (this.Flags.get("IsWarlordDefeated") || this.Contract.m.Destination == null || this.Contract.m.Destination.isNull() || !this.Contract.m.Destination.isAlive())
				{
					this.Contract.setScreen("FinalConfrontation3");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatWithWarlord( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;

				if (!this.Flags.get("IsWarlordEncountered"))
				{
					this.Flags.set("IsWarlordEncountered", true);
					this.Contract.setScreen("FinalConfrontation2");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					properties.Music = this.Const.Music.OrcsTracks;
					properties.AfterDeploymentCallback = this.OnAfterDeployment.bindenv(this);
					this.World.Contracts.startScriptedCombat(properties, this.Contract.m.IsPlayerAttacking, true, true);
				}
			}

			function OnAfterDeployment()
			{
				local all = this.Tactical.Entities.getAllInstances();

				foreach( f in all )
				{
					foreach( e in f )
					{
						if (e.getType() == this.Const.EntityType.OrcWarlord)
						{
							e.getAIAgent().getProperties().BehaviorMult[this.Const.AI.Behavior.ID.Retreat] = 0.0;
							e.getFlags().add("IsFinalBoss", true);
							break;
						}
					}
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getFlags().get("IsFinalBoss") == true)
				{
					this.Flags.set("IsWarlordDefeated", true);
				}
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{你发现%employer%正在他的马厩里踱步。他用手抚过一匹马的侧腹。%SPEECH_ON%你知道兽人光靠蛮力就能拧断这种生物的脖子吗？我见过。我知道，因为死的是我的马，它的脑袋被一个非常愤怒的绿皮给转到了后面。%SPEECH_OFF%怀旧挺好，但这不是你来的目的。你委婉地请这位贵族切入正题。他照做了。%SPEECH_ON%好吧。和绿皮的战争进行得不如我们预期，所以我得出结论，我们必须杀掉它们的一个军阀。 实话跟你说：军阀在体能上远超它那些废物小弟，他就是个活生生的噩梦。把他引出来的最佳办法，就是尽可能多地杀掉他的绿皮同胞。我知道这听起来很粗暴，但等这事了结，我们打赢这场战争的几率将会大大提高。%SPEECH_OFF% | %employer%招你走进他的房间。他正颇为忧虑地看着地图。%SPEECH_ON%{我的斥候报告说这片地区有个军阀，但我们不能完全确定他的具体位置。我有种预感，如果你出去给那些绿皮杂种制造足够多的麻烦，他可能就会现身来会会你。明白吗？ | 我们接到报告，有一个兽人军阀在这片土地上活动。我相信如果能杀了他，兽人的士气就会低落，我们说不定就能打赢这场该死的战争了。当然，他不会那么容易找到。你得让那个大块头自己现身，而我相信最好的办法就是用兽人的语言说话：尽可能多地杀戮。当然，是杀绿皮。别不分青红皂白乱来。 | 很高兴你来了，佣兵，因为我这正好有个任务要交给你。我们得到消息，有一个兽人军阀在这个区域，但我们不知道他在哪儿。我要你去实践一下兽人的外交手段：尽可能多地宰掉那些绿皮野人，那个军阀肯定会主动来找你的。如果我们能把他除掉，这场战争对我们这边来说，前景就会光明许多了。}%SPEECH_OFF% | %employer%被他的军官和一个看起来非常疲惫、靴子沾满泥泞、脸上汗迹未干的孩子围着。一位军官走上前把你拉到一边。%SPEECH_ON%我们得到了一个兽人军阀的消息。那孩子的家人亲眼见到了它，并为此付出了代价。%employer%相信——我也赞同大人的看法——如果我们能尽可能多地杀掉绿皮，或许就能让这个军阀现身。%SPEECH_OFF%你向后靠了靠，回答道。%SPEECH_ON%让我猜猜，你们想要我去取它的首级？%SPEECH_OFF%军官耸耸肩。%SPEECH_ON%这要求不算过分，对吧？我的封君愿意为这项工作支付一大笔克朗。%SPEECH_OFF% | %employer%坐在一群睡瘫了的狗中间。它们嘴里还叼着雉鸡的羽毛，随着打鼾的气息扇动着。这位领主招手让你进去。%SPEECH_ON%进来吧，佣兵。我刚打完猎。巧合的是，我也需要派你去进行一次狩猎。%SPEECH_OFF%你坐了下来。其中一条狗抬起头，喷了个鼻息，然后又低头睡去。你问这位贵族想要什么。他一边揉着一条杂种狗的耳朵，一边快速解释。%SPEECH_ON%我得到消息，有一个兽人正在附近潜藏着。在哪儿？我不知道。但我觉得你能把它引出来。你知道该怎么做，对吧？%SPEECH_OFF%你点头回应。%SPEECH_ON%是的。不断杀掉它的士兵，直到他气得亲自出来和你决斗。但这无论如何都不是个便宜的要求，%employer%。%SPEECH_OFF%贵族咧嘴一笑，摊开双手，仿佛在说“我们来谈个生意”。他的狗抬起头，仿佛在说“除非这生意意味着你继续挠我耳朵”。 | %employer%坐在一张长桌后，一张更长的地图铺满了桌面两端。他的一个书记员对他耳语了几句，然后匆匆走向你。%SPEECH_ON%大人他有个请求。我们相信有一个兽人军阀就在这个地区，自然，我们想除掉这个野蛮家伙。为此，我们……%SPEECH_OFF%你抬起手打断了他。%SPEECH_ON%是啊，我知道怎么引它出来。我们尽可能多地宰掉这些狗娘养的，直到那个愤怒的绿色大块头自己找上门来。%SPEECH_OFF%书记员温和地笑了。%SPEECH_ON%哦，所以你也读过关于这个战术的书？太好了！%SPEECH_OFF%你的眼神非常微弱地黯淡了一下，但你没有多言，而是问起可能的报酬。 | %employer%在他的书房接待了你。他正从书架上取下一本本书，每次抽出一本都带起一大股灰尘。%SPEECH_ON%来，请坐。%SPEECH_OFF%你坐下后，他拿来其中一本厚书。他翻到一页，指着一幅画风俗艳的巨大兽人画像。%SPEECH_ON%你认识这些家伙，对吧？%SPEECH_OFF%你点点头。这是兽人军阀，也就是一支兽人部队的首领，更是在世上肆虐的暴力旋风的核心。贵族也点点头，继续说道。%SPEECH_ON%我正在对它们做点研究，因为我的哨兵带来了目击报告。当然，我们永远无法完全掌握这该死东西的行踪。它想去哪儿就去哪儿，到哪儿都肆意破坏。%SPEECH_OFF%你打断了贵族，向他解释了一个简单的策略：如果你杀掉足够多的绿皮，这个军阀要么会觉得受到冒犯，要么会被这挑战激得更加狂妄——谁也说不清是哪个——然后它就会出来战斗。%employer%笑了。%SPEECH_ON%你看，佣兵，这就是为什么我喜欢你。你懂行。当然，我想可以假定这种事做起来并不容易。报酬肯定会配得上这活计的。%SPEECH_OFF% | %employer%正在仔细翻阅他的书记员送来的一堆卷轴。他不停地摇头。%SPEECH_ON%这些上面都没说我们该怎么找到它！如果我们不能可靠地找到它，又怎么能可靠地杀掉它？这是最简单的算计！我还以为你懂算计！%SPEECH_OFF%书记员缩着脖子，吸着鼻子，眼睛盯着地板，匆匆离开了房间。你问出了什么问题。%employer%叹了口气，说有个兽人军阀在这个区域，但他们不知道如何阻止它。你笑着回答。%SPEECH_ON%这很简单：你用它们的语言说话。尽可能多地杀掉那些杂种， 你尽你所能杀掉那些混蛋，直到那个军阀被迫亲自出来见你。兽人热爱暴力，他们天生如此，甚至可能就是为此而生的。当然，杀掉那个杀死军阀则没那么容易了……%SPEECH_OFF%%employer%向前倾身，手指搭成尖塔状。%SPEECH_ON%是，当然不容易，但你的确听起来像是能办这事的人。而且这项工作真的能让这场该死的战争转向对我们有利。我们来谈谈价格吧。%SPEECH_OFF% | 在他的花园里踱步。他似乎对植物的茎秆特别感兴趣。%SPEECH_ON%这很奇怪，不是吗？我们这里有这些如此翠绿的东西，而那些绿皮杂种也是绿色的，但我觉得他们这辈子都没吃过蔬菜。%SPEECH_OFF%你想说这观察结论挺蠢的，但还是忍住了。相反，你问绿皮有什么问题，因为这显然是他的话外之音。%employer%点头。%SPEECH_ON%当然有问题。我的探子在这个地区发现了一个军阀。。问题是，我们不知道它在哪，要去哪儿。斥候没法长时间跟踪它，否则他们就会被杀掉——原因你懂的。能帮助我们向结束这场该死的战争迈进一步，但我不知道该怎么做，你呢？%SPEECH_OFF%你点头回应。%SPEECH_ON%你为什么想杀掉这个军阀？是因为它在杀害你的人民，对吧？那么，什么会让他想亲自来杀我们呢？那就是去尽可能多地杀掉他的杂种手下。%SPEECH_OFF%贵族拍了下手，扔给你一个鲜红的番茄。%SPEECH_ON%这想法真不错，雇佣兵。我们谈谈酬金吧！%SPEECH_OFF% | 你看到%employer%和他的指挥官们正围着一张地图站着。你走进房间时，他们齐刷刷转向你，就像一群老鹰发现了兔子。贵族欢迎你进来。%SPEECH_ON%你好啊，佣兵，我们有点紧张。我们的斥候报告说，此时此刻，有一个兽人军阀正在这个地区游荡。问题是我们不太确定它要去哪儿，或者怎么找到它。我的指挥官们认为，如果我们尽可能多地杀掉绿皮，那个军阀就会自己现身，然后我们就能干掉它。你觉得你能胜任这个任务吗？如果能，我们就谈谈合同。%SPEECH_OFF% | 你走进%employer%的房间，发现他正在和一群书记员商议。他们肉眼可见在在发抖，手里捏着珠子串成的项链，坐立不安。其中一个指向你。%SPEECH_OFF%其他人发出嗤笑，但你问是什么问题。%employer%解释说有一个兽人军阀在领地上活动，但他们不知道怎么追踪它。你尽职地点点头，然后解释了一个非常简单的解决办法。%SPEECH_ON%尽可能多地杀掉绿皮，兽人军阀出于野兽的傲慢天性，就会出来和你战斗。或者，在这种情况下，出来和……我战斗？%SPEECH_OFF%%employer%点点头。%SPEECH_ON%你头脑很灵光，佣兵。我们谈谈合同吧。%SPEECH_OFF% | %employer%和他的指挥官们站在一些地图前。%SPEECH_ON%我们有个不得了的工作要交给你，佣兵。我们的哨兵发现有一个军阀在这个地区游荡，我们需要你尽可能多地杀掉绿皮，把它从藏身处引出来。如果我们能拿下那个军阀的脑袋，我们就离结束这场该死的战争更近了一大步。%SPEECH_OFF% | 当你进入%employer%的房间时，他问你知不知道如何猎杀兽人军阀。你耸耸肩答道。%SPEECH_ON%它们只知道暴力这一种语言。所以如果你想和其中一个谈谈，你就得杀掉很多它的兽人同胞。这么说吧，这是让它出来会会的唯一方法。%SPEECH_OFF%贵族理解地点点头。他把一张纸滑过桌面推过来。%SPEECH_ON%那么我可能有个活儿适合你。我们已经知道有一个兽人军阀在我们的区域，但很难追踪到它的下落。我要你把它引出来然后杀掉。如果我们能做到这一点，我们对抗那些绿皮野蛮人的胜算将会增加十倍！%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{想必你出价不低。 | 价钱合适，一切好说。 | 有钱能使鬼推磨。}",
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
			ID = "ClosingIn",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_46.png[/img]{你遇到一个刚堆起的人类颅骨堆。%randombrother%凝视着这张张痛苦面孔组成的图腾，摇着头。%SPEECH_ON%你说他们是不是觉得这是艺术？就像哪个兽人后退一步端详着说，嗯，这样摆不错。%SPEECH_OFF%你也不确定。你衷心希望人类不是绿皮们作画的画笔。 | 你途经一片遭屠宰的农畜。内脏顺着农场地垄沟流下，如同某种血腥的灌溉。要么是农夫严重误判了天气，要么这无疑是兽人临近的确凿迹象。 | 遍地尸体。有些被劈成两半，另一些则相对安详，只是后背刺着几根毒镖。这两种死亡形式都明确标示绿皮就在附近。 | 你来到一个被遗弃的绿皮营地。有个地精脑袋被砸碎了。也许它和某个更大更强的兽人打了架。某具骇人形状的东西正架在烤叉上。你只希望那不是你所想的东西。%randombrother%指着食物下方噼啪作响的余烬。%SPEECH_ON%这是刚留下的。他们离这不远，长官。%SPEECH_OFF% | 你走到一个谷仓前，门在刺鼻的风中吱呀开合。%randombrother%朝里窥探一眼，随即捂住鼻子猛退回来。%SPEECH_ON%没错，绿皮来过这儿。%SPEECH_OFF%你忍住恶心朝仓内瞥了一眼，随即命令兄弟们准备战斗，因为恶战无疑就在眼前。 | 你发现一具兽人尸体，背上还趴着一只地精死尸。掀开这两具躯体，底下是一名死去的农夫。%randombrother%点头道。%SPEECH_ON%嗯，他拼得很凶。可惜咱们没能早点赶到。%SPEECH_OFF%你指向泥地里一串新鲜的踪迹。%SPEECH_ON%他的对手不止这两个，而且剩下的家伙离这不远。让兄弟们准备战斗。%SPEECH_OFF% | 的男人。铁链晃动扭曲时，他那发紫变形的躯体发出叮当脆响。%randombrother%解开链条放下尸体。尸首口中喷出黑血，这佣兵吓得跳开。%SPEECH_ON%见鬼，这人刚死没多久！干这事的家伙肯定不远！%SPEECH_OFF%你指着泥地里的足迹告诉他，这无疑是绿皮所为，而且它们确实就在附近。 | 你在路上发现一个皮肉制的包。 里面装满鞣制变硬的人耳。%randombrother%一阵干呕。你通知手下绿皮离此不远。一场战斗无疑即将来临！ | 你路过一间农舍的废墟。焦黑残骸中余烬噼啪作响。%randombrother%发现几具骷髅，指出它们都少了半边身子。看到灰泥地里深深的足迹，你通知兄弟们做好准备，绿皮无疑就在近旁。 | 你发现路边有个啜泣的男人。他盘腿坐着，身体前后摇晃。当你靠近时，他扭过头来——没有眼睛鼻子，嘴唇也被割掉了。%SPEECH_ON%不要再来了！求求你，不要再来了！%SPEECH_OFF%他侧身倒下开始抽搐，随后便不动了。%randombrother%检查了之后站起身摇头。%SPEECH_ON%绿皮干的？%SPEECH_OFF%你指着泥地里深深的足迹点了点头。 | 你遇见一个女人对着一具尸体哀嚎。她浑身滴淌血污，膝下的那具尸体头颅已被完全砸烂。你蹲在她身旁。她瞥了你一眼，发出呻吟。你问是谁或什么东西干的。女人清了清嗓子回答。%SPEECH_ON%绿皮。大的。小的。他们一边干一边笑。他们的棍棒一上一下，一遍又一遍，中间一直在笑。%SPEECH_OFF% | 发现一匹马死在路边，肚子被剖开摊在路上。它的肋骨框架仍在滴淌新鲜血液。%randombrother%指出心脏、肝脏和其他美味部位都不见了。你指着小径前方沾染血迹的大小脚印。%SPEECH_ON%是地精和兽人。%SPEECH_OFF%而且它们离此不远。你命令%companyname%严阵以待，准备战斗。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "小心点！",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "MadeADent",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_81.png[/img]{死了这么多绿皮，他们的军阀出来应该只是时间问题了。 | 你留下了一连串的绿皮尸体。 他们的军阀很快就会听到你的风声。 | 绿皮的军阀现在肯定听说了他的战士被砍倒的故事。毫无疑问，他现在正追踪你的气味。 | 如果你是绿皮军阀，你可能正在准备去追捕那个残害你部队的混账。继续这样的杀戮，你无疑会发现你和那个兽人的想法是多么相似。 | 兽人能理解暴力，而你无疑在这一地区留下了鲜血淋漓的教导。如果军阀善于学习，毫无疑问它很快就会来找你。 | 往好了估计，兽人军阀现在肯定对你这个搅乱了它计划的任性人类怒不可遏。你应该期待那个兽人的到来，或早或晚。而且很可能是前者。 | 杀了这么多兽人和地精，它们的首领亲自来找你只是时间问题。 | 如果暴力是兽人的语言，那么你已经在这个地区上上下下写了一封真正的情书了。兽人军阀肯定满心想要回报你。 | 如果暴力是兽人表达爱意的方式，那么你已经站在他们军阀的院子里，朝它的窗户扔了好多石子想引起注意。只不过，你扔的不是石头，而是它士兵的残肢断臂。那个野蛮家伙肯定很快就会有所回应。 |你留下了一长串的绿皮尸体，这无疑会吸引它们军阀的注意。 | 秃鹰正在大快朵颐：你开辟了一条由绿皮尸体铺就的道路，看来他们的军阀随时都会亲自来看看你在搞什么名堂。 | 像你这样猎杀绿皮，是吸引兽人军阀注意的万全之法——而且这份关注度正在上升。 | 如果事情继续按照计划进行，也就是说继续畅通无阻地屠杀绿皮野人，那么兽人军阀亲自来见你肯定只是时间问题。 | 就算是万兽奔腾，造成的动静也未必有你过去一周大。如果你继续这样左右开弓地宰杀绿皮，它们的军阀出现就只是个时间问题。 | 你感觉就在这地区的某个地方，有一个非常、非常愤怒的兽人军阀，正盯着一张画着你脸的粗糙画像。 | 你乐于想象自己在绿皮圈子里已经生成了“通缉”海报。一个简笔画的人，下面标着领赏条件，死人或者死透了的人。问题在于，你会继续杀掉所有来找麻烦的家伙，直到兽人军阀本人出现——而你感觉这事很快就要发生了。 | 可以肯定，现在绿皮们正围着营火传播关于你的故事。某个该死的人类在它们的队伍中制造恐怖。而你毫不怀疑，兽人军阀会听到这些故事，并且会忍不住亲自来验证真假…… |继续这样猎杀绿皮，它们的军阀肯定找上门来。 | 你现在是在玩火。这么多的绿皮被杀，兽人军阀迟早会来的。 | 你有一种强烈的预感：兽人军阀很快就要出现了。这可能跟你杀光了他的士兵有关。不过这只是你的直觉。 | 你杀过小绿皮，也杀过大绿皮。现在，是时候干掉它们之中最大的那个了：兽人军阀。那个野蛮家伙肯定就在这附近的某个地方…… | 你已经向绿皮们开战，为此它们的军阀迟早肯定会出现。 | 绿皮们接二连三地死去。它们的军阀迟早会意识到这并非自然原因。一旦它搞明白了，就会马不停蹄地来找你。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{胜利！ | 该死的绿皮。}",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "FinalConfrontation1",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_81.png[/img]{你从乡民那里听到许多传言，说一个兽人军阀正在集结士兵，朝你而来。如果这些传言属实，你应当尽你所能做好准备。 | 有很多消息说一个兽人军阀正在这片地区行军。而它恰好是朝着你的方向来的——这让你觉得你的计划已经奏效了！%companyname%该为恶战做好准备了。 | 有消息说，那兽人军阀正朝你而来！让%companyname%做好准备，他们即将面临一场恶战！ | 你遇到的每个农民似乎都在说着同一个传言：有个兽人军阀正朝你而来！这绝非巧合，%companyname%应当相应地做好准备。 | 不少风言风语说，%companyname%成了一名兽人军阀的目标，他正率领着一小支军队赶来。看来你的计划已经奏效。战团该为即将到来的这场恶战做好准备了！ | 似乎你遇到的每个农民都有消息要讲，而且内容全都一样：一个兽人军阀集结了一支军队，而它恰好正朝你而来。%companyname%该为一场恶战做好准备了！ | 一位小老太太急匆匆地跑到你面前。她解释说每个人都在谈论一个正朝你而来的兽人军阀。你不确定这是否属实，但这与你这几天行为的目标过于巧合。%companyname%应该为战斗做好准备。 | 好了，%companyname%该为一场战斗做好准备了。你遇到的每个人都在告诉你同一个传闻：一个兽人军阀已经集结了一支军队，正朝你而来！ | 看来之前的杀戮见效了：有消息说，一个兽人军阀正带着他的军队朝你而来，要亲自解决掉战团。%companyname%应该为战斗做好准备！ | 一个小孩朝你走来。他瞥了一眼%companyname%的徽记，然后又看看你，笑了起来。%SPEECH_ON%我觉得你们这帮人都需要帮忙。%SPEECH_OFF%这或许是真的，但从一个小孩嘴里说出来显得很奇怪。你问他为什么，他回答。%SPEECH_ON%我爸爸说有个又大又坏的兽人要把你们全杀光。他说商人们一整天都在说这个事！%SPEECH_OFF%嗯，如果这是真的，那就意味着策略奏效了，%companyname%应该为战斗做好准备。你谢过了小孩。他耸耸肩。%SPEECH_ON%我刚救了你们的命，就只换来一句谢谢？你们这些人啊！%SPEECH_OFF%小孩啐了一口，踢着石头走开了。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们得为此做好准备。",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				local playerTile = this.World.State.getPlayer().getTile();
				local nearest_orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(playerTile);
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 9, 15);
				local party = this.World.FactionManager.getFaction(nearest_orcs.getFaction()).spawnEntity(tile, "绿皮军团", false, this.Const.World.Spawn.GreenskinHorde, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.getSprite("banner").setBrush(nearest_orcs.getBanner());
				party.getSprite("body").setBrush("figure_orc_05");
				party.setDescription("一支绿皮军团，由可怖的兽人军阀领导。");
				party.setFootprintType(this.Const.World.FootprintsType.Orcs);
				this.Contract.m.UnitsSpawned.push(party);
				local hasWarlord = false;

				foreach( t in party.getTroops() )
				{
					if (t.ID == this.Const.EntityType.OrcWarlord)
					{
						hasWarlord = true;
						break;
					}
				}

				if (!hasWarlord)
				{
					this.Const.World.Common.addTroop(party, {
						Type = this.Const.World.Spawn.Troops.OrcWarlord
					}, false);
				}

				party.getLoot().ArmorParts = this.Math.rand(0, 35);
				party.getLoot().Ammo = this.Math.rand(0, 10);
				party.addToInventory("supplies/strange_meat_item");
				party.addToInventory("supplies/strange_meat_item");
				party.addToInventory("supplies/strange_meat_item");
				party.addToInventory("supplies/strange_meat_item");
				this.Contract.m.Destination = this.WeakTableRef(party);
				party.setAttackableByAI(false);
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local intercept = this.new("scripts/ai/world/orders/intercept_order");
				intercept.setTarget(this.World.State.getPlayer());
				c.addOrder(intercept);
				this.Contract.setState("Running_Warlord");
			}

		});
		this.m.Screens.push({
			ID = "FinalConfrontation2",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_49.png[/img]{军阀率领着一群兽人和地精。他在那些本就高大的战士环绕下依然显得格外显眼。你命令兄弟们列阵，话音未落，那军阀便发出一声咆哮，他的战士们朝你们冲了过来！ | 一大队兽人和地精列阵于前，他们的军阀站在最前方。他踏步上前，将一个背包朝你猛扔过来。背包在空中散开，落地时敞了口。十几颗头颅像小孩玩具袋里的弹珠一样滚了出来。军阀高举武器，发出咆哮。绿皮们冲来的同时，你迅速命令%companyname%列阵。 | %companyname%伫立在一大群绿皮面前：兽人、地精，以及他们的军阀——一个即使在他们族类中也显得庞大异常的怪物。这个巨大的战士举起武器咆哮，惊飞了林中的鸟儿，吓得小动物们窜回洞中。\n\n绿皮们开始冲锋，你向兄弟们大喊，命令他们列阵，并记住自己的名字：%companyname%！ | 你和%companyname%终于站在了军阀及其兽人与地精大军面前。这似乎是个发表演讲的场合，但你还没来得及说一个字，那些野蛮的杂碎就发起了冲锋！ | 终于，人类与野兽的军队对峙起来。%companyname%的对面是一小支兽人和地精的军队，一个野性十足的军阀立于阵前。你拔出剑，军阀也举起了它的武器。尽管只维持了一瞬间，但你们达成了共识：今天赴死的，是战士，而且只有战士。 | 兽人军阀和他的军队正在冲锋！你告诉%companyname%，这正是他们训练和准备已久的时刻。%SPEECH_ON%这一战，是我们自己的选择！%SPEECH_OFF%兄弟们发出怒吼，利刃出鞘，迅速列阵。 | 一大群地精和兽人在一个巨大军阀的率领下冲过战场，你告诉兄弟们不必害怕。%SPEECH_ON%今晚我们有许多功绩可以庆祝，兄弟们！%SPEECH_OFF%他们武器出鞘，发出震耳欲聋的怒吼，这声浪回荡过去，让绿皮们第一次露出了些许惊讶的神情。 | %randombrother%来到你身边，指着一小支朝你们冲来的兽人和地精军队，军阀正冲在最前面。%SPEECH_ON%不是我想说废话，但绿皮们准备好大战一场了。%SPEECH_OFF%你点点头，向兄弟们大喊。%SPEECH_ON%还有谁也准备好了？%SPEECH_OFF%兄弟们纷纷拔出武器。%SPEECH_ON%%companyname%！%SPEECH_OFF% | 你和%randombrother%看着一个兽人军阀朝你们冲来，后面跟着一小支兽人和地精的军队。那佣兵笑了。%SPEECH_ON%好了，他们来了。%SPEECH_OFF%你点点头，向全体人员喊话。%SPEECH_ON%他们冲锋是因为他们害怕。因为他们没有立足之地。但我们有，因为我们就在这顶天立地！%SPEECH_OFF%你将%companyname%的战旗插在地上。徽记在风中飘扬，兄弟们爆发出气势蓬勃的怒吼。 | 你看着绿皮们在军阀的带领下向前冲锋。你拔出剑，对兄弟们大喊。%SPEECH_ON%谁能砍下蛮子的脑袋，今晚就能睡个好觉！今晚谁能睡个好觉？%SPEECH_OFF%金属铿锵作响，兄弟们拔出武器齐声高喊。%SPEECH_ON%%companyname%！%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						this.Contract.getActiveState().onCombatWithWarlord(this.Contract.m.Destination, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "FinalConfrontation3",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_81.png[/img]{军阀倒在地上，死的不能再死了。你看着剩余的绿皮逃往山里去。你的雇主%employer%会对%companyname%今日的战果感到非常满意。 | %companyname%今日大获全胜！兽人军阀已倒毙于烂泥中，他的军队四散逃入山间。这个结果肯定会让你的雇主%employer%感到无比欣慰。 | 你的雇主%employer%花钱雇了最好的人手，也得到了最好的结果：兽人军阀已死，它那四处游荡的野蛮部众也已仓惶逃窜。没了首领，这些畜生无疑将各自散落，自生自灭。你该回去找那位贵族领取报酬了。 | 你已经剿灭了绿皮，杀了他们的军阀，把他们赶进了山里。你的雇主%employer%肯定会对%companyname%的表现极为满意。 | 兽人军阀已死，这条绿皮匪帮的无头之蛇离消亡不远了。你的雇主%employer%听到这个消息一定会非常高兴。 | 兽人军阀死了。考虑到它曾在这世上制造的恐怖与混乱，它此刻的样子倒是出奇地安详。%randombrother%笑着走过来。%SPEECH_ON%它个头挺大，但也还是会死。我觉得人们总是忘记最后这部分。%SPEECH_OFF%你点点头，吩咐兄弟们准备返回%townname%的%employer%处。 | 军阀倒在地上，死的不能再死了。%companyname%已经完成了%employer%吩咐的事情。剩下的就是回去见那位贵族，告诉他这个好消息。 | %employer%大概原本并不相信你。他大概没有预见到这一刻——你，一个佣兵团长，正站在一个死去的兽人军阀身旁。但这就是你今天的成就，因为%companyname%可不是好惹的。是时候回去找那个贵族领赏了。 | 兽人军阀已死，它的军队也已溃散。你环顾四周，向你的兄弟们喊道。%SPEECH_ON%兄弟们，我朋友想杀了他不共戴天的仇人，他该找谁？%SPEECH_OFF%他们举起拳头。%SPEECH_ON%找%companyname%！%SPEECH_OFF%你大笑着继续。%SPEECH_ON%一个老太太想让我们杀光她阁楼里的老鼠，她该找谁？%SPEECH_OFF%这次兄弟们的声音小了些。%SPEECH_ON%找%companyname%？%SPEECH_OFF%你咧开嘴笑着继续。%SPEECH_ON%如果一个娇气的男人害怕他墙上的蜘蛛，他该找谁？%SPEECH_OFF%%randombrother%啐了一口。%SPEECH_ON%咱们还是赶紧回%townname%找%employer%吧！%SPEECH_OFF% | 你看着绿皮像老鼠一样四散奔逃。%randombrother%看起来准备追击，但你拦住了他。%SPEECH_ON%让他们跑吧。%SPEECH_OFF%那佣兵摇了摇头。%SPEECH_ON%可他们会走漏我们的风声！他们知道我们是谁了。%SPEECH_OFF%你咧嘴一笑，拍了拍他的肩膀。%SPEECH_ON%就是要这个效果。来吧，咱们回%townname%找%employer%去。%SPEECH_OFF% | 你走过堆积的尸骸，来到被杀的兽人军阀面前。苍蝇已经落在了它身上。%randombrother%站在你身边，低头看着这头野兽。%SPEECH_ON%它也没那么恐怖。我是说，好吧，它确实挺吓人的。有点会让我做噩梦的那种，不过总的来说，还不算太恐怖。%SPEECH_OFF%你微笑着拍了拍那人的肩膀。%SPEECH_ON%我希望有一天你能用它的故事吓唬你的孙辈。%SPEECH_OFF% | 战场已归于平静。死者躺在他们用一生奔赴的终点。绿皮们正逃往山里去。而%companyname%则在为胜利欢呼。%employer%会对这整个结果感到非常满意的。 | %companyname%傲然屹立，战胜了绿皮野人。你低头看着那兽人军阀，想到有很多东西必须死去……就只是为了它能死。这是个有着奇怪规则的奇怪世界，但世事如此。\n\n%employer%会很高兴，并支付你一大笔钱——而金钱的世界，是你最懂的世界。 | 你和%randombrother%看着兽人军阀的尸体。苍蝇已经在它的舌头上忙开了，一边交配一边传播着它们的瘟疫。那佣兵看着你笑了。%SPEECH_ON%你给自己设想的结局就是这样吗，让一群虫子在你脸上干那事？%SPEECH_OFF%你耸耸肩回答。%SPEECH_ON%至少这和裹着毯子、在家人陪伴下死去差得很远。%SPEECH_OFF%你拍了拍那佣兵的胸口。%SPEECH_ON%好了，别说这些了。咱们回去找%employer%拿报酬吧。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{%companyname%赢了！ | 胜利！}",
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
			ID = "Berserkers1",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_93.png[/img]，%randombrother%突然挺直身子，让大家安静。你俯低身体，匍匐到他身边。他透过一些灌木丛指去。%SPEECH_ON%那儿。麻烦。天大的麻烦。%SPEECH_OFF%你透过灌木望去，看到一个兽人狂战士的营地。他们生了一小堆火，上面架着旋转烤肉叉。附近有一排笼子，每个里面都关着一条哀鸣的狗。你看到一个绿皮打开一个笼子，猛地拽出一条狗。他拖着不断挣扎惨叫的狗走向火堆，把它举到了火焰上方。\n\n佣兵瞥了你一眼。%SPEECH_ON%我们该怎么办，长官？%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们在打仗，每一场战斗都很重要。拿起武器！",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos(), true);
						p.CombatID = "Berserkers";
						p.Music = this.Const.Music.OrcsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.BerserkersOnly, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				},
				{
					Text = "这事和我们无关。",
					function getResult()
					{
						return "Berserkers2";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Berserkers2",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_93.png[/img]这事与你们无关，以后也不会有关。你让队伍绕开营地悄然行进，避开了那群狂战士——否则很可能演变成一场毁灭性恶战。犬吠声仿佛在驱赶你们离去，即便早已离开那片地域，那声响仍萦绕在几名队员心头久久不散。",
			Image = "",
			List = [],
			Options = [
				{
					Text = "保持头脑清醒，伙计们。",
					function getResult()
					{
						this.Flags.set("IsBerserkers", false);
						this.Flags.set("IsBerserkersDone", false);
						return 0;
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.houndmaster")
					{
						bro.worsenMood(1.0, "你没有阻止兽人吃掉战犬");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "Berserkers3",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_32.png[/img]战斗结束后，你仔细查看了狂战士的营地。每个笼子里都关着条蜷缩畏缩的瘦狗。当你打开其中一个笼门，那狗便呜咽着窜出，翻过山丘消失不见。多数杂种狗也纷纷效仿。然而有两条留了下来。它们跟着你巡视营地残迹。%randombrother%指出这些是战犬。%SPEECH_ON%瞧瞧这体格。高大壮实、凶悍的串种狗。它们的主人准是被兽人杀了，现在嘛，它们有理由信任咱们了。欢迎入队，小家伙们。%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "做得好，伙计们。",
					function getResult()
					{
						this.Flags.set("IsBerserkers", false);
						this.Flags.set("IsBerserkersDone", false);
						return 0;
					}

				}
			],
			function start()
			{
				local item = this.new("scripts/items/accessory/wardog_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "你获得了" + item.getName()
				});
				item = this.new("scripts/items/accessory/wardog_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "你获得了" + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Berserkers4",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_32.png[/img]最后一名狂战士倒下后，你们开始搜查营地。篝火周围散落着烧焦的狗骨，肉已被啃噬干净，一堆头颅摇摇欲坠地叠成病态的骨堆。%randombrother%逐一打开笼门。所有猎犬在获得自由的瞬间便狂奔逃窜。这名佣兵试图拦住其中一只，但那畜生哀嚎着瘫软在地，竟因极度的恐慌断了气。整座营地除了令人失望的景象和成堆的兽人粪便外，毫无价值之物。",
			Image = "",
			List = [],
			Options = [
				{
					Text = "不管怎么说，我们还是做了件好事。",
					function getResult()
					{
						this.Flags.set("IsBerserkers", false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{你看到%employer%正在和他的将军们交谈。他转身对你张开双臂微笑。%SPEECH_ON%干成了啊，佣兵。说实话，我原以为你办不到。杀兽人这活儿可真有意思。%SPEECH_OFF%其实没什么意思，但你还是点了点头。贵族取来一袋%reward_completion%克朗亲手交给你。%SPEECH_ON%任务完成得漂亮。%SPEECH_OFF% | 你撞见%employer%正和几个女人躺在床上。他的卫兵站在门口，站在门口，一脸“是你说放他进来”。的无奈表情。贵族朝你挥手。%SPEECH_ON%我有点忙，不过听说你所有的………呃，行动都成功了。%SPEECH_OFF%他打了个响指，一个女子从被褥中滑出，优雅地踏过冰冷的石地板取来钱袋递给你。%employer%继续说道：%SPEECH_ON%是%reward_completion%克朗对吧？这份报酬配得上你的功绩。听说斩杀兽人军阀可不是轻松差事。%SPEECH_OFF%递钱时那女子深深望进你眼睛。%SPEECH_ON%你杀了个兽人军阀？真勇敢啊……%SPEECH_OFF%你点头后，这窈窕女郎踮脚转身。贵族再次打响指召她回床。%SPEECH_ON%当心点，雇佣兵。%SPEECH_OFF% | 卫兵将你带到正在打理菜园的%employer%面前。他修剪着蔬菜扔进仆人提的篮子。%SPEECH_ON%从你还没死来看，我的推理能力告诉我你成功宰了那个兽人军阀。%SPEECH_OFF%你回应道：%SPEECH_ON%并不轻松。%SPEECH_OFF%贵族盯着泥土点头，继续采摘番茄。%SPEECH_ON%那边站着的卫兵会给你报酬。按约定是%reward_completion%克朗。我现在很忙，但你要知道我和镇民都欠你很多。%SPEECH_OFF%显然他说的“很多”就指%reward_completion%克朗。 | %employer%将你迎进房间。%SPEECH_ON%我的小鸟们最近叽叽喳喳，都在讲有个佣兵宰了兽人军阀还击溃了他的军队。我心想，嘿，这人我认识啊。%SPEECH_OFF%贵族咧嘴笑着递来一袋%reward_completion%克朗。%SPEECH_ON%干得好，雇佣兵。%SPEECH_OFF% | %employer%拿着装有%reward_completion%克朗的钱袋迎接你。%SPEECH_ON%我的探子早已汇报了所有我需要知道的情报。你值得信赖，佣兵。%SPEECH_OFF% | 你走进%employer%房间时，他正听书记官低语。见到你，这人猛地起身。%SPEECH_ON%正巧我们正说着你的事情。你现在是全镇的热议话题，佣兵。杀了兽人军阀还击溃大军？要我说，这绝对值我们约定的%reward_completion%克朗。%SPEECH_OFF% | %employer%正专注地盯着地图。%SPEECH_ON%托你的福，我得重画部分区域了——这是好事。杀了那兽人军阀，我们就能从它在这片土地播撒的灰烬中重建。%SPEECH_OFF%你点头，却委婉地问起报酬。贵族微笑。%SPEECH_ON%是%reward_completion%克朗对吧？而且你该花点时间享受赞誉，佣兵。钱又不会长腿跑掉，但现在的自豪感总有一天会消退。%SPEECH_OFF%你不以为然：这钱很快就会“消退”在半升美酒里。 | %employer%在房间里踱步，将军们恭敬地静立两旁。你问出了什么事，这人猛地直起身。%SPEECH_ON%旧神在上啊，我还以为你回不来了%SPEECH_OFF%你无视他对你的信任度的变化，向贵族汇报了全部经过。他连连点头，取出一袋%reward_completion%克朗递来。%SPEECH_ON%这活儿干得漂亮，雇佣兵。真他妈漂亮！%SPEECH_OFF% | 你看到%employer%正在看仆人劈柴。见到你的身影，贵族转过身来。%SPEECH_ON%啊，时下的风云人物！早听说你的壮举了。我们正准备庆祝——得备好柴火做饭办晚宴。本想邀请你，但这是上流人士的聚会，相信你能理解。%SPEECH_OFF%你耸耸肩回应：%SPEECH_ON%要是拿到说好的%reward_completion%克朗，我就更能理解了。%SPEECH_OFF%%employer%大笑着对守卫打了个响指，对方立刻送来你的报酬。 | 你见到%employer%正与另一支佣兵队的队长交谈。那是个弱不禁风的领头人，估计刚入行。但一见到你，贵族立刻打发他离开并迎上来。%SPEECH_ON%见鬼，见到你真好，雇佣兵！刚才这儿都快走投无路了。%SPEECH_OFF%你评价刚才那队长根本担不起任何任务，更别说追杀兽人军阀。贵族递来一袋%reward_completion%克朗回应：%SPEECH_ON%听着，我们都同意你今天立了大功。终于能重建那个天杀兽人摧毁的一切，这才是关键。%SPEECH_OFF%你手里的克朗才是关键，但你不打算再纠结这点。}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "杀死了一个著名的兽人军阀");
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
