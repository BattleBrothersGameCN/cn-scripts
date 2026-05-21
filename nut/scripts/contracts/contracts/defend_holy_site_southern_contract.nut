this.defend_holy_site_southern_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Target = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.defend_holy_site_southern";
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
		this.m.Payment.Pool = 1200 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
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

		local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		local houses = [];

		foreach( n in nobles )
		{
			if (n.getFlags().get("IsHolyWarParticipant"))
			{
				houses.push(n);
			}
		}

		this.m.Flags.set("DestinationName", this.m.Destination.getName());
		this.m.Flags.set("DestinationIndex", targetIndex);
		this.m.Flags.set("EnemyID", houses[this.Math.rand(0, houses.len() - 1)].getID());
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"前往%holysite%，抵御北方异教徒"
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 25)
				{
					this.Flags.set("IsAlchemist", true);
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

				local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
				local houses = [];

				foreach( n in nobles )
				{
					if (n.getFlags().get("IsHolyWarParticipant"))
					{
						n.addPlayerRelation(-99.0, "在战争中选择了阵营");
						houses.push(n);
					}
				}

				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);

				if (this.Contract.getDifficultyMult() >= 0.95)
				{
					local f = houses[this.Math.rand(0, houses.len() - 1)];
					local candidates = [];

					foreach( s in f.getSettlements() )
					{
						if (s.isMilitary())
						{
							candidates.push(s);
						}
					}

					local party = f.spawnEntity(this.Contract.m.Destination.getTile(), candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly() + "战团", true, this.Const.World.Spawn.Noble, this.Math.rand(100, 150) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
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
				if (this.Flags.get("IsAlchemist") && this.Contract.isPlayerAt(this.Contract.m.Home) && this.World.Assets.getStash().getNumberOfEmptySlots() >= 2)
				{
					this.Contract.setScreen("Alchemist1");
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
					"保卫%holysite%免受北方异教徒的侵犯",
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
					p.Music = this.Const.Music.NobleTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.Entities = [];
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
					p.EnemyBanners = [
						this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
					];

					if (this.Flags.get("IsLocalsRecruited"))
					{
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.PeasantsSouthern, 10, this.Contract.getFaction());
						p.AllyBanners.push("banner_noble_11");
					}

					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
				else if (this.Flags.get("IsSallyForth"))
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "DefendHolySite";
					p.Music = this.Const.Music.NobleTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.Entities = [];
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, (this.Flags.get("IsEnemyReinforcements") ? 130 : 100) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
					p.EnemyBanners = [
						this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
					];

					if (this.Flags.get("IsLocalsRecruited"))
					{
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.PeasantsSouthern, 50, this.Contract.getFaction());
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
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Flags.get("IsPalisadeBuilt") ? this.Const.Tactical.FortificationType.WallsAndPalisade : this.Const.Tactical.FortificationType.Walls;
						p.LocationTemplate.CutDownTrees = true;
						p.LocationTemplate.ShiftX = -4;
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];

						if (this.Flags.get("IsAlliedReinforcements"))
						{
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 50 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
							p.AllyBanners.push(this.World.FactionManager.getFaction(this.Contract.getFaction()).getPartyBanner());
						}

						if (this.Flags.get("IsLocalsRecruited"))
						{
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.PeasantsSouthern, 50, this.Contract.getFaction());
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
			Text = "{[img]gfx/ui/events/event_163.png[/img]%到处都找不到%employer%的身影。取而代之的是一位身着神职服饰的男子，身旁跟着一位将军。他们郑重其事地宣告，一支北方分队正在逼近%holysite%，企图将圣地完全纳入北方版图。由于城邦的士兵都在别处驻防，他们只能倚仗你火速前往防守。那不容置疑的语气中透着的焦虑，无疑预示着这将是报酬丰厚的差事。 | [img]gfx/ui/events/event_162.png[/img]你被推进%employer%的房间，维齐尔朝你点头鼓掌。%SPEECH_ON%可算来了，我们的小北方佬，准备为大家做件大事了。来，看看这张地图。看到我的部队在哪儿了吗？看到%holysite%在哪儿了吗？再看这里，北方的鼠辈……他们离圣地很近，而我的人马却很远。而你，正好就在这儿，离得确实很近，不是吗？%reward%克朗，我要你赶紧前往%holysite%并守住它。%SPEECH_OFF%维齐尔带着温和的笑容凝视你，仿佛这不是商议，而是沉甸甸的金子已让这请求与命令无异。}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{%companyname%可以帮你。 | 抵御北方人得要不少钱。 | 我很感兴趣，继续。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{这事不划算。 | 我们还有别的地方要去。 | 我不会冒险让战团对抗北方军队。}",
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
				for( local i = 0; i < 3; i = ++i )
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
			}

		});
		this.m.Screens.push({
			ID = "Preparation4",
			Title = "%holysite%里",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{仍徘徊在%holysite%周围的少数信徒，想必是最狂热、最虔诚的一群。既然你在此地代表南方势力，你让手下挑选出几个看起来比较镀金者信徒，要求他们为自己的神明而战。这无疑是再便捷不过的募兵手段——他们迅速武装起来，接受了最简短的训练。你只能指望他们在即将到来的实战中能派上些用场。}",
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
			Text = "[img]gfx/ui/events/event_78.png[/img]{北方军队到了——或者说，至少是残存的主力到了。虽然沉重的盔甲和武器让他们在长途跋涉中减员不少，但看起来仍然是个不容小觑的对手。你看向%randombrother%，他耸了耸肩。%SPEECH_ON%{除了风景不同，不就是又一场仗嘛。 | 我知道大伙儿又要扯什么宗教狗屁，但说实话，对我而言这不过是又一场厮杀。而我正求之不得。}%SPEECH_OFF%你点头认同，利刃出鞘，下令全员准备迎敌。}",
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
			ID = "Alchemist1",
			Title = "%townname%里",
			Text = "[img]gfx/ui/events/event_163.png[/img]{在%townname%的城门口，一名男子向你走来。从他胸前那些色彩斑斓的皮带和护符盒判断，这是位炼金术士。他声称受维齐尔派遣而来。%SPEECH_ON%材料所剩不多，但还够配制些特殊制品——具体选择当然由你定夺。%SPEECH_OFF%他介绍了三种方案：火油罐、闪光罐或发烟罐。}",
			Image = "",
			Banner = "",
			List = [],
			Options = [
				{
					Text = "我们要火油罐。",
					function getResult()
					{
						this.Flags.set("IsFirepot", true);
						return "Alchemist2";
					}

				},
				{
					Text = "我们要闪光罐。",
					function getResult()
					{
						this.Flags.set("IsFlashpot", true);
						return "Alchemist2";
					}

				},
				{
					Text = "我们要发烟罐。",
					function getResult()
					{
						this.Flags.set("IsSmokepot", true);
						return "Alchemist2";
					}

				},
				{
					Text = "我们不缺东西。",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Flags.set("IsAlchemist", false);
				this.Banner = this.World.FactionManager.getFaction(this.Contract.getFaction()).getUIBanner();
			}

		});
		this.m.Screens.push({
			ID = "Alchemist2",
			Title = "%townname%里",
			Text = "[img]gfx/ui/events/event_163.png[/img]{炼金术士动作迅捷，将整堆粉末状配料倒入钵中，又捣入少量你根本无从辨认的物质。整个过程耗时短得令人惊讶，不知该归功于他技艺精湛还是这根本就是场闹剧。无论如何，他如约将炼金药壶递到你手中。%SPEECH_ON%愿镀金者照亮你的征途，愿你们手中的刀剑让%holysite%重归祥和。%SPEECH_OFF%}",
			Image = "",
			Banner = "",
			List = [],
			Options = [
				{
					Text = "这些应该能派上用场。",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Banner = this.World.FactionManager.getFaction(this.Contract.getFaction()).getUIBanner();

				for( local i = 0; i < 2; i = ++i )
				{
					local item;

					if (this.Flags.get("IsFirepot"))
					{
						item = this.new("scripts/items/tools/fire_bomb_item");
					}
					else if (this.Flags.get("IsFlashpot"))
					{
						item = this.new("scripts/items/tools/daze_bomb_item");
					}
					else if (this.Flags.get("IsSmokepot"))
					{
						item = this.new("scripts/items/tools/smoke_bomb_item");
					}

					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "你获得了一个" + item.getName()
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "SallyForth1",
			Title = "%holysite%里",
			Text = "[img]gfx/ui/events/event_78.png[/img]{南方军队出现了，但来的并非主力部队，也不完全是斥候队。他们似乎根本没花心思保持队形，推进过程中就已经散乱不堪。如果此刻主动出击，很可能打他们个措手不及。}",
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
			Text = "[img]gfx/ui/events/event_50.png[/img]{%SPEECH_START%明智之举。%SPEECH_OFF%%randombrother%赞同了你的命令。%companyname%全速前进，打算在北方人准备就绪之前打他们个措手不及。你们快速穿过原野，转眼间就已经杀到他们面前。敌人还在从车上卸下装备物资，一看到你们出现，几个随军的杂役立刻吓得四散逃命，剩下的士兵则慌忙去拿武器。从指挥官那尖厉的嗓音判断，他显然没受过应付这种场面的训练——他每声嘶力竭地喊出一道命令，嗓音就嘶哑一分，而队伍还在勉强尝试组成阵型。不再浪费时间，你立即率军杀入敌阵！}",
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
			Text = "[img]gfx/ui/events/event_90.png[/img]{你结果了最后一名士兵，他们脸上惊愕的表情依然凝固着。%SPEECH_ON%队长，剩下的过来了。%SPEECH_OFF%%randombrother%眺望地平线后回报道。你点头下令让队员们做好准备。这次北方人以严整的阵型推进，虽然看到你和你脚下横陈的尸体时阵型出现了短暂的动摇。他们的旗帜升上天空，北方士兵们随之重振士气，带着愤怒与战意发起了冲锋。你低头看向%randombrother%，掸掉他肩上的一块碎肉。当他回望时你只是微微一笑。%SPEECH_ON%好戏上场了，得打扮得体面点。%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_164.png[/img]{%SPEECH_START%明智之举。%SPEECH_OFF%%randombrother%赞同了你的指令。%companyname%全速前进，打算在北方人准备就绪之前打他们个措手不及。你们快速穿过原野，转眼间就已经杀到他们面前。敌人还在从车上卸下装备物资，一看到你们出现，几个随军的杂役立刻吓得四散逃命，剩下的士兵则慌忙去拿武器。正当你以为胜券在握时，侧翼又出现了一支敌军部队。%SPEECH_ON%镀金者只会对配得上他圣光的人微笑，逐币者！%SPEECH_OFF%南方部队的指挥官高声嘲笑道。此时退守防御工事已经太远，而敌人又近在眼前，现在只剩下一个选择——你举起长剑，带领战士们准备发起冲锋。}",
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
			Text = "[img]gfx/ui/events/event_164.png[/img]{正当你严阵以待北方军队时，一队南方士兵差点打了你们个措手不及。好在他们仍是友军，并表示愿意效劳。%SPEECH_ON%镀金者启示我们你会在此地。虽你是逐币者，但我们愿遵从你的指挥，以祂的荣耀守护这片圣地。%SPEECH_OFF%从装备判断，他们最适合作为掩护部队引开部分敌军。或者，也可以将其暂时编入%companyname%以充实你方战力。}",
			Image = "",
			Banner = "",
			List = [],
			Options = [
				{
					Text = "指挥官，我需要你和你的人去包抄他们的弩手。",
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
			Text = "[img]gfx/ui/events/event_164.png[/img]{你取出长筒望远镜观察前方战场。南方士兵像蚂蚁般散开，与北方军队展开小规模交锋。令人惊喜的是，佯攻奏效了。你咧嘴一笑，看着北方部队分兵追击，战力因此而削减。}",
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
			Text = "[img]gfx/ui/events/event_164.png[/img]{你更希望这些士兵留在你麾下。指挥官点头道。%SPEECH_ON%镀金者将协助你的光荣托付给我们，无论你信与不信，祂同样也将一些光荣托付给了你。%SPEECH_OFF%行吧。你指派他们驻防位置，这群人立刻带着烦人的虔诚劲儿忙活起来，没完没了地念叨着什么金光啊圣光啊之类的鬼话。}",
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
			Text = "[img]gfx/ui/events/event_87.png[/img]{最后一名活着的北方人倒在地上，胸口带着伤，鲜血染红了地面。他眼神空茫，呼吸平静，仿佛已接受这就是结局。你拔出剑，但他抬手制止——不是求饶，只是让你暂缓。%SPEECH_ON%不必了。我已经看见了。它走了。不停地走。真不明白当初为何那么执着。%SPEECH_OFF%他颓然倒下，紧绷的手从胸前滑落。%randombrother%戳了戳尸体开始搜刮。你收剑入鞘，命令队伍准备返回维齐尔处。 | 你的手下正在清理最后的幸存者。无非是挨个补刀的事。有些尸体还会抽搐，但你知道人已经没了。你不明白为什么他们还能这样动弹，仿佛曾经的那个人把恐惧遗留在了躯壳里。其他的则毫无反应。有个躲藏士兵发出了一声尖叫，但很快沉寂。战场遍布败军尸骸，你命令%companyname%尽可能搜刮战利品，准备返回维齐尔处。 | 最后一个北方人退到了两块岩石的夹缝间，双手像蜘蛛缩回藏身洞窟般向两侧摊开。%SPEECH_ON%旧神绝不会宽恕你们这帮人。%SPEECH_OFF%一道阴影从上方掠过又消失，随后岩石落下砸碎了他的头颅。他瘫倒在地，身体抽搐，喉咙咯咯作响。%randombrother%从岩顶探头张望。%SPEECH_ON%这是最后一个了。咱们该收拾他们的装备，回去找那个……呃，那个摆架子的，维……维……子爵？%SPEECH_OFF%是维齐尔。不过也差不多。}",
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
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{如今%holysite%已落入北方人手中。考虑到你格外珍惜自己的项上人头——并且希望它继续待在原处——你认为至少短期内没必要回去见维齐尔了。}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{你在远离宫殿的一座小修道院里找到了%employer%。这地方可不常见到他的身影，只有一小群贫苦的信徒跪坐在他脚边聆听讲话。这位维齐尔瞥了你一眼，谈话间朝旁人点了点头。片刻后，一个蓄着胡子、配着双剑的男子走上前来。他上下打量你一番，随后侧身露出两名抬着箱子的仆人。%SPEECH_ON%维齐尔向你致谢，逐币者。愿镀金之路永远指引你的旅途。%SPEECH_OFF%当然，钱款交接的瞬间你就被请了出去。当大门在身后关上时，维齐尔连点头致意都欠奉。 | 你被领着穿过长廊，带入一个空房间。刹那间你怀疑自己是否将在此遭遇背叛。不过很少有人会在这种干净的场所动手。当你凝视着光洁的石地板时，%employer%从对面走了进来。他站在数尺开外，话音在房间里回荡。%SPEECH_ON%据说你作战英勇，而北方人在战场上被证明不过是群吠犬。我想后一句该是为取悦我编造的谎言。但身为思想者与务实派，我猜你同样感受到了敌军顽强的意志——正如他们也会感受到我们的。你将获得约定的酬劳，逐币者。%SPEECH_OFF%突然一列人马鱼贯而入站在维齐尔身后，你再次怀疑他们别有企图。所幸他们手中捧着钱袋。当你回头望向门口时，%employer%已不见踪影，片刻后他的仆从也尽数离去。 | %employer%将你迎入室内，几位精挑细选的宗教人士随侍在侧。这些谦逊的修士依次上前向你短暂鞠躬。维齐尔并未参与，但他打了个响指，仆人们便抬来一大箱克朗。最后，这些神职人员转向维齐尔，以同样的仪轨向他叩拜。他们还亲吻他的脚背与戒指——这些可不在给你的礼遇之列。%employer%开口道：%SPEECH_ON%我的道路始终闪耀金光，北方人。镀金者赐我慧眼，在众多被忽视的普通佣兵中独独选中你来守护%holysite%。我蒙受神恩，确然如此。%SPEECH_OFF%你拿起黄金离开，最后映入眼帘的是那群黑袍修士又开始了第二轮朝拜。}",
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
		local f = this.World.FactionManager.getFaction(this.getFaction());
		local candidates = [];

		foreach( s in f.getSettlements() )
		{
			candidates.push(s);
		}

		local party = f.spawnEntity(tiles[0].Tile, "团" + candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly(), true, this.Const.World.Spawn.Southern, this.Math.rand(100, 150) * this.getScaledDifficultyMult(), this.getMinibossModifier());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
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
		local f = this.World.FactionManager.getFaction(this.m.Flags.get("EnemyID"));
		local candidates = [];

		foreach( s in f.getSettlements() )
		{
			if (s.isMilitary())
			{
				candidates.push(s);
			}
		}

		local party = f.spawnEntity(tiles[0].Tile, candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly() + "战团", true, this.Const.World.Spawn.Noble, (this.m.Flags.get("IsEnemyLuredAway") ? 130 : 160) * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
		party.setDescription("听命于当地领主的职业军人。");
		party.setAttackableByAI(false);
		party.setAlwaysAttackPlayer(true);
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
