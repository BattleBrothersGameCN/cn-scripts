this.destroy_orc_camp_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		Reward = 0
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.destroy_orc_camp";
		this.m.Name = "摧毁兽人营地";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		local camp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(this.m.Origin.getTile());
		this.m.Destination = this.WeakTableRef(camp);
		this.m.Flags.set("DestinationName", this.m.Destination.getName());
		this.m.Payment.Pool = 900 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
		local r = this.Math.rand(1, 3);

		if (r == 1)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else if (r == 2)
		{
			this.m.Payment.Completion = 1.0;
		}
		else if (r == 3)
		{
			this.m.Payment.Completion = 0.5;
			this.m.Payment.Count = 0.5;
		}

		local maximumHeads = [
			20,
			25,
			30
		];
		this.m.Payment.MaxCount = maximumHeads[this.Math.rand(0, maximumHeads.len() - 1)];
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"摧毁" + this.Flags.get("DestinationName") + " %origin%%direction%边的兽人"
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
				this.Contract.m.Destination.clearTroops();
				this.Contract.m.Destination.setLastSpawnTimeToNow();

				if (this.Contract.getDifficultyMult() < 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.OrcRaiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setLootScaleBasedOnResources(115 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				this.Flags.set("HeadsCollected", 0);

				if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().get("Betrayed") && this.Math.rand(1, 100) <= 75)
				{
					this.Flags.set("IsBetrayal", true);
				}
				else
				{
					local r = this.Math.rand(1, 100);

					if (r <= 5)
					{
						this.Flags.set("IsSurvivor", true);
					}
					else if (r <= 15 && this.World.Assets.getBusinessReputation() > 800)
					{
						if (this.Contract.getDifficultyMult() >= 0.95)
						{
							this.Flags.set("IsOrcsAgainstOrcs", true);
						}
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
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsSurvivor") && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
					{
						this.Contract.setScreen("Volunteer1");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Return");
					}
					else if (this.Flags.get("IsBetrayal"))
					{
						if (this.Flags.get("IsBetrayalDone"))
						{
							this.Contract.setScreen("Betrayal2");
							this.World.Contracts.showActiveContract();
						}
						else
						{
							this.Contract.setScreen("Betrayal1");
							this.World.Contracts.showActiveContract();
						}
					}
					else
					{
						this.Contract.setScreen("SearchingTheCamp");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Return");
					}
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (this.Flags.get("IsOrcsAgainstOrcs"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("OrcsAgainstOrcs");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "OrcAttack";
						p.Music = this.Const.Music.OrcsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						p.IsAutoAssigningBases = false;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.OrcRaiders, 150 * this.Contract.getScaledDifficultyMult(), this.Const.Faction.Enemy);
						this.World.Contracts.startScriptedCombat(p, false, true, true);
					}
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "OrcAttack";
					p.Music = this.Const.Music.OrcsTracks;
					this.World.Contracts.startScriptedCombat(p, true, true, true);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Betrayal")
				{
					this.Flags.set("IsBetrayalDone", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Betrayal")
				{
					this.Flags.set("IsBetrayalDone", true);
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_combatID == "OrcAttack" || this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull() && this.World.State.getPlayer().getTile().getDistanceTo(this.Contract.m.Destination.getTile()) <= 1)
				{
					if (_actor.getFaction() == this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getID())
					{
						this.Flags.set("HeadsCollected", this.Flags.get("HeadsCollected") + 1);
					}
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
		this.importScreens(this.Const.Contracts.NegotiationPerHead);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "谈判",
			Text = "[img]gfx/ui/events/event_61.png[/img]{%employer%怒气冲冲地喘着粗气。%SPEECH_ON%真该死。%SPEECH_OFF%他走到窗边向外望去。%SPEECH_ON%我最近办了场骑士比武，出了点争议。现在我的骑士们都不肯为我效力，除非这事解决。%SPEECH_OFF%你问他是否要雇佣兵来解决贵族纠纷。这人大笑起来。%SPEECH_ON%诸神在上，当然不是，平民。我需要你处理一群在%origin%%direction%边扎营的绿皮。它们祸害这片地区有段时间了，我要你以牙还牙。这差事你感兴趣吗？还是我得另找其他佣兵？%SPEECH_OFF% | %employer%把脚架在桌上。%SPEECH_ON%对绿皮有什么看法吗，佣兵？%SPEECH_OFF%你摇头表示没有。这人歪着头。%SPEECH_ON%有意思。多数人会说害怕他们，或者说那是能把人劈成两半的恶心蛮子。但你……你不一样。我很欣赏。不如你去%origin%%direction%方向那个被当地人称为%location%的地方？我们发现了大批兽人在那里聚集，需要把它们驱散。%SPEECH_OFF% | 一只猫趴在%employer%的桌上。他抚摸着，那猫儿正惬意地弓背享受抓挠，却突然嘶叫一声咬了他，从你刚进来的门窜了出去。%employer%掸了掸衣服。%SPEECH_ON%该死的畜生。前一刻还对你百般依恋，后一刻就……%SPEECH_OFF%他吮吸着拇指渗出的血珠。你问是否要给他点时间处理伤口。%SPEECH_ON%真幽默啊，佣兵。不用，我要你做的是去%origin%%direction%边对付盘踞在那片地区的绿皮。我们需要它们被消灭、驱散，随你怎么形容，只要它们‘消失’。这听起来像你能为我们办到的事吗？%SPEECH_OFF% | %employer%一边卷起卷轴一边解释他的困境。%SPEECH_ON%贵族间的纷争让我缺少善战的士兵。不幸的是，一伙绿皮偏偏选在这个时候闯入此地。它们在%origin%%direction%边扎了营。我无法在整顿内务的同时应付这些该死玩意的袭击，所以非常希望这任务能引起你的兴趣，雇佣兵……%SPEECH_OFF% | %employer%上下打量着你。%SPEECH_ON%你这身板够对付绿皮吗？你的手下呢？%SPEECH_OFF%你点头装作这事不过像从树上救猫一样轻松。%employer%笑了。%SPEECH_ON%很好，因为我发现整整一大群出现在%origin%%direction%边。去那里消灭它们。够简单吧？这肯定能引起你这种……自信之人的兴趣。%SPEECH_OFF% | %employer%正在喂狗，给每只都分了些农民会为之拼命的肉食。他拍掉手上的油腻。%SPEECH_ON%我的厨子做的，信吗？难吃。令人作呕。%SPEECH_OFF%你点头附和，仿佛能理解这个把上好食物喂狗当常态的人活在什么世界。%employer%把胳膊肘支在桌上。%SPEECH_ON%总之，给我们送肉的人报告说绿皮在宰他们的牛。在%origin%%direction%边发现了个营地。如果你有兴趣，我想请你去那里把它们全灭了。%SPEECH_OFF% | 你看到%employer%正埋头查看几份卷轴。他抬眼瞥见你，示意就座。%SPEECH_ON%很高兴你来了，雇佣兵。我这儿有绿皮的问题——它们在这里%direction%方向的地方扎了营。%SPEECH_OFF%他放下其中一份卷轴。%SPEECH_ON%而我派不起自己的人手。骑士可是……损失不起的。但你，正适合这活儿。意下如何？%SPEECH_OFF% | 你走进%employer%的办公室时，一群人正离开。他们是骑士，衣袍下传来剑鞘碰撞的轻响。%employer%迎你进来。%SPEECH_ON%别管他们。他们只是好奇我上次雇的人怎么了。%SPEECH_OFF%你挑起眉毛。这人挥挥手。%SPEECH_ON%哦别跟我来这套，佣兵。你跟我一样懂这行当，有时候你们的人失手了，你知道那意味着……%SPEECH_OFF%你沉默不语，停顿片刻后点了点头。%SPEECH_ON%很好，很高兴你明白。想知道的话，在%origin%%direction%边有绿皮。它们建了个营地，我猜自从我上次，呃，派了些人去那儿之后就没挪过窝。有兴趣替我端了它们吗？%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{对抗兽人可不便宜。 | 想必你出价不低。 | 谈谈价钱吧。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{这事不划算。 | 我们还有其他任务。}",
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
			ID = "OrcsAgainstOrcs",
			Title = "在攻击前……",
			Text = "[img]gfx/ui/events/event_49.png[/img]{你刚下令进攻，队员们却发现一群兽人正在……自相残杀？这些绿皮似乎分裂成了两派，正用将对方劈成两半的方式解决分歧。血腥的暴力场面令人作呕。当你正打算坐山观虎斗时，两个兽人打着打着就冲到了你们面前，转眼间所有兽人都盯上了你们。好吧，现在想跑也晚了……准备战斗！ | 你命令%companyname%发起进攻，自以为对兽人占了先机。可它们早已严阵以待！而且……正在自相残杀？\n\n一个兽人把同类劈成两段，另一个则砸碎了同族的脑袋。这似乎是部落内讧。真该多等会儿让这些蛮子自己解决矛盾，现在倒好，变成大混战了！ | 兽人正在自相残杀！这场绿皮内讧如今把你们也卷了进来。兽人对兽人对人类，真是难得一见的场面！让队员们保持紧密阵型，或许还能从这场混战中活着出去。 | 诸神在上，兽人的数量远超想象！幸好它们正在自相残杀。不知这是部落纷争还是绿皮特色的酒后斗殴。无论如何，你们已经深陷其中了！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Betrayal1",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_78.png[/img]{你刚解决掉最后一只兽人，突然出现一队全副武装的人马。他们的指挥官拇指勾着佩剑腰带走上前来。%SPEECH_ON%啧啧，你们还真是蠢得可以。%employer%可不是健忘的人——他可没忘记你们上次的背叛。就当这是……一点小小的回礼。%SPEECH_OFF%话音刚落，他身后的士兵突然发起冲锋。抄起武器，我们中埋伏了！ | 你正擦拭剑上的兽人血迹，突然发现一队人马逼近。他们打着%employer%的旗帜，正在拔出武器。当对方发起冲锋时，你才恍然大悟中了圈套。这帮杂种专门让兽人先消耗你们！给他们点颜色看看！ | 有个装备精良的男人不知从哪儿冒出来打招呼。他装备精良，盔甲齐全，而且显然心情颇佳，在走近时露出狡黠的咧嘴笑。%SPEECH_ON%晚上好，雇佣兵。对付那些绿皮干得漂亮啊？%SPEECH_OFF%他停顿片刻，收起笑容。%SPEECH_ON%%employer%向你们问好。%SPEECH_OFF%就在这时，一群人从道路两侧涌出。是埋伏！那个该死的贵族背刺了你们！ | 战斗才刚刚结束，一队身着%faction%纹章颜色的武装人员出现在你们后方，呈扇形包围了战团。他们的首领打量着你们。%SPEECH_ON%我很期待从你冰冷僵硬的手里把这把剑撬出来。%SPEECH_OFF%你耸肩问为什么设局。%SPEECH_ON%%employer%从不会忘记背叛他或家族的人。知道这点就够了。反正你们很快就是死人了。%SPEECH_OFF%准备迎战吧，我们中了埋伏！ | 队员们搜遍兽人营地却空无一人。突然，身着%faction%颜色制服的士兵从背后出现，带队的指挥官神情恶劣地走上前来，胸前绣着%employer%的徽章。%SPEECH_ON%可惜那些绿皮没把你们解决掉。如果你们想知道的话，我是来替%employer%收债的。你们承诺过会完成任务。既然当时没能履约，现在就拿命抵债吧。%SPEECH_OFF%你拔剑出鞘，寒光直指对方。%SPEECH_ON%看来%employer%又要被爽约了。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationBetrayal);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().set("Betrayed", false);
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "Betrayal";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 140 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Betrayal2",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_22.png[/img]{你在裤腿上擦拭剑刃后迅速收剑入鞘。伏击者的尸体以各种怪异姿态倒毙在地。%randombrother%上前询问下一步行动。看来%faction%往后不会与我们友好相处了。 | 你将伏击者的尸体从剑尖踢落。看来从今往后%faction%不会对我们太友善。或许下次答应为这些人办事时，最好说到做到。 | 好吧，至少这次教训告诉我们：别承诺自己做不到的事。这片土地上的人们对失信之徒可不会客气…… | 你确实背叛过%faction%，但往事不必再提。现在重要的是他们背叛了你！从今往后，最好对这群人及其麾下势力都保持警惕。 | 从脚下士兵的尸体来看，%employer%显然对你不再满意。若要说原因，无非是往日旧账——背信弃义、任务失败、出言顶撞，还是睡了贵族女儿？细想之下桩桩件件都涌入脑海。重要的是你们之间的裂痕难以弥合，最近最好提防着点%faction%的人。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "没薪水领了……",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SearchingTheCamp",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_32.png[/img]{战斗结束后，你搜查了兽人营地。在废墟中发现了看似重甲和人类武器的残骸，但都已无法使用。遗憾的是，未能寻获它们可能曾经的主人。 | 兽人伏诛后，你环顾它们的营地。遍地都是污物，名副其实的污秽横流。这些该死的东西根本不知洁净为何物。%randombrother%深一脚浅一脚地走来，在帐篷柱上蹭着靴子。%SPEECH_ON%长官，我们是继续前进还是再搜搜……？%SPEECH_OFF%你已看够，也闻够了。 | 兽人营地是片充斥各种堕落的荒芜之地。空气中弥漫着交媾与排泄的气味。难怪它们如此好战，对最基本的文明都一无所知。 | 兽人营地已被摧毁，你仍花时间翻检废墟。在篝火的灰烬坑里发现了几具人类尸体。从装备判断，他们应是和你一样的佣兵。可惜……所有物品都已烧毁，再无利用价值。 | 几名佣兵穿梭在兽人营地的废墟中。他们翻捡残骸，偶尔拾起些无用的零碎物件。%randombrother%将染血的长剑归鞘。%SPEECH_ON%这儿一无所获，长官。%SPEECH_OFF%你点头示意，让队员们准备返回%employer%处。 | 战斗结束后，你在营地中漫步搜寻可用之物。虽然未找到可用的物资，却撞见一堆骑士的尸体。他们苍白的面容已满是蠕动的蛆虫，显然陈尸已久。天知道兽人对他们做了些什么。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "是时候领工钱了。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Volunteer1",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_32.png[/img]{战斗已经结束，但仍然有人在叫喊。你让%randombrother%闭嘴，因为他偶尔会莫名低吼或叫喊，但他摇头说不是自己。就在这时，一个戴镣铐的男人从兽人营地的废墟里站了起来。%SPEECH_ON%晚上好，先生们！我相信是你们解救了我。%SPEECH_OFF%他踉跄走来，身后旋起幽灵般的扭曲烟尘。%SPEECH_ON%我万分感激，想报答这份恩情。你们是雇佣兵对吧？如果是的话，我愿为你们而战。%SPEECH_OFF%他从地上拾起一把刀在手中旋转，舞动得如同自幼相伴的佩剑。这有趣的提议变得愈发诱人了…… | 你正擦拭剑刃时，倒塌的兽人帐篷里传来人声。%SPEECH_ON%先生们，你们做到了！%SPEECH_OFF%只见一个笑容满面的男人钻了出来。%SPEECH_ON%你们救了我！我助你一臂之力以作回报！%SPEECH_OFF%他伸出手又迟疑地收回。%SPEECH_ON%我是说为你们而战！长官，我愿为你效力！既然各位能有扫荡兽人的本事，我跟着你们准没错吧？%SPEECH_OFF%嗯，有意思的提议。你抛给他武器，他轻松接住，反手转动柄部，又尝试收剑入虚无的剑鞘。%SPEECH_ON%我叫%dude_name%。%SPEECH_OFF% | 一个穿着破旧凹陷盔甲的男人朝你奔来，双臂反绑在身后。%SPEECH_ON%你们成功了！真难以置信！抱歉，请允许我解释这失态举止。一天前我们攻打营地时被兽人俘虏，他们正要把我串上烤叉时各位就出现了。我抓住机会逃脱，但现在看来你的队伍值得投效。%SPEECH_OFF%你让他直奔主题。他照做了。%SPEECH_ON%长官，我愿为你战。我有经验——待过领主军队，当过佣兵，还干过……其他行当。%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "欢迎加入战团！",
					function getResult()
					{
						this.World.getPlayerRoster().add(this.Contract.m.Dude);
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude.onHired();
						this.Contract.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "你得到别处去碰碰运气了。",
					function getResult()
					{
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude = null;
						return 0;
					}

				}
			],
			function start()
			{
				local roster = this.World.getTemporaryRoster();
				this.Contract.m.Dude = roster.create("scripts/entity/tactical/player");
				this.Contract.m.Dude.setStartValuesEx(this.Const.CharacterVeteranBackgrounds);

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).setArmor(this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).getArmor() * 0.33);
				}

				if (this.Contract.m.Dude.getTitle() == "")
				{
					this.Contract.m.Dude.setTitle("幸存者");
				}

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{你回到%employer%处汇报情况。他挥手打断你。%SPEECH_ON%得了吧佣兵，我早知道了。你以为我在这片地界没安插眼线吗？%SPEECH_OFF%他指向桌角的钱袋。你刚拿起钱袋，这人就甩了甩手腕。%SPEECH_ON%这应该足够酬谢你们了，现在请离开我的视线。%SPEECH_OFF% | 你将一颗兽人首级展示给%employer%。他盯着首级，又看向你。%SPEECH_ON%有意思。那我是否可以认为你已完成嘱托？%SPEECH_OFF%你点头回应。这人微笑着递来装有%reward%克朗的木箱。%SPEECH_ON%我就知道你值得信赖，佣兵。%SPEECH_OFF% | 你归来时%employer%凝视着你。%SPEECH_ON%我已经听说了你干的好事。%SPEECH_OFF%他古怪的语调让你迅速回顾过去一周的行踪。那位贵族女子难道……不，不可能。%SPEECH_ON%兽人死了。干得漂亮，雇佣兵。%SPEECH_OFF%他滑给你一袋%reward%克朗，你顿时松了口气。 | 你走进%employer%的房间自斟一杯酒。贵族死死瞪着你。%SPEECH_ON%要我说，你这行径就该判死刑，心情好就绞死，不好就火刑。%SPEECH_OFF%你饮尽酒后将兽人首级砸在桌上，酒杯晃动着滚落。%employer%惊退半步，随即镇定下来。%SPEECH_ON%啊，这杯酒你确实该喝。反正也不是我最好的藏酒。%randomname%我的护卫在门外等你，他会交付约定的%reward%克朗。%SPEECH_OFF% | 你举起兽人首级向%employer%展示。绿色的下颌耷拉着，舌头在獠牙般的齿间垂荡。%employer%点点头挥了挥手。%SPEECH_ON%行行好，为我的梦境着想，快拿开。%SPEECH_OFF%你照做后，这人摇头叹息。%SPEECH_ON%整天看着这些玩意儿我还怎么睡觉？算了，%reward%克朗在门外的护卫手里。辛苦了，佣兵。%SPEECH_OFF% | 你来到%employer%房间时，他正端详卷轴上的画作。他盯着你，纸缘向后卷曲。%SPEECH_ON%我女儿自以为是个画家，信么？%SPEECH_OFF%他向你展示卷轴——画功不俗，人物酷似%employer%，正面对着刽子手。%employer%大笑。%SPEECH_ON%傻丫头。%SPEECH_OFF%他揉碎卷轴扔到一旁。%SPEECH_ON%总之我的探子已经汇报了你的成功。这是约定好的报酬。%SPEECH_OFF%}",
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
						this.World.Assets.addMoney(this.Contract.m.Reward);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "摧毁了兽人的营地");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isGreenskinInvasion())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
						}

						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() + this.Flags.get("HeadsCollected") * this.Contract.m.Payment.getPerCount();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color]克朗"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Origin, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"location",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.m.Destination.getName()
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.m.Origin.getTile().getDirection8To(this.m.Destination.getTile())]
		]);
		_vars.push([
			"dude_name",
			this.m.Dude == null ? "" : this.m.Dude.getNameOnly()
		]);
		_vars.push([
			"reward",
			this.m.Reward
		]);
	}

	function onOriginSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Origin.addSituation(this.new("scripts/entity/world/settlements/situations/greenskins_situation"));
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

			this.m.Home.getSprite("selection").Visible = false;
		}

		if (this.m.Origin != null && !this.m.Origin.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Origin.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(4);
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

			if (this.m.Origin.getOwner().getID() != this.m.Faction)
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

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		this.contract.onDeserialize(_in);
	}

});
