this.hunting_alps_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		SpawnAtTime = 0.0,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_alps";
		this.m.Name = "终结噩梦";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
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

		local names = [
			"梦魇",
			"噩梦窃贼",
			"灵魂窃贼",
			"夜行者 ",
			"夜游",
			"夜魔",
			"夜惊症",
			"夜行者"
		];
		this.m.Flags.set("enemyName", names[this.Math.rand(0, names.len() - 1)]);
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"终结困扰" + this.Contract.m.Home.getName() + "的噩梦"
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

				if (r <= 25)
				{
					this.Flags.set("IsGoodNightsSleep", true);
				}

				this.Contract.m.Home.setLastSpawnTimeToNow();
				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
			}

			function update()
			{
				if (this.World.getTime().IsDaytime)
				{
					this.Contract.m.SpawnAtTime = 0.0;
				}
				else if (this.Contract.m.SpawnAtTime == 0.0 && !this.World.getTime().IsDaytime)
				{
					this.Contract.m.SpawnAtTime = this.Time.getVirtualTimeF() + this.Math.rand(8, 18);
				}

				if (this.Flags.get("IsVictory"))
				{
					this.Contract.setScreen("Victory");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (this.Contract.m.Target == null && !this.World.getTime().IsDaytime && this.Contract.isPlayerNear(this.Contract.m.Home, 600) && this.Contract.m.SpawnAtTime > 0.0 && this.Time.getVirtualTimeF() >= this.Contract.m.SpawnAtTime)
				{
					this.Flags.set("IsEncounterShown", true);
					this.Contract.setScreen("Encounter");
					this.World.Contracts.showActiveContract();
				}
				else if (!this.Flags.get("IsBanterShown") && this.World.getTime().IsDaytime && (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || this.Contract.m.Target.isHiddenToPlayer()) && this.Contract.isPlayerNear(this.Contract.m.Home, 600) && this.Time.getVirtualTimeF() - this.Flags.get("StartTime") >= 6.0 && this.Math.rand(1, 1000) <= 5)
				{
					this.Flags.set("IsBanterShown", true);
					this.Contract.setScreen("Banter");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Alps")
				{
					this.Flags.set("IsVictory", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Alps")
				{
					this.Contract.m.SpawnAtTime = -1.0;
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
					this.Contract.setScreen("Success");
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
			Text = "[img]gfx/ui/events/event_79.png[/img]{%employer%手里拿着个枕头，旁边的人正摸着它表面的枕套，然后凑过去闻了闻。他摇摇头，然后又再闻了一遍%employer%招呼你过去。%SPEECH_ON%这附近有个农夫报告说有个奇怪的鬼怪入侵他的梦境。他把自己床上的东西都拿来了，但我们看不出个所以然。%SPEECH_OFF%你看着那个再次把脸埋进枕套的怪人，扬起眉毛表示可以亲自调查。%employer%点头。%SPEECH_ON%这正是我找你的原因。希望你在这里守一两晚，看看夜里会不会出现什么古怪的东西。我猜多半是虚惊一场，但不管有没有发现都会付你报酬。你觉得如何，有兴趣吗？%SPEECH_OFF%那个怪人几乎把整张脸埋进枕头里大口吸气，仿佛要把自己闷死似的，还问能不能留下这个枕头。 | %employer%带你到书桌前，上面散落着几幅画。%SPEECH_ON%我平时不随便给当地人纸笔，但有几户人家坚持要把看到的东西画下来。%SPEECH_OFF%你翻看画作，每张内容各异，大多是形态杂乱的简笔画人形。其中一幅画技稍好的作品里，有个诡异生物正骑在一个人背上，双手抱着那人的脑袋像是要偷走。他继续道。%SPEECH_ON%对在我看来就是普通噩梦，但我去他们家查看了，每户都像是被什么东西翻动过。佣兵，我希望你留下来查探究竟。可能只是小混混捣乱，但还是得认真对待。有兴趣吗？%SPEECH_OFF% | 你看见%employer%正在听农夫讲事情。他发现你来了便让农夫直接跟你说。 对方解释最近他和许多村民都在做可怕的噩梦，不仅家养宠物失踪，还有孩子说半夜被掳走，自己摸黑走回家。%employer%点头道。%SPEECH_ON%全镇都人心惶惶，佣兵。我听说过%enemy%的传说，那种以梦境为食的怪物，但估计就是些小屁孩在搞鬼。不管怎样，我们已经筹好了赏金，准备雇人加强守卫。你有兴趣吗？%SPEECH_OFF% | %employer%在书桌前重重地叹了口气。%SPEECH_ON%该死地乡巴佬整天嚷嚷%enemy%东%enemy%西的。 我感觉就像肩上压了座大山，简直是山脉连绵！%SPEECH_OFF%他找了个椅子坐下，给他自己倒了杯啤酒并一口气灌了下去。%SPEECH_ON%什么食梦者，什么夜潜者，呸！一派胡言。不过这群傻瓜凑了一箱钱币想雇护卫。希望你守一两夜，看看究竟是真有怪物还是有人在装神弄鬼。有兴趣吗？%SPEECH_OFF% | %employer%抱着头左摇右晃。 你询问是否改日再来，他猛地捶桌。%SPEECH_ON%不！来得正好。镇民连续几天抱怨做怪梦，昨晚连我都做了噩梦——站在麦田里看见阴影掠过，麦秆被压扁，醒来时正好瞥见有东西窜出门外。我们想请你守夜，看看你能否也遇到这些。有兴趣吗？%SPEECH_OFF% | 你看见%employer%正在翻动古籍，尘埃随书页飞扬。他头也不抬地说道。%SPEECH_ON%镇上凑了钱雇你守夜。%SPEECH_OFF%你咧嘴笑问是否管饭，对方缓缓合上书，面无表情地看着你，仿佛你什么也没说一样。%SPEECH_ON%据说有怪物靠食梦为生。我原以为是迷信，但昨晚他们找上我了。我醒来时竟在阁楼上向达库尔祈祷。达库尔又是什么鬼东西？ 我完全搞不清状况，但真心希望你能接下这差事。守上一两晚，看看我们面临的究竟是谣言还是实打实的威胁。%SPEECH_OFF% | %employer%正在把玩一个木雕小像，看起来像个脑袋长角的人。他把雕像扔到桌上。 他把它丢在桌上并对他点头。%SPEECH_ON%木匠做的，说夜里见过这玩意。我问什么时候，他说在梦里，醒来时发现它就站在床边。 今天又有三户人家来说见过同样的东西，他们家养的狗全都不见了。佣兵，我不知道这片土地滋生着什么邪祟，但不能再毫无防备地过夜了。你愿意为%townname%守上一两个晚上吗？%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{你能拿出多少克朗？ | 谈谈报酬吧。 | 佣金是多少？ | 我们可以调查一下。只要价钱合适。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{听起来不像是雇佣兵的工作。 | 听起来这活不适合我们。 | 我们不想接这类差事。}",
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
			ID = "Banter",
			Title = "%townname%附近……",
			Text = "[img]gfx/ui/events/event_79.png[/img]{就在你们休息时，有个老人路过。他没等询问就主动告诉你们，要是想找那些苍白的人，最好等到晚上。%randombrother%问他苍白的人是什么意思。老人笑了笑。%SPEECH_ON%说实话，它们既不苍白也不是人，但我不知道该怎么形容这些东西。老一辈叫它们%enemy%这种怪物会往人脑子里塞可怕的念头和幻象，然后以滋生的恐惧为食。不过你们看起来够结实，应该没问题。%SPEECH_OFF%他擦了擦鼻子并祝你们好运。 | 你正在查看地图熟悉地形，%randombrother%带了个老妇人过来。她脸上密布着皱纹，看起来和树皮差不多。老妇人用颤抖的手招呼你过去。你凑近听她用沙哑的声音说。%SPEECH_ON%他们夜里来。和那些幻象一起。%SPEECH_OFF%她竖起一根手指。%SPEECH_ON%只在夜里！它们靠腐蚀人的心灵过活。我母亲管它们叫%enemy%，说是专门制造幻影和虚假景象的怪物。你们遇上的时候，会听见理智流失的嘶嘶声。抓紧了才能活命。%SPEECH_OFF% | %randombrother%来到你身边，说他以前听说过这些野兽。%SPEECH_ON%古老的故事里提到过这种东西，它们会蹲在窗台上看你睡觉，或者爬上床扒开你的梦境往里瞧。也有人说根本不是这样。他们说这些怪物能在你清醒时往你脑袋里塞幻象，让你看见不存在的东西。%SPEECH_OFF% | %randombrother%若有所思地走过来。他解释说很久以前认识一个因谋杀被绞死的人，那人把自己的孩子剁成了碎块。但被告辩称自己只是在杀鸡。说他当时看见的都是鸡和羽毛，分明只是家禽。他说等清醒过来看见眼前的惨状时，有只野兽正在窗台上窃笑，蹲在那儿洋洋得意地咯咯笑。佣兵点头道。%SPEECH_ON%绞死那家伙的时候，据说他对着什么东西大喊大叫，自己踢开了凳子。大家说他吊在半空中还在不停地蹬腿跑，尽管绳子已经勒得脖子都快断了，还在嚷嚷要报仇。%SPEECH_OFF% | %randombrother%着侦察报告来找你。他说当地人没亲眼见过野兽，但都出现了不正常的幻觉。当你要求解释时，佣兵耸耸肩。%SPEECH_ON%我说不清楚，长官。要我说他们就只是有幻觉而已。我是不信这种胡话的，但他们确非常当真。%SPEECH_OFF% | 就在你们休息时，有个老人路过。他没等询问就主动告诉你们，要是想找那些苍白的人，最好等到晚上。%randombrother%问他苍白的人是什么意思。老人笑了笑。%SPEECH_ON%说实话，它们既不苍白也不是人，但我不知道该怎么形容这些东西。老一辈叫它们%SPEECH_OFF%他擦了擦鼻子并祝你们好运。 | 你正在查看地图熟悉地形，%randombrother%带了个老妇人过来。她脸上密布着皱纹，看起来和树皮差不多。老妇人用颤抖的手招呼你过去。你凑近听她用沙哑的声音说。%SPEECH_ON%他们夜里来。%SPEECH_OFF%她竖起一根手指。%SPEECH_ON%只在夜里！它们靠腐蚀人的心灵过活。我母亲管它们叫%enemy%。你们遇上的时候，会听见理智流失的嘶嘶声。可一定要抓紧了。%SPEECH_OFF% | %randombrother%来到你身边，说他以前听说过这些野兽。%SPEECH_ON%时不时会听到关于它们的传言。说是有种东西蹲在窗台上看你睡觉，或者爬上床扒开你的梦境往里瞧。人们叫它们梦魇，据我所知它们只在晚上出来。当然，前提是它们真的存在。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{睁大眼睛。 | 做好准备。 | 保持清醒，伙计们。}",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Encounter",
			Title = "%townname%附近……",
			Text = "[img]gfx/ui/events/event_102.png[/img]{%randombrother%匆忙跑到你身边。%SPEECH_ON%那边有东西在动。%SPEECH_OFF%你望向队伍外围，那东西不像在行走，倒像是在地面上滑行。它形似一具被剥了皮的鹿尸正倒着行走，双眼在身后留下墨黑的痕迹，仿佛要将恐惧本身刻在大地上。你立即下令全员备战。 | 借着火把光亮查看地图时，你突然瞥见漆黑中窜过一道黑影。那是一团四肢着地的扭曲形体，以反常的速度在地面翻滚前行。它如蛇般贴地潜行，耳边却传来仿佛有人梦中窒息般的哽咽低吼。你立刻下令全员拿起武器。 | 一道苍白的身影在战团巡逻边缘游走。它蹲伏在高草丛中凝视着队伍。最终你走上前去张开双臂闭上双眼。%randombrother%立即惊呼。%SPEECH_ON%长官快回来！天啊，四周还有更多！%SPEECH_OFF%你睁开眼睛点了点头——它们终于来了。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "冲锋！",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Alps";
						p.Entities = [];
						p.Music = this.Const.Music.BeastsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Alps, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_122.png[/img]{怪物们已被尽数消灭。你挥剑砍向其中一具尸体的脖颈，利刃毫无阻滞地斩过，头颅滚落草丛。它的眼窝空洞凹陷，里面既无血肉也无筋骨，什么都没有。你命令队员们准备返回%employer%。 | 梦魇的尸体散落在草丛中，虽然你亲眼看着它们受伤，但此刻它们的皮肉似乎已经愈合，仿佛是被你们的意志而非兵器所摧毁。你试图用剑锯下一颗头颅，却发现剑刃轻易划开皮肤后，颈部的创口竟自动收缩闭合。你又朝尸体连刺数剑，扭转剑刃撕开无法愈合的伤口。肌腱短暂蠕动后便僵在创口中。虽难以理解这现象，你还是将头颅铲进布袋，下令整队返回%employer%。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "该去领取报酬了。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_79.png[/img]{%employer%要求查看梦魇的残骸。你从行囊中取出首级。上面的血肉已萎缩，握在手中的更像是带发的头皮而非头骨。镇民用指尖触碰时，梦魇皮肤如蛇蜕般退缩卷曲。他问这些生物是否难缠。你耸耸肩。%SPEECH_ON%是很难缠，但还不至于让我睡不着觉。%SPEECH_OFF%对方勉强点头。%SPEECH_ON%好吧。这是说好的报酬。把那恶心玩意儿扔了吧。%SPEECH_OFF% | 你把梦魇的首级丢到%employer%的桌案上。 那颗头在桌面上翻滚直至下颌大张，空洞的眼窝无神地望着上方。%employer%用拨火棍拨弄着头骨，最后把这不成形的玩意儿挑在半空。%SPEECH_ON%这玩意可真吓人。 我得跟你说刚才很多乡亲们来找我，说他们梦见田野沐浴在圣光里，就像看到了世界重生。虽然不敢说每个怪物都消灭干净了，但%townname%的麻烦看来是解决了。答应你的报酬这就给你。%SPEECH_OFF% | %employer%在房间里接待你，看着你带的包裹笑了起来。他一边倒酒一边摇头。%SPEECH_ON%不用给我看那恶心玩意儿的脸了，佣兵。几小时前它来找过我，当时我正坐在那儿写东西，突然就像做了个梦，看见它死去的景象，好像它的灵魂从我的身上被硬扯开，逼着我看着它消失。在它离开的时候，我看见你握着剑，站在那里，威风得不得了。%SPEECH_OFF%你点点头问自己当时看起来怎么样。他大笑。%SPEECH_ON%你看着像个能毁灭世界的屠夫，至少是那怪物的屠夫——而且我不得不承认，可能把我的心神也永远带走了一部分。不过没关系，不管我是个完整的人还是缺了点什么，我答应过要给你一大笔报酬，拿走吧。%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "狩猎成功。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "让小镇摆脱不自然的噩梦");

						if (this.Flags.get("IsGoodNightsSleep"))
						{
							return "GoodNightsSleep";
						}
						else
						{
							this.World.Contracts.finishActiveContract();
							return 0;
						}
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
		this.m.Screens.push({
			ID = "GoodNightsSleep",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_33.png[/img]{你寻思伙计们是时候休息了，便带队在%townname%暂歇。众人睡得昏天黑地，恍若昏死过去。 醒来时个个伸着懒腰打着哈欠，没人记得任何美梦或噩梦。这场酣眠只是短暂的空白，却正是他们迫切需要的。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我觉得神清气爽！",
					function getResult()
					{
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 75)
					{
						bro.improveMood(1.0, "睡了一夜好觉，神清气爽");
						bro.getSkills().removeByID("effects.exhausted");
						bro.getSkills().removeByID("effects.drunk");
						bro.getSkills().removeByID("effects.hangover");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Target.getTile())]
		]);
		_vars.push([
			"enemy",
			this.m.Flags.get("enemyName")
		]);
		_vars.push([
			"enemyC",
			this.m.Flags.get("enemyName").toupper()
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/terrifying_nightmares_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}

		if (this.m.Home != null && !this.m.Home.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Home.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(3);
			}
		}
	}

	function onIsValid()
	{
		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Target != null && !this.m.Target.isNull())
		{
			_out.writeU32(this.m.Target.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.m.Flags.set("SpawnAtTime", this.m.SpawnAtTime);
		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		if (!this.m.Flags.has("StartTime"))
		{
			this.m.Flags.set("StartTime", 0);
		}

		this.contract.onDeserialize(_in);

		if (this.m.Flags.has("SpawnAtTime"))
		{
			this.m.SpawnAtTime = this.m.Flags.get("SpawnAtTime");
		}
	}

});
