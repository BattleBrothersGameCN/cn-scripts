this.privateering_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Item = null,
		CurrentObjective = null,
		Objectives = [],
		LastOrderUpdateTime = 0.0
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

		this.m.Type = "contract.privateering";
		this.m.Name = "私掠";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		local nobleHouses = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);

		foreach( i, h in nobleHouses )
		{
			if (h.getID() == this.getFaction())
			{
				nobleHouses.remove(i);
				break;
			}
		}

		nobleHouses.sort(this.onSortBySettlements);
		this.m.Flags.set("FeudingHouseID", nobleHouses[0].getID());
		this.m.Flags.set("FeudingHouseName", nobleHouses[0].getName());
		this.m.Flags.set("RivalHouseID", nobleHouses[1].getID());
		this.m.Flags.set("RivalHouseName", nobleHouses[1].getName());
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

		this.m.Flags.set("Score", 0);
		this.m.Flags.set("StartDay", 0);
		this.m.Flags.set("LastUpdateDay", 0);
		this.m.Flags.set("SearchPartyLastNotificationTime", 0);
		this.contract.start();
	}

	function onSortBySettlements( _a, _b )
	{
		if (_a.getSettlements().len() > _b.getSettlements().len())
		{
			return -1;
		}
		else if (_a.getSettlements().len() < _b.getSettlements().len())
		{
			return 1;
		}

		return 0;
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Flags.set("StartDay", this.World.getTime().Days);
				this.Contract.m.BulletpointsObjectives = [
					"前往%feudfamily%的领地",
					"劫掠和焚毁地点",
					"摧毁车队或巡逻队",
					"在5天后返回"
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
				local f = this.World.FactionManager.getFaction(this.Flags.get("FeudingHouseID"));
				f.addPlayerRelation(-99.0, "在战争中选择了阵营");
				this.Flags.set("StartDay", this.World.getTime().Days);
				local nonIsolatedSettlements = [];

				foreach( s in f.getSettlements() )
				{
					if (s.isIsolated() || !s.isDiscovered())
					{
						continue;
					}

					nonIsolatedSettlements.push(s);
					local a = s.getActiveAttachedLocations();

					if (a.len() == 0)
					{
						continue;
					}

					local obj = a[this.Math.rand(0, a.len() - 1)];
					this.Contract.m.Objectives.push(this.WeakTableRef(obj));
					obj.clearTroops();

					if (s.isMilitary())
					{
						if (obj.isMilitary())
						{
							this.Contract.addUnitsToEntity(obj, this.Const.World.Spawn.Noble, this.Math.rand(90, 120) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						}
						else
						{
							local r = this.Math.rand(1, 100);

							if (r <= 10)
							{
								this.Contract.addUnitsToEntity(obj, this.Const.World.Spawn.Mercenaries, this.Math.rand(90, 110) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
							}
							else
							{
								this.Contract.addUnitsToEntity(obj, this.Const.World.Spawn.Noble, this.Math.rand(70, 100) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
							}
						}
					}
					else if (obj.isMilitary())
					{
						this.Contract.addUnitsToEntity(obj, this.Const.World.Spawn.Militia, this.Math.rand(80, 110) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					}
					else
					{
						local r = this.Math.rand(1, 100);

						if (r <= 15)
						{
							this.Contract.addUnitsToEntity(obj, this.Const.World.Spawn.Mercenaries, this.Math.rand(80, 110) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						}
						else if (r <= 30)
						{
							obj.getFlags().set("HasNobleProtection", true);
							this.Contract.addUnitsToEntity(obj, this.Const.World.Spawn.Noble, this.Math.rand(80, 100) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						}
						else if (r <= 70)
						{
							this.Contract.addUnitsToEntity(obj, this.Const.World.Spawn.Militia, this.Math.rand(70, 110) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						}
						else
						{
							this.Contract.addUnitsToEntity(obj, this.Const.World.Spawn.Peasants, this.Math.rand(70, 100));
						}
					}

					if (this.Contract.m.Objectives.len() >= 3)
					{
						break;
					}
				}

				local origin = nonIsolatedSettlements[this.Math.rand(0, nonIsolatedSettlements.len() - 1)];
				local party = f.spawnEntity(origin.getTile(), origin.getName() + "战团", true, this.Const.World.Spawn.Noble, 190 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
				party.setDescription("听命于当地领主的职业军人。");
				this.Contract.m.UnitsSpawned.push(party.getID());
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
				local wait = this.new("scripts/ai/world/orders/wait_order");
				wait.setTime(9000.0);
				c.addOrder(wait);
				local r = this.Math.rand(1, 100);

				if (r <= 15)
				{
					local rival = this.World.FactionManager.getFaction(this.Flags.get("RivalHouseID"));

					if (!f.getFlags().get("Betrayed"))
					{
						this.Flags.set("IsChangingSides", true);
						local i = this.Math.rand(1, 18);
						local item;

						if (i == 1)
						{
							item = this.new("scripts/items/weapons/named/named_axe");
						}
						else if (i == 2)
						{
							item = this.new("scripts/items/weapons/named/named_billhook");
						}
						else if (i == 3)
						{
							item = this.new("scripts/items/weapons/named/named_cleaver");
						}
						else if (i == 4)
						{
							item = this.new("scripts/items/weapons/named/named_crossbow");
						}
						else if (i == 5)
						{
							item = this.new("scripts/items/weapons/named/named_dagger");
						}
						else if (i == 6)
						{
							item = this.new("scripts/items/weapons/named/named_flail");
						}
						else if (i == 7)
						{
							item = this.new("scripts/items/weapons/named/named_greataxe");
						}
						else if (i == 8)
						{
							item = this.new("scripts/items/weapons/named/named_greatsword");
						}
						else if (i == 9)
						{
							item = this.new("scripts/items/weapons/named/named_javelin");
						}
						else if (i == 10)
						{
							item = this.new("scripts/items/weapons/named/named_longaxe");
						}
						else if (i == 11)
						{
							item = this.new("scripts/items/weapons/named/named_mace");
						}
						else if (i == 12)
						{
							item = this.new("scripts/items/weapons/named/named_spear");
						}
						else if (i == 13)
						{
							item = this.new("scripts/items/weapons/named/named_sword");
						}
						else if (i == 14)
						{
							item = this.new("scripts/items/weapons/named/named_throwing_axe");
						}
						else if (i == 15)
						{
							item = this.new("scripts/items/weapons/named/named_two_handed_hammer");
						}
						else if (i == 16)
						{
							item = this.new("scripts/items/weapons/named/named_warbow");
						}
						else if (i == 17)
						{
							item = this.new("scripts/items/weapons/named/named_warbrand");
						}
						else if (i == 18)
						{
							item = this.new("scripts/items/weapons/named/named_warhammer");
						}

						item.onAddedToStash("");
						this.Contract.m.Item = item;
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
				this.Contract.m.BulletpointsObjectives = [];

				foreach( obj in this.Contract.m.Objectives )
				{
					if (obj != null && !obj.isNull() && obj.isActive())
					{
						this.Contract.m.BulletpointsObjectives.push("摧毁 " + obj.getName() + "附近" + obj.getSettlement().getName());
						obj.getSprite("selection").Visible = true;
						obj.setAttackable(true);
						obj.setOnCombatWithPlayerCallback(this.onCombatWithLocation.bindenv(this));
					}
				}

				this.Contract.m.BulletpointsObjectives.push("摧毁%feudfamily%的任何商队或巡逻队");
				this.Contract.m.BulletpointsObjectives.push("在%days%后返回");
				this.Contract.m.CurrentObjective = null;
			}

			function update()
			{
				if (this.Flags.get("LastUpdateDay") != this.World.getTime().Days)
				{
					if (this.World.getTime().Days - this.Flags.get("StartDay") >= 5)
					{
						this.Contract.setScreen("TimeIsUp");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Flags.set("LastUpdateDay", this.World.getTime().Days);
						this.start();
						this.World.State.getWorldScreen().updateContract(this.Contract);
					}
				}

				if (this.Contract.m.UnitsSpawned.len() != 0 && this.Time.getVirtualTimeF() - this.Contract.m.LastOrderUpdateTime > 2.0)
				{
					this.Contract.m.LastOrderUpdateTime = this.Time.getVirtualTimeF();
					local party = this.World.getEntityByID(this.Contract.m.UnitsSpawned[0]);
					local playerTile = this.World.State.getPlayer().getTile();

					if (party != null && party.getTile().getDistanceTo(playerTile) > 3)
					{
						local f = this.World.FactionManager.getFaction(this.Flags.get("FeudingHouseID"));
						local nearEnemySettlement = false;

						foreach( s in f.getSettlements() )
						{
							if (s.getTile().getDistanceTo(playerTile) <= 6)
							{
								nearEnemySettlement = true;
								break;
							}
						}

						if (nearEnemySettlement)
						{
							local c = party.getController();
							c.clearOrders();
							local move = this.new("scripts/ai/world/orders/move_order");
							move.setDestination(this.World.State.getPlayer().getTile());
							c.addOrder(move);
							local wait = this.new("scripts/ai/world/orders/wait_order");
							wait.setTime(this.World.getTime().SecondsPerDay * 1);
							c.addOrder(wait);

							if (party.getTile().getDistanceTo(playerTile) <= 8 && this.Time.getVirtualTimeF() - this.Flags.get("SearchPartyLastNotificationTime") >= 300.0)
							{
								this.Flags.set("SearchPartyLastNotificationTime", this.Time.getVirtualTimeF());
								this.Contract.setScreen("SearchParty");
								this.World.Contracts.showActiveContract();
							}
						}
					}
				}

				if (this.Flags.get("IsChangingSides") && this.Contract.getDistanceToNearestSettlement() >= 5 && this.World.State.getPlayer().getTile().HasRoad && this.Math.rand(1, 1000) <= 1)
				{
					this.Flags.set("IsChangingSides", false);
					this.Contract.setScreen("ChangingSides");
					this.World.Contracts.showActiveContract();
				}

				foreach( i, obj in this.Contract.m.Objectives )
				{
					if (obj != null && !obj.isNull() && !obj.isActive() || obj.getSettlement().getOwner().isAlliedWithPlayer() || obj.isAlliedWithPlayer())
					{
						obj.getSprite("selection").Visible = false;
						obj.setAttackable(false);
						obj.getFlags().set("HasNobleProtection", false);
						obj.setOnCombatWithPlayerCallback(null);
					}

					if (obj == null || obj.isNull() || !obj.isActive() || obj.getSettlement().getOwner().isAlliedWithPlayer() || obj.isAlliedWithPlayer())
					{
						this.Contract.m.Objectives.remove(i);
						this.Flags.set("LastUpdateDay", 0);
						break;
					}
				}
			}

			function onCombatWithLocation( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.CurrentObjective = _dest;

				if (_dest.getTroops().len() == 0)
				{
					this.onCombatVictory("RazeLocation");
					return;
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "RazeLocation";
					p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
					p.LocationTemplate.Template[0] = "tactical.human_camp";
					p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.None;
					p.LocationTemplate.CutDownTrees = true;
					p.LocationTemplate.AdditionalRadius = 5;

					if (_dest.isMilitary())
					{
						p.Music = this.Const.Music.NobleTracks;
					}
					else
					{
						p.Music = this.Const.Music.CivilianTracks;
					}

					p.EnemyBanners = [];

					if (_dest.getSettlement().isMilitary() || _dest.getFlags().get("HasNobleProtection"))
					{
						p.EnemyBanners.push(_dest.getSettlement().getBanner());
					}
					else
					{
						p.EnemyBanners.push("banner_noble_11");
					}

					if (_dest.getFlags().get("HasNobleProtection"))
					{
						local f = this.Flags.get("FeudingHouseID");

						foreach( e in p.Entities )
						{
							if (e.Faction == _dest.getFaction())
							{
								e.Faction = f;
							}
						}
					}

					this.World.Contracts.startScriptedCombat(p, _isPlayerAttacking, true, true);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "RazeLocation")
				{
					this.Contract.m.CurrentObjective.setActive(false);
					this.Contract.m.CurrentObjective.spawnFireAndSmoke();
					this.Contract.m.CurrentObjective.clearTroops();
					this.Contract.m.CurrentObjective.getSprite("selection").Visible = false;
					this.Contract.m.CurrentObjective.setOnCombatWithPlayerCallback(null);
					this.Contract.m.CurrentObjective.setAttackable(false);
					this.Contract.m.CurrentObjective.getFlags().set("HasNobleProtection", false);
					this.Flags.set("Score", this.Flags.get("Score") + 5);

					foreach( i, obj in this.Contract.m.Objectives )
					{
						if (obj.getID() == this.Contract.m.CurrentObjective.getID())
						{
							this.Contract.m.Objectives.remove(i);
							break;
						}
					}

					this.Flags.set("LastUpdateDay", 0);
				}
			}

			function onPartyDestroyed( _party )
			{
				if (_party.getFaction() == this.Flags.get("FeudingHouseID") || this.World.FactionManager.isAllied(_party.getFaction(), this.Flags.get("FeudingHouseID")))
				{
					this.Flags.set("Score", this.Flags.get("Score") + 2);
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

				foreach( obj in this.Contract.m.Objectives )
				{
					if (obj != null && !obj.isNull() && obj.isActive())
					{
						obj.getSprite("selection").Visible = false;
						obj.setOnCombatWithPlayerCallback(null);
					}
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Flags.get("Score") <= 9)
					{
						this.Contract.setScreen("Failure1");
					}
					else if (this.Flags.get("Score") <= 15)
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{你刚踏进%employer%的房间，他就立即说道。%SPEECH_ON%{佣兵，来得正好。我需要一支突击队去把%feudfamily%的锅碗瓢盆砸个稀烂——你懂我意思吧？不明白？说白了就是冲进他们地盘，能烧的全烧光。干个%days%足够重创他们的战争储备。但千万要提防敌方巡逻队。 | 啊，佣兵。听着，我需要些硬汉深入%feudfamily%领地，见商队就劫，见庄稼就烧。这活儿不太光彩，但能加速结束战争。我需要你在那里呆%days%时间，然后回来。 | 我需要有支劫掠队伍潜入%feudfamily%领地%days%，最大限度摧毁他们的物资。你会成为他们的死敌并被疯狂追捕，但只要避开巡逻队，这任务其实轻松简单。意下如何？ | 我们正与%feudfamily%交战，但战争不止是两军对垒。有时候需要点特殊手段。佣兵，我要你突袭他们领地%days%——摧毁商队、焚烧农场，一切有助于战局的事。当然要警惕巡逻队，换我被人这么搞地盘，追捕力度只会加倍。你怎么说？ | 长话短说：我需要有人去%feudfamily%地盘骚扰%days%。他们肯定防着你们这号人，行动时务必避开巡逻队。有兴趣吗？ | 有桩美差给你，佣兵。去%feudfamily%领地破坏%days%，能毁多少毁多少。这种手段最能提前结束战争。当然他们也明白这个道理，所以会拼命阻止你。}%SPEECH_OFF% | %employer%手指点向铺满桌面的地图。%SPEECH_ON%知道吗？击败对手最好的方式，就是让他根本无力作战——某本古籍上读到的。%SPEECH_OFF%这战争观很文艺，但没错。你点头附和。他继续道：%SPEECH_ON%我要你深入%feudfamily%领地，能破坏多少就破坏多少。劫商队、烧农场，你都懂的。全力破坏%days%后撤回。哦，最后提醒你一句：警惕巡逻队，他们可不会善待你的……远征。%SPEECH_OFF% | %employer%正在翻阅典籍，用羽毛笔做着批注。%SPEECH_ON%我祖父曾击败十倍于己的敌军。知道怎么做到的吗？那些拿我家俸禄的史官只会歌颂战场荣光——但真相并非如此。%SPEECH_OFF%你耸肩猜测他祖父用了计谋。贵族啪地合上书，指尖轻点：%SPEECH_ON%正是！他只带少量人马烧光了敌方的农场、粮仓和补给。再庞大的军队饿着肚子又能如何？佣兵，我要你如法炮制。去%feudfamily%领地破坏%days%，当然要避开巡逻队。要是被逮到，他们绝对会往死里收拾你。%SPEECH_OFF% | 你进门时撞见%employer%与一位老将军争执。将军挺直腰板：%SPEECH_ON%这种卑劣行径会玷污我家族的声誉！非要这么干就找底层贱民去！%SPEECH_OFF%他抓起自己的东西拂袖而去，经过你时还嗤之以鼻。%employer%笑着张开双臂：%SPEECH_ON%真是说魔鬼魔鬼就到。佣兵，我需要有人劫掠%feudfamily%领地%days%。我那些贵族指挥官觉得掉价，但你正合适。当然敌人也会觉得这种行径令人鄙夷，所以要是被发现了——做好被往死里打的准备。%SPEECH_OFF% | %employer%盯着桌上漫延的牛奶正从边缘滴落。%SPEECH_ON%有过被这种小事毁了一整天的经历吗？%SPEECH_OFF%你点头——谁没有呢？他继续道：%SPEECH_ON%我本想做奶酪，现在原料毁了全泡汤。佣兵，这现成的寓言正好对应战争。我要你去劫掠%feudfamily%的领地，打个比方就是“打翻他们的牛奶”：劫商队、烧农场、炸矿洞，不择手段。干满%days%就能成事。当然要提防巡逻队，换你在我地盘这么搞，我绝对把你脑袋插木桩上！%SPEECH_OFF% | 卫兵引你到花园，%employer%正在照料作物。植株倒伏在地，叶片被虫啃得斑驳残缺。他拾起枯枝说道：%SPEECH_ON%这本该是最丰饶的一季，却被肆虐的小虫子毁了。那些小混蛋肯定快活极了。%SPEECH_OFF%他扔下枯枝拍你肩膀：%SPEECH_ON%佣兵，我要你当敌人园子里的害虫。去%feudfamily%领地骚扰至少%days%。如果被抓住，他们绝对会像碾虫子那样对付你。所以学聪明点——像虫子躲鞋底那样避开巡逻队。%SPEECH_OFF% | 你进屋时%employer%正与女郎调情。她匆忙收拾物品避开视线离去。这位得意的贵族自斟一杯葡萄酒：%SPEECH_ON%别在意，她只是我妻子的朋友。%SPEECH_OFF%他将酒瓶放回桌面：%SPEECH_ON%既然说到朋友，不如你去%feudfamily%领地杀人发火一阵，就当你我交个朋友？%SPEECH_OFF%他晃悠着坐到桌沿，嗅嗅手指耸耸肩，抿了口酒：%SPEECH_ON%去他们地盘破坏%days%再回来。当然你想留那儿也行，但我建议撤回——他们的军队可不会一直容忍你。贵族最恨搅局的，这道理你懂。%SPEECH_OFF% | %employer%被指挥官们簇拥着。他招手让你上前，伸手指着你像在指控一桩你毫不知情的罪行：%SPEECH_ON%就是他了！这人肯定能胜任！佣兵！我需要硬点子去劫掠%feudfamily%领地%days%。尽你所能去破坏，凡是削弱他们战力的都不放过。记住保持机动，他们会全力扑杀发现的任何袭击者。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{五天的工期可不便宜。 | 这事%companyname%能办。 | 报酬呢？}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{这事不划算。 | 我们还有别的地方要去。 | 对战团而言太耗时间了。}",
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
			ID = "SearchParty",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_90.png[/img]{你接近了一处农庄，突然其中一个百叶窗嘭地打开。一个老妇人挥舞着白旗，用沙哑的嗓音叫喊。%randombrother%前去查看，听她说了几句就匆忙返回。%SPEECH_ON%长官，她说%feudfamily%知道我们的位置，正有大队敌军朝我们杀来。没错，她用的词就是\"大队\"。%SPEECH_OFF% | 你们经过一处农舍时，有个小男孩跑了出来。%SPEECH_ON%哇，你们就是要去杀强盗的人吗？%SPEECH_OFF%你问他是谁说的。男孩耸耸肩。%SPEECH_ON%我在酒馆瞎转悠时听说%feudfamily%知道强盗在哪儿，正派大个子去把他们揍扁呢！%SPEECH_OFF%孩子像拍虫子似的双手一拍。你揉揉他的脑袋：%SPEECH_ON%对，就是我们。快回家去吧。%SPEECH_OFF%你立刻将消息告知了%companyname%。 | %randombrother%从山坡上跑下来，瘫在你身边大口喘气。%SPEECH_ON%长官，我……他们……%SPEECH_OFF%他直起身子：%SPEECH_ON%我得练练体力了。但我要说的是——有大批敌军正在朝我们赶来！他们肯定清楚我们的位置，长官。%SPEECH_OFF%你点头下令全员戒备。 | 侦察发现：大批敌军巡逻队似乎已掌握你们的位置，正在逼近！%companyname%必须立即准备——无论是撤退还是坚守阵地决一死战。 | 你们已经暴露，%feudfamily%的大批士兵正在杀来！尽可能让兄弟们做好准备，据报这批敌军装备精良。 | %randombrother%向你汇报从当地人口中听到的消息：据说打着旗号的大批士兵正朝你们而来。你让佣兵描述纹章细节，确认是%feudfamily%的部队。他们必定已追踪到你们的行踪。%companyname%必须准备迎接一场恶战！ | 一群在溪边洗衣的妇人问你们怎么还待在这儿。你反问何出此言。其中一人发出粗野的笑声：%SPEECH_ON%听不清吗？我们是问你们怎么还在这儿晃悠。%feudfamily%正全力搜捕你们这号人。照我听说的，他们转眼就能摸到你们屁股后头。%SPEECH_OFF%你问她们从何得知。另一个妇人把衬衫摔进溪水：%SPEECH_ON%老爷，你怕是蠢得不行。谣言跑得比任何马都快。别问为啥，世道就是这样。%SPEECH_OFF%若这些村妇所言不虚，%companyname%必将面临一场苦战！ | 你登上山坡极目远眺，只见高举%feudfamily%旗帜的大队人马正朝你们逼近。这景象可真够瞧的，而且很快就能面对面见识了。\n\n敌军已追上%companyname%！既然烧光了他们的家当，你们就得准备迎接一场血战。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "小心点！",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TimeIsUp",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_36.png[/img]{已经快满%maxdays%了。兄弟们该动身回去找%employer%领赏钱了。 | 战队在外面已经活动%maxdays%了。%employer%应该正等着我们回去。 | 劫掠了%maxdays%便满足了合同的要求，现在是时候回去找%employer%拿钱了。没必要再打白工。 | %employer%就雇了%maxdays%。兄弟们没必要在外面多待，回去找他拿钱吧。 | %companyname%已经给%employer%干了%maxdays%。他就付这么多天的钱，现在最好赶紧回去。 | %employer%付的是%maxdays%的钱，你也已经干满了。%companyname%得赶紧回去领报酬了。 | 尽管你逐渐适应起在这片土地上肆虐的日子，但%employer%只付%maxdays%的钱。你最好现在回去找他。 | 你做的很好，但是时候回去找%employer%了，因为他只会给你%maxdays%的钱。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "是时候回去%townname%了。",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ChangingSides",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_51.png[/img]{行军途中，一个披暗色斗篷的男子缓步走近。兜帽的阴影遮住了他的面容。他在你面前停步，双手摊开。%SPEECH_ON%幸会。我是%rivalhouse%的信使。我们有个提议：请停止为%noblehouse%效力，加入我们。与我们合作绝不愁生计，贵战团将始终优先获得最优质的合约。为表诚意，我将献上这把名为%nameditem%的精良武器。%SPEECH_OFF%你仔细斟酌着这个提议。阵前倒戈本是佣兵的家常便饭。哪个贵族家族待你们更厚道？哪个家族更可能赢得战争？ | 你离开道路去小解。正放松时，一名男子竟从滴水的灌木丛中现身——身上却未见湿痕。你后跃拔出匕首，对方却摊开双手：%SPEECH_ON%且慢，佣兵。我是%rivalhouse%的信使，仅向你提出一项建议。加入我们。以后只要有雇佣需求，贵方始终享有最高优先级——意味着最优厚的合约与酬金。而且我不妨直言，我们的需求永无止境。为表诚意，我受命献上此物。%SPEECH_OFF%他缓缓捧出一柄工艺精湛的武器。你让他稍候，回去继续解手。当某处奔流不止时，万千思绪也已涌上心头。 | 你正在勘察地形，一个披暗色斗篷的男子悄然接近。%randombrother%揪住他兜帽，刀刃已架上脖颈。此人只是举起双手，自称是%rivalhouse%的信使。你点头示意他开口。%SPEECH_ON%我们有个提议：加入我们。抛弃你效忠的那些贵族败类，为我们效力。你将获得最优质的合约与最丰厚的报酬，最重要的是——你将站在胜利者这边！为表诚意，我奉命献上这柄名为%nameditem%的武器。当然，前提是你同意我们的提议。%SPEECH_OFF%你慎重权衡着，毕竟改换门庭可不是什么儿戏。 | 一道黑影沿路走来，手中握着一卷羊皮纸。%SPEECH_ON%夜安，%companyname%。我奉%rivalhouse%之命前来提出雇佣邀请。请背弃你现在的雇主，加入我们。你将获得更优渥的合约，更重要的是——您将站在这场战争的胜利方！如果你同意，同时也为了展示我们的诚意，我们愿意赠予你这柄名为%nameditem%的武器。%SPEECH_OFF%%randombrother%看向你耸耸肩：%SPEECH_ON%虽然我没资格说这话，但这事值得琢磨。%SPEECH_OFF%确实如此。 | 你离开队伍去勘察地形。正观察前方田野时，一个披斗篷的身影突然出现，手里捧着什么东西。%randombrother%猛地扑倒他，刀刃作势就要捅穿他的脸。陌生人举起双手，手里攥着一卷羊皮纸。你命他站起来表明身份。他自称来自%rivalhouse%，要给%companyname%带个提议。%SPEECH_ON%跳槽吧。你们佣兵跳槽又不丢人，大家本来就觉得你们会这么干。不就是为了钱吗？我们这儿合同最多，报酬最高。这不正是你们想要的？%SPEECH_OFF%信使整理着衣物，像个一时窘迫的使节般挺直身子。%SPEECH_ON%要是答应的话，我们还会送上这把叫%nameditem%的武器，以表诚意。你觉得怎么样？%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "诱人的提议。我接受。",
					function getResult()
					{
						return "AcceptChangingSides";
					}

				},
				{
					Text = "你在浪费时间。滚，不然就把你挂在那棵树上。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "AcceptChangingSides",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_51.png[/img]{你接受了提议。神秘信使带你到一处隐蔽树丛，从灌木后挖出武器交给你。%SPEECH_ON%合作愉快，佣兵。%SPEECH_OFF%可以肯定地说，%employer%和他的整个家族现在都恨透了你。 | 你接受提议后，信使带你离开道路，从灌木丛后捞出武器。交货时他还与你握手。%SPEECH_ON%你做了正确选择，佣兵。%SPEECH_OFF%%employer%无疑已视你为敌，没必要回去找他了——除非你的新雇主有此要求。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "%companyname%从此将为%rivalhouse%工作！",
					function getResult()
					{
						this.Contract.m.Item = null;
						local f = this.World.FactionManager.getFaction(this.Contract.getFaction());
						f.addPlayerRelation(-f.getPlayerRelation(), "在战争中改变了阵营");
						f.getFlags().set("Betrayed", true);
						local a = this.World.FactionManager.getFaction(this.Flags.get("RivalHouseID"));
						a.addPlayerRelationEx(50.0 - a.getPlayerRelation(), "在战争中改变了阵营");
						a.makeSettlementsFriendlyToPlayer();
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.updateAchievement("NeverTrustAMercenary", 1, 1);
				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(this.Contract.m.Item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + this.Contract.m.Item.getIcon(),
					text = "你获得了" + this.Contract.m.Item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer%将你迎进房间，递给你一袋%reward_completion%克朗。%SPEECH_ON%干得不错，佣兵。你几乎完成了我要求的所有任务。%SPEECH_OFF% | 你发现%employer%正在喂鸡。你拨开鸡群走到他面前汇报消息，他积极地回应道。%SPEECH_ON%是吗？很好。你是想要鸡饲料当报酬，还是克朗？%SPEECH_OFF%这位贵族板着脸看你，最后还是没憋住笑。%SPEECH_ON%那边站着的护卫拿着%reward_completion%克朗。他知道该交给谁。%SPEECH_OFF% | %employer%忙得没空见你，但他护卫递来的%reward_completion%克朗足以说明他对你的工作相当满意。 | %employer%用手指搅着酒杯。%SPEECH_ON%劫掠是脏活，但你干得不错。说实话，我本来指望你能给敌人带去灭顶之灾，不过现在这样也还行吧。%SPEECH_OFF%他舔掉手指上的酒液，扔给你一装有%reward_completion%克朗的袋子。 | %employer%瘫坐在椅子里，双手垂在扶手上，两腿伸直。%SPEECH_ON%你的%reward_completion%克朗报酬在那边。%SPEECH_OFF%他朝墙角扬了扬下巴，有个钱袋靠墙放着。你去取钱时他继续说道：%SPEECH_ON%算你干得不错。那袋钱的分量就是我的满意程度。%SPEECH_OFF% | 你在狗舍找到正在喂狗的%employer%。%SPEECH_ON%干得好，佣兵。要是我的士兵都有你这样的素质和干劲，这场战争撑不过第一个月。真是可惜啊。%SPEECH_OFF%他突然转身紧盯你，你以为这是在暗示招揽。你礼貌地打了个官腔婉拒，然后询问报酬。他晃着半截培根指向对面站着的护卫：%SPEECH_ON%钱在他那儿。总共%reward_completion%克朗。%SPEECH_OFF% | %employer%感谢你的服务。他说完这句就递给你%reward_completion%克朗。 | 你见到%employer%被指挥官们围着。他们正根据你的战果调整作战地图。这位贵族直起身端详着成果：%SPEECH_ON%虽然没达到最理想效果，但已经很好。非常好了。那边站着的护卫会给你%reward_completion%克朗。%SPEECH_OFF% | %employer%站在墙挂地图前用羽毛笔做标记，你发现这些记号是沿着%companyname%穿越%feudfamily%领地的路线放置的。贵族自顾自地哼着点头，头也不回地说：%SPEECH_ON%不算完美，但还不错。墙角有你的%reward_completion%克朗。%SPEECH_OFF% | %employer%的一名指挥官拦住你不让进房间，他递来一袋%reward_completion%克朗。%SPEECH_ON%大人正忙。请拿好报酬离开。%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "干活拿钱，天经地义。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "劫掠敌人的土地");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isCivilWar())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{你进屋时%employer%正和指挥官们喝得烂醉。一个魁梧将军拍你肩膀想说话，却扭头吐了起来。你快步躲开找到%employer%本人。%SPEECH_ON%哈，佣兵！我——嗝——给，%reward_completion%克朗。%SPEECH_OFF%你赶紧接过他递来的钱袋，免得被某人浇上一层呕吐物。%employer%晃悠着靠住桌子支撑身体：%SPEECH_ON%你差点把%feudfamily%的战争储备烧干净了！干得真他妈——嗝——漂亮！老子听过最他妈棒的差事！%SPEECH_OFF%你迂回穿过狂欢人群和呕吐物撤离了房间。 | %employer%猛摔酒杯，酒水大半泼在自己身上。%SPEECH_ON%精彩！卓越！完美！这就是我对你工作的评价，佣兵。见鬼，我们甚至抓到了几个从%feudfamily%的军队里跑来的逃兵，他们觉得那边已经输定了！给，%reward_completion%克朗，我请客！%SPEECH_OFF%他大笑着灌下一大口酒。 | 你走进%employer%房间时，他正端详作战地图，用羽毛笔轻搔下巴，不时哼着曲子点头。%SPEECH_ON%知道吗？我追踪你在%feudfamily%领地行动时差点把墨水用光，你的成果就是这么丰富，佣兵。%reward_completion%克朗在那边墙角。%SPEECH_OFF% | 有人在%employer%房外递来沉甸甸的钱袋。%SPEECH_ON%你的酬劳%reward_completion%克朗。大人正忙，但非常满意。这应该能体现他对你工作的赞赏。%SPEECH_OFF%确实是个好信号。 | 卫兵带你到%employer%紧锁的房门前，里面传来女声，他似乎正在……庆祝。卫兵敲门后又打消念头：%SPEECH_ON%我本来是想通报你来了，但他不喜欢被打扰——特别是这种时候。你懂的。%SPEECH_OFF%你点头问报酬在哪儿。卫兵引你去金库，一名鹰钩鼻男子在堆积如山的文书钱币后递来%reward_completion%克朗，并在卷轴上登记了交易。 | %employer%正在花园里监督仆人往沃土里栽苗。%SPEECH_ON%你花园里种了什么，佣兵？%SPEECH_OFF%你婉言表示自己不擅园艺。他若有所思地点头：%SPEECH_ON%我在考虑下季种萝卜。不说这个了——看见那个流汗的仆人了吗？他手里的袋子很沉，因为里面装着%reward_completion%克朗。这是给你的奖赏，说不定能买座自己的花园！%SPEECH_OFF% | %employer%和指挥官们正对着作战地图低语。有人推着带你们战徽的标记，用墨棒在地图上追踪轨迹。你抱臂高声道：%SPEECH_ON%看来对我的工作很满意？%SPEECH_OFF%贵族和指挥官们抬头。%employer%咧嘴笑着快步走来：%SPEECH_ON%当然！你干得太棒了，佣兵。那边护卫有%reward_completion%克朗作为报酬。%SPEECH_OFF% | %employer%站在指挥官中间，你进门时他欢呼道：%SPEECH_ON%老天爷啊！你差点把他们老家端了！除了天降神罚我还指望什么更好的结果？%reward_completion%克朗归你了，配得上这水准的工作！%SPEECH_OFF% | %employer%坐在房间里，对你十分满意：%SPEECH_ON%{瞧瞧，大功臣来了。我的小鸟们都在传颂你的战绩！干得漂亮消息自然传得快！%feudfamily%已受重创，战争结束近在眼前！墙角的袋子里装着%reward_completion%克朗。 | 你应该更得意些，佣兵。你对%feudfamily%做的超出我预期。没顺便灭他们全族倒是让我意外。罢了，来日方长。现在墙角有%reward_completion%克朗等着你。}%SPEECH_OFF% | 你见%employer%蹲在铺着作战地图的桌旁，目光掠过堆满的标记。%SPEECH_ON%你好，佣兵。%SPEECH_OFF%他跃起身，慢条斯理抓起代表%feudfamily%的标记扔开：%SPEECH_ON%欣赏你的杰作吧——没费多大力气就重创了我的敌人！我敢说这比正面战场还有效！墙角有%reward_completion%克朗，但愿报酬配得上你这完美表现。%SPEECH_OFF% | 你见%employer%和指挥官们被一群衣着与战时格格不入的女子包围。%SPEECH_ON%佣兵！快进来！%SPEECH_OFF%%employer%搂着两个女人踉跄后退。你勉强跟进去，有女子想拉你狂欢，被一位将军截胡。%employer%瘫坐椅子，女人坐在他腿上：%SPEECH_ON%你可是庆功宴的焦点人物！把%feudfamily%地盘搅得天翻地覆，比正面战场更能结束战争！干杯！%SPEECH_OFF%你环顾四周：%SPEECH_ON%庆功不错，但我不靠打架换酒色。你欠我钱。%SPEECH_OFF%雇主点头：%SPEECH_ON%当然！去找财务官亮出你的徽记，他会给你%reward_completion%克朗的。%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "干活拿钱，天经地义。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess * 2);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess * 2, "劫掠敌人的土地");
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
			ID = "Failure1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_45.png[/img]{你走进%employer%的房间，早已准备好承受他的怒火。而他果然大发雷霆。%SPEECH_ON%给我说清楚，佣兵。我付钱让你去袭击%feudfamily%的地盘。你接受了这桩买卖——我以为这是笔好交易，双方都能得利。现在你却站在这里说对我们的约定屁事没干？你这狗杂碎何必踏进这扇门？不，你比那还不如，你就是条想从干正事的贵族手里偷食的鼻涕虫。趁我还没发火，滚出去！%SPEECH_OFF%尽管%employer%气势汹汹，真正陷入危险的却是他。你迅速离开，免得按捺不住脾气要了这位贵族的性命。 | 你回到%employer%处，但护卫在门外拦住了你。%SPEECH_ON%他已经知道你干了——或者说什么都没干。你最好别进去。%SPEECH_OFF%掀桌的撞击声震得门扉发颤，接着是语无伦次的咆哮。你听从护卫的建议离开了。 | %employer%用手指反复摩挲杯沿，发出刺耳的嗡鸣。%SPEECH_ON%多么美妙的曲调。区区杯子怎会比你这佣兵更管用？想必世道就是如此。我托人办事，对方却搞砸。还有什么可说的？请出去吧。%SPEECH_OFF% | %employer%正在喂狗吃剩肉。旁观的仆从满脸宁愿自己当狗享受吃食的表情。有条狗轻轻从他手中叼走培根时，他转向你：%SPEECH_ON%狗就爱吃肉。我喂它们猪肉——那是头好猪，除了临终的糟心时刻一直活得挺滋润。现在我用它来喂狗。而你，佣兵，给我带来了你人生中的糟心时刻。我该拿你喂狗吗？不乐意？那就滚出我的房间。%SPEECH_OFF% | %employer%根本拒绝见你。他的两名护卫解释称，他因你未能对%feudfamily%领地造成任何破坏而大动肝火。合情合理。你谢过护卫让你省得听贵族老爷毫无意义的怒骂。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "去死吧！",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "未能成功劫掠敌人的土地");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noblehouse",
			this.World.FactionManager.getFaction(this.m.Faction).getName()
		]);
		_vars.push([
			"rivalhouse",
			this.m.Flags.get("RivalHouseName")
		]);
		_vars.push([
			"feudfamily",
			this.m.Flags.get("FeudingHouseName")
		]);
		_vars.push([
			"maxdays",
			"5天"
		]);
		local days = 5 - (this.World.getTime().Days - this.m.Flags.get("StartDay"));
		_vars.push([
			"days",
			days > 1 ? "" + days + "天" : "1天"
		]);

		if (this.m.Item != null)
		{
			_vars.push([
				"nameditem",
				this.m.Item.getName()
			]);
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			foreach( obj in this.m.Objectives )
			{
				if (obj != null && !obj.isNull() && obj.isActive())
				{
					obj.clearTroops();
					obj.setAttackable(false);
					obj.getSprite("selection").Visible = false;
					obj.getFlags().set("HasNobleProtection", false);
					obj.setOnCombatWithPlayerCallback(null);
				}
			}

			this.m.Item = null;
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
		_out.writeU8(this.m.Objectives.len());

		foreach( o in this.m.Objectives )
		{
			if (o != null && !o.isNull())
			{
				_out.writeU32(o.getID());
			}
			else
			{
				_out.writeU32(0);
			}
		}

		if (this.m.Item != null)
		{
			_out.writeBool(true);
			_out.writeI32(this.m.Item.ClassNameHash);
			this.m.Item.onSerialize(_out);
		}
		else
		{
			_out.writeBool(false);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local numObjectives = _in.readU8();

		for( local i = 0; i != numObjectives; i = ++i )
		{
			local o = _in.readU32();

			if (o != 0)
			{
				this.m.Objectives.push(this.WeakTableRef(this.World.getEntityByID(o)));
				local obj = this.m.Objectives[this.m.Objectives.len() - 1];

				if (!obj.isMilitary() && !obj.getSettlement().isMilitary() && !obj.getFlags().get("HasNobleProtection"))
				{
					local garbage = [];

					foreach( i, e in obj.getTroops() )
					{
						if (e.ID == this.Const.EntityType.Footman || e.ID == this.Const.EntityType.Greatsword || e.ID == this.Const.EntityType.Billman || e.ID == this.Const.EntityType.Arbalester || e.ID == this.Const.EntityType.StandardBearer || e.ID == this.Const.EntityType.Sergeant || e.ID == this.Const.EntityType.Knight)
						{
							garbage.push(i);
						}
					}

					garbage.reverse();

					foreach( g in garbage )
					{
						obj.getTroops().remove(g);
					}
				}
			}
		}

		local hasItem = _in.readBool();

		if (hasItem)
		{
			this.m.Item = this.new(this.IO.scriptFilenameByHash(_in.readI32()));
			this.m.Item.onDeserialize(_in);
		}

		this.contract.onDeserialize(_in);
	}

});
