this.big_game_hunt_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Size = 0,
		Dude = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.big_game_hunt";
		this.m.Name = "狩猎大型猎物";
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
				this.Contract.m.BulletpointsObjectives.push("随时返回%townname%领取报酬");

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
						this.Contract.m.BulletpointsObjectives.push("在%worldmapregion%的%regiontype%区域猎杀恐狼、蛛魔和食尸鬼(%killcount%/%maxcount%)");
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

				this.Contract.m.BulletpointsObjectives.push("随时返回%townname%领取报酬");
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
			Text = "[img]gfx/ui/events/event_63.png[/img]{你走进%employer%的房间。这人正用孔雀羽毛剔手指，一边晃着带色彩斑斓的尾端，一边用羽根挑出污垢。他对你的到来态度相当敷衍。%SPEECH_ON%我的守卫已经告知我你对狩猎野兽有兴趣，我很高兴你这样。报酬按头计算。小型的野兽、蛛魔、吃尸体的玩意儿，这类东西对您来说肯定不算什么麻烦，但当地老乡们可吓得不敢对付。如果你真像大家说的那么能干，就不该犹豫接这活儿。替我把这些祸害从领地上清除掉。%direction%方向%distance%的%worldmapregion%地区有过目击，你们可以从那着手开始。%SPEECH_OFF% | %employer%欢迎你进入他的房间。他拿过你早先穿行市集时公告员给你的卷轴。%SPEECH_ON%啊，那么你是为狩猎野兽而来的。我还以为你是其他……%SPEECH_OFF%他捏了捏你的衣角，歪嘴一笑。%SPEECH_ON%类型的乐子。好吧，总之，野兽正在乡间肆虐，我很乐意付你一笔可观的酬劳来处理它们。报酬当然是按头计算，只要你让那把刀保持利落，就能赚大钱。如果你需要个开始狩猎的地方，就去%direction%方向%distance%处%的worldmapregion%地区。在那儿你能找到各式各样的八条腿怪胎和毛茸茸的怪物。不管是什么能把普通农夫吓破胆的东西，对你来说都不在话下，对吧，你这大块头。%SPEECH_OFF% | 你看到%employer%光着脚搭在桌上，一群女人正在打理他的脚。她们从他脚趾缝里抠出结成块的泥垢，仿佛在举行某种成虫怪物的诞生仪式。你清了清嗓子。这人受惊似的也清了清嗓子回应。%SPEECH_ON%啊对，佣兵。听着，我这儿有个差事，如果你感兴趣的话。%SPEECH_OFF%他漫不经心地朝你脚边扔了卷轴，上面列着需要猎杀的野兽：蛛魔、瘦狼。没什么太吓人的。地图上的标注指向%direction%的%worldmapregion%地区。这人打了个嗝。%SPEECH_ON%报酬按头算，希望这合你意。%SPEECH_OFF% | 你看到%employer%手里正转动着一把刀柄。柄和本该是刀刃的地方分界处已经明显开裂，表明这武器彻底报废了。这人把它扔到桌上，拍掉手上的木屑。%SPEECH_ON%有野兽在这带出没，我需要你这样的人把它们全宰了。你觉得呢，嗯？报酬按头计算。要开始狩猎，就去%direction%方向的%worldmapregion%地区。各种各样的小型野兽正在那里捣乱。%SPEECH_OFF% | %employer%将你迎进他的房间。 他的桌上铺满了卷轴，每张都画着动物、野兽，甚至可能是怪物。他正嚼着些浆果，说话时汁水四溅。%SPEECH_ON%当地人说有脏东西在活动，但没一个人能跟我好好说说到底是个什么麻烦。好像是关于怪狼或者八条腿的怪物之类的事。我总不能干站着什么都不做，所以才请你来帮忙。去%direction%方向的%distance%处的%worldmapregion%。如果你看到任何野兽，就当场宰了，把它们的头带回来。我按数量付钱。%SPEECH_OFF% | %employer%与一群农民商议时接待了你。他说据称有怪物把偏远地区搅得天翻地覆。一个农民插嘴道：%SPEECH_ON%都是野兽，一群祸害。用后腿走路的狼，这么大的蜘蛛，还有散发着恶臭专吃尸体的玩意儿。%SPEECH_OFF%贵族摆了摆手。%SPEECH_ON%是，是，够了。佣兵，我需要你出发去猎杀这些生物。先从从这里%direction%的%worldmapregion%地区开始，确保把所有活动的野兽都解决掉。但务必把它们的头带回来，我会按每个头付钱。当然，前提是你感兴趣。%SPEECH_OFF%}",
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
					Text = "{我不喜欢长途跋涉。 | 我们可不想跑到%worldmapregion%去玩捉迷藏。 | 我们不想接这类差事。}",
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
			Text = "[img]gfx/ui/events/event_63.png[/img]{你进门时%employer%正在翻动古籍。他抬头招手让你过去。%SPEECH_ON%拿支蜡烛来。%SPEECH_OFF%你从墙上取下一支烛台，这位贵族立刻举起双手。%SPEECH_ON%我说蜡烛没让你拿整个烛台！你想把我这些藏书全烧成灰吗？就站那儿别动。听着，这带居民最近谈论的邪物我都几十年没听说过了——有蚕食梦境的怪物，胡子能藏进一整个人的巨人，最糟的是……自知貌美的女人。%SPEECH_OFF%你对最后一项存疑，但没作声。贵族接着命令你在其领地内清剿所有发现的此类生物，%worldmapregion%的%direction%已有目击报告，但你可自行选择狩猎的地方。 | 你看见%employer%正与几位黑袍人交谈。他们示意你上前，你勉强照做。贵族问你是否知晓巨魔或食梦妖这类怪物，不等回答就摆手道。%SPEECH_ON%无所谓了。需要你带人去%direction%的%worldmapregion%地区搜查异常。只要不是活人，格杀勿论，带着首级回来。每具首级重金酬谢——如果它们真的存在。%SPEECH_OFF% | %employer%双手各执一卷文书掂量，眼睛却盯着桌上第三卷。最后他扔开手中卷轴扫开桌案，看向你。%SPEECH_ON%到处都在流传怪物出没的消息。有吃牛羊小孩的巨人，还有人做了噩梦然后为此杀害邻居。在%direction%方向的%worldmapregion%那边还冒出个漂亮女人。不知道她是不是什么邪门玩意儿，但一个女的独自在荒郊野外晃荡听着就像是个麻烦。%SPEECH_OFF%你点点头。一个女子独自出现在陌生地域，这准要有人倒霉。贵族张开双臂。%SPEECH_ON%带你的人去查清楚怎么回事。要是碰到会爬会叫的怪东西，只要不是人，就直接宰了把脑袋带回来。%SPEECH_OFF% | 你看见%employer%正借着烛光翻阅书籍，蜡烛离书页太近，连书本边缘的半影都被烛光吞没，仿佛这些典籍只配由他独享。见到你后，他招手示意上前。%SPEECH_ON%我收到报告说%direction%的%worldmapregion%有怪事发生。命案数量在增加，我完全搞不懂原因。还有些人直接失踪了。这可不是好兆头。不知道是邪教还是怪物搞的鬼，但我需要些会耍刀剑去整顿局面。要是你跟什么邪门东西动了手，就把它的脑袋带回来——我会按数量给你计价的。%SPEECH_OFF% | 你发现%employer%正搭着梯子在顶层书架翻找。他摇摇头招手让你进来。%SPEECH_ON%我他妈根本不知道自己在找什么。%SPEECH_OFF%你点头说彼此彼此。他爬下梯子。%SPEECH_ON%真幽默啊佣兵。听着，%direction%方向%distance%的%worldmapregion%地区。据说乱成一团。那带居民不多，但住那儿的人都在说地上爬满了恐怖玩意——巨人啊、缠人梦境的恶灵啊，要啥有啥。需要你带手下平息那些搞鬼的东西，懂吗？任何非人怪物的脑袋都给我带回来，每个都重重有赏。%SPEECH_OFF%}",
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
					Text = "{我不喜欢长途跋涉。 | 我们可不想跑到%worldmapregion%去玩捉迷藏。 | 我们不想接这类差事。}",
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
			Text = "[img]gfx/ui/events/event_63.png[/img]{%employer%坐在桌旁。房间里没有其他人。他示意你就座，你便坐下。他向前倾身。%SPEECH_ON%我的家族有个传说。我父亲遇到过这个传说，我父亲的父亲也遇到过。我们不知道这传说从何而来。我曾期望在我的有生之年能亲眼见到这个传说，而我觉得现在时候到了。就在昨晚，在一个梦里。%SPEECH_OFF%听到这里，你坐到椅子边缘，因为椅子中间有个洞。你点点头，他继续说道。%SPEECH_ON%前往%direction%的%worldmapregion%。我相信这些传说是真的，有巨大的野兽在那片土地上游荡。可能还不止一头！不管有多少，我需要最有经验的佣兵去找到它。把它们的头带给我，你会得到丰厚的回报。你愿意吗？%SPEECH_OFF% | 你走进%employer%的房间。他推给你一卷卷轴，上面是一种你看不懂的文字。这位贵族称那是一段传说记载。他张开双臂。%SPEECH_ON%我相信，有像树那么大的野兽在这片土地上漫步。这里%direction%的%worldmapregion%。那里的农民提到过令人难以置信的巨大怪物。但我愿意相信。我想近距离见识一下，所以我才找你过来。去那片可怕的土地，杀死任何非自然的生物，并把它们的头颅带到我的脚下。%SPEECH_OFF% | %employer%欢迎你进入他的房间，然后直接切入正题。%SPEECH_ON%我需要你前往%direction%的%worldmapregion%。我记录了许多关于巨大野兽在那片土地上出没的传闻，并且我深信不疑。有像树一样大的蛇，还有模仿树的玩意儿，也跟树一样大！管它们到底是什么，我要你杀了它们，把它们的头带给我。或者鳞片、树枝，随便什么都行。你带回来的每一样我都会付钱。这活儿你感兴趣吗？%SPEECH_OFF% | %employer%递给你一本大部头，有些书页折了角。你觉得这对这种无疑很珍贵的资料来说是一种危险的亵渎，但你还是忍住没说。贵族问你是否知道巨人、龙、海怪之类的东西。没等你回答，%employer%就把手指按在书本打开的页面上。他的指关节抵着的是比橡树还高的怪兽——也可能是因为它看起来就像是一棵橡树。%SPEECH_ON%我认为它们存在。我认为它们此刻就在%worldmapregion%，就在这里的%direction%边。 佣兵，我要你前往那里，杀死你找到的每一个邪恶生物。把它们的头带给我。危险无法估量，但回报将是巨大的。你认为自己有能力做到吗？%SPEECH_OFF% | %employer%面带一副要送人去赴死的表情迎接你。不过他还是笑了，毕竟去送死的不是他。%SPEECH_ON%啊，见到一位使剑的好汉真是太好了。想必你也听说了，传闻沸沸扬扬，说%worldmapregion%地区到处都孕育着邪恶的野兽。.%SPEECH_OFF%你不确定自己是否会这么措辞，但还是点了点头。贵族也点头回应。%SPEECH_ON%这世上我信任的人没几个，其中一个最近报告说看到了一个巨大得无法估量的生物，不过他估计那东西和树一样高。另一个哨兵也说，有像龙那么大的蛇也在那片地方游荡。不管那里有什么，我需要你去%direction%杀死任何在那里作祟的东西。根据报告，这可能是你此生所做的最危险的事情。你准备好了吗？你的手下准备好了吗？我绝不会雇佣任何有丝毫拖延的人。%SPEECH_OFF%}  ",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{多大的生意？ | 这可不是件小事。 | 只要价钱合适。 | 这种工作最好多给点钱。 | 你臣民的安全值多少？}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{我们可不想跑到%worldmapregion%去玩捉迷藏。 | 我们不想接这类差事。 | 我不会让战团冒险对付这样的敌人。}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{你回来把野兽脑袋倒在%employer%地板上。他从书桌抬起头。%SPEECH_ON%这可真够多余的。给这人拿钱，再叫个仆人来收拾。%SPEECH_OFF% | %employer%迎接你归来，但保持着距离。他盯着你带来的东西。%SPEECH_ON%回来得正好，佣兵。我让手下清点脑袋，按说好的付钱。%SPEECH_OFF% | 猎杀的成果呈给%employer%过目。他点头挥手让你离开。%SPEECH_ON%谢了，但我可不想再看这些吓人玩意。%randomname%，过来把钱给他。%SPEECH_OFF% | %employer%迎接你回来，检查你的货物。%SPEECH_ON%真恶心。太好了！按说好的给你报酬。%SPEECH_OFF% | 你把脑袋给%employer%看，他晃着手指默数。最后直起身。%SPEECH_ON%没空理这破事。%randomname%，对就是你，过来数脑袋按个数付佣兵钱。%SPEECH_OFF% | %employer%啃着苹果来看你带回什么。他朝兽头袋子瞅了眼，接着咬了一大口苹果。%SPEECH_ON%厉害啊，佣兵。%SPEECH_OFF%他快速嚼了几口然后猛地吞下。%SPEECH_ON%看见那边拿钱袋闲站的仆人没？他会付你该得的。%SPEECH_OFF%贵族扔掉手中的半截苹果，又拿个新的。 | 你进屋时%employer%正带着孩子。小孩冲来看你带的东西，尖叫着跑开。贵族点头。%SPEECH_ON%看来你搞定我付钱要的东西了。仆人%randomname%会算好脑袋数并付钱。%SPEECH_OFF% | 你把脑袋拖进%employer%的房间。 他挑了挑眉毛。%SPEECH_ON%非得拖进来？都留印子了！怎么不叫仆人？他们就是干这活的。旧神啊，这味道还这么冲！%SPEECH_OFF%贵族对拿钱袋的人打响指。%SPEECH_ON%%randomname%，数头，然后给佣兵结账。%SPEECH_OFF% | 你抖开袋子，把脑袋堆在%employer%的地板上。他起身说道。%SPEECH_ON%没在地毯上吧？%SPEECH_OFF%仆人冲来踢散脑袋，急忙摇头。贵族缓缓坐下。%SPEECH_ON%很好，%randomname%，你去数好脑袋个数，然后给这捣蛋佣兵结账，对了佣兵，下次展示战利品时注意点行不？%SPEECH_OFF% | 你拖着一袋兽头走进%employer%的房间。掀盖要倒时，一个仆人瞪大了眼睛冲上前，撞在袋子上把它又推正了回去。盖子啪地合上夹住了他的手指，他忍住了痛呼。%SPEECH_ON%谢了佣兵，但老爷希望我们数的时候不要洒得满地都是。我算完总数就付钱。%SPEECH_OFF% | %employer%检查你的成果。%SPEECH_ON%厉害。恶心。不是说你，是说野兽。你这人是脏，但这些畜生简直是卫生的反义词。%SPEECH_OFF%你听不懂倒数一个词是什么意思，也听不懂倒数第二个词是什么意思，只是直接要他数脑袋给钱。 | %employer%数完脑袋往后靠。耸肩道。%SPEECH_ON%我以为他们会更吓人。%SPEECH_OFF%你说这些脑袋连着身子的时候会更吓人一点。贵族又耸肩道%SPEECH_ON%可能吧，但我妈被砍头后搁篮子里瞪眼的样子才叫吓人。%SPEECH_OFF%你无言以对，直接要钱。 | %employer%盯着你放在他地板上的兽头。一个拿着扫帚的仆人逐个把脑袋从一堆移到另一堆，边移边计数。移完后向贵族汇报总数，后者点了点头。%SPEECH_ON%干得好佣兵。仆人会给你拿钱。%SPEECH_OFF%下人叹了口气，然后收起扫帚。 | %employer%打开那袋野兽头皮和头骨。他抿紧嘴唇，嗅了嗅，啪地一声又把袋子合上。贵族吩咐他的一个仆人去清点这些残骸，并按协议付你报酬。%SPEECH_ON%干得不错，佣兵。镇民们很感激我花钱请你来处理这事。%SPEECH_OFF% | %employer%盯着你收集的头骨和头皮，吹了声口哨。%SPEECH_ON%这要是叹气的话可真是叹到家了。对于这种恶心活儿，我倒是考虑过该给你加点钱——虽然我不会加——但这个念头确实在我脑子里闪过，而这才是最重要的。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "狩猎成功。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.Assets.addMoney(this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected"));
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, function ()
						{
							return this.RenderTemplate("猎杀在%s附近游荡的野兽", this.World.State.getRegion(this.Flags.get("Region")).Name);
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{你回来把野兽脑袋倒在%employer%地板上。他从书桌抬起头。%SPEECH_ON%这可真够多余的。给这人拿钱，再叫个仆人来收拾。%SPEECH_OFF% | %employer%迎接你归来，但保持着距离。他盯着你带来的东西。%SPEECH_ON%回来得正好，佣兵。我让手下清点脑袋，按说好的付钱。%SPEECH_OFF% | 猎杀的成果呈给%employer%过目。他点头挥手让你离开。%SPEECH_ON%谢了，但我可不想再看这些吓人玩意。%randomname%，过来把钱给他。%SPEECH_OFF% | %employer%迎接你回来，检查你的货物。%SPEECH_ON%真恶心。太好了！按说好的给你报酬。%SPEECH_OFF% | 你把脑袋给%employer%看，他晃着手指默数。最后直起身。%SPEECH_ON%没空理这破事。%randomname%，对就是你，过来数脑袋按个数付佣兵钱。%SPEECH_OFF% | %employer%啃着苹果来看你带回什么。他朝兽头袋子瞅了眼，接着咬了一大口苹果。%SPEECH_ON%厉害啊，佣兵。%SPEECH_OFF%他快速嚼了几口然后猛地吞下。%SPEECH_ON%看见那边拿钱袋闲站的仆人没？他会付你该得的。%SPEECH_OFF%贵族扔掉手中的半截苹果，又拿个新的。 | 你进屋时%employer%正带着孩子。小孩冲来看你带的东西，尖叫着跑开。贵族点头。%SPEECH_ON%看来你搞定我付钱要的东西了。仆人%randomname%会算好脑袋数并付钱。%SPEECH_OFF% | 你把脑袋拖进%employer%的房间。 他挑了挑眉毛。%SPEECH_ON%非得拖进来？都留印子了！怎么不叫仆人？他们就是干这活的。旧神啊，这味道还这么冲！%SPEECH_OFF%贵族对拿钱袋的人打响指。%SPEECH_ON%%randomname%，数头，然后给佣兵结账。%SPEECH_OFF% | 你抖开袋子，把脑袋堆在%employer%的地板上。他起身说道。%SPEECH_ON%没在地毯上吧？%SPEECH_OFF%仆人冲来踢散脑袋，急忙摇头。贵族缓缓坐下。%SPEECH_ON%很好，%randomname%，你去数好脑袋个数，然后给这捣蛋佣兵结账，对了佣兵，下次展示战利品时注意点行不？%SPEECH_OFF% | 你拖着一袋兽头走进%employer%的房间。掀盖要倒时，一个仆人瞪大了眼睛冲上前，撞在袋子上把它又推正了回去。盖子啪地合上夹住了他的手指，他忍住了痛呼。%SPEECH_ON%谢了佣兵，但老爷希望我们数的时候不要洒得满地都是。我算完总数就付钱。%SPEECH_OFF% | %employer%检查你的成果。%SPEECH_ON%厉害。恶心。不是说你，是说野兽。你这人是脏，但这些畜生简直是卫生的反义词。%SPEECH_OFF%你听不懂倒数一个词是什么意思，也听不懂倒数第二个词是什么意思，只是直接要他数脑袋给钱。 | %employer%数完脑袋往后靠。耸肩道。%SPEECH_ON%我以为他们会更吓人。%SPEECH_OFF%你说这些脑袋连着身子的时候会更吓人一点。贵族又耸肩道%SPEECH_ON%可能吧，但我妈被砍头后搁篮子里瞪眼的样子才叫吓人。%SPEECH_OFF%你无言以对，直接要钱。 | %employer%盯着你放在他地板上的兽头。一个拿着扫帚的仆人逐个把脑袋从一堆移到另一堆，边移边计数。移完后向贵族汇报总数，后者点了点头。%SPEECH_ON%干得好佣兵。仆人会给你拿钱。%SPEECH_OFF%下人叹了口气，然后收起扫帚。 | %employer%打开那袋野兽头皮和头骨。他抿紧嘴唇，嗅了嗅，啪地一声又把袋子合上。贵族吩咐他的一个仆人去清点这些残骸，并按协议付你报酬。%SPEECH_ON%干得不错，佣兵。镇民们很感激我花钱请你来处理这事。%SPEECH_OFF% | %employer%盯着你收集的头骨和头皮，吹了声口哨。%SPEECH_ON%这要是叹气的话可真是叹到家了。对于这种恶心活儿，我倒是考虑过该给你加点钱——虽然我不会加——但这个念头确实在我脑子里闪过，而这才是最重要的。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "狩猎成功。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.Assets.addMoney(this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected"));
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, function ()
						{
							return this.RenderTemplate("猎杀在%s附近游荡的野兽", this.World.State.getRegion(this.Flags.get("Region")).Name);
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{你把猎物的残骸拖进%employer%的房间。他向后跳开，仿佛你驯服了这头野兽并骑着它来征服他似的。这位贵族捂着胸口重新坐下。%SPEECH_ON%旧神啊，佣兵，你要不是没这么蠢，就该把那玩意儿留在院子里，然后请我下去看的。%SPEECH_OFF%你耸耸肩，问起你的报酬。他却问你是怎么杀死它的。你又把话题拉回报酬上。贵族抿了抿嘴唇。%SPEECH_ON%行了。仆人！给这个固执的野兽杀手拿钱来。%SPEECH_OFF% | 你把野兽的残骸拖进院子，朝楼上的%employer%喊话。他走到窗边，向下看了好久。%SPEECH_ON%真的假的？你不是在开玩笑吧？%SPEECH_OFF%你叹了口气，拔出剑刺进其中一只巨大的眼球。随着噗的一声，眼球瘪了下去，黄色的黏液喷了一地。贵族吹了声口哨，咂了咂舌。%SPEECH_ON%旧神啊，你还真办到了！我这就让仆人把你的报酬拿来！%SPEECH_OFF% | 你征用了一头驴来帮忙把杀死的恶心怪物拖进镇子。它甩了甩耳朵，默默盯着自己驮着的扭曲又诡异的行李。%employer%在他的地盘外迎接你。他站在怪物残骸旁边，手指托着下巴。%SPEECH_ON%难以置信。我简直无法想象它活着打斗时是什么样子。%SPEECH_OFF%你点点头，告诉他外面无疑还有更多这样的家伙，下次你去狩猎时他应该一起来。他摇了摇头。%SPEECH_ON%容我拒绝，佣兵。这是你的报酬，我命令你把这头驴还给它的主人。%SPEECH_OFF%一个农夫大步走来，用布擦着额头。%SPEECH_ON%这叫骡子，你想借这该死的东西，开口问一声不行吗！%SPEECH_OFF% | 你把野兽尸体剁碎，然后一件件地拖进%employer%的房间。他拿了块布捂住鼻子看着你堆起一座肉山。%SPEECH_ON%所以看来传说是真的。这些野兽确实存在。%SPEECH_OFF%几个仆人试图把肉块拼回去，组成了一个畸形的怪物形象，但每次一松手肉块就散落开来。贵族点了点头，打了个响指。%SPEECH_ON%给佣兵拿报酬，再把我的顾问们叫来。%SPEECH_OFF% | 一个%employer%的人拿着刻刀站在一旁，准备在野兽残骸上雕刻。他疯狂地咧嘴笑着。%SPEECH_ON%可以把家族名号刻在骨头上，用来做斧头或剑的柄。%SPEECH_OFF%你告诉这两个人，他们休想碰任何东西，除非付钱给你。贵族咧嘴一笑。%SPEECH_ON%别这么急躁，佣兵。我的仆人正在拿你的报酬。如果你再敢用这种语气说话，我就割了你的舌头，不管你是不是怪物杀手。%SPEECH_OFF%你手按剑柄，心中默默倒计时，以此表明你的耐心。值得所有相关人士庆幸的是，仆人在倒计时结束前赶到了。 | %employer%看着摆好的野兽残骸，像小孩似的拍起手来。%SPEECH_ON%讲述我事迹的故事将会很精彩。我要用这些骨头制作刀柄和握把，然后讲述我如何拿下这些怪物头颅的故事。%SPEECH_OFF%你点点头。听起来真棒。反正历史书又不会记载你的名字。你索要你的报酬。%employer%盯着怪物眼睛都不眨地点了点头，打了个响指。%SPEECH_ON%仆人们！给这个人拿钱！%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "狩猎成功。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.Assets.addMoney(this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected"));
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, function ()
						{
							return this.RenderTemplate("猎杀在%s附近游荡的野兽", this.World.State.getRegion(this.Flags.get("Region")).Name);
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
