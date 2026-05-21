this.hold_chokepoint_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Target = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hold_chokepoint";
		this.m.Name = "坚守要塞";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		local enemies = [];

		foreach( n in nobles )
		{
			if (n.getFlags().get("IsHolyWarParticipant"))
			{
				enemies.push(n);
			}
		}

		this.m.Flags.set("EnemyID", enemies[this.Math.rand(0, enemies.len() - 1)].getID());
		local locations = this.World.EntityManager.getLocations();
		local candidates = [];

		foreach( v in locations )
		{
			if (v.getTypeID() == "location.abandoned_fortress")
			{
				candidates.push(v);
			}
		}

		local closest;
		local closest_dist = 9000;

		foreach( c in candidates )
		{
			local d = this.m.Home.getTile().getDistanceTo(c.getTile()) + this.Math.rand(0, 5);

			if (d < closest_dist)
			{
				closest = c;
				closest_dist = d;
			}
		}

		this.m.Destination = this.WeakTableRef(closest);
		this.m.Payment.Pool = 1400 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
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

		this.m.Flags.set("Wave", 0);
		this.m.Flags.set("WavesDefeated", 0);
		this.m.Flags.set("WaitUntil", 0.0);
		this.m.Flags.set("MapSeed", this.Time.getRealTime());
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"前往废弃的要塞，防御北方的入侵"
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 20)
				{
					if (this.Contract.getDifficultyMult() <= 1.05)
					{
						this.Flags.set("IsEnemyRetreating", true);
					}
				}

				if (r <= 40)
				{
					this.Flags.set("IsReinforcements", true);
				}
				else if (r <= 70)
				{
					this.Flags.set("IsUltimatum", true);
				}

				local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);

				foreach( n in nobles )
				{
					if (n.getFlags().get("IsHolyWarParticipant"))
					{
						n.addPlayerRelation(-99.0, "在战争中选择了阵营");
					}
				}

				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
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
				if (this.Contract.isPlayerAt(this.Contract.m.Destination))
				{
					this.Contract.setScreen("Arrive");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Running_Defend",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"利用废弃的要塞来防御北方的入侵",
					"不要走得太远"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
				}

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Flags.get("IsFailure") || !this.Contract.isPlayerNear(this.Contract.m.Destination, 600))
				{
					this.Contract.setScreen("Failure");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Flags.get("Wave") > this.Flags.get("WavesDefeated") && (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive()))
				{
					this.Flags.increment("WavesDefeated", 1);
					this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(3, 6));

					if (this.Flags.get("WavesDefeated") == 1)
					{
						this.Contract.setScreen("Waiting1");
					}
					else if (this.Flags.get("WavesDefeated") == 2)
					{
						this.Contract.setScreen("Waiting2");
					}
					else if (this.Flags.get("WavesDefeated") == 3)
					{
						this.Contract.setScreen("Victory");
					}

					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("WaitUntil") > 0 && this.Time.getVirtualTimeF() >= this.Flags.get("WaitUntil"))
				{
					this.Flags.set("WaitUntil", 0.0);
					this.Flags.set("IsWaveShown", false);

					if (this.Flags.getAsInt("Wave") == 2 && this.Flags.get("IsEnemyRetreating"))
					{
						this.Contract.setScreen("EnemyRetreats");
						this.World.Contracts.showActiveContract();
						return;
					}
					else if (this.Flags.getAsInt("Wave") == 2 && this.Flags.get("IsUltimatum"))
					{
						this.Contract.setScreen("Ultimatum1");
						this.World.Contracts.showActiveContract();
						return;
					}
					else
					{
						this.Flags.increment("Wave", 1);
						local enemyNobleHouse = this.World.FactionManager.getFaction(this.Flags.get("EnemyID"));
						local candidates = [];

						foreach( s in enemyNobleHouse.getSettlements() )
						{
							if (s.isMilitary())
							{
								candidates.push(s);
							}
						}

						local mapSize = this.World.getMapSize();
						local o = this.Contract.m.Destination.getTile().SquareCoords;
						local tiles = [];

						for( local x = o.X - 3; x < o.X + 3; x = ++x )
						{
							for( local y = o.Y + 3; y <= o.Y + 6; y = ++y )
							{
								if (!this.World.isValidTileSquare(x, y))
								{
								}
								else
								{
									local tile = this.World.getTileSquare(x, y);

									if (tile.Type == this.Const.World.TerrainType.Ocean)
									{
									}
									else
									{
										local s = this.Math.rand(0, 3);

										if (tile.Type == this.Const.World.TerrainType.Mountains)
										{
											s = s - 10;
										}

										if (tile.HasRoad)
										{
											s = s + 10;
										}

										tiles.push({
											Tile = tile,
											Score = s
										});
									}
								}
							}
						}

						tiles.sort(function ( _a, _b )
						{
							if (_a.Score > _b.Score)
							{
								return -1;
							}
							else if (_a.Score < _b.Score)
							{
								return 1;
							}

							return 0;
						});
						local party = enemyNobleHouse.spawnEntity(tiles[0].Tile, candidates[this.Math.rand(0, candidates.len() - 1)].getName() + "战团", true, this.Const.World.Spawn.Noble, (this.Math.rand(100, 120) + this.Flags.get("Wave") * 10 + (this.Flags.get("IsAlliedReinforcements") ? 50 : 0)) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
						party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + enemyNobleHouse.getBannerString());
						party.setDescription("听命于当地领主的职业军人。");
						party.getLoot().Money = this.Math.rand(50, 200);
						party.getLoot().ArmorParts = this.Math.rand(0, 25);
						party.getLoot().Medicine = this.Math.rand(0, 3);
						party.getLoot().Ammo = this.Math.rand(0, 30);
						local r = this.Math.rand(1, 4);

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

						local c = party.getController();
						local attack = this.new("scripts/ai/world/orders/attack_zone_order");
						attack.setTargetTile(this.Contract.m.Destination.getTile());
						c.addOrder(attack);
						local move = this.new("scripts/ai/world/orders/move_order");
						move.setDestination(this.Contract.m.Destination.getTile());
						c.addOrder(move);
						local guard = this.new("scripts/ai/world/orders/guard_order");
						guard.setTarget(this.Contract.m.Destination.getTile());
						guard.setTime(240.0);
						c.addOrder(guard);
						party.setAttackableByAI(false);
						party.setAlwaysAttackPlayer(true);
						party.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
						this.Contract.m.Target = this.WeakTableRef(party);
					}
				}
			}

			function onDestinationAttacked( _dest, _isPlayerInitiated )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerInitiated;

				if (!this.Flags.get("IsWaveShown"))
				{
					this.Flags.set("IsWaveShown", true);

					if (this.Flags.getAsInt("Wave") == 3 && this.Flags.get("IsReinforcements"))
					{
						this.Contract.setScreen("Reinforcements");
					}
					else
					{
						this.Contract.setScreen("Wave" + this.Flags.get("Wave"));
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "HoldChokepoint";
					p.Music = this.Const.Music.NobleTracks;

					if (this.Contract.isPlayerAt(this.Contract.m.Destination))
					{
						_isPlayerInitiated = false;
						p.MapSeed = this.Flags.getAsInt("MapSeed");
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.LocationTemplate.OwnedByFaction = this.Const.Faction.Player;
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						p.LocationTemplate.ShiftX = -4;

						if (this.Flags.get("IsAlliedReinforcements"))
						{
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 50 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
							p.AllyBanners.push(this.World.FactionManager.getFaction(this.Contract.getFaction()).getPartyBanner());
						}
					}

					this.World.Contracts.startScriptedCombat(p, _isPlayerInitiated, true, true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "HoldChokepoint")
				{
					this.Flags.set("IsFailure", true);
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
					if (this.Flags.getAsInt("WavesDefeated") <= 2 && !this.Flags.get("IsEnemyRetreating"))
					{
						this.Contract.setScreen("Success1");
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
			Text = "[img]gfx/ui/events/event_162.png[/img]{%employer%被他的军人们簇拥着。他们穿着极其浮夸的服装，让你觉得他们有点不像来打仗的。然而，尽管外表相当华而不实，其中一位指挥官还是拿着地图把你拉到一边，清晰地说道。%SPEECH_ON%逐币者，我们需要你前往此处%direction%方向的一座废弃要塞。我们有一支士兵正赶往该地，但他们无法赶在北方的野蛮人之前到达。在所有能联系到的人中，你是距离最近的。去那里防守，直到我们的士兵出现。那要塞已经破败，但我相信，以你那善于钻营的性子，必要的时候靠着一堆碎石也能应付。你回来时能拿到%reward%克朗，当然，前提是你成功完成任务。%SPEECH_OFF% | %employer%坐在一个垫子上，面前铺着一块巨大的地毯。衣着考究的副官们坐在角落，每人手持一根长木棍推动着代表部队的棋子。而在地毯的另一头，还有几个地毯匠正在往地图上添加内容——就你所见，他们正在添加北方的区域。维齐尔看到了你，从远处开口说道。%SPEECH_ON%逐币者，此地%direction%方向有一座倾颓的要塞，有人说它几乎只剩下一堆碎石，但古人将其建在那里是有充分理由的：它具有重要的战略意义。虽然我已派士兵火速赶往该地，但他们无法在一支北方部队到达之前抵达。那些不洁的野蛮人，尽管令人不齿，但你不得不佩服他们快速推进的狡黠。所以，我需要你占领那座要塞，并抵挡住北方人，直到我的军队到达。%SPEECH_OFF%他举起一张纸，上面写着一个你很容易理解的数字：%reward%克朗。 | 一个身着军装、身材异常高大的男人拦住了你，没让你进入%employer%的房间。能听到维齐尔正在他的后宫佳丽中周旋，但这不关你的事。那位中尉将一卷羊皮纸按在你胸前。%SPEECH_ON%古人曾在此地%direction%方向修建了一座要塞。它早已坍塌，如同万物一样敌不过时间的侵蚀，但其地理位置至今仍被证明具有战略价值。我们正调遣一队士兵前往该地，但我们的哨骑回报说，北方狗也同样意识到了它的重要性，并将抢先我们一步抵达。这就是你发挥作用的时候了。夺取要塞并坚守至援军到达。一旦解围，你就返回我们这里，领取你这逐币者应得的%reward%克朗。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{听起来像是%companyname%能做的事情。 | 先谈谈我们能拿到的报酬吧。 | 我们能保卫要塞，抵御异教的入侵。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{这不值得。 | 我们还有别的地方要去。 | 我不会冒险让战团去守卫废墟。}",
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
			ID = "Arrive",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_167.png[/img]{这座要塞既熟悉又陌生。尽管它已分崩离析，化作堆积的碎石，你仍不禁从其残垣断壁中感受到一种庄严。再往里走，在破败的军械库和废弃的食堂周围，有更多仓促建造的构造：匆忙搭建的防御工事，那些背水一战的痕迹，却远在它们本应在的位置之外。无从得知这里曾发生过什么，甚至不知是何时发生的，但此刻，它将作为%companyname%的临时据点。\n\n你走到带垛口的墙边向外望去。看来你们来得很及时：北方人已经逼近，一排人影正行进在地平线上，如同前往蚁丘的蚁群。 | 这座要塞作为一个古老帝国失落的遗迹，这说法似乎很贴切：它的构造既熟悉又陌生。你明白墙壁的用途，但却不太理解刻在其上的一些符号代表什么。甚至某些房间的建筑结构，墙角处那令人称奇的砖砌漩涡，也与你见过的任何样式都不同。你不确定这其中是否蕴含某种战术优势，亦或是它的建造者赋予了这些设计其他重要的意义。\n\n但没有时间在它的历史上耽搁了，你来这里仅仅是扼守住咽喉要道。而时机似乎已到：一股北方人如浪潮般涌过地平线，正朝你们直冲过来！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "全体都有，备战！",
					function getResult()
					{
						this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(5, 8));
						this.Contract.setState("Running_Defend");
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Wave1",
			Title = "战斗之前……",
			Text = "[img]gfx/ui/events/event_90.png[/img]{北方先锋部队已兵临城下。你跃上城墙，朝%companyname%大喊，命令他们做好战斗准备。佣兵们立刻行动，各就各位，整备兵器。与此同时，北方军队铿锵作响的兵甲碰撞声随着他们逼近而愈发震耳。第一支箭无害地落入堡垒，这微弱的信号预示着一场恶战即将展开。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Wave2",
			Title = "战斗之前……",
			Text = "[img]gfx/ui/events/event_78.png[/img]{%randombrother%大喊起来，你急忙冲向城墙。阵列于战场之上的是一支全副武装的北方部队。或许他们已得知挡在面前的是%companyname%，因此打算稍微认真些对待此事。但多余的谨慎也救不了他们。与%companyname%正面交锋的结果只有一个，你对着那逼近的攻势，忍不住露出了一个挑衅的笑容。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Wave3",
			Title = "战斗之前……",
			Text = "[img]gfx/ui/events/event_78.png[/img]{北方人再次逼近。他们踏过尸骸前进，如同鲷鱼游过盐水，集结成一团黑暗的人马与装备，阴沉地、轮廓分明地映衬在被你们化为血泥的大地上。原本正在啃食死尸的老鼠四散奔逃，秃鹫也纷纷惊飞。你抬起手臂，命令兄弟们做好准备，迎接这场但愿是最后的战斗。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Waiting1",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_167.png[/img]{第一波攻势被击退了。你短暂地考虑了下要不要用尸体去填补墙上的缺口，但你可不想招来老鼠和它们带来的瘟疫。随着一声简短的命令，你让人把尸体堆在墙外，然后令部下准备迎接下一次突击。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "准备迎接他们的下一次进攻！",
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
			ID = "Waiting2",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_167.png[/img]{%companyname%的成员们看起来几乎像是你当初雇佣他们时的样子：饱经风霜，疲惫不堪。但与战团共度的所有这些时光已经让他们成为了更好的战士。尽管已经耗尽精力，但训练不会停歇，威名不会磨损，声望不会衰减。当时机来临，%companyname%必将为下一次突击做好准备。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "还可能有更多敌人要来。",
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
			ID = "Failure",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_87.png[/img]{你已经受够了这一切。维齐尔交给战团的任务是坚守一段时间，而不是坐在这等死。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "不值得为此葬送整个战团……",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "未能成功抵御北方入侵者，丢失了废弃的要塞。");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "EnemyRetreats",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_168.png[/img]{尸体堆积如山，苍蝇嗡嗡作响，秃鹫如巨大黑云般在空中盘旋，看来北方人已经受够了。一声号角带着溃败的断续鸣响传来，士兵们放下武器，转身向来路撤去。与此同时，一名哨骑从南方赶来，报告说%employer%的部队即将抵达。看来你们可以安全返回雇主那里了。}",
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
			],
			function start()
			{
				this.Contract.spawnAllies();
			}

		});
		this.m.Screens.push({
			ID = "Reinforcements",
			Title = "战斗之前……",
			Text = "[img]gfx/ui/events/event_164.png[/img]{北方人再次逼近。他们踏过尸骸前进，如同鲷鱼游过盐水，集结成一团黑暗的人马与装备，阴沉地映衬在这片被你们化为血泥的大地上。就在你抬起手臂准备向部下下令时，地平线上出现了更多的军队。你的心一沉，随即认出他们高举着%employer%的旗帜！维齐尔的援军到了！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "终于，有援军了！",
					function getResult()
					{
						this.Flags.set("IsAlliedReinforcements", true);
						this.Flags.set("IsReinforcements", false);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Ultimatum1",
			Title = "在你等待时……",
			Text = "[img]gfx/ui/events/event_90.png[/img]{一声洪亮的号角吸引了你的注意。你走上防御工事的顶端向下望去，发现一名打着贵族旗号的传令官。他只身一人，但嗓门却抵得上一整个连队。%SPEECH_ON%尊贵的佣兵，你是否在寻求宽恕？你是否渴望能见到另一个黎明，又或者渴望再经历一个冬去春来？你是否渴望活下去，以便……%SPEECH_OFF%你朝他喊话，让他直说重点。那人清了清嗓子。%SPEECH_ON%贵族们愿意做笔交易。立刻离开此地，我们便放你走，绝不追击。不仅如此，我们承诺，你的过往记录将如同蜡板，离开此地便意味着将其擦拭干净。%companyname%与北方之间的一切敌意，都将凭北方法令一笔勾销。当然，这前提是你接受这个提议。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "你的提议可以接受。",
					function getResult()
					{
						return "Ultimatum2";
					}

				},
				{
					Text = "让你和你的蜡见鬼去吧！",
					function getResult()
					{
						return "Ultimatum3";
					}

				}
			],
			function start()
			{
				this.Flags.set("IsArrived", true);
			}

		});
		this.m.Screens.push({
			ID = "Ultimatum2",
			Title = "在你等待时……",
			Text = "[img]gfx/ui/events/event_90.png[/img]{你接受了这笔交易。一些弟兄发出抱怨，另一些则如释重负，不过这两种情绪的迹象无疑都被小心翼翼地隐藏起来，以免引起你的猜疑。%companyname%就此“合法地”撤离了此地，北方人接管了控制权。你被授予了一系列正式文书，上面载有能从北方各家显贵那里获取的所有重要签名，以及他们的正式印章。这将保你平安穿过北方领土，尽管你无疑是以丧失在南方的良好声誉为代价才取得了这项权利。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "对于战团而言这是最好的选择。",
					function getResult()
					{
						local f = this.World.FactionManager.getFaction(this.Contract.getFaction());
						f.addPlayerRelation(-f.getPlayerRelation(), "在战争中改变了阵营");
						f.getFlags().set("Betrayed", true);
						local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);

						foreach( n in nobles )
						{
							n.addPlayerRelationEx(50.0 - n.getPlayerRelation(), "在战争中改变了阵营");
							n.makeSettlementsFriendlyToPlayer();
						}

						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Ultimatum3",
			Title = "在你等待时……",
			Text = "[img]gfx/ui/events/event_90.png[/img]{你让传令官回他的指挥官那里去。他点了点头。%SPEECH_ON%愿你的坚韧能打动旧神，因为它无法撼动北方的力量。%SPEECH_OFF%传令官鞠了一躬，随即掉头离开。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "准备迎接他们的下一次攻击。",
					function getResult()
					{
						this.Flags.set("IsUltimatum", false);
						this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(3, 6));
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
			Text = "[img]gfx/ui/events/event_168.png[/img]{尸体遍布战场，有时堆积达三四层高。%companyname%的成员穿行于尸骸间搜刮能拿的一切，加入他们掠夺行列的还有乌鸦、秃鹫、老鼠、耗子、野猫、流浪狗、一匹狼、一个过于危险而无法靠近的野人，以及一群显然觉得此地足够温暖而暂停了季节性迁徙的野鹅。维齐尔的手下也已抵达并开始接管，所以你自己也需要动身返回%employer%处领取报酬。 | 空气中弥漫着潮湿凝滞的气息，夹杂着刺鼻的铜腥味。屠杀是如此彻底，以至于此处的土地已化作一片血污沼泽。尸体以各种扭曲的姿态倒伏，有时层层堆叠。偶尔你会听到呻吟声，但死者如此众多，试图寻找幸存者不过是浪费时间。%employer%的手下很快将接管你们的职责，这意味着现在是返回维齐尔那里领取报酬的好时机。}",
			Image = "",
			Characters = [],
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
			],
			function start()
			{
				this.Contract.spawnAllies();
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer%在你离他王座还有一掷之遥时叫停了你。他打了个响指，一个仆人应声上前，但维齐尔大笑着抬手制止。%SPEECH_ON%不，等等。让个女人来做。她。最丑的那个。%SPEECH_OFF%他指向他的后宫，女人们纷纷散开，直到一个女子被孤立出来。她的身姿如此曼妙，你会觉得她在北方能值一座城堡。她从仆人手中接过一袋克朗，匍匐在你面前。%employer%讥讽地笑道。%SPEECH_ON%你本该坚守堡垒直到我的部队抵达。结果你却显露出娘们似的本性，一见危险就逃之夭夭。算你走运，我的人，那些真正的男子汉，从北方人手中夺回了堡垒，并扼守住了那里。别再盯着那个小妾看了，逐币者！你的眼睛要么看着地面，要么看着你的报酬。我建议你拿着你的钱，在我动怒让你吃不了兜着走之前，立刻从我眼前消失。%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "守卫要塞抵抗北方人");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isHolyWar())
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
		this.m.Screens.push({
			ID = "Success2",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{你向%employer%报告了发生的一切。维齐尔脸上缓缓浮现出一丝笑容。%SPEECH_ON%天哪，是我的副官们派你去的？那座堡垒一文不值。谁会开这种玩笑？我倒是想砍了责任人的脑袋，但唉，是多少来着，%reward_completion%克朗？对我而言不算什么。我付过更多钱，就为了听北方弄臣当面讲个蹩脚笑话，而他们的幽默感充其量也只是贫乏得很。拿着你的金子，离开我的地盘吧，逐币者。%SPEECH_OFF% | 当你回到%employer%那里时，到处都找不到维齐尔。取而代之的是他的一名副官将你拉到一边，感谢你的服务。%SPEECH_ON%我私底下和你说，倘若我麾下能有你这样的士兵，我心中恐怕会萌生征伐的妄念。唉，可我得到的部队对我来说，犹如沙粒之于沙漠。这是你的报酬，逐币——士兵。%SPEECH_OFF%他递过来一袋%reward_completion%克朗。另一名副官沿着走廊走来，你面前的这人拍了拍你的肩膀，他的脸色突然没了幽默或友善。%SPEECH_ON%滚出去，逐币者，这就是你的报酬，我们不想听到你嘴里任何讨价还价的话！%SPEECH_OFF% | 你走进维齐尔的大厅，却只发现一个孤零零的人在打扫大理石地板。他扫帚的鬃毛刮到你的靴子停了下来，他抬起头。%SPEECH_ON%啊。他们告诉我像你这样身份的人会来。%SPEECH_OFF%他放下扫帚，那扫帚柄可能比他那孱弱的身躯还要粗。他走到一张桌子前，打开一个装有%reward_completion%克朗的箱子。你问维齐尔们怎么会把这么多钱币托付给他。那人拿起扫帚笑了。%SPEECH_ON%倘若我自己偷走这些克朗，我能跑多远？它很重。我无法全部带走。那么我能拿一点吗？不行。我看起来就不像个贵人。金子在我手中只会照亮我这个小偷，正如镀金者之眼催开鲜花一样确凿。我绝对跑不远的。这就是我的归属，而这些是你的。%SPEECH_OFF%你拿起钱币，但接着问他怎么知道你就是来领钱的佣兵。他的扫帚又停了下来，一滴汗珠慢慢顺着他的脸颊流下。没等他回答，你拿起克朗就走了。 | %employer%正与他的议员共处。那群难得一见的、身着丝绸、抚须沉吟的人用轻蔑的目光打量着你。你大声宣布堡垒已被守住并由南方士兵接管。所有嘈杂声都停止了，你的话语在铺满大理石的大厅里回荡，每个仆人都停下了动作，议员也都停下交谈。%employer%站起身来。%SPEECH_ON%仆人们，给这摇唇鼓舌的家伙拿他的钱。%SPEECH_OFF%一名议员啐了一口，一个戴着项圈的孩子迅速清理干净。%SPEECH_ON%就该趁他还在堡垒时就把报酬汇过去。他怎敢在这房间里喘气。%SPEECH_OFF%仆人们拿着几袋%reward_completion%克朗冲到你身边。维齐尔挥了挥手。%SPEECH_ON%滚吧，逐币者。我花钱雇了一堆弄臣，而你不在其列。%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "守卫要塞抵抗北方人");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isHolyWar())
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

	function spawnAllies()
	{
		local cityState = this.World.FactionManager.getFaction(this.getFaction());
		local mapSize = this.World.getMapSize();
		local o = this.m.Destination.getTile().SquareCoords;
		local tiles = [];

		for( local x = o.X - 3; x < o.X + 3; x = ++x )
		{
			for( local y = o.Y - 6; y <= o.Y - 3; y = ++y )
			{
				if (!this.World.isValidTileSquare(x, y))
				{
				}
				else
				{
					local tile = this.World.getTileSquare(x, y);

					if (tile.Type == this.Const.World.TerrainType.Ocean)
					{
					}
					else
					{
						local s = this.Math.rand(0, 3);

						if (tile.Type == this.Const.World.TerrainType.Mountains)
						{
							s = s - 10;
						}

						if (tile.HasRoad)
						{
							s = s + 10;
						}

						tiles.push({
							Tile = tile,
							Score = s
						});
					}
				}
			}
		}

		if (tiles.len() == 0)
		{
			tiles.push({
				Tile = this.m.Destination.getTile(),
				Score = 0
			});
		}

		tiles.sort(function ( _a, _b )
		{
			if (_a.Score > _b.Score)
			{
				return -1;
			}
			else if (_a.Score < _b.Score)
			{
				return 1;
			}

			return 0;
		});
		local party = cityState.spawnEntity(tiles[0].Tile, "团" + cityState.getNameOnly(), true, this.Const.World.Spawn.Southern, this.Math.rand(100, 150) * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + cityState.getBannerString());
		party.setDescription("忠于城邦的应征士兵。");
		party.getLoot().Money = this.Math.rand(50, 200);
		party.getLoot().ArmorParts = this.Math.rand(0, 25);
		party.getLoot().Medicine = this.Math.rand(0, 3);
		party.getLoot().Ammo = this.Math.rand(0, 30);
		local r = this.Math.rand(1, 4);

		if (r <= 2)
		{
			party.addToInventory("supplies/rice_item");
		}
		else if (r == 3)
		{
			party.addToInventory("supplies/dates_item");
		}
		else if (r == 4)
		{
			party.addToInventory("supplies/dried_lamb_item");
		}

		local c = party.getController();
		local guard = this.new("scripts/ai/world/orders/guard_order");
		guard.setTarget(this.m.Destination.getTile());
		guard.setTime(240.0);
		c.addOrder(guard);
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"employerfaction",
			this.World.FactionManager.getFaction(this.m.Faction).getName()
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Destination.getTile())]
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isHolyWar())
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
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});
