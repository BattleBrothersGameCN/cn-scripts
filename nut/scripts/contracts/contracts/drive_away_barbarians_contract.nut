this.drive_away_barbarians_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		Reward = 0,
		OriginalReward = 0
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.drive_away_barbarians";
		this.m.Name = "击退野蛮人";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.000000;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		local banditcamp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getNearestSettlement(this.m.Home.getTile());
		this.m.Destination = this.WeakTableRef(banditcamp);
		this.m.Flags.set("DestinationName", banditcamp.getName());
		this.m.Flags.set("EnemyBanner", banditcamp.getBanner());
		this.m.Flags.set("ChampionName", this.Const.Strings.BarbarianNames[this.Math.rand(0, this.Const.Strings.BarbarianNames.len() - 1)] + " " + this.Const.Strings.BarbarianTitles[this.Math.rand(0, this.Const.Strings.BarbarianTitles.len() - 1)]);
		this.m.Flags.set("ChampionBrotherName", "");
		this.m.Flags.set("ChampionBrother", 0);
		this.m.Payment.Pool = 600 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.750000;
			this.m.Payment.Advance = 0.250000;
		}
		else
		{
			this.m.Payment.Completion = 1.000000;
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
					"把野蛮人逐出" + this.Flags.get("DestinationName") + "(%origin% %direction%)"
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
				this.Contract.m.Destination.setLastSpawnTimeToNow();
				this.Contract.m.Destination.clearTroops();

				if (this.Contract.getDifficultyMult() <= 1.150000 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.Barbarians, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setLootScaleBasedOnResources(110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.000000);
				local r = this.Math.rand(1, 100);

				if (r <= 20)
				{
					if (this.World.getTime().Days >= 10)
					{
						this.Flags.set("IsDuel", true);
					}
				}
				else if (r <= 40)
				{
					if (this.World.Assets.getBusinessReputation() >= 500 && this.Contract.getDifficultyMult() >= 1.000000)
					{
						this.Flags.set("IsRevenge", true);
					}
				}
				else if (r <= 50)
				{
					this.Flags.set("IsSurvivor", true);
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
				if (this.Flags.get("IsDuelVictory"))
				{
					this.Contract.setScreen("TheDuel2");
					this.World.Contracts.showActiveContract();
					this.Flags.set("IsDuelVictory", false);
				}
				else if (this.Flags.get("IsDuelDefeat"))
				{
					this.Contract.setScreen("TheDuel3");
					this.World.Contracts.showActiveContract();
					this.Flags.set("IsDuelDefeat", false);
				}
				else if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsSurvivor"))
					{
						this.Contract.setScreen("Survivor1");
						this.World.Contracts.showActiveContract();
					}

					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (this.Flags.get("IsDuel"))
				{
					this.Contract.setScreen("TheDuel1");
					this.World.Contracts.showActiveContract();
				}
				else if (!this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Contract.setScreen("Approaching");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Duel")
				{
					this.Flags.set("IsDuelVictory", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Duel")
				{
					this.Flags.set("IsDuelDefeat", true);
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
				if (this.Flags.get("IsRevengeVictory"))
				{
					this.Contract.setScreen("Revenge2");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsRevengeDefeat"))
				{
					this.Contract.setScreen("Revenge3");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsRevenge") && this.Contract.isPlayerNear(this.Contract.m.Home, 600))
				{
					this.Contract.setScreen("Revenge1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Revenge")
				{
					this.Flags.set("IsRevengeVictory", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Revenge")
				{
					this.Flags.set("IsRevengeDefeat", true);
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer%叹了口气，将一张纸片推到你面前。那是一份罪行清单。你点点头，观察到确实有相当多的不法行为。他也点了点头。%SPEECH_ON%要是那只是普通罪犯所为，我本可以找个巡警或是赏金猎人来处理。但我将你带到这里，佣兵，因为这是野蛮人的作为。他们所做的一切，那清单上列出的所有内容，我需要对他们采取同样的行动。他们的村庄在这里的%direction%边。我需要你去拜访他们，并让他们明白，尽管我们生活在有炉火和文明的世界里，但野性的火花仍未离我们远去，而野蛮行径必将得到野蛮的报应。明白吗？%SPEECH_OFF%你现在注意到那罪行清单上布满了折断的羽毛笔尖，仿佛写下这份清单的人对它的分类越来越不满意。 | 一群当地的骑士正和%employer%一同待在房间里。他们平淡地打量着你，仿佛你是一只推开门、闲逛进来的狗。%employer%从椅子上俯下身，拿起一个卷轴，扔给你。%SPEECH_ON%野蛮人在附近一个被摧毁的农场里给我留下了这个。%SPEECH_OFF%纸上有符文的图案和类似绞刑的描绘。%employer%点了点头。%SPEECH_ON%他们屠杀了农民，至少是男人们。至于女人，只有古神们知道她们的下落。从这往%direction%走，佣兵，找到该为这一切负责的那些野蛮人。他们彻底、完全的被消灭会给你带来丰厚的报酬。%SPEECH_OFF% | 当你走进房间时，%employer%看起来相当不悦。他声称%townname%曾经与北方的野蛮人保持着良好的关系。%SPEECH_ON%但我想，我只是在自欺欺人地认为我们能够和那些野蛮人保持平等关系。%SPEECH_OFF%他声称他们一直在袭击商队、谋杀旅行者和攻击定居点。%SPEECH_ON%所以我会以牙还牙。往%direction%走，屠掉他们的村庄。你愿意做这件事吗？%SPEECH_OFF% | %employer%在你走进房间时大笑起来。%SPEECH_ON%不是在笑你，佣兵，只是在笑这种残忍的结合 —— 找位佣兵来迅速彻底地消灭野蛮人。你看，就在这%direction%边有支穿着熊皮的混蛋部落一直在剥头皮、砍杀商队和旅行者。我不能容忍这样。有一部分原因是他们错了，但更重要的是我有钱雇你这种不友好之人来替我解决这个问题。%SPEECH_OFF%他再次笑了起来。你感觉到这个人从未向任何有生命的生物挥过剑。%SPEECH_ON%那么，你怎么说，佣兵，有兴趣屠一些野蛮人吗？%SPEECH_OFF% | 当你进入%employer%的房间时，他正在盯着一只狗的头看。液体从脖子上持续不断地滴落在桌子的边缘。这个人正在摩挲它的一只耳朵。%SPEECH_ON%谁会把一个人的狗杀掉、割下脑袋，还他妈地送回来？%SPEECH_OFF%你想象着某个人有着仇敌，但什么也没说。%employer%向他的一个仆人点了点头，狗的头被拿走了。他现在打量着你。%SPEECH_ON%这事是%direction%边的野人干的。首先，他们对商人和定居者动手，就像野蛮人一样强奸和抢劫。所以我做出了回应，杀了他们几个人，这就是我得到的回报。好了，再也不会容忍这些家伙了。我希望你去他们的村庄，将他们全部消灭殆尽。%SPEECH_OFF%你几乎问出这是否包括摧毁他们的狗。 | 你看见%employer%的椅子旁边坐着一个脏兮兮、浑身是泥的女人。她的头发乱蓬蓬的，身上遍布惩罚的伤痕。她瞪着你，似乎将所有的责备都归咎于你。%employer%踢倒她。%SPEECH_ON%别在意这个村姑，佣兵。我们在她和她的朋友闯入粮仓时把他们逮个正着。我们杀了这群野蛮人的大部分，我想说我们留她下来只是为了好玩，但是打她跟打狗一样没意思。她的男人味只是让人失去了乐趣。%SPEECH_OFF%他又踢了她一脚，她咆哮着回应。%SPEECH_ON%明白了吗？我有了新消息！我们找到了她的脏窝，我有意将其彻底摧毁。这就是你的任务。野蛮人村庄就在这里的%direction%面。消灭他们，你会得到丰厚的报酬。%SPEECH_OFF%那个女人听不懂他在说什么，但她的眼神中传达出一些疲惫，似乎她开始理解为什么你这样的人会走进这里。%employer%咧嘴一笑。%SPEECH_ON%你有兴趣吗，或者我得找个更凶恶的角色？%SPEECH_OFF% | %employer%的房间里挤了一群乡巴佬，他们的数量比他这个身份的人在如此近距离下会感到舒适的量要多得多，但令人惊讶的是，他们似乎对私刑处死他并不感兴趣。看到你后，%employer%叫你靠近。%SPEECH_ON%啊，终于来了！我们的答案在这里！佣兵，%direction%边的野蛮人一直在掠夺附近的村庄，强奸任何一个带洞的东西。我们受够了，坦率地说，跟其他人一样，我不想再让脏兮兮的野蛮人举着他们的老二靠近我的屁股。%SPEECH_OFF%苦工们嘲笑起来，有个人大喊着说野蛮人{砍了他母亲的脑袋 | 还杀了他的宠物山羊 | 偷走了所有的狗，这些混蛋 | 吃了他小儿子的肝}。%employer%点了点头。%SPEECH_ON%是的。是的，诸位，是的！所以我说，佣兵，你得规划一条路线到达野蛮人的村庄，并给予他们适度、适当、文明的制裁。%SPEECH_OFF% | %employer%招呼你进房间。他手持火钩，钩头上挂着一张头皮。%SPEECH_ON%北方的野蛮人今天送来了这个。这块头皮被粘在信使身上，他们弄没了他的眼睛和舌头。这就是这些野蛮人的本性，他们想要和我交流却不发一句话。我的感觉是，在你的帮助下我将以其人之道，还治其人之身，佣兵。去%direction%边找到他们的村庄，将其夷为平地。%SPEECH_OFF%头皮从火钩上滑落，噗哧一声掉在石板地面上。 | %employer%不大情愿地欢迎你走进房间，这是当世界迫使人需要佣兵时人们通常会有的反应。他说话简明扼要。%SPEECH_ON%野蛮人在%direction%边有了个村庄，他们从那里往外派出掠夺队。他们强奸、劫掠，不过是有着人形的害虫。我要他们全都消失，一个不剩。你愿意接受这个任务吗？%SPEECH_OFF% | %employer%的膝上有只猫，但当你走近一看，你才意识到那只是猫的头，而他只是在用拇指摆弄着一根断尾。他紧闭双唇。%SPEECH_ON%野蛮人做的这事。他们还强奸和劫掠了周围的几个农舍, 他们还把一对双胞胎婴儿吊死在树上，但这个……%SPEECH_OFF%他打开手掌，猫的头滚了出来，咯噹一声落在石头地板上。%SPEECH_ON%不能再容忍了。我希望你往%direction%找到那些野蛮人所谓的家园，并像他们对我们所做的那样对待他们！%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{你愿意为此出多少克朗？ | %townname%准备为他们的安全付多少？ | 我们来谈谈价钱。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{不感兴趣。 | 我们有更重要的事情要做。 | 我祝你好运，但我们不会参与其中。}",
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
			ID = "Approaching",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_138.png[/img]{你找到了野蛮人村庄，以及通往那里的一系列石堆。这些石头堆成人形，每个石堆的顶部都放着一颗新鲜砍下的人头。%randombrother%点了点头。%SPEECH_ON%我想他们是否相信这样做可以让他们更接近他们的神呢。%SPEECH_OFF%你怀疑自己有另一种方法让他们更接近他们的神：把他们全部杀死。是时候制定一种进攻计划了。 | 你找到了野蛮人村庄，就在它的郊区，雪地中躺着一块圆石头。它太大了，整个队伍全员并肩站立也无法将其横跨。石头的外缘刻有符文，深沟里积满了干血。在石板的中央，有一个小的方形隆起物，上面弯成弧形，可以放置脖子。%randombrother%吐了一口口水。%SPEECH_ON%看起来像是献祭广场，呃，圆形。%SPEECH_OFF%环顾四周，你大声想知道他们把尸体放在哪里。佣兵耸了耸肩。%SPEECH_ON%不知道。可能吃掉了。%SPEECH_OFF%如果他们真的吃了尸体，你也不会感到奇怪。你盯着村庄，思考是攻击还是等待。 | 蛮族村庄就在不远处。这是一幅游牧场景，帐篷周围零散地布置着打铁的场地和被帆布覆盖的马车、粮仓。你感到他们不会在世界的任何一个特定地方逗留太久了。%randombrother%笑了。%SPEECH_ON%看那个，他在拉屎。真是个混蛋。%SPEECH_OFF%确实，一个野蛮人正蹲在与村里人交谈。这几乎就是一个比喻，让整个营地无所适从。 | 这个野蛮人村庄并没有想象中那么恐怖。除了悬挂在一台木制圣柱上的剥皮尸体外，它看起来就像任何一个普通人的地方一样。除了厚实的衣服和每个人都提着某种斧头或剑之类的武器。都很正常。这里有个人在砍一个尸体的腿，喂猪吃，但你几乎在任何地方都会看到这样的场景。%randombrother%点了点头。%SPEECH_ON%好的，我们准备好攻击了。只要下令，队长。%SPEECH_OFF% | 你发现蛮族村庄位于雪原上。它可能并没有待得太久：大部分都是帐篷，而且帐篷顶部没有积多少雪。他们必须停留一段时间，然后重新上路，无论是为了保持狩猎的新鲜度，还是为了避免那些他们抢劫的人的报复。很遗憾，他们没有做到后者。你准备好战斗了。 | 你找到了一个野蛮人村落。但是，乍一看，他们看起来和普通人没什么两样，男人、女人、孩子都有。有一位铁匠、一个制革匠、一个独眼汉在做箭，还有一个巨大的刽子手正在取出内脏，然后将其浸泡在驴子的器皿中。而那个刽子手让你想起来你来这里的原因。 | 你找到了野人村落。野蛮人正在举行某种宗教仪式。一个戴着乌龟壳项链的老人把他的拳头伸进一具被割去头发的脑袋中，让鲜血流到他的前臂上，孩子们拿马毛刷刷起这个“涂料”，然后把它涂在一个高达10英尺的木制圣像上。原始人们用完全陌生的语言观看和歌唱。%randombrother% 轻声说话，好像是出于对仪式的尊敬而不是害怕他们听到。%SPEECH_ON%嗯，我想我们可以下去见一见他们，好吗？%SPEECH_OFF% | 你找到了野蛮人在他们的村落闲逛。这里大多是帐篷和即興建造的雪屋。年长的妇女围坐在一起编织篮子，年轻的女子则在制箭并且不时地看着那些壮硕的男人。男人们虽然装作不在意，但你知道肯定有些花花公子。还有一些孩子匆忙来回奔波于各种任务之间。就在村子外面，一系列木桩上穿着从肛门到口腔裂开的赤裸尸体，他们的胸腔已像蝴蝶翅膀一样张开，内部埋着松散的绣花。%SPEECH_ON%太可怕了。%SPEECH_OFF%%randombrother%说。你点了点头。的确很可怕，但这就是你来这里的原因。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "准备攻击。",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "TheDuel1",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_139.png[/img]{就在%companyname%准备与野蛮人冲突之际，一个孤独的人走出来站在战线之间。他留着分开的长胡须，扣着乌龟壳，头上戴着狼头骨斜坡。长老手持一根长杖，挂着鹿角。令人震惊的是，他用你们的语言说话。%SPEECH_ON%外来者，欢迎来到北方。我们并不像你们想象的那样不友好。根据我们的传统，我们认为两个人之间的战斗和两支军队之间的战斗一样光荣有价值。于是，我提供了我的最强战士，%barbarianname%。%SPEECH_OFF%一个魁梧的男人走了出来。他解下皮毛，露出一身纯粹的肌肉、肌腱和疤痕。长老点了点头。%SPEECH_ON%外来者，出个你们的最强战士，我们一起度过一个所有先祖都会微笑的日子。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我宁愿烧毁整个营地。进攻！",
					function getResult()
					{
						this.Flags.set("IsDuel", false);
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
				local raw_roster = this.World.getPlayerRoster().getAll();
				local roster = [];

				foreach( bro in raw_roster )
				{
					if (bro.getPlaceInFormation() <= 17)
					{
						roster.push(bro);
					}
				}

				roster.sort(function ( _a, _b )
				{
					if (_a.getXP() > _b.getXP())
					{
						return -1;
					}
					else if (_a.getXP() < _b.getXP())
					{
						return 1;
					}

					return 0;
				});
				local name = this.Flags.get("ChampionName");
				local difficulty = this.Contract.getDifficultyMult();
				local e = this.Math.min(3, roster.len());

				for( local i = 0; i < e; i = ++i )
				{
					local bro = roster[i];
					this.Options.push({
						Text = roster[i].getName() + "会打败你们的冠军！",
						function getResult()
						{
							this.Flags.set("ChampionBrotherName", bro.getName());
							this.Flags.set("ChampionBrother", bro.getID());
							local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
							properties.CombatID = "Duel";
							properties.Music = this.Const.Music.BarbarianTracks;
							properties.Entities = [];
							properties.Entities.push({
								ID = this.Const.EntityType.BarbarianChampion,
								Name = name,
								Variant = difficulty >= 1.150000 ? 1 : 0,
								Row = 0,
								Script = "scripts/entity/tactical/humans/barbarian_champion",
								Faction = this.Contract.m.Destination.getFaction(),
								function Callback( _entity, _tag )
								{
									_entity.setName(name);
								}

							});
							properties.EnemyBanners.push(this.Contract.m.Destination.getBanner());
							properties.Players.push(bro);
							properties.IsUsingSetPlayers = true;
							properties.BeforeDeploymentCallback = function ()
							{
								local size = this.Tactical.getMapSize();

								for( local x = 0; x < size.X; x = ++x )
								{
									for( local y = 0; y < size.Y; y = ++y )
									{
										local tile = this.Tactical.getTileSquare(x, y);
										tile.Level = this.Math.min(1, tile.Level);
									}
								}
							};
							this.World.Contracts.startScriptedCombat(properties, false, true, false);
							return 0;
						}

					});
					  // [062]  OP_CLOSE          0      7    0    0
				}
			}

		});
		this.m.Screens.push({
			ID = "TheDuel2",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_138.png[/img]{%champbrother% 收起他的武器，立在被杀死的野蛮人的尸体旁。胜利的雇佣兵点点头，注视着你。%SPEECH_ON%完成了，先生。%SPEECH_OFF%长者再次前来，举起他的法杖。%SPEECH_ON%如此说来，你们想通过你们的暴力来解决什么问题呢？%SPEECH_OFF%你告诉他，南面的人非常愤怒，希望他们离开这片土地。长者点点头。%SPEECH_ON%如果通过战斗可以解决，那么通过荣誉决斗就会结束。我们会离开的。%SPEECH_OFF%用他们的方言告诉野蛮人收拾东西离开。出奇的是，很少有反驳或抱怨。如果他们信守诺言，那么你现在可以去告诉%employer%。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "一个好的结局。",
					function getResult()
					{
						this.Contract.setState("Return");
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						return 0;
					}

				}
			],
			function start()
			{
				local bro = this.Tactical.getEntityByID(this.Flags.get("ChampionBrother"));
				this.Characters.push(bro.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "TheDuel3",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_138.png[/img]{这是一场激烈的战斗，地上的人们在观察者的沉默中碰撞，仿佛在进行一场永恒而荣誉的仪式。但是%champbrother%躺在地上死去。被打败并且被杀死。长老再次向前迈出了一步，他没有流露出任何得意或者咧嘴的神情。%SPEECH_ON%外来人，两个男人之间的战斗就像我们所有人的胜利一样，我们已经赢了，幸福岩石的凝视是神圣的，所以我们请求你们离开这片土地，不要再回来。%SPEECH_OFF%一些佣兵愤怒地看着你，其中一人说他不认为野蛮人会遵守协议，如果情况颠倒了，公司应该无论结果如何都消灭这些野蛮人。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们会信守承诺，让你们安居乐业。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Assets.addMoralReputation(5);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, function ()
						{
							return this.RenderTemplate("没能摧毁威胁%s的野蛮人营地", this.Contract.m.Home.getName());
						}());
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				},
				{
					Text = "所有人，冲锋！",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-3);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivor1",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_145.png[/img]{战斗结束后，%randombrother%向你招手。在一顶帐篷里，有一个蛮族正在治疗伤口。在他周围，有男人、女人和孩子的尸体。佣兵指着他。%SPEECH_ON%我们在这里追赶了野蛮人。我想他周围的人都是他的家人或认识的人，因为他倒地不起，没有动过。%SPEECH_OFF%你走到那个男子面前，蹲下身。轻轻敲了敲他的鹿皮靴子，问他是否听得懂你的话。他点了点头，耸了耸肩。%SPEECH_ON%少许。你做了这件事。不必要，但你做了。要么结束我，要么我和你一起战斗。一条路，两情均尽。%SPEECH_OFF%他似乎是在向公司提供帮助，毫无疑问，这是一种你不熟悉的北方人的方式。他同样愿意献出自己的头颅，似乎毫不害怕。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们将不留一人活口。",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-1);
						return "Survivor2";
					}

				},
				{
					Text = "让他走。",
					function getResult()
					{
						this.World.Assets.addMoralReputation(2);
						return "Survivor3";
					}

				}
			],
			function start()
			{
				if (this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
				{
					this.Options.push({
						Text = "我们或许需要一个这样的人。",
						function getResult()
						{
							return "Survivor4";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Survivor2",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_145.png[/img]{你抽出剑，将剑尖指向那个人，帐篷里的尸体在剑身上模糊不清，剩下的野蛮人脸上露出笑容，用双手握紧剑身，将其插在剑鞘中。鲜血从他的手掌中不断滴落.%SPEECH_ON%杀死与死亡，并不丢人。是吗？%SPEECH_OFF%你点了点头，将剑刺向他的胸膛，他的身体向后倒下，沉重的感觉让你感觉像被一块石头压着。当你把他从剑上取下时，尸体又落回到尸体堆中。收起剑，你让队伍准备好搜刮财物，准备返回%employer%。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "是时候拿报酬了。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivor3",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_145.png[/img]{你一半地抽出剑，握住了足够长的时间，以至于野蛮人看见它，然后你把剑狠狠地插回鞘中。你点了点头，问道。%SPEECH_ON%明白了吗？%SPEECH_OFF%野蛮人站起来，短暂地倚在帐篷的柱子上。你转过身，伸出手去拉动帐篷帘子。他点了点头。%SPEECH_ON%好的，我知道了。%SPEECH_OFF%他跌跌撞撞地走出帐篷，在光线中消失在北方的荒原上，他的身影摇晃着消失了。你告诉战团准备回到%employer%领取应得的报酬。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "是时候拿报酬了。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivor4",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_145.png[/img]{你盯着那个人，然后掏出匕首，在手掌内侧划了一下。你挤出了一些血液，将匕首扔给了野蛮人，然后伸出手来，血滴缓缓滴落。野蛮人接过刀子，也划破了自己的手掌。他起身，伸出手，你们握了握手。他点了点头。%SPEECH_ON%荣誉，永远伴随。与你一同前行，不离不弃。%SPEECH_OFF%那个人跌跌撞撞地走出帐篷。你告诉士兵不要杀他，而是给他武装，这引起了一些人的关注。他加入队伍出人意料，但还是有用的。南方雇佣兵将会逐渐适应，但现在%companyname%需要回到%employer%。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "欢迎来到%companyname%战团。",
					function getResult()
					{
						this.World.getPlayerRoster().add(this.Contract.m.Dude);
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude.worsenMood(1.000000, "看到他的村庄被屠。");
						this.Contract.m.Dude.onHired();
						this.Contract.m.Dude = null;
						return 0;
					}

				}
			],
			function start()
			{
				local roster = this.World.getTemporaryRoster();
				this.Contract.m.Dude = roster.create("scripts/entity/tactical/player");
				this.Contract.m.Dude.setStartValuesEx([
					"barbarian_background"
				]);

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Revenge1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_135.png[/img]{一名男子挡在你的路上。他是位长者且并非南方人。%SPEECH_ON%啊，外来者。你们来到我们的土地，并洗劫了一座没有防御的村庄。%SPEECH_OFF%你呸了一口并点了点头。%randombrother%喊着说这就是那些野蛮人所做的。老人微笑着。%SPEECH_ON%所以我们陷入了循环，通过这种暴力我们才能重生，但这里必然会有暴力。等我们了结了你们，%townname%也不会幸免。%SPEECH_OFF%一排壮汉从藏身之处跳了起来。看起来他们是你们烧毁的那个村庄的主战派系。可能当时他们在外劫掠，而现在他们在寻求野蛮的复仇。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Revenge";
						properties.Music = this.Const.Music.BarbarianTracks;
						properties.EnemyBanners.push(this.Flags.get("EnemyBanner"));
						properties.Entities = [];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Barbarians, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getID());
						this.World.Contracts.startScriptedCombat(properties, false, true, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Revenge2",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_145.png[/img]{蛮族已经被驱逐出%townname%。尽管获得了胜利，但村民们需要时间才能走出来，看到你的胜利。%employer%最终出来鼓掌喊叫。一众窘迫的中尉四处张望，他们的膝盖被弄脏，散乱的稻草和土块散落在他们身上。看起来他们一直藏着不敢露面。%SPEECH_ON%干得好，雇佣兵，非常出色！古神肯定会看在眼里，并会适时地给予你回报！%SPEECH_OFF%你将剑插回剑鞘，对那些没用的中尉们点了点头。%SPEECH_ON%也许吧，但你还是要先做好自己的事。既然其他人，我们可以这么说，做不到，古神肯定会赞赏你代表他行动的。%SPEECH_OFF%那人皱起了嘴唇，瞥了眼他的中尉，但他们却避开了目光。你的雇主微笑着点头。%SPEECH_ON%当然，当然，雇佣兵。我理解你的苦衷。你将得到全额的报酬，还有更多！实至名归！%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "辛勤的一天工作。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() * 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, function ()
						{
							return this.RenderTemplate("你摧毁了一处威胁%s的野蛮人营地", this.Contract.m.Home.getName());
						}());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, function ()
						{
							return this.RenderTemplate("你从野蛮人的复仇中救下了%s", this.Contract.m.Home.getName());
						}());
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() * 2;
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了 [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] 克朗"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Revenge3",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_94.png[/img]{你在战场上失利，撤退到足够安全的地方观看%townname%的毁灭。野蛮人进入房屋中开始强奸和杀戮男女。孩子被抓起来，被装在用骨头和兽皮制成的笼子里，老人们轻轻地递给他们切成片的苹果和杯子里的樟脑。在市广场上，你看着原始人攻击%employer%的家。几个卫兵前进，但他们几乎立即被击倒。一个男子被放在地上，被剥光衣服，朝着一对狗被踢来踢去，他度过了一段令人不舒服的时间。 \n\n最后，%employer%被拖出家门。野蛮人的领袖盯着他，点了点头，然后用一只手抓住他的脖子，用另一只手掩住他的脸。在这种悬挂中，这个人窒息而亡。尸体被投给了团队，他们将其剥光、亵渎，然后将其从肛门插到嘴巴，高高地吊在市广场上。一旦抢劫完成，野蛮人就随心所欲地拿走了东西并离开了。你最后看见的是一只狗叼着一个人的肋骨在口中蹦跶。%randombrother%走到你身边。%SPEECH_ON%嗯。我想我们拿不到报酬了，先生。%SPEECH_OFF%不。你怀疑不会。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "一切都失去了。",
					function getResult()
					{
						this.World.FactionManager.getFaction(this.Contract.getFaction()).getRoster().remove(this.Tactical.getEntityByID(this.Contract.m.EmployerID));
						this.Contract.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 4);
						this.Contract.m.Home.setLastSpawnTimeToNow();
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail * 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 2, function ()
						{
							return this.RenderTemplate("你没能从野蛮人的复仇中救下%s", this.Contract.m.Home.getName());
						}());
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "临近 %townname%…",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer%欢迎你们的到来并送上掌声。%SPEECH_ON%我的侦察兵追踪了你们的战团北上，取得了难以置信的胜利！干得好，屠杀那些野蛮人。相信这会让他们三思再次来到这里的！%SPEECH_OFF%他向你们支付了应得的克朗。 | 你进入%employer%的房间，看见他靠在椅子上，光着身子的女人在他身边走来走去。他摇了摇头，看着表演，对你说话时甚至没抬起眼睛。%SPEECH_ON%我的侦察兵已经告诉我你们的事情。听说你们将野蛮人打得像他们对你们个人犯了罪一样？真棒。我喜欢这种缺乏约束力的行为。要是我的部下也能这样就好了。%SPEECH_OFF%一个不知从哪里冒出来的仆人火速跑到他们房间，头上架着一只红蜡烛，手中提着一箱克朗。你们拿到了报酬，并迅速离开了房间。 | 你发现%employer%和一群穿着盔甲的人站在一张桌子周围。桌上放着一个野蛮人的尸体。肌肉已被腐烂，但身体的肌肉系统并没有完全腐烂。他们问你是否真的打败了这种人。你直截了当地要求支付你的报酬。%employer%拍手，向大家展示你的能力。%SPEECH_ON%先生们，这就是我想要的人！丝毫不怯弱，时刻专注。%SPEECH_OFF%其中一位贵族吐了口唾沫说了些什么，你没听清楚。你要求他大声点说，但%employer%急忙抢过来，手中拿着一大堆克朗，送你离开了。 | 寻找%employer%有点困难，最终在一间看似废弃的牲畜棚中找到了他。你看到他站在一具死去的野蛮人面前，尸体被悬挂在横梁上，像渔民捕获的鱼一样。尸体已经被烧毁、毁容，以及其他的一切。%employer%蹲下来，在水桶里洗手。%SPEECH_ON%我必须说，佣兵，你杀了那么多野蛮人，真是非常印象深刻。这个野蛮人挺了好久。好像要把他的痛苦增倍还给我一样。但他从来没有这样做。你做到了吗？%SPEECH_OFF%那个人轻轻拍打着野蛮人的脸，链子发出清脆的响声，尸体轻轻扭曲着。%employer%点了点头。%SPEECH_ON%外面有个仆人会给你付钱。做得好，佣兵。%SPEECH_OFF% | 你找到了%employer%和一群人，他们正在监视%townname%的防御工事，无疑是为了准备下一次攻击。从这些人的样子来看，他们生存的意愿将遭遇到一种比他们准备好的更加残酷的现实。但你最好保持沉默。%employer%感谢你出色地完成了工作，并支付了所欠的款项。 | %townname%的居民们看到你们回来了，惊恐地认为你们是他们所熟知的野蛮人。窗户关闭，门被猛然关上，孩子们被匆忙带走，一些勇敢的人拿着干草叉冲了出来。%employer%赶出他的住所并解释清楚，说你们是这个故事的英雄，你们去北方，消灭了野蛮人，烧毁了他们的村落，让他们离开了这个地方。窗户推开，门吱吱作响，孩子们回到了玩耍中。你以为秩序已经恢复，但一位老妇人发出咆哮声。%SPEECH_ON%佣兵不过是另一个名字的野蛮人！%SPEECH_OFF%你叹了口气，告诉%employer%支付欠款。 | %employer%正在研究一些卷轴。他还在记录笔记并划掉一些。抬头看着你，他解释说，他将把你们的名字记录为“去荒野的英雄”和“以最合适和最南部的方式屠杀了野蛮人”。他问你们的名字是什么。你请他支付欠款。 | %employer% 正在一群哭泣的女人陪伴下。当你进来后他站起来向她们指了指你。%SPEECH_ON%看哪！那个杀了那些谋杀了你们丈夫的人的人！%SPEECH_OFF%女人们哭泣并一个接一个地向你跑来，你知道该怎么做，除了严肃地点头和冷静。%employer% 是这群人中最后一个找到你的人，手里拿着一箱克朗，嘴角挂着一个苦笑。你拿到了自己的报酬，他就回到了那些女人中。%SPEECH_ON%那个那个，好女人们，世界将会迎来新的黎明。请跟我来。谁要喝葡萄酒吗？%SPEECH_OFF% | %employer% 张开双臂欢迎你。你拒绝了他的拥抱并要求拿到自己的报酬，他就回到了他的桌子前。%SPEECH_ON%我并不是想拥抱你，佣兵。%SPEECH_OFF%他有点沮丧地拍打着这箱克朗。%SPEECH_ON%但是，你在屠杀那些野蛮人的时候干得很好。我有许多侦察员向我汇报，说你过得很“精彩”。你赚到了这些。%SPEECH_OFF%他将箱子推过桌子，你伸出手臂拿起它，并遇到了一丝阻力，因为他还在拿着它。你匆忙离开房间，没有再看他一眼。 | 你费了好大的劲才找到了%employer% ，他正站在井口中间用一块石板堵住一个洞。他朝你高声喊道。%SPEECH_ON%啊，佣兵。把我拉上来，伙计们！%SPEECH_OFF%一个滑轮系统把他坐着的木板拉了上来。他摆动腿坐在井口边上。%SPEECH_ON%我们的泥瓦匠被一头驴踢死了，所以我想自己帮忙。做点肮脏的工作对于一个健康的人来说并没有什么不好。%SPEECH_OFF%\n他用手套拍了拍你的胸部，留下了一层粉末。他点点头，让一个仆人去拿你的报酬。%SPEECH_ON%完成得很好，佣兵。非常，非常好。嘿。%SPEECH_OFF%你不理他。 | %employer%正在向一群农民发表演说。他描述了一支未知的南方军队向北进发，歼灭了野蛮的败类。你和%companyname%在演讲过程中从未被点名。演讲结束时，农民的暴动欢呼声和鲜花的飘扬让整个现场沉浸在欢庆中。%employer%找到了你，向你伸出手，同时推着一箱克朗向你走来。%SPEECH_ON%我真希望我能把你称为这些好人的英雄，但是雇佣兵并不是被看作是最好的。 %SPEECH_OFF%你接过报酬，向前靠近。%SPEECH_ON%我只想要报酬，祝你在这里玩得开心，%employer%。%SPEECH_OFF% | 你发现%employer%正在参加一个葬礼仪式。他们在焚烧着一个装有三具尸体和可能是第四个较小尸体的火葬柴堆。或许是一整个家庭。%employer%说了几句慰问的话，然后点燃了柴堆。一个仆人突然带着一箱克朗出现在你面前。%SPEECH_ON%%employer%不想受打扰。这是你的报酬，雇佣兵。如果你不信任，可以自己数一下是否全部在里面。%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, function ()
						{
							return this.RenderTemplate("你摧毁了一处威胁%s的野蛮人营地", this.Contract.m.Home.getName());
						}());
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
					text = "你获得了 [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] 克朗"
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
			"barbarianname",
			this.m.Flags.get("ChampionName")
		]);
		_vars.push([
			"champbrother",
			this.m.Flags.get("ChampionBrotherName")
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
