this.find_artifact_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.find_artifact";
		this.m.Name = "远征";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		local myTile = this.World.State.getPlayer().getTile();
		local undead = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getSettlements();
		local highestDistance = 0;
		local best;

		foreach( b in undead )
		{
			if (b.isLocationType(this.Const.World.LocationType.Unique))
			{
				continue;
			}

			local d = myTile.getDistanceTo(b.getTile()) + this.Math.rand(0, 45);

			if (d > highestDistance)
			{
				highestDistance = d;
				best = b;
			}
		}

		this.m.Destination = this.WeakTableRef(best);
		this.m.Flags.set("DestinationName", this.m.Destination.getName());
		local nemesisNames = [
			"·渡鸦",
			"·狐狸",
			"·私生子",
			"·老猫",
			"·狮子",
			"·将军",
			"·强盗男爵",
			"·白嘴鸦"
		];
		local nemesisNamesC = [
			"渡鸦",
			"狐狸",
			"私生子",
			"老猫",
			"狮子",
			"将军 ",
			"强盗男爵",
			"白嘴鸦"
		];
		local nemesisNamesS = [
			"渡鸦",
			"狐狸",
			"私生子",
			"老猫",
			"狮子",
			"将军",
			"强盗男爵",
			"白嘴鸦"
		];
		local n = this.Math.rand(0, nemesisNames.len() - 1);
		this.m.Flags.set("NemesisName", nemesisNames[n]);
		this.m.Flags.set("NemesisNameC", nemesisNamesC[n]);
		this.m.Flags.set("NemesisNameS", nemesisNamesS[n]);
		this.m.Payment.Pool = 2000 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
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
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"前往%direction%方的%objective%，从那里取回圣物。"
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
					this.Flags.set("IsLost", true);
				}

				r = this.Math.rand(1, 100);

				if (r <= 20)
				{
					if (!this.Flags.get("IsLost"))
					{
						this.Flags.set("IsScavengerHunt", true);
					}
				}
				else if (r <= 25)
				{
					this.Flags.set("IsTrap", true);
				}
				else if (r <= 30)
				{
					this.Flags.set("IsTooLate", true);
				}

				if (!this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				this.Contract.m.Destination.setLootScaleBasedOnResources(130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.clearTroops();
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));

				if (!this.Flags.get("IsLost") && !this.Flags.get("IsTooLate"))
				{
					this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.UndeadArmy, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
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
					if (this.Flags.get("IsTrap") && !this.Flags.get("IsTrapShown"))
					{
						this.Flags.set("IsTrapShown", true);
						this.Contract.setScreen("Trap");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsScavengerHunt") && !this.Flags.get("IsScavengerHuntShown"))
					{
						this.Flags.set("IsScavengerHuntShown", true);
						this.Contract.setScreen("ScavengerHunt");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("SearchingTheRuins");
						this.World.Contracts.showActiveContract();
					}
				}
				else if (this.Flags.get("IsLost") && !this.Flags.get("IsLostShown") && this.Contract.isPlayerNear(this.Contract.m.Destination, 500))
				{
					this.Flags.set("IsLostShown", true);
					local brothers = this.World.getPlayerRoster().getAll();
					local hasHistorian = false;

					foreach( bro in brothers )
					{
						if (bro.getBackground().getID() == "background.historian")
						{
							hasHistorian = true;
							break;
						}
					}

					if (hasHistorian)
					{
						this.Contract.setScreen("AlmostLost");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("Lost");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (!this.Flags.get("IsAttackDialogShown"))
				{
					this.Flags.set("IsAttackDialogShown", true);

					if (this.Flags.get("IsTooLate"))
					{
						this.Contract.setScreen("TooLate1");
					}
					else
					{
						this.Contract.setScreen("ApproachingTheRuins");
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					_dest.m.IsShowingDefenders = true;
					this.World.Contracts.showCombatDialog();
				}
			}

		});
		this.m.States.push({
			ID = "Running_TooLate",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"追上%nemesis%并取得圣物"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onCombatWithNemesis.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					this.Contract.setScreen("TooLate3");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatWithNemesis( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;

				if (!this.TempFlags.get("IsAttackDialogWithNemesisShown"))
				{
					this.TempFlags.set("IsAttackDialogWithNemesisShown", true);
					this.Contract.setScreen("TooLate2");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					properties.Music = this.Const.Music.NobleTracks;
					properties.Entities.push({
						ID = this.Const.EntityType.BanditLeader,
						Variant = 0,
						Row = 2,
						Script = "scripts/entity/tactical/enemies/bandit_leader",
						Faction = _dest.getFaction(),
						Callback = this.onNemesisPlaced.bindenv(this)
					});
					properties.EnemyBanners = [
						this.Const.PlayerBanners[this.Flags.get("NemesisBanner") - 1]
					];
					this.World.Contracts.startScriptedCombat(properties, true, true, true);
				}
			}

			function onNemesisPlaced( _entity, _tag )
			{
				_entity.setName(this.Flags.get("NemesisNameC"));
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
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(null);
				}
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
		this.importScreens(this.Const.Contracts.NegotiationDefault);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "谈判",
			Text = "[img]gfx/ui/events/event_45.png[/img]{你见到%employer%正对着一堆地图仔细端详，用当初绘制它们的那些工具仔细筛选。他抬起头，脸上带着制图师特有的疲惫神情。%SPEECH_ON%我的学者们递交了这些地图，告诉我他们发现了一个叫‘%objective%’的地方。据说那里的大厅、走廊，呃，或者管它是什么地方，蕴藏着巨大的力量。%SPEECH_OFF%你挑起眉毛，但对方坚持说道。%SPEECH_ON%听着，我的学者们真心相信那里的东西能帮我们找到解决亡灵天灾的办法。但他们也告诉我，其他人也在寻找它。我需要你抢在所有人之前抵达那里。%SPEECH_OFF% | %employer%展开一幅从他头顶垂到脚踝的地图。他的手指绕过地图的边缘，点在某处。%SPEECH_ON%看到这个了吗？这里叫‘%objective%’。一个我……其实了解不多的地方。我只知道其他人也在往那里去，据说是为了获取某种蕴含强大力量的圣物。我的学者们认为这件圣物或许能帮助我们抵御亡灵天灾。不用多说，我希望你能在别人得手之前拿到它！%SPEECH_OFF% | %employer%向你展示一幅地图，特别指出了上面的某个位置。%SPEECH_ON%那就是所谓的‘%objective%’。有传言说其他人也在寻找它。我的学者们——他们通常不信传闻——认为那里藏着一件能帮助我们对抗亡灵天灾的圣物。这片区域位于敌对领土深处，我有理由相信你们不会是唯一的寻宝者。去那里，把圣物带回来，我会慷慨酬谢你。%SPEECH_OFF% | 见到%employer%时，他急忙恳请你到他身边阅读一本书。你看到一种从未见过的文字，但书页上有张地图无需翻译——特别是那个被羽毛笔重重圈出的位置。%employer%轻点着它。%SPEECH_ON%我需要你去那里，佣兵。他们称之为‘%objective%’。我的学者们声称那里藏有威力强大的圣物，能帮我们对抗亡灵天灾。当然，这样的圣物不可能随意摆在明处。我完全能预料到，被圣物力量吸引的各路人和怪物都会在那片区域徘徊！你必须拿到它并带回来。%SPEECH_OFF% | %employer%迎接了你，迅速描述了一个叫‘%objective%’的地方，那是位于你们所处位置%direction%的某个恐怖之地。%SPEECH_ON%我的学者们说这片区域藏有威力无穷的圣物，可能帮助我们击退亡灵天灾。当然，他们也许只是想怂恿我帮他们搞到研究材料。眼下，我选择相信。我需要你去那里找到它。巨大的力量如同磁石，所以我预料不会只有你们在那儿转悠，明白吗？去把它带回来，你会得到相应的报酬。%SPEECH_OFF% | 你看到一位学者正凑在%employer%耳边低语，这位贵族频频点头。见到你后，他立刻说明情况。%SPEECH_ON%佣兵！我得到……消息，此地%direction%方向有个地方蕴藏着我们必须掌握的强大力量。我认为它能帮助我们击退亡灵天灾。当然，如果它真有这般力量，那我们完全可以想见其他人也在寻找这件物品！正因如此，速度至关重要。我要你即刻往返。%SPEECH_OFF% |%employer%正在他的私人墓园中踱步。他停在一块墓碑前。%SPEECH_ON%每晚我都担心这些石头会开始移动，我的祖先会爬起来，因我的失败而毁灭我。%SPEECH_OFF%他转过身，面带冷笑看着你。接着他一言不发地带你进屋，一位老人正伏案研读堆满桌面的书籍。%employer%让你与老人交谈，自己则站到门边。你在老者对面坐下，他放下羽毛笔。%SPEECH_ON%{吾主赐我殊荣，向你告知所需知晓的一切。我已确认在%direction%方向一个叫‘%objective%’的地方，存在一件威力强大的圣物。我相信此物蕴含的力量或有助于解决死者……复生的问题。我也相信，如此程度的力量不会默默无闻。你需要去那里，击退所有妄图占有它的人，然后带回给我们。 | 欢迎，佣兵。我很少求助你这类职业的人来解决难题。一本好书与宁静的夜晚往往能足以应对，但今时不同往日。我们需要你前往%direction%方向一个叫‘%objective%’的地方。我们有理由相信那里可能藏着解决亡者行走于世问题的方法。当然，这种力量是极大的诱惑。你必须速去速回，以免我们失之交臂。}%SPEECH_OFF% | 一位学者站在%employer%身旁。两人都紧盯着一张纸。当你走近时，他们缓缓将纸推过桌面让你阅读。看来这位学者已定位到一处蕴含巨大力量的地点，他们认为那里可能藏着解决亡灵天灾的方法。%employer%相信许多其他人也在搜寻它，速度至关重要。 | 你看到%employer%正与一位学者交谈，两人都埋头看着一本书，中间烛火摇曳。听到你的动静，这位领主迅速抬头说明现状：他们已破译出一件伟大圣物的位置，此物很可能蕴含着解决亡者行走于世的答案。%employer%郑重地点头。%SPEECH_ON%我们有理由相信，你们不会是唯一的寻宝者，而且那地方本身也绝非安全之所。%SPEECH_OFF% | %employer%从火盆取下火把，带你深入某处墓穴。你看着可怖的雕像从黑暗中显现，贵族的火焰赋予暗影以生机。他在一尊雕像前驻足，然后转身。%SPEECH_ON%这是我父亲。仔细听。%SPEECH_OFF%你将耳朵贴近巨大的石棺，听到里面传来微弱的抓挠声。%employer%摇头。%SPEECH_ON%我的学者们已破译出传闻中某件伟大圣物的位置。它位于此地%direction%方向一个叫‘%objective%’的地方。它或许蕴藏着终结这场疯狂的力量，或许没有。当然，这般力量从不悄无声息地存于世间。我们预料会有许多其他人——或非人之物——聚集在圣物周围。去那里，佣兵，把它带回来，你会得到奖赏。%SPEECH_OFF%他将火把挥向发出低沉咆哮的石棺。%SPEECH_ON%为了我们，也为了他们。%SPEECH_OFF% | %employer%和他的学者带你进入地下墓穴。在那里你看到一口被砸开的棺材。两名卫兵用长矛抵挡着一个试图攻击的、形如僵尸的腐烂女人。她朝他们咆哮撕咬，牙齿空洞地咔嚓作响，火光勾勒出她枯瘦的轮廓。%employer%转向你。%SPEECH_ON%我们不知这是何物，也不知起因，但我们认为位于此地%direction%方向一个叫‘%objective%’的地方或许藏有答案。据说那里有件蕴含力量的圣物，我需要你把它带回来。我的学者提醒你，应做好应对未知危险的准备。%SPEECH_OFF%那行走的亡者女孩咆哮着前冲，将自己刺穿在刀刃上并向下压去。学者点头，%employer%继续说道。%SPEECH_ON%如果它能终结这场苦难，谁又知道它还能做些什么。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{相信你会为这样的危险行程提供丰厚的报酬。 | 那里离这儿很远，所以最好多给点钱。}",
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
			ID = "ApproachingTheRuins",
			Title = "%objective%里",
			Text = "[img]gfx/ui/events/event_57.png[/img]{好了，废墟到了。倒要看看%employer%和他那些书呆子学者是不是在胡说八道。 | 你来到废墟前。四周静得让人心里发毛。你让%companyname%的弟兄们做好最坏的打算。 | 总算到了据说藏着强大圣物的地方。现在就知道%employer%和他那些学者到底是不是在胡扯了。 | 废墟歪歪斜斜地挤作一团。像是约好似的，一大群蝙蝠尖叫着飞出来。%randombrother%吓得蹲下身子，其他人都笑了起来。 | 你找到了%objective%，站在旁边的山丘上。往下看就知道这地方为什么能藏这么久——位置太不起眼了。站在这儿都能听见风穿过石缝的声音。 | 你到达%objective%，%randombrother%不出所料地评价道。%SPEECH_ON%看起来真没劲。咱们赶紧完事吧？%SPEECH_OFF%希望他说得对。 | %randombrother%直起身子。%SPEECH_ON%靠，我看就是那儿了。%SPEECH_OFF%他盯着那片确实像%objective%的废墟，搓了搓手。%SPEECH_ON%赶紧动手吧。我发誓要是里面有巫妖，我做鬼都要念叨这事。%SPEECH_OFF% | %randombrother%望着远处的%objective%。%SPEECH_ON%你觉得下面有什么？我看%employer%在耍我们。咱们走进去肯定会有一群漂亮姑娘迎接。给咱们这些辛苦男人的奖励，懂吧？%SPEECH_OFF%不知为啥，你觉得这不太可能。 | %objective%就在不远处。从这里只能看见歪斜的石墙，但臭味老远就飘过来了。%randombrother%捂住鼻子。%SPEECH_ON%闻起来像我姨妈的屎。就算那个老妖婆真的在里面我也不奇怪。%SPEECH_OFF% | 接近%objective%时，你让手下准备战斗。谁知道这片禁地里有什么在等着%companyname%！ | 当你接近%objective%时，隐约听到一些低语。%SPEECH_ON%{进来吧。进来吧。这是为你好。你会喜欢这里的，肯定的。我们同意。对，我们同意。快一点。我们等不及了！ | 你不是第一个。你不是第一个。你也不会是最后一个。你也不会是最后一个。 | 蠢货，你以为你的想法是自己的？ | 你的手下会背叛你。他们觉得你没用。滚回去吧，你这哭鼻子的虫豸。 | 你来了。你将永远留在这里。 | 啊，又来了一些人类。我受不了你们这副模样。你们污染了我呼吸的空气。让我来处理你。我会让腐烂填满你们的肚子，那样对你们更好…… | 敢来这里，你这小个子挺大胆，不过你只是个标本而已。恐惧会充满你的心，直到什么都装不下。然后你就会死。就是这样，只会这样。 | 过来吧，小人类。我一直想让你来到这里。 | 对！你终于来了！见到你真高兴，人类，太高兴了！ | 啊，又来了一个残忍的畜生。多么愚蠢的小东西。对，非常愚蠢。我们该怎么处置它？当然要放它进来。当然！}%SPEECH_OFF%%randombrother%掏了掏耳朵。%SPEECH_ON%你刚才说话了吗，长官？%SPEECH_OFF%你摇摇头，赶紧让大家做好应对任何情况的准备。 | 当你接近%objective%时，隐约听到一些低语。%SPEECH_ON%{进来吧。进来吧。这是为你好。你会喜欢这里的，肯定的。我们同意。对，我们同意。快一点。我们等不及了！ | 你不是第一个。你不是第一个。你也不会是最后一个。你也不会是最后一个。 | 蠢货，你以为你的想法是自己的？ | 你的手下会背叛你。他们觉得你没用。滚回去吧，你这哭鼻子的虫豸。 | 你来了。你将永远留在这里。 | 啊，又来了一些人类。我受不了你们这副模样。你们污染了我呼吸的空气。让我来处理你。我会让腐烂填满你们的肚子，那样对你们更好…… | 敢来这里，你这小个子挺大胆，不过你只是个标本而已。恐惧会充满你的心，直到什么都装不下。然后你就会死。就是这样，只会这样。 | 过来吧，小人类。我一直想让你来到这里。 | 对！你终于来了！见到你真高兴，人类，太高兴了！ | 啊，又来了一个残忍的畜生。多么愚蠢的小东西。对，非常愚蠢。我们该怎么处置它？当然要放它进来。当然！}%SPEECH_OFF%%randombrother%掏了掏耳朵。%SPEECH_ON%你刚才说话了吗，长官？%SPEECH_OFF%你摇摇头，赶紧让大家做好应对任何情况的准备。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "小心点！",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SearchingTheRuins",
			Title = "%objective%里",
			Text = "[img]gfx/ui/events/event_57.png[/img]{你终于拿到了圣物。它在手中的分量感觉不太对劲，明明应该很沉重，却有种不自然的轻盈感。你把它塞进袋子，准备回去找你的雇主%employer%。 | 你终于得到了追寻已久的圣物。说实话，有点让人失望。你心底曾希望它能赋予你巨大力量，但它只是毫无生气地躺在你手里。也许你并非天选之人。 | 你拿起圣物，无视它发出的低沉嗡鸣，准备返回%employer%那里。 | 你拿起圣物仔细端详。%randombrother%走过来双手叉腰。%SPEECH_ON%妈的，这丑玩意儿也没多稀罕嘛。%SPEECH_OFF% | 你在手中掂量着圣物。它的重量忽轻忽重来回变化。好吧，这足够古怪了，你赶紧把它塞进了挎包。 | 在你收起圣物前，%randombrother%瞥了一眼。%SPEECH_ON%看起来不咋样嘛。%SPEECH_OFF%你告诉他很多蕴含力量的东西看起来都不起眼。他坐着想了想。%SPEECH_ON%我放的屁连个影儿都没有，所以你说得对。%SPEECH_OFF% | 你把圣物递给%randombrother%。他举着它。%SPEECH_ON%要是我现在当场砸了它，你会生气吗？%SPEECH_OFF%你瞪了他一眼。%SPEECH_ON%会，有点。但说不定里面住着小恶魔，会因为你毁了它们家而永远缠着你。谁知道呢，对吧？%SPEECH_OFF%那佣兵赶紧把圣物塞进了挎包。 | 你看着圣物。它毫无特色，一动不动，不像你预期中蕴含伟力的样子，但不知为何这反而最令人不安。你迅速把它收进了挎包。 | 你把圣物放进挎包，它却突然发光呼唤你。打开袋子，你看到两个红点正回盯着你。%randombrother%问你是否一切正常。你猛地合上袋子点了点头。 | 你终于拿到了圣物。它不发光，不嗡鸣，甚至看起来也不怎么漂亮。你不明白为何如此兴师动众，但如果%employer%愿意为此付钱，那是他的事。 | 好了，你拿到圣物了。%randombrother%挠着头走过来。%SPEECH_ON%所以很多人就为这小玩意儿送了命？%SPEECH_OFF%圣物发出响声，一个低沉的声音回答道。%SPEECH_ON%他们没有死。他们现在与我同在，直至永恒。%SPEECH_OFF%那佣兵吓得往后一跳。%SPEECH_ON%知道吗？我什么都没听见。我不知道那是什么。我不在乎。不了。我还是回去啃我的硬面包过平淡日子吧，谢了。%SPEECH_OFF% | 你拿起圣物，中间垫了块布，免得它的力量渗入你的血肉。当然，它看起来只是块花哨的石头，但小心总无大错。%employer%见到它应该会高兴，至于他怎么拿，随他便。 | 圣物看起来是有点怪，但也没什么太出奇的。说不定只是某个流浪汉的玩意儿被别人当成了圣物。%randombrother%盯着它。%SPEECH_ON%说真的，我拉出来的都比这好看。%SPEECH_OFF%你警告他，如果这圣物真有力量，他可能会为这话付出代价。他耸耸肩。%SPEECH_ON%但这也改变不了事实啊。%SPEECH_OFF% | 你举起圣物，它突然变重，让你不得不放下。当你把它放低靠近脚边时，它又变轻了，仿佛希望被重新拾起。这够古怪的了，你赶紧收好它，准备返回%townname%的%employer%那里。 | 你终于拿到了圣物。正盯着它看时，%randombrother%走了过来。%SPEECH_ON%所以，%employer%要的就是这玩意儿？见鬼，我都能造个差不多的，省得我们这么折腾。%SPEECH_OFF%你把圣物收进袋子回应道。%SPEECH_ON%我觉得他之后会发现是假的。%SPEECH_OFF%那佣兵竖起手指。%SPEECH_ON%关键词：之后。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们已经拿到要拿的东西了。是时候回去了！",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.setState("Return");
			}

		});
		this.m.Screens.push({
			ID = "AlmostLost",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_42.png[/img]{行军途中，历史学家%historian%看到你正盯着地图看。他请求查看，你同意了。这人把地图举远又拉近。%SPEECH_ON%我们走错路了。%employer%的学者肯定解读错了。看到这个符号了吗？它其实是……%SPEECH_OFF%他顿了顿，意识到接下来说的你也听不懂，便笑了笑。%SPEECH_ON%好吧，简单说我们得往这边走。%SPEECH_OFF%他掏出羽毛笔做了修正。 | 历史学家%historian%正在查看%employer%给你的地图。他停下来问道。%SPEECH_ON%你说这是那位贵族的学者绘制的地图？因为全搞错了。你看。%SPEECH_OFF%他把地图指给你看。%SPEECH_ON%他们误读了这些文字。这不是字母，而是信仰符号。这些不是单词，而是谜题。只要正确解读，它们会指引你到这里。%SPEECH_OFF%他指向一个与你原定方向完全不同的地点。看来%companyname%需要调整路线了。 | 历史学家%historian%一边仔细研究地图一边摇头。%SPEECH_ON%长官，我们走错方向了。%employer%的学者把这些符号解读错了。我们需要改变路线。%SPEECH_OFF%你本想质疑他的判断，但比起贵族塔楼里那些老学究，你更愿意相信随%companyname%行动的经验丰富的历史学家。 | %historian%拿过%employer%给你的地图仔细查看。%SPEECH_ON%不对，咱们走错方向了。看到没？这里的字母是从上到下，从右到左排列。这是个文字谜题，那位贵族的学者自以为解开了，其实搞错了。%SPEECH_OFF%你问这是否意味着你们走错了路。%historian%点点头。%SPEECH_ON%没错。幸好我在这儿对吧？%SPEECH_OFF% | 你看着%employer%给你的地图。上面满是你看不懂的弯弯绕绕的符号，就像有人随手创造了一套文字。历史学家%historian%嚼着午餐走过来。他边嚼边说。%SPEECH_ON%图是错的。%SPEECH_OFF%你擦掉地图上的食物碎屑，问他什么意思。他笑了。%SPEECH_ON%就是说地图不对。%employer%的学者根本不知道自己在看什么。看到下面那个巨石了吗？那才是我们要去的地方。话说这个挺好吃的，想尝尝吗？%SPEECH_OFF%他让你尝一口，但你拒绝了。%SPEECH_ON%那你可亏了。要我去告诉大家改变方向吗？%SPEECH_OFF%你叹口气点了点头。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "有用的知识。",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						local myTile = this.World.State.getPlayer().getTile();
						local undead = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getSettlements();
						local lowestDistance = 9999;
						local best;

						foreach( b in undead )
						{
							if (b.isLocationType(this.Const.World.LocationType.Unique))
							{
								continue;
							}

							local d = myTile.getDistanceTo(b.getTile()) + this.Math.rand(0, 25);

							if (d < lowestDistance)
							{
								lowestDistance = d;
								best = b;
							}
						}

						this.Contract.m.Destination = this.WeakTableRef(best);
						this.Flags.set("DestinationName", this.Contract.m.Destination.getName());
						this.Contract.m.Destination.setDiscovered(true);
						this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
						this.Contract.m.Destination.clearTroops();
						this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
						this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.UndeadArmy, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						this.Contract.getActiveState().start();
						this.World.Contracts.updateActiveContract();
						this.Contract.m.Dude = null;
						return 0;
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local candidates = [];

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.historian")
					{
						candidates.push(bro);
					}
				}

				this.Contract.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];
			}

		});
		this.m.Screens.push({
			ID = "Lost",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_42.png[/img]你抵达了自认为正确的目的地。然而……这里空无一物。你仔细研究地图，终于意识到问题所在。原来有两处巨石都形似{持剑的男子 |  被旧神攻击的教堂 | 长着脸的巨型土豆 | 身姿曼妙的女子 | 一只遛着人的狗 | 人立而起正扑向一个试图喝汤的小女孩的巨熊 | 仰望云朵的年轻人——上空恰好有块形似兔子的岩石云，但%randombrother%坚称那肯定是狗，直到你们发现竟在争论一块石头云的模样，而它们正被另一个巨石凝视着}。你在地图上做了一个记号，前往真正的目的地，只希望这次偏离正轨的小插曲没有耽误太多时间。",
			Image = "",
			List = [],
			Options = [
				{
					Text = "该死的！",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						local myTile = this.World.State.getPlayer().getTile();
						local undead = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getSettlements();
						local lowestDistance = 9999;
						local best;

						foreach( b in undead )
						{
							if (b.isLocationType(this.Const.World.LocationType.Unique))
							{
								continue;
							}

							local d = myTile.getDistanceTo(b.getTile()) + this.Math.rand(0, 25);

							if (d < lowestDistance)
							{
								lowestDistance = d;
								best = b;
							}
						}

						this.Contract.m.Destination = this.WeakTableRef(best);
						this.Flags.set("DestinationName", this.Contract.m.Destination.getName());
						this.Contract.m.Destination.setDiscovered(true);
						this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
						this.Contract.m.Destination.clearTroops();
						this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
						this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.UndeadArmy, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						this.Contract.m.Destination.setLootScaleBasedOnResources(130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());

						if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
						{
							this.Contract.m.Destination.getLoot().clear();
						}

						this.Contract.getActiveState().start();
						this.World.Contracts.updateActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "TooLate1",
			Title = "%objective%里",
			Text = "[img]gfx/ui/events/event_57.png[/img]当你踏入房间期待找到圣物时，却只看见空荡荡的基座和一张字条。上面写着：%SPEECH_ON%{看来你的手下又迟到了，%employer%。还记得当年与我共事的日子吗？这就是报应！ | 啊哈！没错，我就是写了这两个字——当我发现自己又一次领先你%employer%一步时，我就是这么欢呼的！可惜你走了廉价路线，雇了帮无名佣兵。祝你下次好运。 | 读到这张纸条时，说明你们太慢了，而%employer%选择雇佣你们而非我更是大错特错。可惜啊，圣物已在我手中。现在滚回去向你们的雇主解释失败经过吧。 | 读到此信者，想必就是%employer%宁可雇佣也不选我的那支佣兵团。看他错得多离谱！看看你们这群慢吞吞的废物！估计你们脑子硬得连这都读不懂吧？ | 佣兵你们好，真遗憾不能亲眼看到你们读信时的表情。唉，人生总难事事如意。圣物在我手中而非你们掌心——这个事实应该能让你们明白这一点。祝你下次走运，废物，代我向%employer%问好。}%SPEECH_OFF%落款处签着“%nemesis%”。\n\n你不知道他是谁，但他现在已经死定了。零散的足迹为这混蛋的去向提供了线索。",
			Image = "",
			List = [],
			Options = [
				{
					Text = "一个意想不到的转折！",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						local playerTile = this.World.State.getPlayer().getTile();
						local camp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getNearestSettlement(playerTile);
						local tile = this.Contract.getTileToSpawnLocation(playerTile, 8, 14);
						local party = this.World.FactionManager.getFaction(camp.getFaction()).spawnEntity(tile, this.Flags.get("NemesisNameC"), false, this.Const.World.Spawn.Mercenaries, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
						party.setFootprintType(this.Const.World.FootprintsType.Mercenaries);
						local n = 0;

						do
						{
							n = this.Math.rand(1, this.Const.PlayerBanners.len());
						}
						while (n == this.World.Assets.getBannerID());

						party.getSprite("banner").setBrush(this.Const.PlayerBanners[n - 1]);
						this.Flags.set("NemesisBanner", n);
						this.Contract.m.UnitsSpawned.push(party);
						party.getLoot().Money = this.Math.rand(50, 100);
						party.getLoot().ArmorParts = this.Math.rand(0, 10);
						party.getLoot().Medicine = this.Math.rand(0, 2);
						party.getLoot().Ammo = this.Math.rand(0, 20);
						local r = this.Math.rand(1, 6);

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
						else if (r == 5)
						{
							party.addToInventory("supplies/pickled_mushrooms_item");
						}

						this.Contract.m.Destination = this.WeakTableRef(party);
						party.setAttackableByAI(false);
						party.setFootprintSizeOverride(0.75);
						local c = party.getController();
						c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
						local roam = this.new("scripts/ai/world/orders/roam_order");
						roam.setPivot(camp);
						roam.setMinRange(5);
						roam.setMaxRange(10);
						roam.setAllTerrainAvailable();
						roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
						roam.setTerrain(this.Const.World.TerrainType.Shore, false);
						roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
						c.addOrder(roam);
						this.Const.World.Common.addFootprintsFromTo(playerTile, this.Contract.m.Destination.getTile(), this.Const.GenericFootprints, this.Const.World.FootprintsType.Mercenaries, 0.75);
						this.Contract.setState("Running_TooLate");
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "TooLate2",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_07.png[/img]{沿着脚印追踪，你终于追上了%nemesis%和他的人马。你认出他们是因为队伍里最大的那个蠢货正拿着圣物。看来这家伙确实有嚣张的资本：他身边围着一群装备精良的战士。你们最好小心行事。 | %nemesis%并不像他那些花哨的侮辱性留言暗示的那么难找。不过至少他的防卫很严密。这个混蛋被一群全副武装的侍卫围着，正贪婪地盯着手中的圣物。要想拿回圣物，%companyname%得好好想想该怎么应对这个局面。 | 你发现有个男人正盯着你们要找的圣物。肯定是%nemesis%！就在你准备冲出去亲手宰了他的时候，%randombrother%抓住你的衣服把你拽了回来。他往前指了指，只见一队装备精良的护卫出现在视野里。%companyname%得谨慎处理这个情况。 | 脚印并不难追踪。你起初以为是因为这个%nemesis%是个蠢货，结果发现只是他的护卫太多了。你找到他时，他正拿着圣物，被一队装备精良的护卫团团围住。暴力确实是你此行的目的，但或许还有别的办法？ | 你发现%nemesis%正拿着圣物。他看起来是个容易对付的目标，留下了满地脚印，不知是无知还是过度自信。当你拔出剑时，%randombrother%按住了你的手。他朝前方示意。\n\n你看到一群人走向%nemesis%请示命令。那是他的护卫，而且全都武装到了牙齿。要想拿回圣物，恐怕得比预期流更多的血。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "挑衅%companyname%是个严重的错误，也是你人生最后一个错误。",
					function getResult()
					{
						this.Contract.getActiveState().onCombatWithNemesis(this.Contract.m.Destination, false);
						return 0;
					}

				},
				{
					Text = "今天谁都不用死。我用%bribe%克朗换你手中的圣物，你怎么说？",
					function getResult()
					{
						return this.Math.rand(1, 100) <= 50 ? "TooLateBribeRefused" : "TooLateBribeAccepted";
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "TooLate3",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_11.png[/img]{你终于拿到了圣物。它在手中的分量感觉不太对劲，明明应该很沉重，却有种不自然的轻盈感。你把它塞进袋子，准备回去找你的雇主%employer%。 | 你终于得到了追寻已久的圣物。说实话，有点让人失望。你心底曾希望它能赋予你巨大力量，但它只是毫无生气地躺在你手里。也许你并非天选之人。 | 你拿起圣物，无视它发出的低沉嗡鸣，准备返回%employer%那里。 | 你拿起圣物仔细端详。%randombrother%走过来双手叉腰。%SPEECH_ON%妈的，这丑玩意儿也没多稀罕嘛。%SPEECH_OFF% | 你在手中掂量着圣物。它的重量忽轻忽重来回变化。好吧，这足够古怪了，你赶紧把它塞进了挎包。 | 在你收起圣物前，%randombrother%瞥了一眼。%SPEECH_ON%看起来不咋样嘛。%SPEECH_OFF%你告诉他很多蕴含力量的东西看起来都不起眼。他坐着想了想。%SPEECH_ON%我放的屁连个影儿都没有，所以你说得对。%SPEECH_OFF% | 你把圣物递给%randombrother%。他举着它。%SPEECH_ON%要是我现在当场砸了它，你会生气吗？%SPEECH_OFF%你瞪了他一眼。%SPEECH_ON%会，有点。但说不定里面住着小恶魔，会因为你毁了它们家而永远缠着你。谁知道呢，对吧？%SPEECH_OFF%那佣兵赶紧把圣物塞进了挎包。 | 你看着圣物。它毫无特色，一动不动，不像你预期中蕴含伟力的样子，但不知为何这反而最令人不安。你迅速把它收进了挎包。 | 你把圣物放进挎包，它却突然发光呼唤你。打开袋子，你看到两个红点正回盯着你。%randombrother%问你是否一切正常。你猛地合上袋子点了点头。 | 你终于拿到了圣物。它不发光，不嗡鸣，甚至看起来也不怎么漂亮。你不明白为何如此兴师动众，但如果%employer%愿意为此付钱，那是他的事。 | 好了，你拿到圣物了。%randombrother%挠着头走过来。%SPEECH_ON%所以很多人就为这小玩意儿送了命？%SPEECH_OFF%圣物发出响声，一个低沉的声音回答道。%SPEECH_ON%他们没有死。他们现在与我同在，直至永恒。%SPEECH_OFF%那佣兵吓得往后一跳。%SPEECH_ON%知道吗？我什么都没听见。我不知道那是什么。我不在乎。不了。我还是回去啃我的硬面包过平淡日子吧，谢了。%SPEECH_OFF% | 你拿起圣物，中间垫了块布，免得它的力量渗入你的血肉。当然，它看起来只是块花哨的石头，但小心总无大错。%employer%见到它应该会高兴，至于他怎么拿，随他便。 | 圣物看起来是有点怪，但也没什么太出奇的。说不定只是某个流浪汉的玩意儿被别人当成了圣物。%randombrother%盯着它。%SPEECH_ON%说真的，我拉出来的都比这好看。%SPEECH_OFF%你警告他，如果这圣物真有力量，他可能会为这话付出代价。他耸耸肩。%SPEECH_ON%但这也改变不了事实啊。%SPEECH_OFF% | 你举起圣物，它突然变重，让你不得不放下。当你把它放低靠近脚边时，它又变轻了，仿佛希望被重新拾起。这够古怪的了，你赶紧收好它，准备返回%townname%的%employer%那里。 | 你终于拿到了圣物。正盯着它看时，%randombrother%走了过来。%SPEECH_ON%所以，%employer%要的就是这玩意儿？见鬼，我都能造个差不多的，省得我们这么折腾。%SPEECH_OFF%你把圣物收进袋子回应道。%SPEECH_ON%我觉得他之后会发现是假的。%SPEECH_OFF%那佣兵竖起手指。%SPEECH_ON%关键词：之后。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们已经拿到要拿的东西了。是时候回去了！",
					function getResult()
					{
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
			ID = "TooLateBribeRefused",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_07.png[/img]{盗贼头目大笑摇头。%SPEECH_ON%你真以为……我是说，当真？%SPEECH_OFF%他上前一步继续说道。%SPEECH_ON%我猜你是觉得试试也无妨，但我们的答案是拒绝。%SPEECH_OFF%他缓缓抽出利刃，寒光流转，剑锋直指你。%SPEECH_ON%坚决拒绝。%SPEECH_OFF% | 贿赂这招行不通。这帮盗贼不光拒绝，还觉得被羞辱了，直接动手开打！看来这群强盗还挺讲道义！ | 盗贼头目嗤之以鼻。%SPEECH_ON%贿赂？不要。我们千辛万苦走到这一步，可不是为了做这等小买卖。弟兄们，该让他们尝尝苦头了吧？%SPEECH_OFF%在欢呼声中，这群暴徒纷纷亮出兵器。头目将刀锋指向%companyname%。%SPEECH_ON%准备受死吧，雇佣兵。%SPEECH_OFF% | 你提出贿赂，但很快被拒绝了。暴徒头目与你对视点头。彼此心照不宣：谁都不想空手而归。准备迎战！ | 匪徒们围拢在一起低声商议。最终头目挺身走来，双手叉腰，胸膛傲然挺起。他摇了摇头。%SPEECH_ON%我们谢绝你的提议。现在让路，否则准备开战。%SPEECH_OFF%%employer%付钱可不是让你空手而归的。你下令%companyname%列阵。匪徒叹息着拔剑出鞘。%SPEECH_ON%如你所愿！%SPEECH_OFF% | 暴徒们对你的提议笑出声来。他们似乎将此视作示弱，纷纷亮出兵器。你自觉出价公允，但这帮人偏要拿命来换。既然如此。准备战斗！ | 盗贼头目大笑。%SPEECH_ON%有趣的提议，但不行。你我都清楚这小圣物远高于这个价，也绝对比你能开出的任何价码都要高。现在让开。%SPEECH_OFF%%companyname%迅速列阵，武器就绪。%randombrother%啐了一口。%SPEECH_ON%我们能全歼他们，长官，只管下令。%SPEECH_OFF%你对%companyname%抱有绝对信心——它的信仰本就是施行暴力。是时候践行我们的教义了！ | 匪首从布袋中掏出一颗头颅。那头颅灰败瘆人，发丝在他指间绷紧扭转。%SPEECH_ON%上次挡我们路的人就是这下场。你的提议心领了，佣兵。现在让开，否则我可就不客气了。%SPEECH_OFF%你纵声笑道，%SPEECH_ON%我们是%companyname%，可惜没人知道你们是哪儿冒出来的——等把你们全宰光了，连个能拿来吹牛的故事都不会有。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						this.Contract.getActiveState().onCombatWithNemesis(this.Contract.m.Destination, false);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "TooLateBribeAccepted",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_07.png[/img]{经过一番讨论，盗贼们接受了你的提议。你交出克朗，他们则交出了圣物。这比预想的要顺利。 | 这群匪徒围成一团窃窃私语，不时朝你瞥来。这情形着实诡异——考虑到几分钟后他们的决定可能引发一场血战。最终他们停止了讨论，头目招手让你过去。%SPEECH_ON%我们的雇主肯定不会高兴，但那些克朗实在难以拒绝。按你说的办，佣兵。%SPEECH_OFF% | 这群暴徒为你的提议争执不休。有人说如果空手而归，雇主想必会大发雷霆，另一些人则声称不值得为此送命。后者占了上风。你付出克朗，换回了圣物。 | 若换作注重荣誉的队伍，或许会与%companyname%一战，但你面对的是群盗贼，而非什么正人君子。他们同意用圣物换取克朗。 | 盗贼头目拔出长剑。%SPEECH_ON%你真以为我们会接受那种条……%SPEECH_OFF%飞溅的鲜血替他补完了未尽之语——突然从他胸前透出的剑刃上正滴落血珠。这匪徒眼珠翻白，而凶手一脚踏在他背上将尸体踹离剑锋，擦拭着武器。%SPEECH_ON%我们可不打算为那狗娘养的送命。你的条件我们接受了，佣兵。%SPEECH_OFF% | 盗贼内部爆发了争执。有些人自以为能与你们抗衡，另一些则对%companyname%的威名略有耳闻，极力反对动武。最终他们达成共识：接收交易。 | 你出资购买圣物的提议在盗贼间引发激烈争论。他们压低声音争执，但扫向你们的眼神表明他们将你们视作生死存亡的威胁。最终他们结束密谈，同意了你的条件。你很高兴能避免流血冲突。 | 盗贼们嗤之以鼻。%SPEECH_ON%你以为我们能空着手回去见金主？%SPEECH_OFF%你捋了捋头发回应。%SPEECH_ON%总比彻底回不去强，对吧？%SPEECH_OFF%每个盗贼都警惕地后退一步。头目摇头又点头，动作快得仿佛一气呵成。%SPEECH_ON%见鬼，佣兵，你这可让我们难办了。不过好吧，我们接受。%SPEECH_OFF%圣物易主，干戈得免。 | 盗贼头目转身面向同伙，诚恳发问。%SPEECH_ON%弟兄们怎么说，觉得我们能拿下他们吗？%SPEECH_OFF%有人耸耸肩。%SPEECH_ON%我觉得我们能拿下他们给的金子。%SPEECH_OFF%另一人插嘴。%SPEECH_ON%这趟本是探险差事，咱们的卖命钱可不包括为这破圣物送死。%SPEECH_OFF%匪徒们逐渐达成共识：与其被屠戮，不如收下克朗。这做法实属明智。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "你做出了正确的决定。",
					function getResult()
					{
						this.Contract.m.Destination.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
						return "TooLate3";
					}

				}
			],
			function start()
			{
				local bribe = this.Contract.beautifyNumber(this.Contract.m.Payment.Pool * 0.4);
				this.World.Assets.addMoney(-bribe);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你花了[color=" + this.Const.UI.Color.NegativeEventValue + "]" + bribe + "[/color]克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "Trap",
			Title = "%objective%里",
			Text = "[img]gfx/ui/events/event_12.png[/img]{你迈过一根绊线，并提醒%hurtbro%要小心。但他没有上心，并因此尝到了机关陷阱的厉害。 | 废墟的地面上布满了明显的陷阱和致命装置。你们成功地穿过了它们，没有遇到任何问题，直到%hurtbro%自以为安全而突然前冲。古老的机关被触发，你觉得整个地方都要塌下来砸在你们头上。幸运的是，只有这名佣兵为自己的鲁莽付出了代价。 | 废墟中布满了陷阱，而%hurtbro%成功触发了一个。 | %hurtbro%的脚踩在一块砖上，砖块迅速沉入地面。墙后传来古老机械的轰鸣，天花板开始崩塌。尽管动静很大，但陷阱本身威力相当小，这名佣兵死不了。 | 墙上的铭文通过图画诉说着古老的诫言。不幸的是，那些简笔画画得太差，你没意识到它们其实是警告标志，直到为时已晚：%hurtbro%误入了一个陷阱，并为你糟糕的解读能力吃了大苦头。 | 你该更谨慎些：废墟里遍布陷阱，而%hurtbro%径直踩中了一个。他还活着，这意外让你们后面更加注意安全。 | %hurtbro%触发了一个陷阱，并因其缺乏谨慎而吃了不少苦头。 | 很多很多年前，有个人坐下来制作了一个陷阱。今天，%hurtbro%径直踩在上面。 | 你触发了一根绊线，听到墙壁内传来古老机械的启动声。你俯身躲避，以为自己没事了，结果一转身看到%hurtbro%承受了陷阱的大部分伤害。哎呀…… | 你看到地上的绊线，笑了。就差一点，古代的陷阱大师啊，就差那么一点——突然，%hurtbro%从你身边走过，触发了陷阱。这蠢货能活下来，但他接下来有得受了。 | %hurtbro%吹着口哨，曲调在废墟深处回荡，但回声听起来不太对劲，仿佛在墙内的某处打着嗝。你命令兄弟们稳住别动，但那个吹口哨的人继续前进，随即摔穿地板掉进了一个坑里。你冲到坑边，看到他刚刚好躲过了一些尖刺。 | 在穿行于错综复杂的废墟时，%hurtbro%触发了一个陷阱，让他猛地坠穿地板。他落在下层一个布满孔洞的地面上。尖刺冒了出来，但速度足够慢，让他得以躲开。幸好陷阱的触发顺序不对，你成功把这名佣兵从那里弄了出来。 | 在蜿蜒穿过令人迷惑的废墟时，%hurtbro%突然从视野中消失。你冲到他刚才的位置，差点也掉进同一个陷阱：一个地面上的坑洞，里面散落着脆硬的蛇蜕。幸好那些生物已经不在了，但坠落本身已足以让这可怜的佣兵受伤。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "多加小心！",
					function getResult()
					{
						this.Contract.m.Dude = null;
						return "SearchingTheRuins";
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local bro = brothers[this.Math.rand(0, brothers.len() - 1)];
				local injury = bro.addInjury(this.Const.Injury.Accident1);
				this.Contract.m.Dude = bro;
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = bro.getName() + " 遭受 " + injury.getNameOnly()
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "ScavengerHunt",
			Title = "%objective%里",
			Text = "[img]gfx/ui/events/event_57.png[/img]{你在遗迹中发现一张地图，上面显示圣物实际位于%direction%方向一个叫%objective%的遗迹。 | 可惜圣物不在此处。经过调查，你发现来错了地方：你要找的东西实际在%direction%方向的%objective%。 | 看来你们来错地方了。你和手下尽力破译墙上的文字，与地图比对，最终发现要找的圣物很可能在%direction%方向一个叫%objective%的地方。 | %randombrother%拿着地图走来，低声咒骂着。%SPEECH_ON%长官，咱们好像来错地方了。您看这个。%SPEECH_OFF%你们共同研判出圣物很可能在%direction%方向一个叫%objective%的废墟里。 | 你本想一举找到文物，看来没这么顺利。经过仔细探查，战团慢慢意识到来错了地方。得前往%direction%方向的%objective%才行。 | 这片废墟不对。墙上的标识和明显缺失的圣物都说明了这点。经过仔细推测，你判断圣物实际在%direction%方向的%objective%。 | 在遗迹中艰难搜寻却一无所获后，你逐渐明白来错了地方。你和%randombrother%研究地图许久，最终判定圣物实际在%direction%方向一个叫%objective%的地方。 | %randombrother%发现一具被陷阱尖刺刺穿的尸体。死者枯骨手中紧握着一张地图。你查看地图后意识到，和这个倒霉探险家一样，你们也来错了废墟。圣物实际在%direction%方向的%objective%。幸好这位胆大的探险家比你们先到！ | 一具尸体蜷缩在通往空祭台的台阶上。这里本该放着圣物，但现在不见了。死者身上也没有。%randombrother%翻查尸体衣物，找到一张折叠地图，指向%direction%方向一个叫%objective%的地方。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "准备好继续赶路吧，弟兄们！",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Destination = null;
				local myTile = this.World.State.getPlayer().getTile();
				local undead = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getSettlements();
				local lowestDistance = 9999;
				local best;

				foreach( b in undead )
				{
					if (b.isLocationType(this.Const.World.LocationType.Unique))
					{
						continue;
					}

					local d = myTile.getDistanceTo(b.getTile()) + this.Math.rand(0, 35);

					if (d < lowestDistance)
					{
						lowestDistance = d;
						best = b;
					}
				}

				this.Contract.m.Destination = this.WeakTableRef(best);
				this.Flags.set("DestinationName", this.Contract.m.Destination.getName());
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				this.Contract.m.Destination.clearTroops();
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.UndeadArmy, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.getActiveState().start();
				this.World.Contracts.updateActiveContract();
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer%的房门敞开着，你走了进去。他转过身，用长时间的凝视和\"怎么样？\"的眼神看着你。你拿出圣物递过去。这位贵族以毫不掩饰的活力跳了起来。%SPEECH_ON%你拿到了！旧神在上！快给我！%SPEECH_OFF%圣物交到他手中，%employer%的眼睛瞪大了。你询问报酬的事，但他仿佛已置身另一个世界，好像被吸进了圣物内部。他的一位学者从角落的阴影中走出，递给你一袋%reward_completion%克朗。%SPEECH_ON%请见谅，佣兵。吾主与我尚有要务需处理。%SPEECH_OFF% | %employer%深陷在椅中，更深陷在自己的思绪中。他的一个护卫不得不告知他你的到来，重复了三次这位贵族才抬起头。他盯着你，然后看向圣物。他的身体从椅子上抬起，仿佛被某种无形力量的冲动所驱动。他接过圣物猛地转身，冲到书桌前放下它，俯身以原始的热忱观察着它。护卫递给你一袋%reward_completion%克朗。%SPEECH_ON%你最好离开，佣兵。%SPEECH_OFF% | %employer%的一位学者在贵族房外迎接你。他呼出带着霉书味的气息，举止匆忙。%SPEECH_ON%那就是圣物吗？是吗？%SPEECH_OFF%你递过装有圣物的袋子。学者的手指抓住束口绳，如同鸟喙啄取蠕虫。%SPEECH_ON%拿来！快给！喏，拿上你的钱快走！%SPEECH_OFF%他将一袋%reward_completion%克朗猛地塞进你手里，随即低头钻进了%employer%的房间。 | 几位学者在%employer%的房间里等候。贵族本人则在床上沉睡，面朝天花板，双臂置于身侧，像个未完工的人体模型。一位学者上前。%SPEECH_ON%圣物，交出来。%SPEECH_OFF%这情形非常古怪，但你绝不想吵醒一位沉睡的领主。你询问报酬。另一位学者扔给你一袋%reward_completion%克朗，袋子滑过石地板。%SPEECH_ON%现在把圣物放地上，然后离开。%SPEECH_OFF%你拿上钱走了。 | 你发现%employer%正在和一群贵族开玩笑。他从人群头顶瞥见你，便匆忙结束笑话并道别。他滑步绕过房间，低声与你交谈。%SPEECH_ON%圣物带来了吗？%SPEECH_OFF%你递过去，那人咧嘴笑了。他给你一袋%reward_completion%克朗。%SPEECH_ON%干得好，佣兵，但你该走了。这儿不是你待的圈子。其实也不是我的。%SPEECH_OFF%他眨眨眼，挥手让你离开。 | 一位学者在%employer%房外拦住了你。他将手指竖在唇前摇了摇头，然后引你走向走廊深处。来到一个火盆前，老者迅速环顾四周，随后拉动了火炬。%SPEECH_ON%推这面墙，佣兵。%SPEECH_OFF%你依言而行。其中一块并非石料，而是木头。它滑开后你走了进去。%employer%就在里面，昏暗的烛光房间里散落着大量书籍和古怪物品。他打了个响指，你交出了圣物。作为回报，你收到一袋%reward_completion%克朗。贵族顿了顿，然后看向他的学者。%SPEECH_ON%等等，这地方本该是秘密，你他妈在干什么？%SPEECH_OFF%老者尴尬地抿紧嘴唇。贵族捏着额头。%SPEECH_ON%真见鬼。好吧，看来得再把泥瓦匠叫来了。%SPEECH_OFF% | 你找到%employer%并交出了圣物。他给你一袋%reward_completion%克朗，交易就这样完成了。呵，真是虎头蛇尾。 | %employer%正站在几位指挥官身旁。你进来时他们都看着你，贵族将手伸过桌面。你缓缓上前将圣物放入他掌心。他接过它，翻转端详，然后瞥了你一眼。他打了个响指。%SPEECH_ON%付钱给这佣兵。%SPEECH_OFF%一位指挥官递给你一袋%reward_completion%克朗，你很快就被请出了房间。 | 一个长得酷似%employer%的人在贵族房间里等候你。他要求你交出圣物，你照做了。那人停顿片刻，拿着圣物，眼睛四下扫视。最后，他将它放在地上喊道。%SPEECH_ON%看起来没问题！%SPEECH_OFF%突然，真正的%employer%从房间一侧现身，谨慎地走上前来。%SPEECH_ON%抱歉搞得这么夸张，但世上存在一些你无法理解的力量%SPEECH_OFF%你怀疑圣物是否会活过来变成刺客，但也不愿质疑贵族这明显疯狂的思路。你收下%reward_completion%克朗，愉快地离开了。 | %employer%在房外与你碰面。他脸色通红冒着汗，看起来几乎是在把守房门。%SPEECH_ON%晚上好，佣兵。我要的东西带来了吗？%SPEECH_OFF%你递过圣物。那人咧嘴一笑，给了你一袋%reward_completion%克朗。他转身要回房间，又停住了。%SPEECH_ON%嘿，走吧。我付钱不是让你站着围观我干什么的。%SPEECH_OFF%你点头离开。走的时候，你听到门开了，一阵女人的嘈杂声迅速逸出，随即门又关上了。 | %employer%的一名护卫带你到花园，贵族正在照料作物。他在教一个小男孩修剪番茄。%SPEECH_ON%剪茎，你这白痴！剪这里，明白吗？怎么能戳食物呢？永远别戳食物！佣兵！%SPEECH_OFF%这位领主一看到你就猛地直起身。他把男孩推到一边，走过来问你是否拿到了圣物。你交出去，收到了%reward_completion%克朗作为回报。贵族点了点头。%SPEECH_ON%你干得不错，雇佣兵。我对别人执行我要求的能力正失去信心。我相信你懂我的意思。%SPEECH_OFF%越过贵族的肩膀，你看到那男孩正在毁坏另一株植物。你缓缓点了点头。 | 你将圣物交给%employer%。他皱着眉头盯着它，手指恼怒地在桌面上滚动。%SPEECH_ON%嗯，我想就是这个了。有点失望，但约定就是约定。%SPEECH_OFF%他不情愿地滑给你一袋%reward_completion%克朗。 | %employer%迎你进房，递给你一杯酒。你喝着酒，一位学者过来取走了圣物。他走到房间一侧开始测量、称重，甚至……品尝它？你无视那边进行的任何测算，询问你的报酬。%employer%咧嘴笑了。%SPEECH_ON%你正喝着它呢！%SPEECH_OFF%你停下悬在唇边的酒杯。贵族笑了。%SPEECH_ON%开玩笑的，佣兵，放松！给，%reward_completion%克朗，说好的数目。%SPEECH_OFF% | 你推开%employer%的房门，看见贵族和几位学者站在一张桌前。形状奇怪的瓶罐遍布各处，有些装着更奇怪的颜色。一位学者匆忙向你走来，手从宽大的袖口中射出，如同毒蛇刺出洞穴。他一手夺走圣物，另一手将一袋%reward_completion%克朗猛拍在你胸前。%employer%挥手让你离开。%SPEECH_ON%走吧，雇佣兵，你已完成了我们的要求，目前你的服务就到此为止。%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "获得了一件对战争有重要意义的圣物");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isUndeadScourge())
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

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hurtbro",
			this.m.Dude == null ? "" : this.m.Dude.getName()
		]);
		_vars.push([
			"historian",
			this.m.Dude == null ? "" : this.m.Dude.getNameOnly()
		]);
		_vars.push([
			"objective",
			this.m.Flags.get("DestinationName")
		]);
		_vars.push([
			"nemesis",
			this.m.Flags.get("NemesisName")
		]);
		_vars.push([
			"nemesisS",
			this.m.Flags.get("NemesisNameS")
		]);
		_vars.push([
			"nemesisC",
			this.m.Flags.get("NemesisNameC")
		]);
		_vars.push([
			"bribe",
			this.beautifyNumber(this.m.Payment.Pool * 0.4)
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Destination.getTile())]
		]);
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
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isUndeadScourge())
		{
			return false;
		}

		return true;
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
