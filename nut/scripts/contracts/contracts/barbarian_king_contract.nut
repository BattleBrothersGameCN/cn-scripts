this.barbarian_king_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Threat = null,
		LastHelpTime = 0.0,
		IsPlayerAttacking = false,
		IsEscortUpdated = false
	},
	function create()
	{
		this.contract.create();
		local r = this.Math.rand(1, 100);

		if (r <= 70)
		{
			this.m.DifficultyMult = this.Math.rand(90, 105) * 0.01;
		}
		else
		{
			this.m.DifficultyMult = this.Math.rand(115, 135) * 0.01;
		}

		this.m.Type = "contract.barbarian_king";
		this.m.Name = "蛮王";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 5.0;
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
					"猎杀蛮王和他的部队",
					"据最新情报，他最后的行踪是在%region%一带，在你%direction%边"
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
				local party = f.spawnEntity(nearest_base.getTile(), "蛮王", false, this.Const.World.Spawn.Barbarians, 125 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.setDescription("一支强大的野蛮部落战团，集结在蛮王旗下。");
				party.getSprite("body").setBrush("figure_wildman_04");
				party.setVisibilityMult(2.0);
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
				patrol.setWaitTime(20.0);
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
					"猎杀蛮王和他的部队",
					"他的战团最后现身在%region%附近，位于你%direction%边的%terrain%，靠近%nearest_town%"
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
				else if (!this.Contract.isPlayerNear(this.Contract.m.Destination, 600) && this.Flags.get("HelpReceived") < 4 && this.Time.getVirtualTimeF() >= this.Contract.m.LastHelpTime + 70.0)
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
					"和蛮王同行，共同面对更大的威胁"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.setFaction(2);
					this.World.State.setEscortedEntity(this.Contract.m.Destination, true);
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
						this.World.State.setEscortedEntity(this.Contract.m.Destination, true);
						this.Contract.m.IsEscortUpdated = true;
					}

					this.World.State.setCampingAllowed(false);
					this.World.State.getPlayer().setPos(this.Contract.m.Destination.getPos());
					this.World.State.getPlayer().setVisible(false);
					this.World.Assets.setUseProvisions(false);
					this.World.getCamera().moveTo(this.World.State.getPlayer());
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
				this.World.State.resetSpeedToNormal();
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer%正用手指转着一顶单薄的王冠。虽是廉价金属制成，但确实是某处的王权象征。他上下打量着你，金属划过指甲的刮擦声不绝于耳。%SPEECH_ON%我早就该预料到的。人总渴望权力，野蛮人也不例外。%SPEECH_OFF%王冠滑到他指关节处晃荡着。%SPEECH_ON%%direction%方%region%的野蛮人被个自封的国王统一了。那家伙又凶又狠，眼看就要拉起一支大军，下一步怕是打算往南扩张。我要你去那片区域找到这人，干掉他。%SPEECH_OFF% | %employer%的仆人把你带到了花园，见他正用修剪羊毛的剪刀打理番茄藤。他边修剪边自顾自点头，漫不经心道。%SPEECH_ON%我的探子说%region%有个北方蛮子在集结部队。那群野人聚众闹事不稀奇，但这位竟然自封为王。而国王嘛……从来不会满足已有的地盘，总惦记着别人的领土——比如我的。%SPEECH_OFF%他停顿片刻向你颔首。%SPEECH_ON%我要你去%region%找到这所谓的蛮王，干掉他。这活不简单，但报酬丰厚。%SPEECH_OFF% | %employer%被副官们簇拥着。他们对你嗤之以鼻，但%employer%雇主无视这些目光。%SPEECH_ON%啊，佣兵，你这样的高手正是我需要的。%region%有个蛮子给自己封了王，甚至搞了顶王冠——估计是骨头鹿角做的，但形制和意味才是关键。不光是对他，对我们也是一样。我们不能让他活着。我要你找到这野人，趁他还没集结出我手下处理不了的军队前干掉他。%SPEECH_OFF% | %employer%准备了一扎麦酒为你接风。他自己则用高脚杯喝着葡萄酒。%SPEECH_ON%找你来是要杀掉%region%某个野人。他自称蛮族之王，呵，自认是全体野蛮人的宗主。虽然我对他的王权法统不屑一顾，但这显然是萌芽中的威胁，我不能坐以待毙，放任这野蛮人扫荡各个村庄，壮大成一支军队。我要你找到并除掉他。这活不简单，但报酬丰厚。%SPEECH_OFF%你不禁怀疑他给你灌麦酒是不是想引诱你接这荒唐差事。 | %employer%拿着一对儿鹿角，角的冠枝完好无缺。他把它放在桌上，角正直的立了起来，仿佛还长着鹿身上。%SPEECH_ON%风传野蛮人正在%region%集结军队。他自封国王，要是真能把那群原始人统合起来，肯定是个狠角色。我们要是不早点动手，麻烦马上就来了。%SPEECH_OFF%他把鹿角打翻，角尖着地，发出空洞的断裂声。%SPEECH_ON%所以我把你叫来，佣兵。我要你找到这个野蛮人，在这个野蛮人妄想扩张地盘之前干掉他%SPEECH_OFF% | %employer%抿着嘴坐在椅子上，用匕首在桌面上刻出一道道凹痕。%SPEECH_ON%我派往%direction%的探子前阵子陆续失踪，逃回来的人说有个蛮族在%region%称王。一个野蛮人自封为这群原始人的王，需要我告诉你问题的严重性吗。%SPEECH_OFF%你说，你能想象出他夜不能寐的样子。%employer%咧嘴笑了。%SPEECH_ON%没错，所以我需要你这样魁梧、可靠又文明开化的雇佣兵。趁那所谓的国王还没让所有蠢货都听他号令，找到这个混蛋干掉他%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{多大的生意？ | 这可不是件小事。 | 只要价钱合适。 | 这种工作最好多给点钱。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{我们可不打算对付一整支军队。 | 我们不想接这类差事。 | 我不会让战团冒险对付这样的敌人。}",
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
			Text = "{[img]gfx/ui/events/event_59.png[/img]一群难民与战团擦肩而过。传闻蛮王正在%direction%方%distance%。路上行人多来自%nearest_town%，他们看来是不愿坐等野蛮人大军压境。 | [img]gfx/ui/events/event_41.png[/img]一有个推着空货车的商人与队伍相遇。虽无货可卖，但他透露路上盛传有个自称国王的野蛮人。他说那蛮子就在%direction%的%region%附近。他朝那个方向扬头示意。%SPEECH_ON%如果你们要往那儿去，可得让那群原始人尝尝苦头。%SPEECH_OFF% | [img]gfx/ui/events/event_94.png[/img]路边有个半裸男子盘腿而坐。他说一支原始人军队烧了他的农庄，凌辱妇女，杀光了所有男人。%SPEECH_ON%我捂住嘴躲在灌木堆里才捡回条命。%SPEECH_OFF%那人抹了抹鼻子。%SPEECH_ON%看你们带着武器。如果是去找那些野蛮人，我可以告诉你，他们朝%direction%方去了，沿着%terrain%走%distance%到%region%附近。%SPEECH_OFF% | [img]gfx/ui/events/event_94.png[/img]你们发现一座被烧毁的小村落。几个幸存者如游魂般在废墟间徘徊，身形就像他们焚毁家园上飘散的轻烟。其中一人说有个国王模样的家伙杀了所有被逮到的人，然后往%direction%去了。 | [img]gfx/ui/events/event_60.png[/img]你们沿途遇到多辆翻倒的货车和燃烧的马车。货物已被洗劫一空，只剩车主的尸体。几个孩子正在某处废墟里翻拣。询问肇事者时，一个机灵男孩答道。%SPEECH_ON%是北方来的野蛮人，现在往%direction%去了。我亲眼看见的，那里是%terrain%，离这儿%distance%。%SPEECH_OFF%他抠着鼻子补充。%SPEECH_ON%顺便说一句，他们杀起人来眼睛都不眨。跟你有点像，但块头更大。估计也更壮实。%SPEECH_OFF% | [img]gfx/ui/events/event_76.png[/img]路上，你碰到了%employer%的斥候。他报告在%direction%方%terrain%的%region%附近目击到了蛮王。距离%distance%。你邀请他同行参战，对方大笑。%SPEECH_ON%不必了长官，我现在这样挺好。四处侦察，找点乐子，偶尔睡几个妓女。这日子舒坦得很，可不想被你们佣兵的生活搅黄了！%SPEECH_OFF%好吧。 | [img]gfx/ui/events/event_132.png[/img]是%randombrother%先发现了痕迹。打斗的迹象、焦尸、模糊的脚印和车辙——如此密集的痕迹明显是部队经过所致。%SPEECH_ON%队长，看情形他们打完仗就往%direction%去了。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们跟上。",
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{至此已毋庸置疑。结合沿途所见的所有征兆与众人提供的情报，你终于确定了蛮王及其部队的行军路线。如今唯一要做的，就是与其正面对决。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "加快脚步。",
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
			Text = "[img]gfx/ui/events/event_135.png[/img]{蛮王带着他的战团出现了——一群身材魁梧的恶棍、低吼的战士、怯懦的奴隶和尖啸的女人。这支军队的主宰者如同滚雪球般吸纳了这片土地上每分资源、每寸优势，终将如雪崩般吞噬整个文明。你立即下令全队准备战斗。 | 蛮王部众杂乱无章地涌过原野，毫无训练痕迹，甚至没有基本阵型。但你清楚，只要那野蛮人一挥手，就能驱使这群嗜杀的乌合之众用纯粹的暴力弥补所有纪律缺失。你命令伙计们准备战斗。 | 这支蛮族战团犹如噩梦成真，地平线上汇聚着来自世界角落的旅人。他们不穿制式盔甲，却披挂着从征服者身上剥下的滑稽战利品：战士臂缠新娘婚纱，下位者身披皇家绶带，还有人挂着咯吱作响的肋骨装饰——仿佛刚完成最后一轮洗劫。他们就是专门制造恐怖的农民，村庄是庄稼，战争就是他们的四季收成。\n\n你摇头甩开杂念，指挥部队准备迎敌。}",
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
			Text = "[img]gfx/ui/events/event_145.png[/img]{蛮王死了。虽然自封为王，如今却与他的族人一样倒毙在地。不过是个蛮族，一个未开化的野人。除了更健壮的身躯和那些征战掳掠来的装备，与旁人并无二致。你一脚踩住他的面门，挥剑砍向脖颈，将头颅从肩膀上干净利落地斩下。%randombrother%捡起沉甸甸的头颅塞进背包。你命令手下尽可能搜刮战利品，随后准备返回%employer%处复命。}",
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
			ID = "AGreaterThreat1",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_136.png[/img]{你找到了野蛮人王，但对方提出交涉。蛮王和一位长老亲自过来见你。尽管心存疑虑，你还是前去会面。蛮王开口说话，而长老则负责翻译。%SPEECH_ON%我们来这里不是为了攻城略地，而是为了打败数量巨大的不往生者。%SPEECH_OFF%你怀疑翻译有误，请他们详细说明。国王和长老继续解释。%SPEECH_ON%死神已离开这片土地。如今战死之人会困在此界和彼界之间，不断复活重生。一大群不往生者正在行军。我们并非冲着你或你的贵族而来。只要你帮助我们消灭他们，我们就离开此地，不再打扰你们的百姓——我们只与不往生者为敌。%SPEECH_OFF%%randombrother%凑近低声道。%SPEECH_ON%我们当然可以加入他们，但也可以现在就发动攻击。他们现在明显不在最佳状态，不管他们怎么说，事实是他们一直在蹂躏这片土地。毕竟他们是原始野蛮人，长官，烧杀抢掠是他们的天性。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们会正面进攻，消灭这个所谓的蛮王。",
					function getResult()
					{
						return "AGreaterThreat2";
					}

				},
				{
					Text = "我们和他们一起向“不往生者”进军。",
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
			Text = "[img]gfx/ui/events/event_136.png[/img]{你啐了口唾沫，朝长老点头道。%SPEECH_ON%我们一路走过被烧的房子，被强奸的妇女，和被杀害的男人，就为了找你们这群杂碎，现在居然想联手？我们不是盟友。更不是朋友。告诉你们所谓的“国王”，向他那狗屁神灵祈祷去吧…%SPEECH_OFF%长老抬手制止，用他们的土语和国王交谈了几句。两人点了点头，转身离去。%randombrother%笑道。%SPEECH_ON%队长，简短有力才是骂人的精髓。%SPEECH_OFF%你让他回到战线里，准备迎战。}",
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
			Text = "[img]gfx/ui/events/event_136.png[/img]{你向长老点头。%SPEECH_ON%\"行，我们就跟你们联手对付这个更大的威胁。%SPEECH_OFF%长老笑着搓了搓拇指，用土语说了几句。 蛮王用拳头捶了捶胸口，又在你肩上捶了一下，随后将手臂挥向天空。长老笑着解释道。%SPEECH_ON%现在我们联合起来。但要是失败身亡，他绝对不会和你们一起变成不往生者。到时候，国王将亲自寻见死神，用镰刀了断自己的性命。%SPEECH_OFF%}",
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
				local party = this.World.FactionManager.getFaction(nearest_undead.getFaction()).spawnEntity(tile, "不往生者", false, this.Const.World.Spawn.UndeadArmy, 260 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.getSprite("banner").setBrush(nearest_undead.getBanner());
				party.setDescription("一大群行尸，向活人索取曾属于他们的东西。");
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
			Text = "[img]gfx/ui/events/event_73.png[/img]{那些野蛮人没有说谎：一支古代军队就在前方。他们腐朽的肉体外披着锈迹斑斑的盔甲，这群低吼呻吟的怪物让阳光都黯然失色。这无疑是黑暗的军队。如果是你或野蛮人单独应战，都必败无疑，但团结起来，你们还有一线生机！}",
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
			Text = "[img]gfx/ui/events/event_136.png[/img]{古代的死者最终被打败。已被彻底消灭。当你的手下和野蛮人正在打扫战场时，蛮王与长老向你走来，魁梧的战士点头含糊说了一句，长老翻译道。%SPEECH_ON%他说你们打得漂亮，非常漂亮。他多希望像你和你的战团这样的战士能与他并肩作战，但他明白这不可能。我们生活在万千世界的迷宫中，各自困守其中，偶尔能听见彼此的呼喊，却永远来不及真正相识。他说谢谢。愿你前路顺利。%SPEECH_OFF%你问长老，就那一句话有这么多意思吗。长老微笑。%SPEECH_ON%一句话，再加上一生的情谊。保重，剑客。%SPEECH_OFF%长老递给你一顶角盔，正是蛮王戴着的那顶。他只是以拳捶胸指向天空——一切尽在不言中。}",
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
			Text = "[img]gfx/ui/events/event_31.png[/img]{%employer%把蛮王的头从袋子里倒出。它咕噜噜滚过桌面，撞翻了一托盘酒杯，叮叮当当散落满地。这蛮族即使死了也仍在制造混乱。%SPEECH_ON%谢了，佣兵。%SPEECH_OFF%你的雇主边说边把头颅摆正，将断颈处的皮肉抚平，随后自顾自地点了下头。%SPEECH_ON%这杂种长得真够丑的，是吧？瞧这口牙！上面全是蛀洞。真恶心。%SPEECH_OFF%你催促他付钱，他如数照付。但始终摇头咂嘴，做出剔牙的动作。%SPEECH_ON%这种牙齿该怎么清理？用麻绳磨吗？%SPEECH_OFF%你耸耸肩转身离开，没告诉%employer%你手下一拿到这倒霉头颅，就马上用刀翘掉它嘴里的金牙。 | 你把蛮王的头丢在%employer%的桌子上。他盯着头颅又看向你。%SPEECH_ON%这他妈是我见过最大的头。%SPEECH_OFF%你点点头索要报酬。他足额支付后开始拨弄蛮王的脸庞，像个想窃取秘密的巫师。%SPEECH_ON%我敢打赌，食人魔的传说就是这么来的。小孩看见这丑玩意儿，一下子想象力迸发，所谓的怪物就诞生了。%SPEECH_OFF%要是真这么简单就好了。 | 即便没有了他庞大的身躯，蛮王的头颅仍在%employer%面前引起了轰动。贵族与仆从们围着它惊叹不已。一位身披黑袍的人很快付清了说好的酬金。%employer%亲自拎起头颅掂量了几下。%SPEECH_ON%旧神啊，这可真沉！喂，%randomname%。%SPEECH_OFF%一名侍从应声上前。雇主咧嘴笑道。%SPEECH_ON%取根长矛来，我要把这颗丑脑袋挂上天。%SPEECH_OFF%对野蛮人来说，这算是个合适的归宿。 | 蛮王的头刚被交给%employer%，就成了一件玩物。贵族的孩子在石头地板上踢着它滚来滚去，撞倒酒杯垒成的围墙和餐盘堆砌的城堡。一条狗追着头颅不停吠叫。%employer%拍着你肩膀。%SPEECH_ON%干得漂亮，佣兵。我的斥候告诉我当时打的天昏地暗，你简直和原始人一样疯狂。不过以蛮制蛮就得这样，对吧？文明人可没办法抗衡这种野蛮。%SPEECH_OFF%有个孩子踢中国王面门，下巴应声断裂。小孩被牙齿划伤了脚，不禁尖声求救，叼起头颅在断颈处来回撕扯。%employer%又笑了。%SPEECH_ON%你的酬金在门外，一分不差。%SPEECH_OFF% | 一名穿着骑士甲的人从你手中夺走了蛮王的头。你立即拔剑，但%employer%及时制止冲突。%SPEECH_ON%别激动佣兵，没事。你的报酬，说好的。%SPEECH_OFF%对方递来钱袋时，你瞥见头颅被转交给一位黑袍人。你点头问他们对这脑袋有何打算。%employer%笑了。%SPEECH_ON%我就直说了，还有场酒会等着我呢，佣兵，而且我渴极了。%SPEECH_OFF%他快步从你身边走过。你根本没看见任何酒水，他只是跟着那黑袍人离开了。 | %employer%像猫盯猎物般打量着蛮王的头颅。%SPEECH_ON%有意思，我要把它做成标本，放在我的壁炉上。%SPEECH_OFF%你稍越矩地提醒这终究是颗人类的头颅。%employer%耸了耸肩%SPEECH_ON%那又怎么了，这是个怪物。文明与野蛮无法共存。妥善处理它才能让我时刻铭记这个道理。你还有意见？%SPEECH_OFF%你抿紧嘴唇索要报酬。他指向角落。%SPEECH_ON%钱袋在那儿。干得不错佣兵，但别再这么跟我说话。慢走。%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "杀死自封的蛮王");
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
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color]克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_31.png[/img]{%employer%不情愿地接待了你。%SPEECH_ON%你应该知道我到处都安插了探子和眼线吧？%SPEECH_OFF%你举起双手，告诉他你并没打算撒谎。所谓的“蛮王”不会再袭扰这片土地了。雇主轻轻叩了几下指尖，然后点头道。%SPEECH_ON%你的诚实难能可贵，虽然我得说很遗憾那家伙和他的部队还活着。不过所有报告都显示他们正在撤离，所以无论有没有蛮族首领的脑袋，你的任务都算完成了。这是约定好的报酬。%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "解除了蛮王的威胁");
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
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color]克朗"
				});
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		if (this.m.Destination != null && !this.m.Destination.isNull() && this.m.Destination.isAlive())
		{
			local distance = this.World.State.getPlayer().getTile().getDistanceTo(this.m.Destination.getTile());
			distance = this.Const.Strings.Distance[this.Math.min(this.Const.Strings.Distance.len() - 1, distance / 30.0 * (this.Const.Strings.Distance.len() - 1))];
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
			this.World.State.resetSpeedToNormal();
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
