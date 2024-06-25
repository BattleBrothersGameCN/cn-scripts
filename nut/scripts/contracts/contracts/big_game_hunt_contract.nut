this.big_game_hunt_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Size = 0,
		Dude = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.big_game_hunt";
		this.m.Name = "大型狩猎";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 5.0;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
		this.m.MakeAllSpawnsResetOrdersOnceDiscovered = true;
		this.m.DifficultyMult = 1.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function setup()
	{
		local r = this.Math.rand(1, 100);

		if (r <= 40)
		{
			this.m.Size = 0;
			this.m.DifficultyMult = 0.75;
		}
		else if (r <= 75 || this.World.getTime().Days <= 30)
		{
			this.m.Size = 1;
			this.m.DifficultyMult = 1.0;
		}
		else
		{
			this.m.Size = 2;
			this.m.DifficultyMult = 1.2;
		}
	}

	function start()
	{
		if (this.m.Home == null)
		{
			this.setHome(this.World.State.getCurrentTown());
		}

		local maximumHeads;
		local priceMult = 1.0;

		if (this.m.Size == 0)
		{
			local priceMult = 1.0;
			maximumHeads = [
				15,
				20,
				25,
				30
			];
		}
		else if (this.m.Size == 1)
		{
			local priceMult = 4.0;
			maximumHeads = [
				10,
				12,
				15,
				18,
				20
			];
		}
		else
		{
			local priceMult = 8.0;
			maximumHeads = [
				8,
				10,
				12,
				15
			];
		}

		this.m.Payment.Pool = 1300 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult() * priceMult;
		this.m.Payment.Count = 1.0;
		this.m.Payment.MaxCount = maximumHeads[this.Math.rand(0, maximumHeads.len() - 1)];
		local settlements = this.World.FactionManager.getFaction(this.m.Faction).getSettlements();
		local other_settlements = this.World.EntityManager.getSettlements();
		local regions = this.World.State.getRegions();
		local candidates_first = [];
		local candidates_second = [];

		foreach( i, r in regions )
		{
			local inSettlements = 0;
			local nearSettlements = 0;

			if (r.Type == this.Const.World.TerrainType.Snow || r.Type == this.Const.World.TerrainType.Mountains || r.Type == this.Const.World.TerrainType.Desert || r.Type == this.Const.World.TerrainType.Oasis)
			{
				continue;
			}

			if (!r.Center.IsDiscovered)
			{
				continue;
			}

			if (this.m.Size == 2 && r.Type != this.Const.World.TerrainType.Steppe && r.Type != this.Const.World.TerrainType.Forest && r.Type != this.Const.World.TerrainType.LeaveForest && r.Type != this.Const.World.TerrainType.AutumnForest)
			{
				continue;
			}

			if (r.Discovered < 0.5)
			{
				this.World.State.updateRegionDiscovery(r);
			}

			if (r.Discovered < 0.5)
			{
				continue;
			}

			foreach( s in settlements )
			{
				local t = s.getTile();

				if (t.Region == i + 1)
				{
					inSettlements = ++inSettlements;
				}
				else if (t.getDistanceTo(r.Center) <= 20)
				{
					local skip = false;

					foreach( o in other_settlements )
					{
						if (o.getFaction() == this.getFaction())
						{
							continue;
						}

						local ot = o.getTile();

						if (ot.Region == i + 1 || ot.getDistanceTo(r.Center) <= 10)
						{
							skip = true;
							break;
						}
					}

					if (!skip)
					{
						nearSettlements = ++nearSettlements;
					}
				}
			}

			if (nearSettlements > 0 && inSettlements == 0)
			{
				candidates_first.push(i + 1);
			}
			else if (inSettlements > 0 && inSettlements <= 1)
			{
				candidates_second.push(i + 1);
			}
		}

		local region;

		if (candidates_first.len() != 0)
		{
			region = candidates_first[this.Math.rand(0, candidates_first.len() - 1)];
		}
		else if (candidates_second.len() != 0)
		{
			region = candidates_second[this.Math.rand(0, candidates_second.len() - 1)];
		}
		else
		{
			region = settlements[this.Math.rand(0, settlements.len() - 1)].getTile().Region;
		}

		this.m.Flags.set("Region", region);
		this.m.Flags.set("HeadsCollected", 0);
		this.m.Flags.set("StartDay", 0);
		this.m.Flags.set("LastUpdateDay", 0);
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Flags.set("StartDay", this.World.getTime().Days);
				this.Contract.m.BulletpointsObjectives.clear();

				if (this.Contract.m.Size == 0)
				{
					if (this.Const.DLC.Desert)
					{
						this.Contract.m.BulletpointsObjectives.push("猎杀恐狼、蛛魔、食尸鬼、鬣狗和大蛇");
					}
					else
					{
						this.Contract.m.BulletpointsObjectives.push("猎杀恐狼、蛛魔和食尸鬼");
					}
				}
				else if (this.Contract.m.Size == 1)
				{
					this.Contract.m.BulletpointsObjectives.push("猎杀梦魇、巨魔和女巫");
				}
				else
				{
					this.Contract.m.BulletpointsObjectives.push("猎杀树人和林德蠕龙");
				}

				this.Contract.m.BulletpointsObjectives.push("在%worldmapregion%的%regiontype%区域或其他地区猎杀目标");
				this.Contract.m.BulletpointsObjectives.push("随时返回 %townname% 领取报酬");

				if (this.Contract.m.Size == 0)
				{
					this.Contract.setScreen("TaskSmall");
				}
				else if (this.Contract.m.Size == 1)
				{
					this.Contract.setScreen("TaskMedium");
				}
				else
				{
					this.Contract.setScreen("TaskLarge");
				}
			}

			function end()
			{
				this.Flags.set("StartDay", this.World.getTime().Days);
				local action = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getAction("send_beast_roamers_action");
				local options;

				if (this.Contract.m.Size == 0)
				{
					options = action.m.BeastsLow;
				}
				else if (this.Contract.m.Size == 1)
				{
					options = action.m.BeastsMedium;
				}
				else
				{
					options = action.m.BeastsHigh;
				}

				local nearTile = this.World.State.getRegion(this.Flags.get("Region")).Center;

				for( local i = 0; i < 3; i = ++i )
				{
					for( local tries = 0; tries++ < 1000;  )
					{
						if (options[this.Math.rand(0, options.len() - 1)](action, nearTile))
						{
							local party = action.getFaction().getUnits()[action.getFaction().getUnits().len() - 1];
							party.setAttackableByAI(false);
							this.Contract.m.UnitsSpawned.push(party.getID());
							local wait = this.new("scripts/ai/world/orders/wait_order");
							wait.setTime(15.0);
							party.getController().addOrderInFront(wait);
							local footPrintsOrigin = this.Contract.getTileToSpawnLocation(nearTile, 4, 8);
							this.Const.World.Common.addFootprintsFromTo(footPrintsOrigin, party.getTile(), this.Const.BeastFootprints, party.getFootprintType(), party.getFootprintsSize(), 1.1);
							break;
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
				this.Contract.m.BulletpointsObjectives.clear();

				if (this.Contract.m.Size == 0)
				{
					if (this.Const.DLC.Desert)
					{
						this.Contract.m.BulletpointsObjectives.push("在%worldmapregion%的%regiontype% 区域猎杀恐狼、蛛魔和食尸鬼(%killcount%/%maxcount%)");
					}
					else
					{
						this.Contract.m.BulletpointsObjectives.push("在%worldmapregion%的%regiontype%区域猎杀恐狼、蛛魔、食尸鬼、鬣狗和大蛇(%killcount%/%maxcount%)");
					}
				}
				else if (this.Contract.m.Size == 1)
				{
					this.Contract.m.BulletpointsObjectives.push("在%worldmapregion%的%regiontype%区域猎杀梦魇、巨魔和女巫(%killcount%/%maxcount%)");
				}
				else
				{
					this.Contract.m.BulletpointsObjectives.push("在%worldmapregion%的%regiontype%区域猎杀树人和林德蠕龙(%killcount%/%maxcount%)");
				}

				this.Contract.m.BulletpointsObjectives.push("随时返回 %townname% 领取报酬");
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home) && this.Flags.get("HeadsCollected") != 0)
				{
					if (this.Contract.m.Size == 0)
					{
						this.Contract.setScreen("SuccessSmall");
					}
					else if (this.Contract.m.Size == 1)
					{
						this.Contract.setScreen("SuccessMedium");
					}
					else
					{
						this.Contract.setScreen("SuccessLarge");
					}

					this.World.Contracts.showActiveContract();
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_killer != null && _killer.getFaction() != this.Const.Faction.Player && _killer.getFaction() != this.Const.Faction.PlayerAnimals)
				{
					return;
				}

				if (this.Flags.get("HeadsCollected") >= this.Contract.m.Payment.MaxCount)
				{
					return;
				}

				if (this.Contract.m.Size == 0)
				{
					if (_actor.getType() == this.Const.EntityType.Ghoul || _actor.getType() == this.Const.EntityType.Direwolf || _actor.getType() == this.Const.EntityType.Spider || _actor.getType() == this.Const.EntityType.Hyena || _actor.getType() == this.Const.EntityType.Serpent)
					{
						this.Flags.set("HeadsCollected", this.Flags.get("HeadsCollected") + 1);
					}
				}
				else if (this.Contract.m.Size == 1)
				{
					if (_actor.getType() == this.Const.EntityType.Alp || _actor.getType() == this.Const.EntityType.Unhold || _actor.getType() == this.Const.EntityType.UnholdFrost || _actor.getType() == this.Const.EntityType.UnholdBog || _actor.getType() == this.Const.EntityType.Hexe)
					{
						this.Flags.set("HeadsCollected", this.Flags.get("HeadsCollected") + 1);
					}
				}
				else if (_actor.getType() == this.Const.EntityType.Lindwurm && !this.isKindOf(_actor, "lindwurm_tail") || _actor.getType() == this.Const.EntityType.Schrat)
				{
					this.Flags.set("HeadsCollected", this.Flags.get("HeadsCollected") + 1);
				}
			}

			function onCombatVictory( _combatID )
			{
				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);
			}

		});
	}

	function createScreens()
	{
		this.importScreens(this.Const.Contracts.NegotiationPerHead);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "TaskSmall",
			Title = "谈判",
			Text = "[img]gfx/ui/events/event_63.png[/img]{你进入 %employer%的房间。 那人正在用孔雀羽毛剔着手指，一边晃着它的鲜艳一边用另一只来钓掉污垢。 他当着你的面轻蔑地说。%SPEECH_ON%我的警卫已经通知我说你对猎兽感兴趣，我很高兴你这么做。 报酬将按人头计算。 野兽，蜘蛛，吃尸体的东西，这类我确信对你来说没有问题，但是当地人害怕面对这些。 如果你像人们说的那样擅长你的工作，那么你就不应该迟迟不肯接受这份工作。 在我的土地上除掉它们。 首先，有人看到它们在离 %worldmapregion% %distance% 的 %direction%%SPEECH_OFF% | %employer% welcomes you into his room. 他拿了一卷先前在市场上散步时镇上宣读告示者给你的卷轴。%SPEECH_ON%唉，那你是来狩猎野兽的。 我以为你是一个…%SPEECH_OFF%他捏了捏你衬衫的边，笑了笑。%SPEECH_ON%不同的种类。好吧，尽管如此，野兽正在破坏乡村，我很乐意付给你一笔可观的钱来照顾它们。 当然，报酬是按人头付的，如果你的那把刀刃锋利，你就可以赚很多钱。 如果你需要一个地方开始你的狩猎，请前往离 %worldmapregion% %distance% 的 %direction% 在那里你发现各种各样的八条腿的怪物和毛茸茸的怪物。 不管是什么都会吓到一个普通农夫，但对你来说没什么可怕的，你这个大块头。%SPEECH_OFF% | 你发现 %employer% 把他的没穿鞋的脚放在桌子上，一群女人在修剪。 他们用拇指从他的脚趾上抠下厚厚的泥，就像是某个异像怪兽的诞生仪式。 你咳嗽了一下。 那人吃惊地也咳嗽了一下。%SPEECH_ON%啊是的，佣兵。 这里，如果你有兴趣的话，我有一个任务给你。%SPEECH_OFF%他不屑一顾地在你脚边扔了一个卷轴，上面列出了杀死野兽的必要性。 蛛魔、小狼。没什么可怕的。 地图上的注释指向 %worldmapregion% 区域的 %direction%。那个人打了个嗝。%SPEECH_ON%报酬将按人头计算，希望这个适合你。%SPEECH_OFF% | 你发现 %employer% 他手里握着一柄锯子。 锯子在分界线那里清楚地锯了下去，锯子使用结束了。 那人把它扔在桌上，拍打着手掌上的锯末。%SPEECH_ON%野兽在这些地方游荡，我需要你手下的人把它们都杀光。 你说什么，哼？ 报酬将按人头计算。 若要开始狩猎，请前往 %worldmapregion% 区域的 %direction%。各种小动物在那里都很讨厌。%SPEECH_OFF% | %employer% 欢迎你来他的房间。 他的桌子上满是卷轴，每个卷轴上都画着动物和野兽，甚至可能还有怪物。 他在嚼浆果，一边说一边吐果汁。%SPEECH_ON%当地人说有一些很令人不快的事情正在发生，尽管没有人能给我一个恰当的描述，说明这是什么麻烦。 关于可怕的狼或八条腿的怪物。 我几乎站不起来什么也做不了，所以我请求你的服务。 前往领地 %worldmapregion% %distance% %direction%。如果你看到任何野兽，就在它们当场杀死它们，并带走它们的头。 我会为头皮付钱的。%SPEECH_OFF% | %employer% 在集会上与一群农夫会面。 他说所谓的怪物正在把腹地撕成碎片。 一个农夫插嘴。%SPEECH_ON%野兽，许多的野兽。 用后腿走路的狼，巨大的蜘蛛，吃尸体的东西，臭气熏天。%SPEECH_OFF%贵族挥挥手。%SPEECH_ON%是的，是的，够了。 佣兵，我需要你出去猎杀这些生物。 先到 %worldmapregion% 区域向 %direction% 行进，确保任何正在进行的野兽都在这片土地上被找到。 带它们的头来, 我将会为每个头买单。 也就是说，如果你有兴趣的话。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{多大的生意？ | 只要价钱合适。 | 继续。 | 你臣民的安全值多少？}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{长途跋涉并不合我口味。 | 我们可不想跑到%worldmapregion%去玩捉迷藏。 | 那不是我们要找的工作。}",
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
			ID = "TaskMedium",
			Title = "谈判",
			Text = "[img]gfx/ui/events/event_63.png[/img]{当你进入时，%employer%正在翻阅一本书。他抬起头来向你招手。%SPEECH_ON%拿一支蜡烛来。%SPEECH_OFF%你从墙上取下一个烛台，贵族却挥舞着他的手。%SPEECH_ON%我说的是蜡烛，不是血淋淋的火把！你打算把我所有的书都烧成灰吗？就呆在原地别动。听着，这些地方的人们一直在谈论着我从未听说过的罪恶。猎杀你梦中的妖怪，比巨人还大的巨兽，当然还有最糟糕的，美丽的女人，她们知道自己有多美丽。%SPEECH_OFF%你对于最后一点并不太确定，但也不敢多说。贵族解释说你要在他的领土上杀死你发现的每一个怪物。%worldmapregion%的%direction%处有目击，但你可以自由地打猎这些生物，无论它们躲在哪里。 | 你发现%employer%正与一些身穿黑斗篷的人交谈。他们招手示意你过去，虽然你心生不满还是走了过去。那个贵族问你是否知道像是Unhold之类的怪物，或是那些以梦为食的生物。在你回答之前，他挥了挥手。%SPEECH_ON%无论如何，我需要一些武装力量穿过%worldmapregion% 的 %direction% 地区，看看是否有什么奇怪的事情。如果它不是人类或者没有心跳，就杀了它并带回它的头颅。我会为每一个头颅付给你丰厚的报酬。当然，前提是它们真的存在。%SPEECH_OFF% | %employer%(雇主)双手捧着卷轴，却没有阅读，而是专注地看着办公桌上的第三卷轴。最后，他将前面两卷甩到了一边，扫除了最后一卷。他看着你。%SPEECH_ON%有消息称有怪物出没。巨人吃掉了牛和孩子。我听到有人做噩梦，为此杀死了邻居。还有一些消息传来，说这个地区有一个美丽的女人。我不知道她是否是某种邪恶生物，但在%worldmapregion%的%direction%地区居住的美丽女人听起来很麻烦。%SPEECH_OFF% 你点了点头。对一个女人来说，独自在一个陌生的地方，那肯定会带来麻烦。贵族张开了双臂。%SPEECH_ON%你能带你的战士去那个地方，找到真相和谎言之间的界限吗？如果你发现了某些类似蛇、嘶嘶声或不是人的东西，请将它们杀死，把它的头带给我。%SPEECH_OFF% | 你发现%employer%(雇主)正低头看书，蜡烛近得让书页边缘的半影都黯淡无光。就像只有他能阅读这些文本一样。看到你，他向你挥手示意你过来。%SPEECH_ON% 我收到了有关%worldmapregion%(世界地图区域)%direction%(方向)的奇怪事件的报告。谋杀案频发，不知何故。还有一些人就这么消失了。这从来不是好兆头。我不知道是邪教还是怪物所为，但我需要一些武装人员去那里搞定它。如果你与超自然之物斗争并获胜，那么把它的头带给我。我会丰厚地支付报酬。%SPEECH_OFF% | %employer%(雇主)正爬在梯子上，翻找他最高的架子。他摇了摇头，示意你进来。%SPEECH_ON%我他妈的不知道我在找什么。%SPEECH_OFF%你点了点头，告诉他你也束手无策。那个人爬了下来。%SPEECH_ON%很有趣，雇佣兵。看，我听到有混乱的消息来自%worldmapregion%%distance%%direction%的地区。那里没多少人居住，但那些居住在那里的人会谈论令人毛骨悚然的恐怖。巨人，感染他们梦境的鬼魂，你叫什么我都有。我需要你带领你的战团去压制那些“沸腾和翻滚”的东西，是吧？如果你找到任何非人类的怪物的头颅，我会为每个怪物付给你不错的报酬。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{多大的生意？ | 只要价钱合适。 | 继续。 | 你臣民的安全值多少？}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{长途跋涉并不合我口味。 | 我们可不想跑到%worldmapregion%去玩捉迷藏。 | 那不是我们要找的工作。}",
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
			ID = "TaskLarge",
			Title = "谈判",
			Text = "[img]gfx/ui/events/event_63.png[/img]{%employer% 坐在办公桌旁。 房间里没有别人。 有一个座位供你坐。他俯身向前。%SPEECH_ON%我的家乡有着某种传说。 我父亲遇到了这个传说，还有我父亲的父亲。 我们不知道传说是从哪里传来的。 我希望在自己的有生之年看到这个传说，现在我觉得我已经看到了。 在梦中，就在昨晚。%SPEECH_OFF%听到这个，你坐在座位的边缘，因为中间有一个洞。 你点了点头，他继续说。%SPEECH_ON%前往 %worldmapregion% 的 %direction%。我相信传说是真的，一只巨大的野兽在这些土地上游荡。 也许不止一个！ 不管有多少，我需要最有经验的佣兵来寻找它。 带上他的头，你会得到丰厚的回报。你愿意吗？%SPEECH_OFF% | 你进入 %employer%的房间。 他给你一个卷轴，上面有一个你看不懂的符号。 贵族说这是一段传奇。 他双臂张开。%SPEECH_ON%树木大小的野兽在这些土地上游荡，我相信是的。在这里 %direction% 的 %worldmapregion%。那里的农民说起大怪物，你简直不敢相信。 但我想相信。 我想近距离看一次，这就是我为什么把你召集到这里来的原因。 到那可怕的地方去，看看有没有什么超凡的生物可杀，把它的头放在我的脚前。%SPEECH_OFF% | %employer% 欢迎你到他的房间做生意。%SPEECH_ON%我要你去 %direction% 的 %worldmapregion%。我记录了无数关于巨兽在那片土地上游荡的谣言，我相信它们的每一句话 树那么大的蛇，和树一样大！ 不管他们是什么，我要你杀了他们，把他们的头给我。 或者鳞片，树枝，随便什么。 我会为你带来的每一件东西付钱。 你对此感兴趣吗？%SPEECH_OFF% | %employer% 给你一本书，有些书页是歪歪扭扭的。 你认为这是对一种极其罕见的材料的一种危险的冒犯，但在这件事上要保持缄默。 贵族问你知不知道巨人，龙，海怪之类的。 在你回答之前，%employer% 把他的手指放在书的打开页上。 他的指关节敲打在一只比橡树还高的野兽的画上，一定程度上的原因是它看起来像一棵橡树。%SPEECH_ON%我认为它们存在。 我想他们现在就在 %worldmapregion%，就在这里的 %direction%。 佣兵，我要你到那里去杀死所有你发现的邪恶生物。 把他们的头给我。 危险无法衡量，但回报将是巨大的。 你觉得自己能干吗？%SPEECH_OFF% | %employer% 以一个即将面对厄运的人的面容欢迎你。 不管怎样，他还是笑了，因为那不是他的厄运。%SPEECH_ON%唉，很高兴看到一个剑客。 我相信你已经听说了，关于 %worldmapregion% 区域绝对有邪恶野兽怀孕的谣言满天飞。.%SPEECH_OFF%你不确定这是否是你要用的措辞，但还是点头。 贵族点头回敬。%SPEECH_ON%我在这个世界上信任的人不多，最近有一个人报告说，他看见一个巨大的生物，虽然他认为它有树那么高。 另一个侦察员说像龙一样大的蛇也在附近游荡。 无论那里有什么，我需要你到这片土地的 %direction% 去，杀掉任何困扰它的东西。 根据报道，这可能是你这辈子做的最危险的事。 你准备好了吗？你们的人准备好了吗？ 我不会雇一个拖拉的人。%SPEECH_OFF%}  ",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{多大的生意？ | 这可不是件小事。 | 只要价钱合适。 | 这恐怕要多花点。 | 你臣民的安全值多少？}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{我们可不想跑到%worldmapregion%去玩捉迷藏。 | 那不是我们要找的工作。 | 我不会让战团冒险对付这样的敌人。}",
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
			ID = "SuccessSmall",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{你回来把这些臭脑袋扔到 %employer%的地板上。 他从办公桌上抬起头来看。%SPEECH_ON%这不够。 把钱拿给这人，找个仆人来收拾这烂摊子。%SPEECH_OFF% | %employer% 欢迎你回来，尽管他与你保持距离。 他盯着你的货物。%SPEECH_ON%一次合适的回程，佣兵。 我会让我的人清点人头，然后按照我们的协议付给你钱。%SPEECH_OFF% | 这是为 %employer% 而杀的。 他点头，挥手示意你把它们带走。%SPEECH_ON%谢谢，但我不需要再看那些可怕的东西了。%randomname%，过来把钱交给他。%SPEECH_OFF% | %employer% 欢迎你回来并检查你的货物。%SPEECH_ON%真恶心。痛快！ 这是你的报酬，和谈好的一样。%SPEECH_OFF% | 你向 %employer% 展示他们的头，他用摆动的手指和嘴唇轻声地数着。 最后，他挺直了身子。%SPEECH_ON%我没时间做这件事。%randomname%，是的，你这个仆人，过来数一下这些人头，然后按约定的金额把每一个人头都付了。%SPEECH_OFF% | %employer% 正在吃苹果，他走过去看你带了什么回来。 他凝视着那袋可怕的兽首。 他咬了一大口苹果。%SPEECH_ON%再见，曾经的朋友。%SPEECH_OFF%他迅速地咀嚼，大口吞下。%SPEECH_ON%看着我的仆人拿着钱包懒洋洋地站在那边。 他会付清你的欠你的钱。%SPEECH_OFF%贵族把吃了一半的苹果扔了，又给自己拿了一个。 | %employer% 在你进入他的房间时带着个孩子。 孩子们跑去看你带来了什么，然后尖叫着撤退。这个贵族点头。%SPEECH_ON%想来那意味着你完成了我的任务。 我的仆人 %randomname% 会数数人头和付钱。%SPEECH_OFF% | 你把头拖进 %employer% 的房间。 他挑了挑眉毛。%SPEECH_ON%你要把它们都拖进来吗？ 看，你留下了一个污点！ 你为什么不去叫一个仆人来，那就是他们存在的意义。 旧神啊，这气味比污迹还糟糕！%SPEECH_OFF%这个贵族向一个拿着钱包的男人打了个响指。%SPEECH_ON%%randomname%，数头，确保佣兵得到报酬。%SPEECH_OFF% | 你展开那袋人头，让他们堆在 %employer%的地板上。他站了起来。%SPEECH_ON%不要在地毯上，好吗？%SPEECH_OFF%一个仆人跑过来，把头踢开了。 他很快摇了摇头。 贵族点了点头，慢慢地坐了下来。%SPEECH_ON%好。你，%randomname%，开始计数，为这些垃圾付给这个佣兵对应的钱。 顺便说一下，佣兵，下次展示别紧张，好吗？%SPEECH_OFF% | 你拖着一袋兽皮和头，走进 %employer%的房间。 打开盖子，你开始把它向前倾斜。 一个仆人瞪大了眼睛，冲过来，砰地一声撞在袋子上，把它倾斜回去。 盖子哗啦一声盖住了他的手指，他发出一声惨叫。%SPEECH_ON%谢谢你，雇佣兵，但是尊贵的先生希望我们数的时候不要弄得满地都是。 我把总数加起来，完成就钱付给你。%SPEECH_OFF% | %employer% 评价你的工作。%SPEECH_ON%令人印象深刻。恶心。不是你，是野兽。 我的意思是你是一个肮脏的家伙，佣兵，但是这些肮脏的畜生是卫生的对立面。%SPEECH_OFF%你不知道那个词是什么意思，也不知道另一个词是什么意思。 你只是让他数一数人头，然后给你钱。 | %employer% 数人头，然后向后靠。他耸耸肩。%SPEECH_ON%我以为他们会更可怕。%SPEECH_OFF%你提到，当它们仍然长在野兽躯体上时，他们对勇气的影响相当不同。 贵族又耸耸肩。%SPEECH_ON%我想是这样的，但是我母亲的头被行刑者的刀割掉了，她躺在篮子里凝视着这个世界的样子看起来更可怕。%SPEECH_OFF%你不知道该说些什么。 你要求他把你的钱给你。 | %employer% 盯着你放在他地板上的兽头。 一个拿着扫帚的仆人一个一个地数，从一堆中减去，加到另一堆中。 当他完成计数工作后，他报告了他的数字，贵族点了点头。%SPEECH_ON%干得好，佣兵。仆人会给你钱。%SPEECH_OFF%那个低出身的人叹气然后收起扫帚。 | %employer% 打开装有野兽头皮和头骨的袋子。 他噘起嘴唇，嗅了嗅，又拍了拍，合上了。 贵族命令他的一个仆人数出剩余的钱，然后按照协议付给你。%SPEECH_ON%做得好，佣兵。 镇上的人都很感激我花钱雇你来处理这件事。%SPEECH_OFF% | %employer% 吹着口哨，盯着你收集的头骨和头皮。%SPEECH_ON%如果真有一声叹息，那将是一声地狱般的叹息。 对于这种性质恶劣的工作，我应该考虑给你额外的报酬，我是不会付的，但这个想法掠过我的脑海，这才是最重要的。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "一场成功的狩猎。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.Assets.addMoney(this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected"));
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, function ()
						{
							return this.RenderTemplate("猎杀游荡在%s的野兽", this.World.State.getRegion(this.Flags.get("Region")).Name);
						}());
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				local money = this.Contract.m.Payment.getOnCompletion() + this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected");
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color]克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "SuccessMedium",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{你回来把这些臭脑袋扔到 %employer%的地板上。 他从办公桌上抬起头来看。%SPEECH_ON%这不够。 把钱拿给这人，找个仆人来收拾这烂摊子。%SPEECH_OFF% | %employer% 欢迎你回来，尽管他与你保持距离。 他盯着你的货物。%SPEECH_ON%一次合适的回程，佣兵。 我会让我的人清点人头，然后按照我们的协议付给你钱。%SPEECH_OFF% | 这是为 %employer% 而杀的。 他点头，挥手示意你把它们带走。%SPEECH_ON%谢谢，但我不需要再看那些可怕的东西了。%randomname%，过来把钱交给他。%SPEECH_OFF% | %employer% 欢迎你回来并检查你的货物。%SPEECH_ON%真恶心。痛快！ 这是你的报酬，和谈好的一样。%SPEECH_OFF% | 你向 %employer% 展示他们的头，他用摆动的手指和嘴唇轻声地数着。 最后，他挺直了身子。%SPEECH_ON%我没时间做这件事。%randomname%，是的，你这个仆人，过来数一下这些人头，然后按约定的金额把每一个人头都付了。%SPEECH_OFF% | %employer% 正在吃苹果，他走过去看你带了什么回来。 他凝视着那袋可怕的兽首。 他咬了一大口苹果。%SPEECH_ON%再见，曾经的朋友。%SPEECH_OFF%他迅速地咀嚼，大口吞下。%SPEECH_ON%看着我的仆人拿着钱包懒洋洋地站在那边。 他会付清你的欠你的钱。%SPEECH_OFF%贵族把吃了一半的苹果扔了，又给自己拿了一个。 | %employer% 在你进入他的房间时带着个孩子。 孩子们跑去看你带来了什么，然后尖叫着撤退。这个贵族点头。%SPEECH_ON%想来那意味着你完成了我的任务。 我的仆人 %randomname% 会数数人头和付钱。%SPEECH_OFF% | 你把头拖进 %employer% 的房间。 他挑了挑眉毛。%SPEECH_ON%你要把它们都拖进来吗？ 看，你留下了一个污点！ 你为什么不去叫一个仆人来，那就是他们存在的意义。 旧神啊，这气味比污迹还糟糕！%SPEECH_OFF%这个贵族向一个拿着钱包的男人打了个响指。%SPEECH_ON%%randomname%，数头，确保佣兵得到报酬。%SPEECH_OFF% | 你展开那袋人头，让他们堆在 %employer%的地板上。他站了起来。%SPEECH_ON%不要在地毯上，好吗？%SPEECH_OFF%一个仆人跑过来，把头踢开了。 他很快摇了摇头。 贵族点了点头，慢慢地坐了下来。%SPEECH_ON%好。你，%randomname%，开始计数，为这些垃圾付给这个佣兵对应的钱。 顺便说一下，佣兵，下次展示别紧张，好吗？%SPEECH_OFF% | 你拖着一袋兽皮和头，走进 %employer%的房间。 打开盖子，你开始把它向前倾斜。 一个仆人瞪大了眼睛，冲过来，砰地一声撞在袋子上，把它倾斜回去。 盖子哗啦一声盖住了他的手指，他发出一声惨叫。%SPEECH_ON%谢谢你，雇佣兵，但是尊贵的先生希望我们数的时候不要弄得满地都是。 我把总数加起来，完成就钱付给你。%SPEECH_OFF% | %employer% 评价你的工作。%SPEECH_ON%令人印象深刻。恶心。不是你，是野兽。 我的意思是你是一个肮脏的家伙，佣兵，但是这些肮脏的畜生是卫生的对立面。%SPEECH_OFF%你不知道那个词是什么意思，也不知道另一个词是什么意思。 你只是让他数一数人头，然后给你钱。 | %employer% 数人头，然后向后靠。他耸耸肩。%SPEECH_ON%我以为他们会更可怕。%SPEECH_OFF%你提到，当它们仍然长在野兽躯体上时，他们对勇气的影响相当不同。 贵族又耸耸肩。%SPEECH_ON%我想是这样的，但是我母亲的头被行刑者的刀割掉了，她躺在篮子里凝视着这个世界的样子看起来更可怕。%SPEECH_OFF%你不知道该说些什么。 你要求他把你的钱给你。 | %employer% 盯着你放在他地板上的兽头。 一个拿着扫帚的仆人一个一个地数，从一堆中减去，加到另一堆中。 当他完成计数工作后，他报告了他的数字，贵族点了点头。%SPEECH_ON%干得好，佣兵。仆人会给你钱。%SPEECH_OFF%那个低出身的人叹气然后收起扫帚。 | %employer% 打开装有野兽头皮和头骨的袋子。 他噘起嘴唇，嗅了嗅，又拍了拍，合上了。 贵族命令他的一个仆人数出剩余的钱，然后按照协议付给你。%SPEECH_ON%做得好，佣兵。 镇上的人都很感激我花钱雇你来处理这件事。%SPEECH_OFF% | %employer% 吹着口哨，盯着你收集的头骨和头皮。%SPEECH_ON%如果真有一声叹息，那将是一声地狱般的叹息。 对于这种性质恶劣的工作，我应该考虑给你额外的报酬，我是不会付的，但这个想法掠过我的脑海，这才是最重要的。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "一场成功的狩猎。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.Assets.addMoney(this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected"));
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, function ()
						{
							return this.RenderTemplate("猎杀游荡在%s的野兽", this.World.State.getRegion(this.Flags.get("Region")).Name);
						}());
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				local money = this.Contract.m.Payment.getOnCompletion() + this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected");
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color]克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "SuccessLarge",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{你把剩下的猎物拖进 %employer%的房间。 他向后一跳，好像是你控制了野兽并骑着它来征服的。 那个贵族紧抓着胸口，往后退了一步。%SPEECH_ON%旧神啊，佣兵，如果你不是那么傻，你会把它留在院子里，然后带我去看。%SPEECH_OFF%耸耸肩，你问了问你的报酬。 他问你是怎么杀死它的。 你回到了工资的问题上。 贵族擦擦他的嘴唇。%SPEECH_ON%好的。仆人！给这个顽固的野兽杀手他的硬币。%SPEECH_OFF% | 你把这具野兽的尸体拖到院子里，然后叫 %employer%。他走到窗前，向下看了很长时间。%SPEECH_ON%这是真的还是你在开玩笑？%SPEECH_OFF%你叹了口气，拔出剑来，扎进一只大眼睛里。 砰的一声，它泄了气，喷出黄色的烟雾覆盖周围的泥土。 贵族吹着口哨，咯咯地叫着。%SPEECH_ON%旧神啊，真希望你没这么做！ 我马上派人给你拿工资来！%SPEECH_OFF% | 你拉一头驴去帮忙，让它帮助把被杀的憎恶者拖进城镇。 它轻轻一摇耳朵，无声地凝视着它那弯曲的、不属于世界的行李。%employer% 在他的领域之外会见你。 他站在一堆奇形怪状的残骸旁边，下巴抵在一根手指和拇指的凹角里。%SPEECH_ON%难以置信。我无法想象它在活着和战斗时的样子。%SPEECH_OFF%你点头，你让那个人知道毫无疑问还有更多这样的，他应该在你下次狩猎时一起来。 他摇了摇头。%SPEECH_ON%我将拒绝那个提议，佣兵。 这是你的工资，我命令你把那头驴还给它的主人。%SPEECH_OFF%一个农夫大步走来，用布擦了擦前额。%SPEECH_ON%这东西叫骡子，如果你想借这该死的东西，你可以直接说！%SPEECH_OFF% | 你把野兽尸体切碎，然后一件件地拖进 %employer%的房间。 当尸体堆积起来的时候，他用一块布捂住鼻子。%SPEECH_ON%所以神话是真实的。 这些野兽是真的。%SPEECH_OFF%几个仆人把肉块重新拼在一起，形成了一个每当他们松开手，肉块就会分开的畸形的怪兽形象。 贵族点了点头，打了个响指。%SPEECH_ON%把钱付给雇佣兵，把我的顾问找来。%SPEECH_OFF% | 一个 %employer%的人站在一边拿着刀，准备凿开野兽的残骸。 他咧嘴大笑。%SPEECH_ON%姓氏可以深入骨髓，用作斧头或剑的柄。%SPEECH_OFF%你告诉那两个人不要碰那该死的东西，除非他们付钱给你。贵族笑了。%SPEECH_ON%没必要这么暴躁，雇佣兵。 我有个仆人现在在取你的工钱。 如果你敢再用这种腔调说话，我就取下你的舌头，不管你是不是怪物杀手。%SPEECH_OFF%你用你的手叉着腰，在你的头脑里倒计时，表现出你的耐心。 值得每个人庆幸的是，仆人在数到零之前到达。 | %employer% 像个孩子一样，对着这些残破的遗骸拍手叫好。%SPEECH_ON%关于我的所作所为的故事将会是伟大的。 我要用这些骨头做武器和把手，讲我怎样得到那些怪物的头的故事。%SPEECH_OFF%你点头。听起来不错。反正历史书上也不会记载你的名字。 你要求付钱。 点着头，目不转睛地盯着那家伙，%employer% 啪地打着他的手指。%SPEECH_ON%仆人！把他的硬币给他！%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "一场成功的狩猎。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.Assets.addMoney(this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected"));
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, function ()
						{
							return this.RenderTemplate("猎杀游荡在%s的野兽", this.World.State.getRegion(this.Flags.get("Region")).Name);
						}());
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				local money = this.Contract.m.Payment.getOnCompletion() + this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected");
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color]克朗"
				});
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		local dest = this.World.State.getRegion(this.m.Flags.get("Region")).Center;
		local distance = this.World.State.getPlayer().getTile().getDistanceTo(dest);
		distance = this.Const.Strings.Distance[this.Math.min(this.Const.Strings.Distance.len() - 1, distance / 30.0 * (this.Const.Strings.Distance.len() - 1))];
		_vars.push([
			"killcount",
			this.m.Flags.get("HeadsCollected")
		]);
		_vars.push([
			"noblehousename",
			this.World.FactionManager.getFaction(this.m.Faction).getNameOnly()
		]);
		_vars.push([
			"worldmapregion",
			this.World.State.getRegion(this.m.Flags.get("Region")).Name
		]);
		_vars.push([
			"direction",
			this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(dest)]
		]);
		_vars.push([
			"distance",
			distance
		]);
		_vars.push([
			"regiontype",
			this.Const.Strings.TerrainShort[this.World.State.getRegion(this.m.Flags.get("Region")).Type]
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		return true;
	}

	function onIsTileUsed( _tile )
	{
		return false;
	}

	function onSerialize( _out )
	{
		_out.writeU8(this.m.Size);
		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.m.Size = _in.readU8();
		this.contract.onDeserialize(_in);
	}

});
