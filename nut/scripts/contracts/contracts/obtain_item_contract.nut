this.obtain_item_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		RiskItem = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.obtain_item";
		this.m.Name = "取得宝物";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		local camp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getNearestSettlement(this.m.Home.getTile());
		this.m.Destination = this.WeakTableRef(camp);
		this.m.Flags.set("DestinationName", camp.getName());
		local items = [
			"格哈特爵士的指骨",
			"圣母血瓶",
			"奠基者的裹尸布",
			"长者之石",
			"远见之杖",
			"太阳图章",
			"星图碟",
			"先祖卷轴",
			"石化年鉴",
			"伊斯特万爵士的外套",
			"丰收金杖",
			"先知笔记",
			"先祖战旗",
			"伪王图章",
			"纵欲长笛",
			"命运之骰",
			"丰产神物"
		];
		this.m.Flags.set("ItemName", items[this.Math.rand(0, items.len() - 1)]);
		this.m.Payment.Pool = 500 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"在%location%取得%item%"
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
				this.Contract.m.Destination.clearTroops();
				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.UndeadArmy, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setLootScaleBasedOnResources(100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());

				if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.m.Destination.setDiscovered(true);
				this.Contract.m.Destination.m.IsShowingDefenders = false;
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					this.Flags.set("IsRiskReward", true);
					local i = this.Math.rand(1, 6);
					local item;

					if (i == 1)
					{
						item = this.new("scripts/items/weapons/ancient/ancient_sword");
					}
					else if (i == 2)
					{
						item = this.new("scripts/items/weapons/ancient/bladed_pike");
					}
					else if (i == 3)
					{
						item = this.new("scripts/items/weapons/ancient/crypt_cleaver");
					}
					else if (i == 4)
					{
						item = this.new("scripts/items/weapons/ancient/khopesh");
					}
					else if (i == 5)
					{
						item = this.new("scripts/items/weapons/ancient/rhomphaia");
					}
					else if (i == 6)
					{
						item = this.new("scripts/items/weapons/ancient/warscythe");
					}

					this.Contract.m.RiskItem = item;
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"在%origin%%direction%面的%location%获取%item%"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.m.IsShowingDefenders = false;
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsRiskReward"))
					{
						this.Contract.setState("Return");
					}
					else
					{
						this.Contract.setScreen("LocationDestroyed");
						this.World.Contracts.showActiveContract();
					}
				}
				else if (this.TempFlags.get("GotTheItem"))
				{
					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;

				if (!this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);

					if (this.Flags.get("IsRiskReward"))
					{
						this.Contract.setScreen("RiskReward");
					}
					else
					{
						this.Contract.setScreen("SearchingTheLocation");
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
					properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
					properties.EnemyBanners.push(this.Contract.m.Destination.getBanner());
					this.World.Contracts.startScriptedCombat(properties, _isPlayerAttacking, true, true);
				}
			}

			function end()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull() && this.Contract.m.Destination.isAlive())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(null);
					this.Contract.m.Destination = null;
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
					if (this.Flags.get("IsFailure"))
					{
						this.Contract.setScreen("Failure1");
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
			Text = "{[img]gfx/ui/events/event_43.png[/img]%employer%迎接了你，并带你走向%townname%的广场。有一群农民在那里闲逛，但看到你来了，他们立刻打起精神开始说话，仿佛一直在等你似的。他们大多在用描述性的语言：高得像任何男人！盔甲前所未见！长矛锋利得像小贩的舌头！你抬手问他们在说什么。%employer%大笑。%SPEECH_ON%这儿的人说他们在%direction%方向一个叫%location%的地方看到些怪事。自然，他们不是无缘无故去那儿的。他们在找一个叫%item%的东西，那是镇子珍视的圣物，我们通过它祈求风调雨顺。%SPEECH_OFF%一个农民插嘴道。%SPEECH_ON%我们是听他的安排去找的！%SPEECH_OFF%%employer%点头。%SPEECH_ON%当然。既然他们失败了，或许你能成功？帮我把这个圣物弄来，我会为你的服务支付丰厚报酬。别在意他们编的小故事。我敢肯定没什么好担心的。%SPEECH_OFF% | [img]gfx/ui/events/event_62.png[/img]%employer%将你迎进他的房间，还给你倒了一杯水。 他带着腼腆的笑容递过来。%SPEECH_ON%要是我有麦酒或葡萄酒，我会请你喝点，但你知道我们现在的情况。%SPEECH_OFF%他抿了一口，清了清嗓子。%SPEECH_ON%当然，我不缺的是克朗，否则我们也不会在这谈话了，对吧？我需要你去离这儿%direction%边一个叫%location%的地方，取回一个叫%item%的圣物。很简单，不是吗？%SPEECH_OFF%你问这圣物有什么用。那人解释道。%SPEECH_ON%镇民向它祈祷。求个安宁，又或者求个婆娘，我不在乎。 他们相信它，这让他们有动力干活。光凭这点就值得拿回来。%SPEECH_OFF% | [img]gfx/ui/events/event_62.png[/img]你走进%employer%的房间，发现他正盯着一张偏远地区的地图。他摇了摇头。%SPEECH_ON%看到这儿这个点了吗？那是%location%。%townname%一直在供奉一个叫%item%的圣物，但镇民说它不见了，而且，不管什么原因，他们认为它在那儿。我没人手可雇去查看，因为去那里道路十分危险，而我付不起抚恤金，但你，佣兵，看起来能胜任这任务。你愿意去那儿为我们找到这个%item%吗？%SPEECH_OFF% | [img]gfx/ui/events/event_43.png[/img]你发现%employer%正在和一群农民说话。看到你，他让他们都安静下来。%SPEECH_ON%嘘，你们都安静。这位先生能解决我们的问题。%SPEECH_OFF%这位镇民把你拉到一边。%SPEECH_ON%佣兵，我们有点小麻烦。有个圣物我需要找到，一个叫%item%的玩意儿。我个人倒是不在乎那玩意，但这里的人向它祈求丰收和庇护。现在它不见了。而且不知道什么原因，人们认为它自己跑到了一个叫%location%的地方。没人敢去那儿，但你会去的，对吧？当然，有合适的报酬。%SPEECH_OFF% | [img]gfx/ui/events/event_62.png[/img]你发现%employer%正在和一位德鲁伊交谈，那人身披的形制更似野兽而非人类。以角为盔，以熊皮为甲，鹿蹄在他胸前晃荡作响，串成一条粗野的项链。他这模样相当引人注目。看到你，%employer%招手让你进来。%SPEECH_ON%佣兵！见到你真好——%SPEECH_OFF%德鲁伊在谈话中途把那人推开。他说话时声音颤抖，仿佛从洞穴深处传来。%SPEECH_ON%一个雇佣兵，哈！想必你也是个有信仰的人，不是吗？我们%townname%丢失了%item%。这件圣物对我们至关重要，因为通过它，我们可以与旧神交流，让我们的祈祷得到回应。它不知怎地被偷走带到了%location%。去那里把它取回来。%SPEECH_OFF%你瞥向%employer%，他点了点头。%SPEECH_ON%对，就是他说的那事情。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{找我们准没错。谈谈报酬吧。 | 谈谈价钱吧。 | 听起来很简单。报酬如何？}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{不感兴趣。 | 我们有更重要的事情要做。 | 我相信你能找到别人来干这活。}",
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
			ID = "SearchingTheLocation",
			Title = "%location%里",
			Text = "[img]gfx/ui/events/event_73.png[/img]{你进入遗迹的方式与其说是步入，不如说是攀爬，像一只试图直立行走的蝙蝠般蹒跚越过石砌结构。下到最深处，你看到了数以百计的陶罐、烂得只剩碎屑的古老战车，以及装满锈蚀盾牌和长矛的金属水盆。%randombrother%举起火把，将光芒投向墙壁。巨大的壁画绵延不绝，这些宏伟的艺术品描绘着你从未听闻的战役。你每走一步，似乎都在揭示另一段古老的胜利，直到最后，你来到一幅巨大的彩绘地图前。在那里，你看到一个大陆被一个帝国的统治所覆盖，其腹地镀金，边境漆黑。\n\n%randombrother%走了过来，手里拿着%item%。你点点头，告诉他是时候离开了。当你们两人转过身时，一个男人站在那里，一手持矛，一手持盾。又一个身影加入了他，接着又一个，他们的脚步带着金属的恶意踏在石地上。你朝另一位佣兵大喊快跑，两人匆忙逃离了遗迹，死亡行军的断续脚步声紧追在后。\n\n到了外面，你猛地转身，命令兄弟们准备战斗。还没等第一个佣兵来得及拔剑，一队装甲士兵便从遗迹中涌出，结成密集阵型，将长矛对准了你们。他们的军官伸出一根腐朽的手指，沙哑的声音让话语沉重压在你的胸口。%SPEECH_ON%帝国将起。伪王必死。%SPEECH_OFF% | 进入遗迹的洞口仅容一人通过。你担心如果所有人都同时进去会被卡住，到时%companyname%就跟一群困在狭窄隧道里的老鼠差不多，那基本上就等于把大伙给害死了。于是，你只派了%randombrother%进去，他知道自己要找什么，而且你相信万一发生什么事他能照顾好自己。\n\n几分钟后，你听到那人挣扎着爬回来的声音——而且听起来非常匆忙。他大喊求助，你和另外几个佣兵把手伸进洞里。他抓住手，你们一起把他拽了出来。他拿到了%item%，但脸上带着惊恐的表情。他翻身爬起来，急忙喊道。%SPEECH_ON%快！拿起武器！%SPEECH_OFF%当佣兵们朝洞里张望看是否有东西出来时，你问那位兄弟看到了什么。他摇了摇头。%SPEECH_ON%我不知道，长官。里面是个陵墓，我完全看不出来是什么人的。到处都是盔甲和长矛，还有一副从地板延伸到屋顶的巨大壁画，上面是一个横跨整个世界的超大帝国！ 然后……然后他们就开始从墙里出来了。我尽可能快地逃了出来然后……%SPEECH_OFF%他甚至没来得及说完，原本洞口的那堆碎石就动了起来。先是几块碎石滚落，接着突然全向外炸了出来。一股满怀敌意的部队站在那里——全副武装、盔甲精良的士兵结成阵型，长矛架在盾牌上，迈着统一的步伐向前推进。他们的首领直指着你。%SPEECH_ON%帝国将起。伪王必死。%SPEECH_OFF%你从未听过比这更确凿的战斗宣言，立即让兄弟们准备战斗。 | 你和%randombrother%一同冒险进入遗迹。%item%很容易找到，甚至有点太容易了，但有其他东西完全吸引了你的注意力。 石地板上散落着陶罐。每一件陶罐都放满了长矛，墙上则挂着大量盾牌，挂钩看起来古老而满是锈蚀，一副连蛛网都撑不住的样子。突然，%randombrother%抓住了你的手臂。%SPEECH_ON%长官。有麻烦。%SPEECH_OFF%他指向大厅深处，你看到一个人站在那里，他的动作生硬而迅速，仿佛正在适应他的盔甲。突然，他猛地抬起头盯着你。尽管他站得很远，但他的声音传入耳朵却感觉就在身边。%SPEECH_ON%伪王竟敢擅闯此地？帝国必将再起，但首先你必须死。%SPEECH_OFF%这无疑是战斗宣言，你抓住那佣兵迅速逃离。你没跑到外面多远，佣兵们甚至未经你下令就拿起了武器：跟在你后面的是一队身着前所未见盔甲的士兵。他们以龟甲般的阵型前进，盾牌高举相连，为整只队伍提供防护。根据遗迹里那家伙的话，你毫不怀疑他们是来杀死你和战团其余成员的！ | 你进入遗迹，相当容易地找到了%item%。当你转过身时，一个身着古旧盔甲的高大男人站在那里，手持长矛，空荡荡的眼窝俯视着你。他将长矛向后摆动。%SPEECH_ON%伪王必死。%SPEECH_OFF%长矛向前刺来。%randombrother%跃身而过，将其格挡在地，矛尖在石地板上擦出几点火花。你看着那个亡灵，一条蠕虫正从它的鼻孔中钻过。它再次开口。%SPEECH_ON%伪王必……%SPEECH_OFF%你迅速拔剑，一剑削掉了那古老亡灵的脑袋。它的头骨和头盔一齐哐当一声掉在地上。还没来得及细查，%randombrother%就抓住你叫你快跑：更多的亡灵正从墙壁中出现，挣脱了陵墓那花岗岩般的禁锢。\n\n 一到外面，你立刻命令战团其余成员组成战斗阵型。 | 你派了几个人进入遗迹寻找%item%。他们全都匆忙返回，这很不寻常，因为他们通常倾向于磨蹭度日，消磨时光，轻松赚取一天的薪水。幸运的是，其中一人手里拿着圣物。不幸的是，他们个个面如死灰，仿佛见了鬼。他们无需解释恐惧的源头，因为一群动作迅捷、盔甲铿锵作响的亡灵已从遗迹中冒出，将长矛对准了你的战团。 | 抵达遗迹时，你本以为会有些土匪在附近徘徊。结果，取得%item%简直不能再容易了。至少，在一大群披甲亡灵出现，高喊着“伪王”并要取你项上人头之前，你是这么想的。准备战斗！ | 找到并打包%item%比意料之中的要容易。但遇到一群头重脚轻、身着古朴盔甲、手持长矛并以比王国中薪酬最高的军队还要严密的军事阵型出现的亡灵……就纯属意料之外了。准备战斗！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						this.TempFlags.set("GotTheItem", true);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "LocationDestroyed",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_46.png[/img]{战斗结束，%item%也已到手，你命令兄弟们准备返回%employer%处。你不完全确定刚才攻击你的是什么人或什么东西，但现在，是时候领取报酬了。 | 战斗结束后，你审视着袭击者。他们身披你从未见过的盔甲。%randombrother%试图将一具尸体的头盔撬开，但无济于事。他难以置信地看着尸体。%SPEECH_ON%就好像是卡住了，或者成了他身体的一部分似的。%SPEECH_OFF%你命令兄弟们拿好装备，准备返回%employer%处。不管这些人是谁，你来这是为了拿到%item%。既然东西已经到手，现在是时候领赏了。 | 你已经拿到了%item%，但代价是遭遇了一种前所未见的邪魔。它们身披盔甲，看上去死了，却能以严密的阵型行动。%randombrother%举起%item%，询问下一步该怎么做。你告知兄弟们，是时候回去找%employer%了。 | 你看了看%item%，又看了看为它攻击你的那些人。或者，至少你认为他们是为此攻击你的。敌人的军官似乎说了些什么，但你记不清具体内容了。唉，算了，是时候回去找%employer%领酬金了。 | 你不是很确定刚才你遭遇的到底是什么。%randombrother%问你是否知道他们说的话什么意思。%SPEECH_ON%看起来他们特别针对你，长官。%SPEECH_OFF%你点点头，告诉他你也不清楚那人说了什么，但这无关紧要。你拿到了%item%，是时候返回%employer%那里领取你的报酬了。 | %item%已到手，但代价是什么？奇怪的人——如果还能称之为人的话——袭击了战团，而且你发誓其中一人特别指出了你，仿佛你犯下了什么超越时空的罪行。哦，好吧。你不是那种纠结于这些事情的人。你来到这里是为了圣物，而你已得到它，还有丰厚的报酬在%employer%手里等着你。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们回去吧。",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "RiskReward",
			Title = "%location%里",
			Text = "[img]gfx/ui/events/event_57.png[/img]{你踏入%location%，仔细环顾四周。没过多久，%randombrother%就指出了%item%——那圣物就放在一个布满青苔和蛛网的石头基座上。他还指向房间对面的另一样东西：一件看起来相当不错的%risk%，装饰在一座高大雕像的身上。\n\n 这地方的其余部分都破败不堪，看起来随时会塌在你们头上。那边的%risk%实在令人起疑。 | %item%的位置一目了然，但房间里还有别的东西吸引了你的注意。一座巨大雕像旁，摆放着一个看起来非常独特的%risk%。当然，这不禁让人想问，它为什么会在那儿？虽然你觉得显然应该去把它拿走，但某种直觉告诉你，这或许并非明智的决定。 | 好了，你找到了%item%。这比你想象的要容易得多。但这里还有别的东西。你发现一个闪亮的%risk%装饰在一座高大的人形雕像上，那雕像面容空白。你不确定一尊雕像为什么会配有这种东西，但它就在那儿。而且它看起来一直都在那里，这就引出了一个问题：为什么？ | %item%很容易就找到了，但当你准备去拿镇民的圣物时，你瞥见一个闪亮的%risk%装饰在一座高大而不祥的人形雕像上。你的第一个念头是派个佣兵去把它拿过来，但随即你又想，它为什么会在那儿？}  或许%companyname%应该只专注于身上的任务？",
			Image = "",
			List = [],
			Options = [
				{
					Text = "只拿走%item%。",
					function getResult()
					{
						return "TakeJustItem";
					}

				},
				{
					Text = "既然来了，也顺手拿走%risk%吧。",
					function getResult()
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "TakeRiskItemBad";
						}
						else
						{
							return "TakeRiskItemGood";
						}
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TakeJustItem",
			Title = "%location%里",
			Text = "[img]gfx/ui/events/event_57.png[/img]%employer%要求你拿到%item%，而你只打算听吩咐办事。 {%randombrother%赞同这个做法。%SPEECH_ON%我觉得我们最好别碰那个%risk%。我这辈子没见过比那更明显的陷阱了。%SPEECH_OFF% | %randombrother%摇摇头，对你的犹豫报以嘲笑。%SPEECH_ON%你怕那个大雕像是吧？长官，我还以为你胆子更大些呢。%SPEECH_OFF% | 你拿到圣物后，%randombrother%用手肘轻轻顶了你一下。%SPEECH_ON%有人怕那个又大又坏的雕像了，嗯？来吧，让我去拿。我们拿到它，两秒钟就能出门！%SPEECH_OFF%你善意地提醒这位佣兵谁才是负责人，以免他再继续“开玩笑”。 | 圣物已在你手中，%randombrother%只是点了点头。%SPEECH_ON%做得好，长官。要我说，咱们最好别碰那个%risk%。那亮闪闪的小玩意儿除了麻烦什么都不是。去拿它就是嫌命太长了。%SPEECH_OFF% | %randombrother%瞪着%risk%啐了一口，清了清嗓子，用手抹过他那凌乱的脸。%SPEECH_ON%没错。咱们最好别碰它。要是我在森林中间发现一堆金子，我觉得我得小心一点。这儿也是一个道理。%SPEECH_OFF% | %randombrother%同意你的决定。%SPEECH_ON%对，咱们就别碰那个%risk%了。这世上没有什么东西是免费，没有。那种闪闪发光的东西就更加不会有免费的了。绝对没有，长官。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "真简单。",
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
			ID = "TakeRiskItemGood",
			Title = "%location%里",
			Text = "[img]gfx/ui/events/event_57.png[/img]{手里拿着%item%，你觉得不妨把%risk%也一并拿走。%randombrother%上前照做，小心翼翼地从那雕像上取下了那部件。金属部件刚一松动取下，他就停顿下来，准备好万一雕像活过来给他当头一击。然而，什么都没发生。他紧张地笑了笑。%SPEECH_ON%轻、轻松搞定！%SPEECH_OFF%随着弟兄们们松了一口气，你告诉他们准备回去找%employer%。 | 当你拿到%item%时，你瞥了一眼%risk%，心想何乐而不为。你爬上雕像，凝视着它的脸庞。无论原型是谁，那人有着斧凿般的颧骨和足以挂件外套的硬朗下巴。你无视他的面容特征，一把抓过%risk%并举着它，等待某事发生。然而什么也没发生。%randombrother%笑了起来。%SPEECH_ON%你要不要跟那雕像打声招呼？%SPEECH_OFF%你拍了拍雕像的头，爬了下来。战团现在该返回%employer%那里了。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "真简单。",
					function getResult()
					{
						this.Contract.m.RiskItem = null;
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				this.World.Assets.getStash().add(this.Contract.m.RiskItem);
				this.List.push({
					id = 10,
					icon = "ui/items/" + this.Contract.m.RiskItem.getIcon(),
					text = "你获得了" + this.Contract.m.RiskItem.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "TakeRiskItemBad",
			Title = "%location%里",
			Text = "[img]gfx/ui/events/event_73.png[/img]{你派%randombrother%爬上雕像去取%risk%。他在上面时，你注意到%employer%丢失的小饰物在基座上微微晃动。你伸手想扶稳它，但它非但没有立住，反而如尘埃般从你的指缝间吹散。粉末状的残骸像雾构成的蛇一样缠绕着你的手臂。你向后跃开，那烟雾射向雕像，猛地钻入其双眼——那双眼睛此刻变得鲜红。石头开裂、崩落。那佣兵跳开了。四周不断有身影正从墙壁中浮现，旁边的雕像接连碎裂开来，从中走出模样古怪、身披盔甲、肩扛长矛的士兵。\n\n你命令所有人准备战斗！ | 你不可能拒绝像%risk%这样的东西。你爬上雕像的面部伸手去够它，但就在金属触及你手指的一刹那，一阵隆隆声响起，雕像开始摇晃。%randombrother%大喊，你转过身。他正指向%item%——它正在你眼前崩解成粉末！你只能眼睁睁看着这粉末凝聚成一缕烟，如同被赋予生命般，在房间里盘旋，嗖地掠过你的脸，钻进了雕像的鼻子。它的双眼射出红光，你立刻跳开。一个佣兵来到你身边，武器已然出鞘。%SPEECH_ON%长官，长官！看！%SPEECH_OFF%有身影正从墙壁中浮现！雕像如同悬在指间的牵线木偶般蹒跚向前。慢慢地，每一个都褪去了石质的外壳，化身为模样古怪、身披盔甲、手持长矛的士兵。你迅速命令手下结成战斗阵型，因为无论你刚才释放的是什么，它都绝无善意！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "集合！",
					function getResult()
					{
						this.Contract.m.RiskItem = null;
						this.Flags.set("IsFailure", true);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination, false);
						return 0;
					}

				}
			],
			function start()
			{
				this.World.Assets.getStash().add(this.Contract.m.RiskItem);
				this.List.push({
					id = 10,
					icon = "ui/items/" + this.Contract.m.RiskItem.getIcon(),
					text = "你获得了" + this.Contract.m.RiskItem.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer%在城镇广场与你碰面。你递过%item%，那人将其捧在怀中，像怀抱以为丢失的婴儿般。与圣物尴尬地拥抱片刻后，他将其高高举起，让镇民们都能看到。他们欢呼了很长时间。真的，太长了。你不得不用手肘碰了碰%employer%提醒他付钱给你。 | 你发现%employer%正在猪圈里瞎忙活。他踢着那些肥母猪，不过它们似乎更关注饲料而非踹在屁股上的皮靴头。你大声清了清嗓子。%employer%转过身，一看到圣物眼睛立刻睁大了。他跳过一头猪，接过了%item%。他向聚集过来的镇民们呼喊，他们开始向众神祈祷怜悯。自然，没有一个人感谢你。你不得不提醒%employer%他欠你的克朗。拿到报酬后，你以最快的速度离开了。 | 你发现%employer%正坐在城镇广场上，双臂伸向天空，双眼紧闭，口中喃喃祈祷。镇民们围跪在他四周，做着同样的事。你捡起一块石头投向风向标，叮当的响声和锈铁的旋转声吸引了所有人的注意。\n\n你高举圣物让所有人都能看到。%employer%跳起来接过了%item%。人们欣喜地欢呼，谈论着即将到来的好事。你的报酬交到了你手中——这，说实话，才是你认为的“好事”。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "镇民现在看来心情愉快。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "获得了" + this.Flags.get("ItemName"));
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
						}

						return 0;
					}

				}
			],
			function start()
			{
				local reward = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + reward + "[/color]克朗"
				});
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/high_spirits_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_43.png[/img]{%townname%的镇民们正热切期盼你的归来。可惜的是，你并没有他们急需的那个圣物。%employer%比民众们先一步看出了你的失败，他在镇口与你见面，低声对你说道。%SPEECH_ON%我想你并没有拿到%item%，对吧？%SPEECH_OFF%你试图解释发生的一切，但他似乎并不想听。%SPEECH_ON%无所谓了。 佣兵。显然你拿不到报酬了，而且也不能让镇民们知道你的失败，免得他们精神崩溃。他们依赖偶像来在这世上寻求慰藉。我得自己想个办法了，嗯，祈祷这办法能管用吧。再见。%SPEECH_OFF% | %employer%在一群鹅旁边与你碰面。他正用手给它们喂食，同时，一个男孩偶尔会随意地走过来，抓起一只带去宰杀。那人对你热情地笑了笑，但他的兴奋很快就变味了。%SPEECH_ON%我没看到圣物。我猜你没能拿到它，对吗？%SPEECH_OFF%你只是简单地点了点头作为回答。他张开双臂，有些困惑。%SPEECH_ON%那你为什么还回来？镇民们都认识你。他们知道你是去找圣物的。你该在人们发现你空手而归之前离开。%SPEECH_OFF% | 你空手回到%employer%那里。他把你拉到一边低声说。%SPEECH_ON%你究竟为什么还要回来？你难道不明白这些镇民给那尊偶像赋予了多重的意义吗？没有它来崇拜，他们就无所信仰。信仰坚定的人需要有个地方寄托信仰。如果他找不到地方寄托，他所找到的就只有他自己。而就像丑陋的野兽凝视镜子，我们还不想马上欣赏因神像缺失而映照出的愤怒与困惑。趁人们还没发现你没带着%item%回来，快走吧，佣兵。%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "噢，好吧……",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "没能取得" + this.Flags.get("ItemName"));
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
			"location",
			this.m.Flags.get("DestinationName")
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Destination.getTile())]
		]);
		_vars.push([
			"item",
			this.m.Flags.get("ItemName")
		]);
		_vars.push([
			"risk",
			this.m.RiskItem != null ? this.m.RiskItem.getName() : ""
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull() && this.m.Destination.isAlive())
			{
				this.m.Destination.getSprite("selection").Visible = false;
				this.m.Destination.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
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
			return true;
		}
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

		if (this.m.RiskItem != null)
		{
			_out.writeBool(true);
			_out.writeI32(this.m.RiskItem.ClassNameHash);
			this.m.RiskItem.onSerialize(_out);
		}
		else
		{
			_out.writeBool(false);
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

		local hasItem = _in.readBool();

		if (hasItem)
		{
			this.m.RiskItem = this.new(this.IO.scriptFilenameByHash(_in.readI32()));
			this.m.RiskItem.onDeserialize(_in);
		}

		this.contract.onDeserialize(_in);
	}

});
