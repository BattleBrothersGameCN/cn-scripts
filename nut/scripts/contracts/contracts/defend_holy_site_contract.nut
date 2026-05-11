this.defend_holy_site_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Target = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.defend_holy_site";
		this.m.Name = "保卫圣地";
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
				if (v.getTypeID() == s && v.getFaction() != 0 && this.World.FactionManager.isAllied(this.getFaction(), v.getFaction()))
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
		this.m.Payment.Pool = 1250 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
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

		local cityStates = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState);
		this.m.Flags.set("DestinationName", this.m.Destination.getName());
		this.m.Flags.set("DestinationIndex", targetIndex);
		this.m.Flags.set("EnemyID", cityStates[this.Math.rand(0, cityStates.len() - 1)].getID());
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
					"前往%holysite%，抵御南方异教徒"
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

				if (r <= 25)
				{
					this.Flags.set("IsQuartermaster", true);
				}

				local r = this.Math.rand(1, 100);

				if (r <= 30)
				{
					this.Flags.set("IsSallyForth", true);
				}
				else if (r <= 60)
				{
					this.Flags.set("IsAlliedSoldiers", true);
				}

				local cityStates = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState);

				foreach( c in cityStates )
				{
					c.addPlayerRelation(-99.0, "在战争中选择了阵营");
				}

				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);

				if (this.Contract.getDifficultyMult() >= 0.95)
				{
					local cityState = cityStates[this.Math.rand(0, cityStates.len() - 1)];
					local party = cityState.spawnEntity(this.Contract.m.Destination.getTile(), "团" + cityState.getNameOnly(), true, this.Const.World.Spawn.Southern, this.Math.rand(100, 150) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
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
					local roam = this.new("scripts/ai/world/orders/roam_order");
					roam.setAllTerrainAvailable();
					roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
					roam.setTerrain(this.Const.World.TerrainType.Shore, false);
					roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
					roam.setPivot(this.Contract.m.Destination);
					roam.setMinRange(4);
					roam.setMaxRange(8);
					roam.setTime(300.0);
				}

				local entities = this.World.getAllEntitiesAtPos(this.Contract.m.Destination.getPos(), 1.0);

				foreach( e in entities )
				{
					if (e.isParty())
					{
						e.getController().clearOrders();
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
				}
			}

			function update()
			{
				if (this.Flags.get("IsQuartermaster") && this.Contract.isPlayerAt(this.Contract.m.Home) && this.World.Assets.getStash().getNumberOfEmptySlots() >= 3)
				{
					this.Contract.setScreen("Quartermaster");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Destination))
				{
					this.Contract.setScreen("Approaching" + this.Flags.get("DestinationIndex"));
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Running_Defend",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"保卫%holysite%免受南方异教徒的侵犯",
					"摧毁或击溃附近的敌方部队",
					"不要走得太远"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
				}

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Flags.get("IsFailure") || !this.Contract.isPlayerNear(this.Contract.m.Destination, 700) || !this.World.FactionManager.isAllied(this.Contract.getFaction(), this.Contract.m.Destination.getFaction()))
				{
					this.Contract.setScreen("Failure");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsSallyForthNextWave"))
				{
					this.Contract.setScreen("SallyForth3");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsVictory"))
				{
					if (!this.Contract.isEnemyPartyNear(this.Contract.m.Destination, 400.0))
					{
						this.Contract.setScreen("Victory");
						this.World.Contracts.showActiveContract();
					}
				}
				else if (!this.Flags.get("IsTargetDiscovered") && this.Contract.m.Target != null && !this.Contract.m.Target.isNull() && this.Contract.m.Target.isDiscovered())
				{
					this.Flags.set("IsTargetDiscovered", true);
					this.Contract.setScreen("TheEnemyAttacks");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsArrived") && this.Flags.get("AttackTime") > 0 && this.Time.getVirtualTimeF() >= this.Flags.get("AttackTime"))
				{
					if (this.Flags.get("IsSallyForth"))
					{
						this.Contract.setScreen("SallyForth1");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsAlliedSoldiers"))
					{
						this.Contract.setScreen("AlliedSoldiers1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Flags.set("AttackTime", 0.0);
						local party = this.Contract.spawnEnemy();
						party.setOnCombatWithPlayerCallback(this.Contract.getActiveState().onDestinationAttacked.bindenv(this));
						this.Contract.m.Target = this.WeakTableRef(party);
					}
				}
			}

			function onDestinationAttacked( _dest, _isPlayerInitiated = false )
			{
				if (this.Flags.get("IsSallyForthNextWave"))
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "DefendHolySite";
					p.Music = this.Const.Music.OrientalCityStateTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.Entities = [];
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
					p.EnemyBanners = [
						this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
					];

					if (this.Flags.get("IsLocalsRecruited"))
					{
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.PeasantsArmed, 10, this.Contract.getFaction());
						p.AllyBanners.push("banner_noble_11");
					}

					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
				else if (this.Flags.get("IsSallyForth"))
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "DefendHolySite";
					p.Music = this.Const.Music.OrientalCityStateTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.Entities = [];
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, (this.Flags.get("IsEnemyReinforcements") ? 130 : 100) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
					p.EnemyBanners = [
						this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
					];

					if (this.Flags.get("IsLocalsRecruited"))
					{
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.PeasantsArmed, 50, this.Contract.getFaction());
						p.AllyBanners.push("banner_noble_11");
					}

					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
					p.LocationTemplate.OwnedByFaction = this.Const.Faction.Player;
					p.CombatID = "DefendHolySite";

					if (this.Contract.isPlayerAt(this.Contract.m.Destination))
					{
						p.MapSeed = this.Flags.getAsInt("MapSeed");
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Flags.get("IsPalisadeBuilt") ? this.Const.Tactical.FortificationType.WallsAndPalisade : this.Const.Tactical.FortificationType.Walls;
						p.LocationTemplate.CutDownTrees = true;
						p.LocationTemplate.ShiftX = -2;
						p.Music = this.Const.Music.OrientalCityStateTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];

						if (this.Flags.get("IsAlliedReinforcements"))
						{
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 50 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
							p.AllyBanners.push(this.World.FactionManager.getFaction(this.Contract.getFaction()).getPartyBanner());
						}

						if (this.Flags.get("IsLocalsRecruited"))
						{
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.PeasantsArmed, 50, this.Contract.getFaction());
							p.AllyBanners.push("banner_noble_11");
						}
					}

					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "DefendHolySite")
				{
					if (this.Flags.get("IsSallyForthNextWave"))
					{
						this.Flags.set("IsSallyForthNextWave", false);
						this.Flags.set("IsSallyForth", false);
						this.Flags.set("IsVictory", true);
					}
					else if (this.Flags.get("IsSallyForth"))
					{
						this.Flags.set("IsSallyForthNextWave", true);
					}
					else
					{
						this.Flags.set("IsVictory", true);
					}
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "DefendHolySite")
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%SPEECH_START%该死的沙漠杂种。%SPEECH_OFF%这是你走进%employer%房间时听到的第一句话。他不耐烦地招手让你进去。%SPEECH_ON%和南方的战争还在继续，但他们现在自作主张打破了默契，选择了向%holysite%进军，而我根本无力保护它。我不想在这强调那片圣地有多重要，但要是我就这么放任不管，民众绝对会阉了我。既然我挺珍惜自己这俩蛋蛋的，那就只能出%reward%克朗请你们去守住%holysite%。%SPEECH_OFF% | 你看到%employer%正试图说服一群农民。看来有消息传来，南方士兵正在逼近%holysite%。%SPEECH_ON%我们早有不成文的规矩，这些圣地，它们，它们......是神圣不可侵犯的！%SPEECH_OFF%见到你，这位贵族分开人群，宣称你是一周前他亲自征召的英勇战士。但当他靠近时，却压低声音悄声道：%SPEECH_ON%这些蠢货没必要知道你们是佣兵。听着，南方人这次可真是捅烂我屁眼了。那些野蛮人在打%holysite%的主意，我需要你们赶去阻止他们。%reward%克朗应该够办这事了吧？%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{%companyname%可以帮你。 | 抵御南方人得要不少钱。 | 我很感兴趣，继续。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{这事不划算。 | 我们还有别的地方要去。 | 我不会冒险让战团对抗南方的战争机器。}",
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
			ID = "Approaching1",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{巨大的火山口如今已几乎空无一人，昔日的虔诚信徒与好奇访客尽数散去。战争的一丝风声也足以驱散信徒，令他们躲回各自修道院的庇护之中。毕竟，接下来的数小时里必将分出胜败——而某种程度的狂热，或许会诱使胜者过度沉溺于正义之中……}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们在这里扎营。",
					function getResult()
					{
						return "Preparation1";
					}

				}
			],
			function start()
			{
				this.Flags.set("IsArrived", true);
			}

		});
		this.m.Screens.push({
			ID = "Approaching0",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{神谕所已不复你记忆中的模样：众多信徒已然离去，战争的擂鼓声已响彻这座古老神殿的门阶。但这都无关紧要。你在此地无愿景可求索，无梦境可解析，唯有为你的敌人准备噩梦一场。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们在这里扎营。",
					function getResult()
					{
						return "Preparation1";
					}

				}
			],
			function start()
			{
				this.Flags.set("IsArrived", true);
			}

		});
		this.m.Screens.push({
			ID = "Approaching2",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{讽刺的是，这座坐落在半毁山脚下的废墟之城，此刻终于显露出令人不安的荒芜。只有零星虔信者在此徘徊，其余众人早在宗教冲突席卷他们的帐篷城与灵修地前便已离去。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们在这里扎营。",
					function getResult()
					{
						return "Preparation1";
					}

				}
			],
			function start()
			{
				this.Flags.set("IsArrived", true);
			}

		});
		this.m.Screens.push({
			ID = "Preparation1",
			Title = "%holysite%里",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{你相信你已凭借%holysite%的地形构筑起了基本的防御。趁着尚存的有限时间，%companyname%至少还可完成一项紧要工作。问题只在于哪一项最有用。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "竖起木栅栏来加强防御！",
					function getResult()
					{
						return "Preparation2";
					}

				},
				{
					Text = "搜索这片区域，看看有没有对我们有用的东西！",
					function getResult()
					{
						return "Preparation3";
					}

				},
				{
					Text = "招募一些信徒来帮助我们防守！",
					function getResult()
					{
						return "Preparation4";
					}

				}
			],
			function start()
			{
				this.Contract.setState("Running_Defend");
			}

		});
		this.m.Screens.push({
			ID = "Preparation2",
			Title = "%holysite%里",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{你搜刮了圣地本身——此事你自然会秘而不宣——又在信徒遗弃的物品中搜刮一番，总算凑足木材，加固了环绕%holysite%一角的城墙。依你之见，此处是最容易被突破的弱点，所以你便对此重点布防。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们等着吧。",
					function getResult()
					{
						this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
						return 0;
					}

				}
			],
			function start()
			{
				this.Flags.set("IsPalisadeBuilt", true);
			}

		});
		this.m.Screens.push({
			ID = "Preparation3",
			Title = "%holysite%里",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{你让手下仔细翻找这片区域，搜集各类战备物资。各式各样的物品被搜罗起来堆成小山。等到整个%holysite%都被彻底翻查过一遍后，你和队员们花了几分钟时间琢磨哪些东西最能派上用场……}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们等着吧。",
					function getResult()
					{
						this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
						return 0;
					}

				}
			],
			function start()
			{
				for( local i = 0; i < 2; i = ++i )
				{
					local r = this.Math.rand(1, 12);
					local item;

					switch(r)
					{
					case 1:
						item = this.new("scripts/items/weapons/oriental/saif");
						break;

					case 2:
						item = this.new("scripts/items/tools/throwing_net");
						break;

					case 3:
						item = this.new("scripts/items/weapons/oriental/polemace");
						break;

					case 4:
						item = this.new("scripts/items/weapons/ancient/broken_ancient_sword");
						break;

					case 5:
						item = this.new("scripts/items/armor/ancient/ancient_mail");
						break;

					case 6:
						item = this.new("scripts/items/supplies/ammo_item");
						break;

					case 7:
						item = this.new("scripts/items/supplies/armor_parts_item");
						break;

					case 8:
						item = this.new("scripts/items/shields/ancient/tower_shield");
						break;

					case 9:
						item = this.new("scripts/items/loot/ancient_gold_coins_item");
						break;

					case 10:
						item = this.new("scripts/items/loot/silver_bowl_item");
						break;

					case 11:
						item = this.new("scripts/items/weapons/wooden_stick");
						break;

					case 12:
						item = this.new("scripts/items/helmets/oriental/spiked_skull_cap_with_mail");
						break;
					}

					if (item.getConditionMax() > 1)
					{
						item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 50) * 0.01));
					}

					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "你获得了" + item.getName()
					});
				}

				local amount = this.Math.rand(10, 30);
				this.World.Assets.addArmorParts(amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_supplies.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]+" + amount + "[/color]点工具和补给"
				});
			}

		});
		this.m.Screens.push({
			ID = "Preparation4",
			Title = "%holysite%里",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{仍徘徊在%holysite%周围的少数信徒，想必是最狂热、最虔诚的一群。既然你在此地代表北方势力，你让手下挑选出几个看起来比较结实的旧神狂热信徒，要求他们为自己的神明而战。这无疑是再便捷不过的募兵手段——他们迅速武装起来，接受了最简短的训练。你只能指望他们在即将到来的实战中能派上些用场。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们等着吧。",
					function getResult()
					{
						this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
						return 0;
					}

				}
			],
			function start()
			{
				this.Flags.set("IsLocalsRecruited", true);
			}

		});
		this.m.Screens.push({
			ID = "TheEnemyAttacks",
			Title = "%holysite%里",
			Text = "[img]gfx/ui/events/event_164.png[/img]{南方士兵出现在地平线上。“镀金者信徒”这个称谓确实贴切——即便相隔甚远，他们的盔甲仍在熠熠生辉。%randombrother%啐了一口，望过来。%SPEECH_ON%这群死人打扮得也太光鲜了。你说要是咱们扮成迪精，带着小恶魔那股嚣张劲儿冲出去，那帮南方佬会不会直接吓跑？%SPEECH_OFF%你微微一笑，拔出长剑，下令准备战斗。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "列阵！",
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
			ID = "Quartermaster",
			Title = "%townname%里",
			Text = "[img]gfx/ui/events/event_158.png[/img]{刚离开%townname%，一个在马车尾插着%employerfaction%旗帜的人便迎了上来。他自称是你雇主的军需官，有一批物资要处理。%SPEECH_ON%这儿有几只战犬、投网和投矛。上头吩咐了，你只能选一样，不能全拿——这附近需要装备的弟兄还多着呢。%SPEECH_OFF%}",
			Image = "",
			Banner = "",
			List = [],
			Options = [
				{
					Text = "我们选战犬。",
					function getResult()
					{
						for( local i = 0; i < 3; i = ++i )
						{
							local item = this.new("scripts/items/accessory/wardog_item");
							this.World.Assets.getStash().add(item);
						}

						return 0;
					}

				},
				{
					Text = "我们选投网。",
					function getResult()
					{
						for( local i = 0; i < 4; i = ++i )
						{
							local item = this.new("scripts/items/tools/throwing_net");
							this.World.Assets.getStash().add(item);
						}

						return 0;
					}

				},
				{
					Text = "我们选投矛。",
					function getResult()
					{
						if (this.Const.DLC.Wildmen)
						{
							for( local i = 0; i < 4; i = ++i )
							{
								local item = this.new("scripts/items/weapons/throwing_spear");
								this.World.Assets.getStash().add(item);
							}
						}
						else
						{
							for( local i = 0; i < 4; i = ++i )
							{
								local item = this.new("scripts/items/weapons/javelin");
								this.World.Assets.getStash().add(item);
							}
						}

						return 0;
					}

				},
				{
					Text = "我们不缺东西，留给其他人吧。",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Flags.set("IsQuartermaster", false);
				this.Banner = this.World.FactionManager.getFaction(this.Contract.getFaction()).getUIBanner();
			}

		});
		this.m.Screens.push({
			ID = "SallyForth1",
			Title = "%holysite%里",
			Text = "[img]gfx/ui/events/event_164.png[/img]{南方军队出现了，但来的并非主力部队，也不完全是斥候队。他们似乎根本没花心思保持队形，推进过程中就已经散乱不堪。如果此刻主动出击，很可能打他们个措手不及。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们需要抓住这个机会。让兄弟们准备好主动出击！",
					function getResult()
					{
						return this.Math.rand(1, 100) <= 50 ? "SallyForth2" : "SallyForth4";
					}

				},
				{
					Text = "我们占据着易守难攻的位置。就守在这里。",
					function getResult()
					{
						return "SallyForth5";
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "SallyForth2",
			Title = "%holysite%里",
			Text = "[img]gfx/ui/events/event_50.png[/img]{%SPEECH_START%明智之举。%SPEECH_OFF%%randombrother%赞同了你的命令。%companyname%全速前进，打算在南方人准备就绪之前打他们个措手不及。你们快速穿过原野，转眼间就已经杀到他们面前。敌人还在从车上卸下装备物资，一看到你们出现，几个随军的杂役立刻吓得四散逃命，剩下的士兵则慌忙去拿武器。\n\n从指挥官那尖厉的嗓音判断，他显然没受过应付这种场面的训练——他每声嘶力竭地喊出一道命令，嗓音就嘶哑一分，而队伍还在勉强尝试组成阵型。不再浪费时间，你立即率军杀入敌阵！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "冲锋！",
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
			ID = "SallyForth3",
			Title = "%holysite%里",
			Text = "[img]gfx/ui/events/event_90.png[/img]{你结果了最后一名士兵，他们脸上惊愕的表情依然凝固着。%SPEECH_ON%队长，剩下的过来了。%SPEECH_OFF%%randombrother%眺望地平线后回报道。你点头下令让队员们做好准备。这次南方人以严整的阵型推进，虽然看到你和你脚下横陈的尸体时阵型出现了短暂的动摇。他们的旗帜升上天空，南方士兵们随之重振士气，带着愤怒与战意发起了冲锋。“为了镀金者！”的呐喊声响彻天际。你举剑向前。%SPEECH_ON%尽管他们的信仰或许值得钦佩，但此地没有神明会眷顾他们——这里只有%companyname%，而我们只有一种回应。%SPEECH_OFF%当战斗迫近时，战士们发出了震天的怒吼。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "集合！集合！准备好！",
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
			ID = "SallyForth4",
			Title = "%holysite%里",
			Text = "[img]gfx/ui/events/event_164.png[/img]{%SPEECH_START%明智之举。%SPEECH_OFF%%randombrother%赞同了你的指令。%companyname%全速前进，打算在南方人准备就绪之前打他们个措手不及。你们快速穿过原野，转眼间就已经杀到他们面前。敌人还在从车上卸下装备物资，一看到你们出现，几个随军的杂役立刻吓得四散逃命，剩下的士兵则慌忙去拿武器。正当你以为胜券在握时，侧翼又出现了一支敌军部队。%SPEECH_ON%镀金者只会对配得上他圣光的人微笑，逐币者！%SPEECH_OFF%南方部队的指挥官高声嘲笑道。此时退守防御工事已经太远，而敌人又近在眼前，现在只剩下一个选择——你举起长剑，带领战士们准备发起冲锋。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们杀出一条血路！",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
				this.Flags.set("IsEnemyReinforcements", true);
			}

		});
		this.m.Screens.push({
			ID = "SallyForth5",
			Title = "%holysite%里",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{你认为最好还是固守防御工事。这么做或许会错失良机，但在所有可选方案中这算是最稳妥的。%SPEECH_ON%刚才就该杀出去的。这回咱们丢失战机了，队长。%SPEECH_OFF%转头看见%randombrother%正耸着肩膀。你警告他管好舌头，否则他自己就要丢失点什么了。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "全体都有，备战。他们很快就会全力进攻。",
					function getResult()
					{
						this.Flags.set("IsSallyForth", false);
						this.Flags.set("AttackTime", 1.0);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "AlliedSoldiers1",
			Title = "%holysite%里",
			Text = "[img]gfx/ui/events/event_78.png[/img]{正当你等候南方军队时，一支北方部队抵达了。他们的指挥官轻触头盔致意。%SPEECH_ON%他们当时派我来协助佣兵时，我说让他们有多远滚多远。但你知道我是怎么被说服的吗？他们告诉我这支佣兵是%companyname%。你们名声在外，而我正好有人手可以支援这场战斗。%SPEECH_OFF%从装备判断，他们最适合作为掩护部队，或许能引开部分来袭的敌军。或者，最好直接将他们编入阵线，增强战力。}",
			Image = "",
			Banner = "",
			List = [],
			Options = [
				{
					Text = "指挥官，我需要你和你的人去包抄他们的炮手。",
					function getResult()
					{
						this.Flags.set("IsEnemyLuredAway", true);
						this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
						return "AlliedSoldiers2";
					}

				},
				{
					Text = "指挥官，我需要你和你的人去引走敌军的一部分步兵。",
					function getResult()
					{
						this.Flags.set("IsEnemyLuredAway", true);
						this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
						return "AlliedSoldiers2";
					}

				},
				{
					Text = "指挥官，我需要你和你的人和我们并肩作战。",
					function getResult()
					{
						this.Flags.set("IsAlliedReinforcements", true);
						this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
						return "AlliedSoldiers3";
					}

				}
			],
			function start()
			{
				this.Banner = this.World.FactionManager.getFaction(this.Contract.getFaction()).getUIBanner();
				this.Flags.set("IsAlliedSoldiers", false);
			}

		});
		this.m.Screens.push({
			ID = "AlliedSoldiers2",
			Title = "%holysite%里",
			Text = "[img]gfx/ui/events/event_78.png[/img]{你取出长筒望远镜观察前方战场。北方部队以楔形阵势冲向敌军，随后两翼分兵朝不同方向散开。这看似自杀式的冲锋，却出人意料地演变成南方人难以抗拒的诱敌撤退。你看到镀金者的追随者们没有紧盯主要目标，反而分散阵型去追击佯攻的部队。%SPEECH_ON%这招真灵，队长。%SPEECH_OFF%%randombrother%说道。}",
			Image = "",
			Banner = "",
			List = [],
			Options = [
				{
					Text = "非常好。",
					function getResult()
					{
						this.Flags.set("IsAlliedSoldiers", false);
						this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
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
			ID = "AlliedSoldiers3",
			Title = "%holysite%里",
			Text = "[img]gfx/ui/events/event_78.png[/img]{你更希望这些士兵留在你麾下。指挥官点头道。%SPEECH_ON%是的长官，队长，呃，你怎么称呼？%SPEECH_OFF%你没理会他，吩咐%randombrother%将北方部队纳入防御阵线。%SPEECH_ON%确保他们熟悉部署，但别太熟悉。%SPEECH_OFF%那个佣兵凑近低语。%SPEECH_ON%啊，要是他们是间谍，咱们可不能透露太多细节，对吧队长？%SPEECH_OFF%你凑近轻声回应。%SPEECH_ON%不。把他们放在我们最薄弱的地方。但愿他们全在前线送死，这样我们就能接手他们的装备了。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Banner = "",
			Options = [
				{
					Text = "我们接着等吧。",
					function getResult()
					{
						this.Flags.set("IsAlliedSoldiers", false);
						this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
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
			ID = "Victory",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_168.png[/img]{最后一名南方士兵抬头看着你。%SPEECH_ON%镀金者的光辉在上，我已准备受死。%SPEECH_OFF%你拔出长剑。%SPEECH_ON%既然站在这里的是我，躺在那里的是你，那这光辉又有什么用？%SPEECH_OFF%不待他回应，你便一剑刺穿他的脖颈。你命令佣兵们搜刮战场，准备返回%employer%处。 | 你找到了最后一个南方士兵，他斜靠着石头，手臂搭在石头顶上，就像和酒友勾肩搭背。他吐着血沫点头道。%SPEECH_ON%看来我的道路不如想象中那般金光闪烁。%SPEECH_OFF%你点头回应，告诉他很快就能亲自向镀金者问个明白。%SPEECH_ON%我也会向他打听你的。%SPEECH_OFF%他答道。你因这句话顿了顿，随即用长剑刺穿了他。还有别的尸体等着搜掠。%employer%见到你应当会很高兴。 | 战斗结束，死者满地。你站在最后一名尚有气息的南方人身前。他越过你的肩膀凝视天空。当你问及是否认为他的“镀金者”正注视着时，那人微笑道。%SPEECH_ON%他正注视着你我。%SPEECH_OFF%你点头认可，随后终结了他的生命。你用一声锐利的哨响唤来%companyname%的注意，简洁明了地命令道：搜刮有价值的物品，整装准备返回%employer%处。}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "胜利！",
					function getResult()
					{
						this.Contract.spawnAlly();
						this.Contract.setState("Return");
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
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{南方人在%holysite%上空扬起了他们的旗帜。%SPEECH_ON%我看这下没戏了。%SPEECH_OFF%%randombrother%说道。如果“没戏”指的是别指望能从%employer%那领到报酬，那确实，没必要回去了。}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "灾难！",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "未能保卫某处圣地");
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{%SPEECH_START%我猜你们收拾那些南方杂种时，他们没少哭爹喊娘吧。%SPEECH_OFF%没等你回答，%employer%就咬下了半块鸡胸肉。他满嘴食物却还在不停说话，碎屑险些喷到桌上。%SPEECH_ON%要知道，我本来对旧神心存疑虑，但现在，经此一役，我明白了他们的指引才是正道，他们的神性至为公正。%SPEECH_OFF%他咽下剩余食物，把鸡骨头砸在盘子里。%SPEECH_ON%给佣兵结账。%SPEECH_OFF% | %employer%正被几位僧侣、修道院长和几个未婚女子簇拥着。贵族笑得合不拢嘴。%SPEECH_ON%几天前我们就听闻了你们的壮举。旧神正为你的手下举杯致敬呢，佣兵。我相信你让那些南方人尝遍了他们应得的地狱滋味——他们此刻定然还在其中煎熬。这是承诺给你的报酬。%SPEECH_OFF%几名女子朝你走来，但立刻被叫了回去。%SPEECH_ON%女士们，女士们，请自重。佣兵。%SPEECH_OFF%%employer%指向一个装着%reward%克朗的箱子。 | 你在修道院找到%employer%。他正独自在祭坛前祈祷，结束后头也不回地开口。%SPEECH_ON%旧神昨夜对我说话了。说你会带着好消息归来，果然，你来了。既然现在没有旁人，我跟你说些推心置腹的话。那些在沙漠里横行的\"镀金者\"，我觉得他们是真正的信徒。无论他们身在何处，此刻必然正在虔诚祷告。你根本没有动摇他们的信仰，总有一天我们还得再战一场。%SPEECH_OFF%贵族站起身转过来。%SPEECH_ON%失败会使信徒更加坚定。我受过挫，现在轮到他们了。当你领取这次任务的黄金时，不妨祈祷这是你为此事领取的最后一次酬劳。%SPEECH_OFF%你自然不会照做，但这样子真心换真心似乎不妥。不过%reward%克朗倒是非常妥帖地落入了战团的钱袋。}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "成功保卫了某处圣地");
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
			this.logInfo("姓名：" + s.getName());

			if (s.isMilitary())
			{
				candidates.push(s);
			}
		}

		local party = f.spawnEntity(tiles[0].Tile, candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly() + "战团", true, this.Const.World.Spawn.Noble, this.Math.rand(100, 150) * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
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
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(this.m.Destination.getTile());
		c.addOrder(move);
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

		local party = f.spawnEntity(tiles[0].Tile, "团" + candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly(), true, this.Const.World.Spawn.Southern, (this.m.Flags.get("IsEnemyLuredAway") ? 130 : 160) * this.getScaledDifficultyMult(), this.getMinibossModifier());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
		party.setDescription("忠于城邦的应征士兵。");
		party.setAttackableByAI(false);
		party.setAlwaysAttackPlayer(true);
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
		local attack = this.new("scripts/ai/world/orders/attack_zone_order");
		attack.setTargetTile(this.m.Destination.getTile());
		c.addOrder(attack);
		local occupy = this.new("scripts/ai/world/orders/occupy_order");
		occupy.setTarget(this.m.Destination);
		occupy.setTime(10.0);
		occupy.setSafetyOverride(true);
		c.addOrder(occupy);
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
			"employerfaction",
			this.World.FactionManager.getFaction(this.m.Faction).getName()
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
			foreach( i, s in sites )
			{
				if (v.getTypeID() == s && v.getFaction() != 0 && this.World.FactionManager.isAllied(this.getFaction(), v.getFaction()))
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
