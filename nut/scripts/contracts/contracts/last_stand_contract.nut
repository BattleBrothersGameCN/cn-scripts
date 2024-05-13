this.last_stand_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		IsPlayerAttacking = true
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

		this.m.Type = "contract.last_stand";
		this.m.Name = "保卫定居点";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		this.m.MakeAllSpawnsResetOrdersOnContractEnd = false;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		if (this.m.Home == null)
		{
			this.setHome(this.World.State.getCurrentTown());
		}

		this.m.Flags.set("ObjectiveName", this.m.Origin.getName());
		this.m.Name = "防御" + this.m.Origin.getName();
		this.m.Payment.Pool = 1600 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"前往 %direction% 的 %objective% ",
					"抵御亡灵"
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

				if (r <= 40)
				{
					this.Flags.set("IsUndeadAtTheWalls", true);
				}
				else if (r <= 70)
				{
					this.Flags.set("IsGhouls", true);
				}

				this.Flags.set("Wave", 0);
				this.Flags.set("Militia", 7);
				this.Flags.set("MilitiaStart", 7);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
					this.Contract.m.Origin.setLastSpawnTimeToNow();
				}
			}

			function update()
			{
				if (this.Contract.m.Origin == null || this.Contract.m.Origin.isNull() || !this.Contract.m.Origin.isAlive())
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
					return;
				}
				else if (this.Contract.isPlayerNear(this.Contract.m.Origin, 600) && this.Flags.get("IsUndeadAtTheWalls") && !this.Flags.get("IsUndeadAtTheWallsShown"))
				{
					this.Flags.set("IsUndeadAtTheWallsShown", true);
					this.Contract.setScreen("UndeadAtTheWalls");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Origin) && this.Contract.m.UnitsSpawned.len() == 0)
				{
					this.Contract.setScreen("ADireSituation");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Running_Wait",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"保卫 %objective% 抵御亡灵"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
					this.Contract.m.Origin.setLastSpawnTimeToNow();
				}
			}

			function update()
			{
				if (this.Contract.m.Origin == null || this.Contract.m.Origin.isNull() || !this.Contract.m.Origin.isAlive())
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Contract.m.UnitsSpawned.len() != 0)
				{
					local contact = false;

					foreach( id in this.Contract.m.UnitsSpawned )
					{
						local e = this.World.getEntityByID(id);

						if (e.isDiscovered())
						{
							contact = true;
							break;
						}
					}

					if (contact)
					{
						if (this.Flags.get("Wave") == 1)
						{
							this.Contract.setScreen("Wave1");
						}
						else if (this.Flags.get("Wave") == 2)
						{
							this.Contract.setScreen("Wave2");
						}
						else if (this.Flags.get("IsGhouls"))
						{
							this.Contract.setScreen("Ghouls");
						}
						else if (this.Flags.get("Wave") == 3)
						{
							this.Contract.setScreen("Wave3");
						}

						this.World.Contracts.showActiveContract();
					}
				}
				else if (this.Flags.get("TimeWaveHits") <= this.Time.getVirtualTimeF())
				{
					if (this.Flags.get("IsGhouls") && this.Flags.get("Wave") == 3)
					{
						this.Flags.set("IsGhouls", false);
						this.Flags.set("Wave", 2);
						this.Contract.spawnGhouls();
					}
					else
					{
						this.Contract.spawnWave();
					}
				}
			}

		});
		this.m.States.push({
			ID = "Running_Wave",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"保卫 %objective% 抵御亡灵"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
					this.Contract.m.Origin.setLastSpawnTimeToNow();
				}

				foreach( id in this.Contract.m.UnitsSpawned )
				{
					local e = this.World.getEntityByID(id);

					if (e != null)
					{
						e.setOnCombatWithPlayerCallback(this.onCombatWithPlayer.bindenv(this));
					}
				}
			}

			function update()
			{
				if (this.Contract.m.Origin == null || this.Contract.m.Origin.isNull() || !this.Contract.m.Origin.isAlive())
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Contract.m.UnitsSpawned.len() == 0)
				{
					if (this.Flags.get("Wave") < 3)
					{
						local militia = this.Flags.get("MilitiaStart") - this.Flags.get("Militia");
						this.logInfo("民兵损失：" + militia);

						if (militia >= 3)
						{
							this.Contract.setScreen("Militia1");
						}
						else if (militia >= 2)
						{
							this.Contract.setScreen("Militia2");
						}
						else
						{
							this.Contract.setScreen("Militia3");
						}
					}
					else
					{
						this.Contract.setScreen("TheAftermath");
					}

					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatWithPlayer( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
				local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
				p.Music = this.Const.Music.UndeadTracks;
				p.CombatID = "ContractCombat";

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull() && this.World.State.getPlayer().getTile().getDistanceTo(this.Contract.m.Origin.getTile()) <= 4)
				{
					p.AllyBanners.push("banner_noble_11");

					for( local i = 0; i < this.Flags.get("Militia"); i = ++i )
					{
						local r = this.Math.rand(1, 100);

						if (r < 60)
						{
							p.Entities.push({
								ID = this.Const.EntityType.Militia,
								Variant = 0,
								Row = -1,
								Script = "scripts/entity/tactical/humans/militia",
								Faction = 2,
								Callback = null
							});
						}
						else if (r < 85)
						{
							p.Entities.push({
								ID = this.Const.EntityType.Militia,
								Variant = 0,
								Row = -1,
								Script = "scripts/entity/tactical/humans/militia_veteran",
								Faction = 2,
								Callback = null
							});
						}
						else
						{
							p.Entities.push({
								ID = this.Const.EntityType.Militia,
								Variant = 0,
								Row = 2,
								Script = "scripts/entity/tactical/humans/militia_ranged",
								Faction = 2,
								Callback = null
							});
						}
					}
				}

				this.World.Contracts.startScriptedCombat(p, this.Contract.m.IsPlayerAttacking, true, true);
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_combatID == "ContractCombat" && _actor.getFlags().has("militia"))
				{
					this.Flags.set("Militia", this.Flags.get("Militia") - 1);
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

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = false;
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{你发现 %employer% 帮助一个年轻的贵族男孩将弓箭对准稻草人。 他让男孩伸直背，命令他在射击前深呼吸。 这个业余弓箭手点头，照做了。 箭被发射出去。 它摇晃着飞了出去，旋转着进入一个马厩，几匹马受到惊吓发出呜呜声。 贵族拍拍男孩的背。%SPEECH_ON%相信我，我第一次的时候更糟。 坚持下去。我一会儿就回来。%SPEECH_OFF%贵族走近你，摇了摇头，压低了声音。%SPEECH_ON%事情很可怕，雇佣兵。 年轻人不知道这些天潜伏着什么危险，但你知道。 我们有一个定居点 %objective% 在这里的 %direction%，被…嗯，这个世界的弊病所包围。 我没有多余的人，这就是你到来的原因。 去那里拯救村庄，你会得到很好的报酬，我可以向你保证！%SPEECH_OFF% | %employer% 被发现盯着他的一把剑。 他把它拔了出来，在钢铁般的倒影中盯着他的脸。%SPEECH_ON%当我被教导如何使用其中一种时，它是为男性设计的。 现在？人们谈论死者，谈论绿皮，谈论无法估量的野兽！%SPEECH_OFF%他猛地将剑插进鞘里，然后扔在他的桌子上。 他用手梳理头发。%SPEECH_ON%%objective% %direction% 离这里需要你的帮助。 已经被这些…这些东西包围了！ 我不知道他们是什么，只知道他们杀啊杀啊杀啊！ 我没有多余的人，但如果你去那里帮助这个小镇，那么你将得到最丰厚的回报！%SPEECH_OFF% | 你发现 %employer% 坐在一位修道院院长和一位书记员之间，他们用颤抖着下巴、咬牙切齿的老人声音互相大喊大叫。 既然死者都出现了，生死存亡的问题就引起了相当激烈的争论。 贵族看到你，跳起来。 他急急忙忙向你走来，争论在背后激烈地进行着。%SPEECH_ON%感谢旧神，你在这里，雇佣兵。 只是在这里的 %direction%，%objective% 被一群可怕的军队围攻。 亡灵，肮脏的东西，我不知道，我只知道我没有人来保护城镇。 去那里确保那些人是安全的，我会付钱给你的！%SPEECH_OFF% | 你发现 %employer% 监督一群司事将棺材放入地下。 棺材被牢牢地钉上了，几乎是匆匆忙忙地钉好了：钉子钻开了螺丝，把木头弄弯了，边上还有刮痕。 看到你，贵族走了过来。%SPEECH_ON%那个盒子的居民决定回来。 杀了一个孩子和一条狗。 在卫兵放回原位之前，差点杀了另一个。%SPEECH_OFF%一股黑色的液体从棺材底部喷涌而出。 掘墓人跳开，砰的一声把板条箱直接扔进了坟墓里。%employer% 摇头。%SPEECH_ON%随着所有这些“亡灵”的爆发，我的力量已经被分散了。 我刚刚得到消息 %objective% 就是这里的 %direction% 是另一个受到攻击的目标。 佣兵，你会去那里帮忙拯救它吗？%SPEECH_OFF% | 你发现 %employer% 研究散落在他办公桌上的一堆书。 他摇着头，脖子的每一次扭动似乎都在翻页。 他心烦意乱，急忙招手叫你进去。%SPEECH_ON%别开玩笑了，佣兵，我们没时间了。 我需要你去 %direction% 的 %objective%。 我的鸟告诉我它受到了攻击，更多的这些该死的“死者”复活了，如果这真的是这样说的话。 你有兴趣去吗？ 你的付出会得到更多的回报。%SPEECH_OFF% | 你发现 %employer% 看着一些石匠把锋利的石头放在一起。他和你握手。%SPEECH_ON%再建一座修道院，佣兵，看起来怎么样？%SPEECH_OFF%看起来不错，但你指出路对面还有另一个修道院。贵族笑了。%SPEECH_ON%死者再次在地上行走，周围没有足够的长椅来坐下受惊的人们。 听着，我把你叫到这里是因为我的部队分散在试图处理这个…亡灵的奇怪之处。 有一个小镇在这里的 %direction%，%objective%，迫切需要帮助。 我的鸟儿告诉我它受到了攻击，而你似乎正是有兴趣拯救它的人。 当然是有代价的。%SPEECH_OFF% | %employer%，一位司库和一位指挥官正在交谈。 司库说有很多克朗，但指挥官直言不讳地说周围没有人可以付钱打仗。 你，就像你是魔鬼一样，进入房间并立即被谈论。%SPEECH_ON%佣兵！立即需要你的服务！ 我们有一个村庄在这里的 %direction%，一个叫 %objective% 的地方，,就是被这些攻击，呃，他们是什么？%SPEECH_OFF%指挥官倾身向贵族低声回答。他后退。%SPEECH_ON%受到的攻击来自…“亡灵。”当然。 你愿意去那里保护那些可怜的人吗？%SPEECH_OFF% | 你最终发现 %employer% 在他的马厩里。 他正在给马装上马鞍，很快就意识到你在保持距离。%SPEECH_ON%我们害怕吗，佣兵？%SPEECH_OFF%耸肩，你告诉他你从不关心野兽。 贵族耸耸肩，然后骑上马，双腿越过烛台摆动。%SPEECH_ON%随便你。我的鸟告诉我 %objective%的麻烦，那些麻烦是一大群亡灵在敲门，我不认为他们在给那些镇民送牛奶。 如果你去那里帮助保护村庄，你回来时会有一个大袋报酬等着你。%SPEECH_OFF% | %employer% 被发现走在他的防御工事的墙上。 他身边的守卫，个个身形异常挺拔，背脊挺直，目光尽职尽责的寻找危险。 贵族一见你，就向你招招手。 你们一起凝视着雉堞之间。 大地在你面前展开，巨大的森林变成了点，山脉变成了箭头，鸟儿成群结队。%SPEECH_ON%%direction% 离这里的 %objective%。信使告诉我，它正受到某种难以置信的力量的攻击，确切地说是亡灵。 是的，太难以置信了。无论攻击他们的城墙，我都没有人来处理。 但是你，佣兵，你的服务在这里最合适的。 你会感兴趣吗？%SPEECH_OFF% | 你发现 %employer% 和一个憔悴的书记员盯着石板上的一具无头尸体。 它的头在一个角落里，眼球倾斜，钢棒从它半雕刻的头骨中伸出来。 看到你，贵族伸出了邀请的手。%SPEECH_ON%没什么好怕的，佣兵。 我相信你已经听说过，死者再次在大地上行走，随之而来的是关于原因的大量猜测。%SPEECH_OFF%书记员抬起头，打断了他的话。%SPEECH_ON%或者怎么…%SPEECH_OFF%微笑着，贵族继续道。%SPEECH_ON%反正，离这里 %direction% 的 %objective% 被这些怪物袭击，呃，以前的人类？ 但我还没人送救济。 然而，你非常适合这份工作。 你愿意接受吗？%SPEECH_OFF% | %employer% 当你进入他的房间时，他正在听书记员的耳语。 书记员用黄疸的眼睛看了你一眼，然后继续他的谈话。 等他说完，两个人都点了点头，年长者离开了。 他走的时候不怎么看你。%employer% 喊出。%SPEECH_ON%很高兴你在这里，佣兵！ 现在真的是可怕的时刻。 我的人散布在这片土地上，处理着各种可怕的罪恶。 我敢肯定你已经听说过，但是那些“死者”，或者不管他们是什么，他们还是会再走的。 他们正在攻击在 %direction% 的 %objective%。 没有多余的人手，我就靠你了，佣兵。 你会帮助拯救这个小镇吗？%SPEECH_OFF% | %employer% 正在聆听一群农民的恳求。 当贵族愤怒地挥手示意他们离开时，你才到了谈话的末尾。 随着外行人的喊叫，守卫们紧锣密鼓地护送他们出去，暂时是和平的，如果他们愿意的话，或者暴力地护送他们出去。 他们走出了门，没有进一步的抗议，尽管一名农民看了你一眼，嘴里说“帮帮我们”，然后转身离开。%employer% 挥挥手。%SPEECH_ON%好吧，见鬼，如果它不是佣兵！ 很准时，我贪财的朋友。 我有一个小镇在这里的 %direction%，%objective%，急需帮助。 现在，无论如何他们都说，它处于亡灵的围攻之下。 如果你去那里帮助保卫它，这里有一大袋克朗等着你。 你说什么，哼？%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{对你来说值多少？ | 只要价钱合适，我们来守护%objective%...}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{这不值得。 | 我恐怕%objective%只能靠自己了。}",
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
			ID = "UndeadAtTheWalls",
			Title = "在 %objective%…",
			Text = "[img]gfx/ui/events/event_29.png[/img]{接近%objective%，%randombrother%在前方高呼。%SPEECH_ON%队长，快点！%SPEECH_OFF%你赶紧走过去往前看。那个城镇完全被一大片苍白的、摇摇晃晃、呻吟不断的不死族包围了！%companyname%必须要穿过他们才能进入。 | 有一个人朝着%companyname%这边奔跑过来。他用一只胳膊抱着头，头顶染着深红色的血。他大喊大叫。%SPEECH_ON%走，走开！这里只有恐怖！%SPEECH_OFF% %randombrother%把这个陌生人扔在地上，拔出武器将他压住。当你往前看时，你发现%objective%已经被很多不死族包围了。%companyname%必须要快速行动！ | 你赶在最后一刻赶到：%objective%的城墙已经遭到不死族的攻击！ | 走过一条小道，你突然停下来。在你前进的方向上，%objective%被一大群不死族包围。在你身边，有几个奇怪地被困在了一群不死族中间。%companyname%需要打进%objective%！ | %objective%的城墙异常灰暗——等等，那不是木头，是亡灵！你可怕地发现，苍白的怪物已经开始攻击，但你还有时间拯救%objective%，并奋力进攻。拔出剑，你下令%companyname%准备战斗！ | 无形的一伙亡灵已经在%objective%城墙外徘徊。你能看到防御者的头探出防线，尽力不暴露自己。拔出剑，你告诉%companyname%，他们必须挺身而战。 | 有几只亡灵已经来到了%objective%的门口！守门的士兵向你挥手示意，然后指了指地。看来，可怕的怪物还没有开始攻击，因为他们不知道？你不确定，但唯一可以确定的是，%companyname%只有一条进入城池的路，那就是用剑！ | 幸运的是，你发现%objective%仍然屹立不倒。不幸的是，城墙正在被一群苍白的亡灵攻击。%companyname%必须奋力杀入城中！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						this.Contract.spawnUndeadAtTheWalls();
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ADireSituation",
			Title = "在 %objective%…",
			Text = "[img]gfx/ui/events/event_79.png[/img]{你发现守卫们在%objective%内看起来好像已经有好几周都没有睡觉了，但他们却在微笑。显然，你们光怪陆离的试图到达前门至少给他们提供了一点娱乐。 | 跌跌撞撞地，%companyname%最终通过了前门。在里面，守卫们有点失落，但又带着一丝幽默感，看起来好像跟着怪异玩笑一起从可怕的战斗中走出来。其中一个人在你肩膀上鼓了一下掌。%SPEECH_ON%雇佣兵，你刚才的表演真是太搞笑了，我下面的人都需要这么一笑。谢谢你。%SPEECH_OFF% | 四周看来，守卫们都脆弱而单薄，守卫着几乎半死不活的镇民。泥泞的街道上到处都是垃圾、动物尸体和屎。妇女和儿童正在一处临时墓地哭泣：一个沟渠上方有一张罗列名字的卷轴，为了加入新的名字，用新墨水重新为之更新。 | 你进入%objective%的大门，发现几个守卫手扶长矛站岗。他们的衣服像窗帘一样在骨架周围飘动。一股饥饿感在空气中弥漫着，你身上弥漫着的健康气息引来了他们眼馋的目光。其中一名防御者友好地跟你打招呼。%SPEECH_ON%我们很疲惫，又有点饿，但我们会撑过去的。我们依然会战斗到底，你别怀疑这点。%SPEECH_OFF% | 当你穿过%objective%的大门，一只狗会是你的第一个问候者，舔舔你的腿并深深地闻着你的裤子。一个男人突然大喊着，握着棍子，很快人和动物一起溜到了泥泞的路上，两者似乎都在狂吠。那只杂种狗躲过了饥饿的人群的慢一拍的抓捕，消失得无影无踪。一个面带微笑的卫兵走了过来，用棍子支撑着自己。%SPEECH_ON%晚上好，佣兵。食物库存有点低，那只狗在一个空腹的国度里是合情合理的目标。%SPEECH_OFF%你问他们还能不能打仗，那个男人笑了 %SPEECH_ON% 哎呀，战斗是我们这里唯一剩下的了！%SPEECH_OFF% | 通过%objective%的前门进入，就像走过常态的纱幔进入地狱的深渊。村民蹒跚而行，除了变得越来越饥饿，什么也做不了，守卫们分享着笑话，就像分享食物一样，痛苦地笑着，一边抓紧他们的肚子。防御负责人走了过来。他胡须拉碴，满是疤痕，嘴巴呆着，眼睛看上去很劳累。虽然他就站在你一英尺之外，但就像他正从另一个世界里凝视着你。%SPEECH_ON%很高兴你到了，佣兵。我们这些天肯定需要你的帮助。%SPEECH_OFF% | 你穿过%objective%的大门，发现地狱本身在等待着你。守卫们如同疯子支撑着的骷髅站在那里准备战斗，村民们则懒洋洋地站着或趴在地上或脸朝墙壁。孩子们站在茅草屋顶上翻找草堆里的虫子。防御队的队长直言不讳地欢迎你。%SPEECH_ON%谢了，佣兵，但你应该呆在家里。%SPEECH_OFF% | 前门的门扉缓缓打开，门卫们费力地推动着机关。你走进小镇，发现一群性格低沉的人正在小路边挖一个巨大的坑。他们把尸体丢进去，并准备着点火焚烧尸体。防御军队的队长走了过来。%SPEECH_ON%有时死人会死而复生，但我们知道骨灰不会。好吧，也许骨灰也会，但它们对别人没有危害。%SPEECH_OFF%你想提到那可怕的臭味，但意识到他们可能很久以前就习惯了。 | 穿过杂乱的%objective%大门，你会发现这个城镇看起来早已屈服于不死族。村民们毫无目的地蹒跚着，感到沮丧。几个卫兵站在一辆马车旁边，从家到家分配口粮。你看到有些防御者趴在防御墙边睡觉，手臂半悬在垛口上，握着武器，看起来像是被扔在角落里的木偶。防御军的中尉走了过来。%SPEECH_ON%感谢你来了，自由佣兵。很多人都认为你不会来，毕竟这就是地狱。%SPEECH_OFF% | %objective%的大门打开了，你穿过了门。里面，你看到两个卫士正在拉着一个尸体朝着一个燃烧的尸体堆前进。一个女人抓住死者的靴子，乞求卫士让她再看一眼。他们不理会她，把尸体扔进火里，她跌倒在火堆前，当她丈夫的皮肤噼啪作响时她就晕倒了。防御军的中尉走了过来。他拍了拍你的肩膀。%SPEECH_ON%很高兴你来了，自由佣兵。%SPEECH_OFF% | 穿过%objective%的城门，有个人抓住了你的衣领。%SPEECH_ON%你身上有食物吗？嗯？我能闻到，或者说你就是食物本身吗？%SPEECH_OFF%一个警卫用长矛把他推开。那个疯子揉着肚子，一边拿眉毛上的虱子吃一边说话。%SPEECH_ON%你们带来了更多的剑，但是我们需要的不是剑！%SPEECH_OFF%警卫们把那个人抓走了，中尉走了过来。%SPEECH_ON%别理他，他过去是个更胖的人，所以对最近的变化感到很特别。我们这里还有食物，只是必须要限量。你们这些佣兵的剑很受欢迎，毫无疑问，你们很快就要用它们了。%SPEECH_OFF% | 你踏进%objective%的城门，闻到了烧焦肉的气味。那里有一个燃烧中的尸体堆，一名守卫站在旁边用棍子搅拌着灰烬，就像一个厨师炖着炖锅里的东西。村民站在烧焦的尸体旁边，在空气中举行宗教仪式并擦着眼泪。镇上的队长走了过来。%SPEECH_ON%攻击可能来自任何地方。死者会回来，而我们这是一个备受折磨的城镇。这堆尸体是一家人。妻子在夜里去世，黑暗的掩护下，不断地吃。我们必须烧掉所有的尸体。%SPEECH_OFF%队长看到你皱了皱眉头。他微笑着放轻了语气。%SPEECH_ON%你今天怎么样？%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们需要为即将到来的攻势做好准备...",
					function getResult()
					{
						this.Flags.set("Wave", 1);
						this.Flags.set("TimeWaveHits", this.Time.getVirtualTimeF() + 8.0);
						this.Contract.setState("Running_Wait");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Wave1",
			Title = "在 %objective%…",
			Text = "[img]gfx/ui/events/event_29.png[/img]{你几乎等的快要无法承受时，另一件事出现来完成任务：不死族! %objective%的钟声响起，卫兵们带着一种未曾预计的热情抢先行动。你下令%companyname%准备战斗。 | 当你看着兄弟们打牌的时候，钟声响起。你瞥眼看向当地的修道院，看到一个虚弱的老人使出浑身解数。卫兵们以新的活力回应钟声。一个人从门楼里呼叫。%SPEECH_ON%他们来了，拿起武器!%SPEECH_OFF% | 就在你以为你已经加入了市民，站在那里慢慢地等待死亡时，大门打开了，一个斥候骑着马飞驰而过。疲惫的马匹倒地，向前滑动，骑手则跳下来安然无恙。他站了起来大叫着。%SPEECH_ON%不死族来了!我们必须准备好!%SPEECH_OFF% } | 一名站在瞭望塔上的人大喊起来。%SPEECH_ON%信息到来，小心头顶！%SPEECH_OFF%你抬头看到一支箭弧形地划过天空，扭曲着落到离你只有几英尺远的泥土上。中尉从箭上拆下一卷卷轴，越读口唇越白，他把纸扔到一旁。%SPEECH_ON%准备好了，雇佣兵，死人来了。%SPEECH_OFF%他转向他的战友。%SPEECH_ON%保卫%objective%！ 准备战斗！%SPEECH_OFF% | 一个卫兵大喊起来。%SPEECH_ON%城门打开了，难民来了！%SPEECH_OFF%一群孩子蹒跚着穿过摇晃的大门。其中一人解释说，一群苍白的男人正在接近。中尉盯着你。%SPEECH_ON%最好准备好你的士兵，雇佣兵。%SPEECH_OFF%不死族正在向这里走来，准备战斗！ | 一个侦察兵进入了%objective%，从满是鲜血的双腿残缺的马背上下来。这名骑士抱着一只缺少手臂的手臂，他的脸上被削去了一只耳朵和一只眼睛。中尉冲过去，两人交谈后侦察兵昏迷了过去。中尉叹了口气并站起来。%SPEECH_ON%不死族正在进攻，准备战斗！将那匹马斩杀！%SPEECH_OFF%你点了点头，命令%companyname%为战斗做好准备。当佣兵们准备就绪时，一个穿着屠夫的衣服的人走过来，用切肉刀将这匹马砍死。中尉拍了拍你的肩膀。%SPEECH_ON%嘿，如果能存活下来，我们至少会有东西可吃。%SPEECH_OFF% | 你坐在中尉旁边。他掰开面包。%SPEECH_ON%自你来到这里，一切变得异常寂静。%SPEECH_OFF%你咬了一口，问他是否在暗示你是不死族的双重特工。他笑了。%SPEECH_ON%这些日子不能太放松。%SPEECH_OFF%就在这时，一个钟楼敲响，警卫冲向城墙，哭喊声和尖叫声响起，不死族正在进攻！\n\n中尉戴上头盔，将你扶起来。%SPEECH_ON%卖剑客，是时候证明你的价值了。%SPEECH_OFF% | 一个士兵拿着包裹在皮革里的长镜，开始窥视城墙的垛口。他的手开始颤抖，手中的镜子摆脱了皮绑而碎在了地上。他指着前方尖叫道。%SPEECH_ON%不，不死族来了！准备战斗！敲响警钟！%SPEECH_OFF%你俯视城墙，即使没有望远镜，也可以看到苍白色的浪潮正在向你袭来。你让士兵冷静下来，然后赶快让%companyname%准备战斗。 | 一群狗来到了%objective%，它们嚎叫着要进去。饥饿的居民们满足了它们的愿望，但是这些狗进入之后就被拿起刀和镰刀的人们屠杀了。尽管如此，这些狗仍然在不停地进攻，试图找到一个屠宰场，寻求庇护之所。你朝城墙看去，发现它们冒着生命危险却仍旧想要进入，只为躲避前方正在蔓延的不死族。\n\n你吹哨引起了教堂钟楼上的一个人的注意，朝他指明目标。他立刻站直了，头盔掉了下来，在石制的塔上发出叮当声。他匆促地拉响了钟声，大声的钟声将下方残酷的叫声沉默。人和狼停下来抬头，一片沉闷的寂静笼罩着他们。慢慢地，爪声、呻吟声和咆哮声渗透到空气中。卫兵的中尉跳了出来，手握武器。%SPEECH_ON%准备战斗，勇士们！%SPEECH_OFF% | 有一具不死尸体在攻打%objective%的城墙外游荡。卫兵轮流用箭射击，企图阻止它。%SPEECH_ON%看那个，射中他的脚！%SPEECH_OFF%另一位卫兵准备射击。%SPEECH_ON%他还在走，瞄准他的头，笨蛋！%SPEECH_OFF%这次射击准确无误，箭矢穿透了空心的大脑，发出柔和的-扑哧-声。尸体的平衡瞬间失衡，停顿了一下，然后又继续前行，仿佛刚刚记起了自己的任务。另一名卫兵摇了摇头，准备射击。他闭上了一只眼睛，然后缓缓地睁开了。他的手开始颤抖，箭杆摇撼着木制弓。%SPEECH_ON%准-准备战斗！拉响警报！%SPEECH_OFF%你看过城墙，发现一片灰色浪潮在地平线上浮现，颠簸着前进。不死者在袭击！ | 城镇安静，火堆发出微弱的爆裂声。身旁的人们烤着一只老鼠，切下肉块分享。看够了，你爬上城墙，想找到士兵中的队长，此时他正用瞄准镜观察地平线。他阴郁地放下了瞄准镜。%SPEECH_ON%我艹，它们来了。%SPEECH_OFF%他把瞄准镜递给你，你看了看。一群鱼眼异形的不死生物正在向%objective% 路径蹒跚而来。队长拿回了瞄准镜。%SPEECH_ON%是时候挣钱了，佣兵。%SPEECH_OFF% | 一位女人的尖叫声吸引了你回头看。你看到一个男人正好是在一个塔上的一条绳子上，他跃下去，脖子折断了。尸体晃动着，在石墙上颠簸和扭曲。警卫队长生气地嘟囔着，愤怒地吐了口唾沫。%SPEECH_ON%该死，他应该在看守地平线。%randomname%！爬上去，放他自由，并接替他的岗位！%SPEECH_OFF%另一名警卫咕哝着照着命令去做，但当他爬到警卫时，他不再按照任何命令行事。相反，他开始歇斯底里地喊叫。%SPEECH_ON%长官！长官！他们来了！所有那些苍白的人，他们来了！%SPEECH_OFF%队长命令他的队员准备战斗，你也做好了准备。这个人看着你，带着希望的神情。%SPEECH_ON%无论他们给你多少克朗，我希望你值得。佣兵。%SPEECH_OFF% | 其中一个守卫找到了老鼠洞，这引起了人们沉重且难以置信的欢庆。当城里的居民欢呼和哭泣，老鼠的尖叫声愈加刺耳，守卫队长走了过来。他微笑着观察着这个场景，但当一声尖叫打破了空气的宁静时，他的脸色变了。众人都转向了城墙，一个守卫指着天际。即使你站在这里，也能看到他恐惧的目光。%SPEECH_ON%死人来了！他们要杀死我们所有人！我们没有足够的人手！%SPEECH_OFF%队长让那个人勇敢点，然后悄悄地对你说。%SPEECH_ON%准备你的士兵，佣兵，并证明你值得他们支付的任何代价。%SPEECH_OFF% | 一名守卫试图逃跑被捕。中士怒气冲冲地来回踱步，仔细察看。%SPEECH_ON%我们没有多余的人手，而你选择这样对待我们？%SPEECH_OFF%一个城镇居民扔出一堆泥巴，但是失手了，但意图很明显。%SPEECH_ON%活埋他！这样就少了一个需要养活的人了！%SPEECH_OFF%就在农民们开始变得吵闹之际，城镇钟声开始响起。一个站在哨塔上的人尽力大喊。%SPEECH_ON%他们来了！不死族，就在地平线上！%SPEECH_OFF%中士看着那名逃兵。%SPEECH_ON%你想赚回你的荣誉，就现在开始行动吧。你打算战斗吗？%SPEECH_OFF%这个人迅速点了点头。中士转向你，但你举起了手。%SPEECH_ON%你无需问 %companyname% 这样的问题。%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "保卫城镇！",
					function getResult()
					{
						this.Contract.setState("Running_Wave");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Wave2",
			Title = "在 %objective%…",
			Text = "[img]gfx/ui/events/event_73.png[/img]{当%companyname%休息的时候，清理锈迹斑斑的刀锋，钟楼上发出了另一个信号。不死族再次进攻！ | 卫兵中尉四处巡视确保他的士兵在休息和喝水。就在他和你聊天的时候，城镇钟声响起，守望人大叫又来了一次攻击！你笑着拍着中尉的肩膀。%SPEECH_ON%我们只是做我们该做的。有什么比这更简单呢？%SPEECH_OFF%中尉点头，去准备他的士兵。 | 你看着%randombrother%清洗他的刀锋上的苍白肉块和浸湿的衣服。%SPEECH_ON%老天爷，他们留下的垃圾真是让人难看。%SPEECH_OFF%就在这时，一个岗哨吹哨并吼道不死族再次进攻！雇佣兵愤怒地甩掉了他武器上的脑残。%SPEECH_ON%就在我开始看到我的倒影的时候！%SPEECH_OFF%你帮助那个人站起来，拍了拍他的肩膀。%SPEECH_ON%相信我，你没什么好想念的。%SPEECH_OFF% | 其中一名守卫将一个硬面包撕成屑，开始分给大家。另一个守卫问他食物从哪里来，他毫不客气地回答道:%SPEECH_ON%我在死去的家伙口袋里发现了它.%SPEECH_OFF%吃饭的人都吐掉了食物，有人甚至呕吐。你看着这些男人开始打架，但快速被一个守卫的口哨声打断。站在其中一座塔上的守卫正在指向地平线。%SPEECH_ON%他们又来了! 准备战斗!%SPEECH_OFF%做好战斗准备, 切勿抢夺其他死者的食物, 因为他们把你视为午餐。 | 当你的战士们休息和恢复时, 一名守卫大喊：%SPEECH_ON%他们又来了!%SPEECH_OFF%战争很少能给人一个适当的休息，尤其是与不死族的战争。 | 你看到%randombrother%正在用泥土擦拭他的脸，他顿了顿，扫了一眼你的目光。%SPEECH_ON%泥浴，先生。你懂的，清洗掉...血浴。%SPEECH_OFF%你翻了个白眼。就在这时，教堂的钟开始敲响，一个守卫大喊，发现另一次袭击即将来临!你告诉佣兵完成他的“沐浴”，准备战斗。 | 你看到[%randombrother%]正在洗灰色内脏的细绳从耳朵后面洗出来。%SPEECH_ON%妈妈总是说要去洗耳朵，但我想她没预见到这样的混乱！%SPEECH_OFF%你告诉他，好的母亲是能够预见一切的。他笑着点头。%SPEECH_ON%是啊，她只会对我怒吼，问我从哪儿弄来这个恶心的东西！%SPEECH_OFF%就在这时，塔上的一个守卫喊出不死族再次袭击。你转向雇佣兵。%SPEECH_ON%好吧，我们该再次变脏了。%SPEECH_OFF% | 你发现一个农民正在一面石墙上刻线。看到你，他向你解释道。%SPEECH_ON%我在为那些失踪的人做账。已经有这么多人了，我记不清他们的名字，但是我可以数数。%SPEECH_OFF%你顺着墙朝下看去，发现它逐渐从名字变成了数字。%SPEECH_ON%我们尽力记住他们，你知道吗？%SPEECH_OFF%你点了点头，然后警卫们喊叫着，宣布另一次攻击即将到来。农民拼命地看着你的胳膊，祈求地说：%SPEECH_ON%告诉我你的名字，到时候我会替你刻上的。%SPEECH_OFF%你挣脱了他的手臂，怒视着他，用愤怒的眼神把他吓了一跳。%SPEECH_ON%我是一个杀手，你这个傻瓜，不是你的朋友。分开我与你脖子上的唯一的东西就是谁付给我钱。如果你再问我这个问题，我就会在那面墙上写上你的号码，并且是免费的，你懂吗？%SPEECH_OFF%那个人点了点头。你也点了点头，离开准备让佣兵们应战。 | 正当你和士兵们安下心来休息时，警卫叫喊起来，城镇钟声响起来。另一次攻击即将到来！你命令%companyname%为战斗做准备。 | 你爬上%objective%的城墙，找到了守卫的中尉。他叹了口气。%SPEECH_ON%他们又在攻击了。%SPEECH_OFF%你望向地平线，确实又有一波攻击正在接近。中尉去召集他的士兵准备战斗，你也是这样。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "保卫城镇！",
					function getResult()
					{
						this.Contract.setState("Running_Wave");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Wave3",
			Title = "在 %objective%…",
			Text = "[img]gfx/ui/events/event_73.png[/img]{当所有的战士都在休息时，其中一名守卫嗓音沙哑地大声喊出，他们已经心灰意冷。%SPEECH_ON%又来了，他们又来了……%SPEECH_OFF%如果要%objective%幸存下去，%companyname%必须迎接挑战！ | 一名警卫凝视着火焰，双手颤抖。他自言自语，但渐渐变得更响亮，大家都听得到。%SPEECH_ON%没错，我们要这么做！我们可以进行谈判！我们可以和他们谈判！我来谈，我去和他们谈！%SPEECH_OFF%这个人站了起来，几个人试图把他拉住，但他逃脱了。他跑到城墙上，一头扎了下去。你赶紧跑过去看着那个精神错乱的傻子穿过田野狂奔，直奔一大群不死族！另一名警卫看着他开始发抖。%SPEECH_ON%老神仙保佑，他们更多的部队居然来了？他们怎么可能有这么多？%SPEECH_OFF%你无视了他的话，看着疯子消失在尸体群中。他们的队伍踉跄着把闯入者消耗掉，然后继续前进，就像一个苍白的池塘因为岩石的来碰撞而短暂的波动。你高声呼喊着。%SPEECH_ON%战斗吧，勇士们！让我们再次走入战火中！%SPEECH_OFF%} | 警卫中的一名人发现了另一次攻击！他尖叫着，声音嘶哑，然后昏倒了。%objective%的民兵已经到了尽头，希望这是最后一次攻击！ | 一名守卫吹响了警报，更多的不死族正在接近。警长摇了摇头。%SPEECH_ON%老神明啊，他们会停下来吗？今天你真的赚了你的钱，雇佣军。%SPEECH_OFF%你想开个玩笑，说你应该赚更多的钱，但现在似乎不太合适。相反，你点点头，离开准备为%companyname%再次战斗。 | 当你和警长交换战争故事时，一个民兵走了过来。你注意到他是负责看守城墙的人。他讲话直接。%SPEECH_ON%先生们，他们再次攻击了。%SPEECH_OFF%然后他转身向城镇军械库走去。你站起来，帮助警长站起来。他用简短、庄重的微笑拍了拍你的肩膀。%SPEECH_ON%又一次投入战斗，是吗？%SPEECH_OFF%你只能耸耸肩。%SPEECH_ON%这就是我们存在的目的。见到你，警长。%SPEECH_OFF% | 你凝视着%objective%城墙之外，发现又一波不死族冲来。之前袭击所带来的刺激已经消散殆尽，现在守卫们默默地看着这些僵尸们向前踉蹌。卫队中尉来到你身边。%SPEECH_ON%与你并肩作战是我的荣幸，佣兵。%SPEECH_OFF%你点了点头，回应道。%SPEECH_ON%嗯，荣幸当然了。%SPEECH_OFF%中尉注视着你。%SPEECH_ON%你在想着你的报酬，不是吗？%SPEECH_OFF%你再次点头回应。%SPEECH_ON%我想着它所能买到的东西：温暖的床，热腾腾的饭，和更加热情的女人。%SPEECH_OFF% | 你站在%objective%城墙上，遥望地平线，又一次攻击即将来临。面对这一切不再感到兴奋，也没有尖叫或歇斯底里，不再有任何激情。这只是一股肥胖、蹒跚、畸形的尸潮，呼哧地向前喘息着，仿佛在询问是否需要再进攻一次。你下令%companyname%做好准备。%randombrother%满身都是被撕成碎片的不死族，手舞足蹈地说道：%SPEECH_ON%长官，我觉得我们已经胜利了。%SPEECH_OFF%士兵们开心地笑着，民兵们也加入其中，很快整个空气充满了欢声笑语，还有越来越近的不死族的呻吟声，疯狂引发着疯狂。 | %randombrother% 走过来靠近一个营火，把长长的内脏从他的肩膀上甩了下来。一个农民眼巴巴地看着那些内脏，仿佛随时都准备好了开饭。雇佣兵不安地坐下来。%SPEECH_ON%我要是再看到一个行尸走肉向我走来，仿佛这是午餐时间，我就……%SPEECH_OFF%他还没来得及说完，一个守卫在城墙上吹响了号角，发出警告让所有人都听到。他把号角放在身边，脸变得通红，满脸喘息。%SPEECH_ON%……不死族……他们又开始攻击了！%SPEECH_OFF%雇佣兵的脸一下子变得非常冷静。他起来，没有说话，慢慢地去武装自己。 | 一个农民站在%objective%的门口，他正在与门卫争吵。%SPEECH_ON%放我出去！你们肯定已经打败了他们，我想回到我的农场。你们要知道，我有两头牛！%SPEECH_OFF%这个人两个手指向前指着，以防听众没有理解。他们耸了耸肩，打开了大门，但农民没有动。相反，他向后退了一步。%SPEECH_ON%想了想，我的牛可以等我回家再说。%SPEECH_OFF%在城墙外，你可以看到一大群不死族从地平线上爬过来。不一会儿，警报信号传出，%objective%的士兵们忙碌着，拿起武器准备进行又一场战斗。 | 你沿着城墙见到卫兵中的一名中尉。他在和一些民兵分享面包，并给了你一块。你拒绝了并问他前方有什么。中尉指向田野。%SPEECH_ON%噢，没什么，他们只是再次进攻而已。%SPEECH_OFF%他递给你一个望远镜。透过镜头，你看到一大群尸体向%objective%蹒跚而至。你放下望远镜问他为什么没有拉响警报。他耸耸肩。%SPEECH_ON%给这些人多一两分钟的时间。行尸走肉可能想要杀死我们所有人，但他们对此不急，你懂吧？%SPEECH_OFF%可以理解。你可以先吃一下那份面包，然后再等一两分钟，准备好%company%的战斗。 | 其中一个民兵把一个行尸走肉带到城墙后面。他用链子把它绑着，将尸体的手臂砍掉了。尸体的嘴里有一条又长又悬的舌头。警卫中尉走了下来。他的脸涨得通红，看起来像一个快要咒骂的人需要呼吸一样。%SPEECH_ON%你他妈在干什么？%SPEECH_OFF%民兵拉着链子，将不死者拉倒在地上。他紧张地为自己辩解。%SPEECH_ON%也许，我们可以从它们身上学到一些东西？了解它们为什么行动，学习怎样去，我不知道，也许将它们带回来？%SPEECH_OFF%在争论再次持续之前，一个喊声突然响起。一名守卫站在瞭望塔上，警告另一次攻击。中尉手持武器，急速将死尸砍了下来并摆脱掉它，它下巴的头在脖子上滚动着，像氧气被关在罐子里的蛇一样。中尉用力地拉住民兵的衣领。%SPEECH_ON%你别他妈再搞这种玩意了，明白吗？它们已经死了，没别的了。抓紧你该武装的武器。%SPEECH_OFF%%companyname%已经准备好了，不需要你讲。 | 你在镇子里找到了铁匠，他正在锤炼%objective%“最好”的武器。他健壮的胳膊挥舞着锤子，用钳子轻松地掌握着材料，就好像它们是木棍一样。他手腕上有一个莲花图案的纹身。火苗螺旋状地飞旋着，他很快就注意到了你投射在他的露天铁匠铺周围的阴影。%SPEECH_ON%嘿，佣兵。%SPEECH_OFF%他真诚地好奇并感到无聊，问你最近如何。他把一些钢铁压平并翻转，重复这个过程。%SPEECH_ON%自然没什么好的，可能还会更糟。这个怎么样？%SPEECH_OFF%铁匠把刀子拿起来让你评估。在你回答之前，丁零铛铛的警报声响起，一群人开始抢占城镇防御。民兵们跑过时从他的铁匠铺中拿起武器。他放下了刀子，笑了。%SPEECH_ON%噢，走吧，去打仗吧，佣兵。那是一个修辞问题。%SPEECH_OFF% | %objective% 的抄写员手拿一张羊皮卷在四处走动。他正在背着一个仆人写他所看到的一切。在这个混沌的领域里，你很好奇他到底看到了什么？这个人直截了当地回答你。%SPEECH_ON%研究情感。我觉得悲伤是一种疾病，它正在这里蔓延。%SPEECH_OFF%对于一个好奇的问题，这是一个好奇的答案，所以你又追问了一遍他在研究什么。他不理睬这个问题，而是上下打量了你一下。%SPEECH_ON%按我的指标，你的健康状况不错，雇佣兵。除了你的身体，你走起路来像一只残疾的狗，左转时会皱起眉头。非常容易被发现。但我可以看到痛苦没有阻碍你。事实上，我认为它...驱使着你。你在为失去的东西进行弥补吗？%SPEECH_OFF%在你回答之前，警报铃声响起，人们开始忙碌起来为下一次不死族的攻击做准备。当你回头时，抄写员已经消失了，在一些遥远的角落站着，用他的尖羽毛笔猛烈地写在他愁眉苦脸的仆人的背面。 | 当你准备安顿下来休息时，警铃突然响起，城墙上的守卫们纷纷冲向声音的来源，一面尖叫着一面追赶。看来不死族再次发起进攻了！你匆忙让 %companyname% 做好再次战斗的准备。 | 你注意到城墙的尖端被秃鹫弄得一片漆黑。这些大鸟凝视着城镇，像一个隐秘的丧葬队列。突然，一名民兵从一个瞭望塔的门口走了出来，手持一根木棍将其中一只秃鹫击中。鸟儿发出了短促的尖叫声，其他的秃鹫则像荷叶在波光粼粼的池塘上摇摆不定。接着，民兵一棍子敲碎了晚上的第二只鸟，这些食腐动物也终于明白了发生了什么，纷纷飞走。猎人挟着他的猎物自豪地回到了瞭望塔。%SPEECH_ON%嘿.%SPEECH_OFF%卫队队长拍拍你的肩膀。当你转过身时，他竖起了大拇指。%SPEECH_ON%不死族又来了，我命令士兵们保持警铃安静，谁知道我们大声喊叫会不会招来更多的那些家伙。%SPEECH_OFF%貌似是个明智的主意。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "保卫城镇！",
					function getResult()
					{
						this.Contract.setState("Running_Wave");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Militia1",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_46.png[/img]{你赢了这场战斗，但民兵队可能输掉了整个战争：镇警队的损失太多，更多的居民准备离开村庄，而不是留下来帮助保卫！ | 胜利，但代价是什么？在这场战斗中，太多的民兵阵亡了，以至于%objective%的任何公民都不愿意接任他们的位置！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "胜利仍然是胜利。",
					function getResult()
					{
						this.Flags.set("Wave", this.Flags.get("Wave") + 1);
						this.Flags.set("TimeWaveHits", this.Time.getVirtualTimeF() + 3.0);
						this.Flags.set("Militia", 3);
						this.Flags.set("MilitiaStart", 3);
						this.Contract.setState("Running_Wait");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Militia2",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_46.png[/img]{战斗已经赢了，但是不是没有代价的。一些%objective%市民报名参加保卫城镇的队伍，而其他人正在打包准备离开。 | 您赢得了这场战斗，但不死族也需要你付出代价。虽然一些市民同意帮助民兵队伍，增加队伍人数，但同样数量的人保持距离并为最坏的情况做准备。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "胜利仍然是胜利。",
					function getResult()
					{
						this.Flags.set("Wave", this.Flags.get("Wave") + 1);
						this.Flags.set("TimeWaveHits", this.Time.getVirtualTimeF() + 3.0);
						this.Flags.set("Militia", 6);
						this.Flags.set("MilitiaStart", 6);
						this.Contract.setState("Running_Wait");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Militia3",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_80.png[/img]{多么辉煌的胜利！不仅击退了不死族，你的成功还让许多%objective%的市民加入了民兵队伍，为未来的战斗而战！ | 不死族已经被击败得彻底了，许多%objective%的市民加入了民兵，帮忙参加即将到来的战斗！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "胜利！",
					function getResult()
					{
						this.Flags.set("Wave", this.Flags.get("Wave") + 1);
						this.Flags.set("TimeWaveHits", this.Time.getVirtualTimeF() + 3.0);
						this.Flags.set("Militia", 8);
						this.Flags.set("MilitiaStart", 8);
						this.Contract.setState("Running_Wait");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Ghouls",
			Title = "在 %objective%…",
			Text = "[img]gfx/ui/events/event_69.png[/img]{当你准备战斗时，你会注意到不死族的队伍中摇摆着奇怪的形状：不死食尸鬼。这些生物一定是跟随不死军团寻找他们所杀之物的食物，就像海鸥跟随着海上的渔船一样。 | 食尸鬼！这些恶心的家伙在尸体中间蹦蹦跳跳地走着，它们正在寻找下一顿食物，毫无疑问。 | 不死族留下了很多死亡和垂死的人，毫不奇怪地，食腐动物开始跟随它们。在这种情况下，它们是不死食尸鬼，这些丑陋的野兽正在咆哮和嘶嘶声中渴望着下一顿美食。 | 如果你洗劫一间储藏室，老鼠一定会来。现在不死族正在攻击%objective%，它们已经拥有了一批随从——食尸鬼。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "保卫城镇！",
					function getResult()
					{
						this.Contract.spawnGhouls();
						this.Contract.setState("Running_Wave");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TheAftermath",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_46.png[/img]{你凝视着战场，遍地都是死亡、垂死挣扎、无尽的不死之人和不死垂死挣扎的人。活着的人绕着泥泞走来走去，结束一切类似复活的东西。战斗结束，城镇得以拯救，%employer%现在应该会等着你。 | 战斗结束，城镇得以拯救，是时候回到%employer%那里得到巨额报酬了。 | %objective%更像是一个被洪水淹没的墓地，而不是你所知道的城镇。新旧尸体洗刷到每个角落，鲜血和腐烂的污垢浸润着每个角落，恶臭让你想起曾在小溪旁发现的死狗，骨头上滴着腐化物质，体内被螯虾和蛆虫啃食。\n\n不间断的攻击终于停止了，%objective%现在看起来很安全了。%employer%应该在等你了，你没有理由不尽快逃离这个可怕的地方。 | 嗯，城镇被拯救了。农民们手拿长棍，在战场上走来走去，像探水的鹈鹕一样戳着土地。%randombrother%过来了，清洗着刀刃上的淤泥，问是否该回去找%employer%了。你点了点头。你越快能回去领取报酬越好。 | 战斗结束了。死者中既有农民又有民兵，每个尸体都有幸存者前来用哀号的影子将其裹好。至于那些不死之人，无人在意。他们的身体仿佛没有实际意义，只是给一切碰到的事物带来了毁灭。他们的尸体和他们所代表的混乱无序让人感到愤怒。不想再多呆一秒，你告诉众人准备回去找%employer%。 | 你和%companyname%胜利了。城镇及其居民暂时得以幸存，你们可以回到%employer%领取报酬了。 | 警卫中尉感谢你拯救了城镇。你提到你在这里的唯一原因是因为有人付了你钱。他耸耸肩。%SPEECH_ON%我感谢那些我没有掌控的雨水，不管你是否喜欢，我都要感谢你，雇佣兵。%SPEECH_OFF% | 战斗已经结束了，并且幸运地取得了胜利。不死族的尸体在地面上四处倒塌，以至于它们看起来与几个小时前摇晃晃悠悠的模样几乎没有什么不同。但是，那些刚刚死于战场的人则没有受到宇宙的绝望。他们由哭泣的妇女和困惑的孩子照管着。你看着场面，命令%companyname%准备返回%employer%。 | 一名死者躺在你的脚边，旁边是一个不死的尸体。这是最奇怪的景象，因为他们都已经不在这个世界上了，但是这个人还有生命。令人深刻难忘的呼吸记忆。你看见他挥舞着剑直到最后一刻。对于一个战士来说，这是一种高尚的形式。但是这个不死的尸体呢？那它呢？你会记得它用裸露的牙齿撕裂一个人的喉咙。也许这个尸体有过那个时候，当它还有家人，当它还是这个世界上做好事的善良人。但是，现在它只是一个撕咬喉咙的怪物。它只会被铭记为这样。\n\n对%objective%的毫不留情的攻击终于停止了，于是你匆忙收集了战团，准备回到%townname%的%employer%处领取酬劳。好的支付日总比再看这些垃圾要好。 | 什么是死人？况且是被杀了两次的死人呢？那三次呢？不幸，不幸的是，还是个笑话。\n\n你正在战场上收集%companyname%的士兵。%objective%镇目前得救了，现在你该回到%townname%的%employer%那里领取应得的薪水了。 | %randombrother%用一块布擦了擦额头，留下了一滩恶心的液体。%SPEECH_ON%该死，那是什么？是脑浆吗？先生，你能帮我弄干净吗？%SPEECH_OFF%你帮助那个人擦干净身上的血迹。他站起来，双臂打开。他还满是血、内脏以及其他无法形容的东西。%SPEECH_ON%我看起来怎么样？%SPEECH_OFF%他的笑容在暗淡的天空中闪耀着月亮的光辉。你拒绝回答他，只告诉他去找到士兵。随着%objective%镇的得救，%employer%会期待公司在%townname%回来，并且公司应该得到应得的收入。 | %randombrother%来到你身边，你们两个看着战场。你已经看到死者的家属走出来寻找失踪的亲人。他们悲哀的哭声尖锐而真实，从嚎叫、呻吟的不死族中解脱出来，让人感到难以抵挡。雇佣兵拍了拍你的肩膀。%SPEECH_ON%我去收集士兵，我们可以回到%townname%领取我们的报酬了。%SPEECH_OFF% | 你看着女人们在战场上蹒跚而行，像淋湿的鸟一样抬着裙子绕过池塘的淤泥。当然，一旦她们找到她们要找的东西，她们就不再顾及清洁，跳进污泥中哭泣和嚎叫，用那些曾经用令人气愤的漠视杀死她们的父亲和丈夫的恐怖覆盖自己。\n\n%randombrother% 加入了你的战团。%SPEECH_ON%长官，攻击停止了，士兵们已经准备好回到%townname%。只要下命令。%SPEECH_OFF% | 卫队长来到你的身边，握住了你的手。随着你的握手，干燥的血渍破碎了。他双手叉腰看着现场点了点头。%SPEECH_ON%佣兵，你做得很好，没有你我们无法完成任务。我想给你更多的奖励，但这座城镇现在需要所有的资源来重建。我希望%employer%付你应得的报酬。%SPEECH_OFF%你也希望如此。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们做到了！",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{你来到了%townname%，发现%employer%正在阳台上观望。就在卫兵把一袋克朗狠狠地扔进你怀中之际，他朝你喊道：%SPEECH_ON%雇佣兵！太高兴见到你回来了！我的小鸟们已经告诉我了你的种种行迹，希望你好好花这些克朗！%SPEECH_OFF%还没等你回答，那个人就转身走了。递给你克朗的卫兵也已经不见了踪影。农民们在你身边走过，像是指向他们永远走不到的地方的路标。} | 你发现%employer%正在毒打一个孩子，最终用脚迅速踢向孩子的胸部，将他踢倒在地。看到你，贵族从额头上擦去汗水并解释了自己。%SPEECH_ON%这不关你的事。%SPEECH_OFF%孩子跪在地上，一只手按在肚子上，另一只手的鼻孔里流着血。逐渐地，他站起来，双眼发红地晃动。一名仆人过来给他擦水，但贵族抢过抹布扔到了一边。%SPEECH_ON%你觉得这样可以让他学习。如果你想帮助别人，就帮助这个雇佣军。他被欠下了%reward_completion%克朗的报酬。快点。%SPEECH_OFF%仆人点了点头，赶紧离开了。你待了一会，看着孩子被打。孩子没有哭也没有喊叫，因为他早已经习惯了这种惩罚。几分钟后，仆人突然出现了，手里拿着一个袋子。他把它递给你并悄悄地建议你离开。 | %employer%弯腰俯身在桌子上，双臂僵硬，头低垂着，盯着一只死乌鸦。%SPEECH_ON%我今天早上在我的床上找到了这只乌鸦。就在那躺着。死了。你有什么想法吗？%SPEECH_OFF% 你建议这可能只是一个玩笑。贵族嗤之以鼻。%SPEECH_ON%不。我认为这与你有关，佣兵。你在拯救那个城镇时表现得很出色，但也许它本不该被拯救？也许这就是这只鸟代表的意思。也许死亡会因为我没有偿还而下一步会找上门来。%SPEECH_OFF% 你利用这个声明缓缓地转入到自己的工资问题。尽管贵族说了一些胡话，但他还是清醒地支付了你%reward_completion%克朗。 | %employer% 正在听一群文书的讨论，他们按年龄和资历排成了一定的次序。年轻人保持沉默，只听到他们的鹅毛笔划过纸张的声音。老年人们则在彼此争吵，使用高声与道理来说服对方。这看起来如今是常见的场景，毫无疑问，死人从坟墓中爬起来对于哲学思考的人们来说是一个不同寻常的关注点。无论如何，你大声打了个嗝介绍自己，恶心地打乱了他们的谈话。%employer% 笑着向你挥手让你进来。%SPEECH_ON%啊，雇佣兵！一个能成事的人，来与那些只会喋喋不休的人交谈？%SPEECH_OFF%你摇了摇头，告诉他你只是为了报酬而来。贵族点点头。%SPEECH_ON%当然。你在拯救那个城镇时干得很好。我听到了许多你的英勇事迹。%reward_completion% 就在那角落里等待着你的克朗。%SPEECH_OFF%你穿过房间，皮靴轻轻拍打着石头地面发出微弱的声音。文书们扭头看着你，互相窃窃私语。你拿起一个包，听到克朗的钱币发出了一声清脆的响声，也感到了一丝温暖的重量。你悄悄地离开了，然而当门在你背后关闭时，文书们再次开始争吵。 | %employer% 身边站着几个女人，她们在告诉他她们失去的父亲、丈夫和兄弟。他认真地点头，偶尔会分神看一眼最年轻的女孩的胸部。%SPEECH_ON%是的，当然。非常可怕。可怕啊！等一下,雇佣兵！%SPEECH_OFF%他向你招手让你进来。女人们在你走进来时分开，最年轻的姑娘看了你一眼，迅速擦去眼泪，并做了一些青春期的整理。贵族看到这一幕，扫了你和她一眼。%SPEECH_ON%咳咳，你们的克朗在角落里。你必须走了。现在我有事情要处理。%SPEECH_OFF%他站起身，指向你的%reward_completion%克朗，然后一下子拉起了那位女士的手。%SPEECH_ON%现在，年轻的女裁缝，你说你的丈夫已故，这辈子一个人也没有了？绝对没有任何亲人了吗？%SPEECH_OFF% | 路上的狗啃了点东西。无论它曾经是什么，它曾经有生命，骨头和器官早已变得苍白和腐烂，尽管这些杂种狗狂暴的进食似乎就像吃了一块牛排。%employer%在他的注意力集中的卫兵身边向你问候。%SPEECH_ON%我的鸟儿告诉我城镇得救了。你做得很好，佣兵，比我想象的要好。你的酬劳，按照约定。%SPEECH_OFF%他递给你一个装有%reward_completion% 克朗的小包。狗们暂停了，转过头，嘴里的肉摇晃着，狭黑的眼睛里闪烁着饥饿的空虚。卫兵们放下了长矛，狗们则慢慢地回头继续吃他们的晚餐。 | %employer%低头坐在椅子里。他沮丧地挥手示意你进入房间。%SPEECH_ON%我有一个可怕的消息。我的先知说我给我的土地和人民带来了诅咒。这就是为什么死者会再次复活的原因。%SPEECH_OFF%你耸耸肩，友好地表示先知所说的是胡说八道。贵族耸了耸肩。%SPEECH_ON%我真的希望是这样。我们达成了什么协议，%reward_completion% 克朗？%SPEECH_OFF%你想说你们达成了更多的协议，但不敢得罪一个如此迷信的人。当你回答时，他热情地对你的准确回答微笑。%SPEECH_ON%干得好，雇佣兵。你通过了那个考验。我可能快疯了，但我不会轻易对付。%SPEECH_OFF%你问自己的诚实是否会得到回报。这个人扬起了一只眉毛。%SPEECH_ON%你的头还在自己的肩膀上，不是吗？%SPEECH_OFF%意见已被接受。 | %employer%(雇主)在他的阳台上被发现。尽管守卫们严密地注视着你，但你还是加入了他。这个人挥动他的手臂指向了他所在的城镇.%SPEECH_ON%我知道你没有直接拯救这个城镇，但在某种程度上，我认为你做到了。在任何地方阻止不死族的行动都和在这里阻止一样好。你同意吗？%SPEECH_OFF%这个人给了你%reward_completion%克朗的报酬。你接受了报酬并点了点头。他也点头示意。%SPEECH_ON%你同意了，我很高兴，因为我们可能还需要你的服务。%SPEECH_OFF% | 你踏入雇主微光的房间。窗户上挂着地毯，大部分的蜡烛都没有点燃。在一个拿着烛台的抄写员旁边的所有灯光闪烁着，他火红的脸庞在烛光下宛如握着三叉戟的小恶魔。他朝你瞥了一眼，静静地放下蜡烛。当他退后时，就像他跌入了黑色的池中，他的无躯之躯慢慢沉入黑暗之中。他还在那里，微微呼吸，衣服沙沙作响，但你已经无法看到他的一部分了。%employer%招手让你进去。%SPEECH_ON%雇佣兵！老神在上，你拯救了那个城镇。%SPEECH_OFF%你向前走去，扫了一眼周围摇曳的黑暗，有些是阴影，有些是人。%employer%递给你一个包裹。一些点燃的硬币在其开口处闪烁着。%SPEECH_ON%完成奖励%crowns，如协议所述。现在，请出发吧。我还有更多要研究，要学习的。%SPEECH_OFF%你拿起你的报酬缓慢离开。当门关闭时，你看到抄写员再次出现，像一个憔悴的幽灵，骨瘦如柴的手再次伸向烛光。 | %employer%在他的书房里。守卫们站立在角落里，一位写字员悄悄地绕着书架转，带着同样的热情和失望拉出卷轴，并将它们放回原处。你很快被贵族招手进去，又很快被付款。%SPEECH_ON%干得好，雇佣兵。在这片土地上，你已经成为一位英雄了。说不定，你最终会被记录在这些卷轴之一，永远为人所记忆。%SPEECH_OFF%你听到写字员咕哝着，%employer%朝着门挥了挥手。%SPEECH_ON%请出去吧？我有许多重要的事情要研究，时间太短了。%SPEECH_OFF% | 你进入%employer%的房间，发现他深深地坐在椅子里。农民们在他两边争论不休，指责对方。%SPEECH_ON%这个人是个杀人犯！%SPEECH_OFF%被告翻了个白眼。%SPEECH_ON%杀人犯？那只是一个意外！我以为他是不死族！%SPEECH_OFF%另一个人也翻了个白眼。%SPEECH_ON%不死族？他只是喝醉了！%SPEECH_OFF%情绪开始升高。%SPEECH_ON%噢，我听见他叫嚣！或者呻吟。%SPEECH_OFF%你的雇主绝望地向你挥手示意。%SPEECH_ON%佣兵，你救了那个城镇，干得好。这是你的报酬。%SPEECH_OFF%他将一个装满%reward_completion%克朗的袋子顶上桌子。农民们都停止说话，盯着硬币从袋子的开口中滴落。你拿起这个袋子，假装它对你来说太重了。%SPEECH_ON%哦，太重了！你们先生们有个好天！%SPEECH_OFF% | %employer%欢迎你来到他的房间。%SPEECH_ON%我的耳目告诉我，城镇得救了。你干得很好，雇佣兵，在这个变得如此黑暗的世界中干得很好。按照协议支付你%reward_completion%克朗的报酬。%SPEECH_OFF% | %employer%站在外面，朝着一个墓地凝视，自从你上次来访后，这里的居民已经明显增多了。他递给你一个装着%reward_completion%克朗的小包。%SPEECH_ON%干得好，佣兵。你的事迹已经传遍了这片土地。一次胜利不能拯救我们所有人，但它把我们带上了正确的道路。如果我们要赢得这场与亡者的可恶之战，我们需要尽可能多的精神和希望。%SPEECH_OFF%你拿起报酬，补充道雇佣兵需要尽可能多的克朗，你知道，为了保持士气高昂。贵族笑了。%SPEECH_ON%我的话没有出自慈善，而是表现得正义凛然。出去吧。%SPEECH_OFF% | %employer%的守卫带你进他的房间。他周围展开了一些卷轴。破碎的羽毛笔散落在他的桌子上，就像有人在那里溅了一只鸟。%SPEECH_ON%雇佣兵！很高兴见到这场战争的胜利者，这场星期的胜利者！你解救了那个镇子，干得好！%SPEECH_OFF%他扔给你一个装着%reward_completion%克朗的小包。%SPEECH_ON%为了保住一座城镇的生命，为了保持人民希望的生命，这是一次胜利。我应该多付你一些报酬。我的意思是，我不会多付你，但我应该多付你。%SPEECH_OFF%你黯然接受你的薪酬，点点头回复。%SPEECH_ON%哦，重要的是心意。%SPEECH_OFF%贵族响起手指。%SPEECH_ON%没错！%SPEECH_OFF% | 你发现%employer%深深地坐在椅子里，脸上带着更深的皱纹。他的衣服闪烁着耀眼的富丽和华丽，烛台看起来比拿着它们的仆人更值钱。这个花哨的怨妇沮丧地向你挥手示意。他慢慢地、带着嘲讽的口吻说道。%SPEECH_ON%人类的一个胜利。再一个胜利，这将支撑我们到明天。嗯，谢谢你，佣兵。%SPEECH_OFF%你慢慢地向前迈步，仆人们带着恐惧的眼神瞥了你一眼。你拿到了你的薪水，然后退了回去。%employer%现在示意你离开。%SPEECH_ON%走吧。我希望再次见到你，除非你身体不好，已经死了，那将是一件耻辱的事情。但再想想，我们最终都会这样结束，不是吗？%SPEECH_OFF%你什么话也没说，离开了。这场对抗不死族的战争已经让这个贵族疲惫不堪。",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "%objective% 安全了。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "保卫了" + this.Flags.get("ObjectiveName") + "抵御不死族");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isUndeadScourge())
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Origin, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "%objective% 附近",
			Text = "[img]gfx/ui/events/event_30.png[/img]{不死族太多了，你不得不撤退。不幸的是，一个小镇没有这样的自由，因此%objective%被完全攻陷了。你没有留下来看看它的居民变成了什么样子，虽然聪明人也可以猜到。 | %companyname% 已经在战场上被不死族军团击败！在你的失败之后，%objective%很快被攻陷了。一群农民从城镇逃跑，那些太慢的人也被加入到了漫无目的的步履蹒跚的不死族之中。 | 你未能阻止不死族的攻击！尸体缓缓越过%objective%的城墙，吞噬并杀害所有它们遇到的人。当你逃离现场时，你看到警卫队长在不死族的后面缓缓地走着。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "%objective% 陷落了。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "没能协助" + this.Flags.get("ObjectiveName") + "抵御不死族");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function spawnWave()
	{
		local undeadBase = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getNearestSettlement(this.m.Origin.getTile());
		local originTile = this.m.Origin.getTile();
		local tile;

		while (true)
		{
			local x = this.Math.rand(originTile.SquareCoords.X - 5, originTile.SquareCoords.X + 5);
			local y = this.Math.rand(originTile.SquareCoords.Y - 5, originTile.SquareCoords.Y + 5);

			if (!this.World.isValidTileSquare(x, y))
			{
				continue;
			}

			tile = this.World.getTileSquare(x, y);

			if (tile.getDistanceTo(originTile) <= 4)
			{
				continue;
			}

			if (tile.Type == this.Const.World.TerrainType.Ocean)
			{
				continue;
			}

			local navSettings = this.World.getNavigator().createSettings();
			navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;
			local path = this.World.getNavigator().findPath(tile, originTile, navSettings, 0);

			if (!path.isEmpty())
			{
				break;
			}
		}

		local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).spawnEntity(tile, "大群亡灵", false, this.Const.World.Spawn.UndeadArmy, (80 + this.m.Flags.get("Wave") * 10) * this.getDifficultyMult() * this.getScaledDifficultyMult());
		this.m.UnitsSpawned.push(party.getID());
		party.getLoot().ArmorParts = this.Math.rand(0, 15);
		party.getSprite("banner").setBrush(undeadBase.getBanner());
		party.setDescription("一大群行尸，向活着的人索取曾经属于他们的东西。");
		party.setFootprintType(this.Const.World.FootprintsType.Undead);
		party.setSlowerAtNight(false);
		party.setUsingGlobalVision(false);
		party.setLooting(false);
		party.setAttackableByAI(false);
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(originTile);
		c.addOrder(move);
		local attack = this.new("scripts/ai/world/orders/attack_zone_order");
		attack.setTargetTile(originTile);
		c.addOrder(attack);
		local destroy = this.new("scripts/ai/world/orders/convert_order");
		destroy.setTime(60.0);
		destroy.setSafetyOverride(true);
		destroy.setTargetTile(originTile);
		destroy.setTargetID(this.m.Origin.getID());
		c.addOrder(destroy);
	}

	function spawnUndeadAtTheWalls()
	{
		local undeadBase = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getNearestSettlement(this.m.Origin.getTile());
		local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).spawnEntity(this.m.Origin.getTile(), "大群亡灵", false, this.Const.World.Spawn.ZombiesOrZombiesAndGhosts, 100 * this.getDifficultyMult() * this.getScaledDifficultyMult());
		party.setPos(this.createVec(party.getPos().X - 50, party.getPos().Y - 50));
		this.m.UnitsSpawned.push(party.getID());
		party.getLoot().ArmorParts = this.Math.rand(0, 15);
		party.getSprite("banner").setBrush(undeadBase.getBanner());
		party.setDescription("一大群行尸，向活着的人索取曾经属于他们的东西。");
		party.setFootprintType(this.Const.World.FootprintsType.Undead);
		party.setSlowerAtNight(false);
		party.setUsingGlobalVision(false);
		party.setLooting(false);
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		local wait = this.new("scripts/ai/world/orders/wait_order");
		wait.setTime(15.0);
		c.addOrder(wait);
		local destroy = this.new("scripts/ai/world/orders/convert_order");
		destroy.setTime(90.0);
		destroy.setSafetyOverride(true);
		destroy.setTargetTile(this.m.Origin.getTile());
		destroy.setTargetID(this.m.Origin.getID());
		c.addOrder(destroy);
	}

	function spawnGhouls()
	{
		local originTile = this.m.Origin.getTile();
		local tile;

		while (true)
		{
			local x = this.Math.rand(originTile.SquareCoords.X - 5, originTile.SquareCoords.X + 5);
			local y = this.Math.rand(originTile.SquareCoords.Y - 5, originTile.SquareCoords.Y + 5);

			if (!this.World.isValidTileSquare(x, y))
			{
				continue;
			}

			tile = this.World.getTileSquare(x, y);

			if (tile.getDistanceTo(originTile) <= 4)
			{
				continue;
			}

			if (tile.Type == this.Const.World.TerrainType.Ocean)
			{
				continue;
			}

			local navSettings = this.World.getNavigator().createSettings();
			navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;
			local path = this.World.getNavigator().findPath(tile, originTile, navSettings, 0);

			if (!path.isEmpty())
			{
				break;
			}
		}

		local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).spawnEntity(tile, "食尸鬼", false, this.Const.World.Spawn.Ghouls, 110 * this.getDifficultyMult() * this.getScaledDifficultyMult());
		this.m.UnitsSpawned.push(party.getID());
		party.getSprite("banner").setBrush("banner_beasts_01");
		party.setDescription("一群寻觅的食尸鬼");
		party.setSlowerAtNight(false);
		party.setUsingGlobalVision(false);
		party.setLooting(false);
		party.setAttackableByAI(false);
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(originTile);
		c.addOrder(move);
		local attack = this.new("scripts/ai/world/orders/attack_zone_order");
		attack.setTargetTile(originTile);
		c.addOrder(attack);
		local destroy = this.new("scripts/ai/world/orders/convert_order");
		destroy.setTime(60.0);
		destroy.setSafetyOverride(true);
		destroy.setTargetTile(originTile);
		destroy.setTargetID(this.m.Origin.getID());
		c.addOrder(destroy);
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"objective",
			this.m.Flags.get("ObjectiveName")
		]);
		_vars.push([
			"direction",
			this.m.Origin == null || this.m.Origin.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Origin.getTile())]
		]);
	}

	function onOriginSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Origin.addSituation(this.new("scripts/entity/world/settlements/situations/besieged_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			foreach( id in this.m.UnitsSpawned )
			{
				local e = this.World.getEntityByID(id);

				if (e != null && e.isAlive())
				{
					e.setAttackableByAI(true);
					e.setOnCombatWithPlayerCallback(null);
				}
			}

			if (this.m.Origin != null && !this.m.Origin.isNull() && this.m.Origin.hasSprite("selection"))
			{
				this.m.Origin.getSprite("selection").Visible = false;
			}

			if (this.m.Home != null && !this.m.Home.isNull() && this.m.Home.hasSprite("selection"))
			{
				this.m.Home.getSprite("selection").Visible = false;
			}
		}

		if (this.m.Origin != null && !this.m.Origin.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Origin.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(2);
			}
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isUndeadScourge())
		{
			return false;
		}

		return true;
	}

	function onSerialize( _out )
	{
		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.contract.onDeserialize(_in);
	}

});
