this.slave_uprising_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Target = null,
		IsEscortUpdated = false,
		IsPlayerAttacking = false
	},
	function setLocation( _l )
	{
		this.m.Destination = this.WeakTableRef(_l);
	}

	function create()
	{
		this.contract.create();
		this.m.DifficultyMult = this.Math.rand(70, 105) * 0.01;
		this.m.Type = "contract.slave_uprising";
		this.m.Name = "奴隶起义";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 450 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		this.m.Flags.set("SpartacusName", this.Const.Strings.SouthernNames[this.Math.rand(0, this.Const.Strings.SouthernNames.len() - 1)] + " " + this.Const.Strings.SouthernNamesLast[this.Math.rand(0, this.Const.Strings.SouthernNamesLast.len() - 1)]);
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"镇压%townname%附近%location%的负债者起义"
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 20)
				{
					this.Flags.set("IsOutlaws", true);
					this.Contract.m.Destination.setActive(false);
					this.Contract.m.Destination.spawnFireAndSmoke();
				}
				else if (r <= 40)
				{
					this.Flags.set("IsSpartacus", true);
				}
				else if (r <= 60)
				{
					this.Flags.set("IsFleeing", true);
				}
				else
				{
					this.Flags.set("IsFightingBack", true);
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
					"镇压%townname%附近%location%的负债者起义"
				];
				this.Contract.m.Destination.getSprite("selection").Visible = true;
				this.Contract.m.Destination.setOnEnterCallback(this.onDestinationEntered.bindenv(this));
			}

			function update()
			{
				if (this.Flags.get("IsVictory"))
				{
					if (this.Flags.get("IsSpartacus"))
					{
						this.Contract.setScreen("Spartacus4");
					}
					else if (this.Flags.get("IsFightingBack"))
					{
						this.Contract.setScreen("FightingBack2");
					}

					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
			}

			function onDestinationEntered( _dest )
			{
				if (this.Flags.get("IsFleeing"))
				{
					this.Contract.setScreen("Fleeing1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsOutlaws"))
				{
					this.Contract.setScreen("Outlaws1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsSpartacus"))
				{
					this.Contract.setScreen("Spartacus1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsFightingBack"))
				{
					this.Contract.setScreen("FightingBack1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "SlaveUprisingContract")
				{
					this.Flags.set("IsVictory", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_Outlaws",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"猎杀%townname%周边落草为寇的负债者"
				];
				this.Contract.m.Destination.getSprite("selection").Visible = false;
				this.Contract.m.Destination.setOnEnterCallback(null);
				this.Contract.m.Home.getSprite("selection").Visible = false;

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull())
				{
					this.Contract.setScreen("Outlaws3");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerInitiated )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerInitiated;
				this.World.Contracts.showCombatDialog();
			}

		});
		this.m.States.push({
			ID = "Running_Fleeing",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"猎杀逃离%townname%的负债者"
				];
				this.Contract.m.Destination.getSprite("selection").Visible = false;
				this.Contract.m.Destination.setOnEnterCallback(null);
				this.Contract.m.Home.getSprite("selection").Visible = false;

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull())
				{
					this.Contract.setScreen("Fleeing3");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerInitiated )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerInitiated;

				if (!this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Contract.setScreen("Fleeing2");
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
					"返回%townname%"
				];
				this.Contract.m.Destination.getSprite("selection").Visible = false;
				this.Contract.m.Destination.setOnEnterCallback(null);
				this.Contract.m.Home.getSprite("selection").Visible = true;
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
			Text = "[img]gfx/ui/events/event_162.png[/img]{平日里被沉思氛围环绕的%employer%，此刻正陷于顾问和维齐尔同僚的讨论漩涡中，他们不时打响指，激烈地在地图上指指点点。在这片混乱中，一名小侍从灵巧地穿过人群，将一卷文书递到你面前。他熟练地解释道：%townname%的%location%已被负债者控制。%SPEECH_ON%现需要逐币者效力。若您愿参与让各方回归正轨，为负债者与主人共谋福祉，请在此文书画叉确认。%SPEECH_OFF%你们四目相对片刻，他叹着气轻点纸面。%SPEECH_ON%若接此任务，酬金在此。共%reward%克朗。 | 当你走近%employer%的房间时，两名守卫当即用戟尖对准了你。此时一位侍从快步赶来喝止。%SPEECH_ON%卫兵！这些衣着邋遢的旅人是逐币者。失礼了，逐币者，我们如此紧张的原因正是维齐尔们需要各位协助的理由：负债者们已控制了%townname%的%location%。暴乱恐怕将由此蔓延。%SPEECH_OFF%侍从取出一卷文书递来。上面写明镇压负债者叛乱可得%reward%克朗，文书末尾盖着%townname%诸位维齐尔的联合印章。 | %townname%的维齐尔们齐聚作战室，气氛比平时凝重许多。你被挡在远处无法靠近——从天花板降下的金色栅栏横在面前。他们低声商议，不时点头，最后将一卷文书交给侍从。侍从接过文书后快步走来递给你，并凭记忆复述。%SPEECH_ON%负债者已经推翻了他们的主人，占领了%location%。剿灭这群叛乱者的人，可获得%reward%克朗酬劳。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{他们毫无胜算。 | 我们会拿他们杀鸡儆猴。 | 我们会夺回%location%。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{听起来这活不适合我们。 | 我觉得还是免了吧。 | 我们不想跟逃跑的奴隶战斗。}",
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
			ID = "FightingBack1",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_71.png[/img]{%location%的负债者们看着你们靠近，你希望武器的寒光能让他们停止争取自由的行动。令人惊讶的是，他们非但没有放下武器，反而集结起来与你们对峙。这群乌合之众都是强制劳役和征兵制度的牺牲品。 | 你找到这群负债者，他们回望的眼神清楚地表明他们知道你的来意。双方阵营泾渭分明：你们全副武装从城镇而来，而他们拿着搜刮来的简陋武器，远离曾经束缚他们的锁链。这是支杂乱可怜的队伍，但你深知他们对自由的渴望足以弥补武器的匮乏。自由的滋味最能磨砺人的意志。 | 正如情报所述，负债者们占领了%location%并用能找到的一切武装自己。见到你们后，他们匆忙摆出阵型，但缺乏训练、纪律和补给。然而他们宁死不愿回到过去境遇的决心，却比任何钢铁都要锋利危险。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "灭了他们！",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.Music = this.Const.Music.OrientalBanditTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.LocationTemplate.Template[0] = "tactical.desert_camp";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.None;
						p.LocationTemplate.CutDownTrees = true;
						p.Tile = tile;
						p.CombatID = "SlaveUprisingContract";
						p.TerrainTemplate = "tactical.desert";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.NomadRaiders, 30 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getID());
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Slaves, 55 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "FightingBack2",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_71.png[/img]{起义已被镇压。死去时，奴隶们的面容确实带着几分解脱，仿佛万物的终结也好过枷锁下无情残酷的生活。%employer%与维齐尔们正在等候你返回。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们干完活了。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Outlaws1",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_176.png[/img]{你到达%location%后发现它已被烧成废墟，洗劫一空。一名幸存者从建筑焦黑的灰烬中蹒跚走出。他解释说，那些负债者袭击了所有能碰到的人，对妇女施暴，杀害孩童，劫掠了所有值钱物品，然后分散逃往了偏僻地带。 | 暴动的负债者早已离开%location%，只留下一片死亡与毁灭。一些幸存者蹒跚地收拾着残存的物件。那些还能开口的人讲述着恐怖经历，说负债者简直像野蛮人一样袭击了这片地区，杀人、施暴、抢劫。一个用破布遮住眼睛的男子说，他听见他们谈论要前往乡间并在那里分散开来。%SPEECH_ON%他们现在是普通的强盗了。尝过鲜血的野兽再也无法回到锁链下的生活。他们彻底迷失了。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们会去追捕他们的。",
					function getResult()
					{
						this.World.uncoverFogOfWar(this.Contract.m.Target.getPos(), 400.0);
						this.World.getCamera().moveTo(this.Contract.m.Target);
						this.Contract.setState("Running_Outlaws");
						return 0;
					}

				}
			],
			function start()
			{
				local cityTile = this.Contract.m.Home.getTile();
				local nearest_nomads = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getNearestSettlement(cityTile);
				local tile = this.Contract.getTileToSpawnLocation(this.Contract.m.Home.getTile(), 9, 15);
				local party = this.World.FactionManager.getFaction(nearest_nomads.getFaction()).spawnEntity(tile, "负债者", false, this.Const.World.Spawn.NomadRaiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.setDescription("一群落草为寇的负债者。");
				party.setFootprintType(this.Const.World.FootprintsType.Nomads);
				party.getSprite("banner").setBrush(nearest_nomads.getBanner());
				party.getSprite("body").setBrush("figure_nomad_03");
				this.Contract.m.UnitsSpawned.push(party);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.setVisibleInFogOfWar(true);
				party.setImportant(true);
				party.setDiscovered(true);
				party.setAttackableByAI(false);
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Home);
				roam.setMinRange(8);
				roam.setMaxRange(12);
				roam.setAllTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
				roam.setTerrain(this.Const.World.TerrainType.Shore, false);
				roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
				c.addOrder(roam);
			}

		});
		this.m.Screens.push({
			ID = "Outlaws3",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_168.png[/img]{你低头看着一具奴隶的尸体，那身躯被过去的劳役塑造，但手中和颈间却装饰着偷来的武器与战利品。带着一丝残酷的念头，你觉得奇怪：若他们除了自由别无野心，或许更容易被镇压。但正是贪婪与渴求让他们变得更加危险。不过。他们都死了。而%townname%的维齐尔们会很高兴——无论这些负债者曾怀揣怎样崇高的目标。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们干完活了。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Spartacus1",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_166.png[/img]{你发现那些负债者正坐在荒漠的岩石间，他们对你的到来并无反应。只有一个男人向你走来。尽管他体格强壮，你却感觉他是来谈判的——有什么比肌肉更能令人信服的外交辞令呢。%SPEECH_ON%逐币者，我料到你总会来的。我叫%spartacus%，是这些自由追寻者推选出来的首领——倘若敞开的笼子也能算是渴望飞翔之鸟的首领的话。你沿着镀金之路来到我们面前，被那条无形的金链，还有那些你无法保证会兑现的承诺所牵引至此。而你正是要凭借这些伪造的约定，这些被曲解的协议，来此杀戮或俘获我们。我说得对吗？%SPEECH_OFF%你点了点头。%spartacus%也点头回应。%SPEECH_ON%果然如此。在我们各自践行约定之前——我们决心成为自己命运的主宰，而你则甘为克朗的奴隶——请允许我以一种，呵，逐币者，你会觉得有利可图的方式，尝试与你交涉。%SPEECH_OFF%这个男人单膝跪地。%SPEECH_ON%我是一个失落家族、失落传承、失落家业的末裔。这些人，这些兄弟们，如今就是我的家人。但我之前的生活仍为我留下了某物，或许你会认为它价值连城。%SPEECH_OFF%他递出一张纸。%SPEECH_ON%放我们走，我就在这张纸上为你写下藏宝之地，那里藏着你在别处绝找不到的财富。若你选择攻击，我便会将家族最后的传承带进坟墓。而我最后一息所牵挂的，将不再是那些湮没的财宝，而是去呼吸自由本身的炽烈火焰，让它在我肺中闪耀。这痛苦，也远胜于任何锁链带来的安逸。%SPEECH_OFF%}}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我同意你的条件。你自由了。",
					function getResult()
					{
						return "Spartacus2";
					}

				},
				{
					Text = "我只是公事公办。你们那点螳臂当车的反抗，到此为止了。",
					function getResult()
					{
						return "Spartacus3";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Spartacus2",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_166.png[/img]{你伸出了手。%spartacus%也伸出手来。他开口道：%SPEECH_ON%就这么说定了。%SPEECH_OFF%他举起一支石制的铅笔，笔尖是某种黑色粉末岩石。他指向远处的一块石头。%SPEECH_ON%我们离开时，我会在那块石头上写好家族遗产的位置。我看到你脸上写着疑问，想知道我是否在欺骗你。这种不确定性正是自由的代价，不是吗？不确定将去往何方，却是凭自己的意志前行。这才是真正的自由。笼中的安逸属于不愿飞翔的鸟儿，逐币者。愿你在镀金之路上的旅程，能像我们迈出的第一步这般硕果累累。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "趁着还有机会，尽情享受你们的自由吧。",
					function getResult()
					{
						local bases = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getSettlements();
						local location;
						local lowest_distance = 9000;

						foreach( b in bases )
						{
							if (!b.getLoot().isEmpty() && !b.getFlags().get("IsEventLocation"))
							{
								local d = b.getTile().getDistanceTo(this.Contract.m.Home.getTile()) + this.Math.rand(1, 5);

								if (d < lowest_distance)
								{
									location = b;
									lowest_distance = d;
								}
							}
						}

						if (location == null)
						{
							bases = this.World.EntityManager.getLocations();

							foreach( b in bases )
							{
								if (!b.getLoot().isEmpty() && !b.getFlags().get("IsEventLocation") && !b.isAlliedWithPlayer() && b.isLocationType(this.Const.World.LocationType.Lair))
								{
									local d = b.getTile().getDistanceTo(this.Contract.m.Home.getTile()) + this.Math.rand(1, 5);

									if (d < lowest_distance)
									{
										location = b;
										lowest_distance = d;
									}
								}
							}
						}

						this.World.uncoverFogOfWar(location.getTile().Pos, 700.0);
						location.getFlags().set("IsEventLocation", true);
						location.setDiscovered(true);
						this.World.getCamera().moveTo(location);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationMajorOffense, "选择帮助起义的负债者");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Spartacus3",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_166.png[/img]{%spartacus%伸出手，但你并未伸手回应，反而拔出了剑。这位反抗军首领点了点头。%SPEECH_ON%好吧。我明白了，你无法离开克朗的牢笼，被镀金之路的光芒所驱使。你的奴役如此彻底，你的禁锢如此深刻，以至于当牢门敞开时，你却不展开双翼，宁愿仅仅跳到主人的指头上。愿战斗善待我们双方，逐币者。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.Music = this.Const.Music.OrientalBanditTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.LocationTemplate.Template[0] = "tactical.desert_camp";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.None;
						p.LocationTemplate.CutDownTrees = true;
						p.Tile = tile;
						p.CombatID = "SlaveUprisingContract";
						p.TerrainTemplate = "tactical.desert";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.NomadRaiders, 30 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getID());
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Slaves, 55 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Spartacus4",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_168.png[/img]{你站在%spartacus%的尸身旁。这位反抗军领袖虽然一生向往自由，但在最终获得解脱的时刻，死去的他脸上却没有笑容。他的面容因痛苦而扭曲，身上的伤口显露出皮下组织的黏腻纹路。但他的眼睛。那里曾跃动着一点星火，凝望着天空。一道阴影掠过他的眼眸，你抬头望去以为会看到飞鸟，却空无一物。当你再度低头时，那点星火已然熄灭，死者终究只是死者。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们干完活了。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Fleeing1",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_59.png[/img]{你发现一堆散乱的镣铐，摸上去还很烫手。一位老人伸手指向北边。%SPEECH_ON%那些获得自由的人往那边去了。%SPEECH_OFF%你觉得奇怪，便问他为何要告发那些负债者。他笑了笑。%SPEECH_ON%我有些活儿需要完成，有时候维齐尔们会借几个人给我。单靠我自己这两只手，实在很难把活儿干好。%SPEECH_OFF% | 你发现一道长长的沙土与灌木痕迹，明显遭受过朝北行进的扰动。在散落着杂物的路径中，你找到了一副镣铐，这是所需的最后一点证据。负债者已经转向北边，你必须去追猎他们了。 | 你看见一副镣铐在沙漠灌木丛中晃荡。一个正用杯子喝水的老汉嘟哝着指向北方。%SPEECH_ON%那些负债者像兔子一样往那边跑了。你要是能把他们抓回去交给维齐尔，或许能替我说句好话。我这儿正缺一两个人手帮忙打水。自由人可不会给我打水。%SPEECH_OFF%你自然不会为谁美言，但还是谢过他，然后向北行进。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们会去追捕他们的。",
					function getResult()
					{
						this.World.uncoverFogOfWar(this.Contract.m.Target.getPos(), 400.0);
						this.World.getCamera().moveTo(this.Contract.m.Target);
						this.Contract.setState("Running_Fleeing");
						return 0;
					}

				}
			],
			function start()
			{
				local cityTile = this.Contract.m.Home.getTile();
				local nearest_nomads = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getNearestSettlement(cityTile);
				local tile = this.Contract.getTileToSpawnLocation(this.Contract.m.Home.getTile(), 9, 15);
				local party = this.World.FactionManager.getFaction(nearest_nomads.getFaction()).spawnEntity(tile, "负债者", false, this.Const.World.Spawn.Slaves, 90 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.setDescription("一群负债者。");
				party.setFootprintType(this.Const.World.FootprintsType.Nomads);
				party.getSprite("banner").setBrush("banner_deserters");
				this.Contract.m.UnitsSpawned.push(party);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.setVisibleInFogOfWar(true);
				party.setImportant(true);
				party.setDiscovered(true);
				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);
				local c = party.getController();
				local randomVillage;
				local northernmostY = 0;

				for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
				{
					local v = this.World.EntityManager.getSettlements()[i];

					if (v.getTile().SquareCoords.Y > northernmostY && !v.isMilitary() && !v.isIsolatedFromRoads() && v.getSize() <= 2)
					{
						northernmostY = v.getTile().SquareCoords.Y;
						randomVillage = v;
					}
				}

				local move = this.new("scripts/ai/world/orders/move_order");
				move.setDestination(randomVillage.getTile());
				c.addOrder(move);
				local wait = this.new("scripts/ai/world/orders/wait_order");
				wait.setTime(9000.0);
				c.addOrder(wait);
				this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Destination.getTile(), party.getTile(), this.Const.GenericFootprints, this.Const.World.FootprintsType.Nomads, 0.75);
			}

		});
		this.m.Screens.push({
			ID = "Fleeing2",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_59.png[/img]{你终于追上了这些负债者。他们如今已是饱经风霜的亡命徒，所穿越的荒芜之地在他们身上留下了印记，正如他们也在那片土地上留下了痕迹。但他们跋涉至此绝非为了放弃：一见到你，这群人便全体武装起来，并向你逼近。 | 这些负债者处境绝望，虽说这段旅程给予了他们喘息的自由，他们却为此付出了身心俱疲的代价。这些晒伤、困顿、衣衫褴褛的男人双眼圆睁又充满疲惫地靠近。从他们狂野的眼神中你明白，他们已毫无退意，决心要血战到底。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "灭了他们！",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Fleeing3",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_168.png[/img]{回过头来看，彻底解决这些负债者其实是件简单直接的事。幸存者们都让自己断了回头路，宁可选择刀剑下的死亡。设身处地想，你也不确定自己会做出不同的选择。你收集了能作为证据的物品，准备返回%employer%处。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们干完活了。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_162.png[/img]{你没看到%employer%沉溺女色或畅游酒池，而是见他提着空鸟笼踱步。他阴郁地说心爱的鸟儿逃出笼子飞走了。%SPEECH_ON%别把我当傻子，逐币者，我看得出你觉得我的宠物与那些负债者有相似之处。随你怎么想。但你这么想太短见了。我的鸟自由翱翔于天际，对这世间而言，除了沦为他人腹中食外别无用处。但这并非自由，逐币者——重拾自己天生的使命叫什么自由？真正的自由是逃离这种命运，逃进我的世界，这是它大多数同类永远得不到的机会。%SPEECH_OFF%维齐尔打了个响指，一个侍从仿佛凭空出现。他递给你一袋钱币。你抬头时，维齐尔已经放下鸟笼走开了。 | %employer%正埋首于他那——用守卫的话说——“最宠爱的后宫”的玉体横陈之中。他伸出嘴来，你感觉他的目光正从某个汗湿的膝弯处盯着你，不过无法确定。%SPEECH_ON%逐币者胜利归来了，让他疲惫的双眼好好享用我这儿最上等的货色吧。我的探子说，你确实已经将那些不知天高地厚的负债者铲除殆尽，而他们死亡的消息已被重新利用，成了一句善意的警告，由你亲手书写，逐币者，用以警示其他所有负债者。%SPEECH_OFF%维齐尔消失不见，随即又从一名女子的大腿间冒了出来。%SPEECH_ON%仆从！给逐币者付钱。%SPEECH_OFF%两个瘦骨嶙峋的少年抬过来一个小箱子，放在你脚边。箱子相当沉重，而且没人帮你把它抬出去。 | 一个戴着镣铐的男子在%employer%的房间外迎接你。他双臂各连着一条锁链。一条锁链通向墙壁，另一条则哗啦啦地拖过地板，连着一箱克朗。两条锁链都挂着锁。而钥匙，就在这个男人手里。他紧盯着你，手指反复攥紧又松开钥匙，呼吸急促而不稳。他终于蹲下身，打开了连着你的箱子的那把锁。你拿起箱子后退一步。奴隶将钥匙紧握在胸前，他瞥了一眼另一把锁，将钥匙紧紧攥在手心，低下头，发出一阵你难以分辨是何意味的声响。一名守卫呵斥他保持安静，接着带你出门。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "钱给够就行。",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-2);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "镇压了一场负债者起义。");
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
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"location",
			this.m.Destination.getRealName()
		]);
		_vars.push([
			"spartacus",
			this.m.Flags.get("SpartacusName")
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/slave_revolt_situation"));
		}
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
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
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
		local location = _in.readU32();

		if (location != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(location));
		}

		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});
