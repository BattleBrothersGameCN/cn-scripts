this.siege_fortification_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Allies = []
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

		this.m.Type = "contract.siege_fortification";
		this.m.Name = "围攻要塞";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		this.m.MakeAllSpawnsResetOrdersOnContractEnd = false;
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
		this.m.Flags.set("RivalHouseID", this.m.Origin.getOwner().getID());
		this.m.Flags.set("RivalHouse", this.m.Origin.getOwner().getName());
		this.m.Flags.set("WaitUntil", 0.0);
		this.m.Name = "围攻" + this.m.Origin.getName();
		this.m.Flags.set("CommanderName", this.Const.Strings.KnightNames[this.Math.rand(0, this.Const.Strings.KnightNames.len() - 1)]);
		this.m.Payment.Pool = 1550 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"协助围城"
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
				this.Contract.m.Origin.getOwner().addPlayerRelation(-99.0, "在战争中选择了阵营");
				local r = this.Math.rand(1, 100);

				if (r <= 50)
				{
					this.Flags.set("IsTakingAction", true);
					local r = this.Math.rand(1, 100);

					if (r <= 50)
					{
						this.Flags.set("IsAssaultTheGate", true);
					}
					else if (r <= 80)
					{
						this.Flags.set("IsBurnTheCastle", true);
					}
					else
					{
						this.Flags.set("IsPlayerDecision", true);
					}
				}
				else
				{
					this.Flags.set("IsMaintainingSiege", true);
					r = this.Math.rand(1, 100);

					if (r <= 25)
					{
						this.Flags.set("IsNighttimeEncounter", true);
					}
					else
					{
						this.Flags.set("IsReliefAttack", true);
						r = this.Math.rand(1, 100);

						if (r <= 40)
						{
							this.Flags.set("IsSurrender", true);
						}
						else
						{
							this.Flags.set("IsDefendersSallyForth", true);
						}
					}
				}

				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					if (!this.Flags.get("IsSecretPassage") && !this.Flags.get("IsSurrender"))
					{
						this.Flags.set("IsPrisoners", true);
					}
				}

				this.Contract.spawnSiege();
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
				if (this.Contract.isPlayerNear(this.Contract.m.Origin, 300))
				{
					this.Contract.setScreen("TheSiege");
					this.World.Contracts.showActiveContract();

					foreach( a in this.Contract.m.Allies )
					{
						local ally = this.World.getEntityByID(a);

						if (ally != null)
						{
							ally.setAttackableByAI(true);
						}
					}
				}
			}

		});
		this.m.States.push({
			ID = "Running_Wait",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"继续围攻%objective%",
					"拦截任何试图突围的人"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.m.Origin.getDistanceTo(this.World.State.getPlayer()) >= 800)
				{
					this.Contract.setScreen("TooFarAway");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Time.getVirtualTimeF() < this.Flags.get("WaitUntil"))
				{
					return;
				}

				this.Contract.m.Origin.getOwner().addPlayerRelation(-99.0, "在战争中选择了阵营");

				foreach( i, a in this.Contract.m.Allies )
				{
					local ally = this.World.getEntityByID(a);

					if (ally == null || !ally.isAlive())
					{
						this.Contract.m.Allies.remove(i);
					}
				}

				if (this.Contract.isPlayerNear(this.Contract.m.Origin, 300))
				{
					if (this.Flags.get("IsReliefAttackForced"))
					{
						if (this.World.getTime().IsDaytime)
						{
							this.Contract.setScreen("ReliefAttack");
							this.World.Contracts.showActiveContract();
						}
					}
					else if (this.Flags.get("IsSurrenderForced"))
					{
						this.Contract.setScreen("Surrender");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsDefendersSallyForthForced"))
					{
						this.Contract.setScreen("DefendersSallyForth");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsTakingAction"))
					{
						if (this.World.getTime().IsDaytime)
						{
							if (this.Flags.get("IsPlayerDecision"))
							{
								this.Contract.setScreen("TakingAction");
								this.World.Contracts.showActiveContract();
							}
							else
							{
								this.Contract.setState("Running_TakingAction");
							}
						}
					}
					else if (this.Flags.get("IsMaintainingSiege"))
					{
						this.Contract.setScreen("MaintainSiege");
						this.World.Contracts.showActiveContract();
					}
				}
			}

		});
		this.m.States.push({
			ID = "Running_TakingAction",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"参与攻击%objective%"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.m.Origin.getDistanceTo(this.World.State.getPlayer()) >= 800)
				{
					this.Contract.setScreen("TooFarAway");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Time.getVirtualTimeF() < this.Flags.get("WaitUntil"))
				{
					return;
				}

				if (this.Flags.get("IsLost"))
				{
					this.Contract.setScreen("Failure");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsAssaultTheGate") && !this.TempFlags.get("AssaultTheGateShown"))
				{
					this.TempFlags.set("AssaultTheGateShown", true);
					this.Contract.setScreen("AssaultTheGate");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsAssaultAftermath"))
				{
					this.Contract.setScreen("AssaultAftermath");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsAssaultTheCourtyard") && !this.TempFlags.get("AssaultTheCourtyardShown"))
				{
					this.TempFlags.set("AssaultTheCourtyardShown", true);
					this.Contract.setScreen("AssaultTheCourtyard");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsBurnTheCastleAftermath"))
				{
					this.Contract.setScreen("BurnTheCastleAftermath");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsBurnTheCastle") && !this.TempFlags.get("BurnTheCastleShown"))
				{
					this.TempFlags.set("BurnTheCastleShown", true);
					this.Contract.setScreen("BurnTheCastle");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					foreach( i, a in this.Contract.m.Allies )
					{
						local ally = this.World.getEntityByID(a);

						if (ally == null || !ally.isAlive())
						{
							this.Contract.m.Allies.remove(i);
						}
					}

					if (this.Contract.m.Allies.len() == 0)
					{
						this.Contract.setScreen("Failure");
						this.World.Contracts.showActiveContract();
						return;
					}
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "AssaultTheGate")
				{
					this.Flags.set("IsAssaultTheGate", false);
					this.Flags.set("IsAssaultTheCourtyard", true);
				}
				else if (_combatID == "AssaultTheCourtyard")
				{
					this.Flags.set("IsAssaultTheCourtyard", false);
					this.Flags.set("IsAssaultAftermath", true);
				}
				else if (_combatID == "BurnTheCastle")
				{
					this.Flags.set("IsBurnTheCastle", false);
					this.Flags.set("IsBurnTheCastleAftermath", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "AssaultTheGates" || _combatID == "AssaultTheCourtyard" || _combatID == "BurnTheCastle")
				{
					this.Flags.set("IsLost", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_NighttimeEncounter",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"继续围攻%objective%",
					"拦截任何试图突围的人"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.m.Origin.getDistanceTo(this.World.State.getPlayer()) >= 800)
				{
					this.Contract.setScreen("TooFarAway");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Time.getVirtualTimeF() < this.Flags.get("WaitUntil") || this.World.getTime().IsDaytime)
				{
					return;
				}

				if (this.Flags.get("IsNighttimeEncounterLost"))
				{
					this.Contract.setScreen("NighttimeEncounterFail");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsNighttimeEncounterAfermath"))
				{
					this.Contract.setScreen("NighttimeEncounterAftermath");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsNighttimeEncounter") && !this.TempFlags.get("NighttimeEncounterShown"))
				{
					if (!this.World.getTime().IsDaytime)
					{
						this.TempFlags.set("NighttimeEncounterShown", true);
						this.Contract.setScreen("NighttimeEncounter");
						this.World.Contracts.showActiveContract();
					}
				}
				else
				{
					foreach( i, a in this.Contract.m.Allies )
					{
						local ally = this.World.getEntityByID(a);

						if (ally == null || !ally.isAlive())
						{
							this.Contract.m.Allies.remove(i);
						}
					}

					if (this.Contract.m.Allies.len() == 0)
					{
						this.Contract.setScreen("Failure");
						this.World.Contracts.showActiveContract();
						return;
					}
				}
			}

			function onActorRetreated( _actor, _combatID )
			{
				if (!_actor.isPlayerControlled())
				{
					this.Flags.set("IsNighttimeEncounterLost", true);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "NighttimeEncounter")
				{
					this.Flags.set("IsNighttimeEncounter", false);

					if (!this.Flags.get("IsNighttimeEncounterLost"))
					{
						this.Flags.set("IsNighttimeEncounterAfermath", true);
					}
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "NighttimeEncounter")
				{
					this.Flags.set("IsNighttimeEncounterLost", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_SecretPassage",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"在夜晚结束前潜入%objective%",
					"刺杀敌人的指挥官"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
					this.Contract.m.Origin.setOnCombatWithPlayerCallback(this.onSneakIn.bindenv(this));
					this.Contract.m.Origin.setAttackable(true);
				}
			}

			function end()
			{
				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.setOnCombatWithPlayerCallback(null);
					this.Contract.m.Origin.setAttackable(false);
				}
			}

			function update()
			{
				if (this.Flags.get("IsSecretPassageWin"))
				{
					this.Contract.setScreen("SecretPassageAftermath");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsSecretPassageLost"))
				{
					this.Contract.setScreen("SecretPassageFail");
					this.World.Contracts.showActiveContract();
				}
				else if (this.World.getTime().IsDaytime)
				{
					this.Contract.setScreen("FailedToReturn");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					foreach( i, a in this.Contract.m.Allies )
					{
						local ally = this.World.getEntityByID(a);

						if (ally == null || !ally.isAlive())
						{
							this.Contract.m.Allies.remove(i);
						}
					}

					if (this.Contract.m.Allies.len() == 0)
					{
						this.Contract.setScreen("Failure");
						this.World.Contracts.showActiveContract();
						return;
					}
				}
			}

			function onSneakIn( _dest, _isPlayerAttacking = true )
			{
				if (!this.TempFlags.get("IsSecretPassageShown"))
				{
					this.TempFlags.set("IsSecretPassageShown", true);
					this.Contract.setScreen("SecretPassage");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "SecretPassage";
					p.Music = this.Const.Music.NobleTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
					this.Contract.flattenTerrain(p);
					p.Entities = [];
					p.EnemyBanners = [
						this.Contract.m.Origin.getOwner().getBannerSmall()
					];
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.m.Origin.getOwner().getID());
					p.Entities.push({
						ID = this.Const.EntityType.Knight,
						Variant = 0,
						Row = 2,
						Script = "scripts/entity/tactical/humans/knight",
						Faction = this.Contract.m.Origin.getOwner().getID(),
						Callback = this.onEnemyCommanderPlaced
					});
					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
			}

			function onEnemyCommanderPlaced( _entity, _tag )
			{
				_entity.getFlags().set("IsFinalBoss", true);
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getFlags().get("IsFinalBoss") == true)
				{
					this.Flags.set("IsSecretPassageWin", true);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "SecretPassage")
				{
					this.Flags.set("IsSecretPassageWin", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "SecretPassage" && !this.Flags.get("IsSecretPassageWin"))
				{
					this.Flags.set("IsSecretPassageFail", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_ReliefAttack",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"继续围攻%objective%",
					"拦截任何试图突围的人"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.m.Origin.getDistanceTo(this.World.State.getPlayer()) >= 800)
				{
					this.Contract.setScreen("TooFarAway");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Flags.get("IsReliefAttackLost"))
				{
					this.Contract.setScreen("Failure");
					this.World.Contracts.showActiveContract();
					return;
				}

				local isAlive = false;

				foreach( id in this.Contract.m.UnitsSpawned )
				{
					local e = this.World.getEntityByID(id);

					if (e != null && e.isAlive() && e.getFaction() == this.Contract.m.Origin.getOwner().getID())
					{
						isAlive = true;

						if (e.getDistanceTo(this.Contract.m.Origin) <= 250)
						{
							this.onCombatWithPlayer(e, false);
							return;
						}
					}
				}

				if (this.Flags.get("IsReliefAttackWon") || !isAlive)
				{
					this.Contract.setScreen("ReliefAttackAftermath");
					this.World.Contracts.showActiveContract();
					return;
				}

				foreach( i, a in this.Contract.m.Allies )
				{
					local ally = this.World.getEntityByID(a);

					if (ally == null || !ally.isAlive())
					{
						this.Contract.m.Allies.remove(i);
					}
				}

				if (this.Contract.m.Allies.len() == 0)
				{
					this.Contract.setScreen("Failure");
					this.World.Contracts.showActiveContract();
					return;
				}
			}

			function onCombatWithPlayer( _dest, _isPlayerAttacking = true )
			{
				_dest.setPos(this.World.State.getPlayer().getPos());
				local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
				p.CombatID = "ReliefAttack";
				p.Music = this.Const.Music.NobleTracks;
				p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
				p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
				p.AllyBanners.push(this.World.FactionManager.getFaction(this.Contract.getFaction()).getBannerSmall());
				p.EnemyBanners.push(_dest.getBanner());
				this.Contract.flattenTerrain(p);
				local alliesIncluded = false;

				for( local i = 0; i < p.Entities.len(); i = ++i )
				{
					if (this.World.FactionManager.isAlliedWithPlayer(p.Entities[i].Faction))
					{
						alliesIncluded = true;
					}
				}

				if (!alliesIncluded && _dest.getDistanceTo(this.Contract.m.Origin) <= 400)
				{
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());

					foreach( id in this.Contract.m.UnitsSpawned )
					{
						local e = this.World.getEntityByID(id);

						if (e.isAlliedWithPlayer())
						{
							e.die();
							break;
						}
					}
				}

				this.World.Contracts.startScriptedCombat(p, false, true, true);
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "ReliefAttack")
				{
					this.Flags.set("IsReliefAttackWon", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "ReliefAttack")
				{
					this.Flags.set("IsReliefAttackLost", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_DefendersSallyForth",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"继续围攻%objective%",
					"拦截任何试图突围的人"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.m.Origin.getDistanceTo(this.World.State.getPlayer()) >= 800)
				{
					this.Contract.setScreen("TooFarAway");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Flags.get("IsDefendersSallyForthLost"))
				{
					this.Contract.setScreen("DefendersPrevail");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsDefendersSallyForthWon"))
				{
					this.Contract.setScreen("DefendersAftermath");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.Contract.m.Origin.getOwner().addPlayerRelation(-99.0, "在战争中选择了阵营");
					this.Contract.setScreen("DefendersSallyForth");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "DefendersSallyForth")
				{
					this.Flags.set("IsDefendersSallyForthWon", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "DefendersSallyForth")
				{
					this.Flags.set("IsDefendersSallyForthLost", true);
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
				this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + 5.0);
			}

			function update()
			{
				if (this.Flags.get("IsPrisoners") && this.Time.getVirtualTimeF() <= this.Flags.get("WaitUntil"))
				{
					this.Contract.setScreen("Prisoners");
					this.World.Contracts.showActiveContract();
				}

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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer%在桌上摊开一张地图，上面点缀着军事标记，那是代表交战各方军队动向的小木制徽记。这位贵族特别指向其中一个。%SPEECH_ON%我需要你去这里，和%commander%谈谈。他正在围攻那里的要塞，需要你协助完成最后的进攻。你将获得%reward%克朗的报酬，我相信这应该绰绰有余了，不是吗？%SPEECH_OFF% | 你走进%employer%的作战室，原本围在作战地图旁的一群将军和指挥官顿时安静下来。%employer%招手让你过去，把你带到一边。那些军人盯着你看了一会儿，才慢慢回到他们的战略讨论中。%employer%说明了情况。%SPEECH_ON%我有位指挥官%commander%正在围攻%objective%。他需要再多一些人手来发动进攻，这正是你派上用场的时候。去那里帮助他，我会支付你足足%reward%克朗作为回报。听起来很划算，不是吗？%SPEECH_OFF% | 你还没进%employer%的房间，他就闪身出来，一把揽住你的肩膀。他带你走过走廊，来到一扇窗前，一边说话一边凝视着庭院。%SPEECH_ON%我的将军们没必要见到你。他们觉得你的行当不光彩。有时候雇佣佣兵也需要一点政治手腕。%SPEECH_OFF%你摇摇头，简短地回应。%SPEECH_ON%我们杀人，和他们一样。%SPEECH_OFF%贵族点点头。%SPEECH_ON%当然，佣兵，但也许将来某天你会来杀我们。这让我手下的将军们夜不能寐，有的担忧，有的愤怒。我理解我们生活的这个世界的现实，所以我能睡得像个婴儿，明白吗？所以，我们来谈正事。我需要你去%objective%，协助%commander%指挥官进攻那里的要塞。你将获得%reward%克朗作为报酬。%SPEECH_OFF% | 接待了你，并带你到他的花园。鉴于目前的局势，他看起来异常轻松。他轻抚着一串番茄藤，开始说话。%SPEECH_ON%战争真是件要命的事。就在我们说话的时候，人们正在死去，只因我说了几句话。就这么简单。我不想滥用我的权力。%SPEECH_OFF%你将拇指插进腰带回应道。%SPEECH_ON%为了我手下弟兄们着想，我希望你不会。%SPEECH_OFF%%employer%点点头，摘下一个番茄。藤蔓绷紧后断裂。他咬了一口，然后又点点头，仿佛园丁的生活才是他更向往的。%SPEECH_ON%我有一位名叫%commander%的指挥官，目前正在围攻%objective%。他正在敲定发动进攻的计划。相信‘进攻’这个词让你有点紧张，但他为这个计划已经筹备了一段时间。他现在只差最后一点人手，以确保计划能顺利执行。去找他，帮助他，我会支付你%reward%克朗。%SPEECH_OFF% | %employer%带你到一张他的作战地图前。他指着%objective%。%SPEECH_ON%%commander%指挥官目前正在围攻他们的要塞。我需要可靠的人手去协助他发动进攻。去那里，帮助他，我会支付你%reward%克朗。听起来不错，不是吗？%SPEECH_OFF% | 你进入%employer%的房间，发现一群指挥官正围着一张地图。代表贵族家徽的小标记散布在图纸上。一个人用木棍推着一匹木马穿过绘制粗糙的平原。%employer%欢迎了你，但他的一位将军把你拉到一边，说明了他们的需求： \n\n%commander%指挥官目前正在%objective%进行围城。守军即将崩溃，但他担心援军正在路上。他想在援军抵达前发动最后的总攻。去那里，协助指挥官完成他需要做的任何事情，你将获得%reward%克朗的报酬。 | 你在%employer%的门外停下并问自己，你需要惹上这个烂摊子吗？突然，一个仆人抱着一箱克朗撞到了你。他问%employer%是否在里面，因为准备付给佣兵的%reward%克朗已经备好。你迅速挤开仆人进了房间。%employer%热情地欢迎了你。他解释说%commander%指挥官目前正在围攻%objective%，并且即将取得突破。他只差再多一些人手就能一举定乾坤。%employer%假装思考了一下，然后最后补充道。%SPEECH_ON%报酬是%reward%克朗。%SPEECH_OFF%你假装对这个金额感到惊讶。 | 你不确定这场战争对%employer%来说是否顺利，还是他所有的将军在这种时候总是显得这般紧张。他们看起来宁愿自刎也不愿再多盯一秒钟作战地图。%employer%坐在房间的角落里，旁边燃着炉火，一个仆人捧着酒壶。这位贵族招手让你过去，然后开始说话。%SPEECH_ON%别理会那些牢骚鬼。战争很顺利。一切都很顺利。为了向你证明有多顺利，我需要你去%objective%和%commander%指挥官谈谈，因为他对那个要塞的围攻马上就要结束了。胜利在望，你要做的就是帮我拿下它！%reward%克朗听起来怎么样？%SPEECH_OFF% | 你走进%employer%的房间，发现这位贵族瘫在一张看起来很舒适的椅子里。两只大狗在他脚边打盹，一只发出呼噜声的猫卧在他膝上。他完全睡熟了，大声打着鼾，一只滴着酒水的酒杯不知怎的仍被他紧抓在伸出的手中。一位身着将军服饰的男子在房间另一头招呼你过去。%SPEECH_ON%别在意。战争让大人他心力交瘁。现在，听好。我有我的命令，而你也有你的。我们需要你去%objective%，协助%commander%指挥官围攻那里的要塞。就这些。%SPEECH_OFF%你询问报酬。将军的脸色沉了下来。%SPEECH_ON%是的。报酬。当然。我奉命承诺给你%reward%克朗。我希望这对你……光荣的服务来说是足够的。%SPEECH_OFF%最后那几个字似乎让这人很痛苦。很明显他被指示要尽可能表现得客气一些。 | %employer%手下的一位将军在门外大厅里会见你。%SPEECH_ON%大人正忙。%SPEECH_OFF%他把一卷文书拍在你胸前。你展开阅读。根据文书所述，一位名叫%commander%的指挥官正在围攻%objective%并需要帮助。毫无疑问，这正是%companyname%该出场的时候。你抬头看向那人。他咕哝着，咬牙切齿地说道。%SPEECH_ON%你的报酬是%reward%克朗，尊贵的佣兵先生。%SPEECH_OFF%最后那几个字听起来像是别人教他说的。 | 你找到%employer%，他带你到他私人的犬舍。他一边走一边把肉屑扔给狗，一边说着话。%SPEECH_ON%战争进展顺利。这简直是我所经历过的最棒的事情，我对整件事感到无比喜悦。%SPEECH_OFF%他抚摸着一条杂种狗的耳后，然后让狗舔他的手指。%SPEECH_ON%但并非所有事都尽如人意。我需要你去%objective%，援助正在那里指挥围城的%commander%指挥官。%reward%克朗将作为你协助的报酬。%SPEECH_OFF%一个仆人抱着一只活鸡跑过来。贵族抓住鸡腿，把它扔进一个满是狂吠的狗的笼子里。那只家禽疯狂扑腾，在狗的追咬中弹跳，然后突然被逮住。片刻之间就被撕成了碎片。%employer%转向你，拂去你肩膀上的一根羽毛。%SPEECH_ON%那么，我们成交了吗？%SPEECH_OFF% | 你进入%employer%的房间，这里看来已被改造成一个临时的作战室。指挥官们尽职地站在作战地图旁，来回推着军事标记，并就推演结果争论不休。%employer%把你带到一边。他说话时转动着手指上的戒指。%SPEECH_ON%%commander%指挥官需要人手协助围攻%objective%。探子告诉我他接近突破，但需要像你这样的人来真正促成此事。去帮助他，等你回来时，%reward%克朗将在此等候。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "多少钱，你说？",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{这事不划算。 | 我们还有其他任务。 | 我不会让战团在围城中煎熬。}",
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
			ID = "TheSiege",
			Title = "在围攻时……",
			Text = "[img]gfx/ui/events/event_31.png[/img]{你抵达%commander%的营地，发现他的士兵们看似很放松。他们在泥地里铺开的木板上玩骰子，互相开玩笑，还唱着歌。四周旗帜在风中飘扬，大多早已褪去了昔日鲜艳的色彩。有几个人正在重新绑紧投石机的支架。%commander%亲自将你引到他的指挥帐篷。他递给你一杯喝起来像有老鼠在里面洗过澡的饮料。他说明了情况。%SPEECH_ON%我相信你也知道，我们在这里有段时间了，即将取得突破。我需要你和你的人手在一旁待命。一旦进攻时机到来，我会下令开始强攻。%SPEECH_OFF% | %commander%的营地已经把%objective%周围的土地都糟蹋坏了。这么多人日复一日地驻扎，把地面搅成了泥沼。几个士兵在摇动一台劣质、摇晃的投石机的辐条。他们把一只长满蛆的牛头砸进投掷篮，然后松开绳索弹簧，直到这台战争机器的抛射杆猛地向前弹出，将一个旋转、淌血的黑色头颅射向要塞。它弹跳着擦过一个带城垛的堡垒，在墙面上留下一道恶心的污痕滚落下去。一个守军朝这边吼叫。%SPEECH_ON%射得真准啊，你们这群蠢货！%SPEECH_OFF%%commander%拍拍你的肩膀，咧嘴笑着。%SPEECH_ON%欢迎来到前线，佣兵。你和你的手下能来，我非常感激。%objective%已被孤立，但他们拒绝投降，尽管饥肠辘辘，却仍斗志不减。但是饥饿……会削弱他们。当时机成熟时，我将发动强攻，我只需要你们随时待命。%SPEECH_OFF% | %commander%告诉你，%objective%的守军疲惫不堪，补给短缺，即将崩溃。鉴于这些情况，他正在准备最后一次强攻，只需要%companyname%的队员们在时机到来时做好准备。 | %objective%的围城战看起来更像是一场盛大戏剧中的娱乐活动，而非一次集中的军事行动。双方都处于悲惨而窘迫的境地，隔着城墙互相辱骂，间歇则默默诅咒自己这般不幸而身陷如此困境。然而，%commander%眼中闪烁着愉快的光芒来到你面前。%SPEECH_ON%啊，雇佣兵。我跟你讲讲当下的情况吧。我们已经切断了%objective%的食物供应，几天前我们的一个细作成功把他们的粮仓烧成了平地。他们正在挨饿，很快就要撑不住了。因为我们时间紧迫，我正在组织一次全面强攻，以迅速结束这场围城。时机到来时，你们只需做好准备。%SPEECH_OFF% | 你来到%objective%，看到要塞在地平线上显出黑色的轮廓，而%commander%正通过一副皮裹的望远镜凝视着，对他看到的东西愤怒地皱着眉头。他把设备递给你，你接过来看了一眼。\n\n你第一眼看到的是一个男人的屁股在一上一下地晃动，他正用双手拍打着它。他旁边的士兵下巴松弛，两眼斗鸡，正来回套弄着自己的下体。你放下望远镜，懒得再看其他情况。%commander%摇了摇头。%SPEECH_ON%我们切断了他们的食物供应，现在他们疯了。他们以为这很搞笑，但很快我们就会知道谁才能笑到最后。我正在计划一次强攻。我需要你和%companyname%的队员们在命令下达时做好准备。%SPEECH_OFF% | %objective%走到郊外，他的围城营地就建在这里。一排排帐篷里挤满了疲惫且满腹牢骚的士兵。他们煮东西的锅很脏，相互开的玩笑更脏。远处，%objective%尽职的守军从城垛上望过来。指挥官把你带到他的帐篷里说明了情况。%SPEECH_ON%%objective%已经断粮，正在挨饿。不幸的是，我的时间不多了。我们需要尽快强攻这个该死的地方——尽可能的快。当时机到来时，我需要你做好准备。%SPEECH_OFF% | %objective%的郊外已遍布帐篷。%commander%的一个护卫领着你穿过这座围城营地。满腹牢骚的正规军用怀疑的目光打量着你。然而，%commander%却愉快地欢迎你进入他的帐篷。你一走进去，就看到一个人双手被吊着，双脚离地晃荡。另一个人正在一桶泛红的水里清洗匕首。%commander%朝那囚犯一挥手。%SPEECH_ON%啊，佣兵。你刚好错过了好戏。%SPEECH_OFF%你问他刚才在干什么。指挥官走到囚犯面前，用手托起他的下巴，抬起一张疲惫不堪的脸。%SPEECH_ON%我在获取答案。%objective%即将陷落，但我没有时间坐等它发生。我很快就要强攻要塞，届时我需要你和你的手下准备就绪。%SPEECH_OFF% | 你来到%commander%的围城营地，看到士兵们正把一网兜头颅装进投石机，然后发射到%objective%的要塞上空。指挥官本人来到你身边，带着满足的灿烂笑容沉浸在这景象中。%SPEECH_ON%你知道吗，有些头颅是我们自己人的，但我觉得墙那边的蠢货分辨不出来。关键不是谁的头，而是有多少颗，懂吗？来吧，佣兵。%SPEECH_OFF%他带你到他的指挥帐篷，在那里摊开一张地图。%SPEECH_ON%守军已经疲惫了，最新情报告诉我他们几乎断粮，开始为剩饭内斗。但我没有时间等他们自己意识到处境的绝望，我必须强迫他们认清现实。我们不久就要开始强攻。命令下达时，你必须在场。%SPEECH_OFF% | 当你进入%commander%的营地时，他的几个士兵朝你的一个手下吐口水，一场斗殴迅速爆发。幸好指挥官本人出现，平息了事态。他迅速把你带到他的帐篷，你们在里面谈话，而你的手下则站在外面。%SPEECH_ON%我必须为我手下人的行为道歉。当你日复一日地站在泥地里、睡在泥地里，而敌人却睡在床上、隔着城墙辱骂你时，脾气很容易一点就着。\n\n万幸的是，我的一个细作烧毁了%objective%的粮仓和储备，要塞里已经断供。守军一直在挨饿，但我担心我的人没耐心在这里久待。我也担心可能有援军会来试图解围。所有这些都意味着一件事……我即将下令强攻。计划目前正在制定中，我只需要你在命令到来时做好准备。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "%companyname%很快就会准备好。",
					function getResult()
					{
						this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(15, 30));
						this.Contract.setState("Running_Wait");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TakingAction",
			Title = "在围攻时……",
			Text = "[img]gfx/ui/events/event_31.png[/img]{%commander%正在郊外，身边带着一队骑兵，脸色非常难看。他迅速说明了情况。%SPEECH_ON%佣兵，你来得正是时候。我的探子刚报告说，有敌方援军要来为%objective%解围。我们要么现在就发动进攻，要么试着把这该死的地方烧成平地，用烟把他们熏出来。不过如果用后面这法子，最后能接手的东西就不剩什么了。%SPEECH_OFF%奇怪的是，指挥官居然看向你，想听听你的主意。 | %objective%已被%commander%的部队团团包围，但看起来攻城方比守军更加紧张。%commander%亲自把你拉进他的帐篷。他用指关节敲着桌子说明现状。%SPEECH_ON%我的斥候发现一支敌军正前来解围。我们没有足够的兵力，更别说精力，去击退他们了。我们要么立刻发动强攻，要么给投石机装上火弹，把这鬼地方烧成白地。守军无疑会跑出来，但那样我们就只能从废墟里捡点渣滓了。%SPEECH_OFF%接着，令人惊讶地，指挥官抬起头问道。%SPEECH_ON%你觉得我们该怎么办，佣兵？%SPEECH_OFF% | 当你来到%commander%的帐篷时，他和他的副官们正围着一张地图站着，你的到来让一场争论迅速平息。指挥官指着你。%SPEECH_ON%雇佣兵！我们得到消息，有敌方援军要来解围，而我们没有足够的人手去抵挡。我们要么强攻%objective%，要么对这鬼地方实施焦土战术，用火把守军熏出来，然后接收剩下的废墟。我的副官们在这个问题上没能达成一致。你怎么说？由你来投这决定性的一票。%SPEECH_OFF%副官们嘟囔着，但奇怪的是，他们居然同意把这个决定权交到一个佣兵手里。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "要我说，我们全力进攻这座城堡。",
					function getResult()
					{
						this.Flags.set("IsAssaultTheGate", true);
						this.Contract.setState("Running_TakingAction");
						return "AssaultTheGate";
					}

				},
				{
					Text = "要我说，我们火攻城堡，用烟把他们熏出来。",
					function getResult()
					{
						this.Flags.set("IsBurnTheCastle", true);
						this.Contract.setState("Running_TakingAction");
						return "BurnTheCastle";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "AssaultTheGate",
			Title = "在围攻时……",
			Text = "[img]gfx/ui/events/event_31.png[/img]{%commander%已经下令进攻。\n\n{%companyname%和一队贵族士兵将负责攻打正门。你们全都聚集在一辆攻城锤的顶棚下——这东西更像是轮子上的棚屋，而非什么像样的战争机器。所有人手抓住推杆，你们将攻城锤向前推去。顶棚发出一连串梆梆梆的响声，箭矢密集地钉在上面。你抬头看到几只箭头已经穿透了木板。抵达城门后，你命令士兵们将攻城锤向后拉起，然后一声令下，众人放手。\n\n伴随着沉重的橡木发出的嘎吱声，攻城锤猛冲向前，重重撞在城门上。城门从中部裂开，透过缝隙你能看到%objective%的守军正在另一侧严阵以待。又一声命令，又一次撞击。这次它直接撞穿了城门，铰链崩断，两扇门板在飞溅的木屑和金属碎片中轰然倒塌。武器在手，你和所有士兵迅速冲过了城门。 | 在指挥官一队士兵的陪同下，%companyname%推着一辆带顶棚的攻城锤冲向%objective%的城门。几个守军在城头嘲讽你们。%SPEECH_ON%{不先请我们吃个晚饭吗？ | 哼，你们的攻城锤挺长的嘛。想要掩饰啥啊？ | 来啊，你们这些丑八怪杂种。 | 你们就在自己的小窝棚下面向旧神祈祷吧。}%SPEECH_OFF%当你们撞上城门，并用攻城锤一击将其轰开时，他们的嘲讽声戛然而止。你的士兵们迅速从缺口冲了进去。 | 带着指挥官的几名士兵，你和%companyname%推着一辆攻城锤冲向%objective%的城门。顶棚摇晃作响，比起护盾，这更像是一个窝棚。你祈祷它能撑住。箭矢在上方夺夺作响地钉入，另一些则弹开，发出金属刮过木材的刺耳声响。当你们越来越接近%objective%的城门时，箭矢变成了石块，重重地砸在这战争机器的顶棚上。%randombrother%打量着攻城锤，笑了。%SPEECH_ON%爽啊，老兄。%SPEECH_OFF%突然，一阵可怕的嘶嘶声包围了所有人，仿佛你们闯进了蛇窝。一切变得昏暗，因为热油正从顶棚两侧流下。一股油流浇在了一名贵族士兵的背上，他惨叫着向前扑倒，变成了一个尖叫的、由黑色粘稠物构成的魔像。你急忙命令士兵开始撞击。幸好，攻城锤只摆动了一次就将%objective%的城门轰然撞开。你的士兵们迅速从缺口冲入，与前来迎战的少量守军搏斗。} | 进攻%objective%的命令传了下来。你让%companyname%做好准备。你的士兵和%commander%的士兵一起推着一辆攻城锤冲向要塞的前门。箭矢划过天空，在阳光下闪烁，随即呼啸着落入进攻的人群中。有人无声地倒地倒下，有人则捂着伤口倒下。\n\n前门很快被撞开，你的士兵从缺口涌入，冲进中庭，那里有一些%objective%的守军在等待着。 | %commander%下达了开始进攻的命令。你的战队和他的军队冲向要塞，一波攻城抛射物如黑色的冰雹从头顶飞过。城墙遭受重击，守军被迫低头躲避，而%commander%的弓箭手持续施压。你们成功将一辆攻城锤推到前门并迅速将其撞开。当%companyname%冲进去时，%objective%的守军已在中庭里严阵以待。 | 进攻%objective%的命令传了下来。准备工作中，天空因投石和箭矢而变得昏暗，呈现出一派末日景象。火焰窜过%objective%的墙头，你看到%commander%的士兵将梯子架在城垛上，奋力向上攀登并杀入城内。与此同时，你和你的士兵在一辆攻城锤的顶棚下缓慢推进，将其推至前门并迅速撞开。当你们冲进去时，守军挤满了庭院，准备战斗。 | %commander%下达了进攻%objective%的命令。进攻场面如下：箭矢往来使得天空变得昏暗，如雨点般呼啸飞过并相互弹开。投石像冰冷的彗星一样划过天空，然后砸向城墙和塔楼。守军奋力将梯子推离城垛。进攻者爬上梯子，最上面的人举着盾牌，下面的人则用长矛向前刺击。你和%companyname%推着一辆摇摇晃晃的攻城锤来到前门，在这片混乱的掩护下，你们基本未受干扰。\n\n当前门被撞开时，你和你的士兵及时冲了进去，正好遇上一群在那里集结的守军。在四周的城墙上，你能看到%commander%的士兵正在为夺取控制权而拼死战斗。 | 不幸的是，%commander%认为应该正面强攻%objective%。你和%companyname%受命用攻城锤攻打前门。当你们推着这攻城器械穿过泥地时，你注意到城门正上方有个人守着一口冒着热汽的大锅。你环顾四周，看到扛着梯子的士兵开始向城墙冲锋。他们迅速爬上梯子开始搏斗。当你再向前看时，那个守着热油的守军不见了，但有一双腿从锅沿伸了出来。\n\n撞开前门并冲进去时没有遇到任何麻烦。你很快便遇到了一群集结起来的守军，而在四周的城墙上，%commander%的士兵们仍在继续战斗。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "冲锋！",
					function getResult()
					{
						local tile = this.Contract.m.Origin.getTile();
						this.World.State.getPlayer().setPos(tile.Pos);
						this.World.getCamera().moveToPos(this.World.State.getPlayer().getPos());
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "AssaultTheGate";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Contract.flattenTerrain(p);
						p.Entities = [];
						p.AllyBanners = [];
						p.EnemyBanners = [
							this.Contract.m.Origin.getOwner().getBannerSmall()
						];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.m.Origin.getOwner().getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "BurnTheCastle",
			Title = "在围攻时……",
			Text = "[img]gfx/ui/events/event_68.png[/img]{一列弓箭手将箭头插进布团，浸入沥青。当他们举箭待发时，一个少年举着火炬跑过，将所有箭矢点燃。指挥官抬起手，弓箭手们举起他们燃烧的武器。他手落下，弓手们放箭。火箭划破天空，噼啪作响，嘶嘶有声，随后归于寂静，隐约难辨。它们落在要塞内，起初似乎仅此而已。一名士兵呼喊起来，指着开始升起的烟雾。很快，火舌窜向天空。几分钟后，前门猛然洞开，浑身灰烬、烟雾缭绕的守军如同地狱魔像般冲了出来。\n\n%commander%再次举起手臂，但这次手中握着一把剑。%SPEECH_ON%冲锋！%SPEECH_OFF% | 要塞很快浸染在一片橙红之中。烟雾如团块般翻滚，令人窒息的黑。火舌紧随其后，缓缓向上蔓延。前门摇晃了一下，两下，接着猛然敞开。浑身焦黑、咳嗽不止的守军涌了出来，互相推挤着争夺新鲜空气。%commander%拔出剑指向敌人。%SPEECH_ON%不留俘虏！%SPEECH_OFF%%objective%的守军似乎听到了这话，他们迅速集结成阵。刹那间，你不禁猜想，在他们焦黑的身影之中，是否曾有一面投降用的白旗藏于某处。 | 命令下达，要将%objective%付之一炬。你看着%commander%的军营以地狱风暴般的燃烧投石和箭雨点亮了天空。火焰很快从墙后升起，你看到人们浑身是火地四处奔逃。当地狱之火开始吞噬%objective%的内部时，前门打开了，一群焦黑绝望的人冲了出来。看到他们，%commander%下令全军冲锋。 | %commander%命令手下将%objective%点燃。他们给投石机和抛石机装填上用柴火包裹、浸过沥青的石块。点燃之后，这些石块被抛向空中。随后是密集的火箭齐射，深深扎入%objective%的内部，你开始看到浓烟升起。要塞内燃起熊熊大火，没过多久前门就被撞开，人们跑了出来。%commander%拔出他的剑。%SPEECH_ON%他们就在眼前，弟兄们。让我们一劳永逸地结束这一切！%SPEECH_OFF% | 弓箭手开始用布包裹箭头并浸入沥青。孩子们提着油桶跑来跑去，给投石机的弹丸涂抹油脂。准备就绪后，%commander%下令攻击。人类或许曾崇拜火焰，但在这里，它被塑造成一种狂怒的恐怖，呼啸着划过天空，用炽热的毁灭轰击着%objective%。攻城抛射物粉碎了塔楼，击穿了屋顶，将整个地方点燃。守军们身上插着燃烧的箭矢四处奔逃。随着火势加剧，前门打开，烟雾与灰烬构成的魔像猛冲出来，互相踩踏着试图逃离降临到他们头上的地狱。\n\n看到这幅景象，见此情景，%commander%拔出武器。%SPEECH_ON%冲上去，弟兄们，不留俘虏！%SPEECH_OFF% | %commander%命令手下将地狱倾泻到%objective%头上。你看着投石机、抛石机和弓箭手用密集的燃烧弹幕布满天空。要塞迅速被火焰吞没，翻腾成一片火海。绝望的人们打开前门冲了出来，咳嗽着，拼命地互相推挤以争夺空气。%commander%拔出武器，看着这景象大笑起来。%SPEECH_ON%他们来了，他们死定了！冲锋！%SPEECH_OFF% | 前门猛然敞开，一群人猛冲出来。他们互相攀爬，看起来像是活过来的烟与灰，如同一片黑暗的荆棘在大门前展开。%commander%拔出他的武器。%SPEECH_ON%这就是我们一直在等待的，弟兄们。好了，无需再等！冲锋！%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "冲锋！",
					function getResult()
					{
						local tile = this.Contract.m.Origin.getTile();
						this.World.State.getPlayer().setPos(tile.Pos);
						this.World.getCamera().moveToPos(this.World.State.getPlayer().getPos());
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "BurnTheCastle";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Contract.flattenTerrain(p);
						p.Entities = [];
						p.AllyBanners = [
							this.World.Assets.getBanner(),
							this.World.FactionManager.getFaction(this.Contract.getFaction()).getBannerSmall()
						];
						p.EnemyBanners = [
							this.Contract.m.Origin.getOwner().getBannerSmall()
						];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
						p.Entities.push({
							ID = this.Const.EntityType.Knight,
							Variant = 0,
							Row = 2,
							Script = "scripts/entity/tactical/humans/knight",
							Faction = this.Contract.getFaction(),
							Callback = this.Contract.onCommanderPlaced.bindenv(this.Contract),
							Tag = this.Contract
						});
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 200 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.m.Origin.getOwner().getID());
						p.Entities.push({
							ID = this.Const.EntityType.Knight,
							Variant = 0,
							Row = 2,
							Script = "scripts/entity/tactical/humans/knight",
							Faction = this.Contract.m.Origin.getOwner().getID(),
							Callback = null
						});
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
				foreach( id in this.Contract.m.UnitsSpawned )
				{
					local e = this.World.getEntityByID(id);

					if (e != null && e.isAlive())
					{
						e.die();
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "AssaultTheCourtyard",
			Title = "%objective%里……",
			Text = "[img]gfx/ui/events/event_31.png[/img]{%objective%的城门已被攻占，但还有更多事情要做。必须保持攻势：你迅速命令手下向中庭推进。 | 城门虽已拿下，但%objective%的中庭尚未攻陷。你命令%companyname%继续向前推进。 | %companyname%已经夺取了城门，同时，%commander%的士兵们正沿着城墙肃清塔楼。你不想放缓攻势，于是迅速下令继续向中庭进攻 | 当你冲进中庭时，%commander%的士兵们正在上方为争夺城墙控制权而战。 | 你和%companyname%冲进了%objective%的中庭。头顶上方传来%commander%的士兵为争夺城墙控制权而战的叮当声。 | 必须拿下中庭！你和%companyname%冲进要塞内，准备战斗。四周环绕着正在为争夺城墙控制权而战的%commander%的士兵。 | 当你冲进%objective%的中庭时，被杀的守军从上方坠落——他们是%commander%的士兵为拼命夺取城墙控制权而干掉的。 | %commander%的士兵正在猛攻城墙。现在你必须履行你的职责，夺下中庭！ | 在%commander%的士兵夺取城墙的同时，你的任务是拿下中庭。绝不能失败！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "冲锋！",
					function getResult()
					{
						local tile = this.Contract.m.Origin.getTile();
						this.World.State.getPlayer().setPos(tile.Pos);
						this.World.getCamera().moveToPos(this.World.State.getPlayer().getPos());
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "AssaultTheCourtyard";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Contract.flattenTerrain(p);
						p.Entities = [];
						p.AllyBanners = [];
						p.EnemyBanners = [
							this.Contract.m.Origin.getOwner().getBannerSmall()
						];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.m.Origin.getOwner().getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
				foreach( id in this.Contract.m.UnitsSpawned )
				{
					local e = this.World.getEntityByID(id);

					if (e != null && e.isAlive())
					{
						e.die();
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "AssaultAftermath",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_31.png[/img]{%objective%已经陷落。你看着%commander%的士兵们四处搜寻，从那些濒死者在最后绝望中爬进去的角落和缝隙里拖出尸体。尸体有的被烧焦，有的身首分离，有的缺胳膊少腿，被拖行时内脏洒了一地，还有少数几个看起来仿佛只是在睡梦中死去。一名正规军从塔楼的城垛探出身，扯下堡垒的旗帜，升起了%noblefamily%的纹章，引来一片欢呼。 | 尸体遍布中庭，有的像湿衣服一样挂在墙头，有的蜷在角落，脸上带着震惊的表情，你还在一个烧毁的马厩废墟里看到一些焦黑、枯瘦扭曲的形体，这些死者中还有马、猪、狗甚至羽毛凌乱的鸟儿，它们都被那以不可阻挡之势降临此地的暴力所吞噬。\n\n%commander%正在巡视他幸存的部下，祝贺他们干得漂亮。一名士兵在塔楼顶上升起了%noblefamily%的旗帜。这地方有了新主人。 | 强攻结束了，%objective%的守军已被全部肃清。即使当中还有人幸存，也已彻底逃离了此地。%commander%命令一名手下将%noblefamily%的纹章升上一座塔楼，就这样，%objective%的所有权易主了，其确定性就如同那面在风中无力飘动的旗帜。 | 代价惨重，但强攻终于结束了。%commander%踏过尸体，命令手下立即开始清理此地。他的一名士兵升起了%noblefamily%的旗帜，让所有人都能看到今天是谁获胜了。 | 你周围全是%objective%守军的尸体。他们战斗得很英勇，但历史不会记住这一点。他们的名字将被遗忘，他们的存在是徒劳的。你看着%commander%的一名士兵在塔楼上展开他们的旗帜，至少旗子还算好看。 | 零星的战斗仍在继续。你看着%commander%的手下把守军从附近的一座塔楼上扔下去，那些可怜人尖叫着坠亡。当他们都被清除后，一名士兵升起了%noblefamily%的纹章。旗帜在新降临的寂静中猎猎作响。 | 医师们冲进要塞照料%commander%的士兵。%objective%的一些守军也受了伤，但他们只能自生自灭。任何求救的哭喊都会招致刀剑。幸存者很快学会了忍住伤痛不去哭喊。\n\n%noblefamily%的旗帜在前门上方展开。 | %commander%的士兵在%objective%的中庭废墟中翻拣。一名妇女被发现并被抓进一座塔楼。年幼的孩子们哭喊着追在她后面，无人看管，却没人理会他们。%commander%亲自祝贺你干得好。他指着一名正在前门展开%noblefamily%旗帜的士兵。%SPEECH_ON%看到那纹章了吗？它代表着胜利。%SPEECH_OFF%你本以为堆积如山的敌尸才是宣告胜利的有力辞藻，不过一面飘扬的布旗倒也够用了。 | 中庭里尸体堆积如山，鲜血顺着周围的墙壁滴落。%commander%的士兵四处收集所有能找到的武器，并了结他们发现的任何受伤的敌人。他们自己的伤员则由瘦弱的老医师们照料，这些人带着装满草药的袋子和研钵研杵调配药剂。%noblefamily%的旗帜在墙头展开，以确保——万一之前的证据还不够明显的话——%objective%已经易主。 | %objective%的居民被押着列队穿过其要塞，去看他们死去的守军和彻底被摧毁的防御。%commander%跨立在他们面前，拇指插在腰带里，脸上带着得意的微笑。当一名士兵展开%noblefamily%的旗帜时，他指向它。%SPEECH_ON%看到没？这就是你们现在的主子。明白吗？%SPEECH_OFF% | 你看着居民们被押着穿过%objective%。%commander%似乎乐于彰显这场胜利有多么彻底，已经没有反抗的余地了。这倒是无可指摘：失败会让被征服者的心中滋生反叛的念头，这个念头比拿着剑表明敌意的士兵更可怕，因为后者起码可以让对手心无杂念地立刻斩杀。 | %commander%让%objective%的居民排成队，押着他们穿过要塞。他们被迫去看自己守军战败的景象，鲜血尚未凝固，仍在流淌。队列中有一个美丽而身段匀称的女子，指挥官把她拉了出来。他问她是否认识死者中的任何一个。她指向一个面部塌陷的男人。她认出了别在他制服上那朵枯萎的玫瑰——那是今天早上她送给丈夫的。%commander%为她的损失道歉，然后小心地把她送回了队列。他以近乎父亲般的严厉向人群讲话。%SPEECH_ON%你们会被善待。我们会重建这里，你们会有饭吃。但是，别搞错了，%objective%属于%noblefamily%。只要我们能在这点上达成一致，你们就会一切安好。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "胜利！",
					function getResult()
					{
						this.Contract.changeObjectiveOwner();
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BurnTheCastleAftermath",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_68.png[/img]{用火攻逼出%objective%的守军这一招效果拔群。你和%commander%穿过如今无人防守的大门，查看此地还剩下什么。不幸的是，大火把大部分地方都烧成了平地。不过没关系，士兵在其中一座塔楼上升起了%noblefamily%的旗帜。在翻腾的灰烬和浓烟中，你几乎辨认不出上面的纹章。 | 战场上遍布着死者和垂死之人。%commander%的士兵穿过堆积如山的尸体，偶尔将长矛刺向地面，让那里原本微弱的呻吟声彻底沉寂。\n\n你和指挥官穿过%objective%的大门。大火将每一座木制建筑都烧成了焦黑的骨架。庭院里到处都是烧焦的农畜。%commander%耸耸肩，命令一名手下在塔楼上升起%noblefamily%的旗帜，让所有人都知道今天谁赢得了胜利。 | 战斗结束了。用火攻逼出%objective%的守军很可能挽救了许多生命，但大门以内的一切都被火焰净化了。要重建往日的辉煌——无论什么样的辉煌——都需要时间。%commander%似乎相当满意，他命令一名手下在塔楼上升起%noblefamily%的旗帜。彩色的旗面在飘浮的灰烬和烟雾中清脆地翻动。 | %commander%踏过%objective%的灰烬。%SPEECH_ON%嗯，我们拿下它了。至少拿下了它的废墟。不过我没啥好抱怨。干得好，佣兵。%SPEECH_OFF% | %objective%的居民出来查看他们要塞的残骸。女人们在烧焦的尸体中翻找，寻找亲人的任何痕迹。然而，她们只找到自己的男人被烧成了焦黑枯瘦的骨架，面容熔化凝固成他们最后时刻狰狞的表情。%commander%的一名手下在前门上方展开%noblefamily%的旗帜，指挥官迅速指向它。%SPEECH_ON%都听着！看到那个了吗？那就是我们。现在，你们要做的就是尊重它，然后一切都可以恢复常态！要是不尊重，我就会给你们带来一种新常态，明白吗？%SPEECH_OFF%居民们静静地点头。%commander%笑了，那笑容真诚得可怕。%SPEECH_ON%很好！那么，这儿有谁会做超棒的炒鸡蛋吗？%SPEECH_OFF% | 你和%commander%进入%objective%，发现这场战斗最终以守军们争抢空气而告终。焦黑的形体，无论是人是兽，都在相互攀爬堆叠。一个人的手正扯开另一个人的焦尸，他的手指抠掉了对方身上一缕烧焦的肉。你捂住嘴以防呕吐。%commander%命令手下在前门升起%noblefamily%的旗帜。他拍了拍你的肩膀。%SPEECH_ON%嘿，干得不错，佣兵。不过你真该多吸几口这臭味。能帮你更快习惯。%SPEECH_OFF% | 你捂着鼻子穿过%objective%的城墙。%commander%走在你身边，高昂着头，带着一种自带恶臭般的得意。在%objective%内部，你发现尸体被融化的骨肉缠在一起，扭曲脸上裸露在外的牙齿，仿佛在嗤笑被烧死的可怕结局。%commander%拍了拍你的肩膀。%SPEECH_ON%这可是场不小的胜利，知道吗？你该回去找%employer%了，除非你想帮忙清理。%SPEECH_OFF% | 你和%commander%举着剑进入%objective%，但没有什么会反抗你们了：地狱之火吞噬了所有的活物。即使没有被烧死，他们也在灰烬和浓烟中活活呛死。%commander%踢开一些碎石，一具焦尸随之翻滚出来。%SPEECH_ON%见鬼，这儿除了墙没剩下啥了。%SPEECH_OFF%他严肃地看着你。%SPEECH_ON%但墙就是一切。%SPEECH_OFF%你蹲下来看着那个死人。%SPEECH_ON%你觉得他也是这么想的吗？%SPEECH_OFF%指挥官耸耸肩。他迅速转过身，命令一名手下在前门上空展开%noblefamily%的旗帜。 | 你踏进了%objective%但马上就后悔了。尸体到处都是，没有一具还能辨认。火焰把一切都烧黑了，地上的烂泥也不能幸免。%commander%用脚试图翻动一具尸体。血肉碎块发出嘎吱碎裂声，仿佛他踩在了一层薄冰上。这人皱了皱鼻子。%SPEECH_ON%这可真够难看的，你不觉得吗？%SPEECH_OFF%他转过身，吹出一声尖锐的口哨，然后指向他的一名士兵。%SPEECH_ON%你！把%noblefamily%的旗帜升到大门和塔楼上！%SPEECH_OFF%士兵敬礼后匆匆执行任务去了。%commander%拍拍你的肩膀，说%employer%应该对这个结果非常满意。 | 从%objective%中能回收的东西不多：大火几乎吞噬了一切。留下的人，烧死了。冲向塔楼寻求安全的人，窒息而亡。死者的面容清晰地诉说着——这都不是什么好死法。但%commander%似乎很高兴，命令手下开始清理并展开%noblefamily%的旗帜。 | 你在%objective%的残骸中翻找。尸体吸引了你的目光，因为你从未在一个地方见过这么多烧焦的尸体。一具尸体紧抱着一个微小的形体，仔细看发现是一个婴儿。%commander%走过来拍拍你的肩膀。%SPEECH_ON%啊，真可惜。嘿，你干得不错，佣兵。别多想，明白吗？%SPEECH_OFF%你点点头。指挥官短暂地笑了笑，然后命令手下开始在所有能挂的地方升起%noblefamily%的旗帜。最好让外人都知道，这个烧焦的堡垒空壳有了新主人。 | 在%objective%内部，你看到各种焦黑的混乱景象。被点燃的死狗，它们的锁链在火势蔓延前就已长时间灼烧着它们。困在马厩里的马，焦黑的腿僵硬地翘在空中。冲破围栏四处乱跑的猪，无疑全程都烧着火。淡淡的培根香气也难以掩盖令人恐惧的恶臭。这些生物无一逃脱。\n\n你打开一扇储藏室的门，发现一堆窒息而死的守军。%commander%站到你身后，向里看去。%SPEECH_ON%可怜的家伙。他们看起来真年轻。大概是马夫，侍从什么的。真可惜。%SPEECH_OFF%指挥官探身进房间，从一条面包上掸掉一些稻草。他剥掉外层，露出新鲜的内芯。%SPEECH_ON%嘿，你饿吗？%SPEECH_OFF%你礼貌地拒绝了。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "胜利！",
					function getResult()
					{
						this.Contract.changeObjectiveOwner();
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Origin.spawnFireAndSmoke();

				foreach( a in this.Contract.m.Origin.getActiveAttachedLocations() )
				{
					a.spawnFireAndSmoke();
					a.setActive(false);
				}
			}

		});
		this.m.Screens.push({
			ID = "MaintainSiege",
			Title = "在围攻时……",
			Text = "[img]gfx/ui/events/event_31.png[/img]{%commander%的消息传来，称守军可能愈发虚弱。他希望避免伤亡惨强的强攻，转而采取单纯围困的策略。你接到指示，在接到进一步通知前，在围城营地待命。 | %commander%的一名副官通知你，指挥官已决定再等待一段时间，希望守军会主动投降，而非将战斗拖延下去。%companyname%需要在此等待，直至接到进一步通知。 | 有消息传来，围城状态将再维持一段时间。你接到指示，需等待一段时间，直至接到进一步通知。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "%companyname%很快就会准备好。",
					function getResult()
					{
						if (this.Flags.get("IsNighttimeEncounter"))
						{
							this.Contract.setState("Running_NighttimeEncounter");
						}
						else if (this.Flags.get("IsReliefAttack"))
						{
							this.Flags.set("IsReliefAttackForced", true);
							this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(15, 30));
							this.Contract.setState("Running_Wait");
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "NighttimeEncounter",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_33.png[/img]{%commander%命令你和队员们外出巡逻。巡视过程中，你发现几个%objective%的守军正从堡垒墙边的河床溜出来。他们正在通过某种密道。你迅速思考，下令队员们向他们冲锋，希望能在对方发现你们之前抢占通道。绝不能放跑任何一个混蛋溜回密道！ | 当你还在观望围城局势时，%commander%过来命令你和%companyname%开始巡视%objective%的外围防御。\n\n结果你瞧，就在你们四处走动时，看到几个%objective%的守军正偷偷钻过一个暗门。你蹲下身子仔细观察。当暗门关上时，你看到门顶覆盖着苔藓和杂草以掩盖其位置。如果你现在离开去报告%commander%，很可能会被对方发现并摧毁通道。你决定抓住时机下令攻击。%companyname%必须确保不让任何守军逃脱！ | 随着围城战陷入僵持，你决定主动请缨，询问能否让%companyname%参与巡逻。稍微走动一下能让队员们保持警觉和活力。不然他们也只能在营地闲逛，和那些正规军起冲突。%commander%同意了。\n\n巡逻开始没几分钟，你就发现几个%objective%的守军正从一个简陋护城河的堤岸爬上来。他们是通过靠近防御城墙的一个排污口游进来的。%randombrother%摇了摇头。%SPEECH_ON%真他妈见鬼。%SPEECH_OFF%你让他保持安静。如果守军发现他们的密道暴露了，肯定会将其封闭。你等到所有守军都来到开阔地带，然后下令攻击。绝不能让任何守军逃脱！ | 巡逻任务下达，你自告奋勇让%companyname%负责这项工作。你的队员们嘟嘟囔囔地抱怨，但这类任务有助于让这些大兵保持警觉和活力。但是这样的任务有助于让这些杂兵们振奋精神和保持警觉。\n\n发现一群%objective%的守军正从密道溜出来，也是振奋精神的好方法！外出活动不到几分钟，你就发现守军正在这么做。你看着守军们整理装备，就在他们准备潜入外围地带时，你下令发动攻击。绝不能让这些守军有任何逃脱的机会！ | 随着围城持续，%commander%命令你和你的队员开始巡视%objective%周围的防御工事。巡逻到一半时，你的队员们偶然发现几个守军正从密道溜出来——那是个污秽不堪的格栅，位于齐胸深的护城河中。抢占这个通道将为日后带来巨大的战术优势。你迅速下令队员们攻击——并且绝不能允许任何守军逃脱！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "抓住他们！",
					function getResult()
					{
						local tile = this.Contract.m.Origin.getTile();
						this.World.State.getPlayer().setPos(tile.Pos);
						this.World.getCamera().moveToPos(this.World.State.getPlayer().getPos());
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "NighttimeEncounter";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Contract.flattenTerrain(p);
						p.Entities = [];
						p.EnemyBanners = [
							this.Contract.m.Origin.getOwner().getBannerSmall()
						];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.m.Origin.getOwner().getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "NighttimeEncounterFail",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_33.png[/img]{真该死。几个守军设法溜回了密道，你已经听到通道被封闭的声音了。 | 你的动作不够快，没能拦住所有守军，让几个人跑掉了。他们溜回了%objective%，并在身后封闭了通道。 | 唉，本来的关键目标是杀掉那些溜出来的人并夺取密道。结果反而让几个人逃回了%objective%，还把身后的通道给封死了。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "该死的！",
					function getResult()
					{
						this.Flags.set("IsNighttimeEncounterLost", false);
						this.Flags.set("IsNighttimeEncounter", false);
						this.Flags.set("IsReliefAttack", true);
						this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(15, 30));
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "NighttimeEncounterAftermath",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_33.png[/img]{你成功杀死了所有守军并占领了密道。当你向%commander%报告这个消息时，他命令你通过密道潜入，刺杀%objective%的指挥官。你有几个小时的准备时间，但事不宜迟，必须在今夜结束前行动。 | 杀光了所有守军后，你成功占领了密道。你回到%commander%那里说明了情况。他郑重地点了点头，然后转向你。%SPEECH_ON%我要你从密道潜入，进入要塞内部，刺杀他们的首领。%SPEECH_OFF%与正面强攻的方案相比，这次夜间行动是你一段时间以来听到的最合意的任务了。 | 密道已被占领，消息也报告给了%commander%。他大笑着摇了摇头。%SPEECH_ON%我们已经等这种机会这么久了，结果你第一次巡逻出去，就找到了打开%objective%的钥匙。%SPEECH_OFF%他表示希望你和%companyname%通过通道潜入并刺杀其领导层。一旦完成，守军将群龙无首，%objective%就能轻松拿下。要么这么干，要么尝试正面强攻，而你对后者毫无兴趣。你还有几个小时准备，但任务必须在今夜结束前执行。 | 一名守军尖声呼救。%SPEECH_ON%他们发呃——%SPEECH_OFF%%randombrother%迅速用布捂住那人的嘴，然后割开了他的喉咙。你观察%objective%的城墙上有无动静，但看来没人听到这声喊叫。\n\n回到围城营地，你被%commander%拦下了。他正等着好消息，而你带来的正是这个。这位首领跺了跺脚。%SPEECH_ON%众神在上，这是我几周来听到的最好的消息！好吧，这太棒了，但我们需要采取行动，而且要快。我要你和你的手下从那条通道溜进去，刺杀%objective%的领导层。我们需要尽快行动，最多等几个小时，明白吗？%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们会做好准备然后偷偷潜入。",
					function getResult()
					{
						this.Flags.set("IsSecretPassage", true);
						this.Contract.setState("Running_SecretPassage");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "FailedToReturn",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_33.png[/img]{你未能成功刺杀守军领袖，由于他们的指挥官依然在位，%commander%不得不取消了围城。尽管围城的失败并非全是你的责任，但%employer%很可能会这么认为。 | 密道已经被堵住了！已被封死！守军指挥官依然健在，强攻要塞的代价将过于高昂。%commander%取消了围城，而你为此受到了不少指责。 | 唉，你动用密道的行动太慢了。守军必定是起了疑心，不再保持其畅通，用一堆石头把它堵死了。守军仍在他们稳健的指挥官领导下，强攻工事对%commander%的军队而言代价会非常高昂。他取消了围城。%employer%是不会高兴的。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "该死的！",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "在围攻时擅离职守。" + this.Flags.get("ObjectiveName"));
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SecretPassage",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_33.png[/img]{你和%companyname%悄无声息地穿过通道。隧道墙壁滴着屎尿，你跋涉而过的积水也同样污秽。%randombrother%抱怨了几句，但你让他闭嘴。\n\n%randombrother% 抱怨了一下，但你让他闭嘴。\n\n从另一头出来，你们涌入了中庭，战团沿着一排灌木潜行，然后匍匐在地观察四周。\n\n几名守军在四处走动。他们唉声叹气，呻吟抱怨。饥饿让他们的肚子咕咕作响，诅咒挂在嘴边。很快，就看到指挥官在一队精锐护卫的陪同下出现。他正穿过中庭进行巡视。你不会得到比这更好的机会了，当即下令攻击！ | %companyname%和你打开了密道。你发现一个小马童正从里面出来，手里拿着一卷写有所需物资清单的卷轴。他乞求饶命，但你现在不能冒任何风险。%randombrother%割开他的喉咙，把他淹死在从隧道里流出的污物中。你们继续前进，涌入中庭。你和手下沿着一排灌木潜行，观察了一段时间。\n\n等待中，一个身着指挥官服饰的人走下一段台阶，身后跟着一队护卫。你觉得不会再有比这更好的机会了，于是下令攻击！ | 密道黑暗而浑浊，流经隧道的水充满了屎尿。你卷起裤腿开始向内走。火把会暴露你们，所以你们在黑暗中摸索着墙壁前进。你不知道手指触碰到了什么可怕的东西，也希望永远不知道。最终，远端闪烁起微弱的光芒，你们溜出通道，进入一个中庭。\n\n%objective%的指挥官正在检阅他的部队，但他停下来转身看向你和%companyname%这盛大且臭气熏天的登场。他睁大了眼睛，一手指着你们，另一只手摸向武器。%SPEECH_ON%有刺客！%SPEECH_OFF%你下令%companyname%发动攻击！ | 密道到达%objective%城墙另一边的路程短得惊人。隧道另一端有个站岗的人。他看见你和手下的人影从黑暗中走来。他问道。%SPEECH_ON%我向所有的旧神祈祷，你们带来了我们要的东西。记住，我要了鸡蛋和……%SPEECH_OFF%片刻之间，他看到了%randombrother%从阴影中浮现的脸，又过了片刻，他意识到眼前的陌生人绝不是跑腿的。那守卫向后踉跄，但还没等他喊出声求救，你的佣兵就把刀刃捅进了他的胸膛，两人一起飞进了灌木丛。解决了他之后，你们悄悄潜入%objective%，发现其指挥官正在中庭里操练。\n\n没有比这更好的机会了，你下令%companyname%发动攻击！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "冲锋！",
					function getResult()
					{
						this.Contract.getActiveState().onSneakIn(null, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SecretPassageAftermath",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_31.png[/img]{%objective%的指挥官已倒下，他的部下迅速放下了武器。一名副官举起双手，急促地说道。%SPEECH_ON%我们对继续这场必输无疑的战斗毫无兴趣。唯一想打的人已经死在那儿了。我们投降。%SPEECH_OFF%%employer%必定会对这个转折感到非常高兴。 | 战斗结束后，你找到了垂死的%objective%守军指挥官。当你从他身上跨过时，他正吐着血。%SPEECH_ON%我们永不投降。杀了我吧，你们这些可鄙的佣兵。%SPEECH_OFF%你一剑刺入了他的眼窝。他的一名副官丢下武器，举起了双手。%SPEECH_ON%嘿，他是这儿唯一想守住这个地方的人。现在它是你们的了。饶我们一命吧！%SPEECH_OFF%你命令%randombrother%发出信号，告诉%commander%这座要塞已经被拿下。 | %objective%的指挥官死了，他的部下不约而同地立刻投降了。他们解释说，只有指挥官还想继续坚守这个地方。显然，他是在贵族家族内部争宠，以为一次英勇的防御能为他赢得在权贵席位上的一席之地。好吧，现在他死在了泥地里。你让%randombrother%发出信号，好让%commander%知道%objective%已经投降。一名守军向你求饶。%SPEECH_ON%你肯定会饶我们一命的，对吧？%SPEECH_OFF%你擦拭着刀刃，耸了耸肩。%SPEECH_ON%这不归我管。我的雇主和他率领的军队马上就要从那个门进来了。他怎么想，我可不知道。你想要我大发善心，那就捡起武器，我的手下会给你个痛快。%SPEECH_OFF%那名守军皱了皱眉，点点头。%SPEECH_ON%我想……我还是在他那儿碰碰运气吧。%SPEECH_OFF% | %objective%的指挥官死在了泥地里。他幸存的部队全都举起了双手。你命令手下把这些守军铐起来，同时你发出信号，将你的纹章旗从塔楼一侧垂下。%commander%的围城营地吹响号角作为回应。战斗结束了。%employer%无疑会非常满意。 | 战斗结束了，%objective%的首领死在了烂泥里。被抽走了主心骨，守军立刻放弃了抵抗。你命令%companyname%将他们围住并拷起来。%randombrother%前去向%commander%发出要塞已被攻占的信号。%employer% 无疑会很高兴见你回去。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们做到了！",
					function getResult()
					{
						this.Contract.changeObjectiveOwner();
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SecretPassageFail",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_33.png[/img]{不幸的是，你未能进入刺杀指挥官的预定位置，不得不撤退。当你和队员们从隧道溜回时，%objective%的守军发出嘲弄的嘘声。待你们退回外面，听到通道被彻底封死的声音。看来要攻占%objective%，必须采取更为艰难的途径了。 | 战斗并未如你所愿地进行。你和%companyname%被逼退至通道处，且战且退。当你们撤回外面时，听到石块坠落的巨响——守军已将通道彻底封死。你已竭尽全力，但攻占%objective%看来不会如你希望的那么容易了。 | 平心而论，守军干得很出色。他们虽疲惫饥饿，却如困兽般拼死战斗。当你撤退到%objective%的城墙外时，清楚地听到了通道被彻底封死的声音。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "该死的！",
					function getResult()
					{
						this.Flags.set("IsSecretPassage", false);
						this.Flags.set("IsReliefAttackForced", true);
						this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(15, 30));
						this.Contract.setState("Running_Wait");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ReliefAttack",
			Title = "在围攻时……",
			Text = "[img]gfx/ui/events/event_90.png[/img]{%commander%的斥候带回消息，一支援军正前来试图为%objective%解围。指挥官点了点头，命令手下准备战斗。你也照做了。 | 在等待期间，几名斥候返回并进入了%commander%的帐篷。你跟着他们进去，看见指挥官一边点头一边收拾他的东西。他看向你解释道。%SPEECH_ON%一支敌方援军正在赶来。他们打算来解围。让你的人准备好。%SPEECH_OFF% | {你看着%randombrother%和一名正规军士兵在掰手腕。他们用一只无头鸡当赌注。赢家饱餐一顿，输家手臂酸痛。 | 一名围城士兵和%randombrother%正要开始一场瞪眼比赛。谁先眨眼谁就输。赢家得到一只鸡。 | 你发现%randombrother%正朝着泥地里的一个木桩投掷大石头。一名围城部队的士兵也在做同样的事。看来他们是为了一只鸡在比赛，现在到了最后一投定胜负的时刻。} 就在他们要开始前，一名斥候冲进营地，报告说一支敌军正前来试图为%objective%解围。%commander%命令手下做好准备。你也向%companyname%重复了这道命令。 | %commander%的斥候已带回消息，一支敌军正前来试图为%objective%解围。你命令%companyname%为一场大战做好准备。 | 一场大战迫在眉睫：%commander%的斥候已带回消息，一支敌方援军正前来试图打破这场围城。准备迎战！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "准备战斗！",
					function getResult()
					{
						this.Contract.spawnReliefForces();
						this.Contract.setState("Running_ReliefAttack");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ReliefAttackAftermath",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_86.png[/img]{敌方援军已被击败，溃退出了战场。%objective%的守军无疑目睹了整场战斗，士气遭受重挫。他们投降恐怕只是时间问题了！ | 好哇！敌方援军已经被干脆利落地解决了。%commander%感谢你的援助。他用皮裹的望远镜观察着%objective%的城墙，笑了。%SPEECH_ON%哦，他们已经是群丧家之犬了。他们全看见了。我这辈子都没见过这么绝望的一帮人。%SPEECH_OFF%他咧嘴笑着拍了拍你的肩膀。%SPEECH_ON%佣兵，我看这场围城快要结束了！%SPEECH_OFF% | 你们成功击退了敌方援军！那很可能是%objective%最后的希望了，他们随时都可能投降。 | %commander%感谢你协助摧毁了敌方援军。他认为%objective%现在随时都可能投降。 | 眼睁睁看着世上唯一的希望被歼灭，对士气恐怕没什么好处。%objective%的守军目睹了他们的援军被屠杀，无疑他们现在已濒临投降的边缘。 | 好了，%objective%最后的希望已被彻底粉碎。你和%commander%商议后一致认为：守军无疑已准备投降。这只是时间问题。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "他们不可能一直撑下去。",
					function getResult()
					{
						this.Flags.set("IsReliefAttackForced", false);

						if (this.Flags.get("IsSurrender"))
						{
							this.Flags.set("IsSurrenderForced", true);
						}
						else if (this.Flags.get("IsDefendersSallyForth"))
						{
							this.Flags.set("IsDefendersSallyForthForced", true);
						}

						this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(10, 20));
						this.Contract.setState("Running_Wait");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Surrender",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_31.png[/img]%objective%投降了！\n\n{你穿过敞开的大门，发现里面的守军横七竖八地倒了一地。饥饿的人们痛苦地蜷缩着，其他人倚靠在墙边，干裂的嘴唇在乞求水时不住开裂。没有活着的动物。它们早就被宰杀殆尽了。黑色的鸟儿确实在城墙上俯视着，仿佛与你们一同征服此地，只待时机进行掠夺。%commander%拍拍你的肩膀，感谢你的帮助。 | 前门哐当一声打开，你以胜利者的姿态走了进去。然而，所有胜利带来的荣誉都被内部的景象驱散了。死去的守军被堆在一个角落。有几个人因食人而被钉死，但即使那些被处决的人身上也显现出被啃食过的痕迹。庭院一侧有个烧焦的粮仓。一些人坐着，嘴巴黢黑，显然是试图吞下烧焦的谷物残渣。每一只动物都被宰杀，啃得只剩骨头。\n\n %commander%对着这番景象大笑，命令手下开始给囚犯上镣铐。他转向你。%SPEECH_ON%谢谢你，佣兵。你现在可以回去见%employer%了。%SPEECH_OFF% | 在堡垒内部，你发现守军站成一排。%commander%的两名士兵正沿着队列行进，一个拖着锁链，另一个则用那些锁链把这些人铐在一起。你看到一具尸体被插在马厩顶上，风标穿胸而出，心脏挂在上面，如同某种仪式的血腥结局。%commander%大笑着走过来。%SPEECH_ON%那是他们的指挥官。{他们说他不肯投降，自己从塔楼上跳了下来。 | 他拒绝投降，所以他的手下把他从塔楼上扔了下来。}%SPEECH_OFF%有意思。%employer%会非常高兴再次见到你的。 | 在城墙内，%commander%的士兵正在收缴守军的武器，并把它们堆成一大摞。守军自己则蜷缩在一个角落，每个人都反剪双手戴着镣铐，低着头，眼睛盯着泥地。几个卫兵看守着他们，偶尔踢上几脚，吐口水，甚至扬言要杀了他们。全都是拿他们取乐。\n\n%commander%走过来拍拍你的背。%SPEECH_ON%干得漂亮，佣兵。非常感谢你的帮助。回%employer%那里去吧。你在这里的工作结束了。%SPEECH_OFF% | 穿过大门，你发现守军在乞求饶命。他们的军官死在泥地里，身上几十处刺伤仍在渗血。一个人解释道。%SPEECH_ON%我们早就想投降了，但他不让！我们不想再打这场战争了。%SPEECH_OFF%%commander%走到你身边点了点头。%SPEECH_ON%你在这里的工作完成了，佣兵。去吧，去见%employer%。%SPEECH_OFF%你问他打算怎么处置这些囚犯。他耸耸肩。%SPEECH_ON%不知道。我想我会先吃点东西。也许给我的亲人们写封信。我尽量不草率处理这些事。%SPEECH_OFF%有道理。 | 你和%commander%穿过敞开的大门。里面，少数幸存的守军蜷缩着，手脚并用地乞求食物。他们几乎无法直起身子乞求，腹部因剧痛而深陷。%SPEECH_ON%求求你们！给点……%SPEECH_OFF%%commander%把一只靴子踩在一个人身上，把他推倒。%SPEECH_ON%我们看起来像是来帮忙的吗？%SPEECH_OFF%指挥官转向你。%SPEECH_ON%干得好，佣兵。回去找%employer%吧。你在这里的工作结束了。%SPEECH_OFF% | 穿过大门，你发现守军正被驱赶到一个角落围起来。%commander%问他们谁是头儿。这群人齐刷刷地指向中庭对面。一个死人吊在其中一座塔楼上，面色苍白，手和鼻子都发紫了。一个俘虏解释道。%SPEECH_ON%如果我们不这么做，你们现在还站在外面，而我们还在里面挨饿。%SPEECH_OFF%%commander%点了点头。%SPEECH_ON%好吧。我不会为此惩罚你们。佣兵！你回去找%employer%吧。你在这里的工作结束了。%SPEECH_OFF% | 的指挥官正挥舞着一把长剑，而%commander%的几个手下用长矛把他逼到了角落。随着一次整齐的猛冲，他们像对付野兽一样把他刺穿了。被长矛钉住无法动弹后，他放弃了，向前倾倒，双臂搭在木杆上，仿佛懒洋洋地倚着一些栅栏柱。%SPEECH_ON%呵，看来我栽在你们手上了。%SPEECH_OFF%他转向他的手下——看起来，正是他们实际打开了大门。%SPEECH_ON%下辈子再找你们算账。%SPEECH_OFF%鲜血从他口中涌出，他的身体抽搐了一下，然后就没了动静。士兵们收回长矛，这位首领直接栽进了泥地里。%commander%站在他身旁对你说道。%SPEECH_ON%好了，佣兵。回去见%employer%吧。%SPEECH_OFF% | 要塞内部是一片恐怖的景象。人们四处倒卧，紧捂腹部，有的已经死了，有的但求一死。此地的指挥官吊在一座塔楼上，一条家族旗帜缠在脖子上，仿佛这能给他的死亡带来些许尊严。动物的骨头散落在庭院里，屎、尿和呕吐物像坑洼一样遍布四处。%commander%来到你身边点了点头。%SPEECH_ON%看来就这么结束了。真可惜他们没有早点投降。%SPEECH_OFF%你暗示说，大概就是那个挂在家族旗帜下晃荡的指挥官拒绝投降。指挥官又点了点头。%SPEECH_ON%是啊。他认为那样做是光荣的。换作以前我可能也会这么想，但看到这一切之后，我不太确定他是对的了。%SPEECH_OFF% | 穿过大门，你发现守军聚集在一处礼拜堂外。剩下的人不多了，而且没有一个在祈祷。死者被堆在一个角落，并且有被吃食的痕迹。周围没有动物。马厩里苍蝇肆虐，它们疯狂的嗡嗡声几乎震耳欲聋。猪圈被彻底踏平。一个俘虏抬头看着你。%SPEECH_ON%我们能吃的全都吃了。你明白吗？全、都、吃、了。%SPEECH_OFF%%commander%走到你身边。%SPEECH_ON%别管他们，佣兵。回去找%employer%吧。他肯定在等你了。%SPEECH_OFF% | 你和%commander%穿过前门。里面的守军与其说是活人不如说是骷髅，他们相应地蹒跚移动着。一个人粘到你肩膀上。%SPEECH_ON%吃的！吃的！%SPEECH_OFF%他的呼吸带着饥饿的可怕恶臭。你把他摔到地上，他在那里哭喊起来，并开始往嘴里塞泥土。%commander%嚼着一片涂了黄油的面包来到你身边。%SPEECH_ON%这些混蛋看起来真够惨的，是吧？%SPEECH_OFF%面包屑从他嘴里喷出来，俘虏们盯着那些碎屑，仿佛那是金子。指挥官拍拍你的肩膀。%SPEECH_ON%回去见%employer%吧，听到这个好消息他一定会非常高兴的。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "%objective%已经陷落！",
					function getResult()
					{
						this.Contract.changeObjectiveOwner();
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				foreach( id in this.Contract.m.UnitsSpawned )
				{
					local e = this.World.getEntityByID(id);

					if (e != null && e.isAlive())
					{
						e.die();
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "DefendersSallyForth",
			Title = "在围攻时……",
			Text = "[img]gfx/ui/events/event_78.png[/img]{一声刺耳的巨响打破了围城营地的喧嚣。你向外望去，看到%objective%的大门正在打开，一队人马冲了出来。%commander%从他的帐篷里冲出来，只看了一眼，就开始朝手下吼叫。%SPEECH_ON%出击！他们出击了！他们来了，弟兄们，他们来了！准备好！把这些鼠辈杂种赶尽杀绝，听到没有？%SPEECH_OFF%围城营地爆发出响应的咆哮。你迅速集结%companyname%，准备加入战斗。 | %objective%的守军主动出击了！你命令手下做好准备，随时加入%commander%的战斗。 | 根本就没有人打算投降！%objective%的守卫正主动出击。他们看起来是一群虚弱和饥肠辘辘的家伙，但似乎他们宁可战死于此也不愿投降。%commander%命令他的人做好准备，你也对%companyname%下达了同样的指令。 | %objective%的大门正在打开！起初，仅此而已，接着传来低沉的咆哮，一小队守军开始向外行进。他们振臂高呼，吼着自己家族的战号。 他们带着声势逼近，而你们将以暴力还击。准备战斗！ | 生锈铰链的刺耳声响在围城营地上空回荡。你望向%objective%，看到它的大门缓缓打开。一队人马行进而出，高举旗帜，手握武器。他们看起来仿佛已经打输了一仗，拖着饥饿的身躯蹒跚前行。%commander%摇了摇头。%SPEECH_ON%那些蠢货。他们为什么不直接投降？%SPEECH_OFF%你耸耸肩，转向%companyname%。%SPEECH_ON%如果他们想死，那就如他们所愿。拿起武器，弟兄们！%SPEECH_OFF% | %randombrother%来到你身边，指着%objective%的大门。%SPEECH_ON%看，长官。%SPEECH_OFF%你看着大门缓缓打开。一队人马蹒跚而出。他们举着的不是白旗，而是他们家族的徽记。你跑到%commander%那里，告诉他守军正在主动出击。他点了点头。%SPEECH_ON%我知道他们很顽强，但这太可悲了。没有人应该如此毫无意义地死去。%SPEECH_OFF%你差点脱口而出：如果真是这样，一开始就不该有人在这儿干这些破事了。但你忍住了，转身出去让%companyname%的队员们准备战斗。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "让我们做个了结吧！",
					function getResult()
					{
						local tile = this.Contract.m.Origin.getTile();
						this.World.State.getPlayer().setPos(tile.Pos);
						this.World.getCamera().moveToPos(this.World.State.getPlayer().getPos());
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "DefendersSallyForth";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Contract.flattenTerrain(p);
						p.Entities = [];
						p.AllyBanners = [
							this.World.Assets.getBanner(),
							this.World.FactionManager.getFaction(this.Contract.getFaction()).getBannerSmall()
						];
						p.EnemyBanners = [
							this.Contract.m.Origin.getOwner().getBannerSmall()
						];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 90 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
						p.Entities.push({
							ID = this.Const.EntityType.Knight,
							Variant = 0,
							Row = 2,
							Script = "scripts/entity/tactical/humans/knight",
							Faction = this.Contract.getFaction(),
							Callback = this.Contract.onCommanderPlaced.bindenv(this.Contract)
						});
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 200 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.m.Origin.getOwner().getID());
						p.Entities.push({
							ID = this.Const.EntityType.Knight,
							Variant = 0,
							Row = 2,
							Script = "scripts/entity/tactical/humans/knight",
							Faction = this.Contract.m.Origin.getOwner().getID(),
							Callback = null
						});
						this.Contract.setState("Running_DefendersSallyForth");
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
				foreach( id in this.Contract.m.UnitsSpawned )
				{
					local e = this.World.getEntityByID(id);

					if (e != null && e.isAlive())
					{
						e.die();
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "DefendersPrevail",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_22.png[/img]难以置信，疲惫不堪的%objective%守军竟然赢了！随着围城瓦解，你只得撤退。",
			Image = "",
			List = [],
			Options = [
				{
					Text = "这场围攻已经失败了。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "失败于围攻 " + this.Flags.get("ObjectiveName"));
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "DefendersAftermath",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_31.png[/img]{%objective%的守军已被全歼，要塞门户大开。你和%commander%穿过敞开的大门，发现到处都是尸体、垃圾和被宰杀的动物，尽是绝望的血腥痕迹。指挥官点点头，拍了拍你的肩膀。%SPEECH_ON%干得好，佣兵。你现在该回去找%employer%报告这个消息了。%SPEECH_OFF% | 战斗结束了，%objective%的守军被彻底击败，他们的要塞门户大开，任人占领。%commander%感谢了你的效力，随后解除了%companyname%在战场上的任务。你现在该去见见那位应当非常开心的%employer%了。 | %objective%的守军确实进行了一次顽强的反击，但他们若想采取这样的行动，本该在几周前实力与英勇尚存时进行。现在都无所谓了。饿死的人和吃饱的人看起来没什么两样，而且时间一久，他们看起来都会一个样。\n\n%commander%过来告诉你，他已经不需要%companyname%继续效力了。你表示同意，并打算回去找%employer%领取报酬了。 | 在饥饿且领导无方时主动出击，从来都不是什么好主意。你不确定如果%objective%的守军投降了，%commander%是否会宽恕他们。而现在，他们都死在了泥地里，那个他们选择放弃抵抗的可能结果早已错过。你集结%companyname%的队员，命令他们准备行军返回%employer%处。经过这一天，薪酬将会格外动人。 | 清除了%objective%的守军后，你和%commander%进入了要塞。这些人如此绝望是有原因的：里面的状况简直惨不忍睹。死人被剥光衣服堆在角落里。一个烤肉叉上挂着的像是猪的残骸，但很难分辨，因为他们把那只动物吃得干干净净。一个吊死的人在其中一座塔楼上晃荡。他们在他胸口钉了块木板，上面写着‘食人者’，字迹可能是用他自己的血写成的。\n\n%commander%大笑起来。%SPEECH_ON%看起来这儿可真够热闹的，是吧？下次哪个一本正经的好斗军官叫你死守到底时，记住这景象。%SPEECH_OFF% | %companyname%和%commander%的军队干净利落地击败了主动出击的%objective%守军。随着要塞空置，%commander%的士兵迅速接管了它。指挥官亲自过来告诉你去见%employer%领酬劳。 | %objective%的守军死在了战场上，但若说有什么不同，那这战场倒是一片慈悲之地。要塞内几乎没剩下任何有价值的东西，尤其是，食物已完全彻底耗尽。仿佛墙内的世界从来就不知道食物为何物，守军已将这个地方搜刮得一干二净。你确信，仅仅提及食物都是一种罪行，因为哪怕是对味道的一句描述，也如同鞭子抽打在一个人咕咕作响的胃上。%commander%来到你身边笑了起来。%SPEECH_ON%我以为我知道饥饿是什么滋味，但我总能找到办法解决，你明白吗？我从未在毫无解决办法的情况下挨过饿。多么可怕的事情。不过话说回来，他们还是找到解决办法了，不是吗？%SPEECH_OFF%你点了点头，而他还在为自己的黑色幽默发笑。%SPEECH_ON%你干得很好，佣兵。去吧，%employer%会付给你丰厚的报酬。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "%objective%已经陷落！",
					function getResult()
					{
						this.Contract.changeObjectiveOwner();
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Prisoners",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_53.png[/img]{你的几个手下设法俘虏了一些%objective%的守军。他们挤作一团，被你的佣兵们用武器围住。有些人在瑟瑟发抖。其中一个连靴子都没有。另一个则吓尿了裤子。%randombrother%询问该如何处置他们。 | %randombrother%报告说俘虏了几名%objective%的守军。你过去看到一群人挤在一起，抱成一团，但都低着头。其中一人喊道。%SPEECH_ON%求求你们，别杀我们！我们只是奉命行事，就像你们一样！%SPEECH_OFF% | 你的手下成功俘虏了几名%objective%的守军。他们被集中起来，剥得只剩裤子，并被命令脸朝下趴在泥地里。%randombrother%询问该如何处置他们。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "放他们走。%rivalhouse%或许会领了这份好意。",
					function getResult()
					{
						return "PrisonersLetGo";
					}

				},
				{
					Text = "他们可能还有些价值。把他们带给%commander%当战俘。",
					function getResult()
					{
						return "PrisonersSold";
					}

				},
				{
					Text = "与其在以后的战斗中再面对他们，不如现在就杀了他们。",
					function getResult()
					{
						return "PrisonersKilled";
					}

				}
			],
			function start()
			{
				this.Flags.set("IsPrisoners", false);
			}

		});
		this.m.Screens.push({
			ID = "PrisonersLetGo",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_53.png[/img]{战俘对你们或其他任何人来说都毫无用处。你放了他们，只希望自己不会为这个决定后悔。 | 你放了战俘。他们哭着感谢你，但你只希望这么做不会铸成大错。 | 你把战俘放走了。他们离开前挨个感谢你，但愿从此再无交集。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "今天死的人够多了。",
					function getResult()
					{
						this.World.Assets.addMoralReputation(2);
						this.World.FactionManager.getFaction(this.Flags.get("RivalHouseID")).addPlayerRelation(5.0, "在战斗结束后放走了他们的人");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "PrisonersKilled",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_53.png[/img]{你朝%randombrother%点了点头。%SPEECH_ON%全杀了。%SPEECH_OFF%战俘们站了起来，但是他们已经毫无生路，被逐一屠杀了。 | 这些带戴镣铐的人没有什么用处，但是如果他们获得自由，很可能改日会回来与你再战。你下令处决他们，随之而来的是一阵疯狂的乞求声和割喉声。 | 在这样的战争中，没有粮食来收容这么多战俘，在你们仍身处敌境时，他们也毫无用处。但若放他们走，他们很可能改日又会对你刀剑相向。\n\n 想到这里，你下令处决他们。抗议的声音稍纵即逝，淹没在了喉咙被割开、砍断的汩汩声中。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "还是去处理更重要的事情吧……",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-2);

						if (this.World.FactionManager.isCivilWar())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnPartyDestroyed);
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "PrisonersSold",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_53.png[/img]{你把俘虏押送到%commander%那里。这些人被排成一列，指挥官在他们面前来回踱步。%SPEECH_ON%这个。这个。他。还有他。剩下的全杀了。%SPEECH_OFF%几个幸运儿——恰巧是这群人里块头最大、看起来最能干的——被拉了出来。其余的人则被长矛刺穿胸膛，当场处决。%commander%递给你一些克朗。%SPEECH_ON%感谢你抓住他们。他们会派上好用场，干点重活。%SPEECH_OFF% | 俘虏们被带到%commander%面前。他下令把这些人铐起来并安排去做苦力。指挥官为这批俘虏付给了你一笔可观的报酬。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "还是去处理更重要的事情吧……",
					function getResult()
					{
						this.World.Assets.addMoney(250);
						this.World.Assets.addMoralReputation(-1);
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]250[/color]克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{你向%employer%报告%objective%已被攻占，现已处于控制之下。这人用手掩饰着笑意，保持着相当的镇定，仿佛贵族不应屈尊像平民那样失态地兴奋。他只是点了点头，好像这消息本在预料之中。%SPEECH_ON%好。很好。理所当然。%SPEECH_OFF%他打了个响指，一名仆人递给你装有%reward_completion%克朗的钱袋。 | 你走进%employer%的房间，一群指挥官、副官以及贵族本人顿时安静下来。他挺直了身子。%SPEECH_ON%我的鸟儿已经报告了%objective%被攻占的消息。你的报酬在外面。%SPEECH_OFF%这些首领几乎没表达任何谢意，不过就你而言，%reward_completion%克朗本身就是谢意了。 | 你进入%employer%的作战室。一群指挥官正围在桌旁的地图边。你看着他们将一枚标记推到了%objective%上。%employer%咧嘴笑了。%SPEECH_ON%那些人虽然嘴上不说，但我们对你的工作成果非常满意。我的密探带回的消息让我确信我的钱在你身上没有白花。%SPEECH_OFF%这位贵族亲自将一袋%reward_completion%克朗交给你。 | %employer%的房间如同忙碌的蜂巢。指挥官们跑来跑去，无论他们在房间的哪一边、距离多远，都在互相争吵，而仆人们则低头穿梭，确保他们得到充足的饮食。战争可不是把精力浪费在捡自己的斗篷或做饭这种可怜事上的时候。你甚至惊讶于没有仆人在他们争吵的间隙把食物直接喂到他们嘴里。\n\n然而，%employer%只是独自待在一边。他正在翻着一本书，仿佛独自在一个鸟语花香的花园里。他抬起头。瞥了他的将军们一眼，然后看向你。%SPEECH_ON%干得不错。你的报酬。%SPEECH_OFF%一个箱子被缓缓推到你面前。里面装着%reward_completion%克朗。 | 一名仆人拦住你，没让你进入%employer%的房间。他解释道。%SPEECH_ON%我奉命在此等候你，并送上这%reward_completion%克朗。%SPEECH_OFF%你接过袋子，点了点头。 | 你试图进入%employer%的房间，但一名护卫拦住了你。%SPEECH_ON%只限贵族入内。%SPEECH_OFF%你把护卫的长戟从面前推开，声称你有事要找%employer%。护卫把长戟又放了下来。%SPEECH_ON%只限贵族入内。%SPEECH_OFF%就在你准备争辩时，一个仆人拿着一个大袋子从房间里走了出来。他看到了%companyname%的徽记，便把袋子递给你。%SPEECH_ON%你的%reward_completion%克朗。大人和他的指挥官们都很忙。%SPEECH_OFF%然后仆人就这么走了。护卫俯视着你。%SPEECH_ON%只限贵族入内。%SPEECH_OFF% | 协助攻占%objective%的报酬是%reward_completion%克朗，以及一扇在你面前砰然关上的门。%employer%正忙于和他的指挥官们争吵，无暇给予你更多的祝贺。 | %employer%手下的一名指挥官在前厅会见你。他带着一个仆人，仆人拿着一个大袋子。指挥官开口说道。%SPEECH_ON%啊，%companyname%。你们的行当可没什么荣誉可言，佣兵。你该做个真正的男人，为贵族而战。像我们这样做事充满荣耀。为什么不加入我们？%SPEECH_OFF%那袋沉甸甸的%reward_completion%克朗被放到你手中。你对着指挥官微笑，牙齿边缘反射出金色的光。%SPEECH_ON%是啊，为什么呢？%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "%objective%陷落了。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "参加围攻" + this.Flags.get("ObjectiveName"));
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isCivilWar())
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
			ID = "Failure",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_22.png[/img]真是一场灾难。战斗失败了，你选择撤退以保全剩余的人手。%objective%短期内是不会陷落了。",
			Image = "",
			List = [],
			Options = [
				{
					Text = "该死的鬼地方！",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "失败于围攻 " + this.Flags.get("ObjectiveName"));
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TooFarAway",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_36.png[/img]{你似乎完全忘记了时间这回事。尽管你缺席了，围城战仍试图继续，但最终因缺乏预期中的%companyname%支援而瓦解。不用再费事回去见%employer%了。 | 你受雇是来协助围城，而非放弃围城。没有%companyname%在侧，士兵们很可能不得不从战场撤离。 | 你离围城战场太远了！没有你的援助，进攻方被迫撤退，%objective%也因此免于被%employer%征服。考虑到这正是你受雇要去协助达成的目标，你最好还是别回去见那位贵族大人了。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "对哦，我把围城给忘了……",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function spawnReliefForces()
	{
		local tile;
		local originTile = this.m.Origin.getTile();

		while (true)
		{
			local x = this.Math.rand(originTile.SquareCoords.X - 8, originTile.SquareCoords.X + 8);
			local y = this.Math.rand(originTile.SquareCoords.Y - 8, originTile.SquareCoords.Y + 8);

			if (!this.World.isValidTileSquare(x, y))
			{
				continue;
			}

			tile = this.World.getTileSquare(x, y);

			if (tile.getDistanceTo(originTile) <= 4)
			{
				continue;
			}

			if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Mountains)
			{
				continue;
			}

			break;
		}

		local enemyFaction = this.m.Origin.getOwner();
		local party = enemyFaction.spawnEntity(tile, this.m.Origin.getOwner().getName() + "军队", true, this.Const.World.Spawn.Noble, 200 * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + enemyFaction.getBannerString());
		party.getSprite("banner").setBrush(enemyFaction.getBannerSmall());
		party.setDescription("听命于当地领主的职业军人。");
		party.setFootprintType(this.Const.World.FootprintsType.Nobles);
		party.getLoot().Money = this.Math.rand(50, 200);
		party.getLoot().ArmorParts = this.Math.rand(0, 25);
		party.getLoot().Medicine = this.Math.rand(0, 5);
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

		party.setAttackableByAI(false);
		this.m.UnitsSpawned.push(party.getID());
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(originTile);
		c.addOrder(move);
		local wait = this.new("scripts/ai/world/orders/wait_order");
		wait.setTime(10.0);
		c.addOrder(wait);
	}

	function spawnSupplyCaravan()
	{
		local tile;
		local originTile = this.m.Origin.getTile();

		while (true)
		{
			local x = this.Math.rand(originTile.SquareCoords.X - 7, originTile.SquareCoords.X + 7);
			local y = this.Math.rand(originTile.SquareCoords.Y - 7, originTile.SquareCoords.Y + 7);

			if (!this.World.isValidTileSquare(x, y))
			{
				continue;
			}

			tile = this.World.getTileSquare(x, y);

			if (tile.getDistanceTo(originTile) <= 4)
			{
				continue;
			}

			if (!tile.HasRoad)
			{
				continue;
			}

			break;
		}

		local enemyFaction = this.m.Origin.getOwner();
		local party = enemyFaction.spawnEntity(tile, "补给车队", false, this.Const.World.Spawn.NobleCaravan, this.Math.rand(100, 150), this.getMinibossModifier());
		party.getSprite("base").Visible = false;
		party.setMirrored(true);
		party.setDescription("一支有武装护卫的商队，在定居点间运送粮草、物资和装备。");
		party.addToInventory("supplies/ground_grains_item");
		party.addToInventory("supplies/ground_grains_item");
		party.addToInventory("supplies/ground_grains_item");
		party.addToInventory("supplies/ground_grains_item");
		party.getLoot().Money = this.Math.rand(0, 100);
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(originTile);
		move.setRoadsOnly(true);
		c.addOrder(move);
		local despawn = this.new("scripts/ai/world/orders/despawn_order");
		c.addOrder(despawn);
	}

	function spawnSiege()
	{
		this.m.SituationID = this.m.Origin.addSituation(this.new("scripts/entity/world/settlements/situations/besieged_situation"));

		foreach( a in this.m.Origin.getActiveAttachedLocations() )
		{
			if (this.Math.rand(1, 100) <= 50)
			{
				a.spawnFireAndSmoke();
				a.setActive(false);
			}
		}

		local f = this.World.FactionManager.getFaction(this.getFaction());
		local castles = [];

		foreach( s in f.getSettlements() )
		{
			if (s.isMilitary())
			{
				castles.push(s);
			}
		}

		if (castles.len() == 0)
		{
			castles = clone f.getSettlements();
		}

		local originTile = this.m.Origin.getTile();
		local lastTile;

		for( local i = 0; i < 2; i = ++i )
		{
			local tile;

			while (true)
			{
				local x = this.Math.rand(originTile.SquareCoords.X - 1, originTile.SquareCoords.X + 1);
				local y = this.Math.rand(originTile.SquareCoords.Y - 1, originTile.SquareCoords.Y + 1);

				if (!this.World.isValidTileSquare(x, y))
				{
					continue;
				}

				tile = this.World.getTileSquare(x, y);

				if (tile.getDistanceTo(originTile) == 0)
				{
					continue;
				}

				if (tile.Type == this.Const.World.TerrainType.Ocean)
				{
					continue;
				}

				if (i == 0 && !tile.HasRoad && !this.m.Origin.isIsolatedFromRoads())
				{
					continue;
				}

				if (lastTile != null && tile.ID == lastTile.ID)
				{
					continue;
				}

				break;
			}

			lastTile = tile;
			local party = f.spawnEntity(tile, castles[this.Math.rand(0, castles.len() - 1)].getName() + "战团", true, this.Const.World.Spawn.Noble, castles[this.Math.rand(0, castles.len() - 1)].getResources(), this.getMinibossModifier());
			party.setDescription("听命于当地领主的职业军人。");
			party.setVisibilityMult(2.5);

			if (i == 0)
			{
				party.getSprite("body").setBrush("figure_siege_01");
				party.getSprite("base").Visible = false;
			}
			else
			{
				party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
			}

			party.setAttackableByAI(false);
			this.m.UnitsSpawned.push(party.getID());
			this.m.Allies.push(party.getID());
			party.getLoot().Money = this.Math.rand(50, 200);
			party.getLoot().ArmorParts = this.Math.rand(0, 25);
			party.getLoot().Medicine = this.Math.rand(0, 5);
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
			c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
			c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
			local wait = this.new("scripts/ai/world/orders/wait_order");
			wait.setTime(9000.0);
			c.addOrder(wait);
		}
	}

	function changeObjectiveOwner()
	{
		if (this.m.Origin.getFactionOfType(this.Const.FactionType.Settlement) != null)
		{
			this.m.Origin.getOwner().removeAlly(this.m.Origin.getFactionOfType(this.Const.FactionType.Settlement).getID());
		}

		this.m.Origin.removeFaction(this.m.Origin.getOwner().getID());
		this.World.FactionManager.getFaction(this.getFaction()).addSettlement(this.m.Origin.get());

		if (this.m.Origin.getFactionOfType(this.Const.FactionType.Settlement) != null)
		{
			this.World.FactionManager.getFaction(this.getFaction()).addAlly(this.m.Origin.getFactionOfType(this.Const.FactionType.Settlement).getID());
		}

		if (this.m.SituationID != 0)
		{
			this.m.Origin.removeSituationByInstance(this.m.SituationID);
			this.m.SituationID = 0;
		}

		this.m.Origin.addSituation(this.new("scripts/entity/world/settlements/situations/conquered_situation"), 3);
	}

	function flattenTerrain( _p )
	{
		if (_p.TerrainTemplate == "tactical.hills_steppe")
		{
			_p.TerrainTemplate = "tactical.steppe";
		}
		else if (_p.TerrainTemplate == "tactical.hills_tundra")
		{
			_p.TerrainTemplate = "tactical.tundra";
		}
		else if (_p.TerrainTemplate == "tactical.hills_snow" || _p.TerrainTemplate == "forest_snow")
		{
			_p.TerrainTemplate = "tactical.snow";
		}
		else if (_p.TerrainTemplate == "tactical.hills" || _p.TerrainTemplate == "tactical.mountain")
		{
			_p.TerrainTemplate = "tactical.plains";
		}
		else if (_p.TerrainTemplate == "tactical.hills" || _p.TerrainTemplate == "tactical.mountain")
		{
			_p.TerrainTemplate = "tactical.plains";
		}
		else if (_p.TerrainTemplate == "tactical.forest_leaves" || _p.TerrainTemplate == "tactical.forest" || _p.TerrainTemplate == "tactical.autumn")
		{
			_p.TerrainTemplate = "tactical.plains";
		}
		else if (_p.TerrainTemplate == "tactical.swamp")
		{
			_p.TerrainTemplate = "tactical.plains";
		}
	}

	function onCommanderPlaced( _entity, _tag )
	{
		_entity.setName(this.m.Flags.get("CommanderName"));
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"objective",
			this.m.Flags.get("ObjectiveName")
		]);
		_vars.push([
			"noblefamily",
			this.World.FactionManager.getFaction(this.getFaction()).getName()
		]);
		_vars.push([
			"rivalhouse",
			this.m.Flags.get("RivalHouse")
		]);
		_vars.push([
			"commander",
			this.m.Flags.get("CommanderName")
		]);
		_vars.push([
			"direction",
			this.m.Origin == null || this.m.Origin.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Origin.getTile())]
		]);
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
					local c = e.getController();
					c.clearOrders();

					if (e.isAlliedWithPlayer())
					{
						local wait = this.new("scripts/ai/world/orders/wait_order");
						wait.setTime(60.0);
						c.addOrder(wait);
					}
				}
			}

			if (this.m.Origin != null && !this.m.Origin.isNull())
			{
				this.m.Origin.getSprite("selection").Visible = false;
				this.m.Origin.setOnCombatWithPlayerCallback(null);
				this.m.Origin.setAttackable(false);
			}

			if (this.m.Home != null && !this.m.Home.isNull())
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
		if (!this.World.FactionManager.isCivilWar())
		{
			return false;
		}

		if (this.m.Origin == null || this.m.Origin.isNull() || this.m.Origin.getFaction() == this.getFaction())
		{
			return false;
		}

		return true;
	}

	function onSerialize( _out )
	{
		this.contract.onSerialize(_out);
		_out.writeU8(this.m.Allies.len());

		foreach( ally in this.m.Allies )
		{
			_out.writeU32(ally);
		}
	}

	function onDeserialize( _in )
	{
		this.contract.onDeserialize(_in);
		local numAllies = _in.readU8();

		for( local i = 0; i < numAllies; i = ++i )
		{
			this.m.Allies.push(_in.readU32());
		}
	}

});
