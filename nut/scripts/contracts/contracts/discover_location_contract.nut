this.discover_location_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Location = null,
		LastHelpTime = 0.0
	},
	function create()
	{
		this.contract.create();
		this.m.DifficultyMult = this.Math.rand(75, 105) * 0.01;
		this.m.Type = "contract.discover_location";
		this.m.Name = "寻找位置";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
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

			if (region.Discovered < 0.25)
			{
				this.World.State.updateRegionDiscovery(region);
			}

			if (region.Discovered < 0.25)
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
		this.m.DifficultyMult = this.Math.rand(70, 85) * 0.01;
		this.m.Payment.Pool = this.Math.max(300, 100 + (this.World.Assets.isExplorationMode() ? 100 : 0) + lowestDistance * 15.0 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentLightMult());

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		this.m.Flags.set("Bribe", this.beautifyNumber(this.m.Payment.Pool * (this.Math.rand(110, 150) * 0.01)));
		this.m.Flags.set("HintBribe", this.beautifyNumber(this.m.Payment.Pool * 0.1));
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"寻找位于%direction%边%distance%处的%location%，该地在%region%附近。"
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
					"向%direction%方向搜索，在%region%地区附近寻找%location%。"
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
					local parties = this.World.getAllEntitiesAtPos(this.World.State.getPlayer().getPos(), 400.0);

					foreach( party in parties )
					{
						if (!party.isAlliedWithPlayer)
						{
							return;
						}
					}

					if (this.Time.getVirtualTimeF() >= this.Contract.m.LastHelpTime + 70.0)
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer%正对着一张绘制拙劣的地图端详，随后抬眼看向你，仿佛这图是你画的。%SPEECH_ON%听着，雇佣兵，这任务可能有点奇怪，但你看起来头脑清醒。看到这个黑斑了吗？你愿意往那个方向探险，试着找到%location%吗？它大概就在%region%区域附近。%SPEECH_OFF% | 你刚踏入%employer%的房间，他就把地图推到你面前。%SPEECH_ON%{佣兵！该去探险了！看到这个没有标注的点了吗，在这儿%direction%边的%region%地区。我需要你去那里寻找%location%。你接不接受？ | 好吧，这可能有点奇怪，但我需要找到一个叫%location%的地方并标注在地图上。我们的地图在这一片是空白的，据我所知它至少应该在或靠近%region%——就在这里的%direction%边。去吧，找到它，带着坐标回来，你会得到适当的报酬。 | 这个世界上还有许多地方人类尚未发现并标在地图上。我正在寻找%location%，位于%region%或在其附近，在这里的%direction%边。我只知道这些，但它确实存在。去替我找到它，报酬不会少。 | 我需要找个地方，佣兵。它位于%direction%方向的%region%区域附近。外行人叫它%location%，但不管它叫什么，我需要知道它在什么地方，明白吗？找到它，到时候有重金酬谢。 | 我需要士兵和探险家，佣兵，而我认为你恰好有这两种技能。先别怪我吝啬，不分别雇这两种职业的人——这么跟你说吧，替我办成这事，克朗管够。具体任务？我知道有个叫%location%的地方，但我不知道它在哪，只知道它位于这里%direction%边，在叫做%region%的土地上。找到它，将它标记在地图上，你就能同时拿到士兵和探险家的双重报酬！}%SPEECH_OFF%}",
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
					Text = "{不感兴趣。 | 短时间内我们不会去那里。 | 我们不想接这类差事。}",
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
			Title = "%location%里",
			Text = "[img]gfx/ui/events/event_57.png[/img]{你用望远镜观察到了%location%，随即将它标注在地图上。没费什么工夫。该回去向%employer%复命了。 | 没想到%location%比预想的更容易找到，现在就该返回%employer%那里了。你将它标在地图上，停顿片刻，摇摇头轻笑出声。运气真不错。 | %location%映入眼帘，你立即用尽毕生绘图功力将它重现于地图上。%randombrother%询问是否只需做这些。你点头确认。无论任务艰难还是轻松，%employer%都会照样付钱。}",
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
			Text = "[img]gfx/ui/events/event_07.png[/img]%location%已映入眼帘——%companyname%也暴露在对方视野中。那个曾为你们指路的“好心人”就站在那儿，只不过此刻他身边多了一群彪悍而不友善的壮汉。%SPEECH_ON%%SPEECH_ON%{看来你们还是会听从指示的嘛。告诉蠢货在哪儿碰面，设埋伏就容易多了。行了，杀光他们！ | 哟，佣兵。在这儿见到你真意外。等等，才不意外呢。杀光他们！ | 该死，你们来得可真够慢的！怎么，连自投罗网的简单指示都搞不明白？愚蠢的佣兵，简直蠢得令人发指。赶紧了结这事吧。杀光他们。}%SPEECH_OFF%",
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
			Text = "[img]gfx/ui/events/event_76.png[/img]{一个人十分友善地挥手走近。你回应他的方式是半拔出剑。他大笑起来。%SPEECH_ON%这么多人对%location%感兴趣，你这么戒备我也能理解。听着，我直接告诉你确切位置。就在这里往%direction%方向%distance%处的%terrain%上。%SPEECH_OFF%他一边发出咯咯笑声一边离开。%SPEECH_ON%不知我这是积德还是造孽，但这种乐趣正合我意！%SPEECH_OFF% | 一队饱经风霜的探险者！他们突然停在路中间，半身泥泞半身落叶，都在无意中与环境融为一体。其中一人揉着额头仔细打量你，随后绽开笑容。%SPEECH_ON%嘿，我一眼就看出是来找东西的。你们在找%location%对吧？算你们走运，我们刚从那儿回来！来，把地图给我，我指给你们看。瞧，就在现在位置往%direction%方向%distance%处的%terrain%上。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "非常感谢。",
					function getResult()
					{
						if (this.Math.rand(1, 100) <= 20 && this.Contract.getDifficultyMult() > 0.95)
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
			Text = "[img]gfx/ui/events/event_76.png[/img]{有个陌生人保持着距离，一只脚踩在路上，另一只脚随时准备逃跑。%SPEECH_ON%嘿，你们好。%SPEECH_OFF%他扫视你的手下，缓缓露出笑容，仿佛察觉到了你们的迷惘。%SPEECH_ON%在找%location%是吧？嗯，没错。这样吧，递给我%hint_bribe%克朗，我就告诉你们确切位置！要是想动刀逼问，我撒腿就跑的速度可比你们眨眼还快！%SPEECH_OFF% | 你看着陌生人走到路中央的光亮处，他抬手遮眼，大半张脸仍藏在阴影里。%SPEECH_ON%看你们这样就是在找什么东西，却不知道在哪儿！%location%就是这么个刁钻地方。幸好我知道位置。更幸好你们只要把%hint_bribe%克朗滑到我这儿，也能知道。我可是你们见过跑得最快的人，别想用那些亮闪闪的刀剑逼我开口。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "行，钱给你。讲吧。",
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
			Text = "[img]gfx/ui/events/event_76.png[/img]你接受了这个人的提议，他如约说出了详细信息。%SPEECH_ON%你看，它就在那儿，从我们现在位置往%direction%方向%distance%处的%terrain%上走。简单得很。%SPEECH_OFF%他吹着口哨走开了，这钱对他来说赚得毫不费力。",
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
					text = "你失去了[color=" + this.Const.UI.Color.NegativeEventValue + "]" + this.Flags.get("HintBribe") + "[/color]克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "AnotherParty1",
			Title = "%townname%里",
			Text = "[img]gfx/ui/events/event_51.png[/img]{正当你和%companyname%准备启程时，%randombrother%报告说有人要求与你面谈。你点头允准后，一个阴郁矮小的男人被带了进来。他声称%townname%的“统治者”对%location%只有贪婪的企图。这不明摆着吗，所以问题在哪？那人点头道：%SPEECH_ON%听着，我这边有些人希望永远封存%location%的下落。要是你找到了，先来找我。我们给的酬劳绝对丰厚。%SPEECH_OFF% | 在%companyname%整装待发寻找%location%时，一个男人悄无声息地靠近你。他递来字条后便默然离去。上面用大字写着：让%locationC%保持原状。如果你找到了，先与我们接洽。用你的沉默换取我们的克朗。%townnameC%的统治者什么都不需要知道！ | 一名男子走近战团，你瞥见他身后有几户穷苦人家正注视着这里。不确定他是否代表那些人，但他径直来到你面前低声提议：%SPEECH_ON%听好了佣兵。如果你们找到了%location%，先来找我们。%townname%的统治者不该把贪婪和权欲带到那片土地。交给我们就好，明白吗？报酬绝不会少。%SPEECH_OFF%不待你回应，他直起身便离开了。当你再望向路边时，那些人家早已不见踪影。}",
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
			Text = "[img]gfx/ui/events/event_51.png[/img]{当你走向%townname%时，一个陌生人出现在路中央。正是之前与你交谈过的那人，但这次他手里多了一个钱袋。%SPEECH_ON%{你没有理由告诉本镇统治者%location%的位置。把那里的秘密留给我们，你根本不知道我们在那里保存了多少传家宝和历史。只要保持沉默，我们愿意支付%bribe%克朗作为酬谢。先生，请收下吧。 | 听着，佣兵，我知道你只认一种语言——金钱的语言。收下这袋钱作为我们的谢意——前提是你保持沉默。不必告诉%townname%的统治者%location%在哪儿。那地方属于我们家族。那些狭隘的统治者只会用贪婪和权欲毁掉它。所以你怎么说，愿意收下吗？里面有%bribe%克朗。你只需拿钱闭嘴。}%SPEECH_OFF% | 刚进入%townname%，你就被一个熟悉的面孔拦下：正是出发前与你接触过的那人。但这次他随身带着钱袋。%SPEECH_ON%{%bribe%克朗以换取你的沉默。什么都不要告诉这个镇的统治者，它就是你的了。他们不需要知道我们的交易，他们只需要不知道这个地方在哪里。它对我们来说至关重要，承载着无法估量的历史，而他们他们只会洗劫掠夺那里。请收下吧。 | 拿着，这是%bribe%克朗。我们准备用这个价码买你保密。%townname%的统治者会利用你提供的信息洗劫%location%，因为他们知道我们家族与那里的渊源。唉，我们在此地早已失势，所剩无几了，求求你让我们保留传家宝和故居吧。}%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我觉得不行。只有我们的雇主会知道它在哪里。",
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
			Text = "[img]gfx/ui/events/event_51.png[/img]{在你拒绝那人后，他跪地哭嚎起来，引得%companyname%众人哄笑不止。他哀嚎着控诉你将他家族的悠久历史拱手交给了皮条客和放贷者。你直截了当告诉他你毫不在乎。 | 当你表明无意背叛原雇主时，那人情绪彻底失控。他试图扑上来用愤怒的双手抓住你，%randombrother%一把推开他，并拔刀威胁要取其性命。那人退缩了，瘫坐在路边埋头膝间啜泣。队伍经过时，有个队员递给他一块手帕。 | 你拒绝了那人。他苦苦哀求。你再次拒绝。他继续哀告。你忽然意识到这场景似曾相识——好像对一两个女人也这样过。这实在不太体面。你如实相告，但此刻的情绪已让他彻底崩溃。他开始嚎啕大哭，泣诉统治%townname%的贪婪杂种会如何玷污他的家族姓氏。你告诉他，倘若是他掌管这座城镇，他那所谓的家族姓氏或许就能得以保全。这话并没能止住他的眼泪。}",
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
			Text = "[img]gfx/ui/events/event_51.png[/img]{你同意向那人出售探险行动的详细信息。他对整件事喜出望外，但%employer%却不然。显然有个小孩目睹了这场交易，并向%townname%的掌权者告发了你的背叛行径。毫无疑问，你在此地的声誉已受到损害。 | 一方面，你使这个人口中的家族宅邸免遭%townname%统治者的摧毁。另一方面，%townname%的掌权者迅速得知了你的所作所为。你早该想到小镇居民本身就是高效的流言传播中介。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "好吧，%employer%本该多付我们一些钱。",
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
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("Bribe") + "[/color]克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "AnotherParty5",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]你向那人保证会对他家族据点的位置守口如瓶。趁他欢庆之际，你转头就把%location%的方位告诉了%employer%。两头收钱真是桩美差——虽然同时遭两边记恨不太妙，但跟佣兵打交道还能指望什么呢？",
			Image = "",
			List = [],
			Options = [
				{
					Text = "那些人永远也不会知道。",
					function getResult()
					{
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.Assets.addMoney(this.Flags.get("Bribe"));
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail * 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 1.5, "向竞争对手提供了信息");
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
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color]克朗"
				});
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("Bribe") + "[/color]克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer%对你的归来表示欢迎。你递上刚绘制完成的地图，他仔细端详着，用手背拍打那个标记点。%SPEECH_ON%果然就在这个位置！%SPEECH_OFF%他得意地笑着，如数支付了你的报酬。 | 你走进%employer%的房间，手中拿着新绘制的地图。他接过去仔细查看。%SPEECH_ON%好吧。我本来想这也太容易了，但约定终归是约定。%SPEECH_OFF%他将装着实实在在报酬的钱袋递到你手中。 | 你向%employer%汇报了%location%的具体位置。他边点头边抄录你地图上的标注。出于好奇，你问他如何确定你没有说谎。这人靠坐在椅子上，双手交叠搭在肚腩上。%SPEECH_ON%我雇了个跟踪者紧盯你们的队伍。他比你先返回，你刚才说的不过印证了我已知的情报。希望你别介意这样的安排。%SPEECH_OFF%你点了点头，认为此举是明智的做法，领了酬劳便转身离开。}",
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
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color]克朗"
				});
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		local distance = this.m.Location != null && !this.m.Location.isNull() ? this.World.State.getPlayer().getTile().getDistanceTo(this.m.Location.getTile()) : 0;
		distance = this.Const.Strings.Distance[this.Math.min(this.Const.Strings.Distance.len() - 1, distance / 30.0 * (this.Const.Strings.Distance.len() - 1))];
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
