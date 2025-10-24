this.drive_away_nomads_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		Reward = 0
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.drive_away_nomads";
		this.m.Name = "驱逐";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		local banditcamp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getNearestSettlement(this.m.Home.getTile());
		this.m.Destination = this.WeakTableRef(banditcamp);
		this.m.Flags.set("DestinationName", banditcamp.getName());
		this.m.Payment.Pool = 600 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"把游牧民逐出" + this.Flags.get("DestinationName") + "%origin%%direction%边的游牧民"
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				this.Contract.m.Destination.clearTroops();
				this.Contract.m.Destination.setLastSpawnTimeToNow();

				if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.NomadDefenders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setLootScaleBasedOnResources(110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				this.Contract.m.Destination.setDiscovered(true);
				this.Contract.m.Destination.resetDefenderSpawnDay();
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					if (this.Contract.getDifficultyMult() >= 0.95 && this.World.Assets.getBusinessReputation() > 700)
					{
						this.Flags.set("IsSandGolems", true);
					}
				}
				else if (r <= 25)
				{
					if (this.Contract.getDifficultyMult() >= 0.95 && this.World.Assets.getBusinessReputation() > 300)
					{
						this.Flags.set("IsTreasure", true);
						this.Contract.m.Destination.clearTroops();
						this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.NomadDefenders, 150 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					}
				}
				else if (r <= 35)
				{
					if (this.World.Assets.getBusinessReputation() > 800)
					{
						this.Flags.set("IsAssassins", true);
					}
				}
				else if (r <= 45)
				{
					if (this.World.getTime().Days >= 3)
					{
						this.Flags.set("IsNecromancer", true);
						this.Contract.m.Destination.clearTroops();
						local zombies = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies);
						this.World.FactionManager.getFaction(this.Contract.m.Destination.getFaction()).removeSettlement(this.Contract.m.Destination);
						this.Contract.m.Destination.setFaction(zombies.getID());
						zombies.addSettlement(this.Contract.m.Destination.get(), false);
						this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.NecromancerSouthern, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					}
				}
				else if (r <= 50)
				{
					this.Flags.set("IsFriendlyNomads", true);
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

					if (this.Flags.get("IsNecromancer"))
					{
						this.Contract.m.Destination.m.IsShowingDefenders = false;
					}
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsTreasure"))
					{
						this.Flags.set("IsTreasure", false);
						this.Contract.setScreen("Treasure2");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setState("Return");
					}
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (this.Flags.get("IsSandGolems"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("SandGolems");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.Music = this.Const.Music.OrientalBanditTracks;
						properties.EnemyBanners.push(this.Contract.m.Destination.getBanner());
						local e = this.Math.max(1, 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult() / this.Const.World.Spawn.Troops.SandGolem.Cost);

						for( local i = 0; i < e; i = ++i )
						{
							properties.Entities.push({
								ID = this.Const.EntityType.SandGolem,
								Variant = 0,
								Row = -1,
								Script = "scripts/entity/tactical/enemies/sand_golem",
								Faction = this.Const.Faction.Enemy
							});
						}

						this.World.Contracts.startScriptedCombat(properties, true, true, true);
					}
				}
				else if (this.Flags.get("IsTreasure") && !this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Contract.setScreen("Treasure1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsNecromancer") && !this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Contract.setScreen("Necromancer");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsAssassins"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("Assassins");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.Music = this.Const.Music.OrientalBanditTracks;
						properties.EnemyBanners.push(this.Contract.m.Destination.getBanner());
						local e = this.Math.max(1, 30 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult() / this.Const.World.Spawn.Troops.Assassin.Cost);

						for( local i = 0; i < e; i = ++i )
						{
							properties.Entities.push({
								ID = this.Const.EntityType.Assassin,
								Variant = 0,
								Row = 2,
								Script = "scripts/entity/tactical/humans/assassin",
								Faction = this.Contract.m.Destination.getFaction()
							});
						}

						this.World.Contracts.startScriptedCombat(properties, true, true, true);
					}
				}
				else
				{
					this.World.Contracts.showCombatDialog();
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
		this.importScreens(this.Const.Contracts.NegotiationDefault);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "谈判",
			Text = "[img]gfx/ui/events/event_163.png[/img]{虽然没有号角齐鸣，没有彩带飞舞，也没有欢呼喝彩，但当你踏入%employer%的房间时，仍能感受到扑面而来的奢华气息。房间里装点着金银器皿，技艺精湛的工匠打造的繁复珠宝，还有一群姿容绝世的侍女——置身此情此景，任谁都会不由自主地愿意完成任何吩咐，只为有机会参与这看似日常的盛宴。%employer%斜倚在一堆软垫上。%SPEECH_ON%啊，逐币者。我正等着你呢。别再靠近了，你会吓到我的宝贝们。有个简单的差事给你。游牧民一直在抢劫我的商队，导致我金库日渐空虚。我相信你多少能理解被夺走东西的滋味，对吧？呵，看你那副呆相。如此茫然。不过嘛，倒是挺专注本行的。我要那些游牧民死，愿意付%reward%克朗办成这事。这番话能让你那脑袋里装的东西听明白吗？%SPEECH_OFF% | %employer%半坐半靠在丝绸软垫堆砌的王座上，身下还压着几个妖娆的侍女。他抬手制止。%SPEECH_ON%逐币者，要是你再往前踏一步，你的身影会更清晰，身份却会更低贱，明白吗？聪明人懂得摆正自己的位置。有个简单的任务要交给你的剑。 %townname%外的游牧民专干偷抢掳掠的勾当。我会给你丰厚的奖赏，需要你彻底消灭这些让我日子不痛快的家伙。%SPEECH_OFF% | 你看见%employer%正在喂食一只笼中鸟。那鸟儿身披斑斓羽色，有些色彩你甚至从未见过。%employer%似乎察觉到你的存在——或者说是闻到了你的气味——他转过身，脸上带着一丝嫌恶。%SPEECH_ON%你吓到我的鸟了，逐币者，看在她的份上我就长话短说。有游牧民在我领地周边游荡，我要他们彻底消失。像你这种……呃……层次的人，应该很愿意接这种简单轻松的话吧？%SPEECH_OFF% | 你走进%employer%的房间。他正在享用水果，下半身埋在一群侍女的肉体之中，那些照料他的女人们正喧闹地忙碌着。你无所事事地站了一会，刚想开口，这人就抬手制止。他指向一个仆人打了个响指。仆人踏着丝底凉鞋滑过大理石地面，将一张纸笺递到你面前，上面写着：%SPEECH_ON%致有意向的逐币者：游牧民持续滋扰%townname%周边治安。速往清剿，酬金%reward%克朗。无意接受者请立即离开。%SPEECH_OFF%仆人看着你，等待你的答复。 | 你刚走进房间，%employer%就叹了口气。%SPEECH_ON%啊，逐币者，我差点忘记之前我叫了你们这种人来败坏雅兴。%SPEECH_OFF%你盯着这位维齐尔，他正费力地从堆积如山的软垫和负责拍松每个垫子的侍女群中挣脱出来。%SPEECH_ON%好吧，看来我得花点时间把这事了结。游牧民一直在抢劫我的商队，害得我的市场缺了不少我想要的货品。我出%reward%克朗，去找到并消灭这些沙海里的蛀虫。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{我们再谈一谈报酬。 | 我能解决掉这个麻烦。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{不感兴趣。 | 我们有更重要的事情要做。 | 祝你好运，但我们不会掺和此事。}",
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
			ID = "Treasure1",
			Title = "在攻击前……",
			Text = "[img]gfx/ui/events/event_54.png[/img]{这群游牧民异常密集地聚集在原地，人数也出奇地多——你很快就明白原因了：这些沙民正围在一个地洞周围。他们在洞口架设了滑轮组，正疯狂地拖拽着从沙漠深处找到的某样东西。从监工那人脸上挂着的笑容来看，下面无疑埋藏着宝藏。\n\n你可以现在进攻，这样会面临更多的敌人，或者等到他们完工，带着挖出的东西离开后再动手。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "现在就发起进攻！",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				},
				{
					Text = "我们等他们完事，营地防守松懈了再动手。",
					function getResult()
					{
						return "Treasure1A";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Treasure1A",
			Title = "在攻击前……",
			Text = "[img]gfx/ui/events/event_54.png[/img]{你等待着游牧民将宝物取出。果然，那是一个箱子。当他们撬开箱盖时，脸上掠过一丝满意的神色。而同样不出所料的是，游牧民们分开了——一队最精锐的战士带着财宝离去，想必是要去某个地方销赃。此刻，游牧民的营地比之前更薄弱，也更容易受到攻击…….}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "准备进攻！",
					function getResult()
					{
						this.Flags.set("IsTreasure", false);
						this.Contract.m.Destination.clearTroops();
						this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.NomadDefenders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Treasure2",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_168.png[/img]{游牧民全数歼灭后，你自然要去看看他们到底从地里挖出了什么玩意儿。你站在他们架设的滑轮组前，俯身望向坑洞深处。只见一口箱子静静躺在那里，绳索早已捆扎妥当。你倒是该谢谢那些死去的游牧民替你做完了所有苦工，转身轻松地将箱子从地底拉了上来。打开箱盖，映入眼帘的是……}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "宝藏！",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				local e = 2;

				for( local i = 0; i < e; i = ++i )
				{
					local item;
					local r = this.Math.rand(1, 4);

					switch(r)
					{
					case 1:
						item = this.new("scripts/items/loot/ancient_gold_coins_item");
						break;

					case 2:
						item = this.new("scripts/items/loot/silverware_item");
						break;

					case 3:
						item = this.new("scripts/items/loot/jade_broche_item");
						break;

					case 4:
						item = this.new("scripts/items/loot/white_pearls_item");
						break;
					}

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
			ID = "SandGolems",
			Title = "在攻击前……",
			Text = "[img]gfx/ui/events/event_160.png[/img]{正当你准备发动袭击时，一个男人突然从沙地中钻了出来。他吓得猛地后退，尖叫着滚下沙丘朝游牧民营地逃去。你亮出武器紧追不舍，决心将其灭口。在颠簸的视野边缘，你看见游牧民互相推搡着冲向武器，帐篷在混乱中接连倒塌。当你再次看向那个哨兵时，他竟在沙砾的包裹中骤然消失，而连接着沙丘的巨臂破土而出，耸立在你面前，尘沙与泥土正从其不断成型的躯体上簌簌滑落。\n\n你几乎无法理解眼前的景象，但所有游牧民都在声嘶力竭地呼喊着同一句话：\"伊夫利特！伊夫利特！伊夫利特！\" 而这个无面的、仿佛无边无际的\"伊夫利特\"，在即将到来的战斗中不会站在任何一方。 | 你从沙丘上向游牧民发起冲锋。受惊的他们厉声呼喝着冲向武器。当你逼近营地时，一阵沙浪轰击在营地角落，几名游牧民被掀飞出去。紧接着一块巨岩从尘雾中呼啸而来，将一名游牧民砸得粉碎。一头巨大的土石巨怪咆哮着踏地而来。\"伊夫利特！伊夫利特！\"游牧民们尖叫着，你意识到这个\"伊夫利特\"在这场战斗中不会站在任何人一边。}",
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
			ID = "Assassins",
			Title = "在攻击前……",
			Text = "[img]gfx/ui/events/event_165.png[/img]{你率队冲入营地，正好撞见一名黑衣男子从帐篷中走出。他正在与游牧民族首领握手——这恐怕不是什么好兆头。两人握手到一半骤然停住，盯着你们这支突袭队伍，这可能也不是件好事。游牧首领厉声高呼，命令他手下的刺客们行动起来。那名黑衣杀手点头应和，随之利刃出鞘，一队同伙刺客接连从帐中鱼贯而出，与游牧民一同投入战斗！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "冲锋！",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Necromancer",
			Title = "在攻击前……",
			Text = "[img]gfx/ui/events/event_161.png[/img]{到处是支离破碎的帐篷，地上散落着解体的篮筐。衣物在沙地上翻滚。在这片狼藉中央，坐着一位身披黑色斗篷的男子，他那张狰狞的面孔从兜帽的阴影中窥视而来。%SPEECH_ON%你们来迟了，却又来得凑巧。%SPEECH_OFF%他说着，站起身来。篷布窸窣作响，篮筐倾倒，衣物猛地掀到一旁，整片土地霎时间生机躁动。突然，沙粒滑入幽深的沟壑，满怀敌意的游牧民从地底涌出，他们攀爬而上，有的纵身跃起，仿佛要在新鲜空气中重获生机，有的则身躯挺直如同旗杆。他们的动作怪异而僵直，令人不安。在这群蹒跚前行的队伍后方，那黑衣男子露出了狞笑。他绝非普通的恶徒，而是一名死灵法师！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{一名仆人拦住了你与%employer%会面的去路。他递给你一卷羊皮纸和一个钱袋。尽管已经将文书交到你手中，仆人却将双手背在身后，仰头望着天花板背诵道。%SPEECH_ON%依照先前约定，逐币者获赏%reward_completion%克朗。既已领赏，请即刻离开此地。%SPEECH_OFF%仆人低头看向你，点了点头。%SPEECH_ON%请离开。%SPEECH_OFF%他说道。 | 你试图进入%employer%的房间，但一名身形魁梧、面带疤痕的守卫将长矛的利刃横在门前。%SPEECH_ON%谢绝访客。%SPEECH_OFF%你声称有事要面见维齐尔。守卫摇了摇头。此时一名仆人悄然来到你身后，把一个钱袋塞进你怀里，随后迅速离去。守卫将长矛收回身侧。%SPEECH_ON%你与维齐尔的那点琐事，在你上次离开时就已经了结了。别再去坏他的兴致。赶紧走。现在就走。趁你还没坏掉我的兴致之前。%SPEECH_OFF% | 就在你走向%employer%的房间时，大厅对面传来一阵掌声。你转头看去，发现一位女子不知何时已逼近眼前。四只鸟停在她的肩头，随着她每一步轻轻晃动。%SPEECH_ON%逐币者。%SPEECH_OFF%她掏出一个钱袋递过来。%SPEECH_ON%%employer%不想再闻到你的气味，走到这里就够了。想羞辱我们就数钱，想讨好我们就拿钱走人。%SPEECH_OFF%她说完利落转身离去，那身奇特的裙摆左右飘动。肩头一只鸟扭过头对你发出刺耳的鸣叫。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "行，这趟不算白忙活。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "摧毁了一处游牧民营地。");
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"totalenemy",
			this.m.Destination != null && !this.m.Destination.isNull() ? this.beautifyNumber(this.m.Destination.getTroops().len()) : 0
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Destination.getTile())]
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0 && this.World.getTime().Days > 3 && this.Math.rand(1, 100) <= 50)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/ambushed_trade_routes_situation"));
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

				if (this.m.Flags.get("IsNecromancer"))
				{
					local nomads = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits);
					this.World.FactionManager.getFaction(this.m.Destination.getFaction()).removeSettlement(this.m.Destination);
					this.m.Destination.setFaction(nomads.getID());
					nomads.addSettlement(this.m.Destination.get(), false);
				}
			}

			this.m.Home.getSprite("selection").Visible = false;
		}

		if (this.m.Home != null && !this.m.Home.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Home.getSituationByInstance(this.m.SituationID);

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
