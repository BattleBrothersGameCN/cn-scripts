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
					"前往%direction%方的%objective%",
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
					"保卫%objective%，抵御亡灵"
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
					"保卫%objective%，抵御亡灵"
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer%正在指导一个年轻的贵族男孩向远处的稻草人瞄准弓箭。他挺直孩子的后背，命令他在射击前深呼吸。这个业余射手点点头照做了。箭射了出去。它摇晃着，弹跳着撞到地上，然后旋转着哐当一声飞进了马厩，几匹马被这可怕的动静吓得嘶叫起来。贵族拍了拍男孩的背。%SPEECH_ON%相信我，我第一次射得更糟。继续练习。我稍后就回来。%SPEECH_OFF%贵族向你走来，摇着头压低声音。%SPEECH_ON%情况很严峻，佣兵。年轻人不知道现在的世道藏着什么危险，但你知道。我们有一个叫%objective%的定居点，就在这里的%direction%边，它被……嗯，灾厄包围了。我抽不出人手，但这正是你发挥作用的时候。去那里拯救村庄，你会得到丰厚报酬，我向你保证！%SPEECH_OFF% | %employer%正凝视着他的一把剑。他拔剑出鞘，盯着钢面上映出的自己的脸。%SPEECH_ON%当我被教导如何使用这东西时，它是对付人的。现在呢？人们谈论着死者，绿皮怪，还有巨大到无法衡量的野兽！%SPEECH_OFF%他将剑猛地插回鞘中，连剑带鞘扔在桌上。他用手梳理着头发。%SPEECH_ON%这里的%direction%方向，%objective%需要你的帮助。它被这些……怪物包围了！我不知道它们是什么，只知道它们不停地杀戮、杀戮、再杀戮！我抽不出人手，但如果你去那里帮助这个城镇，你将得到非常丰厚的回报！%SPEECH_OFF% | %employer%坐在一位修道院院长和一位书记员中间，那两个老人正用颤抖下巴、牙齿格格响的嗓音互相吼叫。鉴于死者复生，关于死亡和身后事的问题已经引发了相当激烈的争论。贵族看到你，跳了起来。他匆匆走向你，背景中的争吵仍在激烈进行。%SPEECH_ON%感谢旧神你来了，佣兵。就在这里的%direction%边，%objective%正被一支恐怖大军围困。亡灵，肮脏的东西，我不知道，我只知道我自己没有人手去保护那个城镇。去那里确保那些人的安全，我会付你丰厚的报酬！%SPEECH_OFF% | %employer%正在监督一群教堂司事将一副棺材放入墓穴。棺材被牢牢钉死，几乎可以说是匆忙钉上的：钉子从木头上弯曲螺旋地伸出，侧面还有抓痕。看到你，贵族走了过来。%SPEECH_ON%这口箱子里的住客决定再出来一趟。杀了一个孩子和一条狗。在守卫把它重新制服之前，差点又杀了一个。%SPEECH_OFF%一股黑色液体从棺材底部涌出。掘墓人跳开，让棺材哐当一声直接掉进了墓穴里。%employer%摇了摇头。%SPEECH_ON%随着这些‘亡灵’的出现，我的兵力已经捉襟见肘。我刚收到消息，这里的%direction%边，%objective%也遭到攻击了。佣兵，你愿意去那里帮忙拯救它吗？%SPEECH_OFF% | %employer%正在研究散落在他书桌上的一堆书籍。他摇着头，每次转头似乎都在翻看另一页。他心烦意乱，匆忙招手让你进去。%SPEECH_ON%别磨蹭，佣兵，我们没时间耽搁。我需要你去这里的%direction%方向的%objective%。我的信使告诉我它正遭受攻击，又是天杀的的‘死人’活了过来。你有兴趣去吗？报酬绝对足以补偿你的辛劳。%SPEECH_OFF% | %employer%正看着一些泥瓦匠拼接切割整齐的石块。他和你握了握手。%SPEECH_ON%又在建一座修道院，佣兵，看起来怎么样？%SPEECH_OFF%看起来不错，但你指出马路对面就有一座修道院。贵族咧嘴一笑。%SPEECH_ON%死者又在地上行走了，周围没有足够的长凳来安置那些受惊的人。听着，我叫你来是因为我的兵力在试图处理这种……亡灵复生的怪事上已经捉襟见肘。这里的%direction%方向有个小镇，%objective%，急需帮助。我的信使告诉我它正遭受攻击，而你看起来正是那个有兴趣拯救它的人。当然，是有偿的。%SPEECH_OFF% | %employer%、一位财政官和一位指挥官正在谈话。财政官说有很多克朗，但指挥官直截了当地说没有可以雇来打仗的人手。你恰好走进房间，立刻成为了话题中心。%SPEECH_ON%佣兵！我们急需你的服务！我们有一个村庄在这里的%direction%边，一个叫%objective%的小地方，正遭受，呃，它们叫什么来着？%SPEECH_OFF%指挥官倾向贵族低声说出了答案。贵族往后一仰。%SPEECH_ON%正遭受……‘亡灵’的攻击。好吧。你愿意去那里保护那些可怜人吗？%SPEECH_OFF% | 你最终在马厩里找到了%employer%。他正在给一匹马备鞍，很快意识到你保持着距离。%SPEECH_ON%害怕了是吗，佣兵？%SPEECH_OFF%你耸耸肩，告诉他你从来就不喜欢这些牲口。贵族也耸耸肩作为回应，然后翻身上马，将腿甩过鞍尾。%SPEECH_ON%随你便。我的信使告诉我%objective%遇到了麻烦，那些麻烦就是一大群亡灵在敲它的大门，而且我不认为它们是给那些镇民送牛奶去的。如果你去那里帮助保护村庄，等你回来时，会有一袋丰厚的报酬在这里等着你。%SPEECH_OFF% | %employer%正在城墙上散步。他周围的守卫异乎寻常地身姿挺拔，背脊笔直，尽职的眼睛搜寻着危险。看到你，贵族招手让你过去。你们一起从城垛间向外凝视。土地在你面前展开，巨大的森林变成了小点，山脉变成了箭头，鸟群以密集的队形弧线飞行。%SPEECH_ON%这里的%direction%方向就是%objective%。信使告诉我它正遭受某种难以置信的力量攻击，确切地说是亡灵。是的，就是那么难以置信。无论什么东西在攻击他们的城墙，我都没有人手去处理。但是你，佣兵，你的服务在这里再合适不过了。你有兴趣吗？%SPEECH_OFF% | %employer%和一个瘦削的书记员正盯着一具放在石板上的无头尸体。头颅在角落里，眼球斜视着，钢杆从它被切掉一半的头骨中伸出。看到你，贵族伸出手邀你过去。%SPEECH_ON%没什么好怕的，佣兵。我相信你已经听说了，死者又在地上行走了，随之而来的是许多人猜测为什么会这样。%SPEECH_OFF%书记员抬起头打断道。%SPEECH_ON%或者怎么做到的……%SPEECH_OFF%贵族微笑着继续说。%SPEECH_ON%总之，这里的%direction%方向的%objective%正遭受这些怪物……呃，死人的攻击？但我没有人手可以派去救援。而你，正好适合这份工作。你愿意接手吗？%SPEECH_OFF% | 你进入%employer%的房间时，他正在听一位书记员的低语。书记员用带着猜疑的眼神瞥了你一眼，然后继续他的谈话。当他结束时，两人都点了点头，老人离开了。他离开时甚至没看你一眼。%employer%大声说道。%SPEECH_ON%很高兴你来了，佣兵！这确实是严峻的时期。我的人手分散在各地处理各种怪物。我相信你已经听说了，那些‘死人’，或者不管它们是什么，又重新在大地上活动了。而且它们正在攻击这里的%direction%方向的%objective%。由于抽不出人手，我就靠你了，佣兵。你愿意帮忙拯救这个城镇吗？%SPEECH_OFF% | %employer%正在听一群农民的恳求。你只赶上了谈话的尾声，贵族正愤怒地挥手让他们离开。这些平民随之大喊大叫，守卫们则围拢过来护送他们出去，事态暂时还算稳定，但如果守卫愿意也可以动用暴力。农民们没有进一步抗议就出了门，不过其中一位瞥了你一眼，无声地说了句‘帮帮我们’才转身离开。%employer%挥了挥手。%SPEECH_ON%哎呀，见鬼，这不是佣兵吗！来得正好，我这位唯利是图的朋友。我这里有%direction%方向的一个城镇，%objective%，急需帮助。据说，它目前正被亡灵围困。如果你去那里帮忙防守，这里有一大袋克朗在等着你。你觉得怎么样，嗯？%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{对你来说值多少？ | 只要价钱合适，我们愿意保卫%objective%……}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{这事不划算。 | 恐怕%objective%只能靠自己了。}",
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
			Title = "%objective%里……",
			Text = "[img]gfx/ui/events/event_29.png[/img]{接近%objective%时，%randombrother%突然从先头位置喊道。%SPEECH_ON%头儿，快来看！%SPEECH_OFF%你冲到他身边向前望去。城镇完全被一片起伏不定、哀嚎着的苍白亡灵之海包围了！%companyname%要想进去，就必须杀出一条血路。 | 一个人朝%companyname%慢跑过来。他捂着一只胳膊，头顶流下一道深红色的血迹。他大喊着。%SPEECH_ON%走，快走！这里除了死人什么都没有！%SPEECH_OFF%%randombrother%将陌生人摔倒在地，拔出武器指着他。你拦住佣兵，同时向前望去：%objective%已经被一大群亡灵包围了。%companyname%需要迅速行动！ | 你们来得正是时候：%objective%的围墙已经遭到亡灵的袭击！ | 拐过一个弯道，你猛地停下脚步。前方，%objective%被一群亡灵包围着。离你们更近的地方，有几个亡灵在徘徊，奇怪地与尸群分开了。%companyname%需要杀出一条路才能进入%objective%！ | %objective%的围墙呈现出奇怪的灰色——等等，那不是木头，是亡灵！令你惊恐的是，那些苍白的怪物已经在进攻了，但你们还有时间拯救%objective%并杀进去。你拔出剑，命令%companyname%投入战斗！ | 一群不成形的亡灵已经在%objective%的墙外徘徊。你能看到守卫者的脑袋从围墙后探出来，努力不暴露自己。你拔出剑，告诉%companyname%他们必须杀出一条路进入城镇。 | 一些亡灵已经到了%objective%的大门口！门楼顶上的守卫朝你们挥手，把一根手指放在嘴唇上，然后向下指。看来这些鬼一样的怪物还没开始进攻，是因为没发现？你不确定，你只知道%companyname%只有一条路可走，那就是靠手中的剑杀出一条路！ | 幸运的是，你发现%objective%依然屹立。不幸的是，围墙正遭受一大群苍白亡灵的冲击。%companyname%必须杀出一条血路才能进去！}",
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
			Title = "%objective%里……",
			Text = "[img]gfx/ui/events/event_79.png[/img]{你发现%objective%里面的守卫看起来像是几周没睡了，但他们却在微笑。显然，你们通过他们前门的笨拙模样至少让他们觉得有些好笑。 | 尽管跌跌撞撞、行动迟缓，%companyname%总算通过了前门。里面，守卫们带着哭笑不得的沮丧神情站着，看起来像是刚从一场可怕的战斗中走出来，却又目睹了一个奇怪的笑话。其中一个拍了拍你的肩膀。%SPEECH_ON%看着可真够乐的，佣兵，我的弟兄们需要提提神。谢谢了。%SPEECH_OFF% | 环顾四周，你看到守卫都是些虚弱、瘦骨嶙峋的人，看守着的镇民看起来也已经半死不活。泥泞的道路上遍布粪便、垃圾和动物尸体。妇女和儿童在一个临时墓地旁哭泣：那是一条沟渠，上面挂着一卷写满名字的卷轴，上面有新鲜的墨迹写着又一个名字。 | 你穿过%objective%的大门，发现几个守卫正在站岗，瘦削的手搭在长矛上。他们的衣服在他们骨架上晃荡，就像开着的窗户两边的窗帘。空气中弥漫着浓厚的饥饿感，你仅仅因为健康地出现在这里而招致的咂嘴注视就反映了这一点。一名守军相当热情地招呼你。%SPEECH_ON%我们累了，还有点饿，但我们能挺住。我们还有斗志，这点你不用怀疑。%SPEECH_OFF% | 当你进入%objective%的大门时，首先迎接你的是一条狗，它舔着你的腿，使劲嗅着你的裤子。一个男人突然举着棍子叫喊着冲过来，很快人和狗就在泥泞的路上追逐起来，两者似乎都在吠叫。那杂种狗躲开了一群饥饿者的缓慢围堵，完全消失了。一个咧嘴笑的守卫拄着棍子走过来保持平衡。%SPEECH_ON%晚上好，佣兵。粮食储备有点低，在这片饿肚子的地方，那狗子可是绝好的猎物。%SPEECH_OFF%你问他们是否还能战斗，那人大笑起来。%SPEECH_ON%见鬼，我们剩下能做的就只有战斗了！%SPEECH_OFF% | 进入%objective%的前门，就像是穿过现世的帷幕步入地狱深渊。村民们蹒跚而行，无事可做，只能越来越饿，守卫们分享着笑话，就像分享食物一样，一边痛苦地大笑一边捂着肚子。防御负责人走了过来。他胡子拉碴，满身伤疤，下巴松弛，眼睛看起来疲惫不堪。尽管他站在一步之外，却像是从另一个世界在盯着你。%SPEECH_ON%很高兴你来了，佣兵。我们这些天确实需要你的帮助。%SPEECH_OFF% | 你穿过%objective%的大门，发现地狱本身正等着你。站岗的守卫们像被疯子支起来的骷髅，村民们则无所事事地站着，或躺在泥土里，或脸朝前靠在墙上。孩子们站在茅草屋顶上，在稻草里翻找虫子。守军指挥官直白地欢迎你。%SPEECH_ON%谢谢你来了，佣兵，但你真该呆在家里的。%SPEECH_OFF% | %objective%的前门猛地歪开一条缝，然后缓慢地转动打开，开门人费力地推动着机关。你进入镇子，看到一群教堂司事正在路边挖一个巨大的沟渠。他们把尸体倒进去，准备生火焚烧。守军指挥官走了过来。%SPEECH_ON%有时死人会回来，但我们知道骨灰不会。嗯，也许骨灰也会，但它们害不了人。%SPEECH_OFF%你想提一嘴那可怕的恶臭，但意识到他们可能早就习惯了。 | 在杂乱不堪的%objective%大门后面，城镇看起来简直像是已经屈服于亡灵大军了。村民们绝望地漫无目的地蹒跚而行。几个守卫站在一辆马车旁，挨家挨户分发口粮。你看到一些守军在围墙边睡着了，胳膊半搭在城垛上，手里还握着武器，看起来像被扔在角落的傀儡。守军指挥官走了过来。%SPEECH_ON%谢谢你来了，佣兵。我们中很多人都觉得你不会来，因为这儿根本就是地狱。%SPEECH_OFF% | %objective%的前门打开了，你走了进去。里面，你看到两个守卫正拖着一具尸体走向一个燃烧着的尸堆。一个女人紧紧抓住死者的靴子，求他们让她看最后一眼。他们不理她，把尸体扔进火里，她倒在火堆前，瘫软下去，而她丈夫的皮肤在火中噼啪作响。守军指挥官走了过来。他拍了拍你的肩膀。%SPEECH_ON%很高兴你来了，佣兵。%SPEECH_OFF% | 穿过%objective%的大门，你遇到一个男人抓住你的衣领。%SPEECH_ON%你身上有吃的吗？嗯？我闻到了，还是说你就是吃的？%SPEECH_OFF%一个守卫用矛尾把他撬开。这个疯子捂着肚子，一边从眉毛上抓虱子吃一边说话。%SPEECH_ON%你们又带了些剑来，但我们需要的不是剑！%SPEECH_OFF%守卫把那人带走了，这时指挥官走了过来。%SPEECH_ON%别介意他。他以前是个胖子，所以对近来的情况特别不满。我们这儿还有食物，只是必须定量配给。我们非常需要你带来的剑，佣兵，而且，别搞错，你很快就会用上它们的。%SPEECH_OFF% | 你踏进%objective%的大门，迎面而来的是烧焦皮肉的气味。有一堆闷燃的尸体，一个守卫拿着棍子站在旁边，像厨师搅拌大锅一样搅动着。村民们站在烧焦的遗骸旁，一边向空中比划着宗教手势，一边擦拭着眼泪。镇里的指挥官走了过来。%SPEECH_ON%哪里都可能发生袭击。死人不停地复活，而我们这镇子为此吃了大苦头。这堆曾是一家人。妻子在夜里死了，然后借着黑暗的掩护，不停地吃人。现在我们选择烧掉所有的尸体。必须这么做。%SPEECH_OFF%指挥官看见你皱着眉头，轻松地笑了笑。%SPEECH_ON%那么，你今天过得怎么样？%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们得为接下来的攻势做好准备……",
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
			Title = "%objective%里……",
			Text = "[img]gfx/ui/events/event_29.png[/img]{就在无聊的等待快要杀死你的时候，别的东西过来抢走了这一任务：亡灵！%objective%的钟声开始鸣响，守卫们以一种前所未见的活力匆忙行动起来。你命令%companyname%准备战斗。 | 当你看着弟兄们打牌时，钟声开始响起。你瞥向当地的修道院，看到一个病恹恹的老人身影正在拼命敲钟。守卫们听到钟声后全部打起精神。一个声音从门楼传来。%SPEECH_ON%他们来了，拿起武器，拿起武器！%SPEECH_OFF% | 就在你以为自己已经和镇民一样，只能站着等死的时候，前门打开了，一名哨骑疾驰而入。精疲力竭的牲口倒下并在泥地里滑行，骑手则跳下马翻滚开来。他站起身喊道。%SPEECH_ON%死人来了！我们得准备好！%SPEECH_OFF% | 哨所顶上的一个人喊道。%SPEECH_ON%有消息到，小心脑袋！%SPEECH_OFF%你抬头看到一支箭划过天空，旋转着落下，就插在离你不过几尺远的泥地里。指挥官从箭上取下一卷纸条。他越读嘴唇抿得越白，然后把纸扔到一边。%SPEECH_ON%该准备了，佣兵，死人要来了。%SPEECH_OFF%他转向他的士兵们。%SPEECH_ON%%objective%的战士们！拿起武器！%SPEECH_OFF% | 一个守卫喊道。%SPEECH_ON%大门开了，难民来了！%SPEECH_OFF%零星几个孩子从猛然打开的门中跌撞而入。其中一个解释说有一大群面色苍白的人来了。指挥官盯着你。%SPEECH_ON%你最好让你的人准备好，佣兵。%SPEECH_OFF%亡灵正朝这边来，准备战斗！ | 一名哨骑进入%objective%，从一匹双腿染血、尾巴不见了的马上下来。骑手抱着一条没了手的胳膊，他的脸被削掉了一只耳朵和一只眼睛。指挥官冲过去，两人在哨骑昏倒前交谈了几句。指挥官叹着气，站起身来说。%SPEECH_ON%亡灵来了，大家准备好！给那匹马个痛快！%SPEECH_OFF%你点点头，命令%companyname%做好战斗准备。就在佣兵们准备时，一个穿着屠夫衣服的人走过来，用切肉刀把马砍死了。指挥官拍了拍你的肩膀。%SPEECH_ON%嘿，如果我们能活下来，至少有顿好的吃了。%SPEECH_OFF% | 你在指挥官旁边坐下。他掰开面包。%SPEECH_ON%自从你来了以后，安静得可怕。%SPEECH_OFF%你咬了一口，问他是不是在暗示你是亡灵的卧底。他笑了。%SPEECH_ON%这年头没法太确定。%SPEECH_OFF%就在这时，一座钟楼敲响了钟，守卫们冲向城墙。叫喊和尖叫声爆发了。亡灵来袭！\n\n指挥官戴上头盔，拉你起来。%SPEECH_ON%是时候证明你的价值了，佣兵。%SPEECH_OFF% | 一名守军拿起一个用皮革包裹的望远镜，开始透过城墙的垛口窥视。他的手开始颤抖，望远镜从皮套中晃了出来，在石头上摔碎了。他指着远处尖叫。%SPEECH_ON%亡、亡灵来了！拿、拿起武器！敲钟！%SPEECH_OFF%你望向墙外，但根本不需要望远镜就能看到那片苍白的浪潮正向你们涌来。你告诉那名守卫冷静下来，然后急忙让%companyname%准备战斗。 | 一群狗来到%objective%，嚎叫着想要进来。饥饿的镇民满足了它们的愿望，而这些杂种狗一进来就遭到了刀子和镰刀的袭击。尽管遭到屠杀，狗群仍不断涌来，挣扎撕咬着，试图在这个屠宰场里找到安全。你望向墙外，想看看它们为何愿意冒这个险：亡灵来了！它们蹒跚着、拖沓着、笨重地出现在地平线上。\n\n你向站在钟楼里的一个人吹口哨，并指给他看。他猛地挺直身子，快得让他的金属头盔都掉了下来，叮叮当当地滚下石塔。他急忙敲响钟，洪亮的钟声压过了下面残酷的屠宰活动。人和狗都停下来抬头看，一种沉闷的寂静笼罩了所有人。渐渐地，亡者的喧嚣、呻吟和咆哮声，渗透进空气里。守军指挥官跳了出来，武器已经拔出。%SPEECH_ON%拿起武器，弟兄们！拿起武器！%SPEECH_OFF% | 一个亡灵在%objective%的墙外蹒跚而行。守卫们轮流试图用箭射它。%SPEECH_ON%快看那个，射中他的脚了！%SPEECH_OFF%另一个守卫准备好他的射击。%SPEECH_ON%他还在走。瞄准脑袋，你这傻瓜。%SPEECH_OFF%这一箭射中了，发出轻轻的“咚”的一声，箭头刺入了一个空空的脑壳。亡灵失衡并停顿了一下，然后继续前进，仿佛刚刚记起自己打算做什么。另一个守卫摇摇头，准备好他的射击。他闭上一只眼，然后慢慢睁开。他的手开始颤抖，箭杆在木弓上格格作响。%SPEECH_ON%拿、拿、拿起……呃，拿起武器！拉响警报！%SPEECH_OFF%你望向墙外，看到一片灰色的海洋在地平线上浮现，上下浮动、笨重地移动着。亡灵来袭了！ | 镇子里很安静，火焰轻柔的噼啪声充斥着这沉闷的空气。你看着人们用签子烤着一只老鼠，然后开始切片分食。看够了，你走上城墙，发现守军指挥官正用望远镜观察地平线。他阴沉地放下望远镜。%SPEECH_ON%狗日的，他们来了。%SPEECH_OFF%他把望远镜递给你，你看了一眼。一大群眼睛发泡、形态扭曲的亡灵正蹒跚着走向%objective%。指挥官拿回他的望远镜。%SPEECH_ON%是时候干活挣钱了，佣兵。%SPEECH_OFF% | 一个女人的尖叫声让你回头望去。你刚好看到一个人从塔楼上跳下，随后被套在颈部的绳索折断了脖子。尸体摇晃着撞击在石墙上。守军指挥官怒气冲冲地啐了口唾沫。%SPEECH_ON%该死的，他是负责瞭望的。%randomname%！上去，把他解下来，接替他的岗位！%SPEECH_OFF%另一个守军咕哝着照做了，但当他登上岗哨后，他就不再听从任何命令了。相反，他开始歇斯底里地喊叫。%SPEECH_ON%长官！长官！他们来了！所有那些脸色苍白的人，他们来了！%SPEECH_OFF%指挥官朝他的手下大喊准备战斗，你也对你的手下下令。指挥官转向你，带着一种期望的神情。%SPEECH_ON%不管他们付你多少钱，我希望你物有所值，佣兵。%SPEECH_OFF% | 一名守军发现了一窝老鼠，这引发了一场既悲哀又不可思议的庆祝。当镇民们欢呼哭泣，老鼠尖锐的叫声在签子和火焰中消失时，守军指挥官走了过来。他微笑着观察这一幕，但当一声尖锐的尖叫划破空气时，笑容消失了。所有人都转向城墙，哨兵正指着地平线。即使站在远处的你，也能看到他因惊恐双眼里的眼白。%SPEECH_ON%死人来了！他们来杀光我们了！我们人手不够！%SPEECH_OFF%指挥官让那人提起胆量，然后悄悄转向你。%SPEECH_ON%让你的人准备好，佣兵，证明你值他们付的每一个子儿。%SPEECH_OFF% | 一个企图逃跑的守卫被抓住了。他跪在地上，而守军指挥官来回踱步，带着失望的神情审视着。%SPEECH_ON%我们一个人都损失不起，而你却选择这样对我们？%SPEECH_OFF%一个镇民扔过来一团泥块，没打中，但意图很清楚。%SPEECH_ON%把他活埋了！少一张嘴吃饭！%SPEECH_OFF%就在农民们开始骚动时，镇上的钟开始当当响起。瞭望塔顶上的人用尽全力大喊。%SPEECH_ON%他们来了！亡灵，他们在地平线上！%SPEECH_OFF%指挥官低头看着逃兵。%SPEECH_ON%如果你想赢回你的荣誉，现在就是机会。你愿意战斗吗？%SPEECH_OFF%那人快速点头。指挥官转向你，但你抬手制止。%SPEECH_ON%你无需问%companyname%这样的问题。%SPEECH_OFF%}",
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
			Title = "%objective%里……",
			Text = "[img]gfx/ui/events/event_73.png[/img]{%companyname%正在休息，清理刀刃上令人作呕的粘稠物。此时钟楼又传来了信号。亡灵再次发动了攻击！ | 守军指挥官四处巡视，确保他的手下得到所需的休息和饮用水。正当他过来要和你谈话时，镇上的钟敲响了，哨兵大喊又一次攻击即将来临！你咧嘴一笑，拍了拍指挥官的肩膀。%SPEECH_ON%我们只管做该做的事。没什么比这更简单了，对吧？%SPEECH_OFF%指挥官点点头，去让他的手下做好准备。 | 你看着%randombrother%擦去刀刃上苍白的肉块和湿透的碎布。%SPEECH_ON%旧神在上，它们弄得这脏死了。%SPEECH_OFF%就在这时，一个哨兵吹响哨子，大声呼喊亡灵又攻过来了！这名佣兵愤怒地从武器上甩掉一串脑浆。%SPEECH_ON%我刚开始能照出人影儿！%SPEECH_OFF%你拉他站起来，拍了拍他的肩膀。%SPEECH_ON%相信我，你没错过什么好看的。%SPEECH_OFF% | 一个守卫把一个硬面包卷掰成碎屑，开始分发这些碎渣。另一个守卫问他从哪儿弄来的，那人直截了当地回答。%SPEECH_ON%从某个亡灵的口袋里翻出来的。%SPEECH_OFF%正在吃的人把食物吐了出来，有一个甚至呕吐了。你看着这些人开始打斗，但很快就被哨兵的哨声打断了。塔楼顶上的守卫正指着地平线。%SPEECH_ON%他们又来了！准备战斗！%SPEECH_OFF%准备战斗吧，并尽量别从那些把你也当成午餐的尸体上搜刮食物。 | 当你的手下正在休息恢复时，一个哨兵喊了起来。%SPEECH_ON%他们又来了！%SPEECH_OFF%战争很少给人像样的休息时间，尤其是与亡灵的战争。 | 你看到%randombrother%用泥巴擦脸。他停下来，瞥了一眼正盯着他的你。%SPEECH_ON%泥浴，头儿。你知道，用来洗掉那些血。%SPEECH_OFF%你翻了个白眼。就在这时，镇上的钟开始当当响起，一个哨兵大喊，发现又一轮攻击正在路上！你告诉那个佣兵赶紧结束他的“沐浴”，准备战斗。 | 你发现%randombrother%正从耳后清洗出一串串灰色的内脏组织。%SPEECH_ON%妈妈常说别忘了洗耳朵后面，但我觉得她可没想到会是这种脏东西！%SPEECH_OFF%你告诉他，一个好母亲能想到一切。那人大笑着点头。%SPEECH_ON%是啊，她只会冲我嚷嚷，问我从哪儿搞来这一身脏！%SPEECH_OFF%就在这时，塔楼上的一个哨兵大喊亡灵又攻过来了。你转向那个佣兵。%SPEECH_ON%好吧，是时候再把自己弄脏一次了。%SPEECH_OFF% | 你发现一个农民正在石墙上刻划线条。看到你，他解释道。%SPEECH_ON%只是统计一下损失的人数。人太多了，我记不住他们的名字，但我能数数。%SPEECH_OFF%你顺着墙看去，发现墙上逐渐从名字变成了数字。%SPEECH_ON%我们尽力记住，你知道吗？%SPEECH_OFF%你点点头，然后，像是约好了一样，哨兵们喊叫起来，宣布又一轮攻击即将到来。那个农民带着恳求的表情抓住你的胳膊。%SPEECH_ON%告诉我你的名字，到时候我会帮你刻上去。%SPEECH_OFF%你猛地抽回胳膊，瞪着那个人，用愤怒的目光让他畏缩。%SPEECH_ON%我是个杀手，你这傻瓜，不是你的朋友。我的刀没架在你脖子上的唯一原因，是没人付我钱。如果你再问我那个问题，我就把你的数字刻在那墙上，而且不收钱，明白吗？%SPEECH_OFF%那人点点头。你也点点头，然后离开去让你手下的佣兵们准备战斗。 | 就在你和手下刚安顿下来休息时，哨兵们大声呼喊，镇上的钟开始敲响。又一轮攻击即将到来！你命令%companyname%准备战斗。 | 你爬上%objective%的城墙，找到了守军指挥官。他叹了口气。%SPEECH_ON%他们在进攻。又来了。%SPEECH_OFF%你望向地平线，确实，又一波敌人正在路上。指挥官去集合他的手下准备再次战斗，你也去做同样的事。}",
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
			Title = "%objective%里……",
			Text = "[img]gfx/ui/events/event_73.png[/img]{当所有战斗人员都在休息时，一个哨兵用嘶哑地喊道，声音带着挫败和绝望。%SPEECH_ON%又来了。它们来了……又来了。%SPEECH_OFF%如果%objective%想要活下去，%companyname%必须挺身而出迎接挑战！ | 一个守卫正盯着火焰，双手颤抖。他喃喃自语，但声音慢慢变大，让所有人都能听到。%SPEECH_ON%对，我们就这么办！我们可以谈判！我们跟它们做个交易！我们去跟它们谈谈！我来，我去跟它们谈！%SPEECH_OFF%那人站了起来。有几个人试图把他拉下来，但他挣脱了。他跑到墙边翻了过去。你冲过去，看到那个精神错乱的傻子穿过田野——径直冲向一大波亡灵！另一个守卫看着，开始发抖。%SPEECH_ON%旧神在上，还有？怎么可能还有？%SPEECH_OFF%你没理他，看着那个疯子消失在尸群中。亡灵的队伍踉跄着吞没了这个闯入者，然后继续前进，就像苍白的池塘被石头短暂地激起涟漪。你朝你的手下大喊。%SPEECH_ON%准备战斗，弟兄们！我们又要赴汤蹈火了！%SPEECH_OFF% | 一个哨兵发现又一次攻击来了！他尖叫着，声音嘶哑，然后昏了过去。%objective%的民兵已经接近崩溃，希望这是最后一次袭击了！ | 一个哨兵吹响哨子警告说更多亡灵来了。守军指挥官摇了摇头。%SPEECH_ON%旧神在上，它们到底会不会停止进攻？这次请你过来真是值了，佣兵。%SPEECH_OFF%你想开玩笑说也许还能更值，但这似乎不是个好时机。于是你点点头，走开去让%companyname%准备另一场战斗。 | 当你和守军指挥官交换战争见闻时，一个民兵走了过来。你注意到他是负责监视城墙的人。他直截了当地说。%SPEECH_ON%长官们，它们又攻过来了。%SPEECH_OFF%说完他就转身向镇军械库走去。你起身扶指挥官站起来。他拍了拍你的肩膀，带着简短而严肃的微笑。%SPEECH_ON%又要上阵了，嗯？%SPEECH_OFF%你只能耸耸肩。%SPEECH_ON%我们就是为此而来的。战场上见，指挥官。%SPEECH_OFF% | 你凝视着%objective%的墙外，看到又一波亡灵来了。之前几次攻击带来的所有激动都已消失。现在守军们只是沉默地看着尸体蹒跚前行。守军指挥官来到你身边。%SPEECH_ON%与你并肩作战是我的荣幸，佣兵。%SPEECH_OFF%你点点头回应。%SPEECH_ON%嗯，荣幸，当然。%SPEECH_OFF%指挥官看着你。%SPEECH_ON%你在想你的报酬，对吧？%SPEECH_OFF%你又点点头，回答道。%SPEECH_ON%我在想它能买什么：一张温暖的床，一顿热腾腾的饭，还有一个火辣的姑娘。%SPEECH_OFF% | 你站在%objective%的城墙边，眺望地平线。又一次攻击即将到来，但面对它已毫无兴奋感。没有尖叫，没有歇斯底里。不会再有了。就只是又一场战斗而已。一支臃肿、蹒跚、形状怪异的尸体大军，咕哝着、笨重地向前涌来，前来与你死战一番。你命令%companyname%做好准备。%randombrother%难以置信地张开双臂，他半边身子都糊满了被撕碎亡灵的湿漉漉残骸。%SPEECH_ON%头儿，我觉得我们早就做好准备了。%SPEECH_OFF%人们大笑不止，民兵们也加入进来，很快欢闹声充斥空中，其中部分还夹杂着越来越近的亡灵的呻吟，疯狂已成常态。 | %randombrother%走到一堆营火旁，从肩膀上扯下长长的内脏扔到一边。一个农民盯着那些内脏，仿佛再饿一点就要咬上一口了。佣兵扑通一声坐下，很不舒服的样子。%SPEECH_ON%要是再看到一个尸体像饭点到了似的朝我走来，我就要……%SPEECH_OFF%他话还没说完，墙上的一个哨兵就拼命吹响号角，发出所有人都能听到的警告。他把号角丢在一边，脸涨得通红，上气不接下气。%SPEECH_ON%亡……亡灵……它们又攻过来了！%SPEECH_OFF%佣兵的脸一下子僵住了。他站起身，一言不发，慢慢去拿起武器。 | 一个农民站在%objective%的大门口。他正在和守门人争论。%SPEECH_ON%让我出去！你们肯定把它们都打跑了，我想回我的农场去。我跟你们说，我有两头奶牛呢！%SPEECH_OFF%这人伸出两根手指，生怕听的人不明白。守门人耸耸肩，打开了大门，但农民却没有动。相反，他后退了一步。%SPEECH_ON%再一想，奶牛可以等我回家。%SPEECH_OFF%墙外，你看到一大群亡灵正涌现在地平线上。没过多久，警告信号就发出了，%objective%一片忙碌，人们跑来跑去，拿起武器准备迎接又一场战斗。 | 你在城墙边遇到了守军指挥官。他正在和几个民兵分面包，也递给你一块。你拒绝了，并问地平线那边有什么。指挥官指向田野。%SPEECH_ON%哦，没什么，只是它们又来了。%SPEECH_OFF%他递给你一个望远镜。透过它，你看到一大群尸体正蹒跚着走向%objective%。你放下望远镜，问他为什么还没拉响警报。他耸耸肩。%SPEECH_ON%给弟兄们多一两分钟时间。这些行尸走肉也许想杀光我们，但它们又不着急，你懂吗？%SPEECH_OFF%可以理解。你接过了那块面包吃了，过了一两分钟后，你去让%companyname%准备战斗。 | 一个民兵把一具活死人带到了围墙后面。他用一条链子拴着它，尸体的胳膊被砍掉了。本该是嘴的地方耷拉着一条长长的舌头。守军指挥官走了过来。他的脸涨得通红，看起来像溺水的人需要呼吸一样急需骂人。%SPEECH_ON%你狗日的王八蛋他妈的在搞什么天杀的鬼名堂？%SPEECH_OFF%民兵猛拉链子，把亡灵拽倒在地。他紧张地为自己辩解。%SPEECH_ON%也许我们能从它们身上学到点什么？弄清楚它们为什么会动，还有，我也不知道，也许能把它们变回来？%SPEECH_OFF%没等争论继续下去，一声喊叫打断了众人。瞭望塔顶的一个守卫正在警告又一次袭击。指挥官手持利刃，猛地转身，迅速砍下了那个死人的头。没有下巴的脑袋直接从脖子上滚落，舌头在根部乱甩，像罐子里的蛇一样。指挥官揪着民兵的领子把他拉过来。%SPEECH_ON%别再他妈搞这种鬼东西了，明白吗？它们死了。仅此而已。现在滚去拿你的武器。%SPEECH_OFF%%companyname%已经严阵以待，无需你下令。 | 镇上的铁匠正在敲打%objective%的“顶级”武器。他粗壮的手臂挥舞着锤子，抓着钳子，一副举重若轻的样子。他手弯处纹着一个无限符号。火星像萤火虫一样螺旋飞舞，他很快注意到你的影子在他露天店铺里狂乱地晃动。%SPEECH_ON%嘿，佣兵。%SPEECH_OFF%既真心好奇又实在无聊，你问他怎么样。他锤平一块钢，把它翻过来，重复这个过程。%SPEECH_ON%以前更好。现在不赖。这个看起来怎么样？%SPEECH_OFF%铁匠把刀刃转过来让你品鉴。你还没来得及回答，警报钟就当当地大声敲响，引发一阵忙乱，人们冲出去保卫城镇。民兵们开始跑过，从他店铺周围挂着的钩子上抓起武器。他放下刀刃，大笑起来。%SPEECH_ON%罢了，去战斗吧，佣兵。反正也是随口一问。%SPEECH_OFF% | %objective%的书记员拿着一卷羊皮纸走来走去。他正用一个仆人的背当桌子，写下他所看到的一切。你很好奇，在这片混乱之中，他究竟在看什么？那人直截了当地回答你。%SPEECH_ON%研究情绪。我觉得悲伤是一种疾病，而且正在这里蔓延。%SPEECH_OFF%古怪问题的古怪答案令人更加好奇。于是你又追问了一遍他的研究。他无视了问题，上下打量着你。%SPEECH_ON%根据我的衡量，你健康状况极佳，佣兵。嗯，除了你的身体。你走起路来像条瘸腿的狗，向左转时会龇牙咧嘴。这一眼就能发现。但我看得出疼痛并没有阻碍你。事实上，我会说它……驱动着你。你是在弥补某些被夺走的东西吗？%SPEECH_OFF%你没来得及回答——本来是想叫他闭嘴——警报钟声就打断了一切。人们开始匆忙行动，准备迎接下一次亡灵攻击。当你转过身时，书记员已经不见了，他站在某个遥远的角落，用他那尖锐的羽毛笔在他那做愁眉苦脸的仆人背上奋笔疾书。 | 当你正准备安顿下来休息一下时，警报钟声响起，墙上的哨兵们随之发出一片尖叫。看来亡灵又攻过来了！你急忙让%companyname%准备好迎接另一场战斗。 | 你注意到墙头落满了秃鹫，变得黑压压的。这些大鸟凝视着镇内，像一支披着斗篷的送葬队伍一样观望着。突然，一个民兵从瞭望塔的门里出来，用棍子打碎了一只鸟的脑袋。短暂地嘎了一声后，剩下的秃鹫挪了挪脚，像涟漪池塘上的睡莲一样。接着民兵又打碎了第二只鸟的头，这些食腐动物这才大概明白发生了什么事，纷纷飞走了。猎人提着战利品的脚摇晃着，自豪地回到了瞭望塔。%SPEECH_ON%嘿。%SPEECH_OFF%守军指挥官拍了拍你的肩膀。你转过身时，他用拇指朝自己身后指了指。%SPEECH_ON%亡灵又攻过来了。我命令弟兄们别拉警报。你知道，免得我们的大喊大叫和歇斯底里反而把更多那些杂种引过来。%SPEECH_OFF%似乎是个合理的想法。}",
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
			Text = "[img]gfx/ui/events/event_46.png[/img]{你们赢得了战斗，但民兵队伍却只是惨胜：城镇守卫伤亡如此惨重，以至于更多的居民正在收拾行装准备彻底离开村庄，而不是留下来协助防御！ | 胜利了，但代价是什么？如此多的民兵在战斗中丧生，以至于%objective%的居民无人愿意接替他们的位置！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "赢了就是赢了。",
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
			Text = "[img]gfx/ui/events/event_46.png[/img]{战斗已经赢了，但并非没有损失。%objective%的一些居民报名帮助保卫城镇，而另一些人则收拾行装准备离开。 | 你赢得了这场战斗，但亡灵也让你们付出了沉重代价。虽然部分居民同意加入民兵队，但同样多的人则保持距离，为最坏的情况做准备。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "赢了就是赢了。",
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
			Text = "[img]gfx/ui/events/event_80.png[/img]{多么辉煌的胜利！不仅亡灵被击退，而且你们的成功如此辉煌，以至于%objective%的许多居民都加入了民兵队伍，准备迎接未来的战斗！ | 亡灵已被彻底击溃，%objective%的许多居民纷纷加入民兵，以协助未来的战斗！}",
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
			Title = "%objective%里……",
			Text = "[img]gfx/ui/events/event_69.png[/img]{当你准备战斗时，你注意到一些奇怪的身影在亡灵队伍中移动：食尸鬼。这些生物必定是跟随着亡灵大军，以便吞食它们杀死的一切，就像海鸥跟随海上的渔船一样。 | 食尸鬼！这些肮脏的生物在尸群中奔跑、跳跃，这些该死的野兽无疑正在寻找下一餐。 | 亡灵所过之处留下了大量死者和垂死之人，毫不意外地出现了些食腐动物尾随它们。这一次，是食尸鬼，这些丑陋的野兽咆哮着、龇着牙，饥渴地期待着它们的下一餐。 | 在食品储藏室乱搅一通，必定招来老鼠。而现在亡灵攻击%objective%，它们身后就招来了一群食腐动物——食尸鬼。}",
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
			Text = "[img]gfx/ui/events/event_46.png[/img]{你凝视着战场。那里遍布着死者、垂死者、不死者，以及垂死的不死者。活着的、呼吸着的人们在泥泞中行进，结果任何略微像是死而复生的东西。战斗已经结束，城镇得以保全，%employer%现在应该正等着你。 | 战斗结束，城镇得救。是时候回去找%employer%领取丰厚的报酬了。 | %objective%看起来更像一个被淹没的墓地，而非你所知的任何城镇。新旧尸体遍布大地，血水和发霉的污秽环绕着每一具。这恶臭让你想起曾在溪边发现的一条死狗，骨头上滴着腐液，尸体被鳌虾和蛆虫啃食。\n\n无休止的攻击终于停止了，%objective%眼下似乎安全了。%employer%应该正等着你，而你没有理由不尽快逃离这个恐怖的地方。 | 好了，城镇得救了。农民们拿着长棍在战场上走动，像鹈鹕在最危险的水塘边试探一样戳着土地。%randombrother%走了过来，擦去刀刃上的污垢，问是否该回去找%employer%了。你点点头。越早回去拿报酬越好。 | 战斗结束了。死者中有农民和民兵，每个都有幸存者在旁，他们哭泣的身影笼罩着尸体。至于死去的亡灵，嗯，没人在乎。那些尸体躺在那里，仿佛来时毫无目的，却在离去时彻底摧毁了它们触及的一切。它们的尸体，以及它们所代表的混乱与虚无，看着着实令人愤怒。你一刻也不想多待，通知兄弟们准备返回%employer%处。 | 你和%companyname%赢得了胜利。城镇及其居民暂时得以幸存，你可以回去找%employer%领取报酬了。 | 守军指挥官感谢你拯救了城镇。你说你来这里的唯一原因是有人付了钱。他耸耸肩。%SPEECH_ON%我会感谢不受我掌控的雨水，我也会感谢你，佣兵，不管你喜不喜欢。%SPEECH_OFF% | 战斗结束了，而且谢天谢地，赢了。亡灵的尸体杂乱地散落在地上，看上去和几小时前它们蹒跚而行时几乎没什么不同。但那些刚死不久的人则没有这种彻底的死寂。他们周围有哀嚎的妇女和困惑的孩子围着。你移开视线，命令%companyname%准备返回%employer%处。 | 一个死人躺在你脚下，旁边是一具亡灵尸体。这是最奇怪的景象，因为他们同样离开了这个世界，但那人身上尚存一丝生气，那是关于他不久前记忆的余息。你看到他战斗到了最后一刻。一名战士高尚的死法。那这具亡灵尸体呢？它算什么？你会记得它用牙齿撕开了一个人的喉咙。也许这尸体在那一刻之前有过别的时光，有过家人，曾是个在这世上行善的好人。但现在它只是个撕扯喉咙的怪物。它将被铭记的也只有这个。\n\n对%objective%的无情攻击终于停止了，于是你急忙召集战团，准备返回%townname%的%employer%那里。丰厚的报酬比再多看一眼这烂摊子强多了。 | 什么是死人？那死了两次的死人呢？死了三次的死人又算什么？不幸者、更不幸者、笑话。\n\n你走在战场上，召集%companyname%的成员。%objective%镇暂时得救了，是时候回%townname%找%employer%领取应得的薪酬了。 | %randombrother%用一块布擦了擦额头，留下了一道恶心的苍白液体痕迹。%SPEECH_ON%妈的，这是啥？是脑浆吗？长官，帮帮忙？%SPEECH_OFF%你帮这人把自己擦干净。他后退一步，张开双臂。他身上仍然沾满了血、内脏和一些可能永远无法得知是什么的东西。%SPEECH_ON%我看起来怎么样？%SPEECH_OFF%他的笑容从污秽中亮出，如同苍白天空中的一弯月牙。你拒绝回答，只让他去把兄弟们集合起来。既然%objective%暂时安全了，%employer%正等着战队返回%townname%，而战队也正等着领取应得的薪资。 | %randombrother%来到你身边，你们两人一同俯瞰战场。你已经能看到死者的家属出来寻找他们失去的亲人。他们的哀嚎尖厉、带着人性的音调，驱散了亡灵那咆哮、呻吟的死寂。这名佣兵拍了拍你的肩膀。%SPEECH_ON%我去把兄弟们集合起来，这样我们就能回%townname%领酬金了。%SPEECH_OFF% | 你看着妇女们在战场上蹒跚而行，提着裙摆，如同湿漉漉的禽鸟避开池塘的淤泥。当然，一旦她们找到了寻找的目标，便全然不顾洁净，扑进污秽之中，哀嚎哭喊，将自己沾染上那些以可憎的漠然姿态夺走她们父兄丈夫性命的恐怖。\n\n%randombrother%来到你身边。%SPEECH_ON%头儿，没有新的敌人了，兄弟们准备好返回%townname%了。就等你下令。%SPEECH_OFF% | 守军指挥官来到你身边，同你握手。握手时，干涸的血块裂开剥落。他双手叉腰，对着眼前的景象点了点头。%SPEECH_ON%你干得很好，佣兵，没有你我们不可能成功。我本想给你更多奖励作为感谢，但这个城镇需要所有资源来重建。我真心希望%employer%能付给你应得的全部报酬。%SPEECH_OFF%你也希望如此。}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{你进入%townname%，发现%employer%正从阳台上眺望。他刚向你打招呼，一个守卫就把一袋克朗塞进你怀里。%SPEECH_ON%佣兵！很高兴你回来了！我的小鸟们早已告知我你的成果。希望你把这些克朗花在刀刃上！%SPEECH_OFF%你还没来得及说什么，那人就转身离开了。递给你克朗的守卫也早已不见。农民们像绕开路标一样绕着你走，仿佛你指向的是他们永远不会去的地方。| 你发现%employer%正在对一个孩子拳打脚踢，最后一脚猛踹在胸口把他踢进了土里。看到你，贵族擦去额头的汗水，为自己解释道。%SPEECH_ON%不关你的事。%SPEECH_OFF%那孩子手脚并用撑在地上，一只手捂着肚子，另一只手擦拭着流血的鼻子。渐渐地，他站了起来，在那里摇晃着，视野模糊的眼睛眨出了血红色。一个仆人过来开始往他身上轻轻拍水，但贵族一把抓过布扔到一边。%SPEECH_ON%你以为那样他就能学乖吗？如果你想帮谁，就帮帮这位佣兵。他还等着拿%reward_completion%克朗。快去快去。%SPEECH_OFF%仆人点点头迅速离开。你待了一会儿，看着殴打继续。孩子没有哭喊，因为他对这种惩罚已经习以为常。几分钟后，仆人突然再次出现，手里拿着一个袋子。他把它交给你，并低声诚恳地建议你离开。 | %employer%俯身在他的桌子上，手臂僵硬地撑得又长又直，低着头凝视着一只死乌鸦。%SPEECH_ON%今天早上在我床上发现了这只乌鸦。就躺在那儿。死了。你知道这意味着什么吗？%SPEECH_OFF%你推测说，也许，是个玩笑。贵族嗤之以鼻。%SPEECH_ON%不。我认为这和你有关，佣兵。你拯救那个城镇做得很好，但也许它本不该被拯救？也许这就是这只鸟所代表的。也许死者接下来会来找我，因为我让死神欠收了。%SPEECH_OFF%你利用这句话慢慢将话题引到你自己的报酬问题上。尽管贵族胡言乱语了一通，但他还是暂时恢复了理智，支付了你%reward_completion%克朗。 | %employer%正在听一群书记员说话，这些人不知怎地按年龄和资历排列着。群体中的年轻人保持安静，他们发出的唯一声音是羽毛笔书写的沙沙声。长者们则互相争论，音量与理性和逻辑齐用。这似乎是当今常见的景象，毫无疑问，死者爬出坟墓哲学家来说是值得关注的事。无论如何，你大声打了个嗝来介绍自己，用令人厌恶的张扬打破了他们的谈话。%employer%大笑着招手让你进去。%SPEECH_ON%啊，佣兵！办实事的人，来和这些只会空谈的人聊聊？%SPEECH_OFF%你摇摇头告诉他你只是为了报酬而来。贵族点点头。%SPEECH_ON%当然。你救了那个镇子。我听到了很多关于你的英勇事迹。%reward_completion%克朗在角落等着你。%SPEECH_OFF%你走过房间，靴子在突然变得寂静的房间里发出皮革轻叩石地的声音。书记员们扭过头看着你，互相低声议论。你拿起一个袋子，听到克朗晃动发出的叮当声。你安静地离开，但就在门在你身后关上的那一刻，书记员们再次爆发出争论。 | %employer%身边跟着几个女人。她们正在向他诉说她们失去了父亲、丈夫和兄弟。他点着头，很专注，不过偶尔会抽空瞥一眼最年轻女孩的胸部。%SPEECH_ON%是，是，当然。太可怕了。可怕！稍等一下。佣兵！%SPEECH_OFF%他招手让你进去。你进去时女人们让开一条路。最年轻的姑娘上下打量着你，迅速擦去眼中的泪水，并稍微整理了一下仪容。贵族看到这个，目光在你和她之间扫了扫。%SPEECH_ON%嗯哼，是的，呃，你的克朗在角落。你必须走了。马上走。我还有事要处理。%SPEECH_OFF%他站起身指向你的%reward_completion%克朗，同时以一个迅速的动作拉住那位女士的手。%SPEECH_ON%那么，年轻的小娘子，你说你丈夫死了，在这世上再无依靠？完全没有任何人了？%SPEECH_OFF% | 几只狗在路上啃咬着什么东西。不管那是什么，它曾经拥有生命，骨骼和内脏早已变得苍白腐烂，不过这些杂种狗疯狂的吃相让人觉得那简直就是一块牛排。%employer%问候了你，身边跟着警觉的守卫。%SPEECH_ON%我的信使告诉我城镇得救了。你做得很好，佣兵，比我想象的还要好。你的报酬，按约定好的。%SPEECH_OFF%他递给你一袋%reward_completion%克朗。那些狗停了下来，把头转向你，牙齿上还晃荡着肉块，狭黑的眼睛映射着饥饿的空洞。守卫们放低了长矛，狗群似乎正确地理解了这一信号，慢慢地转回头继续享用它们的晚餐。 | %employer%深陷在他的椅子里。他沮丧地招手让你进房间。%SPEECH_ON%我有可怕的消息。我的预言师说我给我的土地和人民带来了诅咒。所以死者才会再次复活。%SPEECH_OFF%你耸耸肩，和善地说那个预言师满口胡言。贵族也耸耸肩。%SPEECH_ON%我当然希望如此。我们约定的是多少来着，%reward_completion%克朗？%SPEECH_OFF%你想说约定的是更多，但不敢得罪一个如此迷信的人。当你回答后，他对你准确的回答报以温暖的微笑。%SPEECH_ON%答得好，佣兵。你通过了测试。我可能的确要疯了，但我可不是好惹的。%SPEECH_OFF%你问你的诚实是否会得到奖励。那人挑了挑眉毛。%SPEECH_ON%你的脑袋还好好待在肩膀上，不是吗？%SPEECH_OFF%明白了。 | %employer%站在他的阳台上。你走到他身边，尽管守卫站得非常近，谨慎地打量着你。那人向他脚下的城镇挥了挥手。%SPEECH_ON%我知道你并非直接拯救了这个城镇，但在某种程度上，我认为你做到了。在任何地方阻止亡灵都等同于在这里阻止它们。你同意吗？%SPEECH_OFF%他用一袋%reward_completion%克朗为这个问题画上了句号。你接过报酬点了点头。他也点头回应。%SPEECH_ON%很高兴你同意，因为我们可能还需要你的服务。%SPEECH_OFF% | 你步入%employer%昏暗的房间。窗户上挂着毯子，大部分蜡烛都没有点亮。所有的光线都在一个手持枝形烛台站着的书记员身旁闪烁，他火红的脸让他酷似拿着三叉戟的小魔鬼。他瞥了你一眼，静静地放下蜡烛。当他后退时，仿佛坠入了一个黑色的水池，他那悬浮空中的脸慢慢沉入黑暗中。他还在那里，微微呼吸，斗篷沙沙作响，但你已看不到他的任何部分。%employer%招手让你进去。%SPEECH_ON%佣兵！旧神在上，你拯救了那个小镇！%SPEECH_OFF%你向前走去，瞥了一眼周围流动的黑暗，有些是阴影，有些是人。%employer%递给你一个袋子。敞开的袋口处，几枚被烛光照亮的钱币闪烁着微光。%SPEECH_ON%%reward_completion%克朗，之前商量好的。现在，请离开吧。我还有很多要研究，很多要学习。%SPEECH_OFF%你拿起报酬慢慢离开。当门关上时，你看到那个书记员如同一个憔悴的幽灵般重新浮现，骨瘦如柴的手再次伸向光亮。 | %employer%在他的书房里。守卫们站在各个角落，一个书记员安静地在书架间走动，抽出卷轴又放回去，带着同样的认真和失望。贵族一看到你招手让你上前，并快速地支付了报酬。%SPEECH_ON%干得好，佣兵。在这片土地的一些地方，你已经是个英雄了。见鬼，说不定你最终会写进这些卷轴，被永远铭记。%SPEECH_OFF%你听到书记员嗤笑一声。%employer%朝门挥了挥手。%SPEECH_ON%请吧？我有巨量的东西要研究，而时间却如此之少。%SPEECH_OFF% | 你进入%employer%的房间，发现他深陷在自己的椅子里。农民们在他两边争吵，互相指责。%SPEECH_ON%这个人是个杀人犯！%SPEECH_OFF%被告嗤之以鼻。%SPEECH_ON%杀人犯？当时只是个意外！我以为他是亡灵！%SPEECH_OFF%这次轮到另一个人嗤之以鼻了。%SPEECH_ON%亡灵？他不过是喝醉了！%SPEECH_OFF%双方脾气上来了。%SPEECH_ON%哼，我听到低吼了！或者是咕哝声。%SPEECH_OFF%你的雇主沮丧地招手让你进去。%SPEECH_ON%佣兵，干得好。你的报酬。%SPEECH_OFF%他把装有%reward_completion%克朗的袋子推过桌子。农民们停顿了一下，盯着敞开的袋口里闪烁的钱币。你拿起袋子，装作它太重的样子。%SPEECH_ON%嚯，可真重啊！先生们，祝你们有美好的一天。%SPEECH_OFF% | %employer%将你迎进他的房间。%SPEECH_ON%我的小鸟告诉我城镇得救了。你做得很好，佣兵，在这个变得如此黑暗的世界上，这已经很不错了。你的报酬%reward_completion%克朗，之前说好的。%SPEECH_OFF% | %employer%站在外面，凝视着一个自你上次来访后增添了不少居民的墓地。他递给你装有%reward_completion%克朗的钱袋。%SPEECH_ON%你做得很好，佣兵。你的事迹已经传遍了这片土地。一次成功拯救不了我们所有人，但它让我们走上了正确的道路。如果我们要打赢这场跟死人的战争，我们需要尽可能多的士气和希望。%SPEECH_OFF%接过报酬时，你补充说佣兵需要尽可能多的克朗。你知道，以保持他们的“士气”高涨。贵族咧嘴一笑。%SPEECH_ON%我这是道貌岸然，不是慈善慷慨。快给我出去。%SPEECH_OFF% | %employer%的守卫带你进入他的房间。他身边散落着几卷展开的卷轴。折断的羽毛笔乱扔在他的桌子上，仿佛有人在那里砸碎了一只鸟。%SPEECH_ON%佣兵！见到当下、今日、本周的风云人物真是太好了！你做得很好。%SPEECH_OFF%他扔给你装有%reward_completion%克朗的袋子。%SPEECH_ON%一次胜利让一个城镇存活，一次胜利让人民的希望存活。我应该付你更多。我的意思是，我不会，但我应该。%SPEECH_OFF%你闷闷不乐地接过报酬，点头回应。%SPEECH_ON%好吧，心意到了就行。%SPEECH_OFF%贵族打了个响指。%SPEECH_ON%正是！%SPEECH_OFF% | 你发现%employer%深陷在他的椅子里，眉头甚至皱得更深。他的衣服闪烁着奢华的光泽，枝形烛台看起来比举着它们的仆人还值钱。这个花哨的牢骚鬼沮丧地招手让你进去。他说话缓慢而充满讽刺。%SPEECH_ON%人类的一次胜利。让我们又能活到下一天。嗯，谢谢你，佣兵。%SPEECH_OFF%你慢慢走上前，仆人们用恐惧的眼神瞥着你。你拿起报酬向后退去。%employer%这时挥手让你离开。%SPEECH_ON%走吧。我希望再次见到你，除非你形容枯槁、变成死尸，那可就遗憾了。不过话说回来，我们最终不都是那个下场吗？%SPEECH_OFF%你什么也没说，离开了。看来对抗无尽亡灵的战争已经让这位贵族疲惫不堪了。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "%objective%安全了。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "成功保卫了" + this.Flags.get("ObjectiveName") + "抵御亡灵");
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
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color]克朗"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Origin, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "%objective%周边",
			Text = "[img]gfx/ui/events/event_30.png[/img]{亡灵数量太多，你不得不撤退。不幸的是，整个城镇没有这种自由，因此%objective%被彻底攻陷。你没有留下来看居民们下场如何，但这并不难猜想。 | %companyname%在战场上被亡灵大军击败了！随着你的失败，%objective%迅速被攻占。大量农民逃离城镇，而那些行动太迟缓的人则加入了蹒跚漫步的尸海中。 | 你未能阻挡住亡灵！尸体们缓缓越过了%objective%的围墙，吞噬并杀死它们遇到的一切。当你逃离战场时，你看到那名守军指挥官正和尸群一同蹒跚而行。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "%objective%陷落了。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "没能协助" + this.Flags.get("ObjectiveName") + "抵御亡灵");
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

		local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).spawnEntity(tile, "亡灵军团", false, this.Const.World.Spawn.UndeadArmy, (80 + this.m.Flags.get("Wave") * 10) * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
		this.m.UnitsSpawned.push(party.getID());
		party.getLoot().ArmorParts = this.Math.rand(0, 15);
		party.getSprite("banner").setBrush(undeadBase.getBanner());
		party.setDescription("一大群行尸，向活人索取曾属于他们的东西。");
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
		local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).spawnEntity(this.m.Origin.getTile(), "亡灵军团", false, this.Const.World.Spawn.ZombiesOrZombiesAndGhosts, 100 * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
		party.setPos(this.createVec(party.getPos().X - 50, party.getPos().Y - 50));
		this.m.UnitsSpawned.push(party.getID());
		party.getLoot().ArmorParts = this.Math.rand(0, 15);
		party.getSprite("banner").setBrush(undeadBase.getBanner());
		party.setDescription("一大群行尸，向活人索取曾属于他们的东西。");
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

		local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).spawnEntity(tile, "食尸鬼", false, this.Const.World.Spawn.Ghouls, 110 * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
		this.m.UnitsSpawned.push(party.getID());
		party.getSprite("banner").setBrush("banner_beasts_01");
		party.setDescription("一群正在觅食的食尸鬼");
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
