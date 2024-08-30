this.tutorial_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Location = null,
		BigCity = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.tutorial";
		this.m.Name = "%companyname%战团";
		this.m.TimeOut = this.Time.getVirtualTimeF() + 9000.0;
	}

	function start()
	{
		local settlements = this.World.EntityManager.getSettlements();
		local best_dist = 9000;
		local best_start;
		local best_big;

		foreach( s in settlements )
		{
			if (s.isMilitary() || s.getSize() > 1 || s.isIsolatedFromRoads())
			{
				continue;
			}

			local bestDist = 9000;
			local best;

			foreach( b in settlements )
			{
				if (s.getID() == b.getID())
				{
					continue;
				}

				if (b.getSize() <= 1 || b.isIsolatedFromRoads())
				{
					continue;
				}

				local d = s.getTile().getDistanceTo(b.getTile());

				if (d < bestDist)
				{
					bestDist = d;
					best = b;
				}
			}

			if (best != null && bestDist < best_dist)
			{
				best_dist = bestDist;
				best_start = s;
				best_big = best;
			}
		}

		this.setHome(best_start);
		this.setOrigin(best_start);
		this.m.Home.setVisited(true);
		this.m.Home.setDiscovered(true);
		this.World.uncoverFogOfWar(this.m.Home.getTile().Pos, 500.0);
		this.m.Faction = best_start.getFactions()[0];
		this.m.EmployerID = this.World.FactionManager.getFaction(this.m.Faction).getRandomCharacter().getID();
		this.m.BigCity = this.WeakTableRef(best_big);
		local tile = this.getTileToSpawnLocation(this.m.Home.getTile(), 5, 8, [
			this.Const.World.TerrainType.Swamp,
			this.Const.World.TerrainType.Forest,
			this.Const.World.TerrainType.LeaveForest,
			this.Const.World.TerrainType.SnowyForest,
			this.Const.World.TerrainType.Shore,
			this.Const.World.TerrainType.Ocean,
			this.Const.World.TerrainType.Mountains
		]);
		this.World.State.getPlayer().setPos(tile.Pos);
		this.World.getCamera().jumpTo(this.World.State.getPlayer());
		this.m.Flags.set("BossName", "黄鼠狼霍加特");
		this.m.Flags.set("LocationName", "霍加特避难所 ");
		this.setState("StartingBattle");
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "StartingBattle",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"击杀%boss%。"
				];
				this.World.State.m.IsAutosaving = false;
			}

			function update()
			{
				if (!this.Flags.get("IsTutorialBattleDone"))
				{
					if (!this.Flags.get("IsIntroShown"))
					{
						this.Flags.set("IsIntroShown", true);
						this.Sound.play("sounds/intro_battle.wav");
						this.Contract.setScreen("Intro");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.Music = this.Const.Music.CivilianTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "Tutorial1";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Custom;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Custom;
						p.PlayerDeploymentCallback = this.onPlayerDeployment.bindenv(this);
						p.EnemyDeploymentCallback = this.onAIDeployment.bindenv(this);
						p.IsFleeingProhibited = true;
						p.IsAutoAssigningBases = false;
						this.World.Contracts.startScriptedCombat(p, false, false, false);
					}
				}
				else
				{
					this.Contract.setScreen("IntroAftermath");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Tutorial1")
				{
					this.Flags.set("IsTutorialBattleDone", true);
					local brothers = this.World.getPlayerRoster().getAll();
					brothers[0].setIsAbleToDie(true);
					brothers[1].setIsAbleToDie(true);
					brothers[2].setIsAbleToDie(true);
					this.World.State.m.IsAutosaving = true;
				}
			}

			function onPlayerDeployment()
			{
				for( local x = 0; x != 32; x = ++x )
				{
					for( local y = 0; y != 32; y = ++y )
					{
						local tile = this.Tactical.getTileSquare(x, y);
						tile.Level = 0;

						if (x > 11 && x < 22 && y > 12 && y < 21)
						{
							tile.removeObject();

							if (tile.IsHidingEntity)
							{
								tile.clear();
								tile.IsHidingEntity = false;
							}
						}
					}
				}

				this.Tactical.fillVisibility(this.Const.Faction.Player, true);
				local brothers = this.World.getPlayerRoster().getAll();
				this.Tactical.addEntityToMap(brothers[0], 13, 15 - 13 / 2);
				brothers[0].setIsAbleToDie(false);
				this.Tactical.addEntityToMap(brothers[1], 13, 16 - 13 / 2);
				brothers[1].setIsAbleToDie(false);
				this.Tactical.addEntityToMap(brothers[2], 12, 18 - 12 / 2);
				brothers[2].setIsAbleToDie(false);
				this.Tactical.CameraDirector.addJumpToTileEvent(0, this.Tactical.getTile(6, 17 - 6 / 2), 0, null, null, 0, 0);
				this.Tactical.CameraDirector.addMoveSlowlyToTileEvent(0, this.Tactical.getTile(18, 17 - 18 / 2), 0, null, null, 0, 1000);
				this.Contract.spawnBlood(11, 12);
				this.Contract.spawnBlood(13, 15);
				this.Contract.spawnBlood(14, 17);
				this.Contract.spawnBlood(15, 16);
				this.Contract.spawnBlood(17, 14);
				this.Contract.spawnBlood(15, 15);
				this.Contract.spawnBlood(18, 16);
				this.Contract.spawnBlood(12, 14);
				this.Contract.spawnBlood(13, 16);
				this.Contract.spawnBlood(12, 15);
				this.Contract.spawnBlood(16, 18);
				this.Contract.spawnBlood(15, 17);
				this.Contract.spawnArrow(13, 13);
				this.Contract.spawnArrow(14, 17);
				this.Contract.spawnArrow(17, 15);
				this.Contract.spawnCorpse(12, 13);
				this.Contract.spawnCorpse(16, 14);
				this.Contract.spawnCorpse(17, 16);
				this.Contract.spawnCorpse(15, 14);
				this.Contract.spawnCorpse(14, 18);
			}

			function onAIDeployment()
			{
				local e;
				this.Const.Movement.AnnounceDiscoveredEntities = false;
				e = this.Tactical.spawnEntity("scripts/entity/tactical/humans/bounty_hunter", 16, 16 - 16 / 2);
				e.setFaction(this.Const.Faction.PlayerAnimals);
				e.setName("一只眼");
				e.getSprite("socket").setBrush("bust_base_player");
				e.assignRandomEquipment();
				e.getSkills().removeByID("perk.overwhelm");
				e.getSkills().removeByID("perk.nimble");
				e.getItems().getItemAtSlot(this.Const.ItemSlot.Body).setArmor(0);

				if (e.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					e.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				if (e.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					e.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				e.getBaseProperties().Hitpoints = 5;
				e.getBaseProperties().MeleeSkill = -200;
				e.getBaseProperties().RangedSkill = 0;
				e.getBaseProperties().MeleeDefense = -200;
				e.getBaseProperties().Initiative = 200;
				e.getSkills().update();
				e.setHitpoints(5);
				e = this.Tactical.spawnEntity("scripts/entity/tactical/humans/bounty_hunter", 15, 18 - 15 / 2);
				e.setFaction(this.Const.Faction.PlayerAnimals);
				e.setName("伯恩哈德队长");
				e.getSprite("socket").setBrush("bust_base_player");
				e.getSkills().removeByID("perk.overwhelm");
				e.getSkills().removeByID("perk.nimble");
				local armor = this.new("scripts/items/armor/mail_hauberk");
				armor.setVariant(32);
				armor.setArmor(0);
				e.getItems().equip(armor);
				e.getItems().equip(this.new("scripts/items/weapons/arming_sword"));
				e.getBaseProperties().Hitpoints = 9;
				e.getBaseProperties().MeleeSkill = -200;
				e.getBaseProperties().RangedSkill = 0;
				e.getBaseProperties().MeleeDefense = -200;
				e.getBaseProperties().DamageTotalMult = 0.1;
				e.getBaseProperties().Initiative = 250;
				e.getSkills().update();
				e.setHitpoints(5);
				e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/bandit_thug", 18, 17 - 18 / 2);
				e.setFaction(this.Const.Faction.Enemy);
				e.getAIAgent().getProperties().OverallDefensivenessMult = 0.0;
				e.getAIAgent().getProperties().BehaviorMult[this.Const.AI.Behavior.ID.Retreat] = 0.0;
				e.assignRandomEquipment();
				e.getBaseProperties().Initiative = 300;
				e.getSkills().update();
				e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/bandit_thug", 17, 18 - 17 / 2);
				e.setFaction(this.Const.Faction.Enemy);
				e.getAIAgent().getProperties().OverallDefensivenessMult = 0.0;
				e.getAIAgent().getProperties().BehaviorMult[this.Const.AI.Behavior.ID.Retreat] = 0.0;
				e.assignRandomEquipment();
				e.getBaseProperties().Initiative = 200;
				e.getSkills().update();
				e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/bandit_raider_low", 19, 17 - 19 / 2);
				e.setFaction(this.Const.Faction.Enemy);
				e.setName(this.Flags.get("BossName"));
				e.getAIAgent().getProperties().OverallDefensivenessMult = 0.0;
				e.getAIAgent().addBehavior(this.new("scripts/ai/tactical/behaviors/ai_retreat_always"));
				local items = e.getItems();
				items.equip(this.new("scripts/items/armor/patched_mail_shirt"));
				items.equip(this.new("scripts/items/weapons/hunting_bow"));
				this.Flags.set("BossHead", e.getSprite("head").getBrush().Name);
				this.Flags.set("BossBeard", e.getSprite("beard").HasBrush ? e.getSprite("beard").getBrush().Name : "");
				this.Flags.set("BossBeardTop", e.getSprite("beard_top").HasBrush ? e.getSprite("beard_top").getBrush().Name : "");
				this.Flags.set("BossHair", e.getSprite("hair").HasBrush ? e.getSprite("hair").getBrush().Name : "");
				e.getBaseProperties().Hitpoints = 300;
				e.getSkills().update();
				e.setHitpoints(180);
				e.setMoraleState(this.Const.MoraleState.Wavering);
				this.Const.Movement.AnnounceDiscoveredEntities = true;
			}

		});
		this.m.States.push({
			ID = "ReturnAfterIntro",
			function start()
			{
				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.Contract.m.BulletpointsObjectives = [
					"返回" + this.Contract.m.Home.getName() + "以获得报酬"
				];
				this.World.State.getPlayer().setAttackable(false);
				this.World.State.m.IsAutosaving = true;
			}

			function update()
			{
				if (this.World.getTime().Days > 2)
				{
					this.World.State.getPlayer().setAttackable(true);
				}

				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("PaymentAfterIntro1", false);
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Recruit",
			function start()
			{
				this.Contract.m.Home.getSprite("selection").Visible = false;
				this.Contract.m.BigCity.getSprite("selection").Visible = true;
				this.Contract.m.BulletpointsObjectives = [
					"造访%townname%%citydirection%边的%bigcity% "
				];

				if (this.World.getPlayerRoster().getSize() < 6)
				{
					if (this.Math.max(1, 6 - this.World.getPlayerRoster().getSize()) > 1)
					{
						this.Contract.m.BulletpointsObjectives.push("至少再招募" + this.Math.max(1, 6 - this.World.getPlayerRoster().getSize()) + " 个人");
					}
					else
					{
						this.Contract.m.BulletpointsObjectives.push("至少再招募一个人");
					}
				}

				this.Contract.m.BulletpointsObjectives.push("给你的人买武器和盔甲");
				this.World.State.getPlayer().setAttackable(false);
				this.Contract.m.BigCity.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.BigCity.getTile().Pos, 500.0);
			}

			function update()
			{
				if (this.World.getTime().Days > 4)
				{
					this.World.State.getPlayer().setAttackable(true);
				}

				if (this.World.getPlayerRoster().getSize() >= 6 && this.Flags.get("IsMarketplaceTipShown"))
				{
					this.Contract.setState("ReturnAfterRecruiting");
				}
				else if (this.World.getPlayerRoster().getSize() >= 6 && this.Contract.m.BulletpointsObjectives.len() == 3)
				{
					this.start();
					this.World.Contracts.updateActiveContract();
				}
				else if (!this.Flags.get("IsMarketplaceTipShown") && this.World.State.getPlayer().getDistanceTo(this.Contract.m.BigCity.get()) <= 600)
				{
					this.Flags.set("IsMarketplaceTipShown", true);
					this.Contract.setScreen("MarketplaceTip");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "ReturnAfterRecruiting",
			function start()
			{
				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.Contract.m.BigCity.getSprite("selection").Visible = false;
				this.Contract.m.BulletpointsObjectives = [
					"回到%townname%的%employer%处。"
				];
				this.World.State.getPlayer().setAttackable(false);
			}

			function update()
			{
				if (this.World.getTime().Days > 6)
				{
					this.World.State.getPlayer().setAttackable(true);
				}

				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					local tile = this.Contract.getTileToSpawnLocation(this.World.State.getPlayer().getTile(), 6, 10, [
						this.Const.World.TerrainType.Swamp,
						this.Const.World.TerrainType.Forest,
						this.Const.World.TerrainType.LeaveForest,
						this.Const.World.TerrainType.SnowyForest,
						this.Const.World.TerrainType.Shore,
						this.Const.World.TerrainType.Ocean,
						this.Const.World.TerrainType.Mountains
					], false);
					tile.clear();
					this.Contract.m.Location = this.WeakTableRef(this.World.spawnLocation("scripts/entity/world/locations/bandit_hideout_location", tile.Coords));
					this.Contract.m.Location.setResources(0);
					this.Contract.m.Location.setBanner("banner_deserters");
					this.Contract.m.Location.getSprite("location_banner").Visible = false;
					this.Contract.m.Location.setName(this.Flags.get("LocationName"));
					this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).addSettlement(this.Contract.m.Location.get(), false);
					this.Contract.m.Location.setDiscovered(true);
					this.World.uncoverFogOfWar(this.Contract.m.Location.getTile().Pos, 400.0);
					this.Contract.m.Location.clearTroops();
					this.Const.World.Common.addTroop(this.Contract.m.Location, {
						Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW
					}, false);
					this.Const.World.Common.addTroop(this.Contract.m.Location, {
						Type = this.Const.World.Spawn.Troops.BanditThug
					}, false);
					this.Const.World.Common.addTroop(this.Contract.m.Location, {
						Type = this.Const.World.Spawn.Troops.BanditThug
					}, false);

					if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Normal)
					{
						this.Const.World.Common.addTroop(this.Contract.m.Location, {
							Type = this.Const.World.Spawn.Troops.BanditThug
						}, false);
					}

					if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Hard)
					{
						this.Const.World.Common.addTroop(this.Contract.m.Location, {
							Type = this.Const.World.Spawn.Troops.BanditThug
						}, false);
					}

					this.Contract.m.Location.updateStrength();
					this.Contract.setScreen("Briefing");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Finale",
			function start()
			{
				this.Contract.m.Home.getSprite("selection").Visible = false;

				if (this.Contract.m.Location != null && !this.Contract.m.Location.isNull())
				{
					this.Contract.m.Location.getSprite("selection").Visible = true;
				}

				if (this.Contract.m.BigCity != null && !this.Contract.m.BigCity.isNull())
				{
					this.Contract.m.BigCity.getSprite("selection").Visible = false;
				}

				if (this.Contract.m.Location != null && !this.Contract.m.Location.isNull())
				{
					this.Contract.m.Location.setOnCombatWithPlayerCallback(this.onLocationAttacked.bindenv(this));
				}

				this.Contract.m.BulletpointsObjectives = [
					"前往%townname%%direction%方的%location%",
					"击杀%boss%。"
				];
				this.Contract.m.BulletpointsPayment = [
					"事成之后，获得400克朗"
				];
				this.World.State.getPlayer().setAttackable(false);
			}

			function update()
			{
				if (this.World.getTime().Days > 8)
				{
					this.World.State.getPlayer().setAttackable(true);
				}

				if (this.Flags.has("IsHoggartDead") || this.Contract.m.Location == null || this.Contract.m.Location.isNull() || !this.Contract.m.Location.isAlive())
				{
					if (this.Contract.m.Location != null && !this.Contract.m.Location.isNull())
					{
						this.Contract.m.Location.die();
						this.Contract.m.Location = null;
					}

					this.Contract.setScreen("AfterFinale");
					this.World.Contracts.showActiveContract();
				}
			}

			function onLocationAttacked( _dest, _isPlayerAttacking = true )
			{
				local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
				properties.Music = this.Const.Music.BanditTracks;
				properties.BeforeDeploymentCallback = this.onDeployment.bindenv(this);
				this.World.Contracts.startScriptedCombat(properties, true, true, true);
			}

			function onDeployment()
			{
				this.Tactical.getTileSquare(21, 17).removeObject();
				local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/bandit_raider_low", 21, 17 - 21 / 2);
				e.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
				e.setName(this.Flags.get("BossName"));
				e.m.IsGeneratingKillName = false;
				e.getAIAgent().getProperties().BehaviorMult[this.Const.AI.Behavior.ID.Retreat] = 0.0;
				e.getFlags().add("IsFinalBoss", true);
				local items = e.getItems();
				items.equip(this.new("scripts/items/armor/patched_mail_shirt"));
				items.equip(this.new("scripts/items/weapons/falchion"));
				local shield = this.new("scripts/items/shields/wooden_shield");
				shield.setVariant(4);
				items.equip(shield);
				e.getSprite("head").setBrush(this.Flags.get("BossHead"));
				e.getSprite("beard").setBrush(this.Flags.get("BossBeard"));
				e.getSprite("beard_top").setBrush(this.Flags.get("BossBeardTop"));
				e.getSprite("hair").setBrush(this.Flags.get("BossHair"));
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getFlags().get("IsFinalBoss") == true)
				{
					this.Flags.set("IsHoggartDead", true);
					this.updateAchievement("TrialByFire", 1, 1);
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.Contract.m.BigCity.getSprite("selection").Visible = false;
				this.Contract.m.BulletpointsObjectives = [
					"返回%townname%，找%employer%领取报酬"
				];
				this.World.State.getPlayer().setAttackable(false);
			}

			function update()
			{
				if (this.World.getTime().Days > 10)
				{
					this.World.State.getPlayer().setAttackable(true);
				}

				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success");
					this.World.Contracts.showActiveContract();
				}
				else if (!this.Flags.get("IsCampingTipShown") && this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() >= 10.0)
				{
					this.Flags.set("IsCampingTipShown", true);
					this.Contract.setScreen("CampingTip");
					this.World.Contracts.showActiveContract();
				}
			}

		});
	}

	function createScreens()
	{
		this.m.Screens.push({
			ID = "Intro",
			Title = "最后一战",
			Text = "[img]gfx/ui/events/event_21.png[/img]全乱套了。两天前，战团被雇来追踪%boss%和他的掠袭者团队，结果却率先被发现。是埋伏。一支射入某人喉咙的箭让他的马玩笑戛然而止。意料之外的箭矢从四面八方袭来。人们呼喊着，尖叫着，在死前发出巨大的声响。\n\n趁着箭雨减弱之际，你和残存的人一道拔出武器，却只得跪倒在地。一支箭射入了你的身侧。你痛得大叫。匆忙一瞥，只见人们等不及你，就冲上去作困兽之斗，钢铁与钢铁激烈碰撞。\n\n你与队长对视一眼，他在喉咙被割开前最后点了一次头。现在，你指挥着残余的几人。你在痛苦中颤抖着，拄着剑，用你所能鼓起的一切意志慢慢站起来……",
			Image = "",
			List = [],
			Options = [
				{
					Text = "坚持到底！",
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
			ID = "IntroAftermath",
			Title = "结果",
			Text = "[img]gfx/ui/events/event_22.png[/img]你还活着。你们赢了。\n\n肾上腺素逐渐褪去，你控制不住自己的身体，倒在了地面上。你咬紧牙关，折断了箭杆。你的胸膛起伏着，呼吸带痛，一切都变得模糊起来。\n\n战团遭受了重创，只剩下了几个人。霍加特那个混蛋名不虚传，像黄鼠狼一样溜走了。%SPEECH_ON%现在怎么办，队长？%SPEECH_OFF%一个声音在后面说道。 是坐在你边上的%bro2%，他沾满血的斧子被平放在他的腿上。你转向他想要回话，但你还没来得及回答，他就继续说下去。%SPEECH_ON%伯恩哈德死了。他们割断了他的喉咙。他是个好人，也是个相当好的领袖，但一个错误就足以要了他的命。现在你管事了，对吧？%SPEECH_OFF%%bro3%加入了你们的对话，仍然重重的喘着。然后是%bro1%。%SPEECH_ON%把葬礼和涂油留到其他时候吧。让我们好好安葬这些人，回%townname%拿我们的报酬。不管怎样，黄鼠狼的手下们确确实实被杀了。另外，队长，你那伤口也得抓紧处理，等你死了就来不及了。没人想让%bro3%来管事，对吧？%SPEECH_OFF%",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "就这样吧。",
					function getResult()
					{
						this.Contract.setState("ReturnAfterIntro");
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.World.getPlayerRoster().getAll()[1].getImagePath());
				this.Characters.push(this.World.getPlayerRoster().getAll()[0].getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "PaymentAfterIntro1",
			Title = "回%townname%路上",
			Text = "[img]gfx/ui/events/event_79.png[/img]你们回%townname%时的样子，说是闻者伤心见者流泪也不为过。四个运气不好，浑身是血，垂头丧气的雇佣兵。几天前雇佣战团的那个人，%employer%，无疑希望你能以一种更荣耀的方式回来。\n\n尽管如此，他还是欢迎你们去他家做客，拿出了面包和酒，还叫仆人去请了医生。 除了那位双手颤抖的老人在照料你的伤口时，偶尔发出的喘气声以外，他们很少交谈。 一枚针刺入了你的皮肤，而这只是第一针。你咬紧牙关，直到你听到有什么折断了。%employer%坐在你旁边，问你是否解决了霍加特。你摇了摇头。%SPEECH_ON%我们杀了他的人，但黄鼠狼本人终究是从我们刀下逃走了。%SPEECH_OFF%医生挥着一根发光的火棍，表示他想要把它推进你的伤口里。你点头，他便那么做了。只消片刻。你不是一个人，是一团火，火里的血肉，痛苦的傀儡。%employer%递给你一杯酒。%SPEECH_ON%你做的很好，佣兵。强盗被赶跑了，可惜霍加特仍还活着。%SPEECH_OFF%",
			Characters = [],
			ShowEmployer = true,
			List = [],
			Options = [
				{
					Text = "我们希望为此得到报酬。",
					function getResult()
					{
						return "PaymentAfterIntro2";
					}

				}
			],
			function start()
			{
				this.World.Assets.addMoney(400);
				this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "杀了霍加特的人");
			}

		});
		this.m.Screens.push({
			ID = "PaymentAfterIntro2",
			Title = "回%townname%路上",
			Text = "[img]gfx/ui/events/event_79.png[/img]%employer%叹了口气。%SPEECH_ON%好吧，天地良心！400克朗，和约好的一样。%SPEECH_OFF%他冲着一个仆人做了个手势，然后仆人手里拿着报酬跑到了你边上。%SPEECH_ON%我想…我可以再次使用你的服务吗？ 我很想彻底结束霍加特这块心病。当然了，我会再付钱给你们。再加400克朗，谈谈吗？%SPEECH_OFF%%bro2%嗤之以鼻，灌下了更多的酒，但是%bro1% 站起来说道。%SPEECH_ON%没错，战团被毁了，但我们会重建它！没了%companyname%，%bro2%会喝酒花光克朗，流落街头乞讨，还有%bro3%，诸神在上，我们都知道他会跑去追女人，直到头被打烂扔进火炉。我们需要%companyname%，那是我们的全部！你怎么说，队长？%SPEECH_OFF%%bro2%打了个嗝然后向你举起了他的杯子。%bro3%调皮地刮了下鼻子点了点头。%SPEECH_ON%要不要杀了那个混蛋霍加特，你来决定，队长。%SPEECH_OFF%",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "是的，我们和霍加特的事还没完。",
					function getResult()
					{
						return "PaymentAfterIntro3";
					}

				},
				{
					Text = "不，我们会在别的地方找到我们的命运。",
					function getResult()
					{
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Tactical.getEntityByID(this.Contract.m.EmployerID).getImagePath());
				this.Characters.push(this.World.getPlayerRoster().getAll()[0].getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "PaymentAfterIntro3",
			Title = "回%townname%路上",
			Text = "[img]gfx/ui/events/event_79.png[/img]%employer%满意地拍了拍手。%SPEECH_ON%好极了！我的探子找到霍加特的藏身处需要点时间。我建议你们趁着这段时间囤点补给，等到时机到了，好去做个了断。最多几天后见！%SPEECH_OFF%等到你离开%employer%的住宅，走到%townname%郊外以后，%bro1%跟你搭上了话。%SPEECH_ON%我们需要更多的人手，队长。我知道我在那说了不少豪言壮语，但虚张声势没有什么用。我们需要生力军。应该去找三个好小伙，给他们买些像样的武器，穿上手头能买到最好的盔甲。%SPEECH_OFF%他停下来，看了看四周。%SPEECH_ON%我打赌，这个不起眼小镇会有一两个渴望新生活的农民。或者我们可以去%citydirection%边的%bigcity%。那儿的市民没有这里的土包子能吃苦，但有战斗经验的人更愿意在那里休整。%SPEECH_OFF%",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "那正是我们要做的。",
					function getResult()
					{
						this.Contract.setState("Recruit");
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Tactical.getEntityByID(this.Contract.m.EmployerID).getImagePath());
				this.Characters.push(this.World.getPlayerRoster().getAll()[0].getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "MarketplaceTip",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_77.png[/img]当%bigcity%的轮廓出现在地平线上时，%bro3% 找你搭话。%SPEECH_ON%我之前从没去过%bigcity%，但去过很多类似的。这样的城市很适合卖货，这些斤斤计较，傲慢自大的混蛋喜欢让他们的货物流通。商人多了，买不到的东西也就少了。看好便宜货，别被奸商给骗了。%SPEECH_OFF%%bro2%认为有必要对你该做的事提出自己的意见。%SPEECH_ON%如果哪儿有一家好的酒馆，那就是我们最该去的地方。没什么比一品脱酒更能给人带来好运的了。诸神知道，这是我们应得的！%SPEECH_OFF%%bro3%摇了摇头。%SPEECH_ON%哪次进城你不这么说！喝醉了也没个够！%SPEECH_OFF%",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我会记住的。",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				if (this.World.getPlayerRoster().getSize() >= 3)
				{
					this.Characters.push(this.World.getPlayerRoster().getAll()[2].getImagePath());
					this.Characters.push(this.World.getPlayerRoster().getAll()[1].getImagePath());
				}
			}

		});
		this.m.Screens.push({
			ID = "Briefing",
			Title = "大仇未报",
			Text = "[img]gfx/ui/events/event_79.png[/img]你找到他时，%employer%正来回踱步。那个差点用火棍杀了你的医生站在旁边，从指甲里剔着干掉的血块。%employer%拍了拍手。%SPEECH_ON%你总算来了。我有个好消息！ 我们抓住了一个霍加特以前的手下！ 我的朋友和那个人做了一次友好的谈话，现在我知道霍加特在哪舔他的伤口了。%SPEECH_OFF%医生清了清嗓子，像少女涂指甲一样张开了手指，讲话的口气像是要检查恶疾一样。%SPEECH_ON%名为霍加特的强盗正躲在%direction%边%terrain%的一间小屋里。基于我和他一名手下最文明的讨论，霍加特知道%companyname%紧追不舍，一直在召集人手。%SPEECH_OFF%%employer%点着头挥别了你。%SPEECH_ON%祝你好运，佣兵。%SPEECH_OFF%",
			ShowEmployer = true,
			List = [],
			Options = [
				{
					Text = "我们要把他的头带回来！",
					function getResult()
					{
						this.Contract.setState("Finale");
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "AfterFinale",
			Title = "战斗之后",
			Text = "[img]gfx/ui/events/event_87.png[/img]霍加特死在了自己的血泊中，僵在一个丑陋且可怕的姿势。这次他没能逃掉。你一只脚踩在他的尸体上，看着你的人。%SPEECH_ON%为了战团。为了所有死去的同伴。%SPEECH_OFF%%bro3%往那死人脸上吐了口口水。%SPEECH_ON%快割了这混蛋的头，带回%townname%去。%SPEECH_OFF%",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "是时候拿报酬了。",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				if (this.World.getPlayerRoster().getSize() >= 3)
				{
					this.Characters.push(this.World.getPlayerRoster().getAll()[2].getImagePath());
				}
			}

		});
		this.m.Screens.push({
			ID = "CampingTip",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_75.png[/img]%bro3%走到你旁边。%SPEECH_ON%有空吗，队长？%SPEECH_OFF%你点点头，示意他说出自己的想法。%SPEECH_ON%战斗磨损了一些装备，一些人也受了伤。我们可以边行军边疗伤修装备，但扎营做这些会快很多。当然，扎营了就得警惕埋伏。这儿的营火哪儿都能看到。%SPEECH_OFF%",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我会记住的。",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				if (this.World.getPlayerRoster().getSize() >= 3)
				{
					this.Characters.push(this.World.getPlayerRoster().getAll()[2].getImagePath());
				}
			}

		});
		this.m.Screens.push({
			ID = "Success",
			Title = "回%townname%路上",
			Text = "[img]gfx/ui/events/event_24.png[/img]战团作为胜利者回到了%townname%，这次他们的头抬得高多了。%companyname%的规模不及以往，但正如霍加特在最后一刻所学到的那样，他们仍是一支不可小觑的力量。\n\n你把他的头倒在了%employer%脚前。他往后一跳，但医生飞快地捡起了头颅，盯着它，点头。%employer%靠近强盗沾满血的脸仔细地看着。%SPEECH_ON%没错，没错…就是这张丑脸。仆人！付钱给他！%SPEECH_OFF%手里拿着硬币，你高声对人们说。%SPEECH_ON%只要我们的血管里还流动着血液，只要我们还能拿起剑和盾牌，战团就不会倒下。所有人都会知道%companyname%！%SPEECH_OFF%人们欢呼起来。%bro1%把一只手搭在你的肩上。%SPEECH_ON%你做的很棒，队长。 不管你带我们去哪，伙计们都会追随你，作为战场上的兄弟。%SPEECH_OFF%",
			ShowEmployer = true,
			Image = "",
			List = [],
			Options = [
				{
					Text = "浴血同袍！",
					function getResult()
					{
						this.World.Flags.set("IsHoggartDead", true);
						this.Music.setTrackList(this.Const.Music.WorldmapTracks, this.Const.Music.CrossFadeTime, true);
						this.World.Assets.addMoney(400);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "彻底杀死了霍加特");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Music.setTrackList(this.Const.Music.VictoryTracks, this.Const.Music.CrossFadeTime);
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.companion")
					{
						bro.improveMood(1.0, "为战团报了仇");
					}
					else
					{
						bro.improveMood(0.25, "越发相信你的领导能力");
					}
				}

				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]400[/color]克朗"
				});
			}

		});
	}

	function spawnCorpse( _x, _y )
	{
		local tile = this.Tactical.getTileSquare(_x, _y);
		local armors = [
			"bust_body_10_dead",
			"bust_body_13_dead",
			"bust_body_14_dead",
			"bust_body_15_dead",
			"bust_body_19_dead",
			"bust_body_20_dead",
			"bust_body_22_dead",
			"bust_body_23_dead",
			"bust_body_24_dead",
			"bust_body_26_dead"
		];
		local armorSprite = armors[this.Math.rand(0, armors.len() - 1)];
		local flip = this.Math.rand(0, 1) == 1;
		local decal = tile.spawnDetail(armorSprite, this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
		decal.Scale = 0.9;
		decal.setBrightness(0.9);
		decal = tile.spawnDetail("bust_naked_body_01_dead", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
		decal.Scale = 0.9;
		decal.setBrightness(0.9);

		if (this.Math.rand(1, 100) <= 25)
		{
			decal = tile.spawnDetail("bust_body_guts_0" + this.Math.rand(1, 3), this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
			decal.Scale = 0.9;
		}
		else if (this.Math.rand(1, 100) <= 25)
		{
			decal = tile.spawnDetail("bust_head_smashed_01", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
			decal.Scale = 0.9;
		}
		else
		{
			decal = tile.spawnDetail(armorSprite + "_arrows", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
			decal.Scale = 0.9;
		}

		local color = this.Const.HairColors.All[this.Math.rand(0, this.Const.HairColors.All.len() - 1)];
		local hairSprite = "hair_" + color + "_" + this.Const.Hair.AllMale[this.Math.rand(0, this.Const.Hair.AllMale.len() - 1)];
		local beardSprite = "beard_" + color + "_" + this.Const.Beards.All[this.Math.rand(0, this.Const.Beards.All.len() - 1)];
		local headSprite = this.Const.Faces.AllMale[this.Math.rand(0, this.Const.Faces.AllMale.len() - 1)];
		local decal = tile.spawnDetail(headSprite + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
		decal.Scale = 0.9;
		decal.setBrightness(0.9);

		if (this.Math.rand(1, 100) <= 50)
		{
			local decal = tile.spawnDetail(beardSprite + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
			decal.Scale = 0.9;
			decal.setBrightness(0.9);
		}

		if (this.Math.rand(1, 100) <= 90)
		{
			local decal = tile.spawnDetail(hairSprite + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
			decal.Scale = 0.9;
			decal.setBrightness(0.9);
		}

		local pools = this.Math.rand(this.Const.Combat.BloodPoolsAtDeathMin, this.Const.Combat.BloodPoolsAtDeathMax);

		for( local i = 0; i < pools; i = ++i )
		{
			this.Tactical.spawnPoolEffect(this.Const.BloodPoolDecals[this.Const.BloodType.Red][this.Math.rand(0, this.Const.BloodPoolDecals[this.Const.BloodType.Red].len() - 1)], tile, this.Const.BloodPoolTerrainAlpha[tile.Type], 1.0, this.Const.Tactical.DetailFlag.Corpse);
		}

		local corpse = clone this.Const.Corpse;
		corpse.CorpseName = "某人";
		tile.Properties.set("Corpse", corpse);
	}

	function spawnBlood( _x, _y )
	{
		local tile = this.Tactical.getTileSquare(_x, _y);
		tile.spawnDetail(this.Const.BloodDecals[this.Const.BloodType.Red][this.Math.rand(0, this.Const.BloodDecals[this.Const.BloodType.Red].len() - 1)]);
	}

	function spawnArrow( _x, _y )
	{
		local tile = this.Tactical.getTileSquare(_x, _y);
		tile.spawnDetail(this.Const.ProjectileDecals[this.Const.ProjectileType.Arrow][this.Math.rand(0, this.Const.ProjectileDecals[this.Const.ProjectileType.Arrow].len() - 1)], 0, true);
	}

	function onPrepareVariables( _vars )
	{
		local bros = this.World.getPlayerRoster().getAll();
		_vars.push([
			"location",
			this.m.Flags.get("LocationName")
		]);
		_vars.push([
			"bigcity",
			this.m.BigCity.getName()
		]);
		_vars.push([
			"boss",
			this.m.Flags.get("BossName")
		]);
		_vars.push([
			"direction",
			this.m.Location != null && !this.m.Location.isNull() ? this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Location.getTile())] : ""
		]);
		_vars.push([
			"citydirection",
			this.m.BigCity != null && !this.m.BigCity.isNull() ? this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.BigCity.getTile())] : ""
		]);
		_vars.push([
			"terrain",
			this.m.Location != null && !this.m.Location.isNull() ? this.Const.Strings.Terrain[this.m.Location.getTile().Type] : ""
		]);
		_vars.push([
			"bro1",
			bros[0].getName()
		]);
		_vars.push([
			"bro2",
			bros.len() >= 2 ? bros[1].getName() : bros[0].getName()
		]);
		_vars.push([
			"bro3",
			bros.len() >= 3 ? bros[2].getName() : bros[0].getName()
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Location != null && !this.m.Location.isNull())
			{
				this.m.Location.getSprite("selection").Visible = false;
			}

			if (this.m.BigCity != null && !this.m.BigCity.isNull())
			{
				this.m.BigCity.getSprite("selection").Visible = false;
			}

			this.m.Home.getSprite("selection").Visible = false;
			this.World.Ambitions.setDelay(12);
		}

		this.World.State.getPlayer().setAttackable(true);
		this.World.State.m.IsAutosaving = true;
	}

	function onIsValid()
	{
		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Location != null && !this.m.Location.isNull())
		{
			_out.writeU32(this.m.Location.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		if (this.m.BigCity != null && !this.m.BigCity.isNull())
		{
			_out.writeU32(this.m.BigCity.getID());
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
			this.m.Location = this.WeakTableRef(this.World.getEntityByID(location));
		}

		local bigCity = _in.readU32();

		if (bigCity != 0)
		{
			this.m.BigCity = this.WeakTableRef(this.World.getEntityByID(bigCity));
		}

		this.contract.onDeserialize(_in);
	}

});
