this.conquer_holy_site_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Target = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.conquer_holy_site";
		this.m.Name = "征服圣地";
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

		local sites = [
			"location.holy_site.oracle",
			"location.holy_site.meteorite",
			"location.holy_site.vulcano"
		];
		local locations = this.World.EntityManager.getLocations();
		local target;
		local targetIndex = 0;
		local closestDist = 9000;
		local myTile = this.m.Home.getTile();

		foreach( v in locations )
		{
			foreach( i, s in sites )
			{
				if (v.getTypeID() == s && v.getFaction() != 0 && !this.World.FactionManager.isAllied(this.getFaction(), v.getFaction()))
				{
					local d = myTile.getDistanceTo(v.getTile());

					if (d < closestDist)
					{
						target = v;
						targetIndex = i;
						closestDist = d;
					}
				}
			}
		}

		this.m.Destination = this.WeakTableRef(target);
		this.m.Destination.setVisited(true);
		local b = -1;

		do
		{
			local r = this.Math.rand(0, this.Const.PlayerBanners.len() - 1);

			if (this.World.Assets.getBanner() != this.Const.PlayerBanners[r])
			{
				b = this.Const.PlayerBanners[r];
				break;
			}
		}
		while (b < 0);

		this.m.Payment.Pool = 1350 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
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

		this.m.Flags.set("DestinationName", this.m.Destination.getName());
		this.m.Flags.set("DestinationIndex", targetIndex);
		this.m.Flags.set("MercenaryPay", this.beautifyNumber(this.m.Payment.Pool * 0.5));
		this.m.Flags.set("Mercenary", this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
		this.m.Flags.set("MercenaryCompany", this.Const.Strings.MercenaryCompanyNames[this.Math.rand(0, this.Const.Strings.MercenaryCompanyNames.len() - 1)]);
		this.m.Flags.set("MercenaryBanner", b);
		this.m.Flags.set("Commander", this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
		this.m.Flags.set("EnemyID", target.getFaction());
		this.m.Flags.set("MapSeed", this.Time.getRealTime());
		this.m.Flags.set("OppositionSeed", this.Time.getRealTime());
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"从南方异教徒手中征服%holysite%",
					"摧毁或击溃附近的敌方部队"
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

				if (r <= 20)
				{
					this.Flags.set("IsAlliedArmy", true);
				}
				else if (r <= 40)
				{
					this.Flags.set("IsSallyForth", true);
				}
				else if (r <= 60)
				{
					this.Flags.set("IsMercenaries", true);
				}
				else if (r <= 80)
				{
					this.Flags.set("IsCounterAttack", true);
				}

				if (this.Contract.getDifficultyMult() >= 1.15)
				{
					this.Contract.spawnEnemy();
				}
				else if (this.Contract.getDifficultyMult() <= 0.85)
				{
					local entities = this.World.getAllEntitiesAtPos(this.Contract.m.Destination.getPos(), 1.0);

					foreach( e in entities )
					{
						if (e.isParty())
						{
							e.getController().clearOrders();
						}
					}
				}

				local cityStates = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState);

				foreach( c in cityStates )
				{
					c.addPlayerRelation(-99.0, "在战争中选择了阵营");
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
					this.Contract.m.Destination.setOnEnterCallback(this.onDestinationAttacked.bindenv(this));
				}

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onCounterAttack.bindenv(this));
				}
			}

			function update()
			{
				if (this.Flags.get("IsFailure"))
				{
					this.Contract.setScreen("Failure");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsVictory"))
				{
					if (this.Flags.get("IsCounterAttack"))
					{
						this.Contract.setScreen("CounterAttack1");
						this.World.Contracts.showActiveContract();
					}
					else if (!this.Contract.isEnemyPartyNear(this.Contract.m.Destination, 400.0))
					{
						this.Contract.setScreen("Victory");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onCounterAttack( _dest, _isPlayerInitiated )
			{
				if (this.Flags.get("IsCounterAttackDefend") && this.Contract.isPlayerAt(this.Contract.m.Destination))
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
					p.LocationTemplate.OwnedByFaction = this.Const.Faction.Player;
					p.LocationTemplate.Template[0] = "tactical.southern_ruins";
					p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
					p.LocationTemplate.ShiftX = -4;
					p.CombatID = "ConquerHolySiteCounterAttack";
					p.MapSeed = this.Flags.getAsInt("MapSeed");
					p.Music = this.Const.Music.OrientalCityStateTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "ConquerHolySiteCounterAttack";
					p.Music = this.Const.Music.OrientalCityStateTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
			}

			function onDestinationAttacked( _dest )
			{
				if (this.Flags.getAsInt("OppositionSeed") != 0)
				{
					this.Math.seedRandom(this.Flags.getAsInt("OppositionSeed"));
				}

				if (this.Flags.get("IsVictory") || this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					return;
				}
				else if (this.Flags.get("IsAlliedArmy"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("AlliedArmy");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.LocationTemplate.OwnedByFaction = this.Flags.get("EnemyID");
						p.CombatID = "ConquerHolySite";
						p.MapSeed = this.Flags.getAsInt("MapSeed");
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						p.Music = this.Const.Music.OrientalCityStateTracks;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 200 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
						p.AllyBanners = [
							this.World.Assets.getBanner(),
							this.World.FactionManager.getFaction(this.Contract.getFaction()).getPartyBanner()
						];
						p.EnemyBanners = [
							this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
						];
						this.World.Contracts.startScriptedCombat(p, true, true, true);
					}
				}
				else if (this.Flags.get("IsSallyForth"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("SallyForth");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "ConquerHolySite";
						p.Music = this.Const.Music.OrientalCityStateTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];
						p.EnemyBanners = [
							this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
						];
						this.World.Contracts.startScriptedCombat(p, false, true, true);
					}
				}
				else if (this.Flags.get("IsMercenaries"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("Mercenaries1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.LocationTemplate.OwnedByFaction = this.Flags.get("EnemyID");
						p.CombatID = "ConquerHolySite";
						p.MapSeed = this.Flags.getAsInt("MapSeed");
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						p.Music = this.Const.Music.OrientalCityStateTracks;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, (130 + (this.Flags.get("MercenariesAsAllies") ? 30 : 0)) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];
						p.EnemyBanners = [
							this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
						];

						if (this.Flags.get("MercenariesAsAllies"))
						{
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Mercenaries, 50 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
							p.AllyBanners.push(this.Flags.get("MercenaryBanner"));
						}
						else
						{
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Mercenaries, 50 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
							p.EnemyBanners.push(this.Flags.get("MercenaryBanner"));
						}

						this.World.Contracts.startScriptedCombat(p, true, true, true);
					}
				}
				else if (this.Flags.get("IsCounterAttack") && this.Flags.get("IsVictory"))
				{
					if (this.Flags.get("IsCounterAttackDefend"))
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.LocationTemplate.OwnedByFaction = this.Const.Faction.Player;
						p.LocationTemplate.ShiftX = -2;
						p.CombatID = "ConquerHolySiteCounterAttack";
						p.MapSeed = this.Flags.getAsInt("MapSeed");
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						p.Music = this.Const.Music.OrientalCityStateTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];
						p.EnemyBanners = [
							this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
						];
						this.World.Contracts.startScriptedCombat(p, false, true, true);
					}
					else
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "ConquerHolySiteCounterAttack";
						p.Music = this.Const.Music.OrientalCityStateTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];
						p.EnemyBanners = [
							this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
						];
						this.World.Contracts.startScriptedCombat(p, false, true, true);
					}
				}
				else if (!this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Contract.setScreen("Attacking");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
					p.LocationTemplate.OwnedByFaction = this.Flags.get("EnemyID");
					p.CombatID = "ConquerHolySite";
					p.MapSeed = this.Flags.getAsInt("MapSeed");
					p.LocationTemplate.Template[0] = "tactical.southern_ruins";
					p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
					p.Music = this.Const.Music.OrientalCityStateTracks;
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, (this.Flags.get("IsCounterAttack") ? 110 : 130) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
					p.AllyBanners = [
						this.World.Assets.getBanner()
					];
					p.EnemyBanners = [
						this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
					];
					this.World.Contracts.startScriptedCombat(p, true, true, true);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "ConquerHolySiteCounterAttack")
				{
					this.Flags.set("IsCounterAttack", false);
					this.Flags.set("IsVictory", true);
				}
				else if (_combatID == "ConquerHolySite")
				{
					this.Flags.set("IsVictory", true);
					this.Flags.set("OppositionSeed", this.Time.getRealTime());
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "ConquerHolySite" || _combatID == "ConquerHolySiteCounterAttack")
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

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
					this.Contract.m.Destination.setOnEnterCallback(null);
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success");
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer%被一群神职人员围在中间，他们一个比一个看起来更了解旧神的意图和旨意。但谈话有一个明确的主线贯穿其中：南方人占领了%holysite%，必须将其夺回。这位领主指向你。%SPEECH_ON%%companyname%将奋力终结这场噩梦！%SPEECH_OFF%推开那些修士，%employer%凑近过来，压低声音。%SPEECH_ON%当然，有合适的报酬。我抽不出多少人手，但圣地对我的人民和我本人都至关重要。你必须去那里驱逐那些异教徒，以免旧神因我们的失败等缘由抛弃我们。%SPEECH_OFF% | %employer%的房门猛地打开，一队神职人员正鱼贯而出。有几个人停下来瞪着你，似乎没有一个对你的出现感到高兴。%employer%招手让你进去。%SPEECH_ON%别在意他们那可怜巴巴、充满指责的眼神，佣兵。%holysite%已落入南方人之手，这让他们集体如坐针毡。倒不是说我责怪他们，即便是我这样一个满腹牢骚的人，对圣地也怀有一份温情。这些修士只是希望由正统王师收复%holysite%，但唉，我的士兵都已另作他用了。而你，却能把这事办妥，只要价钱合适，对吧？%SPEECH_OFF% | %SPEECH_ON%旧神无疑正注视着这个房间，佣兵。%SPEECH_OFF%%employer%晃动着他的酒杯，酒液沿着杯缘晃动，留下紫色的光泽。%SPEECH_ON%南方人占领了%holysite%，而且无疑彻底亵渎了那里。我宁愿让一只狗在圣地上撒尿，也不愿看到任何一个南方杂碎站在他们所谓的神明光辉之下。他们信什么来着，“镀金者”？真是一派胡言。去那里把他们全杀光，让%holysite%恢复其原有的样子。%SPEECH_OFF% | %employer%正独自一人呆在他的花园里，满腔怒气。栅栏周围的男男女女似乎连朝他看一眼都害怕。你不在乎地径直走了进去。他正盯着一个被踢翻的蚂蚁窝，昆虫们正匆忙地重建家园。贵族叹了口气。%SPEECH_ON%我有时会想，旧神是否也以这种方式看待我们的。%SPEECH_OFF%你说你通常只在蚂蚁咬人时才会注意到它们。贵族站起身来。%SPEECH_ON%你应该知道它们对花园有好处，佣兵。如果它们咬人，我推测也并非出于激情。它们只是在做自己知道该做的事，就像它们知道要重建被我踢翻的家园一样。正如当我得知南方的蟑螂暂时玷污了%holysite%时，我，依照旧神的意愿，便知道必须将他们根除并毁灭。%SPEECH_OFF%你几乎以为贵族会把你比作蚂蚁，但他却只是简单地提议给你一大笔克朗，让你前往圣地并消灭那里的占据者。%SPEECH_ON%你或许会像是花园里的黄蜂。%SPEECH_OFF%贵族说道，你则以一副坚忍的表情点头回应。 | %SPEECH_ON%我可不是写歌的，佣兵，所以当我说南方杂种比掏粪工的屁股还要低贱时，你该明白，仅仅是他们的僭越行为就逼得我快要吟游诗人附体了。%SPEECH_OFF%你想提醒%employer%他可能想说“诗歌”，但在某种意义上，他说的话有几分韵味。此外，他无疑把你看作什么都不懂的土包子。%SPEECH_ON%那些野蛮人占领了%holysite%，有传言说他们甚至杀光了所有‘不信者’。我的士兵分散各处，战场多得是。但你有空。而且你确实是个贪婪的混蛋，没错，但我也知道%companyname%正是我们需要的那种精兵，能把那些杂种从圣地里赶出去。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{我相信你会为这样的袭击慷慨解囊的。 | 我们已经准备好尽自己的一份力了。 | 我们再谈一谈报酬。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{这事不划算。 | 这太远了。 | 我们有更紧迫的事情要处理。 | 我们还有别的地方要去。}",
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
			ID = "Attacking",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{南方人已在%holysite%内外驻扎下来。得益于充裕的时间，他们构筑了坚固的防御，但这对于%companyname%来说根本不算什么。你拔出剑，命令手下准备进攻。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "开始进攻！",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "AlliedArmy",
			Title = "%holysite%里",
			Text = "[img]gfx/ui/events/event_78.png[/img]{%holysite%已被高举%employerfaction%旗帜的部队围困。当你靠近时，一名男子在半路迎上了你。他抬起手，然后按在腰带上。%SPEECH_ON%我接到消息说他们会派些佣兵过来，看来就是你了。是%companyname%对吧？我是%commander%，%employer%手下的一名军官。我将与你们一同清剿这些沙漠鼠辈。我担心，想必你也是，如果我们不立即完成这项任务，旧神会惩罚我们所有人。%SPEECH_OFF%他吐了口唾沫，用手抹过饱经风霜的脸。%SPEECH_ON%好吧。让旧神看清我们的本色，我们将以最正义的方式宰了这些乡巴佬。%SPEECH_OFF% | %holysite%已被高举%employerfaction%旗帜的部队围困。领头者上前大声说道。%SPEECH_ON%%companyname%，我是%commander%，%employer%麾下野战军的指挥官。我是来加入你们的，或者该说你们将加入我，一同前往%holysite%，将那些南方渣滓从圣地的每一寸土地上彻底抹除。因为旧神注视着我们所有人，即便是你们这样的佣兵也不例外，而今日的失败必将使我们万劫不复。%SPEECH_OFF%好吧。你只想确定，不管有无援军，%employer%是否都会全额支付报酬。 | %holysite%已被高举%employerfaction%旗帜的部队围困。看起来像是神职人员和士兵的混合队伍，率领部队的军官挥舞着他的剑，随即迅速指向%holysite%。%SPEECH_ON%那些南方马屁精要么自己滚蛋，要么我们就用手中的钢刃送他们去见旧神的地狱。在这件事上没有其他选择。来吧，佣兵们！%SPEECH_OFF%看来%companyname%这次行动会得到一些援助，尽管你仍期望能拿到全额的报酬。}",
			Image = "",
			Banner = "",
			List = [],
			Options = [
				{
					Text = "开始进攻！",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
				this.Banner = this.World.FactionManager.getFaction(this.Contract.getFaction()).getUIBanner();
			}

		});
		this.m.Screens.push({
			ID = "SallyForth",
			Title = "%holysite%里",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{%holysite%的守军得到了增援！所幸还有一线希望：新增的兵力让他们有了信心离开圣地的天然防御，主动来到开阔地带与你交战。 | 你惊讶地看到守军离开了%holysite%，正跋涉穿过开阔地。一份快速的侦察报告显示，他们在过去几天里获得了增援，单纯因人数而壮了胆。一方面，他们深厚的阵势确实有些令人不安；但另一方面，在平原地带迎战他们会容易得多。不过据你客观估计，他们选择与%companyname%正面交锋本身就是个错误。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "那便打一场野战吧。",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Mercenaries1",
			Title = "%holysite%里",
			Text = "[img]gfx/ui/events/event_134.png[/img]{当%holysite%映入眼帘时，一个看起来与你惊人相似的男子走了过来。他身边带着一个财务官和几个佣兵。%SPEECH_ON%晚上好，队长。我是%mercenarycompany%的%mercenary%。我和你一样，来这片土地是为了赚取克朗。我敢打赌，那个满脑肥油的贵族给你们的条件相当优厚。这样如何，你付我%pay%克朗，我就在这场小行动中助你一臂之力？除非，你想让我去为对面那边提供服务。%SPEECH_OFF% | 一群人向你走来，其中一人的步态和体格都与你相似到古怪的程度。他自称是%mercenary%，%mercenarycompany%的队长。%SPEECH_ON%我原以为%employer%会派他的正规军来夺回圣地。队长，实不相瞒，最初帮那些沙丘疯子占领这座神圣纪念碑的人就是我。不过，只要%pay%克朗，我很乐意帮你们夺回来。同为佣兵，你肯定明白这对各方都是笔好买卖。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [],
			function start()
			{
				if (this.World.Assets.getMoney() > this.Flags.get("MercenaryPay"))
				{
					this.Options.push({
						Text = "你被雇佣了！",
						function getResult()
						{
							return "Mercenaries2";
						}

					});
				}
				else
				{
					this.Options.push({
						Text = "恐怕我们没有花这种钱的习惯。",
						function getResult()
						{
							return "Mercenaries3";
						}

					});
				}

				this.Options.push({
					Text = "自己找工作去，%mercenary%。我们不需要帮助。",
					function getResult()
					{
						return "Mercenaries3";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Mercenaries2",
			Title = "%holysite%里",
			Text = "[img]gfx/ui/events/event_134.png[/img]{队长咧嘴一笑，拍了拍你的肩膀。%SPEECH_ON%啊——这就对了！这就对了，高贵的佣兵精神！好啊，%companyname%的指挥官，让我们就此结伴而走，短暂同行，并肩作战，同样短暂！%SPEECH_OFF% | 交易达成后，这个佣兵队的队长溜达到你身边，靠得极近，近得几乎让人不适，而且绝对能让你闻到他带着异味的气息。%SPEECH_ON%你知道，像我们这样的人，像我们这样的家伙，哥们儿，我们是哥们儿，对吧？像我们这样的哥们儿。我们得团结一致。就眼前这场仗，我们会紧紧团结在一起的。%SPEECH_OFF%他点点头，朝你肩膀轻轻捶了一拳。%SPEECH_ON%等打完了，嗯，我希望咱们以后还有机会再做哥们儿，你懂的吧？%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "开始进攻！",
					function getResult()
					{
						this.Flags.set("MercenariesAsAllies", true);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
				this.World.Assets.addMoney(-this.Flags.get("MercenaryPay"));
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你花了[color=" + this.Const.UI.Color.NegativeEventValue + "]" + this.Flags.get("MercenaryPay") + "[/color]克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "Mercenaries3",
			Title = "%holysite%里",
			Text = "[img]gfx/ui/events/event_134.png[/img]{%SPEECH_START%真遗憾。%SPEECH_OFF%%mercenary%说着，迅速退回到%mercenarycompany%的队列中。他一路后退，直接融入了防守%holysite%的南方士兵阵线。他双臂张开摆动，仿佛在逆流游泳。%SPEECH_ON%我是说，真他妈遗憾！好吧，%companyname%的队长，就让咱们瞧瞧哪边请到了更强的佣兵，好吗？%SPEECH_OFF%这名佣兵拔出了武器，他身后%holysite%的南方士兵们也纷纷亮出兵刃。自然地，你也拔出了武器。是时候战斗了。 | %SPEECH_ON%行，行，我明白了。好吧。我本来也没抱太大期望。毕竟，我也是个雇佣兵。而现在……%SPEECH_OFF%他步步后退，与自己的战团会合，而他的战团则与守护%holysite%的南方士兵们融为一体。%SPEECH_ON%眼下看来，南方人才是出价更高的主顾。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们将在战场上再见。开始进攻！",
					function getResult()
					{
						this.Flags.set("MercenariesAsAllies", false);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "CounterAttack1",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_164.png[/img]{战斗已经结束，但远处一道闪耀的金光吸引了你的目光。当你凝视地平线时，一队南方士兵出现了，他们光鲜的装扮无疑是为了彰显声势。是反击部队！ | 正当你收剑入鞘时，%randombrother%大喊起来。他指向地平线。一列南方士兵正在逼近，他们的盔甲闪闪发光，步伐嚣张跋扈。这些反攻者刻意张扬而来，无疑志在必得…….}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们将坚守此地！",
					function getResult()
					{
						return "CounterAttack2";
					}

				},
				{
					Text = "我们将在开阔地和他们硬碰硬！",
					function getResult()
					{
						return "CounterAttack3";
					}

				},
				{
					Text = "我们没办法再打一场了。撤退！",
					function getResult()
					{
						return "Failure";
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "CounterAttack2",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_164.png[/img]{南方军队正稳扎稳打地逼近。%SPEECH_ON%蟑螂，简直没完没了。%SPEECH_OFF%你转头看见%randombrother%摇了摇头。他抬起靴子弹掉鞋尖上的一只虫子，踩实地面，朝进攻者的方向点了点头。%SPEECH_ON%别担心，队长，我们会把%holysite%的防御工事收拾得妥妥当当，好好招待那群野蛮杂种。%SPEECH_OFF% | 你命令队员们坚守此地。%SPEECH_ON%在%holysite%打防御战，这辈子也算没白活。%SPEECH_OFF%%randombrother%说道。你点头回应，说希望将来这能成为他的回忆。他大笑着问这怎么可能忘得了。另一个佣兵插嘴说倒是有个绝对能让他忘记的法子，但你打断了他，让所有人都集中精力应对眼前的任务。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "集合！",
					function getResult()
					{
						this.Flags.set("IsCounterAttackDefend", true);
						this.Flags.set("IsVictory", false);
						local party = this.Contract.spawnEnemy();
						party.setOnCombatWithPlayerCallback(this.Contract.getActiveState().onCounterAttack.bindenv(this.Contract.getActiveState()));
						this.Contract.m.Target = this.WeakTableRef(party);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "CounterAttack3",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_164.png[/img]{防御工事看起来不如先前牢固了。你命令%companyname%以战斗队形进入战场，这样有问题的工事就不会妨碍指挥。南方部队的军官走上前来。%SPEECH_ON%们用鲜血玷污了%holysite%，为此镀金者亲自将你们引到此地，像真正的男人一样战死。对此你还有什么可说的？%SPEECH_OFF%你拔剑出鞘。%SPEECH_ON%流的不是我的血。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "冲锋！",
					function getResult()
					{
						this.Flags.set("IsCounterAttackDefend", false);
						this.Flags.set("IsVictory", false);
						local party = this.Contract.spawnEnemy();
						party.setOnCombatWithPlayerCallback(this.Contract.getActiveState().onCounterAttack.bindenv(this.Contract.getActiveState()));
						this.Contract.m.Target = this.WeakTableRef(party);
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
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{你收起武器，命令战团开始打扫战场，心头却涌起一股异样——仿佛%holysite%早已不是头一回经历此等血洗。也罢，若有人注定要重蹈先祖的覆辙，你很高兴这人不是你。正当你动身前往%employer%处时，一队北方士兵前来接管了这片圣地。 | 你打败了敌人，成功收复了%holysite%。信徒们缓缓涌入，迈过死者后跪拜在圣地前。没人向你道谢，不过无妨，%employer%自然会向你道谢。你在离开时与一队北方士兵擦肩而过，他们所有人都对你报以讥讽的嗤笑。 | 战斗结束后，小群信徒们渐渐在%holysite%的角落聚集。你不知道这些人从哪里来，他们不在意你，而你也不在意他们。现在重要的是有大量克朗在%employer%那等着你回去领取。待一队北方士兵抵达交接后，你率队离去。}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "胜利！",
					function getResult()
					{
						this.Contract.m.Destination.setFaction(this.Contract.getFaction());
						this.Contract.m.Destination.setBanner(this.World.FactionManager.getFaction(this.Contract.getFaction()).getPartyBanner());
						this.updateAchievement("NewManagement", 1, 1);
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.spawnAlly();
			}

		});
		this.m.Screens.push({
			ID = "Failure",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{%holysite%已落入南方人手中。一名佣兵摇了摇头。%SPEECH_ON%好吧。我估计他们很快就会到处耀武扬威或拉屎撒尿了。%SPEECH_OFF%确实。随着圣地失守，再回去找%employer%已经毫无意义——除非你想去看另一种“神圣景象”}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "灾难！",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "未能征服某处圣地");
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
			ID = "Success",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%townname%的修道院里涌入的平民比你以往所见的要多得多。%employer%站在外面的台阶上，一手按着你肩膀迎接你。%SPEECH_ON%欢迎回来，佣兵。你或许只知道追逐金钱，但旧神的怒火与你同行。%holysite%现在重归正主了。%SPEECH_OFF%贵族打了个响指，几个圆胖的僧侣捧着装满%reward%克朗的箱子蹒跚而来。%employer%转身踏上台阶。%SPEECH_ON%我会向人群为你美言几句，你叫什么来着？啊，我猜你希望整个战团获得荣誉。致辞的时候我会感谢%companyname%的所有人。%SPEECH_OFF% | %employer%正在查看他的作战地图。%SPEECH_ON%有点可笑的是，我派自己士兵去的地方总是失败，但当旧神降下灾祸时，我被迫雇个佣兵却迎来了……胜利。希望%holysite%重归掌控能激励我的士兵像%companyname%那样战斗。%reward%克朗的代价就能让你把那些南方杂种送回了他们的沙漠地狱，并鼓舞了整个战局。我差点要说我亏待你了，佣兵。差点。%SPEECH_OFF% | %SPEECH_ON%斥候回来后第一件事就是去修道院。我就知道你们成功了。我还罚他们每人在地牢里关上一天，因为他们擅离职守。%SPEECH_OFF%%employer%坐在一个模样奇怪的垫子上，也许是南北战争期间的战利品。他晃动着高脚杯中的葡萄酒。%SPEECH_ON%你的%reward%克朗就在外面等着。我得问问，你在外面的时候有没有听到什么？也许是旧神的低语？甚至他们所谓的……镀金者？的低语？%SPEECH_OFF%你摇头表示没有。贵族耸耸肩。%SPEECH_ON%真遗憾。不禁让人好奇，究竟要付出什么神明才会再次降临我们身边。%SPEECH_OFF%你告诉他，把%reward%克朗花在某个特定方向会是个好开端。贵族狡黠一笑，满足了你的愿望。 | 你见到%employer%时，他身边有个皮肤黝黑的年轻女子，明显来自南方地域。他上下打量着她。%SPEECH_ON%旧神给我送来了这个，就像我认为他们送来了你一样。%SPEECH_OFF%他一时语塞，清了清嗓子。%SPEECH_ON%我的意思是，送来帮我。你们在%holysite%的胜利鼓舞了士兵们，驱散了他们肩头失败的阴霾。僧侣们现在重获信徒，只要勤勉尽责，我们必将向旧神证明自己的价值。%SPEECH_OFF%他推开那女子，试图站起来，但坐垫太深，或许太舒适了。他依旧坐着。%SPEECH_ON%你的%reward%克朗会放在大厅。叫我的一个仆人来带这个沙漠娘们去修道院祈祷。%SPEECH_OFF% | 你在镇上一座神庙里找到%employer%，他正站在一尊古神雕像下。%SPEECH_ON%我早已得知你们的成功。全镇欢欣鼓舞，当然，他们不会谈论你，他们会谈论我。%SPEECH_OFF%贵族似乎对自己相当满意。他转身拍拍你的肩膀。%SPEECH_ON%希望那些南方杂种没给你添太多麻烦。我的指挥官会带来你的%reward%克朗。对了，你觉得%holysite%值得一去吗？我从没去过。事实上，也不在乎去不去。我脚踏之处皆受祝福。%SPEECH_OFF%在贵族离开时，你抿紧了嘴唇。}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "征服了一处圣地");
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

	function spawnAlly()
	{
		local o = this.m.Destination.getTile().SquareCoords;
		local tiles = [];

		for( local x = o.X - 4; x < o.X + 4; x = ++x )
		{
			for( local y = o.Y + 4; y <= o.Y + 6; y = ++y )
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
		local f = this.World.FactionManager.getFaction(this.getFaction());
		local candidates = [];

		foreach( s in f.getSettlements() )
		{
			if (s.isMilitary())
			{
				candidates.push(s);
			}
		}

		local party = f.spawnEntity(tiles[0].Tile, candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly() + "战团", true, this.Const.World.Spawn.Noble, 170 * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
		party.setDescription("听命于当地领主的职业军人。");
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
		local occupy = this.new("scripts/ai/world/orders/occupy_order");
		occupy.setTarget(this.m.Destination);
		occupy.setTime(10.0);
		c.addOrder(occupy);
		local guard = this.new("scripts/ai/world/orders/guard_order");
		guard.setTarget(this.m.Destination.getTile());
		guard.setTime(240.0);
		c.addOrder(guard);
		return party;
	}

	function spawnEnemy()
	{
		local cityState = this.World.FactionManager.getFaction(this.getFaction());
		local o = this.m.Destination.getTile().SquareCoords;
		local tiles = [];

		for( local x = o.X - 4; x < o.X + 4; x = ++x )
		{
			for( local y = o.Y - 4; y <= o.Y - 3; y = ++y )
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
		local f = this.World.FactionManager.getFaction(this.m.Flags.get("EnemyID"));
		local candidates = [];

		foreach( s in f.getSettlements() )
		{
			candidates.push(s);
		}

		local party = f.spawnEntity(tiles[0].Tile, "团" + candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly(), true, this.Const.World.Spawn.Southern, this.Math.rand(100, 140) * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
		party.setDescription("忠于城邦的应征士兵。");
		party.setAttackableByAI(false);
		party.setAlwaysAttackPlayer(true);
		party.getLoot().Money = this.Math.rand(50, 200);
		party.getLoot().ArmorParts = this.Math.rand(0, 25);
		party.getLoot().Medicine = this.Math.rand(0, 5);
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
		local attack = this.new("scripts/ai/world/orders/attack_zone_order");
		attack.setTargetTile(this.m.Destination.getTile());
		c.addOrder(attack);
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(this.m.Destination.getTile());
		c.addOrder(move);
		local guard = this.new("scripts/ai/world/orders/guard_order");
		guard.setTarget(this.m.Destination.getTile());
		guard.setTime(999.0);
		c.addOrder(guard);
		return party;
	}

	function onPrepareVariables( _vars )
	{
		local illustrations = [
			"event_152",
			"event_154",
			"event_151"
		];
		_vars.push([
			"illustration",
			illustrations[this.m.Flags.get("DestinationIndex")]
		]);
		_vars.push([
			"holysite",
			this.m.Flags.get("DestinationName")
		]);
		_vars.push([
			"pay",
			this.m.Flags.get("MercenaryPay")
		]);
		_vars.push([
			"employerfaction",
			this.World.FactionManager.getFaction(this.m.Faction).getName()
		]);
		_vars.push([
			"mercenary",
			this.m.Flags.get("Mercenary")
		]);
		_vars.push([
			"mercenarycompany",
			this.m.Flags.get("MercenaryCompany")
		]);
		_vars.push([
			"commander",
			this.m.Flags.get("Commander")
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
				this.m.Destination.setOnEnterCallback(null);
			}

			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.setOnCombatWithPlayerCallback(null);
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

		local sites = [
			"location.holy_site.oracle",
			"location.holy_site.meteorite",
			"location.holy_site.vulcano"
		];
		local locations = this.World.EntityManager.getLocations();

		foreach( v in locations )
		{
			foreach( s in sites )
			{
				if (v.getTypeID() == s && v.getFaction() != 0 && !this.World.FactionManager.isAllied(this.getFaction(), v.getFaction()))
				{
					return true;
				}
			}
		}

		return false;
	}

	function onIsTileUsed( _tile )
	{
		if (this.m.Destination != null && !this.m.Destination.isNull() && _tile.ID == this.m.Destination.getTile().ID)
		{
			return true;
		}

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
