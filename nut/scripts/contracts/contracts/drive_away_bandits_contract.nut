this.drive_away_bandits_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		Reward = 0,
		OriginalReward = 0
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.drive_away_bandits";
		this.m.Name = "驱逐强盗";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function generateName()
	{
		local vars = [
			[
				"randomname",
				this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]
			],
			[
				"randomtown",
				this.Const.World.LocationNames.VillageWestern[this.Math.rand(0, this.Const.World.LocationNames.VillageWestern.len() - 1)]
			]
		];
		return this.buildTextFromTemplate(this.Const.Strings.BanditLeaderNames[this.Math.rand(0, this.Const.Strings.BanditLeaderNames.len() - 1)], vars);
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		local banditcamp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getNearestSettlement(this.m.Home.getTile());
		this.m.Destination = this.WeakTableRef(banditcamp);
		this.m.Flags.set("DestinationName", banditcamp.getName());
		this.m.Flags.set("RobberBaronName", this.generateName());
		this.m.Payment.Pool = 550 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"把强盗逐出" + this.Flags.get("DestinationName") + "%origin%%direction%边的强盗"
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

				if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.BanditDefenders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setLootScaleBasedOnResources(110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);

				if (this.World.Assets.getBusinessReputation() >= 500 && this.Contract.getDifficultyMult() >= 0.95 && this.Math.rand(1, 100) <= 20)
				{
					this.Flags.set("IsRobberBaronPresent", true);

					if (this.World.Assets.getBusinessReputation() > 600 && this.Math.rand(1, 100) <= 50)
					{
						this.Flags.set("IsBountyHunterPresent", true);
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
					if (this.Flags.get("IsRobberBaronDead"))
					{
						this.Contract.setScreen("RobberBaronDead");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Math.rand(1, 100) <= 10)
					{
						this.Contract.setScreen("Survivors1");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Math.rand(1, 100) <= 10 && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
					{
						this.Contract.setScreen("Volunteer1");
						this.World.Contracts.showActiveContract();
					}

					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (this.Flags.get("IsRobberBaronPresent"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("AttackRobberBaron");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.Music = this.Const.Music.BanditTracks;
						properties.Entities.push({
							ID = this.Const.EntityType.BanditLeader,
							Variant = 0,
							Row = 2,
							Script = "scripts/entity/tactical/enemies/bandit_leader",
							Faction = _dest.getFaction(),
							Callback = this.onRobberBaronPlaced.bindenv(this)
						});
						properties.EnemyBanners.push(this.Contract.m.Destination.getBanner());
						this.World.Contracts.startScriptedCombat(properties, true, true, true);
					}
				}
				else
				{
					this.World.Contracts.showCombatDialog();
				}
			}

			function onRobberBaronPlaced( _entity, _tag )
			{
				_entity.getFlags().set("IsRobberBaron", true);
				_entity.setName(this.Flags.get("RobberBaronName"));
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getFlags().get("IsRobberBaron") == true)
				{
					this.Flags.set("IsRobberBaronDead", true);
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
					if (this.Flags.get("IsRobberBaronDead"))
					{
						this.Contract.setScreen("Success2");
					}
					else
					{
						this.Contract.setScreen("Success1");
					}

					this.World.Contracts.showActiveContract();
				}

				if (this.Flags.get("IsRobberBaronDead") && this.Flags.get("IsBountyHunterPresent") && !this.TempFlags.get("IsBountyHunterTriggered") && this.World.Events.getLastBattleTime() + 7.0 < this.Time.getVirtualTimeF() && this.Math.rand(1, 1000) <= 2)
				{
					this.Contract.setScreen("BountyHunters1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsBountyHunterRetreat"))
				{
					this.Contract.setScreen("BountyHunters3");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "BountyHunters")
				{
					this.Flags.set("IsBountyHunterPresent", false);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "BountyHunters")
				{
					this.Flags.set("IsBountyHunterPresent", false);
					this.Flags.set("IsBountyHunterRetreat", true);
					this.Flags.set("IsRobberBaronDead", false);
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer%愤怒地摇了摇头。%SPEECH_ON%强盗在这些地方横行太久了！我派了一个小伙子，%randomname%的儿子，去找他们。你知道发生了什么吗？只有他的脑袋被送回来了。当然，那些白痴强盗派了自己人来送。我们抓住并审问了他……所以现在我们知道他们在哪里了。%SPEECH_OFF%那人靠在椅背上，用两只大拇指互相拍打着，陷入了沉思。%SPEECH_ON%我没有人手，但是我有克朗 —— 要不我给你们一些钱，你把他们弄死？%SPEECH_OFF% | %employer%给自己倒了一杯酒，盯着杯子，又给自己倒了一些。他似乎一口气就把它喝干了，然后才吐出他的消息。%SPEECH_ON%强盗杀了%randomname%和他全家！你敢信吗？我知道你不认识他们，但是他们一家子在这地方很受欢迎。我相信你已经能够猜到要怎么做，我希望把这些强盗解决掉。我花了一半的人去找他们的营地，现在我准备花一半……一些我的克朗，让你为我去杀了他们。你感兴趣吗？%SPEECH_OFF% | %employer%望着窗外，一边思索着，一边用手指在杯沿上舞动。%SPEECH_ON%强盗们一直在偷走贵重的牲畜。他们在夜间来袭，剪断铃铛，静悄悄地离开。我知道牲畜对你来说可能不是很重要，但是一头小牛、一头母牛或一头公牛？对这里的一些人来说就是一笔财富。\n\n于是前几天我派了一个小伙子跟着动物的足迹出了镇子，现在他告诉了我那些强盗的确切位置。如你所料，我没有多余的人手来对付这些流浪汉，但对于克朗……我不缺钱。如果我把钱币放到你手掌上，你会愿意将剑插入那些强盗的胸膛吗？%SPEECH_OFF% | %employer%叹了口气，仿佛他已经厌倦了所有这些麻烦，仿佛他即将开始一场他已经有很多次的对话。%SPEECH_ON%%randomname%，在这里地位相当重要的人物，声称强盗袭击了他的女儿。现在他担心他们下一步会做什么。幸运的是，这个男人拥有相当的财富，可以轻松地追踪这些强盗。如果我给你一笔可观的报酬，你打算以多大的诚意用你的剑戳死几个强盗呢？%SPEECH_OFF% | %employer%在一张够两个人舒服坐着的椅子上坐了下来。他把杯子拿来拿去。%SPEECH_ON%强盗们已经骚扰我们好几个星期了，昨天他们竟然试图放火烧一家酒馆。你能相信吗？谁会放火烧这种东西？幸运的是我们及时扑灭了火，但这里的情况越来越糟了。如果他们威胁到了我们珍贵的饮料，他们下一步会做什么？幸运的是，我们找到了这些流浪汉藏身的地方。所以……是的，我看到了你的表情。这是个简单的任务，佣兵：我们希望你去杀掉那里的每一个强盗。你愿意和我们一起合作吗？%SPEECH_OFF% | 当你走进房间时，%employer%一口喝完了一杯眼镜蛇酒，把杯子掷出窗外。你可以听到它在很远很远的地方哗哗作响。他转向你。%SPEECH_ON%当我走在路上时，强盗们挤上了我的马车，抢走了我所有的货物！他们留了我条小命，这还好，但是他们的所作所为让我夜不能寐。我看到他们嘲弄的脸……听到他们的笑声……我相信这是一种信息，要找我麻烦，因为我拒绝支付他们的“过路费”。好吧，现在我准备支付“过路费” —— 给你，佣兵。如果你去屠杀这些流浪汉，我会付一笔可观的过路费。你怎么说？%SPEECH_OFF% | 当你准备坐下时，%employer%向你扔了一卷卷轴。它在你接到的时候展开了。你开始阅读，但%employer%仍然开始阐述这个新闻。%SPEECH_ON%来自%randomtown%的贸易商已经同意不再光顾%townname%，直到我们的强盗小问题解决为止。它的历史相当简单，我相信你已经了解过强盗的手段，但这些该死的流浪汉一直在路上骚扰、抢劫商队、杀害商人。\n\n我知道他们的准确位置，我只需要一个有勇气且需要荣耀 —— 或者金子！ —— 的人去杀了他们。那么，佣兵，你怎么说？报个价，我们可以商量。%SPEECH_OFF% | 当你和%employer%打招呼时，他在发抖。他气得吐白沫 —— 亦或者他只是真的喝醉了。%SPEECH_ON%这个美丽城镇的市民正在挨饿。为什么？因为强盗们每天晚上潜入粮仓。如果我们抓住了他们，他们就会烧掉建筑物！现在我们不能坐以待毙来保护自己……现在……我想通过杀死他们来保卫我们自己。%SPEECH_OFF%那人摇摇晃晃地走了一会儿，好像要倒在桌子上似的。他稳住身子后继续说道。%SPEECH_ON%显然，我要你去杀了这些流浪汉。你所要做的就是感兴趣，然后……—— 嗝 ——……说出你的价格。%SPEECH_OFF% | %employer%严肃地看着地面。他展开一幅画卷，向你展示了一张脸。%SPEECH_ON%这是%randomname%，一个我们前几天抓到的在逃强盗。他曾经带领一群流浪汉日夜出没，袭击我们的城镇。问题是，他不是真正的蛇头，而是九头蛇的头之一。光杀掉一个只会有另一个取而代之。所以答案如何呢？当然是全部杀掉。这正是我想要你做的事，佣兵。你有兴趣吗？%SPEECH_OFF% | 当你找地方坐下时，%employer%转向你。%SPEECH_ON%你有多久没让你的剑沾上邪恶残忍之人的血了？%SPEECH_OFF%他放下讽刺，你知道你现在应该站着。%SPEECH_ON%我们在%townname%这里和一些当地的强盗发生了一点口角。也就是说，他们的老鼠洞离这里不远。显然，我认为解决这个问题的办法是雇佣一些装备精良的人，比如你那帮好家伙。所以，你对这个感兴趣吗，佣兵，还是我需要找更强壮的人来完成这个任务？%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{多大的生意？ | %townname%准备拿多少钱买个安生？ | 谈谈价钱吧。}",
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
			ID = "AttackRobberBaron",
			Title = "在攻击前……",
			Text = "[img]gfx/ui/events/event_54.png[/img]{在侦察强盗营地时，你注意到了一个让当地人恨得牙痒痒的身影：%robberbaron%，他是肆虐这片地区的著名强盗贵族。无论他去往何处，总有一群面相凶悍的随从紧跟其后。。\n\n你敢打赌，他的脑袋绝对能让你额外赚些钱。 | 你没想到能在这里碰到他，但毫无疑问那就是他本人：%robberbaron%现在就在这座强盗营地里。这个声名狼藉的刽子手正在视察他的其中一个贼窝，煞有介事地在匪徒间踱来踱去，指指点点，品头论足。\n\n几个护卫贴身跟随着他。算上他在内，你估计营地里一共有%totalenemy%个人。 | 本来合同只要求你扫清这里的强盗，但现在似乎多了个更诱人的额外目标：恶名昭彰的刽子手和路匪%robberbaron%就在这座营地里。在一名护卫的陪同下，这位强盗贵族正在评估这座犯罪据点的情况。\n\n而你正掂量着%robberbaron%的脑袋能值多少钱…… | %robberbaron%。那就是他，你确信无疑。透过望远镜，你可以清晰地看到这位恶名昭彰的强盗贵族在营地里走动的身影。他本不在计划内，合约也未曾提及，但毫无疑问的是，如果你把他的脑袋带回镇子里，会有人为你多花的这番工夫支付额外的钱。 | 你在侦察匪徒过程中——清点出约有%totalenemy%人在活动——意外瞥见一个完全出乎预料的身影：%robberbaron%，那位恶名昭彰的强盗贵族。此人带着贴身护卫，想必正在视察营地状况。\n\n真是天赐良机！如果能把他的脑袋带给你的雇主，你说不定还能赚笔外快。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "准备进攻！",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "RobberBaronDead",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_22.png[/img]{战斗结束，你走到%robberbaron%的尸体旁，利落的两剑斩下了他的首级——第一剑切开皮肉，第二剑斩断骨骼。你用钩子刺入颈肉边缘，系上绳索挂在了腰间。 | 战事平息后，你迅速在尸堆中翻找出%robberbaron%的遗体。尽管血色正从躯体褪去，他面容仍显狰狞。当你将首级与躯干分离时那模样依旧狰狞，即便把脑袋扔进粗麻袋再也看不见面容，你猜那副尊容想必还是相当狰狞。 | %robberbaron%倒毙在你脚边。你将尸体翻过面来，摆正脖颈以便剑刃瞄准。两记利落劈斩后首级应声而落，你迅速将其塞进麻袋。 | %robberbaron%毙命后，他突然让你想起许多故人。你没沉溺于这既视感太久：剑光几闪便取下首级，随手抛入行囊。 | %robberbaron%顽强抗争过，他的脖颈又负隅顽抗了一番——筋络骨骼都不让你轻易取走首级兑换赏金。 | 你收好%robberbaron%的首级。经过时%randombrother%指着它问。%SPEECH_ON%那是？该不会是%robberbaron%的……？%SPEECH_OFF%你摇摇头。%SPEECH_ON%不，那人已经死了。这玩意儿只是换赏金用的。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们出发！",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BountyHunters1",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_07.png[/img]{正当你们返回交付合约时，几个人拦在了路中央。其中一人指着%robberbaron%的首级。%SPEECH_ON%我们是这带报酬最高的赏金猎人，我看你们正在抢我们的生意。把那脑袋交出来，今晚大家就都能安稳睡个好觉。%SPEECH_OFF%你大笑。%SPEECH_ON%光说可不够。%robberbaron%的脑袋值不少克朗呢，朋友。%SPEECH_OFF%那个自称赏金猎人头目的人也朝你大笑。他提起一个鼓鼓囊囊的袋子。%SPEECH_ON%这里面是%randomname%，这带最值钱的通缉犯之一。而这个...%SPEECH_OFF%他又举起另一个袋子。%SPEECH_ON%是宰了他的那家伙的脑袋。明白了吗？所以把脑袋交出来，我们各走各路。%SPEECH_OFF% | 一个男人走到路中间，挺直身子朝你们摆开架势。%SPEECH_ON%各位先生好。我相信你们手里有%robberbaron%的脑袋。%SPEECH_OFF%你点头。那人笑了。%SPEECH_ON%麻烦你们行个好，把它交给我吧。%SPEECH_OFF%你大笑着摇头。那人收起笑容，抬手打了个响指。一群全副武装的人从附近灌木丛里涌出，伴着金属碰撞的叮当声列队挡在路中间。他们模样狰狞得像是死囚临刑前夜会梦见的恶鬼。头目露出镶着金牙的笑容。%SPEECH_ON%我不会再问第二遍。%SPEECH_OFF% | 正和%randombrother%交谈时，一声大喊吸引了你的注意。抬头望去，只见一群人挡在路中央。他们装备着各式武器盔甲。为首者上前宣布他们是著名的赏金猎人。%SPEECH_ON%我们只要%robberbaron%的脑袋。%SPEECH_OFF%你耸耸肩。%SPEECH_ON%人是我们杀的，赏金自然归我们。现在让开。%SPEECH_OFF%当你向前迈出一步时，赏金猎人们纷纷举起武器。他们的首领朝你逼近一步。%SPEECH_ON%现在做的决定可能会让很多好汉送命。我知道这口气不好咽下，但我建议你仔细想清楚。%SPEECH_OFF% | 一声尖哨吸引了你和队员们的注意。转向路旁，只见一群人从灌木丛中现身。所有人都拔出武器，但这些陌生人并未再靠近。为首者走上前来，胸前斜挎的皮带上串满耳朵——这是他手艺的汇总。%SPEECH_ON%嘿哥们儿。我们是赏金猎人——要是你们还没看出来的话，而且我确信你们手里有我们的一个赏金目标。%SPEECH_OFF%你举起%robberbaron%的脑袋。%SPEECH_ON%是说这个吗？%SPEECH_OFF%头目热情地笑了。%SPEECH_ON%当然。现在请你们把它交出来，这样我和我的朋友们都会很满意。%SPEECH_OFF%那人轻敲剑柄，咧嘴一笑。%SPEECH_ON%相信你能理解，我们只是来挣钱的。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿上这该死的脑袋，离我们远点。",
					function getResult()
					{
						this.Flags.set("IsRobberBaronDead", false);
						this.Flags.set("IsBountyHunterPresent", false);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractPoor);
						return "BountyHunters2";
					}

				},
				{
					Text = "{要是你这么想要，那便用鲜血的代价来换吧。 | 想让你的脑袋和这个作伴？尽管过来试试。}",
					function getResult()
					{
						this.TempFlags.set("IsBountyHunterTriggered", true);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.Music = this.Const.Music.BanditTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "BountyHunters";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.BountyHunters, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BountyHunters2",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_07.png[/img]你觉得今天流的血够多了，于是把脑袋给了他们。",
			Image = "",
			List = [],
			Options = [
				{
					Text = "走吧，还有赏金等着我们呢。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BountyHunters3",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_07.png[/img]赏金猎人对%companyname%来说实力过于强大！你不愿让队员们白白送死，下令仓促撤退。不幸的是，%robberbaron%的首级在混乱中丢失了……",
			Image = "",
			List = [],
			Options = [
				{
					Text = "噢，好吧。还有赏金等着我们呢。",
					function getResult()
					{
						this.Flags.set("IsBountyHunterRetreat", false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivors1",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_22.png[/img]{战斗接近尾声，几名敌人跪地乞求宽恕。%randombrother%望向你等候决断。 | 战斗结束后，你的队员们将残余匪徒团团围住。幸存者们哀声求饶。其中一个更像是个孩子而非成人，但他却是所有人里最安静的。 | 意识到败局已定，最后几名站着的匪徒丢下武器请求宽恕。你不禁设想若立场对调他们会作何选择。 | 战斗已经结束，但仍有待决断：几名匪徒在战斗中幸存。%randombrother%持剑抵着一名俘虏的脖颈，询问你如何处置。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "割断他们的喉咙。",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-1);
						return "Survivors2";
					}

				},
				{
					Text = "拿走他们的装备，把他们赶走。",
					function getResult()
					{
						this.World.Assets.addMoralReputation(2);
						return "Survivors3";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivors2",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_22.png[/img]{只有天真之人才会选择仁慈。你下令处决了所有囚犯。 | 你想起匪徒曾无数次残杀无辜商人。这个念头刚从你脑海冒出，你就下达了处决命令。囚犯们发出短暂的抗议，但很快被刀剑长矛打断。 | 你背过身去。%SPEECH_ON%对准脖子。利落点。%SPEECH_OFF%佣兵们执行了命令，你随即听到将死之人的哽咽声。整个过程根本谈不上利落。 | 你摇头拒绝。囚犯们失声哀嚎，但队员们已然扑上，挥砍劈刺。幸运者在意识到死亡降临前便已身首分离。那些尚存反抗意志的则煎熬至最后一刻。 | 仁慈需要时间。需要你回头审视的时间。需要质疑抉择的时间。你没有时间，也就没有仁慈。囚犯被尽数处决——这花不了多少时间。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "还有更要紧的事等着我们。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivors3",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_22.png[/img]{今天的杀戮与死亡已经够多了。你释放了囚犯，收缴他们的武器盔甲后便放他们离开。 | 对盗匪的宽恕并不常见，因此当你释放囚犯时，他们几乎要亲吻你的脚，仿佛在膜拜神明。 | 你沉思片刻，随后点头。%SPEECH_ON%那就饶他们一命。没收了装备就放人。%SPEECH_OFF%囚犯们被释放，留下的武器盔甲都归了你们。 | 你让匪徒们脱得只剩衬衣——如果他们还有的话——随后放他们离开。%randombrother%在翻捡留下的装备时，而你目送那群半裸男子仓惶逃远。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "杀了他们也没人多给钱。",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{战斗刚结束，一切开始安静下来时，你听到一名男子的喊叫声。循声而去，发现是匪徒的一名囚犯。他的嘴和双手都被绳索捆绑，你迅速解开了束缚。他喘过气后，怯生生地询问能否加入你们的队伍。 | 在匪徒营地中发现一名被捆绑的囚犯。解救他后，他解释自己来自%randomtown%，几天前刚被这群流寇绑架。他询问是否能加入你的佣兵团队。 | 在翻捡匪徒营地的残余物资时，你发现了他们关押的一名囚犯。释放他后，男子坐起身来解释，自己是在前往%randomtown%找工作的途中被这些匪徒绑架的。你在想或许他可以为你效力…… | 战斗结束后一名男子还留在战场上。他并非匪徒，实际上是他们的囚犯。当你问起他的身份时，他提到自己来自%randomtown%并且正在找工作。你问他是否会使剑。他点了点头。}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "你不妨加入我们。",
					function getResult()
					{
						return "Volunteer2";
					}

				},
				{
					Text = "回家。",
					function getResult()
					{
						return "Volunteer3";
					}

				}
			],
			function start()
			{
				local roster = this.World.getTemporaryRoster();
				this.Contract.m.Dude = roster.create("scripts/entity/tactical/player");
				this.Contract.m.Dude.setStartValuesEx(this.Const.CharacterLaborerBackgrounds);

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Volunteer2",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_22.png[/img]{这这名男子加入了你的队伍，融入这群兄弟之中——对于一群雇佣杀手来说，大家对他的接纳算得上相当热情了。新来的自称精通所有武器，但你觉得该由你来决定他最擅长用什么。 | 当你招手让囚犯加入时，他笑得合不拢嘴。几个弟兄询问该给他配什么武器，你耸耸肩说你会自己决定给这人装备什么。}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "我们得给你找把武器。",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
				this.World.getPlayerRoster().add(this.Contract.m.Dude);
				this.World.getTemporaryRoster().clear();
				this.Contract.m.Dude.onHired();
				this.Contract.m.Dude = null;
			}

		});
		this.m.Screens.push({
			ID = "Volunteer3",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_22.png[/img]{你摇头拒绝。男子皱起眉头。%SPEECH_ON%你确定吗？我挺擅长……%SPEECH_OFF%你打断他。%SPEECH_ON%我很确定。现在享受你重获的自由吧，陌生人。%SPEECH_OFF% | 你打量了这名男子，判断他不适合佣兵生活。%SPEECH_ON%我们感谢你的提议，陌生人，但佣兵生涯危机四伏。回家去吧，回去找你的家人、你的工作、你的家园。%SPEECH_OFF% | 你手下的队员已经足够用了，虽然你差点想用他替换%randombrother%好看看那人被降职时的反应。但最终你还是与囚犯握了握手并送他上路。尽管失望，他还是感谢你解救了他。}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "走吧。",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
				this.World.getTemporaryRoster().clear();
				this.Contract.m.Dude = null;
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{你回到%townname%与%employer%会面。你的任务经过很简单：剿灭了那帮匪徒。他点点头，简短一笑，随即按约定支付了报酬。%SPEECH_ON%干得好，伙计们。那些匪徒可给我们添了不少麻烦。%SPEECH_OFF% | %employer%在你抵达时亲自为你开门。他手里提着个钱袋向你示意。%SPEECH_ON%你既然回来了，说明匪徒都解决了吧？%SPEECH_OFF%你点头。那人把钱袋抛过来。你提醒他也许你在撒谎。%employer%耸耸肩。%SPEECH_ON%也许吧，但白眼狼反咬一口这种事情，没两天就传遍世界了。干得漂亮，佣兵。当然如果只是你谎报军情，我会去找你算账的。%SPEECH_OFF% | %employer%在你进屋将首级扔上他书桌时咧嘴笑了。%SPEECH_ON%不必弄脏我的名贵家具来证明你完成了任务，佣兵。我早已收到捷报——这地方的信鸟飞得可真快，不是吗？报酬在墙角。%SPEECH_OFF% | 你刚汇报完，%employer%便用手帕擦拭额头。%SPEECH_ON%当真全都解决了？天啊……你根本不知道卸下了我多重的负担，佣兵。完全想象不到！你的克朗，如约奉上。%SPEECH_OFF%他将钱袋放在桌上，你迅速收下。分文不差，一如约定。 | %employer%抿着酒杯点头。%SPEECH_ON%知道吗，我向来不待见你们这类人，但这次干得漂亮，佣兵。%randomname%在你抵达前就向我汇报了匪徒全灭的消息。据他描述，当时的场面相当动人。所以嘛……%SPEECH_OFF%他将钱袋重重放在桌上。%SPEECH_ON%按约定，这是相当动人的报酬。%SPEECH_OFF% | %employer%靠着椅背，双手交叠放在膝上。%SPEECH_ON%佣兵向来不受待见，想必是因为你们常为点蝇头小利就屠杀村民——但我得承认这次你们做得不错。%SPEECH_OFF%他朝屋角努了努嘴，那儿放着未上锁的木箱。%SPEECH_ON%全在里面，要清点的话我也不介意。%SPEECH_OFF%你确实清点了，分文不差。 | %employer%的书桌铺满污损展开的卷轴。他对着它们暖笑，仿佛在凝视宝藏。%SPEECH_ON%贸易合约！到处都是贸易合约！快乐的农夫！幸福的家庭！皆大欢喜！啊，当个快活人真好。当然你也挺快活，佣兵，因为你的钱袋刚刚沉了不少！%SPEECH_OFF%他朝你扔来一个小钱袋，接着又一个，再接一个。%SPEECH_ON%本来能用大钱袋支付，但我偏喜欢这么给。%SPEECH_OFF%这人嬉皮笑脸地又抛来一袋，你面无表情地接住，带着剑刃血迹未干者特有的漠然从容。}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "摧毁了强盗营地");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color]克朗"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{你将罪犯的首级扔到%employer%的桌上。咧嘴一笑，指着它。%SPEECH_ON%这就是%robberbaron%。%SPEECH_OFF%%employer%起身掀开覆盖战利品的粗麻布。他点头。%SPEECH_ON%没错，确实是他。看来这笔额外报酬你拿定了。%SPEECH_OFF%你因剿灭匪帮并摧毁附近多个犯罪集团的首脑而获得了整整%reward%克朗。 | %employer%在你提着头发拎着首级进屋时向后靠去。幸运的是，脑袋没有在滴血。%SPEECH_ON%这是%robberbaron%的脑袋。%SPEECH_OFF%%employer%缓缓起身粗略看了一眼。%SPEECH_ON%这么说，你不仅端了匪徒的老巢，还把首领的脑袋带给了我。干得漂亮，佣兵，这份额外奖赏你拿定了。%SPEECH_OFF%他推过来装有%original_reward%克朗的包裹，又从自己腰间取下钱袋抛给你。 | 你举起%robberbaron%的首级，它歪斜的目光扫过血淋淋的发丝。%employer%脸上慢慢浮现笑容。%SPEECH_ON%知道你立了什么功吗，佣兵？知道砍下那人脑袋给这片地区带来多大安宁吗？你的报酬将远超约定！%original_reward%克朗是原定任务酬金，再加上……%SPEECH_OFF%他将一个鼓囊囊的钱袋滑过桌面。%SPEECH_ON%一点小意思……就当是你一路扛着脑袋回来的辛苦费。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "受之无愧。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() * 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "摧毁了强盗营地");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() * 2;
				this.Contract.m.OriginalReward = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color]克朗"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"reward",
			this.m.Reward
		]);
		_vars.push([
			"original_reward",
			this.m.OriginalReward
		]);
		_vars.push([
			"robberbaron",
			this.m.Flags.get("RobberBaronName")
		]);
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
		if (this.m.SituationID == 0)
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
		_out.writeI32(0);

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
		_in.readI32();
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		this.contract.onDeserialize(_in);
	}

});
