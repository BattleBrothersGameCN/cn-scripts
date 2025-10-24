this.raze_attached_location_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Settlement = null
	},
	function setSettlement( _s )
	{
		this.m.Flags.set("SettlementName", _s.getName());
		this.m.Settlement = this.WeakTableRef(_s);
	}

	function setLocation( _l )
	{
		this.m.Destination = this.WeakTableRef(_l);
		this.m.Flags.set("DestinationName", _l.getName());
	}

	function create()
	{
		this.contract.create();
		this.m.DifficultyMult = 0.85;
		this.m.Type = "contract.raze_attached_location";
		this.m.Name = "夷平地点";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		local s = this.World.EntityManager.getSettlements()[this.Math.rand(0, this.World.EntityManager.getSettlements().len() - 1)];
		this.m.Destination = this.WeakTableRef(s.getAttachedLocations()[this.Math.rand(0, s.getAttachedLocations().len() - 1)]);
		this.m.Flags.set("PeasantsEscaped", 0);
		this.m.Flags.set("IsDone", false);
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 600 * this.getPaymentMult() * this.getDifficultyMult() * this.getReputationToPaymentMult();

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
					"夷平" + this.Flags.get("DestinationName") + "附近" + this.Flags.get("SettlementName")
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

				if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().get("Betrayed") && this.Math.rand(1, 100) <= 75)
				{
					this.Flags.set("IsBetrayal", true);
				}
				else
				{
					this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.Peasants, this.Math.rand(90, 150));

					if (this.Math.rand(1, 100) <= 25)
					{
						this.Flags.set("IsMilitiaPresent", true);
						this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.Militia, this.Math.min(300, 80 * this.Contract.getScaledDifficultyMult()));
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
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setFaction(this.Const.Faction.Enemy);
					this.Contract.m.Destination.setAttackable(true);
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Flags.get("IsDone"))
				{
					if (this.Flags.get("IsBetrayal"))
					{
						this.Contract.setScreen("Betrayal2");
					}
					else
					{
						this.Contract.setScreen("Done");
					}

					this.World.Contracts.showActiveContract();
				}
			}

			function onEntityPlaced( _entity, _tag )
			{
				if (_entity.getFlags().has("peasant") && this.Math.rand(1, 100) <= 75)
				{
					_entity.setMoraleState(this.Const.MoraleState.Fleeing);
					_entity.getBaseProperties().Bravery = 0;
					_entity.getSkills().update();
					_entity.getAIAgent().addBehavior(this.new("scripts/ai/tactical/behaviors/ai_retreat_always"));
				}

				if (_entity.getFlags().has("peasant") || _entity.getFlags().has("militia"))
				{
					_entity.setFaction(this.Const.Faction.Enemy);
					_entity.getSprite("socket").setBrush("bust_base_militia");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (this.Contract.m.Destination.getTroops().len() == 0)
				{
					this.onCombatVictory("RazeLocation");
					return;
				}
				else if (!this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);

					if (this.Flags.get("IsBetrayal"))
					{
						this.Contract.setScreen("Betrayal1");
					}
					else if (this.Flags.get("IsMilitiaPresent"))
					{
						this.Contract.setScreen("MilitiaAttack");
					}
					else
					{
						this.Contract.setScreen("DefaultAttack");
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.Contract.m.Destination.getPos());
					p.CombatID = "RazeLocation";
					p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[this.Contract.m.Destination.getTile().Type];
					p.Tile = this.World.getTile(this.World.worldToTile(this.World.State.getPlayer().getPos()));
					p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
					p.LocationTemplate.Template[0] = "tactical.human_camp";
					p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.None;
					p.LocationTemplate.CutDownTrees = true;
					p.LocationTemplate.AdditionalRadius = 5;
					p.PlayerDeploymentType = this.Flags.get("IsEncircled") ? this.Const.Tactical.DeploymentType.Circle : this.Const.Tactical.DeploymentType.Edge;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Center;
					p.Music = this.Const.Music.CivilianTracks;
					p.IsAutoAssigningBases = false;

					foreach( e in p.Entities )
					{
						e.Callback <- this.onEntityPlaced.bindenv(this);
					}

					p.EnemyBanners = [
						"banner_noble_11"
					];
					this.World.Contracts.startScriptedCombat(p, true, true, true);
				}
			}

			function onActorRetreated( _actor, _combatID )
			{
				if (_actor.getFlags().has("peasant"))
				{
					this.Flags.set("PeasantsEscaped", this.Flags.get("PeasantsEscaped") + 1);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "RazeLocation")
				{
					this.Contract.m.Destination.setActive(false);
					this.Contract.m.Destination.spawnFireAndSmoke();
					this.Flags.set("IsDone", true);
				}
				else if (_combatID == "Defend")
				{
					this.Flags.set("IsDone", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "RazeLocation")
				{
					this.Flags.set("PeasantsEscaped", 100);
				}
				else if (_combatID == "Defend")
				{
					this.Flags.set("IsDone", true);
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
				this.Contract.m.Destination.getSprite("selection").Visible = false;
				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.Contract.m.Destination.setOnCombatWithPlayerCallback(null);
				this.Contract.m.Destination.setFaction(this.Contract.m.Destination.getSettlement().getFaction());
				this.Contract.m.Destination.clearTroops();
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Flags.get("PeasantsEscaped") == 0)
					{
						this.Contract.setScreen("Success1");
					}
					else if (this.Math.rand(1, 100) >= this.Flags.get("PeasantsEscaped") * 10)
					{
						this.Contract.setScreen("Success2");
					}
					else
					{
						this.Contract.setScreen("Failure1");
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
			Text = "[img]gfx/ui/events/event_61.png[/img]{%employer%甩开丝质袖口，扳响指关节。%SPEECH_ON%我希望将一件极其敏感的事情托付于你，因为我的家族绝不能与我要告知你的事情有所牵连。%SPEECH_OFF%你点头应承，仿佛佣兵常被要求保守秘密。那人继续说道。%SPEECH_ON%%settlementname%镇太过弱小无法自卫，民众正疾呼寻求能抵御强盗的保护。我们%noblehousename%家族，才是唯一能真正守护他们安稳的势力。不幸的是，当地议会对此视而不见。他们坚信能靠自身力量保护子民。就让我们证明他们错得有多离谱。\n\n我要你将%settlementname%附近的%location%烧为平地，并杀光那里的农民。要做得像是强盗所为。我相信你对他们那套很熟悉。现在……%SPEECH_OFF%%employer%俯身凑近。%SPEECH_ON%……我把话说得非常清楚，你要仔细听好：绝不能留下任何能指认真正袭击者的活人。一个都不行！明白吗？很好。事成之后回来复命。%SPEECH_OFF% | %employer%盯着一堆卷轴，随后狂怒地将它们从桌上扫落，激起一片纷飞的纸页。%SPEECH_ON%%settlementname%的议员们以为能靠自己保护他们的小镇免遭强盗侵害，但我知道他们做不到。我知道他们需要我的保护！而我开出的价码如此合理……%SPEECH_OFF%他勉强冷静片刻，瞥了你一眼。%SPEECH_ON%我有办法了。我知道该怎么做了。你……你对强盗的勾当很熟悉吧？当然。不如你……去%settlementname%外的%location%……干点强盗会干的事。当然，要做得真像是强盗所为……之后，镇上的人肯定会雇我来保护他们！那样他们就安全了！%SPEECH_OFF% | %employer%十指交搭抵着前额。他长叹一声。%SPEECH_ON%我跟%settlementname%的人打交道好几年了，但我开始认为，我得用点更出格的办法才能达成目的。那里的议会不愿意付钱请我保护村庄，因为他们自以为能应付。他们说至今已平安无事很久了。那如果……他们不再安全呢？如果你潜入那里——当然要扮成强盗——让他们明白，没有%noblehousename%的庇护，谁都不得安宁！当然，你绝不能向任何人透露我们这次的谈话……意下如何，佣兵？%SPEECH_OFF% | 你刚坐下，%employer%却正凝望窗外。%SPEECH_ON%站起来，佣兵。我不想俯身说话，那会让我不得不提高嗓门——而我要说的事，可不便张扬。%SPEECH_OFF%你起身侧耳倾听。%SPEECH_ON%%settlementname%拒绝了我的保护提议。他们决定自力更生。这不仅意味着%noblehousename%收不到钱，更是在羞辱我们。如果这个村子拒绝我们的庇护，其他村子呢？我要你扮演强盗\"角色\"去那里，让他们亲身体会，在这世道失去%noblehousename%倚仗会是什么下场！当然，保密最为紧要。我刚才说的每一个字都不能外传。%SPEECH_OFF% | %employer%用力搓揉着一颗苹果，用大拇指硬刮下了苹果皮。%SPEECH_ON%我父亲曾告诫我：如果你的名号不足以让人闻声起敬，那你根本算不得拥有名号。可悲的是，%settlementname%并不尊重%noblehousename%的威名。他们不仅拒绝我的保护提议，还羞辱我的家族。我要你让他们为此付出代价。我要你去那里——不是以佣兵身份，而是扮作强盗——让他们知道没有%noblehousename%庇护的世界是怎么样的。当然，你必须做得干净利落，佣兵。这房间里谈的一切，谁都不能知道。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{谈谈价钱吧。 | 多大的生意？ | 报酬如何？ | 价钱合适，一切好说。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{我们不接这种活。 | 这种活不要找%companyname%。}",
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
			ID = "DefaultAttack",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_16.png[/img]{你抵达了%location%。正如所料，农民们正在四处活动。这简直易如反掌。现在唯一的问题是：你打算怎么动手？ | %location%比想象中更宁静些。几个农民在闲逛，一边摆弄着镰刀锄头，一边聊着各种琐事。你听到他们被某个笑话逗得放声大笑。可惜他们今天的剩余时光可不会这么有趣了。 | 你透过高高的杂草仔细观察%location%。几个农民正在走动，完全没察觉到就在他们小村外的草丛中，悄无声息的毁灭正在逼近。你扫视着这片区域，开始谋划下一步行动。 | %location%很安静，对一个即将遭受毁灭的地方来说有点过于安静。你摇摇头感叹这个世界的残酷，但随即提醒自己这份差事报酬丰厚。这么一想就好受多了。 | 屠杀农民从来不是你的强项。倒不是下不去手，而是这种毫无挑战的活计总让你心里别扭。就像杀死断腿的狗或踩死瞎眼的青蛙。但可从没人付钱请你了结野狗的性命。多讽刺啊，这些农民要是当狗反而比当人更安全。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "包围他们！",
					function getResult()
					{
						this.Flags.set("IsEncircled", true);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				},
				{
					Text = "从一侧扫荡过去！",
					function getResult()
					{
						this.Flags.set("IsEncircled", false);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "MilitiaAttack",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_141.png[/img]{你到达%location%后立即示意手下停步隐蔽。农民们在，但民兵也在。这和说好的不一样，你必须重新评估局势。 | 当你接近%location%时，%randombrother%带回了侦察报告。显然那里不只有农民。该区域还有几个民兵。如果你要坚持行动，就不得不连他们一起对付。现在怎么办？ | 是民兵！他们根本不在计划之内！如果你要继续执行，就得连他们和农民一起解决。是时候仔细考虑一下了…… | 怎么回事？你看见民兵在%location%周围巡逻。现在要想完成任务，你就得真刀真枪地打一仗了。 | 当你准备攻击%location%时，%randombrother%指出了远处的异常。你眯起眼睛，看清那是一小队看起来像民兵的人。这完全不在协议范围内！你仍然可以继续攻击，但肯定会遇到抵抗……}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "包围他们！",
					function getResult()
					{
						this.Flags.set("IsEncircled", true);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				},
				{
					Text = "从一侧扫荡过去！",
					function getResult()
					{
						this.Flags.set("IsEncircled", false);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Done",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_02.png[/img]{屠杀大功告成。你带人将此地付之一炬，只余袅袅残烟。 | 随当你跨过遍布四周的农民尸体时，空气中弥漫着铜腥味。你对自己的杰作点了点头，随后看向%randombrother%下达命令。%SPEECH_ON%全部烧光。%SPEECH_OFF% | 他们的抵抗比预想的稍强，但最终你还是把他们全宰了。或者至少，你希望如此。不想在这事上马虎了事，你随即点燃了视野所及的每栋建筑。 | 你毁灭了%location%。居民尽数屠戮，建筑皆陷火海。以任何佣兵的标准衡量，这都算得上圆满收工。 | ……至此，“抵抗”已被镇压。几具尸体散落各处。你希望已将他们赶尽杀绝。剩下要做的就是将一切焚为灰烬，然后动身离开。 | …于是“抵抗”被压制了。 这里几个尸体，那里几个尸体。 你希望你把他们都干掉了。 剩下的只是把一切都烧成灰并离开。 | 好吧，你达成此行的目的了，于是让几名手下以你认为“具有警示意味”的方式陈列尸体，再命其他佣兵将视野内所有建筑尽数点燃。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们完事了。",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-5);
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 3, this.Contract.m.Settlement, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Betrayal1",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_78.png[/img]{你刚抵达%location%，就遇上一群全副武装的人。其中一人上前，拇指勾着佩剑腰带走上前来。%SPEECH_ON%啧啧，你们还真是蠢得可以。%employer%可不是健忘的人——他可没忘记你们上次背叛%faction%的事。就当这是……一点小小的回礼。%SPEECH_OFF%话音刚落，他身后的士兵突然发起冲锋。抄起武器，我们中埋伏了！  | 你走进%location%，但村民们似乎早有准备：只见窗板纷纷闭合，门扉砰砰关紧。正当你准备下令战队开始屠杀时，一群人从建筑后方走了出来。\n\n他们……的装备可比普通平民精良得多。事实上，他们扛着%employer%的旗帜。当这些人开始冲锋时，你才意识到自己中了圈套，急忙厉声下令全员武装。 | 在%location%外的道路上，一名男子迎上了你们。他装备精良，盔甲齐全，而且显然心情颇佳，在你走近时露出狡黠的咧嘴笑。%SPEECH_ON%晚上好，雇佣兵。%employer%向你们问好。%SPEECH_OFF%就在这时，一群人从道路两侧涌出。是埋伏！那个该死的贵族背刺了你们！ | 你踏进%location%，迎接你的唯有在老旧木构建筑间呜咽的孤风。心知中了圈套，你拔出了长剑。%SPEECH_ON%反应不慢。%SPEECH_OFF%声音来自一栋建筑，一人从中走出，手正从鞘中抽出利刃。一队身着%faction%纹章色彩的武装随从迈着整齐步伐紧随其后，呈扇形包围了战团。%SPEECH_ON%我很期待从你冰冷僵硬的手里把这把剑撬出来。%SPEECH_OFF%你耸肩问为什么设局。%SPEECH_ON%%employer%从不会忘记背叛他或家族的人。知道这点就够了。反正你们很快就是死人了。%SPEECH_OFF%准备迎战吧，我们中了埋伏！ | %location%空无一人。你的手下搜遍建筑也没有发现任何人。突然，几个人拦在了你的来路上，带队的指挥官神情恶劣地走上前来，胸前绣着%employer%的徽章。%SPEECH_ON%安静得可怕，不是吗？如果你们想知道的话，我是来替%employer%收债的。你们承诺过会完成任务。既然当时没能履约，现在就拿命抵债吧。%SPEECH_OFF%你拔剑出鞘，寒光直指对方。%SPEECH_ON%看来%employer%又要被爽约了。%SPEECH_OFF%}}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractBetrayal);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().set("Betrayed", false);
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.CombatID = "Defend";
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[this.Contract.m.Destination.getTile().Type];
						p.Tile = this.World.getTile(this.World.worldToTile(this.World.State.getPlayer().getPos()));
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.Music = this.Const.Music.NobleTracks;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 150 * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Betrayal2",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_22.png[/img]{你在裤腿上擦拭剑刃后迅速收剑入鞘。伏击者的尸体以各种怪异姿态倒毙在地。%randombrother%上前询问下一步行动。看来%faction%往后不会与我们友好相处了。 | 你将伏击者的尸体从剑尖踢落。看来从今往后%faction%不会对我们太友善。或许下次答应为这些人办事时，最好说到做到。 | 好吧，至少这次教训告诉我们：别承诺自己做不到的事。这片土地上的人们对失信之徒可不会客气…… | 你确实背叛过%faction%，但往事不必再提。现在重要的是他们背叛了你！从今往后，最好对这群人及其麾下势力都保持警惕。 | 从脚下士兵的尸体来看，%employer%显然对你不再满意。若要说原因，无非是往日旧账——背信弃义、任务失败、出言顶撞，还是睡了贵族女儿？细想之下桩桩件件都涌入脑海。重要的是你们之间的裂痕难以弥合，最近最好提防着点%faction%的人。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "去他们的！",
					function getResult()
					{
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_61.png[/img]{你回到%employer%处汇报消息。他向后靠坐并点了点头。%SPEECH_ON%一个不留？%SPEECH_OFF%你环顾四周。%SPEECH_ON%有听到什么人来报信吗？%SPEECH_OFF%%employer%微笑着摇头。%SPEECH_ON%当然只有些可怕事件的消息。该死的强盗。%SPEECH_OFF%他打了个响指，一个男子仿佛从阴影中现身，向你支付了酬劳。 | %employer%给你递上一杯酒。对于一个刚下令屠杀农民的人而言，他的笑容显得异常温和。%SPEECH_ON%我听到风声说%location%已化为废墟。%SPEECH_OFF%你点点头。%SPEECH_ON%是强盗干的吧？%SPEECH_OFF%%employer%咧嘴一笑，递给你一袋克朗。%SPEECH_ON%确实是强盗。%SPEECH_OFF% | %location%已被摧毁，你回去向%employer%汇报消息。他身旁站着几位当地居民，于是你将“消息”转为“强盗”袭击了该地。他忧心忡忡地点头，却以娴熟的手法悄悄塞给你一袋克朗。随后转向居民们，宣称必须对强盗问题采取行动…… | 你向%employer%汇报任务成功。他微笑着召集一群平民过来，当众宣布“强盗”摧毁了%location%，并声称必须提高税收以解决这个新问题。说完后，他转身将一袋克朗滑进你的外套内袋。 | 你走进%employer%的住所。他身旁有位正在啜泣的妇人。当你看向他时，他摇了摇头。你会意地向他报告“消息”。%SPEECH_ON%呃……强盗……已经摧毁了%location%。%SPEECH_OFF%%employer%肃穆地点了点头。%SPEECH_ON%是，是的我知道了。这位寡妇已经告诉了我一切。悲惨的消息。太悲惨了。%SPEECH_OFF%当你离开时，他的一名手下将一袋克朗递到你手中。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{干活拿钱，天经地义。 | 给钱就行。}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess);
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
			ID = "Success2",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_61.png[/img]{你走进%townname%，发现几个面熟的农民围在%employer%身边。担心被认出来，你躲在暗处。他们哭喊着说强盗摧毁了%location%。%employer%装出担忧的样子。%SPEECH_ON%真的吗？太可怕了！我会调查此事的。别害怕，乡亲们，我会保护你们的！%SPEECH_OFF%他话音刚落，一名护卫就悄悄塞给你一袋克朗。 | 你走进%employer%的住所，看见几个浑身是血的农民围在他桌边。你躲着等他们说完话离开。%employer%招手让你进来。%SPEECH_ON%强盗。他们说是强盗干的。完美。你的报酬在墙角。%SPEECH_OFF% | %employer%微笑着迎接你回来。%SPEECH_ON%有人逃出来了。%SPEECH_OFF%他摆摆手让你别担心。%SPEECH_ON%他们觉得是强盗干的。就是单纯的流寇过境。你没什么好担心的。你的报酬……%SPEECH_OFF%他把一个袋子滑过桌面推过来。你接过袋子点点头。%SPEECH_ON%合作愉快。%SPEECH_OFF% | 你进去时%employer%把一卷文书啪地摔在桌上。%SPEECH_ON%你留了些活口！不过……没关系。他们以为是强盗干的。%SPEECH_OFF%你一手按在剑柄上，瞥了眼%employer%的护卫。%SPEECH_ON%我还是要拿全款。%SPEECH_OFF%%employer%朝桌上一个钱袋指了指。%SPEECH_ON%当然。但下次我让你办事，就不要有遗漏了，明白吗？%SPEECH_OFF% | 一群农民围着%employer%。你还以为他们要动私刑，结果他却把他们打发走了。看着他们拐过街角，他解释说那些是%location%的幸存者。没等你开口，他就摆手让你别担心。%SPEECH_ON%他们还是觉得是强盗干的，但我对这个结果不满意。咱俩差点就出事了，我是说，我差点出事。%SPEECH_OFF%你点头问要不要把这几个幸存者干掉以防万一。%employer%摇摇头。%SPEECH_ON%不必了。这是说好的报酬，佣兵。不过下次务必按我的吩咐做。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{干活拿钱，天经地义。 | 给钱就行。}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnVictory);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractPoor, "履行了合同");
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
			ID = "Failure1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_43.png[/img]{你刚走进%employer%的住所，他就转身将一卷画像拍在桌上。%SPEECH_ON%认得这人吗？%SPEECH_OFF%你拿起画卷。素描的面容与你自己惊人地相似。%employer%向后靠去。%SPEECH_ON%他们知道有人雇凶袭击了那里。现在就他妈给我滚出去，否则我就让手下把你捅个对穿。%SPEECH_OFF% | %SPEECH_ON%活人！活人！我说过什么？‘不留一个活人’，我记得我是这么说的，对吧？%SPEECH_OFF%你点头时%employer%的指节在桌面上攥得发白。%SPEECH_ON%那他妈的为什么会有农民跑来这里哭喊说佣兵袭击了他们的地方？死人不会说话，但谁会说话？谁会说话，佣兵？%SPEECH_OFF%你站起身。%SPEECH_ON%活人。%SPEECH_OFF%%employer%指向门口。%SPEECH_ON%对。现在立刻滚出我的视线。%SPEECH_OFF% | %employer%告诉你：几个农民逃走了并散播消息说摧毁%location%是有人‘雇凶作案’。你点着头，但你在想……%SPEECH_ON%我们找到的装备还能留着吗？%SPEECH_OFF%%employer%大笑。%SPEECH_ON%你爱留什么留什么，但休想从我这儿拿到一个子儿。滚出去，佣兵。%SPEECH_OFF% | 不幸的是，似乎有几个农民在那场屠杀中幸存下来。他们向%employer%透露了非常具体的细节，即摧毁%location%的是装备精良、心怀不轨的人。不是强盗，而是佣兵。你本该把他们全杀光，不留活口，但现在……好吧，现在你拿不到报酬了。 | %employer%坐在你对面，攥紧拳头，脸色涨红。他质问，他还怎么以保护民众免受强盗侵害为由提高税收，现在所有人都认为是雇佣兵摧毁了%location%，你询问他什么意思，这人非常直白地告诉你：有几个农民活下来了，你这他妈的白痴。留下活口显然不满足工作要求，而现在%employer%的酬金也不会进入你的口袋了。}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "%settlementname%恐怕不会再欢迎我们了……",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail);
						this.Contract.m.Destination.getSettlement().getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationAttacked, "劫掠了" + this.Flags.get("DestinationName"));
						this.World.Contracts.finishActiveContract();
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
			"settlementname",
			this.m.Flags.get("SettlementName")
		]);
		_vars.push([
			"noblehousename",
			this.World.FactionManager.getFaction(this.m.Faction).getNameOnly()
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
				this.m.Destination.setFaction(this.m.Destination.getSettlement().getFaction());
				this.m.Destination.setOnCombatWithPlayerCallback(null);
				this.m.Destination.setAttackable(false);
				this.m.Destination.clearTroops();
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (this.World.FactionManager.isGreaterEvil())
		{
			return false;
		}

		if (this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isActive())
		{
			return false;
		}

		if (this.m.Settlement == null || this.m.Settlement.isNull())
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

		if (this.m.Settlement != null && !this.m.Settlement.isNull())
		{
			_out.writeU32(this.m.Settlement.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local dest = _in.readU32();

		if (dest != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(dest));
		}

		local settlement = _in.readU32();

		if (settlement != 0)
		{
			this.m.Settlement = this.WeakTableRef(this.World.getEntityByID(settlement));
		}

		this.contract.onDeserialize(_in);
	}

});
