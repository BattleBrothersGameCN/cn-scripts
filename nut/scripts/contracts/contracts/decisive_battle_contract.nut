this.decisive_battle_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Warcamp = null,
		WarcampTile = null,
		Dude = null,
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

		this.m.Type = "contract.decisive_battle";
		this.m.Name = "会战";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
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

		if (this.m.WarcampTile == null)
		{
			local settlements = this.World.EntityManager.getSettlements();
			local lowest_distance = 99999;
			local best_settlement;
			local myTile = this.m.Home.getTile();

			foreach( s in settlements )
			{
				if (this.World.FactionManager.isAllied(this.getFaction(), s.getFaction()))
				{
					continue;
				}

				local d = s.getTile().getDistanceTo(myTile);

				if (d < lowest_distance)
				{
					lowest_distance = d;
					best_settlement = s;
				}
			}

			this.m.WarcampTile = myTile.getTileBetweenThisAnd(best_settlement.getTile());
			this.m.Flags.set("EnemyNobleHouse", best_settlement.getOwner().getID());
		}

		this.m.Flags.set("CommanderName", this.Const.Strings.KnightNames[this.Math.rand(0, this.Const.Strings.KnightNames.len() - 1)]);
		this.m.Payment.Pool = 1600 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
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

		this.m.Flags.set("RequisitionCost", this.beautifyNumber(this.m.Payment.Pool * 0.25));
		this.m.Flags.set("Bribe", this.beautifyNumber(this.m.Payment.Pool * 0.35));
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"前往军营，向%commander%报到",
					"协助军队对抗%feudfamily%"
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
				this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).addPlayerRelation(-99.0, "在战争中选择了阵营");

				if (this.Contract.m.WarcampTile == null)
				{
					local settlements = this.World.EntityManager.getSettlements();
					local lowest_distance = 99999;
					local best_settlement;
					local myTile = this.Contract.m.Home.getTile();

					foreach( s in settlements )
					{
						if (this.World.FactionManager.isAllied(this.Contract.getFaction(), s.getFaction()))
						{
							continue;
						}

						local d = s.getTile().getDistanceTo(myTile);

						if (d < lowest_distance)
						{
							lowest_distance = d;
							best_settlement = s;
						}
					}

					this.Contract.m.WarcampTile = myTile.getTileBetweenThisAnd(best_settlement.getTile());
				}

				local tile = this.Contract.getTileToSpawnLocation(this.Contract.m.WarcampTile, 1, 12, [
					this.Const.World.TerrainType.Shore,
					this.Const.World.TerrainType.Ocean,
					this.Const.World.TerrainType.Mountains,
					this.Const.World.TerrainType.Forest,
					this.Const.World.TerrainType.LeaveForest,
					this.Const.World.TerrainType.SnowyForest,
					this.Const.World.TerrainType.AutumnForest,
					this.Const.World.TerrainType.Swamp
				], false, false, true);
				tile.clear();
				this.Contract.m.WarcampTile = tile;
				this.Contract.m.Warcamp = this.WeakTableRef(this.World.spawnLocation("scripts/entity/world/locations/noble_camp_location", tile.Coords));
				this.Contract.m.Warcamp.onSpawned();
				this.Contract.m.Warcamp.getSprite("banner").setBrush(this.World.FactionManager.getFaction(this.Contract.getFaction()).getBannerSmall());
				this.Contract.m.Warcamp.setFaction(this.Contract.getFaction());
				this.Contract.m.Warcamp.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Warcamp.getTile().Pos, 500.0);
				local r = this.Math.rand(1, 100);

				if (r <= 40)
				{
					this.Flags.set("IsScoutsSighted", true);
				}
				else
				{
					this.Flags.set("IsRequisitionSupplies", true);
					r = this.Math.rand(1, 100);

					if (r <= 33)
					{
						this.Flags.set("IsAmbush", true);
					}
					else if (r <= 66)
					{
						this.Flags.set("IsUnrulyFarmers", true);
					}
					else
					{
						this.Flags.set("IsCooperativeFarmers", true);
					}
				}

				r = this.Math.rand(1, 100);

				if (r <= 40)
				{
					if (this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getSettlements().len() >= 2)
					{
						this.Flags.set("IsInterceptSupplies", true);
						local myTile = this.Contract.m.Warcamp.getTile();
						local settlements = this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getSettlements();
						local lowest_distance = 99999;
						local highest_distance = 0;
						local best_start;
						local best_dest;

						foreach( s in settlements )
						{
							if (s.isIsolated())
							{
								continue;
							}

							local d = s.getTile().getDistanceTo(myTile);

							if (d < lowest_distance)
							{
								lowest_distance = d;
								best_dest = s;
							}

							if (d > highest_distance)
							{
								highest_distance = d;
								best_start = s;
							}
						}

						this.Flags.set("InterceptSuppliesStart", best_start.getID());
						this.Flags.set("InterceptSuppliesDest", best_dest.getID());
					}
				}
				else if (r <= 80)
				{
					this.Flags.set("IsDeserters", true);
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
					"前往军营，向%commander%报到"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Warcamp) && !this.Flags.get("IsWarcampDay1Shown"))
				{
					this.Flags.set("IsWarcampDay1Shown", true);
					this.Contract.setScreen("WarcampDay1");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Running_WaitForNextDay",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"待在军营里，听候指令"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Warcamp))
				{
					if (this.World.getTime().Days > this.Flags.get("LastDay"))
					{
						if (this.Flags.get("NextDay") == 2)
						{
							this.Contract.setScreen("WarcampDay2");
						}
						else
						{
							this.Contract.setScreen("WarcampDay3");
						}

						this.World.Contracts.showActiveContract();
					}
				}
			}

		});
		this.m.States.push({
			ID = "Running_Scouts",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"拦截%feudfamily%的斥候，最后看到他们是在%direction%方向",
					"不要让任何人活着逃脱"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = false;
				}

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onCombatWithScouts.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsScoutsFailed"))
					{
						this.Contract.setScreen("ScoutsEscaped");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("ScoutsCaught");
						this.World.Contracts.showActiveContract();
					}
				}
				else if (this.Flags.get("IsScoutsRetreat"))
				{
					this.Flags.set("IsScoutsRetreat", false);
					this.Contract.m.Destination.die();
					this.Contract.m.Destination = null;
					this.Contract.setScreen("ScoutsEscaped");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatWithScouts( _dest, _isPlayerAttacking = true )
			{
				local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
				properties.CombatID = "Scouts";
				properties.Music = this.Const.Music.NobleTracks;
				properties.EnemyBanners = [
					this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getBannerSmall()
				];
				this.World.Contracts.startScriptedCombat(properties, _isPlayerAttacking, true, true);
			}

			function onActorRetreated( _actor, _combatID )
			{
				if (_combatID == "Scouts")
				{
					this.Flags.set("IsScoutsFailed", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Scouts")
				{
					this.Flags.set("IsScoutsRetreat", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_ReturnAfterScouts",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"回到军营"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Warcamp) && !this.Flags.get("IsReportAfterScoutsShown"))
				{
					this.Flags.set("IsReportAfterScoutsShown", true);
					this.Contract.setScreen("WarcampDay1End");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Running_Requisition",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"在军营%direction%方的%objective%处征收粮草。"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = false;
				}

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Destination) && !this.TempFlags.get("IsReportAfterRequisitionShown"))
				{
					this.TempFlags.set("IsReportAfterRequisitionShown", true);
					this.Contract.setScreen("RequisitionSupplies2");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsRequisitionRetreat") && !this.Flags.get("IsRequisitionCombatDone"))
				{
					this.Flags.set("IsRequisitionCombatDone", true);
					this.Contract.setScreen("BeatenByFarmers");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsRequisitionVictory") && !this.Flags.get("IsRequisitionCombatDone"))
				{
					this.Flags.set("IsRequisitionCombatDone", true);
					this.Contract.setScreen("PoorFarmers");
					this.World.Contracts.showActiveContract();
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Ambush" || _combatID == "TakeItByForce")
				{
					this.Flags.set("IsRequisitionRetreat", true);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Ambush" || _combatID == "TakeItByForce")
				{
					this.Flags.set("IsRequisitionVictory", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_ReturnAfterRequisition",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"回到军营"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = true;
				}

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Warcamp))
				{
					if (this.Flags.get("IsInterceptSupplies") || this.Flags.get("IsDeserters"))
					{
						this.Contract.setScreen("WarcampDay1End");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("WarcampDay2End");
						this.World.Contracts.showActiveContract();
					}
				}
			}

		});
		this.m.States.push({
			ID = "Running_InterceptSupplies",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"拦截从%supply_start%到%supply_dest%的补给队。"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = false;
				}

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setVisibleInFogOfWar(true);
				}
			}

			function update()
			{
				if (this.Flags.get("IsInterceptSuppliesSuccess"))
				{
					this.Contract.setScreen("SuppliesIntercepted");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.m.Destination == null || this.Contract.m.Destination != null && this.Contract.m.Destination.isNull())
				{
					this.Flags.set("IsInterceptSuppliesFailure", true);
					this.Contract.setScreen("SuppliesReachedEnemy");
					this.World.Contracts.showActiveContract();
				}
			}

			function onPartyDestroyed( _party )
			{
				if (_party.getFlags().has("ContractSupplies"))
				{
					this.Flags.set("IsInterceptSuppliesSuccess", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_ReturnAfterIntercept",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"回到军营"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = true;
				}

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Warcamp))
				{
					this.Contract.setScreen("WarcampDay2End");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Running_Deserters",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"沿着脚印追寻逃兵",
					"要么说服他们回来，要么杀了他们"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = false;
				}

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Flags.get("IsDesertersFailed"))
				{
					if (this.Contract.m.Destination != null)
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
					}

					this.Contract.setState("Running_ReturnAfterIntercept");
				}
				else if (this.Contract.m.Destination == null || this.Contract.m.Destination != null && this.Contract.m.Destination.isNull())
				{
					this.Contract.setScreen("DesertersAftermath");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerNear(this.Contract.m.Destination, this.Const.World.CombatSettings.CombatPlayerDistance / 2) && !this.TempFlags.get("IsDeserterApproachShown"))
				{
					this.TempFlags.set("IsDeserterApproachShown", true);
					this.Contract.setScreen("Deserters2");
					this.World.Contracts.showActiveContract();
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Deserters")
				{
					this.Flags.set("IsDesertersFailed", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_FinalBattle",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"为%noblehouse%赢得战斗"
				];
			}

			function update()
			{
				if (this.Flags.get("IsFinalBattleLost") && !this.Flags.get("IsFinalBattleLostShown"))
				{
					this.Flags.set("IsFinalBattleLostShown", true);
					this.Contract.m.Warcamp.die();
					this.Contract.m.Warcamp = null;
					this.Contract.setScreen("BattleLost");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsFinalBattleWon") && !this.Flags.get("IsFinalBattleWonShown"))
				{
					this.Flags.set("IsFinalBattleWonShown", true);
					this.Contract.m.Warcamp.die();
					this.Contract.m.Warcamp = null;
					this.Contract.setScreen("BattleWon");
					this.World.Contracts.showActiveContract();
				}
				else if (!this.TempFlags.get("IsFinalBattleStarted"))
				{
					this.TempFlags.set("IsFinalBattleStarted", true);
					local tile = this.Contract.getTileToSpawnLocation(this.Contract.m.Warcamp.getTile(), 3, 12, [
						this.Const.World.TerrainType.Shore,
						this.Const.World.TerrainType.Ocean,
						this.Const.World.TerrainType.Mountains,
						this.Const.World.TerrainType.Forest,
						this.Const.World.TerrainType.LeaveForest,
						this.Const.World.TerrainType.SnowyForest,
						this.Const.World.TerrainType.AutumnForest,
						this.Const.World.TerrainType.Swamp,
						this.Const.World.TerrainType.Hills
					], false);
					this.World.State.getPlayer().setPos(tile.Pos);
					this.World.getCamera().moveToPos(this.World.State.getPlayer().getPos());
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "FinalBattle";
					p.Music = this.Const.Music.NobleTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.Entities = [];
					p.AllyBanners = [
						this.World.Assets.getBanner(),
						this.World.FactionManager.getFaction(this.Contract.getFaction()).getBannerSmall()
					];
					p.EnemyBanners = [
						this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getBannerSmall()
					];
					local allyStrength = 90;

					if (this.Flags.get("IsRequisitionFailure"))
					{
						allyStrength = allyStrength - 20;
					}

					if (this.Flags.get("IsDesertersFailed"))
					{
						allyStrength = allyStrength - 20;
					}

					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, allyStrength * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
					p.Entities.push({
						ID = this.Const.EntityType.Knight,
						Variant = 0,
						Row = 2,
						Script = "scripts/entity/tactical/humans/knight",
						Faction = this.Contract.getFaction(),
						Callback = this.Contract.onCommanderPlaced.bindenv(this.Contract)
					});
					local enemyStrength = 150;

					if (this.Flags.get("IsScoutsFailed"))
					{
						enemyStrength = enemyStrength + 25;
					}

					if (this.Flags.get("IsInterceptSuppliesFailure"))
					{
						enemyStrength = enemyStrength + 25;
					}

					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, enemyStrength * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyNobleHouse"));
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Mercenaries, 60 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyNobleHouse"));
					p.Entities.push({
						ID = this.Const.EntityType.Knight,
						Variant = this.Const.DLC.Wildmen && this.Contract.getDifficultyMult() >= 1.15 ? 1 : 0,
						Name = this.Const.Strings.KnightNames[this.Math.rand(0, this.Const.Strings.KnightNames.len() - 1)],
						Row = 2,
						Script = "scripts/entity/tactical/humans/knight",
						Faction = this.Flags.get("EnemyNobleHouse"),
						Callback = null
					});
					this.Contract.setState("Running_FinalBattle");
					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "FinalBattle")
				{
					this.Flags.set("IsFinalBattleLost", true);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "FinalBattle")
				{
					this.Flags.set("IsFinalBattleWon", true);
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"返回" + this.Contract.m.Home.getName() + "以索取你的报酬"
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer%身穿盔甲，尽管他的指挥官们似乎正试图劝说他不要亲自上阵。尽管如此，他还是热情地欢迎了你，并迅速说明了他的需求。%SPEECH_ON%我们即将结束这场荒唐的战争。我的主力部队正在此地%direction%处集结。我需要你去那里与%commander%会合。他会向你说明你的任务。如果你能帮助我们扭转战局，佣兵，你将获得丰厚的报酬。%SPEECH_OFF% | 你走进%employer%的房间，看见他拿着一面%feudfamily%的旗帜逗着几只狗。那些杂种狗以惯有的凶残撕咬着旗帜。%employer%抬头看向你。%SPEECH_ON%啊，佣兵。很高兴你终于来了。我需要你去拜访位于此地%direction%方向的%commander%。我们正开始这场该死战争的最后阶段，我相信像你这样的人能帮助加速它的结束。我无法告诉你具体会怎样，只能说这类战争通常结束得都相当精彩。你的报酬，同样也会很精彩。%SPEECH_OFF% | 你走进%employer%的房间，发现他被将军们围在中间。他们正低头看着一张地图，上面大量代表敌军的标记正在对峙。这位贵族看向你。%SPEECH_ON%啊，佣兵。我需要你去这里。%SPEECH_OFF%他将一根小棍扔在地图上。%SPEECH_ON%然后与%commander%会合。我们正准备一劳永逸地结束这场战争，你的帮助至关重要。%SPEECH_OFF%你点点头，但并未离开。他挑了挑眉，然后竖起一根手指。%SPEECH_ON%哦对了，你出手帮助是有报酬的！这点毋庸置疑。%SPEECH_OFF% | 你无法进入%employer%的房间。相反，他的一名指挥官在外面会见你，带着一张地图和一份合同。他解释说一场大战即将来临，需要你的帮助。如果你选择接受，你将前往位于此地%direction%边的%commander%处，并在那里等待进一步的指示。 | %employer%房门外的守卫拦住了你。他盯着你身上%companyname%的徽记，然后直接对你说道。%SPEECH_ON%我奉命把这个交给你。%SPEECH_OFF%他将一卷羊皮纸拍在你胸口。指令说明一场决定战争结局的战斗即将到来，如果你选择提供帮助，你需要前往%commander%的营地向他报到以获取进一步指示。你问是与这名守卫还是与%employer%讨价还价。守卫艰难地咽了口口水，一滴汗珠从他的脸颊滑落。%SPEECH_ON%如果你一定要讨价还价，那就试着跟我谈吧。%SPEECH_OFF% | %employer%接待了你，并带你出去见他的私人训犬师。当他沿着犬队行走时，狗儿们顺从地坐着。他用手拂过它们的头顶，那是一种轻松而带有统御意味的抚摸。%SPEECH_ON%%commander%正率领我的部队在此地%direction%边，他向我报告说一场大战可能即将来临。%SPEECH_OFF%这位贵族停下脚步，转向你。%SPEECH_ON%他认为这有可能结束与%feudfamily%的战争。所以我要你去那里帮忙，尽一切努力终结这场可恶的冲突。%SPEECH_OFF% | 你在一间满是将军的房间里与%employer%会面。他的指挥官们怀疑地盯着你，但%employer%邀请你到角落私下交谈。%SPEECH_ON%别在意他们。长话短说，我有一支由%commander%率领的军队就在此地%direction%边。我需要你去见他，获取进一步指示。我的指挥官们认为最终决战可能很快就要到来，我们需要所有能得到的帮助。如果这场战斗真的能结束战争，你将获得相应的奖赏。%SPEECH_OFF% | %employer%的房间，你在那里发现他被争吵不休的将军们包围着。他们互相大喊，撞倒了地图上的战争标记，把作战部署弄得一团糟。%employer%站起身亲自与你见面。%SPEECH_ON%别在意他们的争吵。这些人很紧张，因为我们很可能正处于结束与%feudfamily%这场该死战争的边缘。%commander%和我的大部分军队正在此地%direction%边休整。他正在呼叫尽可能多的增援，包括佣兵。如果你去那里帮忙结束战争这摊烂事，佣兵，你将获得最丰厚的回报。%SPEECH_OFF% | %employer%带你到外面的一些猪圈旁。你在那里看到猪正在啃咬一具尸体。附近，几只山羊在咀嚼一面%feudfamily%的旗帜。%employer%咧嘴笑着转向你。%SPEECH_ON%一个间谍，你懂的。总之，%commander%向我报告，他认为与%feudfamily%的最终决战可能即将到来。他在请求所有能得到的援助，而我打算满足他。如果你去那里与他见面，并按他的要求行事，你将得到极其丰厚的报酬。%SPEECH_OFF% | 你见到了%employer%的一名守卫，他带你去私下面见%employer%。他窝在一个小房间里，这想必是某种远离世间烦扰的僻静处。当他翻阅一本书时，烛光摇曳。他头也不抬地对你说。%SPEECH_ON%你好，佣兵。我的战场指挥官%commander%派信鸽告诉我，%feudfamily%的军队可能正在集结。他认为我们有机会一劳永逸地结束这场战争。%SPEECH_OFF%这位贵族舔了舔拇指，慢慢翻过一页。他继续说道。%SPEECH_ON%我希望你去加入他。自然，你的报酬将与你所能提供的贡献相称，相信这贡献不会小。%SPEECH_OFF% | %employer%的一名守卫带你来到一座塔楼顶部，你见到了这位贵族本人。他看向你。%SPEECH_ON%景色不错，是吧？%SPEECH_OFF%你环顾四周。大地延展，人们变成了在其上跳跃的小点。一辆小驴车在塔下咔嗒作响地驶过，进入%townname%做生意。你耸耸肩。%employer%点了点头。%SPEECH_ON%我原以为你会欣赏这样的景色，但我想一个生意人在有正事要办的时候，脑子里是不会想这些的。而亲爱的佣兵，现在正事当前。我的一位指挥官报告说%feudfamily%的军队正在集结。他认为我们有可能通过一场大规模的最后决战来结束与他们的战争。明白吗？%SPEECH_OFF%你点点头。他继续说道。%SPEECH_ON%如果一切按计划进行，你将根据你的服务获得报酬。我不知道你以前有没有参与结束过一场战争，佣兵，但很多人愿意为这种服务支付天价的酬劳。%SPEECH_OFF%",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "一场伟大的战斗，你说呢？",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{我不会让%companyname%听从别人的指挥。 | 我不得不谢绝。 | 我们还有别的地方要去。}",
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
			ID = "WarcampDay1",
			Title = "在军营……",
			Text = "[img]gfx/ui/events/event_96.png[/img]{你抵达了军营——这里更像一座帐篷之城，并找到了%commander%。他把你迎进他的帐篷——这里则更像一座地图之城，他正审视着自己军队的位置，以及他推测%feudfamily%军队可能所在的方向。%SPEECH_ON%欢迎，佣兵。你来得正是时候。%SPEECH_OFF% | %commander%的军营里满是百无聊赖的士兵。他们要么在搅动炖锅，要么在玩纸牌游戏。眼下最刺激的事莫过于一只甲虫和一条蠕虫之间的战斗，而交战双方似乎对此都兴致缺缺。%commander%亲自欢迎了你，并带你走进他的帐篷，里面挂满了地图和其他用于规划的工具。 | 你走进%commander%的帐篷，遇到一群没什么热情的汉子。其中一个嚷道。%SPEECH_ON%你们不是我们叫来的娘们。%SPEECH_OFF%士兵们哄笑起来。%randombrother%立刻吼了回去。%SPEECH_ON%你们老妈已经先伺候了我们。%SPEECH_OFF%毫不意外的，双方都开始拔武器。%commander%亲自出面干预，阻止了一场彻底的流血冲突爆发。他把你带进他的帐篷。%SPEECH_ON%很高兴你来了，不过要想打赢这场该死的战争，你手下的人最好少惹点麻烦。%SPEECH_OFF% | 你进入%commander%的营地，发现士兵们正在举行甲虫赛跑。他们为甲虫加油鼓劲，而那些甲虫在麦秆铺成的赛道上跑到一半，却互相攻击打了起来。士兵们的欢呼声越发响亮。%commander%穿过人群找到你，把你带进他的帐篷。%SPEECH_ON%很高兴你来了，佣兵。我现在就有事要交给你办。%SPEECH_OFF% | 抵达%commander%的军营时，你发现士兵们正在为一个几乎没穿衣服、骑在驴背上的女人欢呼。那女人和驴子钻进了一个帐篷，帐篷立刻被男人们挤得水泄不通。%randombrother%问能不能去。你说你也要去，所以他当然能去。就在这时，%commander%抓住了你。他把你带到了他的指挥帐篷。%SPEECH_ON%相信我，你不会想看的。%SPEECH_OFF%你并不相信他。 | %commander%的军营把这片土地变成了泥沼。他们砍光了附近所有的树木，在原地建起了粗制滥造的小窝棚，随着泥地的塌陷而东倒西歪。帐篷一眼望不到头。沿途篝火闪烁，犹如白色天幕上缀满的星辰。\n\n你在%commander%的帐篷里见到了他，帐篷里挂满了地图，副官们正等候着命令。 | 军营里充满了叮叮当当的响声。铁匠在修理装备，厨师炖煮着他们称之为食物的可怕糊状物，士兵们则在为帐篷敲打固定桩。你在%commander%的帐篷里与他会面。虽然远离了那些金属噪音，这里却充斥着他副官们的争吵声。他摇了摇头。%SPEECH_ON%大战临近时，人们总会紧张。别在意他们的争执。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "你需要%companyname%做什么？",
					function getResult()
					{
						if (this.Flags.get("IsScoutsSighted"))
						{
							return "ScoutsSighted";
						}
						else
						{
							return "RequisitionSupplies1";
						}
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "WarcampDay1End",
			Title = "在军营……",
			Text = "[img]gfx/ui/events/event_96.png[/img]{你回到了军营，命令手下抓紧时间休息。谁知道明天还有什么在等着你们。 | 好了，%commander%的命令已经完成，但明天肯定还有更多任务。趁现在有机会，赶紧休息！ | 军营和你离开时一模一样。你说不清这是好事还是坏事。明天肯定还有更多狗屁倒灶的事要处理，所以你命令%companyname%抓紧时间休息。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "好好休息，我们很快就会有新的任务。",
					function getResult()
					{
						this.Flags.set("LastDay", this.World.getTime().Days);
						this.Flags.set("NextDay", 2);
						this.Contract.setState("Running_WaitForNextDay");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ScoutsSighted",
			Title = "在军营……",
			Text = "[img]gfx/ui/events/event_54.png[/img]%commander%说明了情况。%SPEECH_ON%{我们的哨兵已经发现了他们的斥候。不幸的是，我没给哨兵配备武器盔甲，所以他们只能请求支援。敌人就在这里的%direction%边。把他们全干掉，%feudfamily%就无法掌握我们军队的动向了。 | 我的几个探路者刚刚在这里的%direction%边发现了%feudfamily%的一些斥候。他们正在到处搜寻主力部队，但他们找不到的，因为你要去那里把他们全宰了。明白吗？ | 在这里%direction%边的地方发现了%feudfamily%的斥候。我要你去把他们全部杀光，抢在他们找到我们，或者汇报过去几天搜集到的任何情报之前。 | 战争中，情报就是一切。而我刚获得情报，%feudfamily%的斥候就在这里的%direction%边活动。如果我能了解他们的情报，同时摧毁他们掌握的关于我们的情报，那就为接下来的战斗赢得了相当大的优势。}%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "战团马上出发。",
					function getResult()
					{
						this.Contract.setState("Running_Scouts");
						return 0;
					}

				}
			],
			function start()
			{
				local playerTile = this.Contract.m.Warcamp.getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 8);
				local party = this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).spawnEntity(tile, "Scouts", false, this.Const.World.Spawn.Noble, 60 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.getSprite("banner").setBrush(this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getBannerSmall());
				party.setDescription("听命于当地领主的职业军人。");
				party.setFootprintType(this.Const.World.FootprintsType.Nobles);
				this.Contract.m.UnitsSpawned.push(party);
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

				this.Contract.m.Destination = this.WeakTableRef(party);
				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Warcamp);
				roam.setMinRange(4);
				roam.setMaxRange(9);
				roam.setAllTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
				roam.setTerrain(this.Const.World.TerrainType.Shore, false);
				roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
				c.addOrder(roam);
			}

		});
		this.m.Screens.push({
			ID = "ScoutsEscaped",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_22.png[/img]{不幸的是，一名或多名斥候成功从战场上溜走了。他们收集到的任何情报现在都已落入%feudfamily%手中。 | 真该死！部分斥候成功逃脱了，不用说，他们肯定返回%feudfamily%的驻地了。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "该死的！",
					function getResult()
					{
						this.Contract.setState("Running_ReturnAfterScouts");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ScoutsCaught",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_22.png[/img]{所有斥候都已阵亡，他们掌握的情报也一起烟消云散了。这对即将到来的战斗将是重大利好。 | 斥候全数毙命，他们获悉的所有情报也随之而去。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "胜利！",
					function getResult()
					{
						this.Contract.setState("Running_ReturnAfterScouts");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "RequisitionSupplies1",
			Title = "在军营……",
			Text = "[img]gfx/ui/events/event_96.png[/img]{%commander%叹了口气，开口说道。%SPEECH_ON%我不是想浪费你的才能，佣兵，但我需要有人去为军队征调粮食。我们的补给快见底了，需要所有能得到的帮助。%SPEECH_OFF%嘿，只要有钱拿，这对你来说就不算侮辱。 | %commander%将一片干树叶塞到唇后，抱起双臂。%SPEECH_ON%见鬼，我知道你是来打仗的。我知道你来这是为了杀人并靠这个赚大钱。但现在，我的军队需要填饱肚子，而要填饱肚子，我需要有人去把粮食弄来。%SPEECH_OFF%他走到一张地图前，指向它。%SPEECH_ON%我需要你去拜访这些农民，把他们的粮食装车。他们会等着你，所以应该不会有什么问题。就当是战前放松一天，怎么样？%SPEECH_OFF% | %commander%指向摊在他一张地图上的卷轴。上面列着数字，越往下数字越小。%SPEECH_ON%我们的粮食储备快见底了。我们通常通过去找%direction%的农民征收粮草。我需要你去那里再弄一些来。他们会等着你，应该不会有什么问题。%SPEECH_OFF% | 你低头看到一个盘子里放着一块干面包。旁边的盘子里有肉，吃了一半，剩下的招来了苍蝇。一只喂饱了的健康战犬在角落里摇着尾巴。%commander%绕到一张地图前。%SPEECH_ON%我们的粮食储备非常短缺。如果我的士兵挨饿，他们就不会打仗，而如果他们不打仗，我们就输了！%SPEECH_OFF%你点点头。这账算得没错。他继续说道。%SPEECH_ON%我们从%direction%的农民那里获取粮食已经有一段时间了。我需要你去那里做同样的事。我的一个守卫会给你一份所需物品的清单。农民不会反抗你的。他们知道如果反抗会有什么后果。%SPEECH_OFF% | 你看见帐篷角落里有个学者模样的人。他正用一支干涸的羽毛笔在卷轴上划拉着，一直摇着头。突然，他站起身，把那页纸递给%commander%。指挥官点了几次头，然后看向你。%SPEECH_ON%这对某些佣兵来说可能有点委屈，但我需要%companyname%去一趟%direction%边的农场，把他们有的粮食‘征用’过来。这不是我们军队第一次向这些农民提出要求了。上次我们去的时候，他们试图抵抗，不过，嗯，他们已经学到了些教训。我的书记官会写下我们需要的一切。就当是去市场采购一天吧。%SPEECH_OFF%指挥官咧着嘴苦笑了一下。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "战团将在一小时内出发。",
					function getResult()
					{
						this.Contract.setState("Running_Requisition");
						return 0;
					}

				}
			],
			function start()
			{
				local settlements = this.World.EntityManager.getSettlements();
				local lowest_distance = 99999;
				local best_location;
				local myTile = this.Contract.m.Warcamp.getTile();

				foreach( s in settlements )
				{
					foreach( l in s.getAttachedLocations() )
					{
						if (l.getTypeID() == "attached_location.wheat_fields" || l.getTypeID() == "attached_location.pig_farm")
						{
							local d = myTile.getDistanceTo(l.getTile());

							if (d < lowest_distance)
							{
								lowest_distance = d;
								best_location = l;
							}
						}
					}
				}

				best_location.setActive(true);
				this.Contract.m.Destination = this.WeakTableRef(best_location);
			}

		});
		this.m.Screens.push({
			ID = "RequisitionSupplies2",
			Title = "在农场……",
			Text = "[img]gfx/ui/events/event_72.png[/img]{农舍就在附近。一片庄稼的海洋就在你们面前，随着风声荡漾。%randombrother%把手伸向麦田。%randombrother2%给了他的肩膀一拳。%SPEECH_ON%你想把害虫带回家吗？手拿开。%SPEECH_OFF%雇佣兵揉揉肩膀，打了回去.%SPEECH_ON%去你的，我爱把手伸到哪就伸到哪。%SPEECH_OFF%拳击声此起彼伏，美好的田园风光被打破了。 | 农舍在远处。庄稼田随着风声轻轻摇曳，像平静的海浪一样。前头的农工们用大镰刀收割，后头的用叉子抬起残留的庄稼。驴子走在最后，拉着推车穿过崎岖的农田。 | 农场坐落在群山之间，这里的土壤很好，地形也影响不了农作物的生长。每一片田地都种满了庄稼，农工们闪闪发光的大镰刀和叉子在田间穿梭。你看到农场主们远远地站在一起。他们看起来很生气，但没几个人敢在%companyname%的面前发怒。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿走我们来拿的东西吧",
					function getResult()
					{
						if (this.Flags.get("IsAmbush"))
						{
							return "Ambush";
						}
						else if (this.Flags.get("IsUnrulyFarmers"))
						{
							return "UnrulyFarmers";
						}
						else
						{
							return "CooperativeFarmers";
						}
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Ambush",
			Title = "在农场……",
			Text = "[img]gfx/ui/events/event_10.png[/img]{就在你们靠近那些农民时，侧翼传来一声呐喊，一群全副武装的士兵跳了出来。有埋伏！ | 当你们接近农舍时，那些装满食物的推车开始向后移动。随着它们缓缓退开，一队全副武装的士兵从中显露出来。农民们迅速躲开。%randombrother%拔出武器。%SPEECH_ON%有埋伏！%SPEECH_OFF% | 你们靠近那些运粮车。当%randombrother%上前扯开一辆货车的篷布时，农民们纷纷让到一旁。里面空空如也。突然，一支箭“砰”地一声钉在车板上。农民们立刻蹲下身子逃开，而全副武装的士兵则从两侧涌出。有埋伏！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Ambush";
						p.Music = this.Const.Music.CivilianTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						local n = 0;

						do
						{
							n = this.Math.rand(1, this.Const.PlayerBanners.len());
						}
						while (n == this.World.Assets.getBannerID());

						p.Entities = [];
						p.EnemyBanners = [
							this.Const.PlayerBanners[n - 1],
							"banner_noble_11"
						];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Mercenaries, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Const.Faction.Enemy);
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.PeasantsArmed, 40 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Const.Faction.Enemy);
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "UnrulyFarmers",
			Title = "在农场……",
			Text = "[img]gfx/ui/events/event_43.png[/img]你们走向农民，却遭到了他们的抵制。他们的头领抱着胳膊直摇头。%SPEECH_ON%{你瞧，我的人已经把车都装好了。咱们各退一步，你看行不？我们也有家要养，有债要还，大伙都一样。你付我们%cost%克朗，我们就把这些都交给%commander%，怎么样？ | 你们是佣兵，对吧？那你们该比谁都明白钱的重要性。我们就是些老实巴交的农民，不是钱庄老板。我们只求干活能有点回报。你给我们%cost%克朗，粮食就归你。这么算我们还是亏的，但我觉着挺公道。 | 你们穿得花里胡哨地过来，以为吓唬吓唬我们就会乖乖就范？要我说，%commander%已经拿得够多了，也该像所有人一样为吃的付钱了！这么着吧，你出%cost%克朗，这粮食就卖给你。我觉得就我们出的货来说，这价钱再公道不过了。}%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "别忘了自己的身份，种地的。你想让我们来硬的吗？",
					function getResult()
					{
						return "TakeItByForce";
					}

				},
				{
					Text = "理解。我给你%cost%克朗，你把粮食给我。",
					function getResult()
					{
						return "PayCompensation";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BeatenByFarmers",
			Title = "在农场……",
			Text = "[img]gfx/ui/events/event_22.png[/img]伏兵的实力太强了！你带着还能站着的弟兄们仓皇撤退。%commander%的部队如今不得不进一步缩减口粮配给，而%companyname%在此地战败的消息无疑将会传开。",
			Image = "",
			List = [],
			Options = [
				{
					Text = "该死的！",
					function getResult()
					{
						this.Flags.set("IsRequisitionFailure", true);
						this.Contract.setState("Running_ReturnAfterRequisition");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "PoorFarmers",
			Title = "在农场……",
			Text = "[img]gfx/ui/events/event_60.png[/img]{农民和他们雇佣的打手都被镇压了。一个肠子都流出来的农场帮工一边向后爬，一边乞求饶命，你走上前去摇了摇头。%SPEECH_ON%你没救了，小子。我这么做是在帮你%SPEECH_OFF%剑刃轻易地滑过他的喉咙。他咽喉里咯咯作响，但很快就结束了。你命令手下收集食物，准备返回%commander%处。 | 农民和他们雇佣的伏兵已经被杀个干净。你命令手下收集粮草。%commander%和他的士兵应该会很高兴看到你回去。 | 有些粮草沾了血，不过用水稍微擦洗一下就行了。%commander%的部下会感激你们的辛苦工作的。 | %randombrother%抓起一个装死的农民，一刀割开了他的脖子。那人喉咙咯咯作响，扭动着挣脱了佣兵的控制。他跌跌撞撞扑向一辆货车，鲜血喷得到处都是。你大喊。%SPEECH_ON%妈的，把他从那儿弄开！%SPEECH_OFF%那个农民很快就被解决了，但那车货物无疑是毁了。你摇了摇头。%SPEECH_ON%拿条毯子盖住那些。也许没人会注意到。%SPEECH_OFF% | 征收粮草比你预想的要多费了点手脚，但现在它们都已在你掌握之中。你把这片农田的所有权赐给了一个鞋子破得像羊毛袋的穷苦农场帮工。%SPEECH_ON%别忘了你主人的下场，因为这一样可以发生在你身上，懂了吗？%SPEECH_OFF%那小子赶紧点头。你命令%companyname%准备返回%commander%处。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "一群蠢货。",
					function getResult()
					{
						this.Flags.set("RequisitionSuccess", true);
						this.Contract.setState("Running_ReturnAfterRequisition");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CooperativeFarmers",
			Title = "在农场……",
			Text = "[img]gfx/ui/events/event_55.png[/img]{农民们热情地迎接你们。%SPEECH_ON%让我猜猜，是%commander%派你们来的？%SPEECH_OFF%你点点头。那农民啐了一口，也点头回应。%SPEECH_ON%我们不会找你麻烦。伙计们，帮他们上路。%SPEECH_OFF%农场帮工们出来协助你的手下搬运食物，准备返回%commander%处的行程。 | 你见到了农民们的头领。他和你握了握手。%SPEECH_ON%%commander%的小鸟告诉我他派了佣兵来，但你们这身行头看起来比我见过的任何战团都厉害不少。我的小伙子们会帮你们装车，这样你们就能上路了。%SPEECH_OFF% | 你们靠近时，农民们已经开始往车上装货。他们的头领走上前来。%SPEECH_ON%干这事儿我可不乐意，但比起坐在某个军营里等着在一场我不关心的战争中送死，我宁愿待在这片地里。我的人会帮你们装车，你们好赶紧上路。见到%commander%时，替我说句好话行不？我还想继续种我的地。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我相信%noblehouse%会很感激的。",
					function getResult()
					{
						this.Flags.set("RequisitionSuccess", true);
						this.Contract.setState("Running_ReturnAfterRequisition");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TakeItByForce",
			Title = "在农场……",
			Text = "[img]gfx/ui/events/event_43.png[/img]{你拔出剑。农民们向后退去，一阵抓取草叉的咔嗒声在他们队伍中哗然响起。他们的首领吐了口唾沫，用袖子擦了擦嘴。%SPEECH_ON%妈的，你想来硬的？那我们就来硬的。%SPEECH_OFF% | 你摇了摇头。%SPEECH_ON%没得谈。交出粮食，否则我们就动手了。%SPEECH_OFF%那农民来回挥舞着草叉。他手下的人慢慢开始拿起武器。他点了点头。%SPEECH_ON%我们是农民，混蛋。最不怕的就是动手。%SPEECH_OFF% | 你来到这里不是为了讨价还价。%SPEECH_ON%不会有任何补偿。%commander%派我们来是为了……%SPEECH_OFF%农民大笑着打断了你。%SPEECH_ON%指挥官派了几只走狗来。好吧我告诉你，小狗崽子，让我们瞧瞧你的人是光叫不咬，还是真有点本事。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "动作快点。",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "TakeItByForce";
						p.Music = this.Const.Music.CivilianTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.Entities = [];
						p.EnemyBanners = [
							"banner_noble_11"
						];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Peasants, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Const.Faction.Enemy);
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "PayCompensation",
			Title = "在农场……",
			Text = "[img]gfx/ui/events/event_55.png[/img]{你觉得没有理由去伤害这些只想勉强过活的可怜农民。交出克朗后，你警告这个农民以后搞这种交易要小心点。%SPEECH_ON%不是每个人都这么好说话，还愿意跟你商量的。%SPEECH_OFF%农民转过头，露出一道从头顶延伸到肩膀的长疤。%SPEECH_ON%我很清楚。谢谢你的体谅，佣兵。%SPEECH_OFF% | 你只会在有人付钱让你干这事的时候才去杀农民。而%commander%没付这个钱。你同意了农民们的条件。他们的首领和你握了握手。%SPEECH_ON%谢谢你，佣兵。难得见到一个愿意让步的人。我原以为你是个粗人，但显然你是个很有见识的人。%SPEECH_OFF% | 你大老远跑来不是为了屠杀一些可怜农民的。你同意了那人的条件。他感谢你没有大老远跑来屠杀一些可怜农民。然而，%randombrother%小声嘀咕说他大老远跑来可不是为了……你大声叫他闭嘴，然后开始往车上装货。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们动作麻溜点，赶紧返回军营。",
					function getResult()
					{
						this.Flags.set("RequisitionSuccess", true);
						this.Contract.setState("Running_ReturnAfterRequisition");
						return 0;
					}

				}
			],
			function start()
			{
				this.World.Assets.addMoney(-this.Flags.get("RequisitionCost"));
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你花了[color=" + this.Const.UI.Color.NegativeEventValue + "]" + this.Flags.get("RequisitionCost") + "[/color]克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "WarcampDay2",
			Title = "在军营……",
			Text = "[img]gfx/ui/events/event_96.png[/img]{早晨的阳光透过帐篷，落在你的眼睛上，提醒你又有新的一天要面对。 | 你起身穿上靴子，拍掉了几只把这里当成过夜好去处的蜘蛛。 | 帐篷外，一只公鸡高声啼叫，向所有人展示它真是个混账畜生。你满心不情愿地爬了起来。 | 你醒来，又是新的一天。太好了。 | 你睡得像死人，醒来也像死人。溜进帐篷的阳光太刺眼，没法再睡，门帘又离得太远懒得去拉上。去他妈的，你还是起来吧。 | 早晨。这不可避免的时刻，万千悔恨总会随着新一天耀眼的曙光一同降临。}\n\n一个年轻的男孩拿着卷轴站在你的帐篷外。他展开，艰难地读道。%SPEECH_ON%{你的……兹之指指挥官从……重……呃，你最好自己去找他。 | %commander%想见你，他……他说，等等，马不需要？什么意思？我不识字。直接去找指挥官吧。 | 先生，这张纸上让我告诉你，你……呃，你应该……呃，嗯，去找指挥官。后面还有好多，但要是我试着念完，我们得在这儿待一整天。 | 所以，是这样子的，我其实看不懂字，但我觉得指挥官想见你。 | 让我看看，这封信……我认识这个字……这是‘我’字，我觉得剩下整句话的意思就是：我他妈根本看不懂这鬼东西。听着，直接去找指挥官吧。我觉得他就是这个意思。}%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "是时候去拜访指挥官了……",
					function getResult()
					{
						if (this.Flags.get("IsInterceptSupplies"))
						{
							return "InterceptSupplies";
						}
						else
						{
							return "Deserters1";
						}
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "InterceptSupplies",
			Title = "在军营……",
			Text = "[img]gfx/ui/events/event_96.png[/img]你在帐篷里会见了%commander%。他看起来相当兴奋。一个精明的、戴着兜帽的小个子男人站在他身旁。指挥官语速很快地说道。{据我手下的探子报告，%feudfamily%家族打算给他们的军队运来一批装备。如果我们能截住这批装备，他们之后的备战程度将大打折扣！ | 你好，雇佣兵。我的探子告诉我，%feudfamily%家族有一批急需的装备正运往他们的营地。我需要你去把它们毁掉。 | 间谍是不是最棒的？看看这个小个子。他告诉我，先生，%feudfamily%家族有一大批货物即将送达。武器、盔甲、食物之类的。那么我说，我正好有个人能利用这个消息：就是你！去找到这支运输队，将其摧毁。 | 要知道，战斗往往在真正打响前就胜负已分了，你明白吗？我的这位小探子告诉我，%feudfamily%家族有一批武器和盔甲即将送达。如果你能设法干掉它，那么他们的军队将在正面战场上失去优势。 | 你知道吗？我曾经不挥一剑就赢得了一场战斗。我设法拦截了一批物资，让我的敌人完全无法应战，所以他们直接投降了。我的这位小探子告诉我，%feudfamily%家族也有一批类似的装备即将送达。我确信这不会结束战争，但如果你能去把它干掉，那将对我们帮助极大。 | 你知道吗，一支没有装备的军队根本称不上军队。%feudfamily%家族的军队物资短缺。一批武器装备正在运来的路上，这就是他们为什么还没发起攻击！不过，我的小间谍已经发现了那批货物。我希望你去摧毁它。 | 我得到了一个极好的消息，佣兵。%feudfamily%正在等待一批武器和盔甲的抵达——而且我们知道它的出发地点。我只需要你去完成那显而易见的事：摧毁那支运输队，在敌人还没反应过来之前重创他。}%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "战团马上出发。",
					function getResult()
					{
						this.Contract.setState("Running_InterceptSupplies");
						return 0;
					}

				}
			],
			function start()
			{
				local startTile = this.World.getEntityByID(this.Flags.get("InterceptSuppliesStart")).getTile();
				local destTile = this.World.getEntityByID(this.Flags.get("InterceptSuppliesDest")).getTile();
				local enemyFaction = this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse"));
				local party = enemyFaction.spawnEntity(startTile, "补给车队", false, this.Const.World.Spawn.NobleCaravan, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.getSprite("base").Visible = false;
				party.getSprite("banner").setBrush(this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getBannerSmall());
				party.setMirrored(true);
				party.setVisibleInFogOfWar(true);
				party.setImportant(true);
				party.setDiscovered(true);
				party.setDescription("一支有武装护卫的商队，在定居点间运送粮草、物资和装备。");
				party.setFootprintType(this.Const.World.FootprintsType.Caravan);
				party.getFlags().set("IsCaravan", true);
				party.setAttackableByAI(false);
				party.getFlags().add("ContractSupplies");
				this.Contract.m.Destination = this.WeakTableRef(party);
				this.Contract.m.UnitsSpawned.push(party);
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

				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local move = this.new("scripts/ai/world/orders/move_order");
				move.setDestination(destTile);
				move.setRoadsOnly(true);
				local despawn = this.new("scripts/ai/world/orders/despawn_order");
				c.addOrder(move);
				c.addOrder(despawn);
			}

		});
		this.m.Screens.push({
			ID = "SuppliesReachedEnemy",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_55.png[/img]{你未能摧毁车队。显然，所有物资都已送达%feudfamily%的军队，这将使得接下来的战斗更加艰难。 | 车队未被摧毁。你可以确信，%feudfamily%的军队将在即将到来的大战中保持近乎完整的实力。 | 唉，该死，车队没被摧毁。现在，%feudfamily%的军队能为即将到来的战斗做好充分准备了。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们应该返回营地……",
					function getResult()
					{
						this.Contract.setState("Running_ReturnAfterIntercept");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SuppliesIntercepted",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_60.png[/img]{你本希望能从商队中尽可能多地掠夺物资，但护卫们在物资被抢走前放火烧毁了一切。虽然可惜，但重要的是%feudfamily%的军队没能得到这些装备。 | 你摧毁了商队的大部分，而你没摧毁的那些，护卫们自己动手了，以确保装备不落入敌手。%commander%会对这个结果非常满意。 | 战斗很激烈，但你成功歼灭了车队护卫。不幸的是，他们似乎采用了焦土政策，设法烧毁了每一辆货车。他们很清楚，绝不能让这些装备落入敌人手中。尽管如此，%commander%还是会非常高兴的。 | 平心而论，车队护卫进行了顽强的抵抗，但%companyname%还是成功将他们全部歼灭。至少你是这么认为的：然而战斗中，一名护卫溜走并来了点焦土策略。每辆货车都被点燃了。显然，如果%feudfamily%得不到这些装备，那谁也别想得到。虽然恼人，但很聪明。尽管如此，%commander%和他的部下会对此消息表示赞赏。 | 车队已被摧毁。你本希望或许能俘获货车，把装备据为己有，但其中一名护卫设法烧毁了所有东西，无疑是为了不让这些装备落入敌手。无论如何，%feudfamily%的军队无疑是被削弱了。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "会战中需要面对的问题又少了一个。",
					function getResult()
					{
						this.Contract.setState("Running_ReturnAfterIntercept");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Deserters1",
			Title = "在军营……",
			Text = "[img]gfx/ui/events/event_96.png[/img]{你走进%commander%的帐篷，正好看到一支蜡烛从你脸旁飞过。烛芯嘶嘶作响地没入泥地中，紧接着一张桌子也飞了过来，上面的地图翻飞得到处都是。满脸通红的%commander%站在这片狼藉之中，双手叉腰，重重地喘着气试图让自己冷静下来。他解释道。%SPEECH_ON%逃兵！他们当了逃兵！在我人生中最重要一仗开打前，我他妈连自己的兵都留不住。听着，我不能让这支军队就此分崩离析。我要你去找到那些逃兵，把他们带回来。如果他们拒绝回来，那就全杀了。有个哨兵说看见他们往%direction%边去了。现在赶紧去！%SPEECH_OFF% | 就在你要进入%commander%的帐篷时，一个男人飞了出来。%commander%从帐篷里冲出来，把他狠狠摔进泥里。他揪住那人的领子，像拎破布娃娃一样把他提起来。%SPEECH_ON%他们去哪儿了？我向旧神发誓，如果你不老实回答我，我会让你求死不能！%SPEECH_OFF%那人哭喊着指向一个方向。%SPEECH_ON%%direction%！他们往那边跑了，我发誓！%SPEECH_OFF%%commander%松开手，那人立刻被两个卫兵拖走了。指挥官站直身子，用手捋了捋头发。%SPEECH_ON%佣兵，我的一些部下脱岗了。找到他们。把他们带回来。明白吗？%SPEECH_OFF%你点点头，但问如果那些人拒绝回来怎么办。指挥官耸耸肩。%SPEECH_ON%当然是宰了他们。%SPEECH_OFF% | 你走进%commander%的帐篷，看到他正从一个坐着的人身边走开。指挥官手里拿着钳子，钳齿间夹着一颗白色的牙齿。你注意到那个坐着的人已经昏了过去，脑袋耷拉着，嘴里滴着血。%commander%把钳子扔在桌上，用染红的手捋了捋头发。%SPEECH_ON%我的一些手下当了逃兵。我不能冒险让军队就这么散架了，尤其是在这个节骨眼上，大战在即。我这位小朋友，在他还能说话的时候告诉我，他的同伙认为往%direction%边逃跑很合适。去吧，佣兵，把那些逃兵给我带回来。%SPEECH_OFF%在你离开之前，你问如果逃兵拒绝回来怎么办。指挥官瞪着你。%SPEECH_ON%你说呢？全杀了！%SPEECH_OFF% | 你发现%commander%正对着他的地图沉思。他的指关节抵在桌上，桌腿发出呻吟摇晃起来。他抬起头。眼中闪过一丝难以置信的怒火。%SPEECH_ON%我的一些手下认为逃离我的军队很合适。哨兵告诉我，他们看见那些人往%direction%边跑了。去把他们带回来。%SPEECH_OFF%你问他是否要活口。他点点头。%SPEECH_ON%我要他们完好无损地回来，这样我才能更好地提醒他们，逃兵在我的军队里意味着什么。当然，如果他们坚决拒绝，那我就要他们死。这也能发挥警示的作用，你同意吧？%SPEECH_OFF% | %commander%把他的一位副官绑在帐篷的柱子上。指挥官手里拿着一根长棍，用力猛抽副官的胸口和两腿。那个男人哭喊着打转，结果后背又挨了打。当副官转回来的时候，陷入昏迷的他只剩瘀紫的脸偶有抽动。\n\n%commander%扔掉棍子，开始拔手指上的木刺。%SPEECH_ON%很高兴你来了，佣兵。我的一些部下当了逃兵，我需要你去找到他们。把他们活着带回来，如果拒绝就全杀了。我这位朋友说他们往%direction%方向跑了。为了他好，我希望他说的是真话。%SPEECH_OFF%你也希望他说的是真话。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "战团将在一小时内出发。",
					function getResult()
					{
						this.Contract.setState("Running_Deserters");
						return 0;
					}

				}
			],
			function start()
			{
				local playerTile = this.World.State.getPlayer().getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 10, [
					this.Const.World.TerrainType.Shore,
					this.Const.World.TerrainType.Mountains
				]);
				local party = this.World.FactionManager.getFaction(this.Contract.getFaction()).spawnEntity(tile, "Deserters", false, this.Const.World.Spawn.Noble, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.getSprite("banner").setBrush("banner_deserters");
				party.setFootprintType(this.Const.World.FootprintsType.Nobles);
				party.setAttackableByAI(false);
				party.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				party.setFootprintSizeOverride(0.75);
				this.Const.World.Common.addFootprintsFromTo(playerTile, party.getTile(), this.Const.GenericFootprints, this.Const.World.FootprintsType.Nobles, 0.75);
				this.Contract.m.Destination = this.WeakTableRef(party);
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

				local c = party.getController();
				local wait = this.new("scripts/ai/world/orders/wait_order");
				wait.setTime(9000.0);
				c.addOrder(wait);
			}

		});
		this.m.Screens.push({
			ID = "Deserters2",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_88.png[/img]{你撞见这群逃兵围坐在一堆闷燃的篝火旁，其中一个正拼命往余烬上踢土掩盖。看到你，他停了下来。其余逃兵顺着他的目光看去，随即猛地跳起身来。%SPEECH_ON%我们绝不回去。你去告诉%commander%，让他见鬼去吧。%SPEECH_OFF% | 这群逃兵正在内讧，你突然闯入他们这场小小的逃亡聚会。其中一个吓得往后一跳。%SPEECH_ON%是%commander%派你来的，对不对？哼，你去告诉他，让他见鬼去吧。%SPEECH_OFF%另一个挥舞着拳头。%SPEECH_ON%没错，我们绝不回去！%SPEECH_OFF%毫无疑问，这是群不服管束的家伙。 | %randombrother%指出一群正站在路标旁的男人。他们争吵得太大声，没听见你们靠近。你吹出一声尖锐的口哨，男人们顿时安静下来并齐刷刷转过身。一个家伙猛地后退。%SPEECH_ON%那个鼠辈指挥官派了佣兵来追我们？%SPEECH_OFF%你点头，并解释说他们该跟你回去。另一个逃兵摇了摇头。%SPEECH_ON%回去？要不你自己滚一边去吧？我们绝不回去，你就这么去告诉那个指挥官。%SPEECH_OFF% | 发现这群逃兵时，他们正从一个羊毛袋里分食。看到你，他们都愣住了，其中一个试图把满嘴的食物整个吞下去。他噎住了。其余的人一动不动。噎住的人胡乱挣扎着求救，脸都憋紫了。他的腿在羊毛袋上方乱蹬，把食物踢得到处都是。你点了点头。%SPEECH_ON%先救你们的人。%SPEECH_OFF%逃兵们赶紧跑到噎住的人身边，把他喉咙里的食物敲了出来。他大口喘着气。你开始解释%commander%对你的要求，但一个逃兵打断了你。%SPEECH_ON%不行。我们不会回去。这场战争毫无意义，我们不想掺和。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "这就是你们人生目标吗？当个连保卫自己的土地都不敢的懦夫？",
					function getResult()
					{
						return this.Math.rand(1, 100) <= 50 ? "DesertersAcceptMotivation" : "DesertersRefuseMotivation";
					}

				},
				{
					Text = "你们只有两个选择：要么为自己的领主战斗，要么死在这里。",
					function getResult()
					{
						return this.Math.rand(1, 100) <= 50 ? "DesertersAcceptThreats" : "DesertersRefuseThreats";
					}

				},
				{
					Text = "我们打开天窗说亮话。 如果你们回来的话，这%bribe%克朗就归你了。",
					function getResult()
					{
						return "DesertersAcceptBribe";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "DesertersAcceptBribe",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_88.png[/img]{你拿出一个袋子，往里放了%bribe%克朗。%SPEECH_ON%我个人出钱，请你们跟我回军营。别他妈搞错了，%commander%对你们火大得很，但他需要所有能召集的人手。如果你们在接下来的战斗中为他而战，我毫不怀疑他会宽恕你们犯的这个小错。%SPEECH_OFF% | 你提议给逃兵们%bribe%克朗。这些人互相看了看，然后对你说道。%SPEECH_ON%等指挥官把我们全吊死的时候，钱还有什么用？%SPEECH_OFF%你点点头回答。%SPEECH_ON%问得好，但%commander%不是傻瓜。他需要所有能集结起来的人手应对即将到来的战斗。在战斗中证明自己，你们造成的小骚乱就会被遗忘。%SPEECH_OFF%}{逃兵们权衡了他们的选择，最终同意跟你回去。 | 逃兵们聚在一起商量，达成了某种共识。散开后，他们的头领走上前来。%SPEECH_ON%尽管有人反对，我们还是同意跟你回军营。希望我不会为此后悔。%SPEECH_OFF% | 经过短暂讨论后，逃兵们进行了投票。虽然不是全票通过，但他们达成了一致：他们会跟你回去见%commander%。 | 逃兵们争论着下一步该怎么办。不可避免地，他们进行了投票。果然，投票结果是平局。于是他们同意抛硬币决定：正面回军营，反面离开。他们的头领抛起硬币，所有人都盯着那枚旋转闪烁的硬币。硬币落下来是正面。看到结果后，每个人都叹了口气，仿佛运气让他们不用承担做出重大抉择的责任。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "这会对接下来的战斗大有好处。",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						this.Contract.setState("Running_ReturnAfterIntercept");
						return 0;
					}

				}
			],
			function start()
			{
				this.World.Assets.addMoney(-this.Flags.get("Bribe"));
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你花了[color=" + this.Const.UI.Color.NegativeEventValue + "]" + this.Flags.get("Bribe") + "[/color]克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "DesertersAcceptThreats",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_88.png[/img]{%bigdog%踏步上前，将武器扛在肩上，随意地转动着。他点头道。%SPEECH_ON%你们怕%commander%。我懂。你们了解他，了解他的脾气和他的手段。问题是……%SPEECH_OFF%这佣兵咧嘴一笑，狡黠的笑容映在他闪亮的刀锋上。%SPEECH_ON%你们了解我吗？%SPEECH_OFF% | 逃兵们眼看就要离开，%bigdog%响亮地吹了声口哨。%SPEECH_ON%嘿，你们这群渣滓，我的指挥官给你们下了命令。%SPEECH_OFF%一个逃兵嗤笑道。%SPEECH_ON%是吗？他又不是我们的指挥官，所以去他妈的命令。%SPEECH_OFF%%bigdog%抽出一把巨大的刀，插进地里。他双手交叠按在刀柄上。%SPEECH_ON%你们怕%commander%，这没关系。但你要是继续当个小混蛋，我的朋友，咱们很快就会知道你到底该怕谁了。%SPEECH_OFF% | 逃兵们转身准备离开。%bigdog%掏出一把巨大的刀，当啷一声敲在盔甲上。逃兵们缓缓转过身来。%bigdog%笑了笑。%SPEECH_ON%你们有谁尿过裤子吗？%SPEECH_OFF%一个逃兵摇了摇头。%SPEECH_ON%喂……喂，哥们，别他妈说这种话。%SPEECH_OFF%%bigdog%猛地抓起刀，刀尖指向那个逃兵。%SPEECH_ON%哦，你想让我闭嘴？再这样跟我说话，这儿很快就没人能说话了%SPEECH_OFF%}{逃兵们权衡了他们的选择，最终同意跟你回去。 | 逃兵们聚在一起商量，达成了某种共识。散开后，他们的头领走上前来。%SPEECH_ON%尽管有人反对，我们还是同意跟你回军营。希望我不会为此后悔。%SPEECH_OFF% | 经过短暂讨论后，逃兵们进行了投票。虽然不是全票通过，但他们达成了一致：他们会跟你回去见%commander%。 | 逃兵们争论着下一步该怎么办。不可避免地，他们进行了投票。果然，投票结果是平局。于是他们同意抛硬币决定：正面回军营，反面离开。他们的头领抛起硬币，所有人都盯着那枚旋转闪烁的硬币。硬币落下来是正面。看到结果后，每个人都叹了口气，仿佛运气让他们不用承担做出重大抉择的责任。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "你做了正确的决定。",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						this.Contract.m.Dude = null;
						this.Contract.setState("Running_ReturnAfterIntercept");
						return 0;
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local candidates = [];

				foreach( bro in brothers )
				{
					if (bro.getSkills().hasSkill("trait.player"))
					{
						continue;
					}

					if (bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getSkills().hasSkill("trait.brute") || bro.getBackground().getID() == "background.raider" || bro.getBackground().getID() == "background.sellsword" || bro.getBackground().getID() == "background.hedge_knight" || bro.getBackground().getID() == "background.brawler")
					{
						candidates.push(bro);
					}
				}

				if (candidates.len() == 0)
				{
					candidates = brothers;
				}

				this.Contract.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];
				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "DesertersAcceptMotivation",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_88.png[/img]{当逃兵们转身欲走时，%motivator%上前一步，清了清嗓子。%SPEECH_ON%所以，就这么着了，是吧？你们打算像一群软蛋一样摆脱自己的责任？我懂你们的感受。我知道你们觉得这场战争毫无意义，不愿为某个高高在上、根本不关心你们的贵族卖命。这很公平。但多年以后，当你们醒来，膝上颠着你们的孙子，他会问起你们当年打仗的事。而你们就只能对那个小男孩撒谎。%SPEECH_OFF% | %motivator%将手指放在唇边，吹出一声尖锐的口哨。逃兵们转向他，他开始讲话。%SPEECH_ON%就这么定了，是吧？你们要故意给自己背上这个包袱？到时候你们要怎么跟自己的孩子说，嗯？说你们是没出息的逃兵，抛下战友替你们去死？别搞错了，你们的缺席会让本不该死的人送命！你们不在场的影响将远超你们的想象！%SPEECH_OFF% | %motivator%向逃兵们喊道。%SPEECH_ON%好吧，那你们现在就走。扔掉你们的旗帜，就当这场战役结束了。那要是%feudfamily%赢了怎么办，啊？%SPEECH_OFF%一个逃兵耸耸肩。%SPEECH_ON%他们又不认识我。我要回家种地去。%SPEECH_OFF%%motivator%大笑着摇了摇头。%SPEECH_ON%是吗？那当这些外乡人来到你家门口时你怎么办？当他们看到你妻子时？当他们看到你孩子时？你以为这仗到底是为了什么？到时候你根本无家可归了，蠢货！%SPEECH_OFF%}{逃兵们权衡了他们的选择，最终同意跟你回去。 | 逃兵们聚在一起商量，达成了某种共识。散开后，他们的头领走上前来。%SPEECH_ON%尽管有人反对，我们还是同意跟你回军营。希望我不会为此后悔。%SPEECH_OFF% | 经过短暂讨论后，逃兵们进行了投票。虽然不是全票通过，但他们达成了一致：他们会跟你回去见%commander%。 | 逃兵们争论着下一步该怎么办。不可避免地，他们进行了投票。果然，投票结果是平局。于是他们同意抛硬币决定：正面回军营，反面离开。他们的头领抛起硬币，所有人都盯着那枚旋转闪烁的硬币。硬币落下来是正面。看到结果后，每个人都叹了口气，仿佛运气让他们不用承担做出重大抉择的责任。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "你做了正确的决定。",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						this.Contract.m.Dude = null;
						this.Contract.setState("Running_ReturnAfterIntercept");
						return 0;
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local highest_bravery = 0;
				local best;

				foreach( bro in brothers )
				{
					if (bro.getCurrentProperties().getBravery() > highest_bravery)
					{
						best = bro;
					}
				}

				this.Contract.m.Dude = best;
				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "DesertersRefuseThreats",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_88.png[/img]{%bigdog%踏步上前，将武器扛在肩上，随意地转动着。他点头道。%SPEECH_ON%你们怕%commander%。我懂。你们了解他，了解他的脾气和他的手段。问题是……%SPEECH_OFF%这佣兵咧嘴一笑，狡黠的笑容映在他闪亮的刀锋上。%SPEECH_ON%你们了解我吗？%SPEECH_OFF% | 逃兵们眼看就要离开，%bigdog%响亮地吹了声口哨。%SPEECH_ON%嘿，你们这群渣滓，我的指挥官给你们下了命令。%SPEECH_OFF%一个逃兵嗤笑道。%SPEECH_ON%是吗？他又不是我们的指挥官，所以去他妈的命令。%SPEECH_OFF%%bigdog%抽出一把巨大的刀，插进地里。他双手交叠按在刀柄上。%SPEECH_ON%你们怕%commander%，这没关系。但你要是继续当个小混蛋，我的朋友，咱们很快就会知道你到底该怕谁了。%SPEECH_OFF% | 逃兵们转身准备离开。%bigdog%掏出一把巨大的刀，当啷一声敲在盔甲上。逃兵们缓缓转过身来。%bigdog%笑了笑。%SPEECH_ON%你们有谁尿过裤子吗？%SPEECH_OFF%一个逃兵摇了摇头。%SPEECH_ON%喂……喂，哥们，别他妈说这种话。%SPEECH_OFF%%bigdog%猛地抓起刀，刀尖指向那个逃兵。%SPEECH_ON%哦，你想让我闭嘴？再这样跟我说话，这儿很快就没人能说话了%SPEECH_OFF%}{逃兵们未能达成一致，于是进行了投票。继续逃跑的选择获得了多数票。他们的头领告知了你这个民主的结果并向你道别。%commander%不会高兴的，但你拔出了剑，告诉他们只剩下另一条路可走。那头领转过身，拔出他的刀并点了点头。%SPEECH_ON%好吧，我就知道你们大老远跑来不是为了听我们说再见的。拿起武器，兄弟们。%SPEECH_OFF% | %commander%会对此大为光火，但逃兵们拒绝回来。他们认为没有理由再跳回那个火坑。你祝他们的头领好运。他向你道谢，但当你拔出武器，%companyname%的其余人也随之效仿时，他迅速沉默下来。那头领叹了口气。%SPEECH_ON%是啊，我猜就会是这样。%SPEECH_OFF%你点点头。%SPEECH_ON%不是针对你个人。我不在乎你们做什么，但我们收了钱，就得把事办了。%SPEECH_OFF% | 逃兵们无法做出决定，于是诉诸于运气：他们的头领掏出一枚硬币抛向空中。正面回营地，反面继续离开。硬币落下来是反面。逃兵们集体松了一口气。他们的头领拍了拍你的肩膀。%SPEECH_ON%命运已经为我们做出了抉择。%SPEECH_OFF%你点点头，拔出了你的剑，战团的其他人也照做了。%SPEECH_ON%等我们宰你们这帮人的时候，记住这一点。%SPEECH_OFF%那头领抽出他的刀，无力地笑了笑。%SPEECH_ON%没关系。我们宁愿死在自由的门槛上，也不愿回到那种苦役中去。%SPEECH_OFF% | 那头领礼貌地拒绝回来。%SPEECH_ON%我们不是轻率地选择这条路的，佣兵。我们不回去了。%SPEECH_OFF%你命令%companyname%拔出他们的兵刃。逃兵的头领叹了口气，但理解地点了点头。%SPEECH_ON%我想事已至此，无法改变了。我们讨论过这个，我们宁愿死在这里，走在我们自己想走的路上，也不愿在外面听凭某个走狗的命令去死。%SPEECH_OFF%你耸耸肩回应道。%SPEECH_ON%我们只是收钱办事。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "让我们结束这一切……",
					function getResult()
					{
						this.Contract.m.Dude = null;
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos(), true);
						p.CombatID = "Deserters";
						p.Music = this.Const.Music.CivilianTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.TemporaryEnemies = [
							this.Contract.getFaction()
						];
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];
						p.EnemyBanners = [
							"banner_deserters"
						];
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local candidates = [];

				foreach( bro in brothers )
				{
					if (bro.getSkills().hasSkill("trait.player"))
					{
						continue;
					}

					if (bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getSkills().hasSkill("trait.brute") || bro.getBackground().getID() == "background.raider" || bro.getBackground().getID() == "background.sellsword" || bro.getBackground().getID() == "background.hedge_knight" || bro.getBackground().getID() == "background.brawler")
					{
						candidates.push(bro);
					}
				}

				if (candidates.len() == 0)
				{
					candidates = brothers;
				}

				this.Contract.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];
				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "DesertersRefuseMotivation",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_88.png[/img]{当逃兵们转身欲走时，%motivator%上前一步，清了清嗓子。%SPEECH_ON%所以，就这么着了，是吧？你们打算像一群软蛋一样摆脱自己的责任？我懂你们的感受。我知道你们觉得这场战争毫无意义，不愿为某个高高在上、根本不关心你们的贵族卖命。这很公平。但多年以后，当你们醒来，膝上颠着你们的孙子，他会问起你们当年打仗的事。而你们就只能对那个小男孩撒谎。%SPEECH_OFF% | %motivator%将手指放在唇边，吹出一声尖锐的口哨。逃兵们转向他，他开始讲话。%SPEECH_ON%就这么定了，是吧？你们要故意给自己背上这个包袱？到时候你们要怎么跟自己的孩子说，嗯？说你们是没出息的逃兵，抛下战友替你们去死？别搞错了，你们的缺席会让本不该死的人送命！你们不在场的影响将远超你们的想象！%SPEECH_OFF% | %motivator%向逃兵们喊道。%SPEECH_ON%好吧，那你们现在就走。扔掉你们的旗帜，就当这场战役结束了。那要是%feudfamily%赢了怎么办，啊？%SPEECH_OFF%一个逃兵耸耸肩。%SPEECH_ON%他们又不认识我。我要回家种地去。%SPEECH_OFF%%motivator%大笑着摇了摇头。%SPEECH_ON%是吗？那当这些外乡人来到你家门口时你怎么办？当他们看到你妻子时？当他们看到你孩子时？你以为这仗到底是为了什么？到时候你根本无家可归了，蠢货！%SPEECH_OFF%}{逃兵们未能达成一致，于是进行了投票。继续逃跑的选择获得了多数票。他们的头领告知了你这个民主的结果并向你道别。%commander%不会高兴的，但你拔出了剑，告诉他们只剩下另一条路可走。那头领转过身，拔出他的刀并点了点头。%SPEECH_ON%好吧，我就知道你们大老远跑来不是为了听我们说再见的。拿起武器，兄弟们。%SPEECH_OFF% | %commander%会对此大为光火，但逃兵们拒绝回来。他们认为没有理由再跳回那个火坑。你祝他们的头领好运。他向你道谢，但当你拔出武器，%companyname%的其余人也随之效仿时，他迅速沉默下来。那头领叹了口气。%SPEECH_ON%是啊，我猜就会是这样。%SPEECH_OFF%你点点头。%SPEECH_ON%不是针对你个人。我不在乎你们做什么，但我们收了钱，就得把事办了。%SPEECH_OFF% | 逃兵们无法做出决定，于是诉诸于运气：他们的头领掏出一枚硬币抛向空中。正面回营地，反面继续离开。硬币落下来是反面。逃兵们集体松了一口气。他们的头领拍了拍你的肩膀。%SPEECH_ON%命运已经为我们做出了抉择。%SPEECH_OFF%你点点头，拔出了你的剑，战团的其他人也照做了。%SPEECH_ON%等我们宰你们这帮人的时候，记住这一点。%SPEECH_OFF%那头领抽出他的刀，无力地笑了笑。%SPEECH_ON%没关系。我们宁愿死在自由的门槛上，也不愿回到那种苦役中去。%SPEECH_OFF% | 那头领礼貌地拒绝回来。%SPEECH_ON%我们不是轻率地选择这条路的，佣兵。我们不回去了。%SPEECH_OFF%你命令%companyname%拔出他们的兵刃。逃兵的头领叹了口气，但理解地点了点头。%SPEECH_ON%我想事已至此，无法改变了。我们讨论过这个，我们宁愿死在这里，走在我们自己想走的路上，也不愿在外面听凭某个走狗的命令去死。%SPEECH_OFF%你耸耸肩回应道。%SPEECH_ON%我们只是收钱办事。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "让我们结束这一切……",
					function getResult()
					{
						this.Contract.m.Dude = null;
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos(), true);
						p.CombatID = "Deserters";
						p.Music = this.Const.Music.CivilianTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.TemporaryEnemies = [
							this.Contract.getFaction()
						];
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];
						p.EnemyBanners = [
							"banner_deserters"
						];
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local highest_bravery = 0;
				local best;

				foreach( bro in brothers )
				{
					if (bro.getCurrentProperties().getBravery() > highest_bravery)
					{
						best = bro;
					}
				}

				this.Contract.m.Dude = best;
				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "DesertersAftermath",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_22.png[/img]{%randombrother%在一具尸体的罩袍上擦拭他的刀刃。%SPEECH_ON%可惜他们选了这么条路。他们本可以活下来的。他们有过选择。%SPEECH_OFF%你耸耸肩回应。%SPEECH_ON%他们当时已是无路可逃。只不过选择了由我们来当行刑人。%SPEECH_OFF% | 逃兵们死得到处都是。有一个正趴在地上爬行，拼命想远离%commander%的军队。你蹲到他身边，手握匕首准备做个了结。他却对你笑了。%SPEECH_ON%没必要弄脏你的短剑，佣兵。给我点时间就行。这就是我……最，呃……%SPEECH_OFF%一股鲜血从他下巴涌出。他眯起眼睛，直直望着前方，然后慢慢地瘫倒在地。你站起身，下令战团准备离开。 | 最后一名逃兵被发现靠在一块岩石上，双手无力地垂在两侧，掌心朝上，像个生意兴隆的乞丐。鲜血正从他的胸口和腿部流下，在地面汇聚成血泊。他凝视着那滩血。%SPEECH_ON%我没事，谢谢你的关心，佣兵。%SPEECH_OFF%你告诉他你什么都没说。他看向你，脸上是真真切切的困惑。%SPEECH_ON%你没说吗？那好吧。%SPEECH_OFF%片刻之后，他侧身倒下，面容凝固成那种死寂的样子。 | 有些男人就喜欢在注定灭亡的生命里玩世不恭。当所有的选择和自由都被剥夺，除了在这残酷的命运面前放声大笑，还能做什么呢？每个逃兵死去时，脸上都带着一种全然镇定的神情。 | 最后一个活着的逃兵凝望着天空。他在空中无力地摆动手。%SPEECH_ON%该死的，我就想看见一只。%SPEECH_OFF%你问他到底想看见什么。他笑了，一阵由衷的轻笑很快被涌上的痛苦打断。%SPEECH_ON%鸟。哦，有一只。它那么大，那么美。%SPEECH_OFF%他指着天空，你抬头望去。一只秃鹫正在头顶盘旋。当你再次低头看去时，那人已经死了。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "很不幸，但必须如此。",
					function getResult()
					{
						this.Contract.setState("Running_ReturnAfterIntercept");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "WarcampDay2End",
			Title = "在军营……",
			Text = "[img]gfx/ui/events/event_96.png[/img]{%commander%通知你，明天就是大战之日。你回到自己的帐篷，准备好好休息，这是你应得的。 | 你回去向%commander%汇报了消息。他反应非常沉闷，思绪完全被明天即将到来的那场大规模决定性战役所占据。一天结束，你决定回去休息，等待清晨来临。 | 你向%commander%报告，但他几乎没反应。他简直活在他的作战地图里了。%SPEECH_ON%明天见，佣兵。今晚好好休息。%SPEECH_OFF% | %commander%让你进入他的帐篷，但似乎无视了你的报告。相反，他正专注于他的地图，并继续与他的副官们辩论明天的作战计划。你决定回去好好休息一晚。 | %commander%对你的报告点了点头，但除此之外并没有真正留意你。一大堆作战地图铺在桌子上，他的眼睛正死死盯着那些。你理解这一点：明天就是大战，他有更重要的事情要考虑。你决定去安心睡觉。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "今晚好好休息，明天战斗就要开始了！",
					function getResult()
					{
						this.Flags.set("LastDay", this.World.getTime().Days);
						this.Flags.set("NextDay", 3);
						this.Contract.setState("Running_WaitForNextDay");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "WarcampDay3",
			Title = "在军营……",
			Text = "[img]gfx/ui/events/event_78.png[/img]{%commander%在一群士兵面前踱步。有些人面带倦容地呆立着，显然彻夜未眠。另一些人仍因紧张而颤抖。指挥官向他们喊道。%SPEECH_ON%你们害怕吗？你们恐惧吗？这很正常。要是你们不怕，我反而要担心了。%SPEECH_OFF%零散的笑声提振了气氛。他继续说道。%SPEECH_ON%但现在，我要求你们不要为自己的小命害怕，而要为了你们的同胞、你们的家人而恐惧！他们才是我们今天为之奋战的人！让我们明天再为自己担忧吧，因为今天，我们是个真正的男人！%SPEECH_OFF%笑声变成了震耳欲聋的欢呼。 | %commander%让他的士兵们在他面前集合。步兵、弓箭手、预备队，所有人都站在凛冽的风中。指挥官上下打量着他们。%SPEECH_ON%我知道你们在想什么，‘我为啥要替这个可怜虫卖命？他要真那么高贵，他那高高在上的架子在哪儿呢？’%SPEECH_OFF%士兵们笑了起来，缓解了一些紧张情绪。%commander%继续说道。%SPEECH_ON%好吧，不管是不是可怜虫，我最爱的就是好好干一仗。而我来这就是为了干仗，兄弟们。我会和你们一起冲进去，战斗到脱力，战斗到最后一刻，因为这就是战士该做的事！%SPEECH_OFF%士兵们举起手臂欢呼。他们的指挥官转过身，举起剑。%SPEECH_ON%现在跟我上，我们要让%feudfamily%瞧瞧什么叫真正的男人！%SPEECH_OFF% | %commander%那支混杂的军队为这场大战集结了起来。指挥官在战线上来回走着，开始演讲。%SPEECH_ON%你们有些人看起来没睡醒。怎么了，紧张？我也是！一宿没合眼。%SPEECH_OFF%这话让一些人放松了下来。知道自己并非孤身一人总是好的，无论是肉体上还是精神上。他继续说道。%SPEECH_ON%但为了今天，为了这场战斗，我清醒得很。我绝不会错过它。所以兄弟们，擦亮你们的眼睛，因为今天我们要让%feudfamily%那些杂种知道，他们真该老老实实待在床上！%SPEECH_OFF% | %commander%向他正在准备的部下讲话。你一个字也没听。相反，你在为你自己的人马准备即将到来的战斗。 | 你看着%commander%走向他的士兵，向他们灌输鼓舞人心的话语。很多话你以前都听过。事实上，这些话是不是来自某个古老的卷轴？来自一个其精髓代代相传的励志演说家？%randombrother%轻笑着走到你身边。%SPEECH_ON%我知道那指挥官说的都是空话，可我还是忍不住想做一两个俯卧撑。%SPEECH_OFF%你笑着让那人归队，和其他兄弟站在一起。他调侃地回嘴。%SPEECH_ON%会有演讲吗？%SPEECH_OFF%你推了他一把，他笑着转过身去。 | %commander%在他的战线前来回踱步。他走到一个男孩面前，那孩子抖得盔甲都在咔嗒作响。%SPEECH_ON%孩子，你让我想起了我自己，知道吗？你以为我没经历过你这样的处境？嘿，放轻松，因为有一天你可能也会站在我这个位置。%SPEECH_OFF%男孩抬起头，眼中闪现出新的光芒。他稳住自己，坚定地点了点头。指挥官提高嗓门，喝令他的士兵为他们生命中最重要的一战做好准备。 | %commander%在他的士兵中穿行，大声宣称这场战斗将是他们一生中最重要的经历。你不太确定，但可以确定的是，这将是他们中许多人最后的经历。然而，战争的残酷并非最好的激励，所以你闭口不言。 | 你系紧靴子，而%commander%正用一场关于贵族家族间战争重大意义的浮夸演讲来激励他的士兵。那些话语很有说服力。必须如此，如果想要这些在战争中捞不到一分好处的人去送死的话。 | %commander%走到他的士兵面前站定。他身着华丽的战甲，屹立于士兵之中，犹如沙滩中的珍珠。他解释说他们必须赢得这场战斗，因为失败可能就意味着输掉整场战争。你觉得他是在用尽一切办法让士兵们投入。你才不会为了那些娇贵的贵族去死，就因为某个追求荣誉的指挥官从政治氛围里臆测出战斗的必要性。不过话说回来，这种态度也正是你一开始成为佣兵的原因。 | 战争真是件要命的事。一个人该如何推销它？%commander%尽了最大努力，向他的士兵讲话时滔滔不绝地论述着多个主题。首先，他说这是光荣之举。然后他说这里士兵众多，无疑增加了别的倒霉蛋替你去死的几率。人多有助于保命！接着他又说，输掉这场战斗可能意味着失去他们的妻子、孩子和国家。最后这一点似乎效果最好，士兵们爆发出愤怒和充满斗志的咆哮。透过此刻欢呼的士兵人群，你可以轻易分辨出那些愤世嫉俗者和鸡奸犯。 | %commander%用深沉而有力的语气对他的士兵讲话。%SPEECH_ON%啊，你们有些人看起来非常兴奋。等不及要宰了%feudfamily%的人了，是吧？我懂这种感觉。%SPEECH_OFF%一阵零星的、带着紧张的笑声。指挥官继续说道。%SPEECH_ON%兄弟们，把你们的家人放在心上，因为他们今天无疑正指望着我们！%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "前进，兄弟们，我们还有仗要打！",
					function getResult()
					{
						this.Contract.setState("Running_FinalBattle");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BattleLost",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_86.png[/img]{到处都是尸体。%commander%的轮廓高出尸体之上，%commander%的身影矗立在尸堆之上，他的盔甲闪烁着寒光，包裹着已经失去生命的肉体。%employer%无疑会为此次战败感到悲痛，但事已至此，无力回天。 | 战斗失败了！%commander%的部下几乎被屠杀殆尽，只剩下零星幸存者，指挥官本人也已倒下。秃鹫已在头顶盘旋，%feudfamily%的士兵正有条不紊地检查堆积如山的尸体，杀死任何装死的人。你迅速集结%companyname%的残余人员撤退。%employer%无疑会对这一结果感到惊恐，但现在已经无能为力了。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "没有谁能百战百胜……",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "输掉了一场重要的战斗");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BattleWon",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_87.png[/img]{你们胜利了！嗯，你和%commander%的部队胜利了。战斗已经获胜，这才是最重要的。你踏过堆积如山的尸体，准备返回向你的雇主复命。 | 尸体堆积如山，足有五层高。秃鹫正从尸堆上啄食碎肉。伤兵在乞求帮助。无疑，在外人看来，这里似乎没有任何赢家。然而，%commander%却咧嘴笑着走了过来。%SPEECH_ON%{干得好，佣兵！你该回去找你的雇主，告诉他这里发生了什么。 | 哟，这不是佣兵老兄吗。之前还不确定你能不能活下来。你该回去找你的雇主，告诉他这里发生了什么。}%SPEECH_OFF% | 一个伤兵在你脚边乞求。你分不清他是%commander%的人还是敌人。突然，一支矛猛地刺穿了那人的头颅，让他脸上永远挂着斜眼的表情。你抬眼望去，看见处决者正双手搭在矛柄上，脸上带着大功告成的神色。他伸出一根手指。%SPEECH_ON%你就是那个佣兵，对吧？%commander%让我告诉你，你该回去找你的雇主了。你听懂我在说什么吗？%SPEECH_OFF%你点了点头。尸堆中传来一声呻吟。那人提起他的长矛，用另一只手接住。%SPEECH_ON%得嘞，继续干活！%SPEECH_OFF% | 战斗结束，你看见%commander%咆哮着撕扯掉他的盔甲和衬衣。他炫耀着自己的伤口，鼓起肌肉让伤口裂开，看着像刚切开的水果渗着汁液。他命令他的士兵们也照做，把每个人转过来让他检查后背。%SPEECH_ON%你们看，像我们这样的好战士，伤口都在这里，这里，还有这里……%SPEECH_OFF%他指着自己身体的正面各处，然后指向自己的后背。%SPEECH_ON%但是这里，没有人这里受伤。因为我们到死都在前进，绝不后退一步！对不对？%SPEECH_OFF%士兵们欢呼起来，尽管有些人脚步踉跄，伤口还在淌血。你无视这番表演，集结起%companyname%的成员。你的雇主肯定会很高兴听到这里的结果，而这才是你真正关心的。 | %commander%在战斗后向你打招呼。他浑身浸透鲜血，仿佛砍下过某人的头颅，然后在喷涌的颈血下沐浴过。他笑起来时，露出一排闪亮的白牙。%SPEECH_ON%这才叫真正的战斗。%SPEECH_OFF%你问他如果输了是否还会这么说。他大笑起来。%SPEECH_ON%哦，我们这儿还有个怀疑论者？不，我根本没打算在这里输掉，而且就算输了，我也没打算活着亲眼见证自己的失败。%SPEECH_OFF%你点点头回应。%SPEECH_ON%能活着亲眼目睹自己最大失败的人可不多。和你并肩作战很愉快，指挥官，但我现在必须回去见雇主了。%SPEECH_OFF%指挥官点了点头，然后转过身，大喊着让人给他拿条毛巾来。 | 你你发现%commander%正蹲在一个受伤的敌兵身旁。他用一把匕首在那可怜人的胸前来回划着，刮擦着盔甲。指挥官看着你。%SPEECH_ON%你怎么想，佣兵？我要不要留他一命？%SPEECH_OFF%俘虏盯着你，他向前探着头，用力眨着眼睛。你猜想这意思是“要”。你耸耸肩。%SPEECH_ON%这不是我说了算的。听着，和你并肩作战很愉快，但我现在必须回去见雇主了。%SPEECH_OFF%%commander%点了点头。%SPEECH_ON%那就后会有期。%SPEECH_OFF%当你离开时，指挥官仍弓着身子待在他的俘虏旁边，刀刃来回刮擦着，叮当作响，一遍，又一遍，又一遍。 | 你看见%commander%正将匕首捅进一个伤兵的胸膛侧面。倒下的敌人因剧痛而抽搐，但他随后迅速衰弱，片刻间便瘫软下来。随着刀刃拔出，一股鲜血涌出，指挥官随手在裤腿上擦了擦匕首。%SPEECH_ON%直插心脏，干净利落。还能指望有更好的死法吗？%SPEECH_OFF%你点点头，告诉指挥官你要回去找你的雇主领酬劳了。 | 你看着%commander%和一队士兵在战场上巡弋，杀掉他们发现的每一个伤兵。%randombrother%问我们是否要向指挥官报告。你摇了摇头。%SPEECH_ON%不用。我们去找雇主报告。让这鬼地方见鬼去吧，咱们去拿钱。%SPEECH_OFF% | 战场上到处都是死人和一心求死之人。%commander%的士兵们正在收治己方伤员，并杀掉发现的任何敌人。指挥官本人拍了拍你的肩膀，一点血沫溅上了你的脸颊。%SPEECH_ON%干得好，佣兵。我之前还不确定你的人能不能守住约定，但你们确实做到了。我相信你的雇主见到你会非常高兴的。%SPEECH_OFF% | 你四处召集%companyname%的成员。%commander%向你走来，用一块布擦拭着剑身，浓稠的血块随之剥落。%SPEECH_ON%这么快就走？%SPEECH_OFF%你点点头。%SPEECH_ON%付我们钱的是我们的雇主，所以我们要去找他。%SPEECH_OFF%指挥官收剑入鞘，也点了点头。%SPEECH_ON%有道理。和你并肩作战很愉快，佣兵。真可惜不能把你招进我的队伍。我猜你们这帮家伙还得继续追着钱跑，是吧？%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "胜利！",
					function getResult()
					{
						local faction = this.World.FactionManager.getFaction(this.Contract.getFaction());
						local settlements = faction.getSettlements();
						local origin = settlements[this.Math.rand(0, settlements.len() - 1)];
						local party = faction.spawnEntity(this.World.State.getPlayer().getTile(), origin.getName() + "战团", true, this.Const.World.Spawn.Noble, 150);
						party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + faction.getBannerString());
						party.setDescription("听命于当地领主的职业军人。");
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer%简直就是只醉猫。他隔着杯沿盯着你，对着杯心说话然后才喝下去。%SPEECH_ON%啊见鬼，你回来了。%SPEECH_OFF%他吞咽时杯子掉落了。你迅速报告了你的成功。这人笑了，尽管他醉得不止天南地北。%SPEECH_ON%那么事情办成了。胜利是我的。这正是我想要的。我希望没有太多人因为做我想做的事而死掉。%SPEECH_OFF%他突然大笑起来。他的一名护卫递给你一个袋子，然后把你请出了房间。 | %employer%拿着一袋克朗欢迎你回来。%SPEECH_ON%{胜利是我们的，佣兵。 | 干得真漂亮，佣兵。胜利属于我们，而且有部分胜利要归功于你。你的%reward_completion%克朗就在这里。 | 是多少来着，%reward_completion%克朗？为击败那支军队，为了让我们离结束这场战争更近一步，这点代价算小的。 | 我的小鸟告诉我你在那里干得很好，佣兵。当然，他们也告诉我%feudfamily%的军队正在撤退。我还能有什么不满足的呢？你的%reward_completion%克朗，如约奉上。}%SPEECH_OFF% | %employer%正在对他的指挥官们大声发号施令。看到你，他迅速指向你这边。%SPEECH_ON%看到这边这个人了吗？他是个能成事的人。护卫！把%reward_completion%克朗给他。要是我能付钱让你们这群不中用的狗东西干得有他一半好就好了！%SPEECH_OFF% | %employer%正在花园里对一群女士讲笑话。你闯入她们中间，浑身血污，沾满泥泞。女士们倒吸一口气退开了。%employer%大笑起来。%SPEECH_ON%啊，佣兵回来了！你可真受女士欢迎啊，雇佣兵。我真希望能把这些好姑娘中的一个许配给你，但恐怕你就算只是碰一下她们，她们的父亲都会要了你的命根子。%SPEECH_OFF%其中一个女人抚摸自己的胸口。%SPEECH_OFF%其中一位女士用手拂过自己的胸部。%SPEECH_ON%如果他喜欢，他可以碰我。%SPEECH_OFF%%employer%又笑了。%SPEECH_ON%哦亲爱的，你惹的麻烦还不够多吗？快走吧，女士们，去告诉我的一个护卫，让他拿一袋%reward_completion%克朗来。%SPEECH_OFF% | %employer%正试图训练他的猫握手。%SPEECH_ON%看看这个小混蛋。它甚至不看我一眼！我喂它的时候，它表现得好像这是我该做的。只要我想，我就能把这小混球踢出窗外。%SPEECH_OFF%你回应道。%SPEECH_ON%它摔不着的。%SPEECH_OFF%贵族点点头。%SPEECH_ON%这就是最他妈气人的地方。%SPEECH_OFF%你的雇主把这只顽强的猫拎起来扔出了窗外。他拍拍手，然后给了你一袋%reward_completion%克朗。%SPEECH_ON%如果我看起来心不在焉请见谅。你在那里干得很好。%feudfamily%的军队在撤退，这些天我不能再要求更多了。%SPEECH_OFF% | %employer%正在对他的一名指挥官进行临时审判。你不清楚是为了什么，但那指挥官的下巴抬得高高的，带着挑衅。结束时，他被打了一顿带了出去。%employer%招手让你过去。%SPEECH_ON%{谢谢你，雇佣兵。胜利属于我们，如果没有你的帮助，我不确定还是不是这个结果。当然，你的%reward_completion%克朗报酬，按约定给你。 | 那人拒绝执行我的命令，事情就是这样。然而你，表现得出类拔萃！你的%reward_completion%克朗，按约定给你。 | 那人不愿为我而战。说他不愿举剑对抗他为敌人效力的同母异父兄弟。真是胡说八道。你干得很好，佣兵。你的%reward_completion%克朗，如约奉上。}%SPEECH_OFF% | 你回到%employer%那里，他正站在一排指挥官中间。%SPEECH_ON%{谢谢你，雇佣兵。胜利现在属于我们了。给你，约定好的%reward_completion%克朗。 | 战争还在继续，但由于你，它或许快要结束了。随着敌军全面撤退，我们离一劳永逸地结束这该死的事情更近了一步。这是你应得的%reward_completion%克朗，佣兵。}%SPEECH_OFF% | %employer%的一名护卫阻止你靠近。他拿着一袋%reward_completion%克朗，迅速递了过来。%SPEECH_ON%大人告诉我你在战斗中表现很好。%SPEECH_OFF%护卫尴尬地环顾四周。%SPEECH_ON%我……我要说的就这些。%SPEECH_OFF% | 你进入%employer%的作战室，里面一个指挥官都没有。%SPEECH_ON%很高兴见到你，佣兵。我相信你也知道，%feudfamily%的军队已经在撤退了。谁知道如果没有你我们能否做到呢。专为你准备的%reward_completion%克朗。拿着。%SPEECH_OFF% | %employer%正在喂一只高大、看起来傻乎乎的鸟。你从未见过那种体型的鸟，所以保持着距离。这位被逗乐的贵族一边让那生物从他手上啄食一边说话。%SPEECH_ON%没什么好怕的，佣兵。只是跟你说一声，我已经了解了你的事迹。%feudfamily%的军队正在撤退，所以我们正一步步接近结束这场该死的战争。那边的那个护卫，拿着袋子的那个，有你的%reward_completion%克朗。%SPEECH_OFF%你离开时，那只鸟拍打着翅膀发出刺耳的叫声。 | %employer%正在一个人造池塘边消磨时间。他正用温柔的手舀起青蛙。那些黏糊糊的小东西扭动着跳开了。%SPEECH_ON%胜利属于我们。我得说干得漂亮，佣兵。我给了你一个巨大的机会，而你确实……把握住了它。%SPEECH_OFF%你一定是没藏住你的窘态，因为这位贵族迅速站起身来，在裤子上擦了擦手。%SPEECH_ON%见鬼，没那么糟吧，有吗？哎，那边的护卫有你的%reward_completion%克朗报酬。}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "赢得了一场重要的战斗");
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
	}

	function onCommanderPlaced( _entity, _tag )
	{
		_entity.setName(this.m.Flags.get("CommanderName"));
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noblehouse",
			this.World.FactionManager.getFaction(this.getFaction()).getName()
		]);
		_vars.push([
			"feudfamily",
			this.World.FactionManager.getFaction(this.m.Flags.get("EnemyNobleHouse")).getName()
		]);
		_vars.push([
			"commander",
			this.m.Flags.get("CommanderName")
		]);
		_vars.push([
			"objective",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.m.Destination.getName()
		]);
		_vars.push([
			"cost",
			this.m.Flags.get("RequisitionCost")
		]);
		_vars.push([
			"bribe",
			this.m.Flags.get("Bribe")
		]);

		if (this.m.Flags.get("IsInterceptSupplies"))
		{
			_vars.push([
				"supply_start",
				this.World.getEntityByID(this.m.Flags.get("InterceptSuppliesStart")).getName()
			]);
			_vars.push([
				"supply_dest",
				this.World.getEntityByID(this.m.Flags.get("InterceptSuppliesDest")).getName()
			]);
		}

		if (this.m.Dude != null)
		{
			_vars.push([
				"bigdog",
				this.m.Dude.getName()
			]);
			_vars.push([
				"motivator",
				this.m.Dude.getName()
			]);
		}

		if (this.m.Destination == null)
		{
			_vars.push([
				"direction",
				this.m.WarcampTile == null ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.WarcampTile)]
			]);
		}
		else
		{
			_vars.push([
				"direction",
				this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Destination.getTile())]
			]);
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
			}

			if (this.m.Warcamp != null && !this.m.Warcamp.isNull())
			{
				this.m.Warcamp.die();
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isCivilWar())
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

		if (this.m.Warcamp != null && !this.m.Warcamp.isNull())
		{
			_out.writeU32(this.m.Warcamp.getID());
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

		local warcamp = _in.readU32();

		if (warcamp != 0)
		{
			this.m.Warcamp = this.WeakTableRef(this.World.getEntityByID(warcamp));
		}

		this.contract.onDeserialize(_in);
	}

});
