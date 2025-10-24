this.roaming_beasts_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		IsPlayerAttacking = true
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.roaming_beasts";
		this.m.Name = "狩猎野兽";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 500 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					function ()
					{
						return this.RenderTemplate("猎杀威胁%s的事物", this.Contract.m.Home.getName());
					}()
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

				if (this.Math.rand(1, 100) <= 5 && this.World.Assets.getBusinessReputation() > 500)
				{
					this.Flags.set("IsHumans", true);
				}
				else
				{
					local village = this.Contract.getHome().get();
					local twists = [];
					local r;
					r = 50;

					if (this.isKindOf(village, "small_lumber_village") || this.isKindOf(village, "medium_lumber_village"))
					{
						r = r + 50;
					}
					else if (this.isKindOf(village, "small_tundra_village") || this.isKindOf(village, "medium_tundra_village"))
					{
						r = r + 50;
					}
					else if (this.isKindOf(village, "small_snow_village") || this.isKindOf(village, "medium_snow_village"))
					{
						r = r + 50;
					}
					else if (this.isKindOf(village, "small_steppe_village") || this.isKindOf(village, "medium_steppe_village"))
					{
						r = r - 25;
					}
					else if (this.isKindOf(village, "small_swamp_village") || this.isKindOf(village, "medium_swamp_village"))
					{
						r = r - 25;
					}

					twists.push({
						F = "IsDirewolves",
						R = r
					});
					r = 50;

					if (this.isKindOf(village, "small_steppe_village") || this.isKindOf(village, "medium_steppe_village"))
					{
						r = r + 50;
					}
					else if (this.isKindOf(village, "small_farming_village") || this.isKindOf(village, "medium_farming_village"))
					{
						r = r + 25;
					}
					else if (this.isKindOf(village, "small_tundra_village") || this.isKindOf(village, "medium_tundra_village"))
					{
						r = r - 25;
					}
					else if (this.isKindOf(village, "small_snow_village") || this.isKindOf(village, "medium_snow_village"))
					{
						r = r - 50;
					}
					else if (this.isKindOf(village, "small_swamp_village") || this.isKindOf(village, "medium_swamp_village"))
					{
						r = r + 25;
					}

					twists.push({
						F = "IsGhouls",
						R = r
					});

					if (this.Const.DLC.Unhold)
					{
						r = 50;

						if (this.isKindOf(village, "small_lumber_village") || this.isKindOf(village, "medium_lumber_village"))
						{
							r = r + 100;
						}
						else if (this.isKindOf(village, "small_tundra_village") || this.isKindOf(village, "medium_tundra_village"))
						{
							r = r - 25;
						}
						else if (this.isKindOf(village, "small_steppe_village") || this.isKindOf(village, "medium_steppe_village"))
						{
							r = r - 25;
						}
						else if (this.isKindOf(village, "small_snow_village") || this.isKindOf(village, "medium_snow_village"))
						{
							r = r - 50;
						}
						else if (this.isKindOf(village, "small_swamp_village") || this.isKindOf(village, "medium_swamp_village"))
						{
							r = r + 25;
						}

						twists.push({
							F = "IsSpiders",
							R = r
						});
					}

					local maxR = 0;

					foreach( t in twists )
					{
						maxR = maxR + t.R;
					}

					local r = this.Math.rand(1, maxR);

					foreach( t in twists )
					{
						if (r <= t.R)
						{
							this.Flags.set(t.F, true);
							  // [346]  OP_JMP            0      5    0    0
						}
						else
						{
							r = r - t.R;
						}
					}
				}

				local playerTile = this.World.State.getPlayer().getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 10);
				local party;

				if (this.Flags.get("IsHumans"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).spawnEntity(tile, "恐狼", false, this.Const.World.Spawn.BanditsDisguisedAsDirewolves, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("一群寻找猎物的凶猛恐狼。");
					party.setFootprintType(this.Const.World.FootprintsType.Direwolves);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Direwolves, 0.75);
				}
				else if (this.Flags.get("IsGhouls"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "食尸鬼", false, this.Const.World.Spawn.Ghouls, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("一群正在觅食的食尸鬼");
					party.setFootprintType(this.Const.World.FootprintsType.Ghouls);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Ghouls, 0.75);
				}
				else if (this.Flags.get("IsSpiders"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "蛛魔", false, this.Const.World.Spawn.Spiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("一群蛛魔正在游荡。");
					party.setFootprintType(this.Const.World.FootprintsType.Spiders);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Spiders, 0.75);
				}
				else
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "恐狼", false, this.Const.World.Spawn.Direwolves, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("一群寻找猎物的凶猛恐狼。");
					party.setFootprintType(this.Const.World.FootprintsType.Direwolves);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Direwolves, 0.75);
				}

				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Home);
				roam.setMinRange(2);
				roam.setMaxRange(8);
				roam.setAllTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
				roam.setTerrain(this.Const.World.TerrainType.Shore, false);
				roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
				c.addOrder(roam);
				this.Contract.m.Home.setLastSpawnTimeToNow();
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onTargetAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					if (this.Flags.get("IsHumans"))
					{
						this.Contract.setScreen("CollectingProof");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsGhouls"))
					{
						this.Contract.setScreen("CollectingGhouls");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsSpiders"))
					{
						this.Contract.setScreen("CollectingSpiders");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("CollectingPelts");
						this.World.Contracts.showActiveContract();
					}

					this.Contract.setState("Return");
				}
				else if (!this.Flags.get("IsWorkOfBeastsShown") && this.World.getTime().IsDaytime && this.Contract.m.Target.isHiddenToPlayer() && this.Math.rand(1, 9000) <= 1)
				{
					this.Flags.set("IsWorkOfBeastsShown", true);
					this.Contract.setScreen("WorkOfBeasts");
					this.World.Contracts.showActiveContract();
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (this.Flags.get("IsHumans") && !this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					local troops = this.Contract.m.Target.getTroops();

					foreach( t in troops )
					{
						t.ID = this.Const.EntityType.BanditRaider;
					}

					this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
					this.Contract.setScreen("Humans");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
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
					if (this.Flags.get("IsHumans"))
					{
						this.Contract.setScreen("Success2");
					}
					else if (this.Flags.get("IsGhouls"))
					{
						this.Contract.setScreen("Success3");
					}
					else if (this.Flags.get("IsSpiders"))
					{
						this.Contract.setScreen("Success4");
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
			Text = "[img]gfx/ui/events/event_43.png[/img]{你正等待%employer%说明他需要你提供何种服务，同时心里琢磨起这个地方为什么如此寂静而怪异。%employer%突然高声说道。%SPEECH_ON%这个地方受到了众神的诅咒，还出没着怪异的野兽！它们夜间来袭，双眼泛着红光，肆意夺人性命。我们大部分牲畜都死了，我怕一旦牲畜没了，接下来被撕碎的就是我们。前些天我们派了最壮实的小伙子们去捕杀那些野兽，但至今杳无音信。%SPEECH_OFF%他深深地叹了口气。%SPEECH_ON%沿着%direction%方向的踪迹追踪，找到并杀死那些怪物，这样我们才能重获安宁！我们并不富裕，但大家凑了钱来支付你的报酬。%SPEECH_OFF% | 你找到%employer%时，他正望着窗外。他手里拿着一个酒杯——而外面除了一片死寂，什么也没有。他转向你，神情几乎可以说是沉痛。%SPEECH_ON%你来这里时，注意到有多安静了吗？%SPEECH_OFF%你回答说注意到了，但你是个看起来就不好惹的佣兵，早已习惯这种场面。%employer%点点头，喝了一口。%SPEECH_ON%啊，当然。不幸的是，这次并不是因为人们怕你。过去几周一直有人遭到袭击。某种野兽在四处游荡，我们不知道它们是什么，只知道它们抓走了谁。我们当然向领主求助过，但他什么都没做……%SPEECH_OFF%他又喝了一口，这次喝了很久。喝完时，他转向你，手里拿着空杯子。%SPEECH_ON%你愿意去猎杀这些怪物吗？求你了，佣兵，帮帮我们。%SPEECH_OFF% | 你找到%employer%时，他正在听几个农民说话。他们一看到你，就迅速离开了，留下他手里拿着一个袋子。他举起它来。%SPEECH_ON%这里面是克朗。是那些人给我，让我交给某个能帮助我们的人，任何人都行。不断有人失踪，佣兵，而且当找到他们时……他们不只是死了，而是……支离破碎。所有人都吓得不敢出门。%SPEECH_OFF%他盯着袋子，然后看向你。%SPEECH_ON%我真心希望你对这个任务感兴趣。%SPEECH_OFF% | 你看到%employer%正在读一卷卷轴。他把纸扔给你，让你念出上面的名字。笔迹难以辨认，但名字本身就不好辨别。你停下来道歉，说自己不是本地人。那人点点头，拿回卷轴。%SPEECH_ON%没关系，佣兵。如果你想知道，那是过去一周里死去的男女老少的名字。%SPEECH_OFF%上周？那名单上的名字可不少。那人似乎看出了你的想法，沉重地点了点头。%SPEECH_ON%是啊，我们处境很糟。死了这么多人。我们相信这是邪恶生物的所作所为，是超出我们理解能力的野兽。很明显，我们希望你去找到并消灭它们。你对这样的任务感兴趣吗，雇佣兵？%SPEECH_OFF% | %employer%脚边躺着几条狗，全都累坏了，舌头耷拉着。%SPEECH_ON%它们过去几天一直在搜寻失踪的人。那些人就这么消失了，天知道去了哪里。%SPEECH_OFF%他弯下腰，抚摸着其中一条猎犬，搔着它的耳后。通常狗会对这个有反应，但这可怜的家伙几乎毫无反应。%SPEECH_ON%不过，乡亲们不知道我所知道的事——那就是人们并非只是失踪……他们是被抓走的。可怕的野兽正在肆虐，佣兵，我需要你去追捕它们。见鬼，说不定你还能找到一两个镇民，虽然我对此不抱希望。%SPEECH_OFF%仿佛接到信号一般，其中一条杂种狗发出一声长长的、疲惫的喘息。 | %employer%拿着一个袋子，上面系着一卷纸，但纸上写的名字不是你的。他仔细掂量着挎包，指间感受着钱币的块状轮廓，叮当声显得沉闷。他转向你。%SPEECH_ON%你认得那个名字吗？%SPEECH_OFF%你摇摇头。那人继续说道。%SPEECH_ON%一周前，我们派了著名的%randomnoble%前往此地%direction%方向，去猎杀几周来一直肆虐本镇及周边农庄的邪恶野兽。你知道为什么这个钱袋还在我手里吗？%SPEECH_OFF%你耸耸肩答道。%SPEECH_ON%因为他没回来？%SPEECH_OFF%%employer%点点头，放下袋子。他坐在桌子边缘。%SPEECH_ON%没错。因为他没有回来。那么，你认为这是为什么呢？我觉得是因为他死了，但我们别这么悲观。我认为是因为外面的野兽需要更厉害的角色。我认为它们需要像你这样的人，佣兵。既然这位贵族失败了，你愿意帮助我们吗？%SPEECH_OFF% | %employer%从书架上取下一本书。当他把书放在桌上时，灰尘甚至可能是灰烬飞扬起来。他打开书，一页一页地慢慢翻阅。%SPEECH_ON%你相信有怪物吗，佣兵？我真心请教，因为我相信你在这个世界上的见闻比我广。%SPEECH_OFF%你点点头说道。%SPEECH_ON%不止是相信，我知道有。%SPEECH_OFF%那人又翻过一页。他抬头看着你。%SPEECH_ON%好吧，我们相信怪物已经来到了%townname%。我们相信这就是人们不断失踪的原因。明白这意味着什么吗？我需要你去找到这些传言中的生物，然后像对付普通畜生一样杀了它们。你感兴趣吗？%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{对你来说值多少？ | %townname%愿意付多少？ | 谈谈报酬吧。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{这听起来不像是适合我们的工作。 | 祝你好运，但我们不会掺和此事。}",
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
			ID = "Humans",
			Title = "在攻击前……",
			Text = "[img]gfx/ui/events/event_07.png[/img]{这根本不是什么野兽，而是披着狼皮的人！ 看到了怪物的“真”面目，弟兄们反而松了口气——毕竟眼前的敌人他们再熟悉不过了。 | 当你逼近这些怪物时，才发现这些丑陋的生物根本不是野兽，而是伪装起来的人类！你不清楚他们为何要玩这种变装把戏，但他们已经亮出了兵器。对你而言，是兽是人，终归一死。 | 你撞见一个人正把狼头从肩膀上摘下来。他瞥了你一眼，手里的伪装还没放下，又慌忙戴了回去。你拔剑出鞘。%SPEECH_ON%现在再装神弄鬼，未免太迟了吧。%SPEECH_OFF%剑光一闪，你挑飞了他的面具，他踉跄后退。不等你补上一剑，他转身就逃，奔向一群同样鬼鬼祟祟的同伙。那些人一见到你，立刻亮出武器。不管这群蠢货为何扮成这副德行，现在都不重要了。 | 你发现一具野兽尸体，背上插着几支箭。这看起来并不致命……当你用剑尖挑开这生物的鬃毛时，它的脑袋竟滚落下来，露出了底下的人头。%SPEECH_ON%是你干的？%SPEECH_OFF%前方突然传来人声。那儿站着几个人，正卸去伪装——正是你们追踪的野兽。 领头的人抬高音量。%SPEECH_ON%杀了他们！杀光他们！%SPEECH_OFF%得了，的确是野兽——披着兽皮的禽兽。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "准备进攻！",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "WorkOfBeasts",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_60.png[/img]{你在草丛中偶然发现一具尸体。通常来说，死尸并不那么令人惊讶，到处都有人，所以时不时看到一具尸体只是时间问题。但这具尸体的后背有巨大的撕裂伤口，而且器官都不见了。\n\n%helpfulbrother%走了过来。%SPEECH_ON%器官没了可能是狼吃了，甚至是兔子吃了。 怎么，你没听说过饿极了的兔子吗？%SPEECH_OFF%他吐了口唾沫，啃着指甲。%SPEECH_ON%不过，这些伤口，绝不是兔子或猎狗之类的东西弄的。是某种……更大的……更危险的东西。%SPEECH_OFF%你感谢这人敏锐的观察力，并让他归队。 | 一个农民向你走来，身上的衣服破成了碎布条。他还算体面地用双手遮住了下体。%SPEECH_ON%求求你们，先生们，来看看这个……恐怖的东西。%SPEECH_OFF%当你问他指的是什么时，他猛地举起双手，朝你挺了下胯。他像被旋转的木偶一样转过身，大叫大嚷地跑开了。在那人发疯之后，一个女人走向你。她双手按在胸前。%SPEECH_ON%他疯了，因为他的兄弟被野兽撕碎了。%SPEECH_OFF%你转向她，有点期待这女人也会扯掉衣服，随心所欲地摇晃她的身体。然而，她只是凝视着你。%SPEECH_ON%我知道%townname%雇了些人来对付这些野兽，而你看起来确实像个受雇的好手。求你了，先生，保护我们免受这些邪祟的侵害……以及它们所散播的邪祟……%SPEECH_OFF% | 你遇到一头被开膛破肚的牛，一半身子被甩在篱笆顶上，另一半则散落在远处的草地上，距离远到其内脏所能延伸的极限。\n\n一个农夫走过来，把帽子从眼前向上推了推。%SPEECH_ON%是野兽干的。我没看见它们，但我确实在你们来之前听到了这场该死的混乱。光是听到就够我知道该躲起来了。拜托，如果你们是来寻找那些怪物的，那就快点行动，因为我可承受不起再损失一头牲畜了。%SPEECH_OFF% | 一个正在劈柴的农民在你面前直起身来。%SPEECH_ON%诸神在上，见到你们真好，先生们。我之前听说有些佣兵在四处奔走，寻找骚扰这一带的野兽。%SPEECH_OFF%你问他是否看到过什么可能有助于搜寻的线索。他把手搭在斧柄上。%SPEECH_ON%不能说有。 但我听到些传闻。我知道离这不远的一对男女被抓走了。嗯，他们是一起失踪的。有消息说他们现在死在树林里了。像藤壶一样挂在树上，内脏松散地垂着，懂吗？或者，等等，也许他们只是自己跑掉同居去了！妈的……妈的！那姑娘恨她父亲，而那小子就是个空有俊俏脸蛋和油嘴滑舌的混混。对，这说得通。%SPEECH_OFF%他停顿了一下，然后瞥了你一眼。%SPEECH_ON%总之，我确定有怪物在附近。留神点，佣兵。%SPEECH_OFF% | 一个女人从她的小屋里跑出来拦住你。她几乎上气不接下气，问你有没有看到一个男孩。你摇头表示没有。她伸出手比划着。%SPEECH_ON%他大概这么高。一头棕色的乱发。不是天生的，但那小子就喜欢玩泥巴。他笑的时候牙齿像星星，又亮又散。%SPEECH_OFF%你再次摇头表示没有。%SPEECH_ON%他扔石头扔得可好了。扔得老远。我告诉过他，领主的手下在附近时不要显露力气，免得他们把他抓去当兵。%SPEECH_OFF%她呼了口气，把一缕散乱的头发吹出眼睛。%SPEECH_ON%唉，算了，总之，如果你看到他，告诉我一声。大概率就是我儿子。还有，小心黑暗。有野兽在这附近阴人。%SPEECH_OFF%没等你说什么，这女人提起她的长裙，蹒跚地回她的小屋去了。 | 你遇到一个男人跪在一只彻底死透的狗旁边。你在他身旁单膝跪下。%SPEECH_ON%是野兽干的吗？%SPEECH_OFF%他摇头否认。%SPEECH_ON%见鬼，是我干的。总算解决了。这该死的玩意儿再也不会吵得我睡不着了。%SPEECH_OFF%就在这时，对面一间小屋的门开了，一个男人尖叫着冲了出来。%SPEECH_ON%那是我的狗吗，你这狗娘养的？%SPEECH_OFF%杀狗者迅速站起来。%SPEECH_ON%是野兽！它们昨晚又来过了！%SPEECH_OFF%你悄悄地离开了这场发生在死狗旁的争执。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们继续前进。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CollectingPelts",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_56.png[/img]{野兽已被斩杀，你下令让队员们剥取毛皮作为证据。你的雇主%employer%看到这些应该会非常满意。 | 解决了这些丑恶的生物，你开始动手剥取它们的毛皮和头皮。要证明对付了如此骇人的生物，自然需要留下些骇人的证据。否则你的雇主%employer%或许不会相信你在此处的成果。 | 战斗结束后，你让队员们收集毛皮，准备带回给你的雇主%employer%。 | 若没有证据，你的雇主%employer%恐怕不会相信此地发生的一切。你命令队员们开始收集毛皮、战利品、头皮——任何能彰显你们在此胜利的物证。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "赶快完事吧，还有赏金等着我们呢。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CollectingProof",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_22.png[/img]{你的手下带走了这些蠢货的伪装，以免你们的雇主%employer%不相信此事。 | 你们的雇主可能不会相信这里发生的事。你命令手下收集这些伪装。%bro1%一边从死者脸上扯下面具，一边思索。%SPEECH_ON%所以他们把自己打扮成能吸引我们注意力的模样，现在却都送了命。希望他们没把这当成儿戏。%SPEECH_OFF%%bro2%在伪装服的褶皱间擦拭刀刃。%SPEECH_ON%如果真是场游戏，我玩得还挺尽兴。%SPEECH_OFF% | %randombrother%对着尸体点头。%SPEECH_ON%雇主%employer%很可能不会相信有土匪扮成野兽这回事。%SPEECH_OFF%你表示同意，随即命令手下开始收集面具和伪装作为证据。 | 你需要向雇主%employer%出示证据。这些虽不是你们要找的野兽，但雇主肯定有兴趣过目他们的伪装。有个手下把自己的疑问说了出来。%SPEECH_ON%他们打扮成这样到底图什么？%SPEECH_OFF%%bro2%不断扯下伪装服叠在臂弯。%SPEECH_ON%仪式性自杀？毕竟他们的舞蹈和玩乐引起了我们注意。%SPEECH_OFF%他拎起一件伪装服时，连带着拽起了死者的头颅。这名佣兵大笑着把脑袋踢开。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "回去%townname%！",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CollectingGhouls",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_131.png[/img]{战斗结束后，你走到一具食尸鬼的尸体前单膝跪下。若不是那口参差不齐的獠牙碍事，你大可以把整个脑袋塞进它那张血盆大口。你无暇欣赏这口烂牙，掏出匕首锯断它的脖颈——外皮坚韧得出奇，但令人意外的是，内里的筋肉却轻易便被割开。你高举首级，下令%companyname%的弟兄们如法炮制。毕竟，%employer%总要见到凭证才肯认账。 | 死去的食尸鬼瘫在地上一动不动，看上去更像顽石而非野兽。蝇群已在它口中交配，在死亡泛起的白沫间播种生命。 你命令%randombrother%砍下它的头颅，毕竟%employer%肯定要看到证明才会付钱。 | 四处散落着食尸鬼的尸骸。你在其中一具旁蹲下，注视着它仍在微微开合的嘴——肺腔里的浊气随着嘶哑的嗝逆声不断溢出。你用布捂住口鼻，操起利刃剁向它的脖颈，随即拎起首级示意弟兄们照做。%employer%肯定想见到些凭证。 | 死去的食尸鬼堪称值得玩味的标本。你不禁思索它在自然界究竟处于何种位置：形如粗陋人形，肌肉虬结似猛兽，扭曲的头颅仿佛源自野人噩梦中的造物。你下令让%companyname%收集这些秽物的首级带回%employer%作为凭证。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "回去%townname%！",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CollectingSpiders",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_123.png[/img]{你命令弟兄们清扫战场，尽可能多地收集蜘蛛的残骸。有几个人不慎碰到蛛魔腿上的刚毛，很快就发起皮疹挠了起来。 | 蜘蛛的尸体散布战场，如同阁楼角落常见的景象。死去后，它们看起来就像僵硬合拢的巨型手套。你让伙计们用力掰开这些腿肢，采集这些野兽残骸作为证据。 | 佣兵们打扫着战场，对着蛛魔僵硬的遗体又劈又锯，准备将战利品带回给%employer%。即便已然死亡，这些织网骑士依然狰狞可怖，仿佛随时都会猛地复活，缠住最近的活物。它们骇人的外形和超现实的尺寸并没能阻止某些佣兵围着跳舞——他们弹舌发出嘶嘶声，尽情吓唬着那些不敢靠近这些鬼东西的同伴。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "回去%townname%！",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{你回到%employer%处，将一张兽皮平铺在他的桌案上。松垂的爪子轻轻叩击着橡木桌沿。他拎起一只爪子看了看，又任其落下。%SPEECH_ON%看来你找到了我们一直在搜寻的野兽。%SPEECH_OFF%你向他讲述了战斗经过。他显得十分满意，从书架上取来一个小木箱递给你。%SPEECH_ON%按约定，这是%reward_completion%克朗。%townname%的民众理应从这等恐怖中获得喘息，而你给了他们这份安宁。%SPEECH_OFF% | 当你踏入%employer%的房间时，他几乎立刻后退了一步。%SPEECH_ON%佣兵，你手里拿的究竟是什么鬼东西？%SPEECH_OFF%你拎起兽皮的后颈。黑色的血液从颈部成股滴落，溅在地板上。%SPEECH_ON%你要找的其中一头野兽。如果你还需要其他证据，外面还有……%SPEECH_OFF%那人抬手制止了你。%SPEECH_ON%一件就足够让我信服了。干得非常出色，佣兵。你的酬劳%reward_completion%克朗在%randomname%议员那里，你进来的时候可能经过他了，就长得很丑的那位。%SPEECH_OFF%他又瞥了一眼那野兽，缓缓摇头。%SPEECH_ON%愿逝者和生者都能因这些邪恶生物的消亡而得到安息。%SPEECH_OFF% | %employer%举着酒杯欢迎你的归来。%SPEECH_ON%喝一杯吧，野兽杀手。%SPEECH_OFF%你很好奇他怎么提前知道你的成功。他对你的好奇不以为意。%SPEECH_ON%我在这片土地上耳目众多——当然不是指密探，只是平民百姓们总爱传话。我自然清楚，我自己就是其中之一！这次你干得很棒，佣兵，所以喝一口吧。这可是上等好酒。%SPEECH_OFF%酒确实不错。不过，你带走的%reward_completion%克朗要美妙得多。%employer%叫住你。%SPEECH_ON%只想让你知道，佣兵，那些野兽杀害了许多好人。这里的人们或许会惧怕你，毕竟你是佣兵，但他们同样对你永远感激。%SPEECH_OFF%你掂了掂钱袋。是啊，相当感激…… | %employer%后退了几步。%SPEECH_ON%啊，呃，看来你确实宰了那些野兽。你带来的这张皮相当不错。%SPEECH_OFF%你扔下带来的东西：一团厚实沉重的兽皮瘫落成皮毛与血肉的混合物。那人几乎不敢靠近，直接扔给你一个钱袋。%SPEECH_ON%按约定，%reward_completion%克朗。我会去告知民众你的成功。我们终于可以安生了。%SPEECH_OFF% | %employer%正坐在桌边，双腿翘在桌角上。他凝视着天花板，脸庞的皱纹因忧虑而愈发深刻。他看向你。%SPEECH_ON%欢迎回来。我一直听闻你的行动……你与那些怪物的战斗。%SPEECH_OFF%你点点头，环顾四周寻找报酬。他示意你出门。%SPEECH_ON%报酬在%townname%议员%randomname%手里。按约定是%reward_completion%克朗。而且%townname%的民众，尽管他们可能惧怕你，但还是因你的到来而蒙受恩惠。谢谢你，佣兵。%SPEECH_OFF% | 你回来时，%employer%正在喂他的狗。那杂种狗丢下骨头，凑过来嗅你带来的东西。那人指着兽皮。%SPEECH_ON%这算哪门子恶心玩意儿？%SPEECH_OFF%你耸耸肩，把它扔到他的桌上。狗用鼻子碰了碰一只爪子，低吼一声，然后开始舔舐起来。%employer%短暂地笑了笑，随即走向书架，拿起一个木箱递给你。%SPEECH_ON%是%reward_completion%克朗对吧？你该知道，你为%townname%的民众带来了平静。%SPEECH_OFF%你点点头。%SPEECH_ON%他们的开心也能换算成克朗给我吗？%SPEECH_OFF%%employer%对你贪婪的幽默皱起眉头。%SPEECH_ON%不能。祝你今日愉快，佣兵。%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "清除城镇附近的恐狼");
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
		this.m.Screens.push({
			ID = "Success2",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer%对你的归来表示欢迎。%SPEECH_ON%我已经听说了这个，我想算是好消息吧。不过我倒不意外。一群土匪玩扮装游戏，算是披着狼皮的……狼？%SPEECH_OFF%他朝你咧嘴一笑，期待你能被他这个蹩脚的笑话逗乐。你耸耸肩。他也跟着耸肩。%SPEECH_ON%啊，好吧。你的报酬%reward_completion%克朗正在外面等你。我会告诉%townname%的居民，他们害怕的怪物其实只是人类。%SPEECH_OFF% | 你带着那群蠢土匪的装扮回来了。%employer%左右翻看着这些伪装。%SPEECH_ON%有意思。做工相当精致。我差点要说这些土匪挺有想法。%SPEECH_OFF%他拿起一个面具似乎想试戴，却突然停下，仿佛意识到不该当着外人这么做。他把面具放回去，朝你微笑。%SPEECH_ON%总之，佣兵……干得好。%reward_completion%克朗的报酬就在外面，由%townname%的一位议员保管。他在等着你。现在%townname%的居民终于能安葬死者，重归平静了。%SPEECH_OFF% | 听闻你的揭晓，%employer%笑得前仰后合。%SPEECH_ON%人？竟然只是人？%SPEECH_OFF%你点头承认，同时试图把话题拉回正轨。%SPEECH_ON%他们杀了很多农民，而且依然是一群危险的家伙。%SPEECH_OFF%雇主点了点头。%SPEECH_ON%当然，当然！我无意轻视任何事或任何人。别擅自揣测我，佣兵，死去的都是我的乡亲邻舍！总之，你完成了我委托的事，我对此非常感激。%SPEECH_OFF%他递过来一袋克朗。你清点袋中的%reward_completion%克朗后便准备离开。那人在你身后喊道。%SPEECH_ON%你肯定明白在这糟糕的世道里找点乐子的心情，对吧？因为是我去参加了所有遇害者的葬礼。不管这该死的地方怎么逼我，我绝不要皱着眉头进坟墓。%SPEECH_OFF% | 你向%employer%展示了那群狡猾土匪的证据。他翻检着那堆伪装道具，搓掉手指上凝固的血痂。%SPEECH_ON%这确实是人血。你确定他们不是在玩扮装游戏，而真正的怪物还在外面游荡？%SPEECH_OFF%你抿紧嘴唇，解释说他们拿着攻击你们的武器可一点都不像玩具。%employer%点点头，看似理解了，但仍带一丝怀疑。%SPEECH_ON%好吧，我想我可以等着看怪物是否会再次出现。如果它们真的来了，呵，一个遭背叛的人本身就能变成相当可怕的怪物，你同意吗？%SPEECH_OFF%你只让他付钱，并说不妨等着看他这般多疑是否会应验。他点点头，给了你%reward_completion%克朗并送你离开。%SPEECH_ON%我真心希望你说的是实话，佣兵。%townname%太需要在这见鬼的世道中缓一口气了。%SPEECH_OFF% | %employer%用手指抚过一件伪装道具的边缘。%SPEECH_ON%这皮毛触感柔软。非常逼真……%SPEECH_OFF%他抬头看向你。%SPEECH_ON%我不得不猜想，是不是他们杀了原本的怪物，然后……决定披上它们的毛皮？可为什么呢？你觉得他们是被诅咒了吗？%SPEECH_OFF%你耸耸肩答道。%SPEECH_ON%我只能说，他们拥有怪物的外表，也具备怪物的残忍。他们袭击了我们，并为此付出了代价。最近有本地人目击到什么怪物吗？%SPEECH_OFF%那人取出一袋%reward_completion%克朗推给你。%SPEECH_ON%不，没有。事实上，他们又开始外出活动了。我指的不是远行，但对很多人来说，敢迈出自家安全的门槛已经是巨大的一步！你确实为我们带来了安宁，佣兵，我们为此十分感谢。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "不管是野兽还是匪徒……给钱就是了。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "清除城镇附近伪装成恐狼的强盗");
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
		this.m.Screens.push({
			ID = "Success3",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{你找到%employer%时他正在解手。他站起身提好裤子，一名仆人迅速从他刚才坐的地方取走一个桶。那可怜的仆人匆匆离开了房间。%employer%指着你手里晃荡的食尸鬼头颅。%SPEECH_ON%真是恶心透顶。%randomname%，给这人结账。是%reward%克朗对吧？%SPEECH_OFF% | 你将食尸鬼头颅放在%employer%的桌案上。不知为何，黏液仍从它脖颈处渗出，顺着橡木桌边流淌，无疑会留下污渍。这人向后靠去，十指交叉搭在肚子上。%SPEECH_ON%食尸鬼？接下来是不是该说还有幽灵了？%SPEECH_OFF%他自顾自地轻笑。%SPEECH_ON%对你们佣兵来说，果然没什么事算难办。%SPEECH_OFF%他打了个响指，一名仆人上前递给你一袋%reward%克朗。 | 从结束战斗到走回%employer%住所的这段路上，食尸鬼大张的嘴里已聚满苍蝇，它的舌头被一团无定形、搏动着的、嗡嗡作响的黑色球体取代。%employer%瞥了一眼就掏出手帕捂住嘴。%SPEECH_ON%行了，我知道了，快拿走，拜托。%SPEECH_OFF%他招手唤来一名守卫，你领到了一袋%reward%克朗。 | 目光冷峻的%employer%俯身仔细打量你带来的食尸鬼头颅。%SPEECH_ON%真是壮观啊，佣兵。很高兴你把它带给了我。%SPEECH_OFF%他向后靠去。%SPEECH_ON%就放我桌上吧。说不定能拿来吓唬孩子们。要我说，这些小兔崽子最近对精致生活太过习以为常了。%SPEECH_OFF%他打了个响指，一名仆人上前付给你%reward%克朗。 | 你将食尸鬼头颅带给%employer%，他盯着它看了很久。%SPEECH_ON%这让我想起某个人。说不太清楚具体是谁，而且恐怕也不该深究。抱歉了佣兵，占用你时间还没付酬劳。仆人，给这人结账！%SPEECH_OFF%你如约获得了报酬。 | %employer%接过食尸鬼头颅举高。几只呜呜叫的猫不知从何处冒出来，像秃鹫般在下方绕圈。他把头颅扔出窗外，猫群立刻追着跑走了。%SPEECH_ON%干得好，佣兵。按约定给你%reward%克朗。%SPEECH_OFF% | 你将食尸鬼头颅放在%employer%的餐桌上。他从餐盘前抬起头，瞥了眼头颅，又看向你。%SPEECH_ON%我在吃饭呢，佣兵。%SPEECH_OFF%被恶心到的他推开餐盘，撞得银器叮当作响。 仆人迅速收走食物，大概是想自己吃掉。%employer%取出一个钱袋放在桌上。%SPEECH_ON%说好的%reward_completion%克朗。%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "清除城镇附近的食尸鬼");
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
		this.m.Screens.push({
			ID = "Success4",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{你背着死蜘蛛走进了%employer%的办公室。那人尖叫起来，椅子随着他向后猛退而吱嘎作响。他跳起身，从桌上抓起一把黄油刀。你将死去的蛛魔从肩上甩下，它仰面摔在地上发出闷响。这位镇民慢慢凑上前，把黄油刀插回一条面包里，摇了摇头。%SPEECH_ON%旧神在上，你差点把我吓出心脏病。%SPEECH_OFF%你点点头，告诉他解决这些畜生可不是一只大靴子就能搞定的。他也点头回应。%SPEECH_ON%当然，佣兵，当然！你的报酬，%reward_completion%克朗，就在那个角落里。还有，求你离开的时候把这鬼东西一起带走。%SPEECH_OFF% | 你刚踏进%employer%的房间，猫儿们就发出嘶嘶声逃开了。几只狗——这些畜生总喜欢探究不明事物——在你腿边跑来跑去，嗅着蜘蛛尸体，它们的鼻子皱起、缩回，但又总是忍不住再凑上来闻。这位镇民正在写笔记，他几乎不敢相信自己的眼睛。他放下了羽毛笔。%SPEECH_ON%那是只巨型蜘蛛吗？%SPEECH_OFF%你点点头。他笑了，重新拿起了羽毛笔。%SPEECH_ON%也许我当初该建议你带只非常大的靴子去。你的报酬，%reward_completion%克朗，就在那个钱袋里。去吧，拿走它。钱都在里面。尸体你可以留下。我想好好观察一下这生物。%SPEECH_OFF% | %employer%正在举办一场生日派对，你扛着一只巨型死蜘蛛走进房间，并把尸体扔在地上。蜘蛛刚毛擦过石头发出嘶嘶声，八条腿倒立着快速划动，如同某种恐怖家具，它滑向一边，撞到书架一角弹起，翻转过来用脚尖支地，仿佛随时准备扑击。现场顿时一片混乱，所有人尖叫着跑出门，或者从最近的窗户跳出去，五彩纸屑在他们身后嬉戏般地旋转飘落。雇主独自站在空荡荡的场地中，抿紧了嘴唇。%SPEECH_ON%说真的，佣兵，有必要这样吗？%SPEECH_OFF%你点点头，告诉他雇佣你是必要的，付你钱同样也非常必要。那人摇摇头，用一根假驴尾巴示意房间的角落。%SPEECH_ON%钱袋在那边，里面有约定好的%reward_completion%克朗。现在把这吓人玩意弄出去，顺便告诉外面的人生日宴会还没结束。%SPEECH_OFF% | 你觉得没法把蜘蛛尸体搬进%employer%的房间，于是你改从外面把它啪地一声拍在他的窗户上。你听到一声惊恐的尖叫和家具倒地的声响。片刻之后，旁边的窗户被猛地推开。镇民探出身来。%SPEECH_ON%哦，干得漂亮，佣兵，真他妈漂亮！愿旧神罚你闲坐一千年！%SPEECH_OFF%你点点头，询问你的报酬。他不情愿地扔给你一个钱袋。%SPEECH_ON%%reward_completion%克朗在里面。现在拿着那鬼东西滚吧！%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "清除城镇附近的蛛魔");
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
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_helpful = [];
		local candidates_bro1 = [];
		local candidates_bro2 = [];
		local helpful;
		local bro1;
		local bro2;

		foreach( bro in brothers )
		{
			if (bro.getBackground().isLowborn() && !bro.getBackground().isOffendedByViolence() && !bro.getSkills().hasSkill("trait.bright") && bro.getBackground().getID() != "background.hunter")
			{
				candidates_helpful.push(bro);
			}

			if (!bro.getSkills().hasSkill("trait.player"))
			{
				candidates_bro1.push(bro);

				if (!bro.getBackground().isOffendedByViolence() && bro.getBackground().isCombatBackground())
				{
					candidates_bro2.push(bro);
				}
			}
		}

		if (candidates_helpful.len() != 0)
		{
			helpful = candidates_helpful[this.Math.rand(0, candidates_helpful.len() - 1)];
		}
		else
		{
			helpful = brothers[this.Math.rand(0, brothers.len() - 1)];
		}

		if (candidates_bro1.len() != 0)
		{
			bro1 = candidates_bro1[this.Math.rand(0, candidates_bro1.len() - 1)];
		}
		else
		{
			bro1 = brothers[this.Math.rand(0, brothers.len() - 1)];
		}

		if (candidates_bro2.len() > 1)
		{
			do
			{
				bro2 = candidates_bro2[this.Math.rand(0, candidates_bro2.len() - 1)];
			}
			while (bro2.getID() == bro1.getID());
		}
		else if (brothers.len() > 1)
		{
			do
			{
				bro2 = brothers[this.Math.rand(0, brothers.len() - 1)];
			}
			while (bro2.getID() == bro1.getID());
		}
		else
		{
			bro2 = bro1;
		}

		_vars.push([
			"helpfulbrother",
			helpful.getName()
		]);
		_vars.push([
			"bro1",
			bro1.getName()
		]);
		_vars.push([
			"bro2",
			bro2.getName()
		]);
		_vars.push([
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Target.getTile())]
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/disappearing_villagers_situation"));
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

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});
