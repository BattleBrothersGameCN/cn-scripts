this.root_out_undead_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Objective1 = null,
		Objective2 = null,
		Target = null,
		Current = null,
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

		this.m.Type = "contract.root_out_undead";
		this.m.Name = "铲除亡灵";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		if (this.m.Origin == null)
		{
			this.setOrigin(this.World.State.getCurrentTown());
		}

		local nearest_undead = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getNearestSettlement(this.m.Origin.getTile());
		local nearest_zombies = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getNearestSettlement(this.m.Origin.getTile());

		if (this.Math.rand(1, 100) <= 50)
		{
			this.m.Objective1 = this.WeakTableRef(nearest_undead);
			this.m.Objective2 = this.WeakTableRef(nearest_zombies);
		}
		else
		{
			this.m.Objective2 = this.WeakTableRef(nearest_undead);
			this.m.Objective1 = this.WeakTableRef(nearest_zombies);
		}

		this.m.Flags.set("Objective1Name", this.m.Objective1.getName());
		this.m.Flags.set("Objective2Name", this.m.Objective2.getName());
		this.m.Payment.Pool = 1500 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
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
					"摧毁%objective1%",
					"摧毁%objective2%",
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
				this.Contract.m.Objective1.setLootScaleBasedOnResources(120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Objective1.setResources(120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Objective1.clearTroops();
				this.Contract.addUnitsToEntity(this.Contract.m.Objective1, this.Contract.m.Objective1.getDefenderSpawnList(), 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Objective1.setDiscovered(true);

				if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Objective1.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Objective1.getLoot().clear();
				}

				this.World.uncoverFogOfWar(this.Contract.m.Objective1.getTile().Pos, 500.0);
				this.Contract.m.Objective2.setLootScaleBasedOnResources(120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Objective2.setResources(120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Objective2.clearTroops();
				this.Contract.addUnitsToEntity(this.Contract.m.Objective2, this.Contract.m.Objective2.getDefenderSpawnList(), 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Objective2.setDiscovered(true);

				if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Objective2.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Objective2.getLoot().clear();
				}

				this.World.uncoverFogOfWar(this.Contract.m.Objective2.getTile().Pos, 500.0);
				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					this.Flags.set("IsNecromancers", true);
				}
				else if (r <= 25)
				{
					this.Flags.set("IsBandits", true);
				}

				this.Flags.set("ObjectivesDestroyed", 0);
				this.Flags.set("Objective1ID", this.Contract.m.Objective1.getID());
				this.Flags.set("Objective2ID", this.Contract.m.Objective2.getID());
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [];

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull() && this.Contract.m.Target.isAlive())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.BulletpointsObjectives.push("杀死逃跑的亡灵巫师");
				}

				if (this.Contract.m.Objective1 != null && !this.Contract.m.Objective1.isNull() && this.Contract.m.Objective1.isAlive())
				{
					this.Contract.m.Objective1.getSprite("selection").Visible = true;
					this.Contract.m.BulletpointsObjectives.push("摧毁%objective1%");
					this.Contract.m.Objective1.setOnCombatWithPlayerCallback(this.onCombatWithPlayer.bindenv(this));
				}

				if (this.Contract.m.Objective2 != null && !this.Contract.m.Objective2.isNull() && this.Contract.m.Objective2.isAlive())
				{
					this.Contract.m.Objective2.getSprite("selection").Visible = true;
					this.Contract.m.BulletpointsObjectives.push("摧毁%objective2%");
					this.Contract.m.Objective2.setOnCombatWithPlayerCallback(this.onCombatWithPlayer.bindenv(this));
				}
			}

			function update()
			{
				if (this.Flags.get("ObjectiveDestroyed"))
				{
					this.Flags.set("ObjectiveDestroyed", false);

					if (this.Flags.get("IsBanditsCoop"))
					{
						this.Contract.setScreen("BanditsAftermathCoop");
					}
					else if (this.Flags.get("IsBandits3Way"))
					{
						this.Contract.setScreen("BanditsAftermath3Way");
					}
					else if (this.Flags.get("ObjectivesDestroyed") == 1)
					{
						this.Contract.setScreen("Aftermath1");
					}
					else
					{
						this.Contract.setScreen("Aftermath2");
					}

					this.World.Contracts.showActiveContract();
				}

				if (this.Flags.get("IsNecromancersSpawned"))
				{
					if (this.Contract.m.Target == null || this.Contract.m.Target.isNull())
					{
						this.Contract.setScreen("NecromancersAftermath");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Contract.m.Target.getTile().getDistanceTo(this.World.State.getPlayer().getTile()) >= 9)
					{
						this.Contract.setScreen("NecromancersFail");
						this.World.Contracts.showActiveContract();
					}
				}

				if (!this.Flags.get("IsBandits") || this.Flags.get("ObjectivesDestroyed") != 0)
				{
					if (this.Contract.m.Objective1 != null && !this.Contract.m.Objective1.isNull() && !this.Contract.m.Objective1.getFlags().has("TriggeredContractDialog") && this.Contract.isPlayerNear(this.Contract.m.Objective1, 450))
					{
						this.Contract.m.Objective1.getFlags().add("TriggeredContractDialog");
						this.Contract.setScreen("UndeadRepository");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Contract.m.Objective2 != null && !this.Contract.m.Objective2.isNull() && !this.Contract.m.Objective2.getFlags().has("TriggeredContractDialog") && this.Contract.isPlayerNear(this.Contract.m.Objective2, 450))
					{
						this.Contract.m.Objective2.getFlags().add("TriggeredContractDialog");

						if (this.Flags.get("IsNecromancers"))
						{
							this.Flags.set("IsNecromancersSpawned", true);
							this.Contract.setScreen("Necromancers");
							this.World.Contracts.showActiveContract();
						}
						else
						{
							this.Contract.setScreen("UndeadRepository");
							this.World.Contracts.showActiveContract();
						}
					}
				}
			}

			function onCombatWithPlayer( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
				this.Contract.m.Current = _dest;

				if (_dest != null && !_dest.getFlags().has("TriggeredContractDialog") && this.Flags.get("IsBandits") && this.Flags.get("ObjectivesDestroyed") == 0)
				{
					_dest.getFlags().add("TriggeredContractDialog");
					this.Contract.setScreen("Bandits");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					_dest.m.IsShowingDefenders = true;
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.EnemyBanners.push(_dest.getBanner());

					if (this.Flags.get("IsBandits") && this.Flags.get("ObjectivesDestroyed") == 0)
					{
						if (this.Flags.get("IsBanditsCoop"))
						{
							p.AllyBanners.push("banner_bandits_06");
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.BanditRaiders, 90 * this.Contract.getScaledDifficultyMult(), this.Const.Faction.PlayerAnimals);
						}
						else
						{
							p.EnemyBanners.push("banner_bandits_06");
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.BanditRaiders, 90 * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						}
					}

					this.World.Contracts.startScriptedCombat(p, this.Contract.m.IsPlayerAttacking, true, true);
				}
			}

			function onLocationDestroyed( _location )
			{
				if (_location.getID() == this.Flags.get("Objective1ID"))
				{
					this.Contract.m.Objective1 = null;
					this.Flags.set("ObjectiveDestroyed", true);
					this.Flags.set("ObjectivesDestroyed", this.Flags.get("ObjectivesDestroyed") + 1);
				}
				else if (_location.getID() == this.Flags.get("Objective2ID"))
				{
					this.Contract.m.Objective2 = null;
					this.Flags.set("ObjectiveDestroyed", true);
					this.Flags.set("ObjectivesDestroyed", this.Flags.get("ObjectivesDestroyed") + 1);
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{你看到%employer%正卷起一张地图，将一端凑到蜡烛上。火焰迅速窜起，烧焦的纸片随着火势飘落。他招手让你进去。%SPEECH_ON%糟糕的地图对军队而言如同毒药。而一份好地图，却堪比黄金。%SPEECH_OFF%火苗开始舔舐到他的手指，这人丢下纸张踩灭了它。他坐下后又取出另一卷轴，在整张桌面上铺开。这简直是你见过的最精美的地图。%employer%用两根小棍标出了两个具体地点。%SPEECH_ON%‘%objective1%’和‘%objective2%’，两个花哨的名字。我的探子说亡灵就是从这些地方冒出来的。嗯，至少是那些怪物的大部分来源。去这两个地方吧，佣兵，帮忙终结这些恐怖事物。 | 你步入%employer%的房间。他的将军们个个面红耳赤，这是一场不欢而散的争吵的鲜明写照。这位贵族招手让你进去。%SPEECH_ON%啊，这才是我他妈真想聊聊的人。诸位，让条路。%SPEECH_OFF%在轻蔑目光的注视下，你穿过那群傲慢的指挥官。%employer%将一张地图拍在你胸前。有两个地点被圈出并粗陋地画上了骷髅头标记。%SPEECH_ON%两个都去，佣兵。‘%objective1%’和‘%objective2%’。我的书记官认为这些地点对亡灵浪潮至关重要。我的指挥官们不同意，但何不去看看呢？要是你看到任何那些吓人的狗屎玩意，就宰了它们，把它们爬出来的什么鬼洞窟都毁掉，然后带着你英勇事迹的好消息回来见我。听起来如何？%SPEECH_OFF% | %employer%正在照料他的菜园。蔬菜已经变成了灰色。他的手指从藤蔓上刮下灰烬。%SPEECH_ON%我对现状感到难过，佣兵，但至少我他妈的食物不会活过来咬我屁股。%SPEECH_OFF%你笑着回答。%SPEECH_ON%给点时间吧。我们可不知道蔬菜的报复心有多重。%SPEECH_OFF%这位贵族认真地点头，仿佛你是个哲学家而不是在说笑。他扔给你一张地图。%SPEECH_ON%你在上面能看到两个被标记出来的地点，‘%objective1%’和‘%objective2%’。据推测，这两处都是亡灵的聚集地。去那里，把它们全杀了，摧毁它们的巢穴。或者坟墓。坑洞。随便是什么都行。%SPEECH_OFF% | 一个看起来愁苦的农民——也就是说，一个普通的农民——在你进去时正离开%employer%的房间。后者招手让你到他的桌前。%SPEECH_ON%很高兴你来了，佣兵，因为我有个相当重要的任务交给你。我的斥候报告了两个我和这片土地上的人民都非常关注的地点。它们叫做‘%objective1%’和‘%objective2%’，而且据称亡灵正从这两处涌出。所以，你说你去那里查探一下如何？而查探的意思就是，如果属实就把它们全宰了，然后带着好消息回来见我。%SPEECH_OFF% | 你看到%employer%正盯着桌上的一只死猫。这猫科动物胸口插着一把匕首，你意识到这位贵族手里还握着另一把刀。一名警卫站在一旁，剑已出鞘，他旁边的书记官拿着羽毛笔和卷轴。你穿过房间时，所有人都慢慢放松下来。刀剑入鞘，笔尖开始书写。书记官匆忙把猫带走，天知道要作何用途。%employer%坐了下来。%SPEECH_ON%你好，佣兵。我们刚才在做个小实验。我们原本不信猫真有九条命，但在这个充满恐怖的新世界里，它们说不定有两条。结果证明，不。它们没有。它们只有一条命。%SPEECH_OFF%这位贵族抽出一张地图拍在桌上。他指着两个标记。%SPEECH_ON%‘%objective1%’在这里。‘%objective2%’在这里。两个都去。如果我的斥候没搞错，你会在那里找到亡灵。很多亡灵。你的任务是摧毁那里的一切，确保这些亡灵渣滓被扼杀在萌芽状态。%SPEECH_OFF% | %employer%身旁是一名风尘仆仆的探哨。这位探路者正在大吃大喝，补充他奔波于这片土地所消耗的体力。%employer%递给你一张粗略绘制的地图。%SPEECH_ON%‘%objective1%’和‘%objective2%’。我们，嗯，我这位友好的鸟儿先生认为，这些是亡灵的储藏所，这名字无疑很贴切。各式各样的邪秽之物都从这些地点涌出。去那里，摧毁你看到的一切，然后作为英雄归来。%SPEECH_OFF%你耸耸肩。%SPEECH_ON%%companyname%更喜欢克朗，而不是赞誉。%SPEECH_OFF% | %employer%拿着一张地图迎接你。%SPEECH_ON%‘%objective1%’和‘%objective2%’，认得这些地方吗？不认得，自然是不认得。但我要你每个地方都去一趟，铲除藏匿其中的邪祟，然后回来。一趟短暂简单的藏尸地之旅，对吧？%SPEECH_OFF%对。能出什么差错呢？ | %employer%问你是否惧怕亡灵。你耸耸肩回答。%SPEECH_ON%我害怕带着未尽之愿遗憾死去。只怕这个。还有马。%SPEECH_OFF%贵族笑了笑。%SPEECH_ON%嗯，那好吧。这儿有张地图。你会看到标记的‘%objective1%’和‘%objective2%’。我的斥候认为它们是亡灵的避难所。有道理，毕竟那本来就是我们安置死人的地方。去这两处，摧毁它们，然后回来拿你的报酬。够简单了吧，嗯？%SPEECH_OFF% | %employer%在门口迎接你，手里拿着一张地图。%SPEECH_ON%‘%objective1%’和‘%objective2%’，标记得很清楚，看到了吗？。嗯，我的小鸟们说大量的邪祟正从这两处涌出。如果属实，那么我需要一个无所畏惧、擅长杀戮的人去这两处，摧毁那里的一切。我相信你就是这样的人。你是吗？%SPEECH_OFF% | 一个全副武装却面带愁容的男人离开%employer%的房间。当你进去时，这位贵族招手让你到桌前看一张地图。%SPEECH_ON%你不怕死人，对吧？那亡灵呢？不怕？完美。‘%objective1%’在那里，还有‘%objective2%’在那里。去这两处，摧毁它们，让刚才出门的那个懦夫看看真男人是怎么干活的。%SPEECH_OFF%你竖起一根纠正的手指。%SPEECH_ON%真男人为了钱干活。%SPEECH_OFF% |%employer%用一个奇怪的问题迎接你的到来。%SPEECH_ON%去过墓地吗，佣兵？%SPEECH_OFF%没等你回答，这人给自己倒了杯酒喝了一大口，另一只手抬起让你保持安静。%SPEECH_ON%它们是些古怪的地方。真的，很不自然。什么样的生物会把自己的死者带到某块地——还往往是好地——然后埋在那里？多么俗气。多么无意义。那么，死者回来又有什么好惊讶的呢？也许它们缠着我们就是因为我们破坏了自然秩序。%SPEECH_OFF%这人扔给你一个卷轴，上面是张绘制精良的地图。两个地点被标记出来。%SPEECH_ON%‘%objective1%’和‘%objective2%’。我需要你去这两处，摧毁它们，然后回来。对你这行当的人来说够简单了吧，对吧？%SPEECH_OFF% | 你看到%employer%一边摇头一边用羽毛笔在地图上划着。%SPEECH_ON%‘%objective1%’和‘%objective2%’，两个离这儿不远的屎坑，需要摧毁。当然，它们是死人的家，因此也是亡灵的窝。它们没让我们安生过，现在嘛，这些尸体能安息吗？天晓得。但把它们全宰了，懂了吗？%SPEECH_OFF% | 只见%employer%正在照料几十只关在笼中的鸟。有些在笼子里扑腾，撞在栏杆上。这位贵族拾起一只死鸟，它的腿僵直地翘在空中。他把尸体扔给你。%SPEECH_ON%我有个任务交给你，佣兵。摧毁离这儿不远的‘%objective1%’和‘%objective2%’。我的斥候报告——多亏了这些小鸟——这些地点是亡灵的巢穴，也许是个源头，也许是个行动基地，如果尸体们真能组织起这种事的话。%SPEECH_OFF%这人开始往笼子里扔鸟食。几只鸟盯着饲料选择不吃，拒绝窃取大自然最伟大馈赠的行为。然而翅膀被剪掉的鸟则狼吞虎咽。%employer%转向你，拍掉手上的残渣。%SPEECH_ON%那么，我们成交吗？%SPEECH_OFF% | 你看到%employer%被他的卫兵围着，所有目光都集中在房间中央的一具尸体上。在见到这位贵族之前，一股恶臭就先迎接了你。尸体上飘散着瘴气，一种慵懒的灰色调，仿佛通风道里的一堆灰烬。%SPEECH_ON%佣兵！你来了真好！如果可以的话，别管这骚动。我们有个卫兵自杀然后又，嗯，回来了的问题。也许是个复杂的刺杀计划？这世道很难说。来，我有些东西给你。%SPEECH_OFF%他招手让你上前，伸出的手里拿着一个卷轴。你接过它展开，是一张地图。这人解释道。%SPEECH_ON%‘%objective1%’和‘%objective2%’，如果你认得的话，是据信亡灵从中涌出的藏尸地。我需要一个像你这样，呃，钢铁般的人去那里，终结这两个地点。希望这能引起你的兴趣。%SPEECH_OFF% | %employer%欢迎你进入他的房间，但一名卫兵用戟刃抵住了你的喉咙。你保持冷静，这位贵族迅速命令手下退下。贵族道歉道。%SPEECH_ON%对刚才的不幸事件很抱歉，但弟兄们都很紧张。前晚他们中有个人在睡梦中死了，然后，嗯，他回来了。变成了个鬼一样的东西，在其他人意识到发生了什么之前就杀了三个人。%SPEECH_OFF%你摸摸下巴，回复说反正你也需要好好刮个胡子。%employer%咧嘴一笑点点头。%SPEECH_ON%嗯，这就是我喜欢你的地方，佣兵。总是精神头很好。看看我这张地图。看到这些地点了吗？农民们叫它们‘%objective1%’和‘%objective2%’。我们有理由相信这两处都是为亡灵大军提供力量的能量源。我需要一个有你这种充满气概和决心的人去那里摧毁它们。这任务你感兴趣吗，雇佣兵？%SPEECH_OFF% | 你看到%employer%正靠在椅背上。他扔给你一张地图。%SPEECH_ON%读读看，研究一下。看到‘%objective1%’和‘%objective2%’了吗？我的间谍认为它们是供养亡灵的强大力量之源。我觉得它们只是有很多尸体供亡灵复生而已。无论如何，我需要你去这两处，把它们都摧毁，然后回来见我。你对这个感兴趣吗？%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{报酬如何？ | 我只对报酬感兴趣。}",
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
			ID = "UndeadRepository",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_57.png[/img]{一股熟悉的恶臭开始在战团周围弥漫。%randombrother%说他们肯定快到那个藏尸地了。你评价说他真他妈是个天才，应该去搞点发明创造造福人类。在全队的哄笑声中，你几乎能听见他的沉默。 | 随着你接近目标，越发确证%employer%对此地的评估是正确的。恶臭不容否认：曾经埋在此处的死者已经复苏，重新在这片土地上游荡了。 | 你发现一具尸体缠在灌木丛中，它被枝条绊住的手正以一种死人特有的漠然反复向外划动。%randombrother%小心地保持距离靠近，将刀刃刺入它的头颅。他退后一步，擦拭着武器，说战团肯定快到目的地了。 | 从尸体腐烂后产生的刺鼻气味和它们散发的发酵气体来判断，毫无疑问%objective%就在附近。 | 你看到半个人正在地上爬行。它茫然地呻吟着盯着你，对自己这新生的存在漠不关心，却又渴望终结你的生命。你用靴子把它的头踩进泥里。它的咆哮变成了咕噜声，你小心地将匕首刺入它的耳孔。%randombrother%环顾四周。%SPEECH_ON%%objective%应该不会太远了。%SPEECH_OFF% | 你的目的地还没进入视野，但其气味已猛烈地冲入鼻腔，你希望盘踞在那里的东西可别像这气味一样凶猛。你该让手下为即将到来的战斗做好准备。 | %randombrother%指向路边散落的一堆尸体，它们的死状看起来像是一连串杂技般的动作。你不知道发生了什么，但这些尸体早已死亡，却没有任何苍蝇或其他动物啃食的迹象。你通知手下，目的地已近，他们该为即将到来的战斗做好准备。 | 战团碰到了一具步履蹒跚、手脚都戴着镣铐的尸体。生前的囚禁在复生后并未结束，于是你做了刽子手早在许久之前就该做的事——砍掉了这个僵尸的头。%randombrother%问你们的目的地是否近了，你点了点头。确实近了，随之而来的将是一场%companyname%最好严阵以待的战斗。 | 弥漫在全队周围的可怕气味证明你肯定离目的地不远了。 不论是行尸还是有人在拉史上最臭的屎，%companyname%都该准备战斗了。 | 行尸一个接一个地出现了，如同一连串面包屑将%companyname%直接引向目标。你们该准备战斗了，因为很快整条面包就会摆在你们的盘子里。 | 一个老人向战团打招呼，说%objective%离这不远了。你问他那还在这儿干嘛。他耸耸肩。%SPEECH_ON%当个等死的老头子，还能干嘛？%SPEECH_OFF% | %randombrother%嗅了嗅空气。%SPEECH_ON%我认得%randombrother2%放屁的味道，但这味儿不是他的。%SPEECH_OFF%被冒犯的佣兵耸耸肩。%SPEECH_ON%我倒是想放个这么臭的屁，不过是啊，我觉得你说得对。咱们肯定快到%objective%了。%SPEECH_OFF%你点点头，告诉手下们准备迎接即将到来的战斗。 | 你发现一具饱经风蚀、眼窝深陷的尸体正对着一块大岩石胡乱挥舞。它来回挪动，认真地刮擦着石头，努力想要杀死它。%randombrother%一挥刀就斩下了这个僵尸的头，轻松得像热刀切黄油一样。他朝远处点了点头。%SPEECH_ON%%objective%很近了。%SPEECH_OFF%如果真是这样，%companyname%该准备战斗了。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "为最坏的情况做好准备！",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Aftermath1",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_46.png[/img]{此地的邪祟已被铲除。你深吸一口气，感觉像是多年来的第一次呼吸，仿佛空气本身都因你的胜利而变得温暖。现在只剩下所谓的%objective2%了。 | 当最后的一个亡灵安息时，你感觉到空气正在变得清澈，如同烟雾弥漫的雾气让位于清新的春日芬芳。气味的迅速转变无疑意味着你已清除了盘踞在此的邪祟。现在去净化%objective2%，了结这份合同。 | 此地的邪祟已被平息。你的下一个目标正等着你。 | 随着这恐怖之地的邪祟被清除，合同上只剩下%objective2%了。 | 当最后一个僵尸被安息时，你感到空气骤然一变。尽管身处泥泞污秽之中，纯净的空气却以出乎意料的清冽直冲肺腑。%randombrother%擦了擦额头。%SPEECH_ON%肯定是结束了。那咱们接下来去%objective2%？%SPEECH_OFF% | 你之前踏入的是邪祟横行之地，但随着最后一个僵尸被斩杀，你看到世界的光芒变得明亮，脚下的泥土气息也回归了自然秩序。既然此地已得安息，是时候前往%objective2%了。 | 胜利来之不易。战场上遍布着僵尸和更为古老的亡灵。你希望%objective2%能更容易解决，但希望不大。 | 你跨过一具古人的尸体。它与你自己如此不同，简直可说是你所知一切生命的异类。头骨形状怪异，像是你自己头骨的萎缩前身，盔甲和武器也仿佛来自异界。\n\n你让兄弟们做好准备，向%objective2%进发。 | 大地散落着亡灵们残破的尸体。你踏过它们的尸身，发现脚下的土地正在恢复生机，仿佛土壤从藏匿中翻转过来，空气本身也变得更容易呼吸。或许邪祟真的已离开此地？无论如何，是时候前往%objective2%，并按照%companyname%的方式款待它一番了。 | 随着最后一个亡灵被斩杀，你环顾战场。从他们各式各样的衣物和盔甲来看，这些死者并非来自同一源头，但他们甚至也不属于同一时代。有些穿着古代盔甲，带着令人不安的整齐划一前来杀戮。\n\n %randombrother%走过来报告，说战团已准备就绪，随时可以出发前往%objective2%。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{胜利！ | 别再复活了！}",
					function getResult()
					{
						this.Contract.getActiveState().start();
						this.World.Contracts.updateActiveContract();
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Aftermath2",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_46.png[/img]{%objective2%已成废墟，不过在你看來，它看起来比以往任何时候都要好。现在最好回去找%employer%领取你的奖赏。 | 你修正了%objective2%，将它从亡灵手中夺回，重返生者的世界。你已经看到草木焕发生机，清风送来沁人凉意。最好向%employer%汇报这些成果，这样你就能领取酬劳了。 | 盘踞在%objective2%的黑暗已被摧毁。好吧，除了瓦砾下的那些角落。那里确实还有点黑暗，但这更多是因为缺乏光线而非邪祟影响。无论如何，你都该去告诉%employer%你的成果。 | 有了%companyname%以胜利者的姿态屹立于其废墟之上，%objective2%看起来顺眼多了。照你看，该找个画家来为你的功绩稍作描绘。%randombrother%用战靴碾碎僵尸颅骨的画面尤其精彩。不过，从%employer%那里拿到报酬的画面会更美。最好现在就回去找他。 | %objective2%已被摧毁，邪祟也随之离开了这片土地。希望它是永远消失了，但更有可能只是转移到了另一个薄弱之地。说到这个，你最好回去找%employer%领取报酬。 | %objective2%已被夷为平地，寄居其中的所有邪祟都已消散。空气变得轻盈，更加清新。%employer%应该会很高兴见到你和你要汇报的成果。 | %companyname%屹立于胜利之中，%objective2%的邪祟已被平息，或者也许是被驱逐到别处栖身。你内心愤世嫉俗的部分希望是后者，因为那样就会有其他贵族想要你铲除它，你就能再赚一笔酬金。正当驱邪循环的骗局构想充斥脑海时，%randombrother%过来问是否该返回%employer%那里了。你点点头。一步一步来。 | %objective2%和它所有阴森残酷的居民都已被刀剑终结。看着战场上散落的尸体很是怪异，从僵尸的肉身，到古人覆满尘埃的骨架。这些尸体的多样性胜过古董店。\n\n一旦战团搜刮够了战利品，就该回去找%employer%领取报酬了。 | 死透了的僵尸和古人骷髅散落一地。“死去的亡灵”，超乎常理的邪恶之物的毁灭需要用这般奇怪的措辞来描述。但它们确实被屠戮了，证明这些怪物是可以被阻止的。你让战团做好准备返回%employer%处，去领取应得的报酬。 | %objective2%已被摧毁，证明即使是复生的死者也逃不脱%companyname%在战场上的摧枯拉朽之力。随着邪祟被清除，你感到文明与自然正回归此地。空气带着令人愉悦的清新扑鼻而来。头顶上，鸟儿划过天空。是小鸟，而不只是寻找腐肉的秃鹫。\n\n你命令战团尽可能搜刮战利品，然后准备返回%employer%处。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{胜利！ | 是时候回去%townname%了。}",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Necromancers",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_76.png[/img]{你发现远处有一些死灵法师。毫无疑问，这些人就是荼毒这片土地的大部分邪祟的元凶。不能让他们逃了！ | %randombrother%来到你身边，汗水顺着他的脸颊流下。%SPEECH_ON%长官，我们发现有几个人影在那边跑，看起来不带好意。%SPEECH_OFF%你拿起望远镜，看到沿着地平线，像蚂蚁在土丘上匆忙爬行一样，有几个穿灰衣的男人在奔跑，身后还拖着一种病态的阴霾。你拍了拍那佣兵的肩膀。%SPEECH_ON%好眼力。现在去告诉弟兄们，我们有几个死灵法师要追猎了。%SPEECH_OFF% | 你拿起望远镜观察周围地域。令人惊讶的是，远处有几个人影在奔跑，而且他们不停回头张望，仿佛你们正在追击。你调整焦距仔细看去：深色衣袍、苍白面孔、白色胡须、带有邪教风格雕刻的匕首……是死灵法师！需要抓住并杀死他们，才能彻底根除这片土地的邪祟。 | %randombrother%报告说，发现有几个人影正在逃离%companyname%。你耸耸肩告诉他，看到佣兵团就逃跑很正常。他点点头，又补充道。%SPEECH_ON%对，当然，但这些人穿着黑袍，头发灰白，而且我很肯定他们旁边还跟着几具看起来相当像尸体的东西。%SPEECH_OFF%这描述简直再典型不过了——死灵法师。战团应该在他们逃脱前追上去！ | 你正在查看地图时，%randombrother%前来汇报侦察情况。%SPEECH_ON%我们发现了几个死灵法师，长官。老头子，奇怪的武器，发光的眼睛，还有几具尸体当朋友，该有的特征全齐了。%SPEECH_OFF%如果这些真是死灵法师，那他们很可能就是这片土地诸多邪祟的根源，应该尽快将其铲除。 | 死灵法师！这些低声吟唱、鬼鬼祟祟的家伙，在尸体和其他与他们为伍的“友军”的掩护下在这片土地上行走。必须立刻追捕他们！ | 死灵法师！这些黑暗艺术的践行者，无疑对侵蚀这片土地的邪祟负有一部分责任。必须追捕并杀死他们！ | %randombrother%递给你一个望远镜。透过镜片，你迅速确认了他的报告：远处确实有死灵法师，他们正匆忙穿过附近的山谷，无疑是想避开%companyname%。你收起望远镜，命令那名佣兵通知弟兄们做好准备。必须尽快追上并杀死这些死灵法师！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "追上他们！",
					function getResult()
					{
						local tile = this.Contract.m.Objective2.getTile();
						local banner = this.Contract.m.Objective2.getBanner();
						this.Contract.m.Objective2.die();
						this.Contract.m.Objective2 = null;
						local playerTile = this.World.State.getPlayer().getTile();
						local camp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getNearestSettlement(playerTile);
						local party = this.World.FactionManager.getFaction(camp.getFaction()).spawnEntity(tile, "Necromancers", false, this.Const.World.Spawn.UndeadScourge, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
						party.getSprite("banner").setBrush(banner);
						party.setFootprintType(this.Const.World.FootprintsType.Undead);
						party.getSprite("body").setBrush("figure_necromancer_01");
						party.setSlowerAtNight(false);
						party.setUsingGlobalVision(false);
						party.setLooting(false);
						this.Const.World.Common.addTroop(party, {
							Type = this.Const.World.Spawn.Troops.Necromancer
						}, false);
						this.Const.World.Common.addTroop(party, {
							Type = this.Const.World.Spawn.Troops.Necromancer
						}, true);
						this.Contract.m.UnitsSpawned.push(party);
						this.Contract.m.Target = this.WeakTableRef(party);
						party.setAttackableByAI(true);
						party.setFootprintSizeOverride(0.75);
						local c = party.getController();
						c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
						local roam = this.new("scripts/ai/world/orders/roam_order");
						roam.setPivot(camp);
						roam.setMinRange(1);
						roam.setMaxRange(10);
						roam.setAllTerrainAvailable();
						roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
						roam.setTerrain(this.Const.World.TerrainType.Shore, false);
						roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
						c.addOrder(roam);
						this.Contract.getActiveState().start();
						this.World.Contracts.updateActiveContract();
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "NecromancersFail",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_36.png[/img]{死灵法师的踪迹已消失了。真希望这世上能有某种力量将其重现。 | 你没能追上死灵法师。你不知道他们去了哪里，但毫无疑问他们已带着自己的邪恶力量一同离去。 | 怎么回事？你怎么让死灵法师逃脱的？现在他们可以肆意妄为，四处散布邪能了。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "不，不，不！",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "未能摧毁亡灵天灾的据点");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "NecromancersAftermath",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_46.png[/img]{死灵法师已被消灭。他们心中藏有的任何邪祟，都已通过刀剑暴露无遗。他们再也不会困扰这片土地了。 | 死灵法师们倒地身亡，他们不负责任地征募尸体入伍，现在他们也是其中一员了。 | 你低头凝视着一名死灵法师，仔细打量着这个竟如此残忍地唤起死人为其作战的人。他的嘴巴依然扭曲着，仿佛随时准备念出又一道邪恶的咒语。庆幸的是，这一切都结束了。因为无论多么残忍，他终究只是个人。 | 你低头看着死灵法师那张憔悴、鬼气森森的脸。%randombrother%走上前啐了一口，一大坨唾沫正好落在尸体的脸颊上。%SPEECH_ON%去他妈的，他们可吓不倒我。%SPEECH_OFF%你点了点头。当唾沫顺着死灵法师的脸流下时，你看到它的眼睛短暂地泛起了红光。你觉得最好还是别把这个告诉那个佣兵。 | 死灵法师们已被斩杀，尽管他们眼中的光芒消散得慢得令人不安。%randombrother%似乎仍对这场战斗颇为得意。%SPEECH_ON%瞧瞧他们。全死透了，一堆废物。%SPEECH_OFF%他弯下腰，双手撑膝，对着尸体的脸大喊，好像对方是个聋子。%SPEECH_ON%你的死鬼朋友们现在在哪儿呢？嗯？哦对了，你现在也是个彻头彻尾的死鬼了！真可惜啊！%SPEECH_OFF%你让这家伙收敛点，免得这些黑暗法师在死后还有作祟的能力。 | 这些卑劣之徒已被杀死。不出所料，死了的死灵法师看起来跟普通的死人没啥两样。 | 死灵法师已被铲除，他们曾施加于此地的邪恶统治也已告终。毫无疑问，你干得很出色，摧毁了诸多荼毒这片土地的邪祟。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "少了件要担心的事。",
					function getResult()
					{
						this.Flags.set("IsNecromancers", false);
						this.Flags.set("IsNecromancersSpawned", false);
						this.Flags.set("ObjectivesDestroyed", this.Flags.get("ObjectivesDestroyed") + 1);
						this.Contract.m.Target = null;

						if (this.Flags.get("ObjectivesDestroyed") == 2)
						{
							this.Contract.setState("Return");
						}
						else
						{
							this.Contract.getActiveState().start();
							this.World.Contracts.updateActiveContract();
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Bandits",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_07.png[/img]{在前往%objective%的途中，你遇到了一群土匪。他们转身亮出武器，%companyname%的成员们也做出了同样的动作。你举起手，那群流寇的头领也做了相同的手势，稍稍缓解了两队人马之间的紧张气氛。头领开口道。%SPEECH_ON%战利品是我们的，我们先到这儿，要是你们敢抢，我们也会在这儿奉陪到底！%SPEECH_OFF%看起来他们只是想洗劫这个地方。这么做需要杀掉大量僵尸，这无疑会有帮助。或许你们可以联手？无论你作何选择，都要快，因为亡灵已经来了！ | 一群土匪正准备攻击%objective%！他们拔出武器并威胁要动手，但你与他们谈判了片刻，发现他们只是想洗劫这地方。或许%companyname%可以和他们联手？或者，见鬼，干脆把亡灵和土匪全宰了，把所有东西都据为己有。 | 当你接近%objective%时，遇到了一群土匪。他们正准备攻击——不是攻击%companyname%，而是藏尸地。看来他们只是盯上了那里可能存在的任何战利品，并且愿意为此和你们动手。也许你可以加入他们，代价是放弃任何潜在的战利品，或者干脆继续前进，杀光所有活物，把财富和荣耀都留给自己。不过要快点决定，因为亡灵已经来了！ | 土匪！一群全副武装、准备进攻的土匪。庆幸的是，他们打算攻击的是%objective%本身。或许%companyname%可以和他们联手，但毫无疑问这些流寇会想要分走找到的战利品的一大块。另一个选择是把所有东西都杀光，然后把战利品据为己有。不过最好快点决定，因为亡灵已经来了！ | 你遇到了几个全副武装的人。他们迅速转身面对你，武器已然出鞘。%randombrother%抽出了刀，威胁要杀掉第一个敢动的人。尽管气氛相当紧张，你和那群流寇的头领还是设法平息了事态并进行交谈。他解释说，他们来此是为了洗劫%objective%，并拿走那里的全部战利品。你可以和这些盗贼合作，或者，如果你想独吞所有战利品，就把他们和僵尸一起干掉。 | %randombrother%去小便，但他从灌木丛边跳开，一半手在提裤子，一半手在试图拔出真正的武器。一个土匪从灌木丛中钻了出来，手里已经握着刀，很快他们的人接二连三地出现，大喊大叫着，%companyname%的人也对他们报以同样的反应。他们的头领走了出来，举起双手，要求与头领对话。\n\n在你们的谈话中，你了解到他们是一群寻宝的流寇，想要洗劫%objective%。你可以加入他们，一起对抗亡灵，但如果你不加入，他们就会同时与你和亡灵开战，因为他们来这儿可不是为了和佣兵分赃的。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们有共同的目标。联手一起进攻吧！",
					function getResult()
					{
						this.Flags.set("IsBanditsCoop", true);
						this.Contract.m.Current.getLoot().clear();
						this.Contract.m.Current.setDropLoot(false);
						this.Contract.getActiveState().onCombatWithPlayer(this.Contract.m.Current, false);
						return 0;
					}

				},
				{
					Text = "我们不是来这让出战利品的。受死吧！",
					function getResult()
					{
						this.Flags.set("IsBandits3Way", true);
						this.Contract.getActiveState().onCombatWithPlayer(this.Contract.m.Current, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BanditsAftermathCoop",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_07.png[/img]{此地的邪祟已被铲除。和土匪们分完赃物后，你准备向%objective2%进发，并确保不向这些窃贼透露丝毫动向。 | 当最后一个亡灵安息时，你感觉到空气正在变得清澈，如同烟雾弥漫的雾气让位于清新的春日芬芳。气味的迅速转变无疑意味着你已清除了盘踞在此的邪祟。你和土匪们瓜分了战利品。他们一副谄媚的嘴脸，声称要不是他们在，你们这帮人肯定活不下来。你差点就告诉他们%objective2%的事，但他们这不合时宜的骄傲爆发，彻底毁掉了你们再次合作的可能。 | 此地的邪祟已被平息。%objective2%正等着你。\n\n你和土匪们瓜分了战利品，他们非常乐意与你做这笔交易。他们虽未明说，但显而易见，若不是你在场，他们早就被屠杀殆尽了。 | 随着这恐怖之地的邪祟被清除，合同上只剩下%objective2%要处理了。至于那些土匪，他们按约定拿走了自己的那份战利品。他们问你要去哪里，你告诉他们这不关他们的事。 | 当最后一个僵尸被安息时，你感到空气骤然一变。尽管身处泥泞污秽之中，纯净的空气却以出乎意料的清冽直冲肺腑。%randombrother%擦了擦额头。%SPEECH_ON%肯定是结束了。那咱们接下来去%objective2%？%SPEECH_OFF%一个土匪走了过来，你让那佣兵闭嘴。最好别让这些狗东西知道下一个地点。尽管分走了一大份战利品，他们在战斗中根本就没帮上什么忙。 | 你之前踏入的是邪祟横行之地，但随着最后一个僵尸被斩杀，你看到世界的光芒变得明亮，脚下的泥土气息也回归了自然秩序。既然此地已得安息，是时候前往%objective2%了\n\n土匪头领走了过来。他手里拿着卷轴，正在记录分赃情况。%SPEECH_ON%合作愉快，佣兵。%SPEECH_OFF%你告诉他，要不是你出现，他那帮蠢货手下早就自作自受地完蛋了。他耸耸肩。%SPEECH_ON%人无完人嘛。那下次再合作？%SPEECH_OFF%你没理他，转身去集合手下。 | 胜利来之不易。战场上遍布着僵尸和更为古老的亡灵。与你联手的那帮土匪正在仔细搜查残骸，按约定拿走他们那份战利品。你希望%objective2%能更容易解决，但希望不大。 | 土匪们正在战场上搜刮，捡取你和他们头领约定归他们的那份战利品。你吩咐%randombrother%悄悄让兄弟们做好准备，向%objective2%进军。他问为什么要悄悄进行，你回答。%SPEECH_ON%因为咱们最不需要的，就是这些没用的鼠辈累赘再出现在另一场战斗里，抢走你我都知道他们不配拿的战利品。%SPEECH_OFF%那佣兵点点头。%SPEECH_ON%啊。你把我的心里话都说出来了，不过长官，你这骂人的水平比我高。%SPEECH_OFF% | 你开始让手下做好准备，向%objective2%进军。\n\n土匪头领凑到你跟前。%SPEECH_ON%跟你并肩作战真不赖。话说，你们接下来要去哪儿？又去找宝藏了，嗯？%SPEECH_OFF%你转身一把抓住他的衣领。%SPEECH_ON%我想你我都清楚在那场战斗里谁才是真正出了力的。现在，拿着你的战利品滚蛋。这是我们说好的。要是你敢跟踪我们，我就把你偷来的所有东西熔了，浇在你他妈的脑袋上，听懂了吗？%SPEECH_OFF%他畏缩地后退，紧张地点头，好像你下一秒就会实现这个承诺似的。 | 随着最后一个亡灵被斩杀，你环顾战场。从他们各式各样的衣物和盔甲来看，这些死者并非来自同一源头，但他们甚至也不属于同一时代。有些穿着古代盔甲，带着令人不安的整齐划一前来杀戮。\n\n%randombrother%走过来报告，说战团已准备就绪，随时可以出发前往%objective2%。土匪头领插嘴道。%SPEECH_ON%嗯，不过得等咱们先分完战利品，对吧？%SPEECH_OFF%你点了点头。这确实是约定好的。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "胜利！",
					function getResult()
					{
						this.Flags.set("IsBanditsCoop", false);

						if (this.Flags.get("ObjectivesDestroyed") == 2)
						{
							this.Contract.setState("Return");
						}
						else
						{
							this.Contract.getActiveState().start();
							this.World.Contracts.updateActiveContract();
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BanditsAftermath3Way",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_22.png[/img]{你在尸堆中发现了土匪头领的尸体。他脸上带着悔恨的神情，这表情常见于刚把自己作死的人脸上，但他的情绪更加浓烈。唉，真可悲。你集合手下，准备向%objective2%进军。 | 土匪头领倒在地上死了。他半边脸不见了，很快就发现是在附近一个僵尸的嘴里。真遗憾。好了，该动身去%objective2%了。 | 不死生物解决了，那些自以为能对抗%companyname%的愚蠢土匪也解决了，现在只剩下%objective2%了。 | 土匪们做出了糟糕的选择，同时与不死生物和%companyname%开战。令人震惊的是，他们下场很惨。你命令手下收集所有战利品，准备向%objective2%进军。 | 当最后一个亡灵安息，你感觉空气变得清新了，如同烟雾弥漫的雾气让位于清新的春日芬芳。气味的迅速转变无疑意味着你已清除了盘踞在此的邪祟。不幸的是，那帮决定与你为敌的土匪尸体多少会弄臭这里。哦算了。现在去净化%objective2%，了结这份合约。 | 此地的邪能已被平息。那些土匪也是，一群可怜的傻瓜。%objective2%正等着呢。 | 当最后一个僵尸重获安宁，它旁边的最后一个蠢贼也毙命时，你感到焕然一新。一部分是因为向那些土匪证明了他们的头领有多糟糕才让他们落得如此团灭的下场。另一部分无疑是邪能退散后留下的舒畅感。是时候动身去%objective2%了。 | 胜利来之不易。嗯，不死生物倒是顽强抵抗了。那些土匪死得一如他们蠢货的本色。你希望%objective2%能更容易解决，但除非那里真的塞满了白痴盗贼而不是邪恶玩意，否则希望不大。 | 你发现土匪头领的尸体趴在一具僵尸的尸体上。%randombrother%走过来笑道。%SPEECH_ON%看来他们是天生一对。%SPEECH_OFF%你也笑着，让他叫兄弟们准备好，向%objective2%进发。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "他们罪有应得。",
					function getResult()
					{
						this.Flags.set("IsBandits3Way", false);

						if (this.Flags.get("ObjectivesDestroyed") == 2)
						{
							this.Contract.setState("Return");
						}
						else
						{
							this.Contract.getActiveState().start();
							this.World.Contracts.updateActiveContract();
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer%举着酒杯，在欢叫的女人簇拥下从容地将你迎进房间。在这个充满行尸走肉的世界里，他倒是生机勃勃。这位醉醺醺的贵族把%reward_completion%克朗交到你手上，随后他的一个守卫便把你请了出去。 | 你走进%employer%的房间，看到他和一个女人站在一张桌子旁。桌上躺着一个脸色极其苍白、一动不动的孩子。母亲沉默地哀悼着，她的脸诉说着所有需要的悲恸。你向贵族报告任务已完成，打破了这悲伤的气氛。他点点头。%SPEECH_ON%我知道。有传言说，一旦你回来，打散的邪能或许能让大地重获新生。土壤是比以前肥沃了，但死者依然长眠。你的报酬在角落，佣兵。%SPEECH_OFF%你去取走了你的%reward_completion%克朗。当你离开时，%employer%仍在安慰那个女人。 | 一名守卫带你来到%employer%的一处藏身地，某个与其说是房间不如说是密室的四方地方。这位贵族正埋头阅读卷轴，但看到你时猛地坐直了身子。%SPEECH_ON%佣兵！我正等你呢！进来，快进来。%SPEECH_OFF%他放下文书，从地上拿起一个袋子。%SPEECH_ON%约定好的%reward_completion%克朗。有消息说邪祟已完全离开了这些土地。我不太确定，但毫无疑问你的胜利至少确保了我们在战争中的优势。干得好，雇佣兵。%SPEECH_OFF% | %employer%一只手招你进房间，另一只手则递出一袋克朗。%SPEECH_ON%你无需向我报告，佣兵，我的小鸟们已经告诉了我一切。给你，这是约定好的报酬。%SPEECH_OFF% | %employer%热情地欢迎你，尽管一个鹰钩鼻书记官在角落里愤怒地佝偻着身子，好像你是来抢他食物的又一只食腐动物。你汇报了你的成果，但贵族摆手打断了。%SPEECH_ON%哦佣兵，这片土地上发生的一切我都知道。你赚这%reward_completion%克朗是理所应当的。%SPEECH_OFF%书记官开口说话，吓了%employer%一跳。%SPEECH_ON%邪祟确实已被摧毁，唯有良善得以滋长！现在，雇佣兵，请离开吧。我们这里有要事相商。%SPEECH_OFF%哦哦，行啊。你拿上报酬走了。 | 你在马厩里找到了%employer%。马厩隔间都空了，周围也没有马童。见到你，他迅速握了握你的手。%SPEECH_ON%很高兴见到你，佣兵。我已经得知你成功的消息。你为这片土地解除了邪恶的枷锁，赋予了它新的生命与活力。至少目前是这样。去找那边那个守卫，他会带你去财务官那里领取你应得的%reward_completion%克朗。%SPEECH_OFF% | 你发现%employer%站在一个新掩埋的坟墓前。几个教堂司事坐在附近共用一个山羊皮水袋。贵族耸了耸肩。%SPEECH_ON%尸体不再爬出来了。所以佣兵，你不仅摧毁了邪祟的源头，很可能还直接将部分邪祟驱离了这些土地。诸神在上，但愿如此。你的报酬在财务官那里。他会按承诺给你%reward_completion%克朗。%SPEECH_OFF% | 正在和一名医师交谈。医师身旁是一车锋利的工具，其中一些斜插在一盆红水里。瞥了一眼贵族，你看到他的一条胳膊刚缝好针。他招手让你进去。%SPEECH_ON%猎野猪时出了点意外，佣兵。%SPEECH_OFF%医师收拾好东西离开了，告诉贵族要静养一周。%SPEECH_ON%是是是，好吧，我还有事要处理。头一件就是你，雇佣兵。你的报酬在角落，答应你的%reward_completion%克朗。谁知道驱使亡灵的邪能是否真的被驱离了这些土地，但你已按要求完成了任务。%SPEECH_OFF% | 你进去时%employer%正在和一个女人说话。她说出了你这段时间以来听过的最奇怪的话。%SPEECH_ON%我的小儿子留在地下了！他没有回来！我太高兴了！他不会复活了！%SPEECH_OFF%贵族热情地握着她的手，朝你点了点头。%SPEECH_ON%而那位就是将邪祟从此地驱离的人。你赚得了那%reward_completion%克朗，佣兵！%SPEECH_OFF% | 你看到%employer%正在和一只毛茸茸的小狗玩耍。它蹦跳着，在光滑的石板地上啪嗒啪嗒地追着一根棍子。贵族把棍子扔到你脚下，小狗扑向棍子，撞在了你的靴子上。%SPEECH_ON%前几天这狗还一动不动，但现在它玩个不停。嗯，我要是好赌之人，准会打赌这跟你和那些不死生物有关，佣兵。干得好。你的报酬是%reward_completion%克朗，说好的数目，或者你可以带走这小狗。%SPEECH_OFF%你说你要小狗。贵族惊讶地往后一退。%SPEECH_ON%算了，你还是拿克朗吧。小狗是我的。%SPEECH_OFF%汪。 | 你步入%employer%的房间，发现他正凝视着窗外。他带着乐观的真诚评论道。%SPEECH_ON%生机勃勃。一切都如此生机勃勃。%SPEECH_OFF%他转过身，手里拿着一个袋子。他走过来把它递给你。%SPEECH_ON%里面应该有%reward_completion%克朗。你干得很好，佣兵，愿你在此的服务让我们离彻底终结这邪能更近一步。%SPEECH_OFF% | %employer%拿着一壶酒欢迎你。酒带着一股金属味，但你明白不该对此发表评论。贵族步履轻快地绕到他的书桌旁。%SPEECH_ON%干得好，佣兵。若不是有你这样的人，真不知道这些土地会变成什么样。我向旧神祈祷，愿在不久的一天，我们能完全摆脱所有这些邪祟！%SPEECH_OFF% | 一名守卫在%employer%的房间外迎接你。他瞥了你一眼，尤其注意了你肩上的%companyname%徽章。%SPEECH_ON%给，佣兵。%employer%非常忙，但他让我转达感谢。%SPEECH_OFF%你拿到了%reward_completion%克朗。 | 一个皮肤苍白光滑的财务官在通往%employer%房间的走廊里迎接你。他拿着一个装满克朗的袋子，迅速递给你。%SPEECH_ON%你的报酬在里面，说好的数目。我的主子目前正与他的书记官们忙于更好地解决这可怕的不死生物问题。%SPEECH_OFF% | 你发现%employer%在刮胡子，一个疲惫且皱着眉的女人为他举着镜子。%SPEECH_ON%嚯，佣兵。哎哟。嘿。%SPEECH_OFF%他把剃刀在水盆里蘸了蘸，然后急忙走到书桌旁。%SPEECH_ON%我的小鸟们早已告诉我你的成果行动。 不仅如此，每个人似乎都因此好起来了！孩子们又笑了，阳光明媚，庄稼据说也长势旺盛！每个人都很开心！%SPEECH_OFF%女人问是否可以放下镜子。贵族打了个响指。%SPEECH_ON%嘘，你。给，佣兵。说好的%reward_completion%克朗。%SPEECH_OFF% | 你发现%employer%不在他的房间，而是在某个烛光昏暗的暗室里。这个滴着水、潮湿的房间里有个男人被锁链吊着。从他的表情判断，他看起来宁愿是被绳子吊着。贵族背着手站着，一个戴黑头罩的人正用犹豫不决的手指抚过一盘刀刃。你咳嗽了一声。%employer%转过身来。%SPEECH_ON%啊，佣兵！我正等你呢！给，之前商量好的%reward_completion%克朗。但愿这次亡灵能永远消失。但是，无论发生什么，你为将邪祟从此世根除做出了巨大贡献。%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "摧毁了亡灵天灾的据点");
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
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"objective1",
			this.m.Flags.get("Objective1Name")
		]);
		_vars.push([
			"objective2",
			this.m.Flags.get("Objective2Name")
		]);
		local distToObj1 = this.m.Objective1 != null && !this.m.Objective1.isNull() && this.m.Objective1.isAlive() ? this.m.Objective1.getTile().getDistanceTo(this.World.State.getPlayer().getTile()) : 9999;
		local distToObj2 = this.m.Objective2 != null && !this.m.Objective2.isNull() && this.m.Objective2.isAlive() ? this.m.Objective2.getTile().getDistanceTo(this.World.State.getPlayer().getTile()) : 9999;

		if (distToObj1 < distToObj2)
		{
			_vars.push([
				"objective",
				this.m.Flags.get("Objective1Name")
			]);
		}
		else
		{
			_vars.push([
				"objective",
				this.m.Flags.get("Objective2Name")
			]);
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Objective1 != null && !this.m.Objective1.isNull() && this.m.Objective1.isAlive())
			{
				this.m.Objective1.getSprite("selection").Visible = false;
				this.m.Objective1.setOnCombatWithPlayerCallback(null);
			}

			if (this.m.Objective2 != null && !this.m.Objective2.isNull() && this.m.Objective2.isAlive())
			{
				this.m.Objective2.getSprite("selection").Visible = false;
				this.m.Objective2.setOnCombatWithPlayerCallback(null);
			}

			if (this.m.Target != null && !this.m.Target.isNull() && this.m.Target.isAlive())
			{
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			this.m.Current = null;
			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isUndeadScourge())
		{
			return false;
		}

		if (this.m.IsStarted)
		{
			if (this.m.Objective1 == null || this.m.Objective1.isNull() || !this.m.Objective1.isAlive())
			{
				return false;
			}

			if (this.m.Objective2 == null || this.m.Objective2.isNull() || !this.m.Objective2.isAlive())
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
		if (this.m.Objective1 != null && !this.m.Objective1.isNull())
		{
			_out.writeU32(this.m.Objective1.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		if (this.m.Objective2 != null && !this.m.Objective2.isNull())
		{
			_out.writeU32(this.m.Objective2.getID());
		}
		else
		{
			_out.writeU32(0);
		}

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
		local obj1 = _in.readU32();

		if (obj1 != 0)
		{
			this.m.Objective1 = this.WeakTableRef(this.World.getEntityByID(obj1));
		}

		local obj2 = _in.readU32();

		if (obj2 != 0)
		{
			this.m.Objective2 = this.WeakTableRef(this.World.getEntityByID(obj2));
		}

		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});
