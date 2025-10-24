this.investigate_cemetery_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		TreasureLocation = null,
		SituationID = 0
	},
	function setDestination( _d )
	{
		this.m.Destination = this.WeakTableRef(_d);
	}

	function create()
	{
		this.contract.create();
		this.m.Type = "contract.investigate_cemetery";
		this.m.Name = "清除墓地里的威胁";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		if (this.m.Destination == null || this.m.Destination.isNull())
		{
			local myTile = this.World.State.getPlayer().getTile();
			local undead = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getSettlements();
			local lowestDistance = 9999;
			local best;

			foreach( b in undead )
			{
				local d = myTile.getDistanceTo(b.getTile());

				if (d < lowestDistance && (b.getTypeID() == "location.undead_graveyard" || b.getTypeID() == "location.undead_crypt"))
				{
					lowestDistance = d;
					best = b;
				}
			}

			this.m.Destination = this.WeakTableRef(best);
		}

		this.m.Flags.set("DestinationName", this.m.Destination.getName());
		this.m.Payment.Pool = 550 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					function ()
					{
						return this.RenderTemplate("清理%s的威胁", this.Flags.get("DestinationName"));
					}()
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
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				this.Contract.m.Destination.clearTroops();
				this.Contract.m.Destination.setLastSpawnTimeToNow();

				if (this.Contract.getDifficultyMult() < 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.m.Destination.setLootScaleBasedOnResources(100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 60 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				local r = this.Math.rand(1, 100);

				if (r <= 10 && this.World.Assets.getBusinessReputation() > 500)
				{
					this.Flags.set("IsMysteriousMap", true);
					this.logInfo("地图");
					local bandits = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits);
					this.World.FactionManager.getFaction(this.Contract.m.Destination.getFaction()).removeSettlement(this.Contract.m.Destination);
					this.Contract.m.Destination.setFaction(bandits.getID());
					bandits.addSettlement(this.Contract.m.Destination.get(), false);
					this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.BanditRaiders, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				}
				else if (r <= 40)
				{
					this.logInfo("食尸鬼");
					this.Flags.set("IsGhouls", true);
					this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.Ghouls, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				}
				else if (r <= 70)
				{
					this.Flags.set("IsGraverobbers", true);
					this.logInfo("盗墓贼");
					local bandits = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits);
					this.World.FactionManager.getFaction(this.Contract.m.Destination.getFaction()).removeSettlement(this.Contract.m.Destination);
					this.Contract.m.Destination.setFaction(bandits.getID());
					bandits.addSettlement(this.Contract.m.Destination.get(), false);
					this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.BanditRaiders, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				}
				else
				{
					this.logInfo("亡灵");
					this.Flags.set("IsUndead", true);
					this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.Zombies, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
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
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsUndead") && this.World.Assets.getBusinessReputation() > 500 && this.Math.rand(1, 100) <= 25 * this.Contract.m.DifficultyMult)
					{
						this.Flags.set("IsNecromancer", true);
						this.Contract.setScreen("Necromancer0");
						this.World.Contracts.showActiveContract();
					}

					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (!this.Flags.get("IsAttackDialogShown"))
				{
					this.Flags.set("IsAttackDialogShown", true);

					if (this.Flags.get("IsGhouls"))
					{
						this.Contract.setScreen("AttackGhouls");
					}
					else if (this.Flags.get("IsGraverobbers"))
					{
						this.Contract.setScreen("AttackGraverobbers");
					}
					else if (this.Flags.get("IsUndead"))
					{
						this.Contract.setScreen("AttackUndead");
					}
					else if (this.Flags.get("IsMysteriousMap"))
					{
						this.Contract.setScreen("MysteriousMap1");
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog();
				}
			}

		});
		this.m.States.push({
			ID = "Running_Necromancer",
			function start()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}

				this.Contract.m.BulletpointsObjectives = [
					"摧毁 " + this.Flags.get("DestinationName")
				];
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					this.Contract.setScreen("Necromancer3");
					this.World.Contracts.showActiveContract();
					this.Flags.set("IsNecromancerDead", true);
					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (!this.Flags.get("IsAttackDialogShown"))
				{
					this.Flags.set("IsAttackDialogShown", true);
					this.Contract.setScreen("Necromancer2");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog();
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
					if (this.Flags.get("IsNecromancer"))
					{
						if (this.Flags.get("IsNecromancerDead"))
						{
							this.Contract.setScreen("Success3");
						}
						else
						{
							this.Contract.setScreen("Necromancer1");
						}
					}
					else if (this.Flags.get("IsUndead"))
					{
						this.Contract.setScreen("Success1");
					}
					else if (this.Flags.get("IsMysteriousMapAccepted"))
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							this.Contract.setScreen("Failure1");
						}
						else
						{
							this.Contract.setScreen("Failure2");
						}
					}
					else
					{
						this.Contract.setScreen("Success2");
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer%焦躁地来回踱步，不时停下来对你说话。%SPEECH_ON%乡亲们乱成一团了！墓地的坟冢被发现遭人撬开和劫掠。有些蠢货声称是死人从坟墓里爬出来了——纯粹是迷信的胡说八道。很明显，是些胆大包天的盗墓贼来到了%townname%，用他们的贪婪折磨我们！%SPEECH_OFF%他愤怒地一拳砸在桌子上。%SPEECH_ON%去墓地那里，把这场祸害彻底解决掉！%SPEECH_OFF% | %employer%一边自顾自地笑着一边坐进他的椅子。%SPEECH_ON%别惊慌，佣兵，但他们说有鬼魂在作祟！是啊，是啊，本地农民每天早上都来说鬼怪和地精的事情，让我没个清净。他们说这些妖怪把墓地搅得天翻地覆，抢劫坟墓以扩充它们的军队之类的胡话。很明显，这只是一些手拿铁锹、意图盗取珠宝的家伙干的。我以前见过。%SPEECH_OFF%他低头看着自己的手，短暂地笑了笑。%SPEECH_ON%总之，我不能就这么放着不管，因为这些农民会不停地烦我。所以，为了安抚他们，你……派上用场了。我需要你去墓地，处理掉你找到的任何捣蛋鬼。具体怎么做由你决定，但我得先建议你带些结实的家伙，明白我的意思不……%SPEECH_OFF% | %employer%的桌上放着一张墓地地图。一半的墓地块似乎都被用墨水填满了。%SPEECH_ON%你看到的每一个方块都代表着它被刨了。他们每晚都来，而我每次都抓不到他们。我已经无计可施了，所以我决定彻底了结这件事。我要你去那个墓地，杀死你看到的每一个盗墓的蠢货。明白吗？%SPEECH_OFF% | %employer%站在窗边，一边小口喝着蜂蜜酒一边向外凝视。他似乎并没有真正在看什么特定的事物，甚至说话的语气仿佛对这场谈话毫不在乎。%SPEECH_ON%盗墓贼在洗劫墓地。又来了。我对你要求不高，佣兵，无非是去那里终结这蠢勾当。去那个墓地，杀死你看到的每一个盗墓贼。明白？很好。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "谈谈价钱吧。",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "不感兴趣。",
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
			ID = "AttackGhouls",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_69.png[/img]{嘎吱。吧唧。这是某个东西——或者说某个存在——正在享受美餐的咀嚼声。当你穿过墓地时，你撞见了一群食尸鬼，它们在一处空地上围成一团。中间正是你要找的那些盗墓贼的遗骸。这些丑陋的怪物缓缓转向你，红色的眼睛因看到新鲜血肉而瞪得更大。 | 一群食尸鬼在墓地中不停攀爬翻越，压倒了一座又一座的墓碑。它们显然刚进行了一场盛宴，其中几只仍在啃咬着某只手臂或某条腿——想必就是那些盗墓贼的肢体。 | 你听到一声尖利的惨叫，迅速转过陵墓的拐角，看见一个食尸鬼正将牙齿刺入一名男子的后颈。那野兽满嘴是血，甚至从鼻孔中涌出，只是抬眼瞥了你一下。较小的食尸鬼们围在四周，步步逼近，确保它们的下一餐不会溜走……}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "AttackGraverobbers",
			Title = "在靠近时……",
			Text = "[img]gfx/ui/events/event_57.png[/img]{盗墓贼们就在这，跟说好的一样。你抓了他们个正着，你的兄弟们拔出武器跃过墓碑。 | 走进墓地，你发现了盗墓贼们，正如%employer%所预料到的那般。他们同时也发现了你。你的手下展开队形，拔出武器以阻止任何人逃离。 | 随着你走过片片墓碑，几声细语从一处陵墓的另一头传来。当你走过转角，你发现一群人正站在一座被挖空的坟墓边。他们面前有一具打开的棺材，几人正从中拿出珠宝。你命令你的人冲锋。 | %employer%说的没错：这里确实有盗墓贼在。你发现了一些翻倒的墓碑和被挖开的坟墓。泥泞的痕迹引导你找到了那些正在忙新活的挖掘者。%SPEECH_ON%不是故意要组织你们，但%employer%付了个好价钱来确保这些人呆在地里。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "AttackUndead",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_57.png[/img]{墓园笼罩在浓雾中——或者说，是亡者散发出的浓重瘴气。等等……亡者就在其中往你走来！准备战斗！ | 你注意到一块墓碑，基座处的泥土被翻掘开来。泥点像面包屑般一路延伸。没有铁锹……没有人影……顺着痕迹追踪，你遇到了一群呻吟低语的活死人……此刻正用永不满足的饥渴眼神盯着你…… | 一个人影在墓碑丛深处徘徊。他身形摇晃，仿佛随时会倒下。%randombrother%来到你身边摇了摇头。%SPEECH_ON%那可不是活人，长官。有亡灵在活动。%SPEECH_OFF%他话音刚落，远处的那个陌生人缓缓转身，露出空空荡荡的另外半边脸。 | 你发现许多墓穴都已空空如也。不是被挖开，而是从内部被掘开。这绝非盗墓贼所为……}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "MysteriousMap1",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_57.png[/img]{你进入墓地，发现盗墓者正如%employer%所说：深陷在他人的死后世界中。你拔出剑，命令他们放下任何自认为可以偷走的珠宝。其中一人举起双手站起来，试图说明情况。%SPEECH_ON%在你杀掉我们之前，我能说几句吗？我们有张地图……我知道，这像是在骗人，但请听我说完……我们有张指向大量财宝的地图。你放我们走，我就把它给你。要是杀了我们……那你永远也见不到它了。怎么说？%SPEECH_OFF% | 正如%employer%所料，确实有盗墓贼在墓碑间蹑手蹑脚地活动。你在他们挖到一半的时候拦住他们，并问他们在与自己手下的受害者一同归于泥土之前，是否还有什么遗言。其中一个人乞求饶恕，说自己有一张藏宝图，愿意以此换取他们所有人的性命。 | 你撞见了几个正试图撬开陵墓大门的人。你用剑敲了敲靴子，引起他们的注意。%SPEECH_ON%晚上好先生们。%employer%派我来的。%SPEECH_OFF%其中一人丢下了工具。%SPEECH_ON%等一下！我们有一张地图……对，一张地图！如果你放过我们，我就把它给你！但你得放过我们！如果你不答应……你永远也别想看到那张地图，明白？%SPEECH_OFF% | 你打了盗墓贼们一个措手不及，在他们还在铲土的时候拔剑相向。其中一人，大概是意识到自己即将踏入他早已一脚踩进的坟墓，试图与你做个交易。这些人有一张指向神秘宝藏的地图。你只需要放他们走就能获得它。如果你杀了他们，由于“地图”被藏在别的地方，你将永远也见不到它，也见不到它所指向的宝藏。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "杀光他们！",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				},
				{
					Text = "很好，交出地图你们就可以活着离开这个地方。",
					function getResult()
					{
						this.updateAchievement("NeverTrustAMercenary", 1, 1);
						local tile = this.Contract.getTileToSpawnLocation(this.World.State.getPlayer().getTile(), 8, 18, [
							this.Const.World.TerrainType.Shore,
							this.Const.World.TerrainType.Ocean,
							this.Const.World.TerrainType.Mountains
						], false);
						tile.clear();
						this.Contract.m.TreasureLocation = this.WeakTableRef(this.World.spawnLocation("scripts/entity/world/locations/undead_ruins_location", tile.Coords));
						this.Contract.m.TreasureLocation.onSpawned();
						this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).addSettlement(this.Contract.m.TreasureLocation.get(), false);
						this.Contract.m.TreasureLocation.addToInventory("loot/silverware_item");
						this.Contract.m.TreasureLocation.addToInventory("loot/silver_bowl_item");
						return "MysteriousMap2";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "MysteriousMap2",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_57.png[/img]{也许%employer%只是想除掉那些寻找宝藏的人？这……那说得通，对吧？你决定放这些人走，以换取一张地图，上面标示了从这里前往%treasure_location%的路径，就在%treasure_direction%边。 | %employer%可没提过这些人有张地图……也许他是想抹除这个信息？谁知道呢。但宝藏的诱惑对你来说太大了，你决定放这些人走以换取情报。他们的地图揭示了%treasure_location%的位置。它就在你此刻所处位置的%treasure_direction%方。 | 当你还是个孩子时，你经常去寻宝。那感觉……出奇地刺激。不知为何，重温那段旧日冒险的诱惑让你选择了放这些人走。作为回报，他们给你看了地图，上面标出了%treasure_location%——藏有……谁知道是什么呢？你真正清楚的只有它正位于你此刻所处位置的%treasure_direction%方。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "这最好值得。",
					function getResult()
					{
						this.World.uncoverFogOfWar(this.Contract.m.TreasureLocation.getTile().Pos, 700.0);
						this.Contract.m.TreasureLocation.setDiscovered(true);
						this.World.getCamera().moveTo(this.Contract.m.TreasureLocation.get());
						this.Contract.m.Destination.fadeOutAndDie();
						this.Contract.m.Destination = null;
						this.Flags.set("IsMysteriousMapAccepted", true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Necromancer0",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_56.png[/img]{消灭了全部的亡灵后，你找到一片泛着紫光的布。 你不确定它是什么东西，但不知怎么想要留着它。%randombrother%认为这很蠢，但他说了不算。 | 战斗结束后，%randombrother%找到一个铲头，上面烙着一个符号。他在想，也许你的雇主%employer%会对此有所了解。你表示同意，带着这片金属去找那位当地人，看他能否辨认。 | 将这些怪物斩杀殆尽后，你收剑入鞘，仔细搜寻战场。在搜索中，你找到了一个由乌鸦羽毛和牛皮制成的古怪护身符。你把它收进口袋，心想你的雇主%employer%或许会知道些什么。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "是时候领工钱了。",
					function getResult()
					{
						this.Flags.set("DestinationName", this.World.EntityManager.getUniqueLocationName(this.Const.World.LocationNames.NecromancerLair));
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Necromancer1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_63.png[/img]{回到%employer%那里后，你迅速说明墓地里没有盗墓贼，只有一群活死人。他显得很震惊，但当你拿出找到的物件时，他抿紧嘴唇郑重地点了点头。%SPEECH_ON%这是……%necromancer_location%的东西。我们本以为可以无视那个地方，看来我错了。去那里吧，佣兵，彻底终结那个恐怖巢穴的威胁！%SPEECH_OFF%他稍稍收敛了夸张的语气。%SPEECH_ON%对了，除了原任务的%reward_completion%克朗，我会再付你%reward_completion%克朗。%SPEECH_OFF% | 你在书房找到%employer%，他正严肃地小口喝着酒。%SPEECH_ON%我已经听到消息了。死者重返人间，哦，光说出来就够吓人的！%SPEECH_OFF%你点头拿出在墓地找到的物件。%SPEECH_ON%你认识这个吗？%SPEECH_OFF%他瞥了一眼，仿佛早就知道在你手里。%SPEECH_ON%没错，那是%necromancer_location%的东西。我们本以为可以无视那里传来的恐怖，但是……你看。也许你能去那里？也许你能摧毁%necromancer_location%，把我们从它的恐怖中解救出来？这是原定的报酬，但如果你帮我们解决%necromancer_location%，你会再得到%reward_completion%克朗。你觉得如何？%SPEECH_OFF% | 你走进%employer%的房间，把那物件重重摔在他桌上。他用手把它扫开。%SPEECH_ON%你从哪儿弄来的？%SPEECH_OFF%你指着它逼问。%SPEECH_ON%你早知道墓地有亡灵？%SPEECH_OFF%他心虚地别开视线，然后点头。%SPEECH_ON%是的……我知道。它们，还有那东西，都来自%necromancer_location%。某种黑魔法师住在那里，他给我们制造这些……麻烦已经有一阵子了。求你了，你能去那里摧毁它吗？这是原合同的报酬，但如果你帮我们除掉那个该死的……不管他是什么，你会得到丰厚补偿。比如说……再加%reward_completion%克朗？%SPEECH_OFF% | 你向%employer%解释墓地没有盗墓贼，也根本没有活人。在他开口前，你拿出那个物件，举到光线下让他看清。他迅速后退。%SPEECH_ON%放下它！%SPEECH_OFF%他的吼叫点燃了那物件，后者在你的指尖燃尽，而你没有丝毫疼痛的感觉，只看到灰尘从手中盘旋而下。%employer%双手抱头。%SPEECH_ON%它来自%necromancer_location%。一个……死灵法师住在那儿，他是个操纵死者的傀儡师。 求你了，佣兵，去那里摧毁它。我们会无比感激……%SPEECH_OFF%他停顿片刻，拿出一个钱袋。%SPEECH_ON%这是原定的报酬。但如果你杀死%necromancer_location%那个可怕的人，回来时还会有%reward_completion%克朗等着你。%SPEECH_OFF% | 你出示在墓地找到的物件。%employer%一看到它就倒抽一口气，但很快便调整好自己，阴沉着脸跟你说道。%SPEECH_ON%实话跟你说吧，佣兵。有个死灵法师住在离这不远的%necromancer_location%。%SPEECH_OFF%他取出一个钱袋递给你。%SPEECH_ON%这是原任务的报酬。但如果你现在就去杀死那个邪恶之徒，我愿意再出%reward_completion%克朗，这已是我们能凑出的全部了。%SPEECH_OFF%他向后靠去，满心期望你会接受这些新条件。}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "行吧，我们会去解决掉那个死灵法师。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "清除了墓地里的威胁");
						local tile = this.Contract.getTileToSpawnLocation(this.World.State.getPlayer().getTile(), 8, 15, [
							this.Const.World.TerrainType.Shore,
							this.Const.World.TerrainType.Ocean,
							this.Const.World.TerrainType.Mountains
						], false);
						tile.clear();
						this.Contract.m.Destination = this.WeakTableRef(this.World.spawnLocation("scripts/entity/world/locations/undead_necromancers_lair_location", tile.Coords));
						this.Contract.m.Destination.onSpawned();
						this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).addSettlement(this.Contract.m.Destination.get(), false);
						this.Contract.m.Destination.setName(this.Flags.get("DestinationName"));
						this.Contract.m.Destination.setDiscovered(true);
						this.Contract.m.Destination.clearTroops();
						this.Contract.m.Destination.setLootScaleBasedOnResources(115 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.Necromancer, 115 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());

						if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
						{
							this.Contract.m.Destination.getLoot().clear();
						}

						this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
						this.Contract.m.Home.getSprite("selection").Visible = false;
						this.Flags.set("IsAttackDialogShown", false);
						this.Contract.setState("Running_Necromancer");
						return 0;
					}

				},
				{
					Text = "不行，战团在这里已经做得够多了。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "清除了墓地里的威胁");
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
			ID = "Necromancer2",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_57.png[/img]{此地的景象正如你所想的那般令人毛骨悚然，充斥着无可饶恕的亵渎，堪称腐烂不堪的极致。你尚未发现死灵法师的踪迹，最好万分谨慎地前进…… | 你发现一条由骸骨铺成的小径指引着方向。有些骨头上还挂着鲜肉，或许是死灵法术失败的半成品，未能完全从死亡重回现实。无视这些恐怖景象，你开始策划进攻方案…… | 像%necromancer_location%这样的地方，荒草丛生，杂草遍布，黑黢黢的树木林立，本无需任何\"禁止入内\"的标牌。但它偏偏就有。那是一个由骸骨拼成的谜题——一具由各种人兽骨骼拼凑而成的恐怖造物，高悬在十字架上，用它空洞的眼窝瞪视着，以震慑任何胆敢靠近的冒险者。蛞蝓在它的眼窝中爬行，兵蚁组成的动脉沿其肢体脉动。\n\n%randombrother%走上前来，眼前的景象让他略显不安，他询问你打算如何进攻。 | 一开始映入眼帘的是一只老鼠，四肢大张，每一只小爪子都被钉子固定在木板上。接着是一条狗，它的头颅被换成了猫头。你发誓这怪物在你靠近时动了，但也许只是眼花了。然后……是那些人。你找不到任何词语能描述他们的遭遇，那是一座由血肉堆砌的骇人奇观，是暴行的巅峰。\n\n%randombrother%走到你身边。%SPEECH_ON%咱们去结果了这个疯子。%SPEECH_OFF%没错。问题在于，如何发起攻击？}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "准备进攻。",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Necromancer3",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_56.png[/img]{%necromancer_location%已被肃清。你几乎觉得自己干了一件神圣的事，但随即想起你做这一切是为了报酬，而不是为了什么正义事业。反正你也从不喜欢后者。 | 死灵法师已死，你手里提着他的头颅。现在该去告诉%employer%那家伙这个好消息，让他付清你应得的报酬。 | 这场战斗并不轻松，但%necromancer_location%已被摧毁。死灵法师死了，和任何人一样，成了一坨倒在地上的烂肉。奇怪的是他的巫术能唤起死者，自己死了却没法施法。虽然奇怪，但也不算坏事。你带上这异端的头颅，以防万一。 | 你已斩杀死灵法师，但担心他的把戏能在死后继续，于是砍下他的脑袋塞进布袋。你的雇主%employer%见到这个应该会很高兴。 | 战斗结束，你挥剑斩向死灵法师的脖颈，将他的头颅从肩上卸下。它脱落得几乎过于轻易，仿佛本就渴望被你掌控。无论如何，你的雇主%employer%会想亲眼见到它，作为你在此地作为的证明。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "该去领这颗脑袋的赏金了。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{当你回来时，%employer%在狡黠地笑着。%SPEECH_ON%麻烦活，不是吗？我已经听说了消息 —— 它在这片地方传的很快。遗憾的是我们只能这样做，但谁知道否则你会为对付这些……东西收取多少费用呢。\n\n嗨……你还是拿得到报酬的。%SPEECH_OFF%他指着角落里的一个木箱。%SPEECH_ON%%reward_completion%克朗都在那里面，跟我们说好的一样。%SPEECH_OFF% | %employer%听完了你的报告然后缓慢倚回他的椅子。%SPEECH_ON%关于这些……东西之前是有很多流言。死人走来走去？%SPEECH_OFF%他盯着桌子，然后愤怒地看向你。%SPEECH_ON%胡说八道！我不信。你会拿到我们说好的%reward_completion%克朗。你别想用你的这些……这些谎言从我这敲走更多钱！%SPEECH_OFF%你真的应该带一两个头来，但话说回来，一个死人的头和亡灵的头可能没什么区别…… | %employer%听完你关于亡灵的报告后耸耸肩。%SPEECH_ON%真可惜。%SPEECH_OFF%他若无其事地呷了一口高脚杯的边缘，然后将手伸向房间的一角。%SPEECH_ON%你的报酬在那个箱子里。%randomname%会为你们送行。%SPEECH_OFF% | %employer%合拢双手，然后将它们放在腿上。%SPEECH_ON%我听说过这些……东西。这些游荡的怪物。它们来%townname%不是什么好消息，但我想他们没有比墓地更好的去处了！不管怎么说，好过镇广场。%SPEECH_OFF%他紧张地笑着。%SPEECH_ON%%randomname%现在正带着你的报酬站在我门外。谢谢你，佣兵。%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "清除了墓地里的威胁");
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
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color]克朗"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer%将你迎进他的房间。%SPEECH_ON%你把它们都杀光了吗？那里现在安全了吗？%SPEECH_OFF%你耸耸肩。%SPEECH_ON%短期内不会有人再去挖坟了。%SPEECH_OFF% | 你看到%employer%深陷在椅子里，就着烛光阅读一份磨损严重的卷轴。他头也不抬地说道。%SPEECH_ON%我的麻烦，你解决了吗？%SPEECH_OFF%你点点头。%SPEECH_ON%要是没解决，我就不会站在这儿了。%SPEECH_OFF%%employer%指向他桌子的角落。%SPEECH_ON%你的报酬。%reward_completion%克朗，跟说好的一样。%SPEECH_OFF% | 你回到%employer%的房间时，他正在和几个手下谈话。他分开他们，向你询问任务情况。你汇报说现在可以安全地安葬%townname%的逝者了。%employer%笑了。%SPEECH_ON%好。很好。你的报酬。%SPEECH_OFF%他打了个响指，其中一个手下走上前，递给你一个钱袋。里面装着%reward_completion%克朗，如约兑现。}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "清除了墓地里的威胁");
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success3",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{你带着死灵法师的头颅回到%employer%那里。 对于一颗人头而言，它轻得令人难以置信。%SPEECH_ON%就是这鬼东西用亡灵翻搅我们的坟墓吗？%SPEECH_OFF%你点点头，将头颅放下。后者抽了口气，%employer%吓得跳开。%SPEECH_ON%他还活着！%SPEECH_OFF%你耸耸肩，用匕首刺穿了它的脑壳。死灵法师的眼睛向上翻向刀柄，牙齿因发笑而打颤，随后双眼缩回眼窝，一缕淡淡的红烟盘旋而出，接着便再无动静。%employer%颤抖着坐了回去，示意角落里的一个钱袋。那是你的报酬，相当沉重。 | 你走进%employer%的书房时他正坐着，但一看到你手中摇晃的死灵法师头颅，他立刻站起来向后退去。%SPEECH_ON%我、我想就是……是他？ 对吧？结束了？%SPEECH_OFF%你点点头，把头扔到那人的桌子上。头颅咕噜噜地滚动，最后脸上因凝住的笑容而突出的颧骨卡住了脑袋。%employer%用一本书把它推开。%SPEECH_ON%好。太好了！说好的，你的报酬……%SPEECH_OFF%他指向一个角落，那里放着一个 {木箱 | 大袋子}。 你拿上它，数了数，然后告别。 | %employer%从阅读中抬头。%SPEECH_ON%诸神在上，你手里拿的是那死灵法师的头吗？%SPEECH_OFF%你点点头，把它扔到地上。一只猫从它栖身的书架上溜下来，用爪子拨弄着头颅。%employer%站起身，从书架上取下几本书，露出一个大盒子。他拿起盒子递给你。%SPEECH_ON%我留着这盒东西，就是为了这种时候派上用场。%SPEECH_OFF%你以为会是个什么物件，也许是个护身符或其他神秘的东西，结果却只是一大堆克朗。 | 回到%employer%那里时，你手里攥着死灵法师的头，那人马上示意你递过去。你毫无顾虑地照做了……\n\n%employer%用双手捧着它，像研究一个生病的婴儿般端详着它。 片刻之后，他走向一柄断裂的三叉戟，把头颅插在其中一个尖齿上。%SPEECH_ON%我觉得它摆在那挺好看的。 你也这么觉得，不是吗？%SPEECH_OFF%他用大拇指按在死灵法师苍白的下巴上。你清清嗓子问起报酬，%employer%示意一名卫兵进来。你接过一钱袋数了数，里面有%reward_completion%克朗。心满意足的你离开了%employer%，好让他继续……忙活他手头上的事情。}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractPoor, "清除了墓地里的威胁");
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
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color]克朗"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_63.png[/img]{你进去时，%employer%正站在窗边。%SPEECH_ON%鸟儿们的歌声今天听起来有些生气。好像他们要说的东西毫无意义。我觉得这很有趣。你呢？%SPEECH_OFF%他突然转向你。%SPEECH_ON%嗯，雇佣兵？不觉得吗？我的小鸟们告诉我，那些盗墓贼离开了。活着。想去哪儿就去哪儿，想回来就回来。真是怪事，因为死人通常哪儿都去不了。我之前让你怎么解决这些盗墓贼的？%SPEECH_OFF%你犹豫了。他替你回答道。%SPEECH_ON%我让你杀掉他们。现在他们没死。所以你就拿不到报酬。啊，真简单。接下来呢？接下来你给我滚出我的房子。%SPEECH_OFF% | 你走进他的房间时，%employer%大笑起来。%SPEECH_ON%说实话，我很惊讶你居然回来了。我觉得这是种侮辱，真的，你竟然以为我不会知道。有人在路上看见了那些盗墓贼。那些我让你去杀的盗墓贼。还记得吗？记得我说的去干掉他们吗？我确定你记得。我同样确定你记得那时我请你来就是干这件事。所以……没有杀人……%SPEECH_OFF%他一拳砸在桌子上。%SPEECH_ON%就没有报酬！现在滚出我的家！%SPEECH_OFF% | 你看见%employer%坐在椅子里，双手转动着一个空酒杯。%SPEECH_ON%我可不常碰到想糊弄我的人。你回来就是想这么干，对吧？我知道那些盗墓贼没死，佣兵。我不是傻瓜。在我让我的人把你剁碎之前，从我的视线里消失。%SPEECH_OFF% | 你进入他房间时，%employer%正在看书。%SPEECH_ON%你有十秒钟时间转身离开。十、九、八……%SPEECH_OFF%你意识到他知道盗墓贼没有被解决掉。%SPEECH_ON%……四……三……%SPEECH_OFF%你转身匆忙离开了房间。}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "该死的！",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Assets.addMoralReputation(-1);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationAttacked);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Failure2",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_63.png[/img]{%employer%抿紧了嘴唇。%SPEECH_ON%你这可让我难做了，佣兵。你说盗墓贼都处理掉了，可我这儿……什么证据都没看到。死人通常都会留下不少痕迹。尤其是那些突然横死的。%SPEECH_OFF%他耸了耸肩。%SPEECH_ON%报酬我给你一半。拿着钱就走人。下次，带着证据来。要是你说谎……哼，我自有办法查证。%SPEECH_OFF% | 你回来时发现%employer%正在打理他的花园。%SPEECH_ON%有时候我明明种的是这种菜，长出来的却完全是另一种。这怎么回事？是我自己搞错了？还是你想糊弄我？你说盗墓贼都死了，但我的人去墓地查过，没找到任何证据。他们也没见着那些盗墓贼的影子，而且请你……%SPEECH_OFF%他抬手制止你解释。%SPEECH_ON%别跟我说你把尸体处理了之类的鬼话。这么办吧，佣兵。我给你一半报酬，然后我会坐在这儿琢磨你到底有没有骗我。没问题吧？很好。%SPEECH_OFF% | 当你告诉他问题已经解决时，%employer%露出了微笑。%SPEECH_ON%这倒是个好消息。可惜的是，我的人去墓地侦察过，没找到任何那些盗墓贼死掉的证据。这情况真有意思，不过我也不会扣着你不放，非要查个水落石出。所以……报酬我给你一半。下次，带着证据来。或者……别再撒谎。我也不知道你到底属于哪种情况。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "嗯。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractPoor);
						this.World.Assets.addMoralReputation(-1);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() / 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail);
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
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"treasure_location",
			this.m.TreasureLocation == null || this.m.TreasureLocation.isNull() ? "" : this.m.TreasureLocation.getName()
		]);
		_vars.push([
			"treasure_direction",
			this.m.TreasureLocation == null || this.m.TreasureLocation.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.TreasureLocation.getTile())]
		]);
		_vars.push([
			"necromancer_location",
			this.m.Flags.get("DestinationName")
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/terrified_villagers_situation"));
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
				local zombies = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies);
				this.World.FactionManager.getFaction(this.m.Destination.getFaction()).removeSettlement(this.m.Destination);
				this.m.Destination.setFaction(zombies.getID());
				zombies.addSettlement(this.m.Destination.get(), false);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}

		if (this.m.Home != null && !this.m.Home.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Home.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(3);
			}
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
			if (this.m.Destination == null || this.m.Destination.isNull())
			{
				return false;
			}

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
