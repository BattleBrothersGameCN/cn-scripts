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
		this.m.Name = "战役";
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
			"乌鸦",
			"狐狸",
			"私生子",
			"猫",
			"狮子",
			"将军",
			"土匪男爵",
			"车头(Rook)"
		];
		local nemesisNamesC = [
			"乌鸦",
			"狐狸",
			"混血儿",
			"猫",
			"狮子",
			"将军 ",
			"强盗 男爵",
			"车(Caption)"
		];
		local nemesisNamesS = [
			"雷文",
			"狐狸",
			"私生子",
			"猫",
			"狮子",
			"常规",
			"强盗男爵",
			"磨具"
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
					"从%objective%处取回神器，前往%direction%。"
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
					"追上 %nemesis% 并取得神器"
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{你发现%employer%正在看着一堆地图，用着最初绘制它们时用的工具筛选着它们。他抬起头，脸上带着地图制作者那种紧张的表情。%SPEECH_ON%我的文书们给了我这些地图，告诉我他们找到了一个名叫\'%objective%\'的地方。据说在那里的大厅、走廊或者其他地方隐藏着巨大的力量。%SPEECH_OFF%你挑了挑眉毛，但他坚持下去。%SPEECH_ON%看，我的文书们真心相信无论是什么在那里都可能帮助我们找到这些不死族的解药。但他们也告诉我，其他人也在寻找它。我需要你比任何人都先到达那里。%SPEECH_OFF% | %employer%展开了一张地图，纸在他的头到脚之间立起。他的手指绕着其中的一边，在某个点上打下标记。%SPEECH_ON%看见了吗？这就是\'%objective%\'。一个我......其实并不知道很多的地方。但我所知道的是其他人都在前往那里，声称要获得一件拥有巨大力量的神器。我的文书相信这个神器或许可以帮助我们抵御这些不死族。显然，我希望你在他们之前赶到那里！%SPEECH_OFF%} | %employer%给你一张地图，特别指出了上面的某个地点。%SPEECH_ON%那就是所谓的\'%objective%\'。传言说有其他人正在寻找它。我的文书虽然不喜欢听传言，但他们认为这里有一个我们可以用来对抗不死族的特定物品。这个区域位于敌对领地深处，我有理由相信你不会是唯一的寻找者。前往那里，把物品带回来，我会给你丰厚的奖励。%SPEECH_OFF% | 当你见到%employer%时，他匆忙地请你到他身边阅读一本书。你看到了一种你从未见过的语言，但书中还有一张地图并不需要翻译，上面标注着一处地点，被一支羽毛笔重重圈了起来。%employer%敲打着地图。%SPEECH_ON%卖剑客，我需要你去那里。他们叫它\'%objective%\'。我的文书说里面有一个非常强大的物品，我们可以用它来对抗不死族。当然，这样的物品不会就这么随便放在外面。我很期望各种各样的人和生物都会在那个区域徘徊，被这种物品的力量所吸引！你需要去取得它并把它带回来。%SPEECH_OFF% | %employer%欢迎你，迅速地描述了一个叫做\'%objective%\'的地方，那是从你所在的位置往%direction%的可怕地方。%SPEECH_ON%我的文书说，这个区域藏有一件能够帮助我们抵御不死族攻击的巨大能量神器。当然，他们可能只是想让我去买他们想研究的东西。但是现在，我相信他们。我需要你去那里找到它。巨大的能量是有磁性的，所以我不认为只有我一个人去那里探险，你明白吗？去把它带回来，你将得到相应的奖励。%SPEECH_OFF% | 你看到一名文书倾听着%employer%的耳边，并不断低语。看到你后，他迅速解释了情况。%SPEECH_ON%佣兵！我得到了消息，某个%direction%的地方藏有一个我们需要获得的巨大能量。我认为它将帮助我们抵御不死族的攻击。当然，如果它真的有这个能力，那么我们可以轻易地想象其他人也会寻找这个物品！因此，速度是最重要的。我要你去那里然后回来。%SPEECH_OFF% | %employer% 正在走过他的私人墓地，他站在一块墓碑前。%SPEECH_ON%每晚，我都担心这些墓碑会动起来，我的祖先会起来销毁我因为我的失败。%SPEECH_OFF%他转过身来，面带冷笑地看着你。他带你进入家中，那里有个老人正在看着一张完全覆盖了他桌子的书。 %employer% 告诉你和这个老人谈话，然后站在门口。你坐在老人对面，他放下羽毛笔。%SPEECH_ON%{ 我的君主允许我告诉你所有你需要知道的事情。我已经确定了一个位于这里%direction%的强大的遗物，名为\'%objective%\'。我相信这个遗物可能包含解决这个死亡问题的力量...让死人再次活过来。我还相信这种力量不会在这个世界中被忽视。你需要前去那里，击败任何认为它属于他们的人，然后回到我们这里。 | 欢迎，佣兵。我并不经常向你这样的求职者求助解决问题。一本好书和一个安静的晚上曾经足以满足我，但现在不行了。我们需要你前往%direction%的一个地方，叫做\'%objective%\'。我们有理由相信它可能包含我们走在行尸走肉苦海中遇到的难题的答案。当然，这样的力量是一种强大的诱惑。你需要快速到达那里并返回，以免我们失去它。}%SPEECH_OFF% | %employer%的身旁站着一位抄写员。两个人都在看一张纸。当你靠近时，他们缓缓地将它推过桌子让你读。看起来这位抄写员已经找到了一个极具力量的地方，他们相信这个地方可能包含解决行尸走肉之灾的方案。%employer%认为很多人也会寻找它，速度至关重要。 | 你发现队长正在和一名抄写员交谈，两人的鼻子都低头看书，中间还有一支摇曳的蜡烛。在听到你的声音后，队长迅速抬起头来，解释了眼前的情况：他们已经破解了一件重要 Relic 的位置，这可能包含着对阻止不死者复活的答案。队长恭敬地点点头，继续说到：%SPEECH_ON%我们有理由相信，你去寻找它时不会孤单，也不会很安全。%SPEECH_OFF% | %employer% 拿起火把并走下去带你到一个墓穴。你看着可怕的雕像从黑暗中浮现出来，贵族的火苗点亮了阴影和幽灵。他停在一个雕像前然后转身。%SPEECH_ON%这是我父亲。仔细聆听。%SPEECH_OFF%你把耳朵贴在巨大的石棺上，听到了微弱的刮擦声。%employer% 摇了摇头。%SPEECH_ON%我的文书已经破译了一个所谓的伟大遗物的位置。它位于这里%direction%一个叫做\'%objective%\'的地方。它可能包含结束这场疯狂的力量。当然，这样的力量在这个世界上永远不会安静地存在。我们希望许多其他人，无论是人类还是其他种族，都会在附近的遗迹里。去那里，佣兵，将它带回来，你就会得到回报。%SPEECH_OFF%他把火把挥回棺材那里，发出了一声闷闷的低吼。%SPEECH_ON%为了我和他们的利益。%SPEECH_OFF% | %employer%和他的书记把你带到了地下墓穴。在那里，你找到了一个被打开的棺材。两个卫兵拿着长矛推开一个可怕的腐烂女人，防止其攻击。当火光映照在她消瘦的身形上时，她咆哮着咬牙切齿。%employer%转向你。%SPEECH_ON%我们不知道这是什么或者是什么引起了它，但我们认为一个被称为\'%objective%\'的地点在我们%direction%。那里可能包含答案。据说那里有一个强大的神器，我需要你把它带回来。我的书记说你应该准备迎接未知的危险。%SPEECH_OFF%走路的死女孩咆哮着向前跳动起来，将自己刺上一把剑并将其推向下面。书记点点头，%employer% 继续说道。%SPEECH_ON%如果它可以结束这种折磨，谁知道它还能做什么。%SPEECH_OFF%",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{我相信你会为这样的危险旅行付出足够的报酬。 | 那离这里还很远，所以最好报酬丰厚。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{这不值得。 | 这太远了。 | 我们有更紧迫的事情要处理。 | 我们还有别的地方要去。}",
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
			Title = "在 %objective%",
			Text = "[img]gfx/ui/events/event_57.png[/img]{好的，废墟。让我们看看%employer%和他那些愚蠢的抄写员们在说些什么。 | 你来到了废墟，周围没有太多东西，这让你感到不安。你让%companyname%为最坏的情况做好准备。 | 最终，你来到了一个据说有伟大文物的地方。是时候看看%employer%和他的抄写员们是否真的知道他们在说什么了。 | 废墟倾斜地崩塌着，似乎预示着什么。一大群蝙蝠突然尖叫着飞了出来，%randombrother%躲闪着，其他人都哈哈大笑。 | 你找到了%objective%，站在旁边的小山上。往下看，你可以看到为什么它被隐藏了那么久，这里如此不起眼。即使从这里，你也可以听到风穿过它的石制建筑的声音。 | 你到达了%objective%，%randombrother%像你预想的那样评估着它。%SPEECH_ON%看起来烂透了。我们继续吧，好吧？%SPEECH_OFF%希望他是对的。} | %randombrother% 直起身来。 %SPEECH_ON%该死，我想就是那里了。%SPEECH_OFF% 他盯着一座废墟的群落，看起来确实是 %objective%。 他拍手搓着手。%SPEECH_ON%那我们开始吧。我发誓去，如果那里有不死族，即使我死后很久也要抱怨个没完没了。%SPEECH_OFF% | %randombrother% 望着远处的 %objective%。%SPEECH_ON%那么，你觉得那里有什么？我觉得 %employer% 在骗我们。我们走进去可能会被一群漂亮的女人迎接。这是对工作努力的男人的奖励，你知道的。%SPEECH_OFF% 基于某些原因，你不认为会是这种情况。 | %objective% 离这里很近。从这里，你只能看到倾斜的石结构，但是异味弥漫的距离遥远。%randombrother% 捂住鼻子。%SPEECH_ON%嗯，闻起来像我姨婆的屎。如果那婊子也在里面，我一点不会惊讶。%SPEECH_OFF% | 靠近 %objective%，你告诉你的战友们准备战斗。谁知道这些禁地里等待着 %companyname% 呢！ | 当你接近%objective%时，轻柔的耳语从你身边传来。%SPEECH_ON%{进去。进去。这是最好的选择。你会喜欢这里的，没错。我们同意，是的我们同意。请快点，我们等不及了！ | 你不是第一个。你不是第一个。你也不会是最后一个。你也不会是最后一个。 | 愚蠢的人，你以为你的想法是你自己的吗？ | 你的人会背叛你。他们认为你无用。回去吧，你这个卑劣的昆虫。 | 在这里你来了，你就会永远在这里。 | 啊，更多的人类。我几乎无法忍受在这种状态下你的气味。你对我呼吸的空气是有毒的。让我来处理你。我会让你的肚子变腐，你就会更好… | 你这个勇敢的小人，来到这里，但你只是一件标本而已。恐惧会充满你的心，直到没有任何其他东西的空间。然后你会死。就是这样，就会是这样。 | 来吧，小人类。这是我一直想让你待的地方。 | 太好了！你终于来了！很高兴见到你，人类，真的非常高兴见到你！%SPEECH_OFF% | 啊，又来了一只残忍的野兽。它是多么愚蠢的小东西啊。是的，非常愚蠢。我们该怎么办呢？当然要让它进来。当然！}%SPEECH_OFF%%randombrother% 用手指挖了挖耳朵.%SPEECH_ON%先生，你说什么了吗？%SPEECH_OFF%你摇了摇头，匆忙告诉手下们准备好应对任何情况。 | 当你靠近%objective%时，轻柔的耳语从你身边传来。%SPEECH_ON%{进来。进来。这样做是最好的。你会喜欢这里的，是的，我们同意。是的，我们同意。请快点，我们等不及了！ | 你不是第一个。你不是第一个。你也不会是最后一个。你也不会是最后一个。 | 傻瓜，你以为你的想法是你自己的吗？ | 你的部下将背叛你。他们认为你无用。回去吧，你这个龟缩的昆虫。 | 在这里，你将永远存在。 | 啊，又来了更多人类。我几乎无法忍受你们在这种状态下的气味。你们毒害了我的呼吸空气。让我处理你们。我会让你们的肚子腐烂，你们会变得更好…… | 敢来此处的小人啊，你只是一个微不足道的样本。恐惧将填满你的心，直到没有任何其他空间。然后，你就会死。如此就是，如此就会。 | 来吧，小人类。这就是我一直想让你到达的地方。 | 是的！你终于来了！很高兴见到你，人类，非常高兴！ | 啊，又来了一只残忍的野兽。这是多么愚蠢的小东西啊。是的，非常愚蠢。我们该怎么做呢？当然要让它进来。当然！}%SPEECH_OFF%%randombrother%捏了捏耳朵。%SPEECH_ON%你有什么需要说的吗，先生？%SPEECH_OFF%你摇了摇头，匆忙告诉人们做好准备迎接任何事情。",
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
			Title = "在 %objective%",
			Text = "[img]gfx/ui/events/event_57.png[/img]{终于拿到了神器。在你手中它的重量似乎不对劲，仿佛它应该很重，但似乎有什么东西让它人为地变轻了。你把它装进口袋，准备回到你的雇主%employer%那里。 | 你现在拥有了你一直在寻找的神器。如果实话实说，它有点让你失望。你的一部分希望它能给你巨大的力量，但它只是闲置在你手里。也许你不是被选中的人。 | 你拿着神器，无视它发出的微弱嗡鸣声，准备回到%employer%那里。 | 你拿起神器仔细观察。%randombrother%走上前来，双手插腰。%SPEECH_ON%喔，这丑陋的东西不值得这么多钱。%SPEECH_OFF% | 你在手中称量神器，它时轻时重。好吧，这很奇怪，你迅速把它塞进了一个小袋里。 | %randombrother%在你收起神器之前看了看它。%SPEECH_ON%看起来不是什么大不了的东西。%SPEECH_OFF%你告诉他，很多具有强大力量的东西看起来都不起眼。他坐在那里想了想。%SPEECH_ON%我的屁看起来什么都不是，所以也许你是对的。%SPEECH_OFF% | 你把神器交给%randombrother%。他拿起来看。%SPEECH_ON%如果我现在把它打碎，你会生气吗？%SPEECH_OFF%你瞪了他一眼。%SPEECH_ON%是啊，我会有点生气。但也许里面有些小鬼会为打破他们的家而让你永远不得好死，谁知道呢？%SPEECH_OFF%佣兵迅速把神器装进了一个小袋里。 | 你看着神器。它毫无生气，一动不动，不像应该拥有伟大力量的东西，但不知为什么，看起来令人不安。你迅速把它塞进了一个小袋里。 | 你把神器放进小袋里，结果它开始发光，并呼唤你。打开小袋，你看到两个红点瞪视着你。%randombrother%问你是否一切正常。你迅速关上小袋，点了点头。 | 你终于有了这件神器。神器既不闪光，也不发出嗡鸣声，甚至看起来不那么漂亮。你不确定为什么会出现这么大的骚动，但如果%employer%愿意买它，那就是他的事。 | 好了，你得到了神器。%randombrother%走过来，挠了挠他的头。%SPEECH_ON%这么多人为了这个小东西白白牺牲？%SPEECH_OFF%神器发出嘎嘎声，一个低沉的声音回答道。%SPEECH_ON%他们没死，他们现在和我在一起，永远永远。%SPEECH_OFF%佣兵跳了回来。%SPEECH_ON%你知道吗？我没有听到那个声音。我不知道那是什么。我不在意。我就去吃又硬又不新鲜的面包，过着无聊的生活。%SPEECH_OFF% | 你拿着神器，用一块布把它和你隔离开来，以防它的力量渗透到你的皮肤里。当然，看起来它只是一个漂亮的石头，但小心谨慎总是没错的。对你来说，%employer%应该很高兴看到它，他可以按照自己的意愿拿着它。 | 神器看起来很奇怪，但并没有什么太特别的。你甚至觉得这只是某个流浪汉的作品，被其他人用作神器。%randombrother%盯着它看。%SPEECH_ON%如果我真的很诚实，我看过的东西比它好看多了。%SPEECH_OFF%你警告他，如果这个遗物真的拥有力量，他可能会为那个评论付出代价。他耸耸肩。%SPEECH_ON%但这都是事实。%SPEECH_OFF% | 你举起神器，突然它变得异常沉重，回到你的手中。当你将它向脚降低时，它变轻了，仿佛渴望被抱起来。对于你来说，这够奇怪的，所以你迅速把它藏起来，准备返回%townname%的%employer%那里。 | 终于，你拿到了神器。当%randombrother%走近时，你正在盯着它看。%SPEECH_ON%这就是%employer%想要的东西？喔，我本来可以制造出这样的东西，省去了我们所有这些麻烦。%SPEECH_OFF%你把神器藏到一个袋子里回应。%SPEECH_ON%我想他最终会知道那是假的。%SPEECH_OFF%佣兵举起指头。%SPEECH_ON%关键字：最终。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们已经得到我们来这里的东西了。是时候回去了！",
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
			Text = "[img]gfx/ui/events/event_42.png[/img]{正在前行的路上，历史学家%historian%看到你盯着地图发呆。他问可以让他看看，你答应了。他拿着地图，远远近近地看了看。%SPEECH_ON%我们走错路了。%employer%的抄写员肯定读错了这个符号。你看这个符号，其实意思是……%SPEECH_OFF%他停顿了一下，意识到他要说的话不太可能让你明白。于是他笑了笑。%SPEECH_ON%好吧，基本上我们需要往这个方向走。%SPEECH_OFF%他拿出一支羽毛笔并做了一个更正。 | %historian%历史学家正在看%employer%给你们提供的其中一个地图。他停下来问道。%SPEECH_ON%你说贵族的抄写员制作了这张地图？因为它完全是错的。看看这里。%SPEECH_OFF%他把地图给你看。%SPEECH_ON%他们读错了这些语言。这不是文字，而是谜题。只有你正确地解读它们，才能带领你到这里。%SPEECH_OFF%他指着一个完全不同的地方，比你之前的方向要远。看来%companyname%需要改正航向。 | %historian%历史学家正在看着一张地图，摇着头。%SPEECH_ON%阁下，我们走错路了。%employer%的抄写员误读了这里的符号。我们需要改变方向。%SPEECH_OFF%你想质疑这个人的假设，但相信与%companyname%同行的勇敢历史学家比贵族高塔里煮出的陈年老人要准。 | %historian%拿起%employer%给你的地图并审视它。%SPEECH_ON%对，错了，我们走错路了。你看这个？这里的字母竖直和水平颠倒，这是一个谜题，贵族的抄写员错误地认为他们已经解决了这个难题。%SPEECH_OFF%你问这是否意味着你走错了路。%historian%点了点头。%SPEECH_ON%是的，我出现在这里很幸运，不是吗？%SPEECH_OFF% | %employer%给你的地图上满是你不理解的曲折符号，好像有人随手涂鸦了整个语言。%historian%历史学家走过来，边吃边说话。%SPEECH_ON%地图是错的。%SPEECH_OFF%你擦掉地图上的饼干屑，问他是什么意思。他笑了。%SPEECH_ON%我的意思是地图是错误的。%employer%的抄写员不知道在看什么。那边的岩石组合就是我们应该去的地方。顺便说一下，你要吃点吗？%SPEECH_OFF%他递给你一口，但你拒绝了。%SPEECH_ON%你的损失。我该告诉士兵们我们改变了航向吗？\n%SPEECH_OFF%你叹了口气，点了点头。}",
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
			Text = "[img]gfx/ui/events/event_42.png[/img]你来到了你认为应该是的地方。但是……这里什么都没有。你仔细看着地图，意识到了自己的错误。显然，这里有两个岩石形成的景点，一个是{拿着剑的人 | 遭到旧神攻击的教堂 | 带有脸庞的巨型土豆 | 美丽曲线的女人 | 那只遛人的狗 | 用后腿拍打试图从碗里吃汤的小女孩的熊 | 一个年轻男子看着云彩，云彩的形状像兔子却被%randombrother%说是狗，让你和他意识到你们正在争论一群云朵的形状，而这时它们正在被一位云朵观察者所注视}。你在地图上做了一个记号，前往真正的目的地，希望这次误入歧途的小旅行没有浪费太多时间。",
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
			Title = "在 %objective%",
			Text = "[img]gfx/ui/events/event_57.png[/img]当你走进房间，希望找到遗物时，你看到的只有一个空的基座和一张纸条。纸条上写着：%SPEECH_ON%{看起来你的手下又迟到了，%employer%。还记得你曾和我一起合作吗？这就是你的下场！ | 啊哈！是的，我写了那个，因为我看到我又一次领先于你，%employer%！你还是雇了一群无名佣兵，真是太便宜了。下次好运。 | 如果你在看这个，那么你们太慢了，%employer%误解了，没有雇用我。唉，遗物现在在我手里。现在把你们拖回去告诉你的雇主你们失败了。 | 如果你在看这个，那么你们很可能是那群被%employer%雇用代替我的佣兵。看看他是多么错了！还有你们是多么慢！你们大概是铁了心，看不到这个字。 | 嗨，雇佣兵，太遗憾我不能亲眼看到你读这封信时的表情。嗯，我们不能总是得到自己想要的。遗物在我的手中而不是你的手中，这一点足以说明问题。下次好运，你们这些输家，向%employer%问好。}%SPEECH_OFF%在底部，有个人署名为“%nemesis%”。你不知道他是谁，但现在他已经名存实亡。一些脚印暗示了这个家伙走的方向。",
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
						local party = this.World.FactionManager.getFaction(camp.getFaction()).spawnEntity(tile, this.Flags.get("NemesisNameC"), false, this.Const.World.Spawn.Mercenaries, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
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
			Text = "[img]gfx/ui/events/event_07.png[/img]{顺着他们的足迹，你们追上了%nemesis%和他的手下。你们确认是他们，因为团队中最大的混蛋手持遗物。看起来这个人可以用实力证明自己，周围围着一群武装士兵。你们需要小心接近。 | %nemesisC%并没有像他那俗气、侮辱性的消息所说的那样难以寻找。但毫无疑问，他的保镖很充足。一群手持武器和盔甲的人围着那个混蛋，他贪婪地盯着手中的遗物。为了取回这件宝物，%companyname%应该仔细思考如何应对这种局面。 | 你发现一个人正盯着你们想找的遗物看。一定是%nemesis%！就在你们准备直接上去杀死他时，%randombrother%拉住你的衣服把你拖回来，他指向前方，那里出现了一群武装士兵。%companyname%应该谨慎处理这种局面。 | 这些足迹并不难追踪。最初你以为是因为这位%nemesisS%很白痴，但结果表明他很有保镖。你发现他手持遗物，被一群武装警卫完全包围着。你们之所以来这里，是为了战斗，但也许还有其他方式？ | 你发现%nemesis%手持这件遗物。他看起来容易收服，也留下了大量的足迹，可能是无知或自信心过于满满。就在你拔剑时，%randombrother%阻止了你。他向前点了点头。\n\n你注意到一群人向%nemesis%走来，询问他的命令。他们是他的随从，而且装备精良。要取回这件宝物，也许需要比你想象的更多的流血。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "你犯了一个可怕的错误，挑战了%companyname%。这是你的最后一次机会。",
					function getResult()
					{
						this.Contract.getActiveState().onCombatWithNemesis(this.Contract.m.Destination, false);
						return 0;
					}

				},
				{
					Text = "这里没有人需要死。以%bribe%克朗的代价交换神器，你怎么说？",
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
			Text = "[img]gfx/ui/events/event_11.png[/img]{终于，你得到了这件神器。它在你的手中感觉很轻，似乎本该很重，但有些东西让它保持着轻盈的状态。你将它装入口袋，准备返回%employer%。 | 你现在拥有了你一直在寻找的神器。坦白说，有点令人失望。你内心有一部分希望它会给你无限的力量，但实际上它只是呆呆地躺在你的手中。也许你只是不是被选中的人。 | 你拿起神器，忽略了它传出的微弱嗡嗡声，准备返回%employer%。 | 你拿起神器仔细地看了一眼。%randombrother% 走上来，双手叉腰。%SPEECH_ON%见鬼，这丑陋的东西不算什么贵重物品吧。%SPEECH_OFF% | 你将神器在手中称了一下重，感觉轻重不定。哦，够奇怪的，所以你快速地把它塞进提包里。 | %randombrother%在你将神器放入提包之前看了一眼。%SPEECH_ON%看起来不怎么样。%SPEECH_OFF%你告诉他许多有力之物却并不起眼。他坐在那里，想了想。%SPEECH_ON%我的屁也没什么好看的，所以我想你是对的。%SPEECH_OFF% | 你把神器交给了%randombrother%，他拿起来高举着。%SPEECH_ON%如果我现在把它摔碎了，你会生气吗？%SPEECH_OFF%你瞪了那个男人一眼。%SPEECH_ON%嗯，有点吧。但也许里面有小恶魔，他们会因为你破坏他们的家而永世诅咒你。谁知道呢？%SPEECH_OFF%雇佣兵迅速把神器放进了口袋里。 | 你看着这件神器。它是空白的，静止不动，不像是一件具有强大力量的物品，但出乎意料的是，这恰恰是最令人不安的地方。你迅速把它放进了口袋。 | 你把神器放进了口袋里，却突然发现它开始闪光并呼唤着你。打开口袋，你看见两个红点看着你。%randombrother%问你是否没事。你迅速地把口袋拉上并点了点头。 | 你终于得到了这件神器。它不会发光，不会发出嗡嗡声，甚至看起来都不是那么漂亮。你不确定到底有什么了不起的地方，但如果%employer%想为此付钱，那是他的问题。 | 你得到了神器。%randombrother%走过来，揉了揉他的头。%SPEECH_ON%为了一点小东西，这么多人都死了？%SPEECH_OFF%神器发出响声和低沉的声音回答说。%SPEECH_ON%他们没有死。他们现在和我在一起，永远不会离开。%SPEECH_OFF%佣兵跳了回来。%SPEECH_ON%你知道吗？我没听到那个。我不知道那是什么。我不在乎。不，我只想回去吃那块又硬又难吃的面包，过一种平淡的生活，非常感谢。%SPEECH_OFF% | 你拿着神器，使用一块布把它和你隔开以防其力量渗入你的肉体。当然，它只是一块看起来很华丽的石头，但小心一些没有坏处。%employer%应该很高兴看到它，以你的看法，他可以随便拿着它。 | 这件神器看起来很奇怪，但没什么特别之处。你甚至觉得它可能是某个乞丐的玩意，被别人当作神物。%randombrother%盯着它看。%SPEECH_ON%说实话，我拉了比它漂亮的东西。%SPEECH_OFF%你警告他，如果这件文物确实有力量，他就要为这个评论付出代价。他耸耸肩。%SPEECH_ON%不过，这不改变事实。%SPEECH_OFF% | 你提起圣物时，它突然变得沉重，被逼回地面。当你把它向脚边放下时，它会变得轻盈，仿佛想再次被举起。这对你来说已经够奇怪的了，所以你迅速将其收好，准备回到%employer%那里。 | 终于，你得到了神器。你盯着它看的时候%randombrother%走近了。%SPEECH_ON%这就是%employer%想要的？该死，我本来可以制造一个这样的东西并节省我们所有的麻烦。%SPEECH_OFF%你将圣器装进一个袋子里并回应道。%SPEECH_ON%我想他最终会知道这是假的。%SPEECH_OFF%雇佣兵举起他的手指。%SPEECH_ON%关键字：最终。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们已经得到了我们来这里寻找的东西。是时候回去了！",
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
			Text = "[img]gfx/ui/events/event_07.png[/img]{贼头头笑了笑，摇了摇头。%SPEECH_ON%你是认真的吗……我是说，真的吗？%SPEECH_OFF%他向前走了一步。%SPEECH_ON%这个想法不错，但是答案还是不行。%SPEECH_OFF%他缓缓拔出他的剑，光芒闪耀着，指向你。%SPEECH_ON%谢了，不过不用了。%SPEECH_OFF% | 你试图贿赂，但没有成功。不仅如此，这些贼还感到受辱并开始攻击你们！很明显，这些贼窃贼有道。 | 首领嗤之以鼻。%SPEECH_ON%贿赂？没有。我们没有来到这里并遭受我们的苦难只为了做一个琐碎的交换。男人们，你们说是时候让他们受苦了吗？%SPEECH_OFF%一路欢呼着，盗贼们拔出了他们的武器。他们的领袖将刀指向了%companyname%。%SPEECH_ON%准备死吧，雇佣兵。%SPEECH_OFF% | 你发出了贿赂，但很快被拒绝了。匪徒领袖和你点头示意。有一件事是明白的：你们两者之间没有一个人会空手而归。准备战斗！ | 匪徒们聚在一起低声交谈。最后，首领走出来，双手插腰，充满自信。他摇了摇头。%SPEECH_ON%我们谢绝你的提议。现在，让我们通过，否则准备好战斗吧。%SPEECH_OFF%%employer%没有让你们空手而归。你命令%companyname%列队战斗。匪徒叹了口气，拔出他的剑。%SPEECH_ON%就这样吧！%SPEECH_OFF% | 匪徒们嘲笑你的提议。看起来他们也认为这是一种软弱的表现，因为他们都拿出了武器。你认为这个提议非常公平，但看起来这些人希望用最终的代价来出售这个物品。那就是这样。准备战斗！ | 盗贼的头领笑了。%SPEECH_ON%一个有趣的提议，但不行。我想我们俩都知道这件小古董的价值，甚至比你能提供的任何东西都要高。现在让开。%SPEECH_OFF% %companyname% 排出队形，拔出武器。%randombrother% 吐了口口水。%SPEECH_ON%我们可以全部干掉他们，长官，只需下命令。%SPEECH_OFF%你对%companyname%有着绝对的信心，因为它是个行凶的团体。该练习我们所说的话了！ | 匪徒领袖伸手到一个袋子里取出一个头。头是灰色的，用头发夹住在他的手指间。%SPEECH_ON%这就是上一个挡住我们的人的下场。你的提议我们尊重地拒绝了，雇佣兵。现在让开或者后果自负。%SPEECH_OFF%你笑着回应。%SPEECH_ON%我们是%companyname%，可惜没有人知道你是谁，因为在我们杀光你们之后就没有什么好吹嘘的了。%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_07.png[/img]{经过一番讨论，盗贼同意了你的提议。你交出了克朗，他们交出了神器。这比预期的要容易。 | 强盗们在一起小声议论，偶尔看向你。考虑到几分钟后你们可能会为了他们的决定而相互残杀，这是一个奇怪的经历。最后，他们停止了讨论，领袖向你挥手示意。%SPEECH_ON%我们的雇主不会高兴，但那些克朗的确很难放弃。你做了一个交易，雇佣军。%SPEECH_OFF% | 破坏者争论你的提议。一些人说，如果他们空手返回，他们的雇主将会非常不满，而另一些人则表示这不值得为之而死。后者赢了。你用克朗换回了神器。 | 一个有荣誉感的队伍可能会试图与%companyname%作战，但你们是在与盗贼打交道，而不是最有荣誉感的人。他们同意用克朗交换神器。 | 盗贼头目抽出了他的剑。%SPEECH_ON%你真的认为我们会接受那个…%SPEECH_OFF%一股鲜血喷涌而出，打断了他的话语，并溅在了从他的胸口突然伸出的剑的长度上。强盗的眼睛翻了回去，他的杀手踩在他背上，将他从剑上踢开。杀手收拾了他的武器。%SPEECH_ON%我们不打算为那个傻*死。你的提议被接受了，雇佣兵。%SPEECH_OFF% | 盗贼之间爆发了争吵。有些人认为他们可以打败你，而另一些人则更清楚%companyname%是谁，而后者则非常强烈地反对任何敌对行动。最后，他们达成了一致意见：贿赂被接受了。 | 你提出付出代价以换取那件神器的提议引发了盗贼之间的激烈辩论。他们低声争吵，但他们的眼神似乎表明他们认为你是最具存在感的威胁。最后，他们打破了僵局，并接受了你的条件。你很高兴这没有演变成流血事件。 | 盗贼嘲笑。%SPEECH_ON%你觉得我们能空手回到我们的恩人那里吗？%SPEECH_OFF%你抚摸着头发回答道。%SPEECH_ON%总比不回去强，是不是?%SPEECH_OFF%每个盗贼都谨慎地后退一步，他们的领袖摇了摇头，然后又点头。%SPEECH_ON%见鬼，佣兵，你让我们左右为难了。但好吧，我们会接受的。%SPEECH_OFF%文物被交出，暴力被避免。 | 盗贼的领袖转向他的团伙，真诚地问道。%SPEECH_ON%你们怎么看，伙计们，觉得我们能打败他们吗？%SPEECH_OFF%一个耸了耸肩。%SPEECH_ON%我觉得我们能赚到他们提供的金子。%SPEECH_OFF%另一个人插了嘴。%SPEECH_ON%这只是一次探险，我们没有足够好的薪水为了这该死的文物去死。%SPEECH_OFF%慢慢地，强盗们达成一致：他们会接受贿赂而不是被屠杀。从大多数指标来看，这是一个明智的举动。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "你做了正确的决定。",
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
					text = "你花费了 [color=" + this.Const.UI.Color.NegativeEventValue + "]" + bribe + "[/color] 克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "Trap",
			Title = "在 %objective%",
			Text = "[img]gfx/ui/events/event_12.png[/img]{你跨过了一个绊线并告诉%hurtbro%要小心。他没有听，因为他的疏忽吃到了机关陷阱。 | 废墟的地面布满了明显的陷阱和致命的小玩意。你们可以毫不费力地通过它们直到%hurtbro%，他觉得这里很安全地向前冲。古老的机械被触发了，你以为整个地方都要倒塌在你们的头上。幸运的是，只有这个雇佣兵因过于鲁莽而付出了代价。 | 废墟布满了陷阱，%hurtbro%设法引爆了其中一个。 | %hurtbro%的脚踩在一个砖块上，很快就陷了下去。古老的机器在墙后隆隆作响，天花板开始倒塌。尽管有很多噪音，但这个机关本身很小，雇佣军将活下来。 | 墙上的字形通过图片表达着古老的沉思。不幸的是，这些线条太简陋，以至于你们没能意识到它们实际上是警告标志，直到为时已晚：%hurtbro%走入一个陷阱，因为你翻译得太烂，他惹了很多麻烦。 | 你应该知道得更好：废墟布满了陷阱，%hurtbro%直接走进了其中一个。他会活下来，而你从现在开始会更加安全。 | %hurtbro%引爆了一个陷阱，因为他缺乏谨慎，吃了很多痛苦。 | 很久很久以前，有个人坐下来制作了一个陷阱。今天，%hurtbro%直接跑进去了。 | 你引爆了一个绊线，听到古老的机器轰鸣。你赶紧躲开，只见%hurtbro%不幸中了陷阱的重点。哎呀…… | 你看到地上有一条绊线，哈哈大笑。古老的陷阱制造者，又差一点点——突然，%hurtbro% 在你身边经过，触发了陷阱。这个白痴还活着，但是他的未来充满了痛苦。 | %hurtbro%吹着口哨，旋律飘进遗迹的深处，但是回声似乎有些不对，就像在墙里打嗝。你叫住了队伍，但是吹口哨的人还是走到前面，然后掉进了一个坑里。赶到边缘，你看到他刚好避开了一些尖刺。 | 当%hurtbro%在遗迹中行走时，他触发了一个陷阱，使他从楼上坠落。他落在一个布满洞口的较低楼层。尖刺出现了，但是足够缓慢，让他躲过去。幸运的是，陷阱的触发顺序不对，你设法让这个佣兵脱险了。 | 在穿越这座令人迷惑的废墟时，%hurtbro% 突然从视野中消失了。你冲到他原来的位置，差点掉进同样的陷阱：一个坑洞，地面上散落着发出嘎吱声的蛇皮。幸运的是，那些爬虫已经不在了，但跌落本身已经足以让那个可怜的雇佣兵受伤。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "要更加小心！",
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
			Title = "在 %objective%",
			Text = "[img]gfx/ui/events/event_57.png[/img]{你在废墟中找到了一张地图，似乎表明文物实际上是在一处名为%objective%的废墟中，在这里的某个%direction%。 | 不幸的是，文物不在这里。一些调查揭示出你们来错地方了：你们要找的实际上在%objective%的一个%direction%处。 | 嗯，你们来到了错误的地方。你和你的手下们尽力破解墙上的语言，并将它们与地图上的内容进行了比较。随着时间的推移，你们发现你们正在寻找的文物很可能位于名为%objective%的地方，就在这里的%direction%处。 | %randombrother%给你带来地图，他嘴里咒骂着。%SPEECH_ON%我想我们来错地方了，长官。看看这个。%SPEECH_OFF%在一起，你们得出结论，这个文物很可能位于%objective%的某个废墟中，在这里的某个%direction%处。 | 你本来希望一举找到文物，但这是不可能的。通过仔细的调查，战团慢慢发现自己来错了地方，需要去%direction%处的%objective%。 | 这里的废墟是错的。墙上的标志和缺失的文物都证明了这一点。通过仔细的推测，你认为文物实际上在离这里%direction%%objective%的地方。 | 经过在墟墙上爬行并找到了一无是处，你们慢慢发现你们来错了地方。你和%randombrother%研究地图一会儿后，判断文物实际上在一个叫%objective%的地方，离这里只有%direction%。 | %randombrother%发现一个男人挂在了一对陷阱触发的尖刺上。他的腐烂的手紧紧握住一张地图。你看了一下地图，意识到就像这个人一样，你已经来到了错误的废墟。文物实际上在离这里%direction%%objective%的地方。好在这位勇敢的探险者比你早到达了这里！ | 在通往空演讲台的一对台阶处找到了一具尸体。你认为这就是文物应该存在的地方，但现在它已经不在了。死去的人似乎没有它。%randombrother%在死者的衣服里找了一张折叠的地图。它指向离这里%direction%的一个叫做%objective%的地方。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "准备好继续前进吧，队员们！",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer%的大门敞开，你走进去。他转过身来看着你，眼神长久而凝重，逼视着你。你递上神器，他立刻站起身来，蓦然兴奋。%SPEECH_ON%你找到了它！老神在在啊！交给我！%SPEECH_OFF%神器被移交给%employer%，他的瞳孔瞪得大大的。你问起你的报酬，但他已经心不在焉了，仿佛已被神器吸引。他的秘书从角落的阴影中走出来，拿出一个装着%reward_completion%克朗的小袋子交给了你。%SPEECH_ON%请原谅我们，佣兵。我跟我的主人还有任务要处理。%SPEECH_OFF% | %employer%深深地坐在椅子上，或许他还深陷的他自己的思考。他的一个卫兵不得已要告诉他你来了，重复了三次直到他抬起头。他盯着你，又盯着神器。他从椅子上站起身来，仿佛被某股无形的力量激发一般。他接过神器，然后急急忙忙地跑到他的桌边，俯下身去，充满原始狂热地观察着它。卫兵递给你一袋%reward_completion%克朗。%SPEECH_ON%走吧，雇佣兵，看来我们已经没有什么需要再说的了。%SPEECH_OFF%} | %employer%的一名抄写员在贵族的房间外迎接您。他嘴里有霉味，举止匆忙。%SPEECH_ON%那是神器吗? 是吗?%SPEECH_OFF%您交出装有神器的袋子，抄写员的手指像啄食蠕虫的鸟嘴一样紧握绳扣。%SPEECH_ON%给！给！拿去拿你的钱走！%SPEECH_OFF%他把%reward_completion%克朗的一个包裹塞到你的手中，然后钻进%employer%的房间。 | %employer%的房间里等着几个抄写员。贵族本人则睡在床上，头部朝向天花板，手臂贴在两侧，像是一个拼装不完的模型。其中一名抄写员走上前。%SPEECH_ON%神器，交出来。%SPEECH_OFF%这很奇怪，但你当然不会吵醒睡着的贵族。你询问报酬。另一名抄写员向你扔出一个装有%reward_completion%克朗的口袋，袋子滑过石地板。%SPEECH_ON%现在把神器放在地上然后离开。%SPEECH_OFF%你拿着钱走了。 | 你看到%employer%逗乐着一群贵族。他通过贵族们的头顶看到了你，于是匆忙结束了他的笑话，向你悄悄走过来。%SPEECH_ON%你带来圣物了吗？%SPEECH_OFF%你把它交给了他，这个人露出了笑容。他给了你一个装满了%reward_completion%克朗的袋子。%SPEECH_ON%干得好，雇佣兵，但你需要走了，这不是你应该待的地方。这也不是我的地方。%SPEECH_OFF%他眨了眨眼睛，把你赶走了。 | 你在%employer%房间外被一名抄写员拦住了。他把手指放在嘴上，摇了摇头，然后引导你再往走廊深处走。走到一个火盆前，年迈的人迅速扫了一眼四周，然后拉下了火炬上的一个拉环。%SPEECH_ON%推墙，雇佣兵。%SPEECH_OFF%你照着指示去做，立刻发现那墙上的一块石头并非石头，而是木头。它滑开了，你穿过走了进去。%employer%在那里，房间里弥漫着微弱的烛光，摆满了书籍和奇特的物品。他轻轻响了一下手指，你便把圣物交给了他。作为回报，你得到了一个装满了%reward_completion%克朗的小包。贵族顿了一下，然后看着他的抄写员。%SPEECH_ON%等等，这里本应该是秘密的，你在干嘛啊？%SPEECH_OFF%老年人尴尬地抿了抿嘴。贵族捏着额头烦躁起来。%SPEECH_ON%该死，好吧，再打电话给那个石匠。%SPEECH_OFF% | 你找到了%employer%，交给了他那件神器。他给了你一袋%reward_completion%克朗，交易就这样完成了。唔，没什么悬念。 | %employer%和几个指挥官站在一起。你进来时，他们看着你，那位贵族伸出手放在自己的桌子上。你慢慢地走过去，把神器放在他的手心里。他拿起来，翻转着，盯着看了一会儿，然后看了你一眼。他响了响手指%SPEECH_ON%把佣兵的钱付了%SPEECH_OFF%其中一位指挥官递给你一袋%reward_completion%克朗，然后你很快被赶了出去。 | 一名长得很像%employer%的人在贵族的房间等待着你，他要求你交出神器，你按照要求做了。这个人停顿了一下，拿着神器，眼睛四处瞟。最后，他把它放在地上喊了一声%SPEECH_ON%看起来没问题！%SPEECH_OFF%突然，真正的%employer%从房间的一侧出现，谨慎地向前迈步%SPEECH_ON%抱歉让你见笑，但这里有些力量是你无法理解的。%SPEECH_OFF%你怀疑一件神器怎么会变成一个想杀死人的刺客，但你不会质疑贵族显然疯狂的思想过程。你收下你的%reward_completion%克朗，高高兴兴地离开了。 | %employer%在他的房间外等你。他的脸涨红，满头大汗，似乎几乎在守着门。%SPEECH_ON%晚上好，雇佣兵。你有要求的东西吗？%SPEECH_OFF%你把神物交给了那个人。他咧嘴一笑，给了你一个装满%reward_completion%克朗的小袋子。他转身回到房间，然后停顿了一下。%SPEECH_ON%走开吧。我不是让你站在这看着我做什么的。%SPEECH_OFF%你点点头离开了。当你离开时，你听见门打开，女人的声音传了过来，随即又迅速地关上了。 | %employer%的卫兵之一带你到花园里，那里贵族正在照料庄稼。他正在教一个年轻男孩修剪西红柿。%SPEECH_ON%茎子，你这个白痴！看我的，应该这样！你为什么要刺穿食物？永远不要！雇佣兵！%SPEECH_OFF%你一看到贵族就站直了身子。他把男孩推到一边，走过来问你有神物了吗。你把它交给他，得到了%reward_completion%克朗的回报。贵族点点头。%SPEECH_ON%你干得好，佣兵。我对个人能够完成我的要求正在失去信心。你肯定明白。%SPEECH_OFF%你看到男孩又剪坏了一株植物。你慢慢地点了点头。 | 你把遗物交给了%employer%，他皱着眉头盯着它，愤怒地在桌子上滚着手指。%SPEECH_ON%嗯，我想这就是结束了。有点令人失望，但协议就是协议。%SPEECH_OFF%他不情愿地滑过一袋%reward_completion%克朗的奖励给你。 | %employer%欢迎你进入他的房间，并给你提供了一杯酒。当一名抄写员走过来拿走遗物时，你开始询问你的报酬。%employer%咧嘴一笑。%SPEECH_ON%你在喝它！%SPEECH_OFF%你停了一下，酒杯还悬在你的唇边。贵族笑了。%SPEECH_ON%玩笑而已，赏金猎人，放松一点！来吧，按照我们达成协议的那样，%reward_completion%克朗。%SPEECH_OFF% | 你打开门，看到贵族和几个文书站在桌子前。奇怪形状的瓶瓶罐罐放得到处都是，有些装着更奇怪的颜色。其中一个文书匆匆走向你，从松松垮垮的袖子中伸出手来，就像蛇从洞穴中突出一样。他一只手夺走了文物，而另一只手则砰地一声将%salary_completion%克朗的袋子砸在了你的胸口上。%employer%向你挥手。%SPEECH_ON%走吧，雇佣兵，你已经完成了我们的要求，你现在的服务已经到此为止了。%SPEECH_OFF%",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "获得了一件对战争有重要意义的神器");
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
					text = "你获得了 [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] 克朗"
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
