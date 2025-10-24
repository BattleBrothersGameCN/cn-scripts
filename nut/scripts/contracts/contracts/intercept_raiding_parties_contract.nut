this.intercept_raiding_parties_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Objectives = [],
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.intercept_raiding_parties";
		this.m.Name = "拦截掠夺队";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
		this.m.MakeAllSpawnsResetOrdersOnContractEnd = false;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		local f = this.World.FactionManager.getFaction(this.getFaction());
		local towns = [];

		foreach( s in f.getSettlements() )
		{
			if (s.isIsolated() || s.isCoastal() || s.isMilitary() || !s.isDiscovered())
			{
				continue;
			}

			if (s.getActiveAttachedLocations().len() < 2)
			{
				continue;
			}

			if (this.World.getTileSquare(s.getTile().SquareCoords.X, s.getTile().SquareCoords.Y - 12).Type == this.Const.World.TerrainType.Ocean)
			{
				continue;
			}

			towns.push(s);
		}

		towns.sort(function ( _a, _b )
		{
			if (_a.getTile().SquareCoords.Y < _b.getTile().SquareCoords.Y)
			{
				return -1;
			}
			else if (_a.getTile().SquareCoords.Y > _b.getTile().SquareCoords.Y)
			{
				return 1;
			}

			return 0;
		});
		this.m.Destination = this.WeakTableRef(towns[this.Math.rand(0, this.Math.min(1, towns.len() - 1))]);
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

		this.m.Flags.set("LastLocationDestroyed", "");
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"拦截所有%objective%附近的南方掠夺队",
					"不要让他们烧毁任何地点"
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

				if (r <= 10)
				{
					this.Flags.set("IsAssassins", true);
				}
				else if (r <= 50)
				{
					this.Flags.set("IsSlavers", true);
				}

				if (this.Math.rand(1, 100) <= 50)
				{
					this.Flags.set("IsThankfulVillagers", true);
				}

				local cityStates = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState);

				foreach( c in cityStates )
				{
					c.addPlayerRelation(-99.0, "在战争中选择了阵营");
				}

				this.Contract.m.Destination.setLastSpawnTimeToNow();
				local locations = [];

				foreach( a in this.Contract.m.Destination.getActiveAttachedLocations() )
				{
					if (a.isUsable() && a.isActive())
					{
						locations.push(a);
					}
				}

				local cityState = cityStates[this.Math.rand(0, cityStates.len() - 1)];

				for( local i = 0; i < 2; i = ++i )
				{
					local r = this.Math.rand(0, locations.len() - 1);
					this.Contract.m.Objectives.push(locations[r].getID());
				}

				local g = this.Contract.getDifficultyMult() > 1.1 ? 3 : 2;

				for( local i = 0; i < g; i = ++i )
				{
					local tile = this.Contract.getTileToSpawnLocation(this.World.getTileSquare(this.Contract.m.Destination.getTile().SquareCoords.X, this.Contract.m.Destination.getTile().SquareCoords.Y - 12), 0, 10);
					local party;

					if (i == 0 && this.Flags.get("IsAssassins"))
					{
						party = cityState.spawnEntity(tile, "团" + cityState.getNameOnly(), true, this.Const.World.Spawn.Southern, this.Math.rand(70, 90) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
						this.Contract.addUnitsToEntity(party, this.Const.World.Spawn.Assassins, this.Math.rand(30, 40) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						party.getFlags().set("IsAssassins", true);
					}
					else if (i == 0 && this.Flags.get("IsSlavers"))
					{
						party = cityState.spawnEntity(tile, "Slavers", true, this.Const.World.Spawn.Southern, this.Math.rand(60, 80) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
						this.Contract.addUnitsToEntity(party, this.Const.World.Spawn.NorthernSlaves, 50 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						party.getFlags().set("IsSlavers", true);
					}
					else
					{
						party = cityState.spawnEntity(tile, "团" + cityState.getNameOnly(), true, this.Const.World.Spawn.Southern, this.Math.rand(100, 130) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
						party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + cityState.getBannerString());

						if (this.Math.rand(1, 100) <= 33)
						{
							this.Contract.addUnitsToEntity(party, this.Const.World.Spawn.NorthernSlaves, this.Math.rand(10, 30));
						}
					}

					party.setDescription("忠于城邦的应征士兵。");
					party.setAttackableByAI(false);
					party.getLoot().Money = this.Math.rand(50, 200);
					party.getLoot().ArmorParts = this.Math.rand(0, 25);
					party.getLoot().Medicine = this.Math.rand(0, 3);
					party.getLoot().Ammo = this.Math.rand(0, 30);
					local r = this.Math.rand(1, 4);

					if (r <= 2)
					{
						party.addToInventory("supplies/rice_item");
					}
					else if (r == 3)
					{
						party.addToInventory("supplies/dates_item");
					}
					else if (r == 4)
					{
						party.addToInventory("supplies/dried_lamb_item");
					}

					local c = party.getController();
					c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
					c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
					local wait = this.new("scripts/ai/world/orders/wait_order");
					wait.setTime(80.0 + i * 12.0);
					c.addOrder(wait);

					for( local j = 0; j < 2; j = ++j )
					{
						local raid = this.new("scripts/ai/world/orders/raid_order");
						raid.setTargetTile(j == 0 ? locations[0].getTile() : locations[1].getTile());
						raid.setTime(60.0);
						c.addOrder(raid);
					}

					this.Contract.m.UnitsSpawned.push(party.getID());
				}

				this.Flags.set("ObjectivesAlive", 2);
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
				}

				foreach( i, id in this.Contract.m.UnitsSpawned )
				{
					local p = this.World.getEntityByID(id);

					if (p != null && p.isAlive())
					{
						p.getSprite("selection").Visible = true;
						p.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
					}
				}
			}

			function update()
			{
				local alive = 0;

				foreach( i, id in this.Contract.m.Objectives )
				{
					local p = this.World.getEntityByID(id);

					if (p != null && p.isAlive())
					{
						if (p.isActive())
						{
							alive = ++alive;
						}
						else
						{
							this.Flags.set("LastLocationDestroyed", p.getRealName());
						}
					}
				}

				if (alive < this.Flags.get("ObjectivesAlive"))
				{
					this.Flags.set("ObjectivesAlive", alive);
					this.Contract.setScreen("LocationDestroyed");
					this.World.Contracts.showActiveContract();
				}
				else if (alive == 0 || this.Contract.m.UnitsSpawned.len() == 0)
				{
					if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() < 4.0 && alive > 0)
					{
						if (this.Flags.get("IsThankfulVillagers") && this.Contract.isPlayerNear(this.Contract.m.Destination, 500))
						{
							this.Contract.setScreen("ThankfulVillagers");
						}
						else
						{
							this.Contract.setScreen("PartiesDefeated");
						}
					}
					else
					{
						this.Contract.setScreen("Lost");
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					foreach( i, id in this.Contract.m.UnitsSpawned )
					{
						local p = this.World.getEntityByID(id);

						if (p == null || !p.isAlive())
						{
							this.Contract.m.UnitsSpawned.remove(i);
							break;
						}
					}
				}
			}

			function onDestinationAttacked( _dest, _isPlayerInitiated )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerInitiated;

				if (!this.Flags.get("IsEngagementDialogShown"))
				{
					this.Flags.set("IsEngagementDialogShown", true);

					if (_dest.getFlags().has("IsAssassins"))
					{
						this.Contract.setScreen("Assassins");
					}
					else if (_dest.getFlags().has("IsSlavers"))
					{
						this.Contract.setScreen("Slavers");
					}
					else
					{
						this.Contract.setScreen("InterceptParty");
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog(_isPlayerInitiated, true, true);
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

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					local alive = 0;

					foreach( id in this.Contract.m.Objectives )
					{
						local p = this.World.getEntityByID(id);

						if (p != null && p.isAlive() && p.isActive())
						{
							alive = ++alive;
						}
					}

					if (alive == 0)
					{
						this.Contract.setScreen("Lost");
					}
					else if (alive == 1)
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer%的房间昏暗而安静。若不是几支摇曳的烛光和鸟儿的啁啾，这里简直漆黑无声。贵族站在阴影中说道：%SPEECH_ON%那些南方杂碎不断派遣掠夺队北上。你也知道，让几个黝黑的杂种在这里烧杀抢掠，实在是件麻烦事。他们想逼我把主力部队调回后方，但我绝不会让步。这就是你出现在这里的原因，佣兵。我要你找到这些捣乱的破坏分子，把他们全部干掉。如果你接下这个任务，%reward%克朗就是你的了。%SPEECH_OFF% | 你看到%employer%正在和他的军官们商议。他面前摆着两堆筹码，一堆明显比另一堆高得多。他从较高的那堆取出一些放到较矮的那堆上。%SPEECH_ON%如果我分配这么多呢？%SPEECH_OFF%军官们纷纷摇头。%SPEECH_ON%这正是南方人想要的结果。如果从前线抽调兵力，他们肯定会察觉并趁势进攻。%SPEECH_OFF%这时所有人突然抬头看向你。%employer%咧嘴一笑。%SPEECH_ON%啊哈，看来我们的救星非雇佣兵莫属！队长，我需要战士留守%townname%，防御南方破坏分子和掠夺者的袭击。只要你圆满完成任务，%reward%克朗就是你的！%SPEECH_OFF%军官们对让你这样的佣兵承担此任务显得犹豫，但你能感觉到形势确实严峻。 | 你被引到%employer%的书房，他正在翻阅卷轴。他举起其中一份。%SPEECH_ON%在这种时期，你觉得我在研读什么？%SPEECH_OFF%你猜测是军事方面的内容。他摇了摇头。%SPEECH_ON%是务农学。你看，我现在处于战争状态。但战争不仅靠士兵，还要靠补给线、后勤和粮食。所有这些都依赖后方提供。南方狗和我们一样明白这个道理，他们派了掠夺者和渗透者来摧毁我们的后方。为了分散我的注意力，分散我士兵的注意力。我需要你揪出这些杂种，保护我们的家园、店铺和农场。只要圆满完成，我愿意支付%reward%克朗。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{这工作可能正适合我们。 | 击退南方来的入侵者？ 战团在此响应号召！ | 行吧，我们再谈酬金的问题。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{这事不划算。 | 我们还有别的地方要去。 | 这会占用我们太多的时间。}",
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
			ID = "LocationDestroyed",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_30.png[/img]{远方浓烟升腾。尖叫声回响在云层之下，火焰中跃动着仓惶逃窜的身影。那正是%objective%的%location%，此地无疑已被摧毁。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "趁着为时未晚，我们必须阻止他们。",
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
			ID = "InterceptParty",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_156.png[/img]{这些南方人仿佛正处在地域过渡中，衣着混杂着南方服饰与北方装束，还携带着满载掠夺财宝的箱子。有个男人戏谑地套着北方婚纱转圈。若不是他们满身血污与灰烬，这伙人看起来倒像支欢乐的队伍。准备战斗！ | 你发现了这支北上的南方掠夺队。从他们满身的血迹判断，这帮人肯定已经在偏远地区的定居点制造了一路混乱。准备战斗！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "准备接敌。",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "PartiesDefeated",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_87.png[/img]{你找到最后一个还在喘气的南方人，揪着头发将他提起示众。在农民们的注视下，你从喉咙割到后颈，直到身躯坠落，头颅高悬手中。人群欢呼起来。%SPEECH_ON%我们的救星！%SPEECH_OFF%毫无疑问，%employer%听闻你的功绩定会欣喜不已。 | 南方入侵者已被全数歼灭，伤重未死者遭到当地居民的残酷清算。剥皮阉割等极端手段层出不穷，场面血腥得令人不忍直视。但你对这些外邦人毫无同情，此刻更关心的是%employer%即将支付的酬金。 | 随着最后一批南方人被送进坟墓，你知道%employer%会很乐意支付你应得的报酬。离开时，你看见一些当地居民正在肢解袭击者的尸体——在这片土地和世界其他地方，这都是传统做法。 | 最后一名掠夺者发出凄厉的惨叫，最终毙命于刀下。他的同伙被当地民众拖来拖去，尸体要么被剁成碎块，要么被付之一炬。你观望片刻，终究继续赶路，心里清楚%employer%还在等着你。 | 死者反倒是掠夺者中最幸运的，因为重伤者得不到丝毫怜悯。当地居民和农户们涌入战场认领俘虏，有人甚至为此出价交易。被选中的掠夺者随后遭到玷污、肢解和酷刑。你没看到有人被直接处死，实际上有个医师似乎专程在场延长他们的痛苦。这景象颇为壮观，但更让人期待的是%employer%将丰厚酬金倒入你的钱箱。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "让伙计们准备好出发。",
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
			ID = "Lost",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_94.png[/img]{敌人已经离去，但他们的恶行已然得逞。烟尘萦绕在焚毁的断壁残垣间，此处的居民除了被掳掠到南方当作负债者贩卖，就只剩下横陈街头的死尸。\n\n你没必要返回雇主处复命了，他们不会为你的失败支付酬金的。不如去别处另寻生计。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们失败了。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "抵御南方劫掠者失败，未能保卫" + this.Contract.m.Destination.getName() + " ");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Assassins",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_165.png[/img]{你发现一个农夫死在路上，背上插着一柄弯刀。没人会扔下这么精致的匕首不要，果然如你所料——凶手仍在现场：一群南方刺客。他们如鬼影般游移，锋利的钢刃随身形转动寒光闪烁。准备战斗！ | 一个女人匆忙向你奔来，破碎的衣裙飘荡，双臂挥舞，双眼圆睁——眼白浸在血海中，宛如猩红海滩上的贝壳。未及开口，她闷哼一声瞬间倒地。一柄匕首钉在她后脑，更远处，一个黑衣男子带着一队刺客赫然伫立！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Slavers",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_53.png[/img]{这支南方掠夺队看起来像是聚集了世界各地的人。仔细察看才发现，原来他们是奴隶贩子！这群主奴混杂的队伍向%companyname%逼近，训练有素者和乌合之众杂乱无章地组成阵型。你能在人群中看到北方人的面孔，但可悲的是他们已被摧垮意志，宁愿拿起武器对抗战团，也不为自由而战。 | 你遭遇了南方人，但他们根本不是什么掠夺者——而是奴隶贩子！他们押运着满载妇女儿童的货车。当你们被发现时，奴隶贩子们急忙开始砍杀任何可能构成威胁的新奴役男子，其余人则向%companyname%发起冲锋。杀戮即将开始，你毫不留情地向这群人压去。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "ThankfulVillagers",
			Title = "%objective%里",
			Text = "[img]gfx/ui/events/event_79.png[/img]{你们解决了最后一批南方掠夺者。 正当你命令战团收集有价值之物时，几个村民带着自己的物资走了出来。%SPEECH_ON%我们还以为世界末日到了，结果你们来了，我们的骑士。%SPEECH_OFF%虽然你并非骑士，但你不介意接受骑士般的赞誉——以及骑士般的报酬：村民们赠予了你们礼物！ | 袭击者被清除后，你发现自己渐渐被村民们围住。他们面容憔悴、惊魂未定，却提着满篮的物资。这些是作为救命之恩的谢礼献给你们的。他们似乎把你们误认作%employer%的士兵，但你压根没想过要透露自己只是雇佣兵。你收下赠礼，甚至还轻触帽檐说这是分内之事——而事实也的确如此。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "被感谢的感觉很好。",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				local p = this.Contract.m.Destination.getProduce();

				for( local i = 0; i < 2; i = ++i )
				{
					local item = this.new("scripts/items/" + p[this.Math.rand(0, p.len() - 1)]);
					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "你获得了" + item.getName()
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer%招手让你进去，不过欢迎方式并不如你期望的那般热情。他的语气带着几分父亲般的失望。%SPEECH_ON%你们解决了几伙南方流寇。不算出色，但也不算太糟。我会按你们阻止的每批匪徒付钱，只是我原本希望你们能做得更好。%SPEECH_OFF%你几乎想要道歉，但你知道任何示弱的表现都可能让对方趁机克扣报酬，于是把话咽了回去。他按约定支付了%reward%克朗。 | 你进去时%employer%身边跟着几名守卫，不过人群里少了些熟悉的面孔。他语气沉痛地说道。%SPEECH_ON%你已尽力了，佣兵。要全歼那些掠夺者本就不太可能。我现在明白了。当然，我这是在给你找台阶下。说不定我雇错了人，但今日我不作此决断。要重建的实在太多。按击垮的掠夺者队伍数量支付你%reward%克朗，依约履行。%SPEECH_OFF% | 你走进%employer%的房间，发现%reward%克朗的报酬已经核算好放在桌上。他漫不经心地转了下手指向那堆钱币。%SPEECH_ON%掠夺者来了，你们解决了一些，剩下的烧杀抢掠无恶不作。所以。拿上你的%reward%克朗吧，佣兵。这与你的工作质量相符，要是觉得钱堆矮了一截也别太惊讶。%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "受之无愧。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractPoor);
						this.World.Assets.addMoney(this.Math.round(this.Contract.m.Payment.getOnCompletion() / 2));
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractPoor, "抵御南方劫掠者，成功保卫" + this.Contract.m.Destination.getName() + " ");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isHolyWar())
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{你没在作战室找到%employer%，而是在他的侧室——几位女士正在屋里走动，有的在清理角落蛛网，有的往书架归档卷轴，还有的在擦拭家具。她们自然都赤身裸体。这人张开双臂。%SPEECH_ON%我觉得该庆祝一下，因为%townname%得救了，被你这样的人救了，佣兵！%SPEECH_OFF%他醉醺醺的，在屋里摇摇晃晃时女士们都温柔地让开。%SPEECH_ON%现在...现在——嗝——现在我向你保证，那%reward%克朗我绝对没——嗝——没克扣。全按说好的在那儿。平民们很开心，我也很开心。非常开心。%SPEECH_OFF%他搂了其中一个女人，那女人的反应跟砖头一样沉闷。你抓起钱袋离开时，几个姑娘也溜出门外，%employer%则陷入喃喃自语的醉态。 | 你在作战室外找到了%employer%，他正在书房里——书架恐怕比书还多。但他看起来仍自我感觉良好。%SPEECH_ON%你在外面的表现很出色，佣兵。绝对出色。当然有伤亡，但总体而言一切运转正常，那些南方杂碎也被赶跑了。多亏你，我们的前线不必为照顾后方而松懈。给，答应你的%reward%克朗。%SPEECH_OFF%这人移开身子时，你看见书架上摆着个刚处理完还泛着油光的头骨。他带着孩童般的得意指向它。%SPEECH_ON%那是他们的头骨之一。我打算拿它当酒壶，或者尿壶。还没决定好。%SPEECH_OFF% | %employer%正坐在书桌前，桌上叠着三个头骨组成的金字塔。他一只手搭在上面，像在抚摸狗头。你注意到头骨上还挂着碎肉甚至头发，漂白工序想必很仓促。这人愉快地说道：%SPEECH_ON%多亏了你，我的士兵才能坚守前线，佣兵。解决这些掠夺者不仅救了许多人的命，或许还阻止了第一块多米诺骨牌的倒下。若没有你，前线的父亲、兄弟和儿子们可能早已退守照顾家人，整场战争就全完了。%SPEECH_OFF%他用空着的手推过来一个钱袋。%SPEECH_ON%你的%reward%克朗。要我说，这袋钱币的分量衬得上你的成果。%SPEECH_OFF%他阴沉一笑，对着头骨歪了歪头。%SPEECH_ON%我想它们也会同意——虽然这件事上我得替它们发言。%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "抵御南方劫掠者，成功保卫" + this.Contract.m.Destination.getName() + " ");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isHolyWar())
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
			"objective",
			this.m.Destination.getName()
		]);
		_vars.push([
			"location",
			this.m.Flags.get("LastLocationDestroyed")
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
			}

			foreach( id in this.m.UnitsSpawned )
			{
				local p = this.World.getEntityByID(id);

				if (p != null && p.isAlive())
				{
					p.getSprite("selection").Visible = false;
					p.setOnCombatWithPlayerCallback(null);
				}
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isHolyWar())
		{
			return false;
		}

		local f = this.World.FactionManager.getFaction(this.getFaction());

		foreach( s in f.getSettlements() )
		{
			if (s.isIsolated() || s.isCoastal() || s.isMilitary() || !s.isDiscovered())
			{
				continue;
			}

			if (s.getActiveAttachedLocations().len() < 2)
			{
				continue;
			}

			if (this.World.getTileSquare(s.getTile().SquareCoords.X, s.getTile().SquareCoords.Y - 12).Type == this.Const.World.TerrainType.Ocean)
			{
				continue;
			}

			return true;
		}

		return false;
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

		_out.writeU8(this.m.Objectives.len());

		for( local i = 0; i < this.m.Objectives.len(); i = ++i )
		{
			_out.writeU32(this.m.Objectives[i]);
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

		local numObjectives = _in.readU8();

		for( local i = 0; i < numObjectives; i = ++i )
		{
			this.m.Objectives.push(_in.readU32());
		}

		this.contract.onDeserialize(_in);
	}

});
