this.patrol_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Location1 = null,
		Location2 = null,
		NextObjective = null,
		Dude = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.patrol";
		this.m.Name = "巡逻";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 5.0;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
		this.m.MakeAllSpawnsResetOrdersOnceDiscovered = true;
		this.m.DifficultyMult = 1.0;
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

		local settlements = clone this.World.FactionManager.getFaction(this.m.Faction).getSettlements();
		local i = 0;

		while (i < settlements.len())
		{
			local s = settlements[i];

			if (s.isIsolatedFromRoads() || !s.isDiscovered() || s.getID() == this.m.Home.getID())
			{
				settlements.remove(i);
				continue;
			}

			i = ++i;
		}

		this.m.Location1 = this.WeakTableRef(this.getNearestLocationTo(this.m.Home, settlements, true));
		this.m.Location2 = this.WeakTableRef(this.getNearestLocationTo(this.m.Location1, settlements, true));
		this.m.Payment.Pool = 750 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
		local r = this.Math.rand(1, 3);

		if (r == 1)
		{
			this.m.Payment.Count = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else if (r == 2)
		{
			this.m.Payment.Count = 0.75;
			this.m.Payment.Completion = 0.25;
		}
		else
		{
			this.m.Payment.Count = 1.0;
		}

		local maximumHeads = [
			20,
			25,
			30,
			35
		];
		this.m.Payment.MaxCount = maximumHeads[this.Math.rand(0, maximumHeads.len() - 1)];
		this.m.Flags.set("HeadsCollected", 0);
		this.m.Flags.set("StartDay", 0);
		this.m.Flags.set("LastUpdateDay", 0);
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Flags.set("StartDay", this.World.getTime().Days);
				this.Contract.m.BulletpointsObjectives = [
					"沿途巡逻，前往" + this.Contract.m.Location1.getName(),
					"沿途巡逻，前往" + this.Contract.m.Location2.getName(),
					"沿途巡逻，前往" + this.Contract.m.Home.getName()
				];
				this.Contract.m.BulletpointsObjectives.push("在%days%内返回");

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
				this.Flags.set("EnemiesAtWaypoint1", this.Math.rand(1, 100) <= 25 * this.Math.pow(this.Contract.getDifficultyMult(), 2));
				this.Flags.set("EnemiesAtWaypoint2", this.Math.rand(1, 100) <= 25 * this.Math.pow(this.Contract.getDifficultyMult(), 2) + (this.Flags.get("EnemiesAtWaypoint1") ? 0 : 50));
				this.Flags.set("EnemiesAtLocation3", this.Math.rand(1, 100) <= 25 * this.Math.pow(this.Contract.getDifficultyMult(), 2) + (this.Flags.get("EnemiesAtWaypoint2") ? 0 : 100));
				this.Flags.set("StartDay", this.World.getTime().Days);

				if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().get("Betrayed"))
				{
					this.Flags.set("IsBetrayal", this.Math.rand(1, 100) <= 75);
				}
				else
				{
					local r = this.Math.rand(1, 100);

					if (r <= 10)
					{
						if (this.World.FactionManager.isGreenskinInvasion())
						{
							this.Flags.set("IsCrucifiedMan", true);
						}
					}
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.Location1.getSprite("selection").Visible = true;
				this.Contract.m.Location2.getSprite("selection").Visible = false;
				this.Contract.m.Home.getSprite("selection").Visible = false;
				this.Contract.m.NextObjective = this.Contract.m.Location1;
				this.Contract.m.BulletpointsObjectives = [
					"沿途巡逻，前往" + this.Contract.m.Location1.getName()
				];

				if (this.Contract.m.Payment.Count != 0)
				{
					this.Contract.m.BulletpointsObjectives.push("按照你在路上斩获头颅的数量计算报酬 (%killcount%/%maxcount%)");
				}

				this.Contract.m.BulletpointsObjectives.push("在%days%内返回");
			}

			function update()
			{
				if (this.Flags.get("LastUpdateDay") != this.World.getTime().Days)
				{
					if (this.World.getTime().Days - this.Flags.get("StartDay") >= 5)
					{
						this.Contract.setScreen("Failure1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Flags.set("LastUpdateDay", this.World.getTime().Days);
						this.start();
						this.World.State.getWorldScreen().updateContract(this.Contract);
					}
				}

				if (this.Contract.isPlayerAt(this.Contract.m.Location1))
				{
					this.Contract.setScreen("Success1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("EnemiesAtWaypoint1"))
				{
					if (this.Contract.spawnEnemies())
					{
						this.Flags.set("EnemiesAtWaypoint1", false);
					}
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				this.Contract.addKillCount(_actor, _killer);
			}

			function onCombatVictory( _combatID )
			{
				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Location2",
			function start()
			{
				this.Contract.m.Location1.getSprite("selection").Visible = false;
				this.Contract.m.Location2.getSprite("selection").Visible = true;
				this.Contract.m.Home.getSprite("selection").Visible = false;
				this.Contract.m.NextObjective = this.Contract.m.Location2;
				this.Contract.m.BulletpointsObjectives = [
					"沿途巡逻，前往" + this.Contract.m.Location2.getName()
				];

				if (this.Contract.m.Payment.Count != 0)
				{
					this.Contract.m.BulletpointsObjectives.push("按照你在路上斩获头颅的数量计算报酬 (%killcount%/%maxcount%)");
				}

				this.Contract.m.BulletpointsObjectives.push("在%days%内返回");
			}

			function update()
			{
				if (this.Flags.get("LastUpdateDay") != this.World.getTime().Days)
				{
					if (this.World.getTime().Days - this.Flags.get("StartDay") >= 5)
					{
						this.Contract.setScreen("Failure1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Flags.set("LastUpdateDay", this.World.getTime().Days);
						this.start();
						this.World.State.getWorldScreen().updateContract(this.Contract);
					}
				}

				if (this.Contract.isPlayerAt(this.Contract.m.Location2))
				{
					this.Contract.setScreen("Success2");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("EnemiesAtWaypoint2"))
				{
					if (this.Contract.spawnEnemies())
					{
						this.Flags.set("EnemiesAtWaypoint2", false);
					}
				}

				if (this.Flags.get("IsCrucifiedMan") && !this.TempFlags.get("IsCrucifiedManShown") && this.World.State.getPlayer().getTile().HasRoad && this.Contract.getDistanceToNearestSettlement() >= 6 && this.Math.rand(1, 1000) <= 1)
				{
					this.TempFlags.set("IsCrucifiedManShown", true);
					this.Contract.setScreen("CrucifiedA");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsCrucifiedManWon"))
				{
					this.Flags.set("IsCrucifiedManWon", false);

					if (this.Math.rand(1, 100) <= 50)
					{
						this.Contract.setScreen("CrucifiedE_AftermathGood");
					}
					else
					{
						this.Contract.setScreen("CrucifiedE_AftermathBad");
					}

					this.World.Contracts.showActiveContract();
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				this.Contract.addKillCount(_actor, _killer);
			}

			function onCombatVictory( _combatID )
			{
				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);

				if (_combatID == "CrucifiedMan")
				{
					this.Flags.set("IsCrucifiedManWon", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.Location1.getSprite("selection").Visible = false;
				this.Contract.m.Location2.getSprite("selection").Visible = false;
				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.Contract.m.NextObjective = this.Contract.m.Home;
				this.Contract.m.BulletpointsObjectives = [
					"沿途巡逻，前往" + this.Contract.m.Home.getName()
				];

				if (this.Contract.m.Payment.Count != 0)
				{
					this.Contract.m.BulletpointsObjectives.push("按照你在路上斩获头颅的数量计算报酬 (%killcount%/%maxcount%)");
				}

				this.Contract.m.BulletpointsObjectives.push("在%days%内返回");
			}

			function update()
			{
				if (this.Flags.get("LastUpdateDay") != this.World.getTime().Days)
				{
					if (this.World.getTime().Days - this.Flags.get("StartDay") >= 5)
					{
						this.Contract.setScreen("Failure1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Flags.set("LastUpdateDay", this.World.getTime().Days);
						this.start();
						this.World.State.getWorldScreen().updateContract(this.Contract);
					}
				}

				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Flags.get("HeadsCollected") != 0)
					{
						this.Contract.setScreen("Success3");
					}
					else
					{
						this.Contract.setScreen("Success4");
					}

					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("EnemiesAtWaypoint3"))
				{
					if (this.Contract.spawnEnemies())
					{
						this.Flags.set("EnemiesAtWaypoint3", false);
					}
				}

				if (this.Flags.get("IsCrucifiedMan") && !this.TempFlags.get("IsCrucifiedManShown") && this.World.State.getPlayer().getTile().HasRoad && this.Contract.getDistanceToNearestSettlement() >= 6 && this.Math.rand(1, 1000) <= 1)
				{
					this.TempFlags.set("IsCrucifiedManShown", true);
					this.Contract.setScreen("CrucifiedA");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsCrucifiedManWon"))
				{
					this.Flags.set("IsCrucifiedManWon", false);

					if (this.Math.rand(1, 100) <= 50)
					{
						this.Contract.setScreen("CrucifiedE_AftermathGood");
					}
					else
					{
						this.Contract.setScreen("CrucifiedE_AftermathBad");
					}

					this.World.Contracts.showActiveContract();
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				this.Contract.addKillCount(_actor, _killer);
			}

			function onCombatVictory( _combatID )
			{
				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);

				if (_combatID == "CrucifiedMan")
				{
					this.Flags.set("IsCrucifiedManWon", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);
			}

		});
	}

	function createScreens()
	{
		this.importScreens(this.Const.Contracts.NegotiationPerHead);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "谈判",
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer%严肃地指了指椅子。你顺势坐下。%SPEECH_ON%这片地区不太平。商队都在抱怨路上的匪徒和其他威胁。%SPEECH_OFF%他低头揉着太阳穴。%SPEECH_ON%我的人手都抽不开身，需要你负责巡逻。前往%location1%，接着行进到%location2%，然后在%days%内返回。遇到威胁就彻底清除。我可不是雇你游山玩水，佣兵。酬金按你带回来的脑袋计算。 | %employer%正对着地图喃喃自语，目光像鹰隼般在图纸上快速移动。%SPEECH_ON%我的人手分散在各处。这里，那里，还有那边。这片区域？连名字都没有，但他们也在那儿。唯独这里和这里没人驻守——这就是需要你的地方，佣兵。%SPEECH_OFF%他停顿片刻抬头看你。%SPEECH_ON%需要你巡逻到%location1%和%location2%。清理所有妄想霸占道路的活物。你肯定懂我在说什么。但别指望散步就能拿钱，佣兵。%days%内带着你收集的每一颗头颅回来，按件计酬。%SPEECH_OFF% | %employer%灌了口酒打个嗝，显得很不耐烦。%SPEECH_ON%我通常不找佣兵巡逻，但手下都在别处忙活。任务很简单：去%location1%，再到%location2%，%days%内返回。沿途清除所有威胁本地居民的活物。记得把脑袋带回来：酬金按战利品计算，不按里程。%SPEECH_OFF% | %employer%露出狡黠的笑。%SPEECH_ON%要是给你个按人头计酬的差事如何？有兴趣吗？现在需要有人巡逻到%location1%和%location2%的区域。你边走边清理沿途威胁，%days%内带着战利品回来。\n\n我会按你带回的脑袋数量付钱。考虑一下？%SPEECH_OFF% | %employer%手指点着地图。%SPEECH_ON%先去这里。%SPEECH_OFF%指尖滑向另一处。%SPEECH_ON%再去这里。一次长途巡逻。有任何不属于%noblehousename%的活物妄图霸占道路的话，就把他们处理掉。记住把脑袋带回来。我可不是给你钱度假。%days%内带着战利品回来，按件计酬。%SPEECH_OFF%}%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "多大的生意？",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "我不喜欢长途跋涉。",
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
			ID = "CrucifiedA",
			Title = "在路上……",
			Text = "[img]gfx/ui/events/event_02.png[/img]你派去侦察的%randombrother%回来汇报：%SPEECH_ON%到处是烧毁的小村子。有个死人从肚子那儿被砍成两半，腿也不见了。他的狗就趴在旁边，不肯离开，怎么哄都不走。还发现一头死驴挂在树杈上，屁股那头插着根长矛。%SPEECH_OFF%他顿了顿，突然打响指：%SPEECH_ON%哦！差点忘了。那边山丘背面有个被钉在十字架上的人。还活着呢，惨叫连连，但我没靠近——陌生人的痛苦最是麻烦。%SPEECH_OFF%",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "行吧。我们去看看那个被钉着的家伙。",
					function getResult()
					{
						return "CrucifiedB";
					}

				},
				{
					Text = "没什么需要处理的。干得好。",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Flags.set("IsCrucifiedMan", false);
			}

		});
		this.m.Screens.push({
			ID = "CrucifiedB",
			Title = "在路上……",
			Text = "[img]gfx/ui/events/event_02.png[/img]你决定冒险去看看那个被钉着的家伙。\n\n你登上附近的山坡向下望去，情况正如那个佣兵所说。山坡尽头确实钉着个人，身体无力地悬垂着，即使隔这么远仍能听见断断续续的惨叫。%randombrother%问你该怎么办。",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "我们去放他下来。",
					function getResult()
					{
						if (this.Math.rand(1, 100) <= 50 && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
						{
							return "CrucifiedC";
						}
						else
						{
							return "CrucifiedD";
						}
					}

				},
				{
					Text = "这显然是个陷阱。我们静观其变。",
					function getResult()
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "CrucifiedE";
						}
						else
						{
							return "CrucifiedF";
						}
					}

				},
				{
					Text = "我们走吧。这事有点不对劲。",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "CrucifiedC",
			Title = "在路上……",
			Text = "[img]gfx/ui/events/event_02.png[/img]如果留下这个可怜人面对如此可怕的命运，你不确定自己晚上还能否安睡。你带着战团开始下山。救援行动并不特别迅速，因为你仍然担心埋伏，但什么也没有发生。当你靠近时，被钉在十字架上的人咧嘴笑了。%SPEECH_ON%放我下来，我会为你战斗到生命的尽头，我发誓！%SPEECH_OFF%佣兵们用武器撬开钉子，把那人解救下来。他顺着木柱滑下，落入一些佣兵的臂弯中，他们轻轻将他放到地上。他一边小口喝水，一边说道。%SPEECH_ON%是绿皮干的。我是村里最后一个人，我猜他们是想想找点乐子，而不是直接用斧头劈开我的脑袋。在你来之前，我都快觉得后面那种死法更好了。先生，我现在的状态不是很好，但过段时间我会恢复的，我以我家族的姓氏发誓，我会为你战斗到死或直到最后的胜利！%SPEECH_OFF%",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "没多少人能从这样的恐怖经历中幸存下来。欢迎加入战团。",
					function getResult()
					{
						this.World.getPlayerRoster().add(this.Contract.m.Dude);
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude.onHired();
						this.Contract.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "你不适合来我们战团。",
					function getResult()
					{
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude = null;
						return 0;
					}

				}
			],
			function start()
			{
				local roster = this.World.getTemporaryRoster();
				this.Contract.m.Dude = roster.create("scripts/entity/tactical/player");
				this.Contract.m.Dude.setStartValuesEx(this.Const.CharacterVillageBackgrounds);
				this.Contract.m.Dude.getBackground().m.RawDescription = "你及时把十字架上的%name%救了下来。他发誓效忠于你，直到他的生命到达尽头，或是你取得最终的胜利。";
				this.Contract.m.Dude.getBackground().buildDescription(true);
				this.Contract.m.Dude.getSkills().removeByID("trait.disloyal");
				this.Contract.m.Dude.getSkills().add(this.new("scripts/skills/traits/loyal_trait"));
				this.Contract.m.Dude.setHitpoints(1);

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

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "CrucifiedD",
			Title = "在路上……",
			Text = "[img]gfx/ui/events/event_67.png[/img]要是对这可怜虫见死不救，你夜里怕是难以安眠。你带着战团冲下山坡，既是帮他，也是帮你自己求个心安。被钉在十字架上的家伙见你们靠近露出笑容。%SPEECH_ON%谢了陌生人！谢谢谢谢谢——%SPEECH_OFF%话音被标枪贯穿胸膛的闷响打断，矛头深深扎进他身后的木板。你猛地转身，正好看见绿皮从附近灌木丛里蜂拥而出。天杀的，根本就是个陷阱！准备战斗！",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "事件";
						properties.Music = this.Const.Music.GoblinsTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.EnemyBanners = [
							"banner_goblins_03"
						];
						properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.GreenskinHorde, this.Math.rand(90, 110), this.Const.Faction.Enemy);
						this.World.Contracts.startScriptedCombat(properties, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "CrucifiedE",
			Title = "在路上……",
			Text = "[img]gfx/ui/events/event_07.png[/img]你决定继续观望。正当你坐着听垂死者的哀嚎渐渐归于沉寂时，%randombrother%突然抓住你肩膀指向不远处——几个匪徒正朝十字架走去·。他们到达后交谈片刻，其中一人掏出匕首开始戳刺垂死者脚趾，凄厉的惨叫顿时划破寂静。有个匪徒转身大笑，笑声戛然而止。他喊叫着指向山坡……你们被发现了！趁这群杂种还没列好阵型，你立即下令%companyname%发起冲锋！",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "CrucifiedMan";
						properties.Music = this.Const.Music.GoblinsTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.EnemyBanners = [
							"banner_bandits_03"
						];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.BanditRaiders, this.Math.rand(90, 110), this.Const.Faction.Enemy);
						this.World.Contracts.startScriptedCombat(properties, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "CrucifiedE_AftermathGood",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_22.png[/img]令人震惊的是，战斗结束后那个被钉在十字架上的人还活着。他用沙哑的嗓音向你呼喊，虽然说不清词句，但那种\"求救\"的语调再明显不过。你让兄弟们把他放了下来。他刚碰到地面就昏了过去，随即又猛地醒过来抓住你的手。%SPEECH_ON%谢谢你，陌生人。太感谢你了。兽人……来了……然后土匪又来洗劫剩下的……但你，你不一样。谢谢你！这世上我一无所有了，只想跟那些夺走我一切的家伙战斗到底。我是%crucifiedman%，家族的最后一人。如果你愿意收留，我发誓将用这把剑为你效忠，直到我死或你赢得最后胜利的那天。%SPEECH_OFF%",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "没多少人能从这样的恐怖经历中幸存下来。欢迎加入战团。",
					function getResult()
					{
						this.World.getPlayerRoster().add(this.Contract.m.Dude);
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude.onHired();
						this.Contract.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "你不适合来我们战团。",
					function getResult()
					{
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude = null;
						return 0;
					}

				}
			],
			function start()
			{
				local roster = this.World.getTemporaryRoster();
				this.Contract.m.Dude = roster.create("scripts/entity/tactical/player");
				this.Contract.m.Dude.setStartValuesEx(this.Const.CharacterVillageBackgrounds);
				this.Contract.m.Dude.getBackground().m.RawDescription = "你及时把十字架上的%name%救了下来。他发誓效忠于你，直到他的生命到达尽头，或是你取得最终的胜利。";
				this.Contract.m.Dude.getBackground().buildDescription(true);
				this.Contract.m.Dude.getSkills().removeByID("trait.disloyal");
				this.Contract.m.Dude.getSkills().add(this.new("scripts/skills/traits/loyal_trait"));
				this.Contract.m.Dude.setHitpoints(1);

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

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "CrucifiedE_AftermathBad",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_22.png[/img]解决完土匪后，你去查看那个十字架上的人是否还活着。他已经断气了。这人身上没什么值得拿的东西，你搜刮完土匪就领着%companyname%重新上路。",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "安息吧。",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "CrucifiedF",
			Title = "在路上……",
			Text = "[img]gfx/ui/events/event_02.png[/img]你决定静观其变。那个垂死之人继续在痛苦中煎熬。他的呻吟声渐渐微弱——这对耳朵倒是好事，却让弟兄们心里更不是滋味。过了一会儿，%randombrother%过来提议战团现在可以下山了。毕竟这时候还藏着埋伏的可能性已经微乎其微。你带着战团小跑下山来到十字架前。那人下巴耷拉在胸前，半睁的双眼毫无神采，混着血丝的唾沫正从嘴角滴落。他身上没搜出什么值钱物件，于是你下令%companyname%继续赶路。",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "安息吧。",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-1);
						return 0;
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().isOffendedByViolence() && !bro.getBackground().isCombatBackground())
					{
						bro.worsenMood(0.5, "你任由一个被钉在十字架上的人缓慢死去。");

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
			ID = "Success1",
			Title = "%location1%里……",
			Text = "[img]gfx/ui/events/event_45.png[/img]{抵达%location1%后，你让队员们休息片刻。趁此机会清点物资确保一切就绪。很快你就带着战团重新开拔。 | 在巡逻首站%location1%停驻后，你让队员们休整片刻。前路尚长，你认为这正是补充补给的好时机。 | 首段巡逻任务已完成。现在必须赶往下一站。你把情况告诉大家，队员们一片哀嚎。你又补充说不是雇他们来抱怨的——结果换来更响的哀嚎。 | 到达首个巡逻点后，你下令休整一会，自己则清点物资。巡逻才完成了三分之一。你在考虑再次出发前是否该补充些装备。 | 你们平安抵达%location1%，基本全员无恙。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "我们继续前进。",
					function getResult()
					{
						this.Contract.setState("Location2");
						return 0;
					}

				}
			],
			function start()
			{
				if (this.Math.rand(1, 100) <= 33)
				{
					this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/safe_roads_situation"), 2, this.Contract.m.Location1, this.List);
				}
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "%location2%里……",
			Text = "[img]gfx/ui/events/event_45.png[/img]{%location2%的位置和描述一致。你让队员们去休整，自己则规划最后一段巡逻路线。 | 巡逻队抵达%location2%，当地人对佣兵照例报以嘟囔和猜疑。接下来还有段路要走，或许在此地补充物资是个好主意。 | 队员们涌进%location2%的酒馆各处。你清点着物资，琢磨是否该购买补给。瞥见酒馆昏暗的灯光时，你又觉得喝一杯也无妨。 | 抵达%location2%后，%randombrother%建议战团应该为返回%employer%的行程补充物资。你早有此意，但还是让这个佣兵享受自己想到主意的满足感。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "我们继续前进。",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				if (this.Math.rand(1, 100) <= 33)
				{
					this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/safe_roads_situation"), 2, this.Contract.m.Location2, this.List);
				}
			}

		});
		this.m.Screens.push({
			ID = "Success3",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_45.png[/img]{你回到%employer%那里。他正在数克朗，但在付钱前先问你这趟收获了多少\"脑袋\"。你汇报消灭了%killcount%个敌人后，他抿嘴点头。%SPEECH_ON%还算不错。%SPEECH_OFF%随即把若干克朗倒进钱袋递给你。 | 回到%employer%处，你发现他深陷在一张巨椅中，仿佛需要整个空间来承载他的贵族气派、奢华做派与傲慢姿态。\n\n你上前一步，跟他说明巡逻的路上杀了 %killcount%你汇报巡逻情况，着重强调沿途消灭了%killcount%个敌人——毕竟这是计酬标准。%employer%点头示意，让手下把克朗装进钱袋交给你。 | %employer%倚窗而立，品着葡萄酒，目光似乎黏在楼下花园劳作的几个女人身上。他头也不回地问你途中宰了多少。%SPEECH_ON%%killcount%个。%SPEECH_OFF%贵族轻笑一声。%SPEECH_ON%你说得倒轻巧。%SPEECH_OFF%依旧目不斜视地打了个响指。侍从应声呈上钱袋。你接过酬金，转身离去。 | %employer%边批阅卷宗边迎你进门，好奇地问你巡逻时攒了多少战绩。你汇报%killcount%个后，他哼了声在纸上略作记录，随即踢开身旁木箱，将克朗舀进钱袋递来，接着让你走人，全程头也不抬。 | %employer%宅邸正在举办宴会。你穿过醉醺醺的奢华人群找到他。他在喧嚣乐声中吼着问你巡逻时宰了多少人。诡异的是，你高喊%killcount%的战绩竟未引起任何宾客侧目。%employer%耸耸肩转身没入人群。你正要追赶，却被一人拦住，他将钱袋重重拍在你胸前：%SPEECH_ON%你的报酬，佣兵。现在请自觉离开——宾客们开始注意到你了，他们来这儿可不是为了找不自在。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "今天走的路够多了。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.Assets.addMoney(this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected"));
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "巡逻领地");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				local money = this.Contract.m.Payment.getOnCompletion() + this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected");
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color]克朗"
				});

				if (this.Math.rand(1, 100) <= 33)
				{
					this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/safe_roads_situation"), 2, this.Contract.m.Home, this.List);
				}
			}

		});
		this.m.Screens.push({
			ID = "Success4",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_45.png[/img]{你空着手回到了%employer%那里。他不断地打量着你，特意找了找那些本该带回来的头颅。%SPEECH_ON%真的？一点麻烦都没遇到？%SPEECH_OFF%你纹丝不动。他抿嘴耸肩。%SPEECH_ON%见鬼，好吧……%SPEECH_OFF%看着你时他差点被自己的笑声呛到。%SPEECH_ON%有意思，大概吧。%SPEECH_OFF% | %employer%上下打量着你。%SPEECH_ON%脑袋在哪儿呢，佣兵？总不会忘了收集吧……？%SPEECH_OFF%你解释巡逻时没遇到任何敌人。他挑起眉毛。%SPEECH_ON%没开玩笑？该死……好吧……再见。%SPEECH_OFF% | 你空着手回到%employer%处。他盯着你空无一物的……行囊。%SPEECH_ON%这是什么意思？说好要付钱买的脑袋在哪儿？%SPEECH_OFF%你耸耸肩解释巡逻途中太平无事。%employer%正喝着酒，听到这消息差点呛到。%SPEECH_ON%等等，真的？我是说，这倒是好事，但天杀的……真没想到。你，呃，估计也没料到吧。%SPEECH_OFF%你们面面相觑。鸟鸣声打破了寂静。他抿着酒望向窗外。%SPEECH_ON%所以……今天天气不错哈？%SPEECH_OFF%你翻了个白眼。}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "今天走的路够多了。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnVictory);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractPoor, "巡逻领地");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				if (this.Contract.m.Payment.getOnCompletion() > 0)
				{
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color]克朗"
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_45.png[/img]{你花的时间也太长了，完全超出了巡逻任务的规定期限。这合同算你搞砸了。 | %employer%派来的人送来通知，上面写明巡逻任务要求速战速决，不是让你自己悠闲散步。这合同算黄了。 | 你在干什么，想多攒几个脑袋吗？你觉得%employer%会吃这套把戏？他之所以只给你几天时间完成这任务不是没道理的。这次委托算失败了。}",
			Image = "",
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "去他的合同！",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "在执行巡逻任务时擅离职守。");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function addKillCount( _actor, _killer )
	{
		if (_killer != null && _killer.getFaction() != this.Const.Faction.Player && _killer.getFaction() != this.Const.Faction.PlayerAnimals)
		{
			return;
		}

		if (this.m.Flags.get("HeadsCollected") >= this.m.Payment.MaxCount)
		{
			return;
		}

		if (_actor.getXPValue() == 0)
		{
			return;
		}

		if (_actor.getType() == this.Const.EntityType.GoblinWolfrider || _actor.getType() == this.Const.EntityType.Wardog || _actor.getType() == this.Const.EntityType.Warhound || _actor.getType() == this.Const.EntityType.SpiderEggs || this.isKindOf(_actor, "lindwurm_tail"))
		{
			return;
		}

		if (!_actor.isAlliedWithPlayer() && !_actor.isAlliedWith(this.m.Faction) && !_actor.isResurrected())
		{
			this.m.Flags.set("HeadsCollected", this.m.Flags.get("HeadsCollected") + 1);
		}
	}

	function spawnEnemies()
	{
		if (this.m.Flags.get("HeadsCollected") >= this.m.Payment.MaxCount)
		{
			return false;
		}

		local tries = 0;
		local myTile = this.m.NextObjective.getTile();
		local tile;

		while (tries++ < 10)
		{
			local tile = this.getTileToSpawnLocation(myTile, 7, 11);

			if (tile.getDistanceTo(this.World.State.getPlayer().getTile()) <= 6)
			{
				continue;
			}

			local nearest_bandits = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getNearestSettlement(tile);
			local nearest_goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(tile);
			local nearest_orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(tile);
			local nearest_barbarians = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians) != null ? this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getNearestSettlement(tile) : null;
			local nearest_nomads = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits) != null ? this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getNearestSettlement(tile) : null;

			if (nearest_bandits == null && nearest_goblins == null && nearest_orcs == null && nearest_barbarians == null && nearest_nomads == null)
			{
				this.logInfo("没有找到敌人的基地");
				return false;
			}

			local bandits_dist = nearest_bandits != null ? nearest_bandits.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local goblins_dist = nearest_goblins != null ? nearest_goblins.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local orcs_dist = nearest_orcs != null ? nearest_orcs.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local barbarians_dist = nearest_barbarians != null ? nearest_barbarians.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local nomads_dist = nearest_nomads != null ? nearest_nomads.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local party;
			local origin;

			if (bandits_dist <= goblins_dist && bandits_dist <= orcs_dist && bandits_dist <= barbarians_dist && bandits_dist <= nomads_dist)
			{
				if (this.Math.rand(1, 100) <= 50)
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).spawnEntity(tile, "强盗", false, this.Const.World.Spawn.BanditRaiders, 110 * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
				}
				else
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).spawnEntity(tile, "强盗猎人", false, this.Const.World.Spawn.BanditRoamers, 80 * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
				}

				party.setDescription("一伙粗野凶悍的土匪，专挑弱者下手。");
				party.setFootprintType(this.Const.World.FootprintsType.Brigands);
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

				origin = nearest_bandits;
			}
			else if (goblins_dist <= bandits_dist && goblins_dist <= orcs_dist && goblins_dist <= barbarians_dist && goblins_dist <= nomads_dist)
			{
				if (this.Math.rand(1, 100) <= 50)
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).spawnEntity(tile, "地精掠袭者", false, this.Const.World.Spawn.GoblinRaiders, 110 * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
				}
				else
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).spawnEntity(tile, "地精斥候", false, this.Const.World.Spawn.GoblinScouts, 80 * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
				}

				party.setDescription("一伙狡诈的地精，身形矮小却诡计多端，不容小觑。");
				party.setFootprintType(this.Const.World.FootprintsType.Goblins);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 2);
				party.getLoot().Ammo = this.Math.rand(0, 30);

				if (this.Math.rand(1, 100) <= 75)
				{
					local loot = [
						"supplies/strange_meat_item",
						"supplies/roots_and_berries_item",
						"supplies/pickled_mushrooms_item"
					];
					party.addToInventory(loot[this.Math.rand(0, loot.len() - 1)]);
				}

				if (this.Math.rand(1, 100) <= 33)
				{
					local loot = [
						"loot/goblin_carved_ivory_iconographs_item",
						"loot/goblin_minted_coins_item",
						"loot/goblin_rank_insignia_item"
					];
					party.addToInventory(loot[this.Math.rand(0, loot.len() - 1)]);
				}

				origin = nearest_goblins;
			}
			else if (barbarians_dist <= goblins_dist && barbarians_dist <= bandits_dist && barbarians_dist <= orcs_dist && barbarians_dist <= nomads_dist)
			{
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).spawnEntity(tile, "野蛮人", false, this.Const.World.Spawn.Barbarians, 110 * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
				party.setDescription("一支野蛮人战团。");
				party.setFootprintType(this.Const.World.FootprintsType.Barbarians);
				party.getLoot().Money = this.Math.rand(0, 50);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 5);
				party.getLoot().Ammo = this.Math.rand(0, 30);

				if (this.Math.rand(1, 100) <= 50)
				{
					party.addToInventory("loot/bone_figurines_item");
				}

				if (this.Math.rand(1, 100) <= 50)
				{
					party.addToInventory("loot/bead_necklace_item");
				}

				local r = this.Math.rand(2, 5);

				if (r == 2)
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

				origin = nearest_barbarians;
			}
			else if (nomads_dist <= barbarians_dist && nomads_dist <= goblins_dist && nomads_dist <= bandits_dist && nomads_dist <= orcs_dist)
			{
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).spawnEntity(tile, "游牧民", false, this.Const.World.Spawn.NomadRaiders, 110 * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
				party.setDescription("一群沙漠掠袭者，狩猎任何试图穿越沙海的人。");
				party.setFootprintType(this.Const.World.FootprintsType.Nomads);
				party.getLoot().Money = this.Math.rand(50, 200);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 2);
				party.getLoot().Ammo = this.Math.rand(0, 20);
				local r = this.Math.rand(1, 4);

				if (r == 1)
				{
					party.addToInventory("supplies/bread_item");
				}
				else if (r == 2)
				{
					party.addToInventory("supplies/dates_item");
				}
				else if (r == 3)
				{
					party.addToInventory("supplies/rice_item");
				}
				else if (r == 4)
				{
					party.addToInventory("supplies/dried_lamb_item");
				}

				origin = nearest_nomads;
			}
			else
			{
				if (this.Math.rand(1, 100) <= 50)
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).spawnEntity(tile, "兽人掳掠者", false, this.Const.World.Spawn.OrcRaiders, 110 * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
				}
				else
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).spawnEntity(tile, "兽人斥候", false, this.Const.World.Spawn.OrcScouts, 80 * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
				}

				party.setDescription("一群凶狠的兽人，绿皮肤、个头比任何人类都高。");
				party.setFootprintType(this.Const.World.FootprintsType.Orcs);
				party.getLoot().ArmorParts = this.Math.rand(0, 25);
				party.getLoot().Ammo = this.Math.rand(0, 10);
				party.addToInventory("supplies/strange_meat_item");
				origin = nearest_orcs;
			}

			party.getSprite("banner").setBrush(origin.getBanner());
			party.setAttackableByAI(false);
			party.setAlwaysAttackPlayer(true);
			local c = party.getController();
			local intercept = this.new("scripts/ai/world/orders/intercept_order");
			intercept.setTarget(this.World.State.getPlayer());
			c.addOrder(intercept);
			this.m.UnitsSpawned.push(party.getID());
			return true;
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"location1",
			this.m.Location1.getName()
		]);
		_vars.push([
			"location2",
			this.m.Location2.getName()
		]);
		_vars.push([
			"killcount",
			this.m.Flags.get("HeadsCollected")
		]);
		_vars.push([
			"noblehousename",
			this.World.FactionManager.getFaction(this.m.Faction).getNameOnly()
		]);
		_vars.push([
			"days",
			5 - (this.World.getTime().Days - this.m.Flags.get("StartDay"))
		]);
		_vars.push([
			"crucifiedman",
			this.m.Dude != null ? this.m.Dude.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Location1 != null)
			{
				this.m.Location1.getSprite("selection").Visible = false;
			}

			if (this.m.Location2 != null)
			{
				this.m.Location2.getSprite("selection").Visible = false;
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (this.m.IsStarted)
		{
			if (this.m.Location1 == null || this.m.Location1.isNull() || !this.m.Location1.isAlive())
			{
				return false;
			}

			if (this.m.Location2 == null || this.m.Location2.isNull() || !this.m.Location2.isAlive())
			{
				return false;
			}

			return true;
		}
		else
		{
			if (this.World.FactionManager.getFaction(this.m.Faction).getSettlements().len() < 3)
			{
				return false;
			}

			return true;
		}
	}

	function onIsTileUsed( _tile )
	{
		if (this.m.Location1 != null && !this.m.Location1.isNull() && _tile.ID == this.m.Location1.getTile().ID)
		{
			return true;
		}

		if (this.m.Location2 != null && !this.m.Location2.isNull() && _tile.ID == this.m.Location2.getTile().ID)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		if (this.m.Location1 != null)
		{
			_out.writeU32(this.m.Location1.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		if (this.m.Location2 != null)
		{
			_out.writeU32(this.m.Location2.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local location1 = _in.readU32();

		if (location1 != 0)
		{
			this.m.Location1 = this.WeakTableRef(this.World.getEntityByID(location1));
		}

		local location2 = _in.readU32();

		if (location2 != 0)
		{
			this.m.Location2 = this.WeakTableRef(this.World.getEntityByID(location2));
		}

		this.contract.onDeserialize(_in);
	}

});
