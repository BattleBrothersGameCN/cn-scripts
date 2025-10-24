this.restore_location_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Caravan = null,
		Location = null,
		IsEscortUpdated = false
	},
	function setLocation( _l )
	{
		this.m.Location = this.WeakTableRef(_l);
	}

	function create()
	{
		this.contract.create();
		this.m.DifficultyMult = this.Math.rand(70, 90) * 0.01;
		this.m.Type = "contract.restore_location";
		this.m.Name = "重建工作";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 300 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"肃清%townname%附近的废墟%location%"
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

				if (r <= 15)
				{
					this.Flags.set("IsEmpty", true);
				}
				else if (r <= 30)
				{
					this.Flags.set("IsRefugees", true);
				}
				else if (r <= 60)
				{
					this.Flags.set("IsSpiders", true);
				}
				else
				{
					this.Flags.set("IsBandits", true);
				}

				this.Contract.m.Home.setLastSpawnTimeToNow();
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"肃清%townname%附近的废墟%location%"
				];
				this.Contract.m.Location.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Location))
				{
					if (this.Flags.get("IsVictory"))
					{
						this.Contract.setScreen("Victory");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("ReturnForEscort");
					}
					else if (this.Flags.get("IsFleeing"))
					{
						this.Contract.setScreen("Failure2");
						this.World.Contracts.showActiveContract();
						return;
					}
					else if (this.Flags.get("IsEmpty"))
					{
						this.Contract.setScreen("Empty");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsRefugees"))
					{
						this.Contract.setScreen("Refugees1");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsSpiders"))
					{
						this.Contract.setScreen("Spiders");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsBandits"))
					{
						this.Contract.setScreen("Bandits");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "RestoreLocationContract")
				{
					this.Flags.set("IsVictory", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "RestoreLocationContract")
				{
					this.Flags.set("IsFleeing", true);
				}
			}

		});
		this.m.States.push({
			ID = "ReturnForEscort",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"返回%townname%"
				];
				this.Contract.m.Location.getSprite("selection").Visible = false;
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
		this.m.States.push({
			ID = "Escort",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"护送工人前往%townname%附近的%location%"
				];
				this.Contract.m.Location.getSprite("selection").Visible = true;
				this.Contract.m.Home.getSprite("selection").Visible = false;
			}

			function update()
			{
				if (this.Contract.m.Caravan == null || this.Contract.m.Caravan.isNull() || !this.Contract.m.Caravan.isAlive() || this.Contract.m.Caravan.getTroops().len() == 0)
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (!this.Contract.m.IsEscortUpdated)
				{
					this.World.State.setEscortedEntity(this.Contract.m.Caravan);
					this.Contract.m.IsEscortUpdated = true;
				}

				this.World.State.setCampingAllowed(false);
				this.World.State.getPlayer().setPos(this.Contract.m.Caravan.getPos());
				this.World.State.getPlayer().setVisible(false);
				this.World.Assets.setUseProvisions(false);
				this.World.getCamera().moveTo(this.World.State.getPlayer());

				if (!this.World.State.isPaused())
				{
					this.World.setSpeedMult(this.Const.World.SpeedSettings.EscortMult);
				}

				this.World.State.m.LastWorldSpeedMult = this.Const.World.SpeedSettings.EscortMult;

				if (this.Flags.get("IsFleeing"))
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
					return;
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Location))
				{
					this.Contract.setScreen("RebuildingLocation");
					this.World.Contracts.showActiveContract();
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Flags.set("IsFleeing", true);

				if (this.Contract.m.Caravan != null && !this.Contract.m.Caravan.isNull())
				{
					this.Contract.m.Caravan.die();
					this.Contract.m.Caravan = null;
				}
			}

			function end()
			{
				this.World.State.setCampingAllowed(true);
				this.World.State.setEscortedEntity(null);
				this.World.State.getPlayer().setVisible(true);
				this.World.Assets.setUseProvisions(true);

				if (!this.World.State.isPaused())
				{
					this.World.setSpeedMult(1.0);
				}

				this.World.State.m.LastWorldSpeedMult = 1.0;
				this.Contract.clearSpawnedUnits();
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"返回%townname%"
				];
				this.Contract.m.Location.getSprite("selection").Visible = false;
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success2");
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer%拿出些面包和啤酒款待，自己似乎也乐得享用。闲聊几句你对%townname%的看法后，他切入正题。%SPEECH_ON%这片区域曾经繁荣过，但我们的许多资产都遭到强盗洗劫、焚毁或占领。需要你前往%townname%外的%location%，清除那里的所有占据者，这样我们才能安全运送物资，让工匠重建我们曾经拥有的一切。%SPEECH_OFF%他俯身撑桌，坚定地注视着你。%SPEECH_ON%你愿意协助我们完成这项任务吗？%SPEECH_OFF% | %employer%咬了口苹果，把剩下的抛给你。接住后，你看着这人，不太确定他的用意。见他沉默不语，你便咬了一口扔回去，并向他道谢。%SPEECH_ON%不客气，佣兵。今天天气不错，不过嘛，显然我另有他事相求。%townname%外的%location%据信窝藏着一伙强盗。你只需去那里清剿干净，让我能把这地方恢复往日的清净模样。这符合你的……利益吗？%SPEECH_OFF% | %employer%叹着气任由一卷文书从指间滑落，仿佛其中的消息沉重到难以承受。%SPEECH_ON%我们从%townname%收取的克朗不够，我认为这可能是因为强盗占领了%location%。虽然尚未完全证实……我确实该更关注子民的消息，但你也明白情况。%SPEECH_OFF%你耸了耸肩。%SPEECH_ON%总之，我要你去那里查明问题，然后回来向我汇报以便进一步指示。听起来很简单，对吧？%SPEECH_OFF% | %employer%从椅子里探身向前，指向摊在桌案的地图。%SPEECH_ON%%townname%外的%location%已被强盗摧毁。现在，佣兵，我需要你协助夺回这片领土，帮我重振往日荣光——至少我是这么告诉那些农民的。你有兴趣吗？%SPEECH_OFF% | %employer%长叹一声，气息往前呼出，身体则往后陷进椅子里。%SPEECH_ON%我小时候常去%location%。那曾是个繁荣之地，如今却因一群流寇而沦为废墟。显然，我找你不只是为了怀旧。我需要你去那里夺回控制权！杀掉那些强盗，然后立即向我汇报。这项简单任务能让你提起兴致吗？%SPEECH_OFF% | %employer%把脚架到桌上，碰翻了一只空酒杯。%SPEECH_ON%那些农民又来了。不停地烦我。他们说%townname%外的%location%已被摧毁。我通常不信这些蠢货的话，但我的几位顾问似乎证实了消息。所以现在我得采取行动了。%SPEECH_OFF%他晃着手指指向你，脸上带着笑意。%SPEECH_ON%这就是你出场的时候了。去%location%，杀掉那些无法无天的流寇，然后回来向我汇报。你觉得如何？%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{听起来挺简单。 | 佣金是多少？}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{听起来这活不适合我们。 | 我觉得还是免了吧。}",
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
			ID = "Empty",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_71.png[/img]{抵达%location%后，你让手下散开，缓慢潜入该区域。你亲自前进，小心地穿梭走向那些建筑——阵阵疾风穿过时，窗框发出呼啸声。进一步调查后，这里似乎空无一人。甚至连他们刚离开的迹象都没有。你集结手下，返回向%employer%汇报。 | %location%出人意料地空荡。你在某间房屋内踱步巡视，拾起积尘的杯子，翻动草垫床铺，却既不见虫豸也不见人迹。这地方已被彻底废弃。你动身回去将这个消息告知%employer%。 | 一个驱鹿器在%location%边缘不停点头摇晃，其木制声响是周遭唯一显得有生机的东西。若曾有人居住于此，他们也早已离去多时。建筑空置着，内部已被掏空。仅凭外观就能断定里面空无一人。即便旧神亲自摧毁此地，也不会有人知晓或在意。可悲。最好让%employer%知道这个“好消息”。 | %location%正如你所料已被废弃，但视野内不见强盗或流浪者的踪迹。你无法责怪他们不愿占据此地：尽管仍有几栋建筑立着，但处处都让你感到不安。陈旧、脆弱……闹鬼？仿佛这里曾是无尽罪孽的温床。或许%employer%的工人们会将其拆除并重新建设。 | 在%location%找不到一个强盗。半数的建筑已被摧毁，其余则空置荒废。几个%employer%的工人或许能让此地恢复秩序，所以你最好去通知他。 | 你发现一个风向标陷在泥泞中，旁边还有具牛尸。猪圈里铺满了鲜绿的野草。某栋建筑已被蔓延的藤蔓染成翠绿。墓地的标记歪斜倾倒，有些平躺在地。你找到一把铁锹和旁边的土坑。未使用的墓穴积满了水，蓝色鸟儿正在其中沐浴。你思忖此地是否保持原状更好，但这并非你该考虑的事。你动身回去向%employer%汇报现状。 | 你进入%location%，让手下散开搜查建筑。你不愿将调查完全交给这群佣兵，便亲自走进附近一间民居。门板嘎吱开启，后面是散落一地的锅碗瓢盆。跋涉而入后，你在屋角发现几只死老鼠，它们的骨架仍保持着奔逃姿态，旁边还有一只死猫。椽子上有个鸟巢。发黄的蛋壳顶盖微微闪烁，但你始终未见鸟类踪影，更未闻其鸣叫。\n\n%randombrother%进门报告说一无所获。就算曾有强盗在此，他们也早已离去。你命令这名佣兵集结手下，是时候向%employer%汇报调查结果了。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "这倒是没想到。",
					function getResult()
					{
						this.Contract.setState("ReturnForEscort");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Bandits",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_71.png[/img]{你命令手下在%location%散开搜索。你手握长剑潜行穿过这片区域。刚转过一个拐角，你就发现一个男人正蹲在粪坑上。他看到你时膝盖直打颤。当他伸手去拿武器时，你一剑刺穿了他，迅速将他的尸体从剑刃上踢开，并向手下发出强盗来袭的警告——他们正从附近建筑里蜂拥而出。 | %location%很安静，但还不够安静。四处都能听到木材的吱嘎声，链条移动的叮当响。这里有人。你拔出长剑，命令手下准备战斗。刚下令，一个强盗就踹开建筑大门冲了出来，一群同样叫嚷着的人跟在他身后蜂拥而出。 | 强盗！果然如你所料。他们不仅占据了%location%，还毫不在意自己有多显眼。当你的手下合围该区域时，强盗们懒洋洋地拿起武器，仿佛早就对付过你们这类人似的。 | %location%空无一人——除了占据中央的那一大群强盗，他们正围坐在篝火和一只烤全猪旁。他们瞥了你一眼，回头看看猪，又看向你。其中一个从火边拿起油腻的烤肉叉。%SPEECH_ON%见鬼，先生，我们只想吃点东西。%SPEECH_OFF%你拔出长剑点了点头。%SPEECH_ON%我也是。%SPEECH_OFF% | 你在%location%外发现一个强盗。他正扛着一具农民的尸体，这证据足以让你明白需要杀掉他和他的所有同伙。你命令手下发动攻击。 | 当你靠近%location%时，强盗们纷纷从营火旁匆忙散开。出乎意料的是，他们拿起武器，出来保卫他们新占领的“领地”。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.Music = this.Const.Music.BanditTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "RestoreLocationContract";
						p.TerrainTemplate = "tactical.plains";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.LocationTemplate.Template[0] = "tactical.human_camp";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.None;
						p.LocationTemplate.CutDownTrees = true;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.BanditScouts, 90 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Spiders",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_110.png[/img]{从%location%住宅区随风无力飘荡的白色物质看似烟尘，但建筑却完好无损。当你靠近这些住所时，一对对红色眼瞳在黑暗的窗内骤然亮起。蛛魔蜂拥而出，它们多刺的肢节在木板条上咔嗒作响，刮擦着屋顶，成片的黑色身躯如蒲公英烧烬后的飞絮般从窗框里翻涌而出。 | 你发现%location%已空无一人，但一层丝质白色薄膜如霜般覆盖着此处的每个角落，细丝在风中无力地卷曲。%randombrother%碰了其中一根的末端，那丝线随着他的手臂拉伸，他只得割断才得以脱身。抬头向前望去，你看见蛛魔正朝你们冲来，它们多刺的节肢如剪刀般交错移动，跨越地面的速度快得骇人，饥饿的口器发出咔嗒声响。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.Music = this.Const.Music.BeastsTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "RestoreLocationContract";
						p.TerrainTemplate = "tactical.plains";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Spiders, 90 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Refugees1",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_59.png[/img]{%location%确实挤满了人，但他们不是强盗。难民像流动的垃圾一样堆满此地，寻找着歇脚之处。这些令人不适的男女甚至孩童在场地内怯生生地走动，全都虚弱得无暇顾及眼前的佣兵团。%randombrother%来到你身边询问该如何处理。\n\n如果任由他们留在这里，%employer%会很不高兴，你大概也拿不到报酬。但另一方面……看看这群可怜人吧。他们需要个地方安顿下来。 | 你放下望远镜摇了摇头。难民挤满了——或者该说是侵占了%location%。总比强盗强吧，你这么想，但依然是个问题。%employer%不会乐见他们的存在，这点你很确定。但另一方面，下面那些人……衣衫褴褛……瘦骨嶙峋……疲惫不堪……你也不忍心再把他们赶回路上流浪吧，对吧？ | %randombrother%转身吐了口唾沫。他双手叉腰摇着头。%SPEECH_ON%天杀的。%SPEECH_OFF%站在你和战团成员面前的是一群混杂的难民。大概二三十人。多半是男性。你估计其余的人，妇女和儿童，此刻正躲藏在偏僻地带。这群疲惫的人似乎累得无法与你们真正交流。他们只是互相交换眼神，偶尔顺从地耸耸肩。\n\n一位弟兄在你一侧说道：%SPEECH_ON%如果我们想要%employer%的报酬，就得把他们赶走……%SPEECH_OFF%但这时另一个兄弟从你另一侧插话：%SPEECH_ON%是啊，但看看这些人。真的要把他们赶出去吗？要我说，就让他们留下吧。%SPEECH_OFF% | 难民们占据了%location%，估计是某场残酷战争的幸存者。他们搜刮了该地区的资源，现在似乎已相当扎根于此。你知道%employer%不会高兴他们的存在——他们看起来不像是本地人。%randombrother%来到你身边，朝那群衣衫褴褛的疲惫陌生人点了点头。%SPEECH_ON%我可以带几个人把他们赶走，长官。很简单的。%SPEECH_OFF% |视野内不见强盗踪影。相反，你发现一大群难民占领了%location%。这群疲惫的人们已在此安顿得相当不错：几只炖锅在噼啪作响的篝火上煮着，他们似乎对这个新“家”相当满意。但%employer%绝对不会高兴他们在此。绝对不会。你虽不愿相信，但冷酷的事实是：如果你想拿到报酬，这些人必须离开。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "把这些人赶出去。",
					function getResult()
					{
						return "Refugees2";
					}

				},
				{
					Text = "这些人无处可去。 就……别管他们了。",
					function getResult()
					{
						return "Refugees3";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Refugees2",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_59.png[/img]{你命令手下把难民们赶出去。他们没有怎么反抗——大多只是在抱怨世道残酷。然而你心里只想着能拿到多少报酬。 | 你命令%randombrother%和几个佣兵进去把他们赶走。幸运的是没有发生流血事件，但每个从你面前经过的难民都用肃穆而悲伤的目光看着你。你耸了耸肩。 | 难民们被赶了出去。其中一个像是想对你说什么，但最终还是闭上了嘴。仿佛他记起曾经说过那些想法，在当时毫无作用，现在也不会有什么不同。你享受着他的沉默。 | 你让%randombrother%给难民们分发一些食物。都是些快要变质的东西：要么是硬得像砖头的面包块，要么是揭开盖子就散发着死亡气息的陈年炖菜。难民们接过每件东西的样子，仿佛你给了他们全世界。不过他们并没有道谢。只是点点头，耸耸肩，然后继续前行。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "滚远点，贱民！",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-2);
						this.Contract.setState("ReturnForEscort");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Refugees3",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_59.png[/img]{你任由难民们留在这里。最好别回去见%employer%了，因为他绝不会对此感到满意。 | 男人，女人和孩子看起来受够磨难了。你决定让他们留在这里。 | 这些人已饱尝世间苦难。你觉得他们没法再挺过一次流浪，于是决定让他们留在已安顿下来的地方。 | 这些饱经风霜、受尽磨难的人不该被从此地赶走。你打算随他们去。他们很快就能把这里变成可居住的区域，尽管%employer%不会乐意于看到自己的人没法进驻此地。 | %employer%想让自己的人在此定居，但你觉得是这群人先来的。况且，他们要是再被赶到荒野里的话，估计活不了多久。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们会在别的地方找到工作的……",
					function getResult()
					{
						this.World.Assets.addMoralReputation(2);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "没能肃清破败的" + this.Contract.m.Location.getRealName());
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_71.png[/img]{战斗已经结束，%location%已肃清。是时候返回%employer%那里了。 | 你检视着战场点了点头，庆幸自己肩上还有个脑袋可以点头。该回去见%employer%了。 | 战斗相当激烈，你集结了手下，准备返回%employer%处。 | 战斗结束后，你评估着现场情况，思索着后续如何报告。%employer%肯定会想了解这里发生的一切。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "已经解决了。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "RebuildingLocation",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_71.png[/img]{你返回%location%，看着工人们分散到各栋建筑中。他们开始工作，堆积木板，架起支撑梁，其中一队人正在为自己挖掘水井。看来现在可以回去见%employer%了。 | 建筑工人们感谢你将他们平安送达%location%。随后他们转身开始工作，分散在场地各处，随手拿起身边的工具忙碌起来。当你动身返回%employer%时，身后回荡着锤锯交错的嗡鸣嘶响。 | 大多数建筑工人进入%location%并开始重建的准备工作。工头感谢你确保他们安全抵达，因为他深知这个世界的危险。他还感谢你没有出卖他们。你带着一丝苦笑接受这番感激，随后启程返回%employer%。 | 好了，工人们已平安抵达。你转身踏上归途，返回%employer%那里领取你应得的报酬。 | 这趟旅程漫长无比，来回往返，但现在%location%似乎即将重新站稳脚跟。在确认工人们安全无虞后，你动身返回%employer%处领取酬金。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "是时候去拿报酬了。",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_98.png[/img]{%employer%在你进门时瞥了你一眼。%SPEECH_ON%那么清理干净了吗？%SPEECH_OFF%你点点头。%employer%起身下达指令：你需要带领一队建筑工人返回%location%，以便他们进行重建。 | %employer%听着你的汇报并点了点头。%SPEECH_ON%我有一批人要返回%location%进行重建。你需要护送他们。明白了吗？很好。%SPEECH_OFF% | %employer%卷起几卷文书，向你下达下一步指令。%SPEECH_ON%我有一伙人要回去重建那个地方。这里头投入了不少克朗，所以我需要你确保那些人能完好无损地抵达。之后再回来领取你的报酬。%SPEECH_OFF% | %employer%看到你之后向后靠坐。小口啜饮一杯蛇酒。%SPEECH_ON%有消息了？%SPEECH_OFF%你告诉他区域已肃清。这人将剩下的酒一饮而尽，放下杯子。%SPEECH_ON%很好……很好。现在带我一伙工人回去协助重建。等他们完工后，回来领你的酬金。%SPEECH_OFF% | %employer%在你进门时向后靠坐。%SPEECH_ON%你既然回来了，我想%location%已经清理完毕了，对吗？%SPEECH_OFF%你确认了他想听到的消息。他似乎很高兴，但你的任务尚未结束：%employer%要你带一伙工人返回该地区协助重建和重新安置。等他们安全抵达后，回来找他领取报酬。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "这应该要不了多久。",
					function getResult()
					{
						this.Contract.spawnCaravan();
						this.Contract.setState("Escort");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_63.png[/img]{%employer%用一沉甸甸的克朗钱袋迎接你的归来。他摆手示意你离开，几乎没感谢你的工作。不过，去他的吧，去他的繁文缛节。一袋克朗就是最好的感谢。 | 你进入%employer%的住所，他招手让你过去。他的一名手下递给你一大袋克朗。你看着那人。%SPEECH_ON%你怎么知道他们到了？%SPEECH_OFF%%employer%腼腆地笑了笑。%SPEECH_ON%在这一带我有许多眼线。连鸟儿都会向我传话……%SPEECH_OFF%这个解释已经足够了。 | 回到%employer%那里，你汇报说%location%的修复工作进展顺利。他向你道谢。%SPEECH_ON%呵，瞧瞧看？一个信守承诺、完成工作的佣兵。真是难得。这是你的报酬。%SPEECH_OFF%他的一名手下递给你一个粗麻布袋，沉甸甸的，里面的克朗让袋子棱角分明。%employer%抬手致意。%SPEECH_ON%后会有期，佣兵。%SPEECH_OFF% | 你返回时%employer%正在书房里。他向你展示一卷文书，问你是否知道这是什么。你耸耸肩。%SPEECH_ON%我没什么学问。至少不会认字。%SPEECH_OFF%%employer%也耸了耸肩。%SPEECH_ON%真可惜。但你是遵守承诺的人，相信我，如今的世道这很难得。你的报酬在角落那里。%SPEECH_OFF%报酬就在他所说的地方。你无意拘泥客套，拿起钱袋便告辞离去。 | %employer%向后靠坐，神情颇为自得。%SPEECH_ON%我知道怎么挑人。我是说，挑佣兵。我那些同行大多也雇你们这路人，但总搞砸，因为他们根本不知道如何从蛛丝马迹判断人的好坏。但你……我第一眼见到你就知道你这人靠谱。你的报酬，佣兵……%SPEECH_OFF%他将一袋克朗重重放在桌上。%SPEECH_ON%全在这儿了，不过你想数的话我也理解。%SPEECH_OFF%你确实数了——分文不差。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "这钱好挣。",
					function getResult()
					{
						this.Contract.m.Location.setActive(true);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "帮助重建" + this.Contract.m.Location.getRealName());
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
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "战斗之后",
			Text = "[img]gfx/ui/events/event_60.png[/img]{建筑队已然被毁，重建%location%的任何希望都已破灭。至少目前如此。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "该死！",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "未能保护好建筑队");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Failure2",
			Title = "战斗之后",
			Text = "[img]gfx/ui/events/event_71.png[/img]{你的手下未能成功肃清%location%，因此你不必指望获得任何报酬。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "该死！",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "没能保护好" + this.Contract.m.Location.getName());
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function spawnCaravan()
	{
		local faction = this.World.FactionManager.getFaction(this.getFaction());
		local party = faction.spawnEntity(this.m.Home.getTile(), "工人车队", false, this.Const.World.Spawn.CaravanEscort, this.m.Home.getResources() * 0.4, this.getMinibossModifier());
		party.getSprite("banner").Visible = false;
		party.getSprite("base").Visible = false;
		party.setMirrored(true);
		party.setDescription("一支携带建筑材料的建筑工车队，来自" + this.m.Home.getName() + ".");
		party.setFootprintType(this.Const.World.FootprintsType.Caravan);
		party.setMovementSpeed(this.Const.World.MovementSettings.Speed * 0.5);
		party.setLeaveFootprints(false);
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(this.m.Location.getTile());
		move.setRoadsOnly(false);
		local despawn = this.new("scripts/ai/world/orders/despawn_order");
		c.addOrder(move);
		c.addOrder(despawn);
		this.m.Caravan = this.WeakTableRef(party);
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"location",
			this.m.Location.getRealName()
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.World.State.setCampingAllowed(true);
			this.World.State.setEscortedEntity(null);
			this.World.State.getPlayer().setVisible(true);
			this.World.Assets.setUseProvisions(true);

			if (!this.World.State.isPaused())
			{
				this.World.setSpeedMult(1.0);
			}

			this.World.State.m.LastWorldSpeedMult = 1.0;

			if (this.m.Location != null && !this.m.Location.isNull())
			{
				this.m.Location.getSprite("selection").Visible = false;
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (this.m.Location == null || this.m.Location.isActive() || !this.m.Location.isUsable())
		{
			return false;
		}

		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Caravan != null && !this.m.Caravan.isNull())
		{
			_out.writeU32(this.m.Caravan.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		if (this.m.Location != null && !this.m.Location.isNull())
		{
			_out.writeU32(this.m.Location.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local caravan = _in.readU32();

		if (caravan != 0)
		{
			this.m.Caravan = this.WeakTableRef(this.World.getEntityByID(caravan));
		}

		local location = _in.readU32();

		if (location != 0)
		{
			this.m.Location = this.WeakTableRef(this.World.getEntityByID(location));
		}

		this.contract.onDeserialize(_in);
	}

});
