this.discover_location_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Location = null,
		LastHelpTime = 0.000000
	},
	function create()
	{
		this.contract.create();
		this.m.DifficultyMult = this.Math.rand(75, 105) * 0.010000;
		this.m.Type = "contract.discover_location";
		this.m.Name = "寻找位置";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.000000;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		if (this.m.Home == null)
		{
			this.setHome(this.World.State.getCurrentTown());
		}

		this.contract.start();
	}

	function setup()
	{
		local locations = clone this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getSettlements();
		locations.extend(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getSettlements());
		local lowestDistance = 9000;
		local best;
		local myTile = this.m.Home.getTile();

		foreach( b in locations )
		{
			if (b.isLocationType(this.Const.World.LocationType.Unique))
			{
				continue;
			}

			if (b.isDiscovered())
			{
				continue;
			}

			local region = this.World.State.getRegion(b.getTile().Region);

			if (!region.Center.IsDiscovered)
			{
				continue;
			}

			if (region.Discovered < 0.250000)
			{
				this.World.State.updateRegionDiscovery(region);
			}

			if (region.Discovered < 0.250000)
			{
				continue;
			}

			local d = myTile.getDistanceTo(b.getTile());

			if (d > 20)
			{
				continue;
			}

			if (d + this.Math.rand(0, 5) < lowestDistance)
			{
				lowestDistance = d;
				best = b;
			}
		}

		if (best == null)
		{
			this.m.IsValid = false;
			return;
		}

		this.m.Location = this.WeakTableRef(best);
		this.m.Flags.set("Region", this.World.State.getTileRegion(this.m.Location.getTile()).Name);
		this.m.Flags.set("Location", this.m.Location.getName());
		this.m.DifficultyMult = this.Math.rand(70, 85) * 0.010000;
		this.m.Payment.Pool = this.Math.max(300, 100 + (this.World.Assets.isExplorationMode() ? 100 : 0) + lowestDistance * 15.000000 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentLightMult());

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.750000;
			this.m.Payment.Advance = 0.250000;
		}
		else
		{
			this.m.Payment.Completion = 1.000000;
		}

		this.m.Flags.set("Bribe", this.beautifyNumber(this.m.Payment.Pool * (this.Math.rand(110, 150) * 0.010000)));
		this.m.Flags.set("HintBribe", this.beautifyNumber(this.m.Payment.Pool * 0.100000));
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"找到位于%direction%边%distance%处的%location%，大约在%region%区域附近。"
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
					this.Flags.set("IsAnotherParty", true);
					this.Flags.set("IsShowingAnotherParty", true);
				}

				this.Contract.m.LastHelpTime = this.Time.getVirtualTimeF() + this.Math.rand(10, 40);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"向%direction%搜索，在%region%地区附近寻找%location%。"
				];

				if (this.Contract.m.Location != null && !this.Contract.m.Location.isNull())
				{
					this.Contract.m.Location.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Flags.get("IsShowingAnotherParty"))
				{
					this.Flags.set("IsShowingAnotherParty", false);
					this.Contract.setScreen("AnotherParty1");
					this.World.Contracts.showActiveContract();
				}

				if (this.TempFlags.get("IsDialogTriggered"))
				{
					return;
				}

				if (this.Contract.m.Location.isDiscovered())
				{
					if (this.Flags.get("IsTrap"))
					{
						this.TempFlags.set("IsDialogTriggered", true);
						this.Contract.setScreen("Trap");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("FoundIt");
						this.World.Contracts.showActiveContract();
					}
				}
				else
				{
					local parties = this.World.getAllEntitiesAtPos(this.World.State.getPlayer().getPos(), 400.000000);

					foreach( party in parties )
					{
						if (!party.isAlliedWithPlayer)
						{
							return;
						}
					}

					if (this.Time.getVirtualTimeF() >= this.Contract.m.LastHelpTime + 70.000000)
					{
						this.Contract.m.LastHelpTime = this.Time.getVirtualTimeF() + this.Math.rand(0, 30);
						local r = this.Math.rand(1, 100);

						if (r <= 50)
						{
							this.Contract.setScreen("SurprisingHelpAltruists");
						}
						else
						{
							this.Contract.setScreen("SurprisingHelpOpportunists1");
						}

						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "DiscoverLocation")
				{
					this.Contract.setState("Return");
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "DiscoverLocation")
				{
					this.Contract.setState("Return");
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

				if (this.Contract.m.Location != null && !this.Contract.m.Location.isNull())
				{
					this.Contract.m.Location.getSprite("selection").Visible = false;
				}

				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Flags.get("IsAnotherParty"))
					{
						this.Contract.setScreen("AnotherParty2");
					}
					else
					{
						this.Contract.setScreen("Success1");
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer%正看着一张画得很差的地图，然后抬头看着你，仿佛你是负责制作这张地图的人。%SPEECH_ON%看呐，雇佣兵，给你这个任务很奇怪，但你看起来很有头脑。看到这个黑点了吗？你愿意前往那个方向，尝试找到位于%region%地区或附近的%location%吗？%SPEECH_OFF% | 你走进了%employer%的房间，他把一张地图猛地推到了你的面前。%SPEECH_ON%{佣兵！你是时候去探险了！看到这个未知的点了吗，这儿%direction%边的%region%地区。我需要你去那儿寻找%location%。你接不接受这个任务？ | 好吧，这可能看起来很奇怪，但我需要一个被称为%location%的地方被找到和标在地图上。我们的地图在这一点上不完整，我至少认为它位于或靠近%region% —— 这儿%direction%边的地区。去吧，找到它，并带着坐标回来，你会得到适当的报酬。 | 这个世界上还有许多地方人类尚未发现和勘测并标在地图上。我正在寻找%location%，位于%region%或在其附近，在这里的%direction%边。除此之外，我对它了解不多，但我确信它的存在。所以，请你去找到它，回来向我报告坐标，你会得到适当的奖励。 | 我需要你去寻找一个地方，佣兵。它位于或靠近这里%direction%边的%region%。外行人称它为%location%，但无论它是什么，我需要知道它的具体位置，明白吗？找到它，你就会有丰厚的报酬。 | 我需要一位士兵和一位探险家，佣兵，而我认为你恰好有这两种技能。在你指责我不雇佣两种职业显得吝啬之前，我只想说你帮我做这件事可以赚很多钱。嗯，这个任务是什么呢？我知道一个叫%location%的地方，但我不知道它在哪，除了它位于这里%direction%边的狭长地带 —— 叫作%region%。找到它，将它标记在地图上，你将得到士兵和探险家两个人的报酬！}%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{报酬是多少？ | 出价合适我们就会去找到它。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{不感兴趣。 | 这和我们的旅行计划不顺路。 | 这不是我们要找的那种工作。}",
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
			ID = "FoundIt",
			Title = "在%location%",
			Text = "[img]gfx/ui/events/event_57.png[/img]{你用瞄准镜观察到了%location%，并将其标记在你的地图上。很容易。是时候回到%employer%那了。 | 好了，现在已经是时候回到%employer%那里了，因为寻找%location%比你想象的更容易。你在地图上做了标记，停下来笑了笑，摇了摇头。真是幸运。 | %location%出现在视野中，你立即发挥你的注解能力将其标注在地图上。%randombrother%问是否就这样任务就完成了，你点了点头。不管是难是易，%employer%都会等着付钱给你。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "是时候回去了。",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Trap",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_07.png[/img]%location%已经被发现 —— 而%companyname%也被发现了。给你指路的那个所谓的“利他主义者”就站在那里，现在他身边有一群强壮而不友好的人。%SPEECH_ON%{好吧。看来你还是可以听从指示的。设埋伏在告诉了某个白痴在哪见面时很容易的。不管怎样，把他们都杀了！ | 嘿，雇佣兵，在这里见到你真奇怪。哦等等，不是。杀了他们！ | 该死，你们花的时间太长了！什么，你就不能按照简单的指示走进自己的坟墓吗？愚蠢的佣兵，蠢得让人讨厌。好吧，让我们结束这一切，杀了他们！}%SPEECH_OFF%",
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
						p.CombatID = "DiscoverLocation";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.BanditRaiders, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, false, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SurprisingHelpAltruists",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_76.png[/img]{一个人友好地挥着手走了过来。你拔出了一半的剑作为回应，他笑了。%SPEECH_ON%很多人对%location%很感兴趣，所以我不能责怪你如此戒备。听着，我会告诉你它在哪里。就在这里%direction%边%distance%的%terrain%。%SPEECH_OFF%他咯咯地笑着走开了。%SPEECH_ON%我不知道我是做了好事还是坏事，而这正是我喜欢的那种有趣的情况！%SPEECH_OFF% | 一群世故的探险者！他们停在路中间，一半被泥巴包裹着，一半被树叶覆盖着，仿佛不经意间与环境融为一体。其中一位揉着额头，仔细地打量着你，然后微笑着开口。%SPEECH_ON%嘿，我一眼就能看出你是个探索者。你是在寻找%location%，对吧？那你真是走运，我们正好刚从那边过来！把你的地图给我，我会指给你它的准确位置。你看，就在%direction%边%distance%处的%terrain%。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "非常感谢。",
					function getResult()
					{
						if (this.Math.rand(1, 100) <= 20 && this.Contract.getDifficultyMult() > 0.950000)
						{
							this.Flags.set("IsTrap", true);
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SurprisingHelpOpportunists1",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_76.png[/img]{陌生人是一个独自行动的人，保持着距离，一只脚站在路上，另一只脚向着逃脱的方向挪动。%SPEECH_ON%嗨，你们好！%SPEECH_OFF%他瞥了一眼你的人，慢慢地露出了微笑，好似能感觉到我们对前路的迷茫。%SPEECH_ON%你们在寻找%location%吗？嗯，好吧，我告诉你们，给我%hint_bribe%克朗，我会告诉你具体在哪里！如果你们拿着剑追我，我会消失得比你们眨眼还快！%SPEECH_OFF% | 你看着陌生人走到路灯下，他遮着眼睛以保持脸部的神秘感。%SPEECH_ON%你看起来像那种在寻找某物但不知道在哪里的人！%location%就是那样棘手。还好我知道它在哪儿。而且还好你可以通过给我%hint_bribe%克朗以得知其所在。我是你们见过的最快的短跑运动员，所以别想用你们那些闪闪发亮的剑逼问我。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "好吧，这是克朗。现在讲吧。",
					function getResult()
					{
						return "SurprisingHelpOpportunists2";
					}

				},
				{
					Text = "不需要，我们自己会找到的。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SurprisingHelpOpportunists2",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_76.png[/img]你接受了这个人的提议，他就像承诺的那样给出了细节。%SPEECH_ON%你看，它就在那儿，在离我们现在的位置往%direction%%distance%处的%terrain%。简单。%SPEECH_OFF%他在走开时吹起了口哨，毫无疑问，这对他来说是个非常容易的赚钱机会。",
			Image = "",
			List = [],
			Options = [
				{
					Text = "搞定。",
					function getResult()
					{
						this.World.Assets.addMoney(-this.Flags.get("HintBribe"));
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你失去了 [color=" + this.Const.UI.Color.NegativeEventValue + "]" + this.Flags.get("HintBribe") + "[/color] 克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "AnotherParty1",
			Title = "在%townname%",
			Text = "[img]gfx/ui/events/event_51.png[/img]{当你和%companyname%准备启程时，%randombrother%说有个人想和你直接说上话。你点点头，让他来见你。他是个阴郁的矮个子，他说，%townname%的“统治者”单纯只因贪婪而对%location%感兴趣。当然，这是预料之中的，所以问题是什么呢？那人点了点头。%SPEECH_ON%听着，我认识一些人对让%location%保持隐秘很感兴趣。如果你找到地方了，那么，请先跟我说。我们会让你大赚一笔的。%SPEECH_OFF% | 当%companyname%准备启程去找%location%之际，一名男子悄悄靠近你，将一张纸条递给你，然后无言离开。纸条上用大字写道：*把%locationC%留在原处。如果你找到了它，与我们谈。我们用克朗换取你的沉默。%townnameC%的统治者不需要知道任何事情！* | 一名男子走近战团，在他身后，你可以看到一对贫穷的家庭在盯着他看。你不确定他是否是他们的代表，但无论如何，他直奔你而来，用低声轻语提出了一个提议。%SPEECH_ON%听着，佣兵。如果你去找到了%location%，先来找我们。%townname%的统治者不需要把他们对权力的贪婪和欲望带到那个地方。交给我们，好吗？我们会会好好报偿你。%SPEECH_OFF%你还没来得及说一句话，他就挺直身子继续前行。当你再次朝路边看去时，那些家庭已经不见了。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我会考虑的。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "AnotherParty2",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_51.png[/img]{当你前往%townname%时，一个陌生人出现在路上。他是你之前跟他交谈过的那个人，但这次他手里拿着一个小背包。%SPEECH_ON%{你没有理由告诉这个城镇的统治者%location%的位置。把它的秘密留给我们，你不知道我们在那里拥有什么传家宝和历史。为了你的沉默，我们愿意支付%bribe%克朗作为报酬。先生，请收下吧。 | 听着，雇佣兵，我知道你只懂一门语言，那就是金钱的语言。如果你保持沉默，那就接受这个小背包作为我们感激的象征。你不必告诉%townname%的统治者%location%在哪里。那个地方属于我们的家族。那些小当权者只会用他们的贪婪和对权力的追逐毁坏它。那么，你怎么说，你愿意接受吗？里面有%bribe%克朗。你需要做的就是拿走，啥都别说。}%SPEECH_OFF% | 进入%townname%，你被一张熟悉的面孔拦住了：就是你在第一次离开之前所碰面的那个人。但这次他带着一个小背包。%SPEECH_ON%{%bribe%克朗以换取你的沉默。什么都不要告诉这个镇的统治者，它就是你的了。他们不需要知道我们的交易，他们只需要不知道这个地方在哪里。它对我们来说很重要，有着无法估量的历史，而他们所会做的只是洗劫和掠夺。请接受吧。 | 拿着这个，这是%bribe%克朗。那就是我们准备给你的封口费。%townname%的统治者将利用你的信息来对%location%进行劫掠，因为他们知道我们与之有家族关系，而且，呃，我们在这里早已失势。我们几乎没有什么剩下的，所以，请让我们保留我们的传家宝和老房子吧。}%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我不这么认为。只有我们的雇主会知道它在哪里。",
					function getResult()
					{
						return "AnotherParty3";
					}

				},
				{
					Text = "我们成交。只有你会知道它在哪。",
					function getResult()
					{
						return "AnotherParty4";
					}

				},
				{
					Text = "如果我们能拿两次报酬，何必只拿一次呢？",
					function getResult()
					{
						return "AnotherParty5";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "AnotherParty3",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_51.png[/img]{在你拒绝他后，他跪在地上大声哭泣，这让%companyname%感到很好笑。他哭诉说你把他家的历史留给了好色之徒和高利贷者。你告诉他你不在乎。 | 告诉他你无意背叛你的原雇主激怒了他。他企图攻击你，伸出愤怒的双手向你扑来。%randombrother%把他推开，并拔出刀威胁要杀了他。那人退后了，在路边坐下，头埋在双膝之间，抽泣着。其中一个人经过时给了他一块手帕。 | 你告诉他不行，他苦苦哀求。你又再次拒绝了他。他祈求得更厉害了。突然，你意识到你曾经对一两个女人做过类似的事情，这作态真的不好看。你对他解释了一大堆，但这一刻的情感对他来说太过强烈。他开始嚎啕大哭，不停地诉说其家族名声将会如何被那些掌控%townname%的贪婪混蛋们毁掉。你告诉他，如果、可能，他是这个小镇的主人，他所谓的家族名声就将得到保护。这并不能止住他的眼泪。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "让开。",
					function getResult()
					{
						return "Success1";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "AnotherParty4",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_51.png[/img]{你同意向那个男人出售你的远征计划细节。他为此非常高兴，但是%employer%却不是。显然，有个小孩看到了这场交易，并向%townname%的当权者报告了你的背叛。你在这里的声誉无疑受到了一些伤害。 | 好吧，一方面你保护了这个男人所谓的家乡免受那些%townname%的当权者破坏。另一方面，%townname%的当权者很快就听说了你的所作所为。你应该更加关注这个小镇的人口在传播谣言上的强大之处。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "嗯，%employer%本该多付我们些钱。",
					function getResult()
					{
						this.World.Assets.addMoney(this.Flags.get("Bribe"));
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "将" + this.Flags.get("Location") + "的位置卖给了另一方");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了 [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("Bribe") + "[/color] 克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "AnotherParty5",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]你告诉那人你会对他家的位置保密。在他庆祝的时候，你又去向%employer%告知了%location%的位置。同时从两方获得报酬确实很甜蜜。不过，同时遭受双方的仇恨就不那么美妙了，但他们能对与佣兵打交道抱多少期望呢？",
			Image = "",
			List = [],
			Options = [
				{
					Text = "那些人永远学不到什么。",
					function getResult()
					{
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.Assets.addMoney(this.Flags.get("Bribe"));
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail * 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 1.500000, "向竞争对手提供了信息");
						this.World.Contracts.finishActiveContract(true);
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
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了 [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("Bribe") + "[/color] 克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer%对你的归来表示欢迎。你把新近绘制的地图递给他，他仔细看了看，用手背拍打着上面的标记。%SPEECH_ON%当然是在那里了！%SPEECH_OFF%他咧嘴笑了笑，付了你应得的报酬。 | 你手里拿着新地图走进了%employer%的房间。他接过地图仔细看了一遍。%SPEECH_ON%好吧，我会想这也太容易了，但协议就是协议。%SPEECH_OFF%他递给你一个小背包，里面装着你应得的报酬。 | 你向%employer%汇报了%location%的位置。他点了点头，拿出纸笔把你地图上的笔记抄了下来。出于好奇，你问他怎么知道你没有说谎。那人坐下靠好，双手合十放在肚子上。%SPEECH_ON%我雇了一位跟随你们战团的追踪者。他比你来得早，你只是确认了我已经知道的事情。希望你不介意我们采取的措施。%SPEECH_OFF%你点了点头，认为这是明智的做法，拿了钱就走了。}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "受雇找到了" + this.Flags.get("Location"));
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
					text = "你获得了 [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] 克朗"
				});
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		local distance = this.m.Location != null && !this.m.Location.isNull() ? this.World.State.getPlayer().getTile().getDistanceTo(this.m.Location.getTile()) : 0;
		distance = this.Const.Strings.Distance[this.Math.min(this.Const.Strings.Distance.len() - 1, distance / 30.000000 * (this.Const.Strings.Distance.len() - 1))];
		_vars.push([
			"region",
			this.m.Flags.get("Region")
		]);
		_vars.push([
			"location",
			this.m.Flags.get("Location")
		]);
		_vars.push([
			"locationC",
			this.m.Flags.get("Location").toupper()
		]);
		_vars.push([
			"townnameC",
			this.m.Home.getName().toupper()
		]);
		_vars.push([
			"direction",
			this.m.Location == null || this.m.Location.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Location.getTile())]
		]);
		_vars.push([
			"terrain",
			this.m.Location != null && !this.m.Location.isNull() ? this.Const.Strings.Terrain[this.m.Location.getTile().Type] : ""
		]);
		_vars.push([
			"distance",
			distance
		]);
		_vars.push([
			"bribe",
			this.m.Flags.get("Bribe")
		]);
		_vars.push([
			"hint_bribe",
			this.m.Flags.get("HintBribe")
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

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (this.m.Location == null || this.m.Location.isNull() || !this.m.Location.isAlive() || this.m.Location.isDiscovered())
		{
			return false;
		}

		return true;
	}

	function onIsTileUsed( _tile )
	{
		if (this.m.Location != null && !this.m.Location.isNull() && _tile.ID == this.m.Location.getTile().ID)
		{
			return true;
		}

		return false;
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

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local location = _in.readU32();

		if (location != 0)
		{
			this.m.Location = this.WeakTableRef(this.World.getEntityByID(location));
		}

		this.contract.onDeserialize(_in);
	}

});
