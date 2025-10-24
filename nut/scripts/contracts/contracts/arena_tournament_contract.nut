this.arena_tournament_contract <- this.inherit("scripts/contracts/contract", {
	m = {},
	function create()
	{
		this.contract.create();
		this.m.DifficultyMult = 1.3;
		this.m.Type = "contract.arena_tournament";
		this.m.Name = "竞技场锦标赛";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 1.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		local items = [];
		items.extend(this.Const.Items.NamedWeapons);
		items.extend(this.Const.Items.NamedHelmets);
		items.extend(this.Const.Items.NamedArmors);
		local item = this.new("scripts/items/" + items[this.Math.rand(0, items.len() - 1)]);
		this.m.Flags.set("PrizeName", item.createRandomName());
		this.m.Flags.set("PrizeScript", item.ClassNameHash);

		if (item.isItemType(this.Const.Items.ItemType.Weapon))
		{
			this.m.Flags.set("PrizeType", "weapon");
		}
		else if (item.isItemType(this.Const.Items.ItemType.Shield))
		{
			this.m.Flags.set("PrizeType", "shield");
		}
		else if (item.isItemType(this.Const.Items.ItemType.Armor))
		{
			this.m.Flags.set("PrizeType", "armor");
		}
		else if (item.isItemType(this.Const.Items.ItemType.Helmet))
		{
			this.m.Flags.set("PrizeType", "helmet");
		}

		this.m.Flags.set("Round", 1);
		this.m.Flags.set("RewardApplied", 0);
		this.m.Flags.set("Opponents1", this.getOpponents(1).I);
		this.m.Flags.set("Opponents2", this.getOpponents(2).I);
		this.m.Flags.set("Opponents3", this.getOpponents(3).I);
		this.contract.start();
	}

	function getOpponents( _round, _index = -1 )
	{
		local twists = [];

		if (_round >= 2)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Swordmaster);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, _d - this.Const.World.Spawn.Troops.Swordmaster.Cost); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Mercenary);
					}
				}

			});
		}

		if (_round == 3 && this.World.getTime().Days > 50 && this.Const.DLC.Wildmen)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Swordmaster, true);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, _d - this.Const.World.Spawn.Troops.Swordmaster.Cost * 2); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Mercenary);
					}
				}

			});
		}

		if (_round >= 2)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.HedgeKnight);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, _d - this.Const.World.Spawn.Troops.HedgeKnight.Cost); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Mercenary);
					}
				}

			});
		}

		if (_round == 3 && this.World.getTime().Days > 50 && this.Const.DLC.Wildmen)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.HedgeKnight, true);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, _d - this.Const.World.Spawn.Troops.HedgeKnight.Cost * 2); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Mercenary);
					}
				}

			});
		}

		if (_round == 3)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.HedgeKnight);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Swordmaster);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.BanditRaider, _d - this.Const.World.Spawn.Troops.HedgeKnight.Cost - this.Const.World.Spawn.Troops.Swordmaster.Cost); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.BanditRaider);
					}
				}

			});
		}

		if (_round == 3 && this.World.getTime().Days > 150 && this.Const.DLC.Wildmen)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.HedgeKnight, true);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Swordmaster, true);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.MasterArcher, true);
				}

			});
		}

		if (_round == 3)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.DesertDevil);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Swordmaster);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, _d - this.Const.World.Spawn.Troops.DesertDevil.Cost - this.Const.World.Spawn.Troops.Swordmaster.Cost); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.NomadOutlaw);
					}
				}

			});
		}

		if (_round == 3 && this.World.getTime().Days > 150 && this.Const.DLC.Wildmen)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.DesertDevil, true);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Swordmaster, true);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, _d - this.Const.World.Spawn.Troops.DesertDevil.Cost * 2 - this.Const.World.Spawn.Troops.Swordmaster.Cost * 2); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.NomadOutlaw);
					}
				}

			});
		}

		if (_round >= 2)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.DesertDevil);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, _d - this.Const.World.Spawn.Troops.DesertDevil.Cost); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.NomadOutlaw);
					}
				}

			});
		}

		if (_round == 3)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Executioner);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, _d - this.Const.World.Spawn.Troops.Executioner.Cost); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator);
					}
				}

			});
		}

		if (_round == 3 && this.World.getTime().Days > 50 && this.Const.DLC.Wildmen)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Executioner, true);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, _d - this.Const.World.Spawn.Troops.Executioner.Cost * 2); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator);
					}
				}

			});
		}

		if (_round == 3)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.DesertDevil);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Executioner);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, _d - this.Const.World.Spawn.Troops.DesertDevil.Cost - this.Const.World.Spawn.Troops.Executioner.Cost); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator);
					}
				}

			});
		}

		if (_round == 3 && this.World.getTime().Days > 150 && this.Const.DLC.Wildmen)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.DesertDevil, true);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Executioner, true);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, _d - this.Const.World.Spawn.Troops.DesertDevil.Cost * 2 - this.Const.World.Spawn.Troops.Executioner.Cost * 2); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator);
					}
				}

			});
		}

		if (_round == 3)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.DesertDevil);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.DesertStalker);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Executioner);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, _d - this.Const.World.Spawn.Troops.DesertDevil.Cost - this.Const.World.Spawn.Troops.Executioner.Cost - this.Const.World.Spawn.Troops.DesertStalker.Cost); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.NomadOutlaw);
					}
				}

			});
		}

		if (_round == 3 && this.World.getTime().Days > 150 && this.Const.DLC.Wildmen)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.DesertDevil, true);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.DesertStalker, true);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Executioner, true);
				}

			});
		}

		if (_round == 3 && this.World.getTime().Days > 50 && this.Const.DLC.Wildmen)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator, true);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, _d - this.Const.World.Spawn.Troops.Gladiator.Cost * 2); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator);
					}
				}

			});
		}

		if (_round == 3 && this.World.getTime().Days > 150 && this.Const.DLC.Wildmen)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator, true);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator, true);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, _d - this.Const.World.Spawn.Troops.Gladiator.Cost * 4); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator);
					}
				}

			});
		}

		if (_round == 2)
		{
			twists.push({
				R = 10,
				function F( _c, _d, _e )
				{
					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, _d); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Mercenary);
					}
				}

			});
		}

		if (_round == 3 && this.Const.DLC.Unhold)
		{
			twists.push({
				R = 10,
				function F( _c, _d, _e )
				{
					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Unhold, _d); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Unhold);
					}
				}

			});
		}

		if (_round == 3 && this.Const.DLC.Lindwurm)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					for( local i = 0; i < this.Math.min(3, _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Lindwurm, _d)); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Lindwurm);
					}
				}

			});
		}

		if (_round == 2)
		{
			twists.push({
				R = 10,
				function F( _c, _d, _e )
				{
					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.SandGolemMEDIUM, _d); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.SandGolemMEDIUM);
					}
				}

			});
		}

		if (_round == 2)
		{
			twists.push({
				R = 10,
				function F( _c, _d, _e )
				{
					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, _d); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator);
					}
				}

			});
		}

		if (_round == 1 && this.Const.DLC.Unhold)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Spider, _d); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Spider);
					}
				}

			});
		}

		if (_round <= 2)
		{
			twists.push({
				R = 10,
				function F( _c, _d, _e )
				{
					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, _d); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.NomadOutlaw);
					}
				}

			});
		}

		if (_round == 1)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Serpent, _d); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Serpent);
					}
				}

			});
		}

		if (_round == 1)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.HyenaHIGH, _d); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.HyenaHIGH);
					}
				}

			});
		}

		if (_index >= 0)
		{
			return {
				I = _index,
				F = twists[_index].F
			};
		}
		else
		{
			local maxR = 0;

			foreach( t in twists )
			{
				maxR = maxR + t.R;
			}

			local r = this.Math.rand(1, maxR);

			foreach( i, t in twists )
			{
				if (r <= t.R)
				{
					return {
						I = i,
						F = t.F
					};
				}
				else
				{
					r = r - t.R;
				}
			}
		}
	}

	function startTournamentRound()
	{
		local p = this.Const.Tactical.CombatInfo.getClone();
		p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
		p.CombatID = "Arena";
		p.TerrainTemplate = "tactical.arena";
		p.LocationTemplate.Template[0] = "tactical.arena_floor";
		p.Music = this.Const.Music.ArenaTracks;
		p.Ambience[0] = this.Const.SoundAmbience.ArenaBack;
		p.Ambience[1] = this.Const.SoundAmbience.ArenaFront;
		p.AmbienceMinDelay[0] = 0;
		p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Arena;
		p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Arena;
		p.IsUsingSetPlayers = true;
		p.IsFleeingProhibited = true;
		p.IsLootingProhibited = true;
		p.IsWithoutAmbience = true;
		p.IsFogOfWarVisible = false;
		p.IsArenaMode = true;
		p.IsAutoAssigningBases = false;
		local bros = this.getBros();

		for( local i = 0; i < bros.len() && i < 5; i = ++i )
		{
			p.Players.push(bros[i]);
		}

		p.Entities = [];
		local baseDifficulty = 45 + 10 * this.m.Flags.get("Round");
		baseDifficulty = baseDifficulty * this.getScaledDifficultyMult();
		local opponents = this.getOpponents(this.m.Flags.get("Round"), this.m.Flags.get("Opponents" + this.m.Flags.get("Round")));
		opponents.F(this, baseDifficulty, p.Entities);

		for( local i = 0; i < p.Entities.len(); i = ++i )
		{
			p.Entities[i].Faction <- this.getFaction();
		}

		this.World.Contracts.startScriptedCombat(p, false, false, false);
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"给至多五人装备竞技场项圈",
					"再次进入竞技场，开始第一轮比赛",
					"每场战斗都将一决生死，你将无法撤退或获得战利品",
					"每轮比赛结束后，你可以选择退出比赛获得安慰奖，或者立即开始下一轮。"
				];
				this.Contract.m.BulletpointsPayment = [
					"三轮全胜的奖品是名为%prizename%的著名%prizetype%"
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.Flags.set("Day", this.World.getTime().Days);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Flags.get("Round") > 1 && this.Contract.getBros() == 0)
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsFailure"))
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.World.getTime().Days > this.Flags.get("Day") + 1)
				{
					this.Contract.setScreen("Failure2");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("Round") > 1)
				{
					this.Contract.setScreen("Won" + this.Flags.get("Round"));
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Arena")
				{
					this.Flags.increment("Round");
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Arena")
				{
					this.Flags.set("IsFailure", true);
				}
			}

		});
	}

	function createScreens()
	{
		this.m.Screens.push({
			ID = "Task",
			Title = "竞技场内",
			Text = "",
			Image = "",
			List = [],
			ShowDifficulty = true,
			Options = [
				{
					Text = "{我们将赢得大奖!}",
					function getResult()
					{
						return "Overview";
					}

				},
				{
					Text = "{我们还没准备好。}",
					function getResult()
					{
						this.Contract.getHome().removeSituationByID("situation.arena_tournament");
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.State.getTownScreen().getMainDialogModule().reload();
						return 0;
					}

				}
			],
			function start()
			{
				this.Text = "[img]gfx/ui/events/event_155.png[/img]数十名男子在竞技场入口处往来徘徊。有人沉默伫立，不愿显露半分实力；另一些人却在大肆吹嘘，要么对自身武艺充满信心，要么想靠虚张声势来掩饰不足。\n\n";
				this.Text += "竞技场主，在你见过做着有趣工作的人里，是最不对自己工作感兴趣的，今天倒是格外兴致勃勃。他一手举着卷轴，另一手竖起三根手指。%SPEECH_ON%三轮！连打三轮！一轮接一轮，越打越凶险。用指定的五个人赢得所有三轮比赛，就能赢得一件名为%prizename%的著名%prizetype%！锦标赛！锦标赛！你参加吗？%SPEECH_OFF%";
				this.Text += "竞技场主继续说道。%SPEECH_ON%准备好后，让那些将参加战斗的人戴上我们提供的竞技场项圈。%SPEECH_OFF%";
			}

		});
		this.m.Screens.push({
			ID = "Overview",
			Title = "Overview",
			Text = "竞技场锦标赛规则如下。你同意这些条款吗？",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们参赛！",
					function getResult()
					{
						for( local i = 0; i < 5; i = ++i )
						{
							this.World.Assets.getStash().add(this.new("scripts/items/accessory/special/arena_collar_item"));
						}

						this.Contract.setState("Running");
						return 0;
					}

				},
				{
					Text = "我得考虑一下。",
					function getResult()
					{
						return 0;
					}

				}
			],
			ShowObjectives = true,
			ShowPayment = true,
			function start()
			{
				this.Contract.m.IsNegotiated = true;
			}

		});
		this.m.Screens.push({
			ID = "Start",
			Title = "竞技场内",
			Text = "[img]gfx/ui/events/event_155.png[/img]{当你们候场时，观众的嗜血穿过了黑暗，顶棚震落的尘埃如幕布垂下，跺脚声震耳欲聋。他们期待中低语，在杀戮中咆哮。战斗间歇的宁静转瞬即逝，随着生锈栅门在锁链刺耳声中升起，人群再度沸腾。你踏入光线的刹那，雷鸣般的喧嚣直击心脏，足以唤醒死尸。 | 竞技场看台摩肩接踵，多数人醉语连篇。他们嘶吼着当地方言与异邦话语，但癫狂的面容与挥动的拳头已足够传递嗜血的渴望。现在，%companyname%的人将满足这群疯子的渴求。 | 清洁工在场地里匆忙穿梭。他们拖走尸体，收集有价值之物，偶尔将战利品抛向观众，看台上立刻重演群氓式的争斗。如今，%companyname%也是这场盛事的一部分。 | 竞技场在等待，人群在沸腾，%companyname%夺取荣耀的时刻到了！ | 当%companyname%的战士踏入血染的角斗场时，人群爆发出轰鸣。尽管知道这只是观众的无脑嗜血狂欢，你胸腔仍不禁涌起自豪——你的战团正是这场表演的主角。 | 栅门升起。唯有锁链碰撞、滑轮吱嘎与奴隶劳作的喘息刺破寂静。当%companyname%的战士们从场地深处走出，沙砾在脚下咯吱作响，直至他们在场地中央站定。看台顶端传来陌生语言的呐喊，尾音在空气中尚未消散，人群便已爆发出欢呼与咆哮。现在正是你的部下在平民注视下证明自身的时刻。 | %companyname%的厮杀很少展现在那些惯于远离暴力的人眼前。但在这角斗场，平民贪婪期盼着死亡与痛苦，当你的战士踏入沙地时他们发出嗜血的低吼，当佣兵们亮出兵器准备厮杀时他们纵情咆哮。 | 这座竞技场犹如溃烂的疮口，顶盖被神灵撕开，揭露出人类的虚荣、嗜血与野蛮。看台上的人们嘶吼叫嚣，当鲜血飞溅到脸上，他们竟用血水洗脸，相视而笑如同闹剧。他们为战利品互相争斗，以他人痛苦为乐。而%companyname%即将在这群人面前搏杀，为他们献上娱乐，绝佳的娱乐。 | 竞技场的观众阶级混杂，贫富不分，唯有维齐尔们高坐专属看台。在%townname%的民众难得团结一致，共赏人与怪物互相屠戮的盛宴。%companyname%很乐意为此尽一份力。 | 男孩骑在父亲肩头，少女向角斗士投掷鲜花，妇人轻摇团扇，男子暗自衡量自身能耐。这就是竞技场观众的常态——剩下的还有些醉醺醺胡言乱语的酒鬼。你希望%companyname%至少能为这群疯子贡献一两小时的消遣。 | 当%companyname%的人走进沙坑时，观众爆发出震耳欲聋的欢呼声。千万别错把这欢呼当作善意——掌声未落便有空啤酒杯与烂番茄砸下，夹杂着看客们幸灾乐祸的嬉笑。你不禁怀疑%companyname%的人是否真的要在这耗费时光，但转念想到即将到手的金钱与荣耀，想到这些看台上的杂碎终将回到惨淡生活，而你虽同样回归惨淡生活，至少钱袋会鼓胀几分。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "把那个奖品赢到手里！",
					function getResult()
					{
						this.Contract.startTournamentRound();
						return 0;
					}

				},
				{
					Text = "我不去了，我不想死！",
					function getResult()
					{
						this.Contract.getHome().removeSituationByID("situation.arena_tournament");
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.State.getTownScreen().getMainDialogModule().reload();
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnArenaCancel);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Won2",
			Title = "竞技场内",
			Text = "[img]gfx/ui/events/event_147.png[/img]{三场战斗中的第一场已经结束。你得仔细评估手下状况，判断他们能否挺过下一轮——接下来的战斗只会更加艰难。退出也没什么可耻的，毕竟死人没机会吹嘘自己的胜利。你仍然会得到一些钱，但也失去了赢取大奖的机会。2",
			Image = "",
			List = [],
			Options = [
				{
					Text = "下一轮也会赢！",
					function getResult()
					{
						this.Contract.startTournamentRound();
						return 0;
					}

				},
				{
					Text = "是时候退出锦标赛了。",
					function getResult()
					{
						return "DropOut";
					}

				}
			],
			function start()
			{
				if (this.Flags.getAsInt("RewardsApplied") < 2)
				{
					this.Flags.set("RewardsApplied", 2);
					this.World.Statistics.getFlags().increment("ArenaFightsWon", 1);

					if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 10)
					{
						this.updateAchievement("Gladiator", 1, 1);
					}

					this.Contract.updateTraits(this.List);
				}

				this.Contract.m.BulletpointsObjectives = [
					"下一轮战斗将自动开始。",
					"每场战斗都将一决生死，你将无法撤退或获得战利品",
					"每轮比赛结束后，你可以选择退出比赛，或者立即开始下一轮。"
				];
			}

		});
		this.m.Screens.push({
			ID = "Won3",
			Title = "竞技场内",
			Text = "[img]gfx/ui/events/event_147.png[/img]半决赛结束了，你可以选择现在退出，或者继续战斗争得大奖。",
			Image = "",
			List = [],
			Options = [
				{
					Text = "杀进决赛！",
					function getResult()
					{
						this.Contract.startTournamentRound();
						return 0;
					}

				},
				{
					Text = "是时候退出锦标赛了。",
					function getResult()
					{
						return "DropOut";
					}

				}
			],
			function start()
			{
				if (this.Flags.getAsInt("RewardsApplied") < 3)
				{
					this.Flags.set("RewardsApplied", 3);
					this.World.Statistics.getFlags().increment("ArenaFightsWon", 1);

					if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 10)
					{
						this.updateAchievement("Gladiator", 1, 1);
					}

					this.Contract.updateTraits(this.List);
				}
			}

		});
		this.m.Screens.push({
			ID = "Won4",
			Title = "竞技场内",
			Text = "[img]gfx/ui/events/event_147.png[/img]战斗结束，人群的咆哮在你耳边回荡，如潮水般淹没所有感官。你不过是民众的化身，是他们借以宣泄虚荣与空洞英雄主义的图腾。在众人的狂热崇拜中，你赢得了最终大奖：%prizename%！",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "胜利！",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess * 2);
						this.Contract.getHome().removeSituationByID("situation.arena_tournament");
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Flags.set("RewardsApplied", 4);
				this.World.Statistics.getFlags().increment("ArenaFightsWon", 1);

				if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 10)
				{
					this.updateAchievement("Gladiator", 1, 1);
				}

				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new(this.IO.scriptFilenameByHash(this.Flags.get("PrizeScript")));
				item.setName(this.Flags.get("PrizeName"));
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 12,
					icon = "ui/items/" + item.getIcon(),
					text = "你获得了" + item.getName()
				});
				this.Contract.updateTraits(this.List);
			}

		});
		this.m.Screens.push({
			ID = "DropOut",
			Title = "竞技场内",
			Text = "[img]gfx/ui/events/event_147.png[/img]{你决定退出锦标赛，让手下养精蓄锐来日再战。由于退赛在竞技场外办理的，所以没有人给你喝倒彩。这不过是走个事务性流程，领取少量奖金后你们便可离开。没有人会鄙夷这个决定——尤其是那些最懂其中利害的角斗士同行。至于观众？他们只渴望鲜血，根本不会留意哪些流淌鲜血的躯体已经离开。}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "下次吧。",
					function getResult()
					{
						this.Contract.getHome().removeSituationByID("situation.arena_tournament");
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				local money = (this.Flags.get("Round") - 1) * 1000;
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color]克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "竞技场内",
			Text = "[img]gfx/ui/events/event_147.png[/img]{%companyname%的人战败了，有人当场战死, 有人重伤，后者可能是更加不幸的结局。至少观众们倒是心满意足。在这竞技场中，只要演出精彩，即便结局是死亡也值得称道。}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "完了！",
					function getResult()
					{
						local roster = this.World.getPlayerRoster().getAll();

						foreach( bro in roster )
						{
							local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

							if (item != null && item.getID() == "accessory.arena_collar")
							{
								bro.getFlags().increment("ArenaFights", 1);
							}
						}

						this.Contract.getHome().removeSituationByID("situation.arena_tournament");
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Failure2",
			Title = "竞技场内",
			Text = "{[img]gfx/ui/events/event_155.png[/img]竞技场比赛的时间到了，你们却没有到场。或许是被更重要的事耽搁，又或许只是像懦夫般躲了起来。不管怎样，你的声誉都会因此受损。",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "但是……",
					function getResult()
					{
						this.Contract.getHome().removeSituationByID("situation.arena_tournament");
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Collars",
			Title = "竞技场内",
			Text = "{[img]gfx/ui/events/event_155.png[/img]竞技场比赛即将开始，但你的人均未佩戴竞技场项圈，故无法入场。\n\n请为你指定的队员装备获得的竞技场项圈以确定参赛人选，再次进入竞技场后比赛将正式开始。",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "哦，对哦！",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
	}

	function getBros()
	{
		local ret = [];
		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && item.getID() == "accessory.arena_collar")
			{
				ret.push(bro);
			}
		}

		return ret;
	}

	function updateTraits( _list )
	{
		local roster = this.World.getPlayerRoster().getAll();
		local n = 0;

		foreach( bro in roster )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && item.getID() == "accessory.arena_collar")
			{
				local skill;
				bro.getFlags().increment("ArenaFightsWon", 1);
				bro.getFlags().increment("ArenaFights", 1);

				if (bro.getFlags().getAsInt("ArenaFightsWon") == 1)
				{
					skill = this.new("scripts/skills/traits/arena_pit_fighter_trait");
					bro.getSkills().add(skill);
					_list.push({
						id = 10,
						icon = skill.getIcon(),
						text = bro.getName() + "成为了" + this.Const.Strings.getArticle(skill.getName()) + skill.getName()
					});
				}
				else if (bro.getFlags().getAsInt("ArenaFightsWon") == 5)
				{
					bro.getSkills().removeByID("trait.pit_fighter");
					skill = this.new("scripts/skills/traits/arena_fighter_trait");
					bro.getSkills().add(skill);
					_list.push({
						id = 10,
						icon = skill.getIcon(),
						text = bro.getName() + "成为了" + this.Const.Strings.getArticle(skill.getName()) + skill.getName()
					});
				}
				else if (bro.getFlags().getAsInt("ArenaFightsWon") == 12)
				{
					bro.getSkills().removeByID("trait.arena_fighter");
					skill = this.new("scripts/skills/traits/arena_veteran_trait");
					bro.getSkills().add(skill);
					_list.push({
						id = 10,
						icon = skill.getIcon(),
						text = bro.getName() + "成为了" + this.Const.Strings.getArticle(skill.getName()) + skill.getName()
					});
				}

				n = ++n;
			}

			if (n >= 5)
			{
				break;
			}
		}
	}

	function getAmountToSpawn( _type, _resources, _min = 1, _max = 24 )
	{
		return this.Math.min(_max, this.Math.max(_min, _resources / _type.Cost));
	}

	function addToCombat( _list, _entityType, _champion = false )
	{
		local c = clone _entityType;

		if (c.Variant != 0 && _champion)
		{
			c.Variant = 1;
		}
		else
		{
			c.Variant = 0;
		}

		if (c.Variant != 0 && "NameList" in _entityType)
		{
			c.Name <- this.Const.World.Common.generateName(_entityType.NameList) + (_entityType.TitleList != null ? " " + _entityType.TitleList[this.Math.rand(0, _entityType.TitleList.len() - 1)] : "");
		}

		_list.push(c);
	}

	function getScaledDifficultyMult()
	{
		local p = this.World.State.getPlayer().getStrength();
		p = p / this.World.getPlayerRoster().getSize();
		p = p * 12;
		local s = this.Math.maxf(0.75, 1.0 * this.Math.pow(0.01 * p, 0.95) + this.Math.minf(0.5, this.World.getTime().Days * 0.005));
		local d = this.Math.minf(5.0, s);
		return d * this.Const.Difficulty.EnemyMult[this.World.Assets.getCombatDifficulty()];
	}

	function setScreenForArena()
	{
		if (!this.m.IsActive)
		{
			return;
		}

		if (this.getBros().len() == 0)
		{
			this.setScreen("Collars");
		}
		else if (this.World.getTime().Days > this.m.Flags.get("Day") + 1)
		{
			this.setScreen("Failure2");
		}
		else
		{
			this.setScreen("Start");
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"prizename",
			this.m.Flags.get("PrizeName")
		]);
		_vars.push([
			"prizetype",
			this.m.Flags.get("PrizeType")
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.m.Home.getSprite("selection").Visible = false;
			this.m.Home.getBuilding("building.arena").refreshCooldown();
			local roster = this.World.getPlayerRoster().getAll();

			foreach( bro in roster )
			{
				local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

				if (item != null && item.getID() == "accessory.arena_collar")
				{
					bro.getItems().unequip(item);
				}
			}

			local items = this.World.Assets.getStash().getItems();

			foreach( i, item in items )
			{
				if (item != null && item.getID() == "accessory.arena_collar")
				{
					items[i] = null;
				}
			}
		}

		this.m.Home.removeSituationByID("situation.arena_tournament");
	}

	function isValid()
	{
		return this.Const.DLC.Desert;
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
