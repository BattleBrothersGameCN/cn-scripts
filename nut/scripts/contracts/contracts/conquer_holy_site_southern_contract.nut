this.conquer_holy_site_southern_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Target = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.conquer_holy_site_southern";
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

		this.m.Payment.Pool = 1300 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
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
		this.m.Flags.set("Commander", this.Const.Strings.SouthernNames[this.Math.rand(0, this.Const.Strings.SouthernNames.len() - 1)]);
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
					"从北方异教徒手中征服%holysite%",
					"摧毁或击溃附近的敌方部队"
				];
				this.Contract.setScreen("Task");
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
					p.Music = this.Const.Music.NobleTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "ConquerHolySiteCounterAttack";
					p.Music = this.Const.Music.NobleTracks;
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
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						p.Music = this.Const.Music.NobleTracks;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 200 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
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
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
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
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						p.Music = this.Const.Music.NobleTracks;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, (130 + (this.Flags.get("MercenariesAsAllies") ? 30 : 0)) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
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
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
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
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
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
					p.LocationTemplate.Template[0] = "tactical.southern_ruins";
					p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
					p.Music = this.Const.Music.NobleTracks;
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, (this.Flags.get("IsCounterAttack") ? 110 : 130) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
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
			Text = "[img]gfx/ui/events/event_162.png[/img]{你在堆积如山的卷宗后找到了%employer%。他正忙于书写，周围的圣职人员同样专注地守候着，确保在维齐尔写完最后一句话的瞬间就能收走卷轴。这位奋笔疾书的大人物终于抬起头来。%SPEECH_ON%我们遇到了%holysite%被北方鼠辈侵占的事件。我会尽量克制情绪——毕竟镀金者的教义不主张让怒火玷污理智，我就简单表态吧：这些野蛮人的存在冒犯了理性的尊严。%SPEECH_OFF%维齐尔蘸了蘸羽毛笔继续边写边说。%SPEECH_ON%不过，犬吠惊飞鸟。我需要一条能撕咬的猎犬，逐币者，带着你的战队去圣地根除那些败类。若达成协议，%reward%克朗与镀金者的荣光将待你归来。%SPEECH_OFF% | %employer%以出人意料的热情迎接你。%SPEECH_ON%我早知镀金者必将为我带来举足轻重的强者，一个真正孔武有力的战士。说是逐币者没错，但更是真正的勇士！%SPEECH_OFF%不待你询问任务详情，维齐尔便举起一只黄金圣杯，杯沿如同月牙般被削去半边。%SPEECH_ON%我们最神圣的土地%holysite%已被北方野蛮人占领。我们的世界正面临黑暗威胁，要抵御这片阴影必须确保行动顺利。我麾下将士虽众，但镀金者眷顾的土地辽阔无边。我需要你这样的战士助我们夺回%holysite%。因为这片土地乃镀金者之封邑，而镀金者必会犒赏众人：任务完成可得%reward%克朗。我们可否达成协议？ | 难得一见地，你发现%employer%正匍匐在一枚日光形状的闪耀徽章之下。他低声自语后起身，再次低语，逐一清洁指尖，然后转向你。%SPEECH_ON%当我的军队在别处高歌猛进时，%holysite%却无人防守。我急于赢得这场战争，却给北方野蛮人敞开了侵占的大门。我当面请求你提供外部援助。镀金者会为我们铺就镀金之路，逐币者，你同样在祂的慷慨恩泽之内。只要你夺回%holysite%，经由我手，你将获得%reward%克朗！%SPEECH_OFF% | 一只金质高脚杯砸在大理石地板上，酒水四处飞溅。维齐尔对你喊道，语气混杂着愤怒与需求。%SPEECH_ON%总算来了能帮忙的人！%SPEECH_OFF%他挥手屏退几名侍从，甚至几名看似是他指挥官的人。%SPEECH_ON%逐币者，%holysite%已被北方渣滓攻占。一想到他们在那洗劫我就悲痛落泪，而他们玷污镀金者圣迹的每一天，我都将再度哭泣。%reward%克朗。这就是将要筹备并放入你口袋的数目。对你来说确实丰厚，但人们说得对，对某些人而言，镀金之路的含义或许更为直白。%SPEECH_OFF% | %employer%被身着绸缎的随从环绕。一人提着带罩的笼子，里面萤火虫的微光忽明忽暗；另一人拿着鸟笼，里面的鸟儿只剩骨架和两根仿佛复现其完整羽翼的羽毛。见到你，维齐尔从这些人中间走出，如同穿行于神庙坚不可摧的立柱之间。%SPEECH_ON%逐币者，你来了！我的斥候报告说，我们在对抗北方野狗的战争中退了一步。%holysite%已被占领，依照镀金者的启示，我必须将其夺回。不仅为了我的领土，更是为了让祂的荣光不至蒙尘。成事你将获得%reward%克朗，重赏之下必有勇夫，正是如此！%SPEECH_OFF% | 一反往常珠光宝气、被熟识的奢靡之徒环绕的景象，你发现%employer%身着简朴服饰跪在地上。他头戴饰有黑色绳圈的头巾。这位收敛了社交锋芒的维齐尔平静地对你说。%SPEECH_ON%北方异教徒已从我们土地上夺走了%holysite%。我不责怪他们的行为，他们不知自己在做什么。凭我赤诚双手，镀金者必知我过。但失败不意味着投降。我需要你前往圣地，将其归还于我。为此，你将获得%reward%克朗的犒赏。%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{正如维齐尔所料，北方人已在%holysite%内外展开部署。大多数普通信徒早已撤离，现在只剩下%companyname%与敌军对峙。你拔出长剑，下令战士们准备进攻。}",
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
			Text = "[img]gfx/ui/events/event_164.png[/img]{当你接近%holysite%时，一个人突然站起，仿佛从地下冒出。你受惊拔出武器，但对方表明自己是%employer%手下的指挥官，只是在潜伏而已。%SPEECH_ON%放轻松，逐币者，你的赏金少不了。维齐尔的信鸽早已将你的行踪告知我们，不得不说你们来得有点晚。我明白这不是你们的战争，不过……好吧，现在不是责备的时候。我们一起为镀金者夺回圣地，愿我们前方的道路永远沐浴在祂的光辉之中。%SPEECH_OFF% | 当%holysite%映入眼帘时，一个人影从地底冒出。他询问你是否是%companyname%的指挥官，你的片刻迟疑似乎给了他答案，于是他立即开口。%SPEECH_ON%是了，你当然是。我是%employer%的副官%commander%。维齐尔的信鸽早已通报你可能前来。逐币者，你或许是为钱财而来，但若今日获胜，镀金者的荣光必将照亮你明日的道路！%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_134.png[/img]{当%holysite%映入眼帘时，一个看起来与你惊人相似的男子走了过来。他身边带着一个财务官和几个佣兵。%SPEECH_ON%晚上好，队长。我是%mercenarycompany%的%mercenary%。我和你一样，来这片土地是为了赚取克朗。我敢打赌维齐尔已经签了份靠谱合同雇你和你的手下，不过如果你付我%pay%克朗，我就帮你完成这桩小事——你意下如何？%SPEECH_OFF% | 一群人向你走来，其中一人的步态和体格都与你相似到古怪的程度。他自称是%mercenarycompany%的队长%mercenary%。%SPEECH_ON%我原以为维齐尔会派他的正规军来夺回圣地。实不相瞒，队长，最初帮北方人占领这座神圣纪念碑的正是我。不过，只要%pay%克朗，我很乐意帮你们夺回来。同为佣兵，你肯定明白这对各方都是笔好买卖。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [],
			function start()
			{
				if (this.World.Assets.getMoney() > this.Flags.get("MercenaryPay"))
				{
					this.Options.push({
						Text = "你被雇佣了!",
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
			Text = "[img]gfx/ui/events/event_134.png[/img]{%SPEECH_START%真遗憾。%SPEECH_OFF%%mercenary%说着，迅速退回到%mercenarycompany%的队列中。他一路后退，直接融入了防守%holysite%的北方士兵阵线。他双臂张开摆动，仿佛在逆流游泳。%SPEECH_ON%我是说，真他妈遗憾！好吧，%companyname%的队长，就让咱们瞧瞧哪边请到了更强的佣兵，好吗？%SPEECH_OFF%这名佣兵拔出了武器，他身后%holysite%的北方士兵们也纷纷亮出兵刃。自然地，你也拔出了武器。是时候战斗了。 | %SPEECH_ON%行，行，我明白了。好吧。我本来也没抱太大期望。毕竟，我也是个雇佣兵。而现在……%SPEECH_OFF%他步步后退，与自己的战团会合，而他的战团则与守护%holysite%的北方士兵们融为一体。%SPEECH_ON%眼下看来，北方人才是出价更高的主顾。%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_78.png[/img]{战斗已经结束，但远处有盔甲的金属反光在闪烁。你眯起眼睛聚焦于逐渐接近的身影。或许他们是前来朝圣的信徒——不，是北方人！这是他们的反击！ | 当你收剑入鞘时，一支箭从头顶呼啸而过，轻声扎进沙地。你朝来源望去，只见一个紧张的年轻弓箭手正被人拍打后脑勺，而在他身旁赫然是一整支北方部队！这是他们的反击！}",
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
			Text = "[img]gfx/ui/events/event_78.png[/img]{不过是又来了一批北方佬。%SPEECH_OFF%%randombrother%说道。你点头回应。%SPEECH_ON%正好给镀金者的火焰添更多柴薪。%SPEECH_OFF%他嘀咕说镀金者更喜欢黄金而非火焰，但你让他闭嘴，准备好迎接即将到来的战斗。%holysite%本身的防御工事应该能帮上忙。 | 你命令士兵们在%holysite%内组织防御。%randombrother%环顾四周。%SPEECH_ON%你说那些看着这里的神明会不会有点恼火？懂我意思吗？就像我们把他们的锅碗瓢盆搞得一团糟？%SPEECH_OFF%你拍了下他的后脑勺，让他集中注意力。}",
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
			Text = "[img]gfx/ui/events/event_78.png[/img]{你命令%companyname%进入战场。北方部队的军官咧嘴笑着向你挥手致意。%SPEECH_ON%终于敢出来了，是吧？怎么，祷告腻了？%SPEECH_OFF%你转身啐了一口。%SPEECH_ON%我们只是没地方埋你们的尸体罢了。%SPEECH_OFF%他的笑容瞬间消失，随即下令冲锋。准备战斗！}",
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
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{当你收剑入鞘，让战团从尸体上搜集战利品时，你隐约感到%holysite%并非第一次经历这般血腥。罢了，若有人注定要重蹈祖先的覆辙，你很高兴那人不是你。几名南方士兵前来接管这片圣地。有他们驻守，你便动身离开，心知%employer%必将喜迎你带回的消息。 | 你打败了敌人，成功收复了%holysite%。南方士兵逐渐进驻防御工事。随后零散跟来的是一群信徒，他们穿过横陈的尸骸，只为在那至圣之所顶礼膜拜。没有一人向你道谢。不过无所谓，因为这是%employer%的职责。 | 战事既毕，一小群信徒开始聚集在%holysite%的各个角落。你都不知道这些人是从哪儿冒出来的。他们不打扰你们，你们也不理会他们。现在重要的是，%employer%备好的大笔克朗正待你归去。当你离开时，几名南方士兵接防驻地，同样没吐露半句感谢。}",
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
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{你未能保护%holysite%免受北方人侵占。待在这儿是没什么用了，如果你实在是想把你的头放在维齐尔的鎏金托盘里的话，回去找%employer%也行。}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer%正坐在一件金色圣徽的光芒下——那是由链条从天花板悬吊下来的巨大金属物件，形如太阳。这一定是你外出期间新建造的。当你上前时，一位圣职人员拦住你并摇了摇头。他在空中画了个圆，随后将指尖轻触你的头顶。他微笑着将你引到房间另一侧，%reward%克朗已被整齐码放在木托盘中。\n\n那人鞠躬，双手指向金色圣徽，手掌姿态如同托举着整个构造物，随后他做出引导圣徽的荣光至酬金的动作，钱币顿时迸发出光芒。虽是某种把戏，但报酬确是真的，于是你收下钱便离开了。 | 当你走进%employer%的房间，数名守卫短暂地鞠躬并伏地跪拜后起身。远处，维齐尔静坐在王座上，身着丝绸的圣职人员环绕四周。今日你似乎无缘近前觐见，但一群少年将盛满钱币的托盘逐批端到你面前，直到你收齐%reward%克朗。维齐尔点头并翻转手掌。你收取报酬后便离去。 | 你走进宏伟殿堂，看见%employer%仿佛被一团金色烟雾所包裹。他手腕上系着布条，站在旋转平台上——由藏身地板下的奴隶吃力地推动着转动。他的侍妾们站在一旁，口中含满某种金色液体，随后将其喷溅成水雾。细看之下，这场面远不如初入时想象的那般辉煌。所幸你无需继续观摩：一名身着圣袍的壮汉拦住你，将你引至房间后方的长桌。桌上排列着盛满钱币的托盘，总计是你应得的%reward%克朗报酬。钱款到手后，你便被匆忙带离了殿堂。}",
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
			candidates.push(s);
		}

		local party = f.spawnEntity(tiles[0].Tile, "团" + candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly(), true, this.Const.World.Spawn.Southern, 170 * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
		party.setDescription("忠于城邦的应征士兵。");
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
			if (s.isMilitary())
			{
				candidates.push(s);
			}
		}

		local party = f.spawnEntity(tiles[0].Tile, candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly() + "战团", true, this.Const.World.Spawn.Noble, this.Math.rand(100, 140) * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
		party.setDescription("听命于当地领主的职业军人。");
		party.setAttackableByAI(false);
		party.setAlwaysAttackPlayer(true);
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
