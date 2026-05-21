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
		this.m.Name = "驱逐野蛮人";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
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
					"驱逐" + this.Flags.get("DestinationName") + "%origin%%direction%边的野蛮人"
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

				if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.Barbarians, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setLootScaleBasedOnResources(110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
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
					if (this.World.Assets.getBusinessReputation() >= 500 && this.Contract.getDifficultyMult() >= 1.0)
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer%叹着气将一张纸片推到你面前。那是份罪行清单。你看到上面罗列相当多的不法行为。他说道。%SPEECH_ON%要是那只是普通罪犯所为，我大可以找个巡警或是赏金猎人来处理。但我找了你，佣兵，因为这是野蛮人干的勾当。他们犯下的所有罪行——这清单上罗列的所有罪行——我都要他们血债血偿。他们的村落就在这里的%direction%边。我需要你去拜访他们，并让他们明白，尽管我们生活在有炉火的文明世界里，但野性的火花仍未熄灭，而野蛮行径必将得到野蛮的报应。明白吗？%SPEECH_OFF%你现在注意到那罪行清单上溅满断裂的羽毛尖，仿佛记录者随着罗列罪状愈发怒不可遏。 | 一群本地骑士与%employer%同处一室。他们漠然打量着你，活像在看一只推门溜进来的野狗。%employer%从座椅下抽出一卷轴抛给你。%SPEECH_ON%我去查探被夷为平地的农庄时，野蛮人给我留了这个。%SPEECH_OFF%纸上画着符文般的图案和看似绞刑的场景。%employer%点头。%SPEECH_ON%他们屠杀了农户——至少男人们全死了。天知道女人们遭遇了什么。从这往%direction%走，佣兵，找到罪魁祸首的野蛮人。将他们彻底铲除，你会获得丰厚报酬。%SPEECH_OFF% | 你进屋时%employer%显得烦躁不堪。他说%townname%曾与北方野蛮人交好。%SPEECH_ON%但看来自以为能和那些野人平等相处是我自欺欺人。%SPEECH_OFF%他指控对方持续袭击商队、杀害旅人、劫掠农庄。%SPEECH_ON%那我就以牙还牙。往%direction%走，把他们的村落屠戮殆尽。有兴趣接这活吗？%SPEECH_OFF% | %employer%在你进屋时大笑。%SPEECH_ON%不是取笑你，佣兵，只是感叹这残酷的组合——雇佣佣兵来迅速彻底抹除野蛮人。你看，就在这%direction%边有支披着熊皮的混蛋部落一直在剥头皮、砍杀商队和旅行者。我忍无可忍。有一部分原因是因为他们罪有应得，但主要还是因为我有钱雇你这种粗人去解决这个问题。%SPEECH_OFF%他又自顾自笑起来。你感觉这人从没拿剑刺过任何活物。%SPEECH_ON%怎么说，佣兵，有兴趣宰几个野人吗？%SPEECH_OFF% | 你走进%employer%房间时，他正盯着一只狗头。脖颈断口持续渗出的液体正沿桌沿滴落。他轻抚着一只狗耳。%SPEECH_ON%究竟是多恨一个人才会杀他的狗，砍下头，还他妈寄给他？%SPEECH_OFF%你猜想是结下死仇的人所为，但默不作声。%employer%向仆从点头示意，狗头被收走。他此刻望向你。%SPEECH_ON%这事是%direction%边的野人干的。起初他们袭击商队和农户，像野蛮人那样奸淫掳掠。我派人回击，杀了他们几个人，这就是我得到的回应。够了，这群畜生。我要你去他们村落，把他们彻底灭绝。%SPEECH_OFF%你差点想问是否连他们的狗也要赶尽杀绝。 | 你见到%employer%时，他椅旁蜷着个浑身污浊的女人。头发板结，皮肉布满各种虐痕。她朝你狞笑仿佛全是你的过错。%employer%把她踢翻。%SPEECH_ON%别在意这贱人，佣兵。我们抓到她和她同伙抢劫粮仓。其他野人都宰了，留她本想着取乐，但揍她跟揍条狗一样无趣。这身男人气太煞风景了。%SPEECH_OFF%他又踹一脚，女人龇牙低吼。%SPEECH_ON%瞧见没？但我有好消息！我们找到她老巢了，我打算把那地方烧成白地。这就是你的任务。野蛮人村庄就在这里的%direction%面。去踏平它，报酬丰厚。%SPEECH_OFF%女人听不懂对话，但涣散眼神似乎表明她逐渐明白为何你这种人会进门。%employer%咧嘴笑。%SPEECH_ON%有兴趣接活吗？还是我得找个更狠的角色？ | %employer%房间里挤满农民。以他的身份本不该让这么多人近身，但奇怪的是他们好像也不是在私刑他。见到你后，%employer%召你上前。%SPEECH_ON%啊，终于！救星来了！佣兵，此处%direction%的野蛮人一直在洗劫村庄，强奸所有带洞的活物。我们受够了！坦白说我和大伙一样不想让肮脏的野蛮屌靠近屁眼。%SPEECH_OFF%人群发出嘲弄的喧哗，有人哭喊野蛮人{砍了他母亲的脑袋 | 还杀了他养的羊 | 偷走了他所有的狗，天杀的 | 生吞了他儿子的肝脏}。%employer%点了点头。%SPEECH_ON%对、对，诸位，对！所以我说，佣兵，请你规划前往野蛮村落的路线，并给予他们适度、适当、文明的制裁。%SPEECH_OFF% | %employer%招手让你进屋。他握着根火钳，钳尖晃荡着一张头皮。%SPEECH_ON%北方野人今天送来的。粘在信使身上——他的眼睛和舌头都被挖掉了这就是他们的本性，这些野人，用无声的方式跟我对话。所以我预感要借用你的帮助回信了，佣兵。去%direction%边找到他们的村庄，将其夷为平地。%SPEECH_OFF%头皮从火钳脱落，啪嗒一声湿响砸在石地上。 | %employer%不情愿地迎你进门，正如被世道逼得不得不求助佣兵的人那般。他言简意赅。%SPEECH_ON%野蛮人在%direction%边有个村落，正不断派出劫掠队。他们强奸，他们掠夺，他们就是一般人虫害兽。我要他们彻底消失，一个不留。你愿意接这任务吗？ | %employer%膝头卧着只猫，待你走近才看清只剩下脑袋，他正用拇指拨弄着断尾。他抿紧嘴唇。%SPEECH_ON%野蛮人干的。他们还强奸洗劫了周边不少农庄，把一对双胞胎婴儿吊在树上，但这个……%SPEECH_OFF%他摊开手掌，猫头滚落石地发出沉闷的撞击声。%SPEECH_ON%忍无可忍。我要你往%direction%边找到那些野蛮人所谓的家园，把他们干的好事如数奉还！%SPEECH_OFF%}",
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
			ID = "Approaching",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_138.png[/img]{你们找到了野蛮人村落，通向村庄的小径旁矗立着一系列石冢。石块堆砌成人形，每个冢顶都安放着一颗刚斩下的人头。%randombrother%点头道。%SPEECH_ON%不知他们是否觉得这样能更接近神明。%SPEECH_OFF%你觉得自己有更好的办法让他们面见神明：送他们全员上路。是时候策划进攻方案了。 | 你们发现了野蛮人村落，也见到在村子外围的雪地里嵌着一块圆形巨石。这石头大得离谱，全队人脚挨着头躺成一排都够不到另一边。石头外缘刻满了符文，长长的凹槽里结着厚厚一层干涸的血垢。石台中央有个方形凸起，上面带着放置脖颈的弧形凹槽。%randombrother%啐了一口。%SPEECH_ON%看着像个献祭场。%SPEECH_OFF%环顾四周，你好奇他们把尸体都弄哪儿去了。佣兵耸了耸肩。%SPEECH_ON%不知道。估计吃了吧。%SPEECH_OFF%要真这样你也不会觉得意外。你盯着村落，盘算是直接进攻还是再等等。 | 蛮族村落就在前面不远。这是一幅游牧景象：帐篷周围散落着临时锻炉，盖着防水布的货车充当粮仓。你觉得他们不会在任何地方久留。%randombrother%大笑。%SPEECH_ON%快看那个。那家伙在拉屎。真他妈绝了。%SPEECH_OFF%确实有个野人一边蹲着解手一边和同村人交谈。这情景本身就像个隐喻——整个营地都要像他一样被打个措手不及了。 | 令人意外的是，这座野人村落并非你预期中地狱般的光景。除了倒挂在木质图腾上那具剥皮尸体，这里看着和其他住着普通人的地方没什么两样。除了人人都穿着厚实衣物且随身带着各种斧头或刀剑。一切都挺正常。虽然有人在砍尸体腿脚喂猪，但这种场面哪儿都能见着。%randombrother%点头。%SPEECH_ON%好了，我们准备进攻。下命令吧，队长。%SPEECH_OFF% | 你们发现野蛮人村落蜷伏在雪原中。它肯定没在这里扎营多久：主要是帐篷而且篷顶积雪不多。他们肯定是暂时驻扎然后继续迁徙，要么是为了保持狩猎资源充足，要么是为了躲避报复。可惜后者他们没能躲过。你让队伍准备行动。 | 你们找到了野人村落。不过乍看之下，他们像是普通人。男人，女人，孩童。有铁匠，皮匠，独眼制箭人，还有个巨汉刽子手正在驴背上剖解尸体，清洗内脏。而这，提醒了你此行的目的。 | 你们找到野蛮人村落时，他们正在进行某种宗教仪式。一个戴着龟甲项链的老者把拳头塞进被割去头发的脑袋中，任鲜血顺着手臂流淌，孩童们则用马鬃刷蘸取这些\"颜料\"，跑去涂抹在十英尺高的木质图腾上。这些原始人用你完全不懂的语言吟诵观礼。%randombrother%低声说话，更像是出于对仪式的尊重而非怕被听见。%SPEECH_ON%要我说，咱们该下去打个招呼了对吧？%SPEECH_OFF% | 你们看见野蛮人在村落里闲逛。这里多是帐篷和临时雪屋。老妇围坐编筐，年轻女子制箭时偷瞄巡行的壮汉。男人们装作不在意，但开屏孔雀的把戏瞒不过你的眼睛。还有孩童奔波于各种杂务。而村外立着一排木桩，每根都从肛门到口腔贯穿着赤裸尸体，胸腔像蝴蝶翅膀般展开，内脏如散线刺绣垂落。%SPEECH_ON%真吓人。%SPEECH_OFF%%randombrother%说道。你点头。确实如此，但这正是你来此的目的。}",
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
			Text = "[img]gfx/ui/events/event_139.png[/img]{就在%companyname%即将与野蛮人交锋之际，有一人孤身走出，站在战线之间。他灰白的长须间编织着龟甲，头戴狼颅制成的斜面骨盔。这位长者除了一根系着鹿角的长杖外手无寸铁，鹿角随着他的动作咔嗒作响。令人惊讶的是，他竟用你们的语言开口。%SPEECH_ON%外乡人。欢迎来到北方。我们并非如你们所想的那般不近人情。依照传统，我们相信两位勇士之间的对决，其荣耀与价值不亚于两军交战。故此，我献上我们最强大的勇士，%barbarianname%。%SPEECH_OFF%一名魁梧壮汉应声出列。他卸下毛皮掷在地上，展露出布满肌肉与伤疤的雄健躯体。长老颔首。%SPEECH_ON%请派出你们的勇士，外乡人。今日你我将让各自的先祖都为之骄傲。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我更想烧毁整个营地。进攻！",
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
								Variant = difficulty >= 1.15 ? 1 : 0,
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
			Text = "[img]gfx/ui/events/event_138.png[/img]{%champbrother%收剑入鞘，站在倒下的野蛮人尸体旁。这位得胜的佣兵朝你点头致意。%SPEECH_ON%解决了，长官。%SPEECH_OFF%长老再次上前，举起权杖。%SPEECH_ON%胜负已分，你们专程来此大动干戈，究竟想解决什么问题？%SPEECH_OFF%你告诉他，南面的居民怒不可遏，要求他们离开这片土地。长者颔首。%SPEECH_ON%若你们想以战斗解决，那么这场荣誉决斗已见分晓。我们这就离开。%SPEECH_OFF%野蛮人听令开始收拾行装。令人意外的是，他们几乎没有怨言。如果他们信守诺言，你现在就可以向%employer%复命了。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "美好结局。",
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
			Text = "[img]gfx/ui/events/event_138.png[/img]{这是场精彩的战斗，大地上勇士间的对决让旁观者肃静无声，仿佛在见证某种永恒而荣耀的仪式。然而，%champbrother%已倒地身亡。他被击败并遭诛杀。长老再次迈步上前，脸上不见丝毫得意之色。%SPEECH_ON%外乡人，二人之间的对决便如同我们全体之间的较量。我们获胜了——愿远岩之神眷顾——现请你们离开这片土地，不要再回来。%SPEECH_OFF%几名佣兵愤然望向你，其中一人扬言如果胜负易位，这些野人绝对不会遵守约定，主张战团应当无视决斗结果将这些野蛮人赶尽杀绝。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们会信守承诺，不再打扰你们。",
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
					Text = "全体都有，冲锋！",
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
			Text = "[img]gfx/ui/events/event_145.png[/img]{战斗结束后，%randombrother%招呼你过去。其中一顶帐篷里有个正在疗伤的野蛮人，四周有几个男女老少。佣兵指着他说。%SPEECH_ON%我们把这野人追到这里。周围应该都是他的家人或相识——因为他瘫倒后就再没动弹过。%SPEECH_OFF%你走向那人蹲下身，轻叩他的鹿皮靴问是否听得懂你的话。他点头并耸肩道。%SPEECH_ON%懂一点。你们干的。没必要，但还是干了。给我个痛快，或者我加入你。二选一，都算光荣。%SPEECH_OFF%他似乎在提议加入战团，这想必是北方人某种你不熟悉的荣誉准则。他同时也坦然奉上自己的首级，面对死亡竟毫无惧色。}",
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
					Text = "放他走。",
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
						Text = "他这种人能派上用场。",
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
			Text = "[img]gfx/ui/events/event_145.png[/img]{你缓缓拔剑，剑锋垂向那人。帐篷内的尸骸在弯曲的金属剑身上扭曲变形，幸存野蛮人的面容在剑尖处模糊晃动。他咧嘴一笑，双手攥住剑刃，掌心瞬间被割裂，鲜血顺着手掌不断滴落。%SPEECH_ON%死亡，杀戮，没有耻辱。你我都是。对吗？%SPEECH_OFF%你点了点头，将剑刃推进他胸膛。他沉重的身躯如巨石般向后仰倒，当你抽出长剑时，尸体重重砸回尸堆中。你还剑入鞘，下令队伍收拾战利品，准备返回%employer%处复命。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "是时候去拿报酬了。",
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
			Text = "[img]gfx/ui/events/event_145.png[/img]{你将剑从鞘中抽出一半，持握片刻让野蛮人看清剑身，随即猛地推回鞘中。点头问道：%SPEECH_ON%明白吗？%SPEECH_OFF%野蛮人挣扎起身，短暂倚靠着帐篷支柱。你转身向帐门抬手示意。他颔首：%SPEECH_ON%嗯，我懂了。%SPEECH_OFF%他踉跄着踏入天光，朝着北方荒原蹒跚而去，身影在视野中左右摇晃，逐渐缩小，最终消失不见。你下令队伍整装准备返回%employer%处，领取应得的报酬。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "是时候去拿报酬了。",
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
			Text = "[img]gfx/ui/events/event_145.png[/img]{你凝视着那名野蛮人，随即抽出匕首划开自己的掌心。攥紧滴血的手，你将匕首抛给对方，伸出鲜血淋漓的手掌。野蛮人接过利刃依样划伤自己，起身与你血手相握。他颔首道：%SPEECH_ON%荣耀永存。永远追随你，不离不弃。%SPEECH_OFF%那人踉跄着走出帐篷。你告诉弟兄们不要伤他性命，而是给他武器，这引得数人面面相觑。这位新成员的加入虽出人意料，却必将成为战团的助力。出身南方的雇佣兵会逐渐适应的，但现在%companyname%该动身返回%employer%那里了。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "欢迎加入%companyname%战团。",
					function getResult()
					{
						this.World.getPlayerRoster().add(this.Contract.m.Dude);
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude.worsenMood(1.0, "看到他的村庄被屠。");
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
			Text = "[img]gfx/ui/events/event_135.png[/img]{一名长者拦在你们前路。他并非南方人氏。%SPEECH_ON%啊，外来者。你们闯进我们的土地，袭击毫无防备的村庄。%SPEECH_OFF%你啐了口唾沫点头承认。%randombrother%高声反驳说你们这些野人自己不也这么干。老者微笑。%SPEECH_ON%如此我们便陷入循环，借由这暴力得以重生，但暴力永无止境。等我们解决你们之后，%townname%也别想幸免。%SPEECH_OFF%一排壮汉从藏身之处跳了起来。看样子，这应该就是你们焚毁的那个村落的主力战团——当时他们可能外出劫掠去了。此刻他们正为践行野蛮人的复仇而来。}",
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
			Text = "[img]gfx/ui/events/event_145.png[/img]{野蛮人被逐出了%townname%。尽管战果已定，村民们还是花了不少时间才敢露面，看清你们的全面胜利。%employer%最终走了出来，鼓掌欢呼。他身后跟着一群神色尴尬的军官，他们膝盖沾满泥污，身上还沾着零散的稻草和土块——看来他们刚才一直在藏着。%SPEECH_ON%干得好，佣兵，干得漂亮！旧神肯定看在了眼里，迟早会奖赏你的！%SPEECH_OFF%你还剑入鞘，朝他那群无用的军官点了一下头。%SPEECH_ON%或许吧，但你最好先把你的奖赏给我。毕竟某些人……未能尽责？旧神肯定会感激你代他们行事的。%SPEECH_OFF%那人抿紧嘴唇，瞥了眼他的军官，而他们都移开了视线。你的雇主微笑着点头。%SPEECH_ON%当然，当然，佣兵。我完全明白你的意思。你将获得全额报酬，甚至更多！这都是你应得的，千真万确！%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "这钱可真不好挣。",
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
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color]克朗"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Revenge3",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_94.png[/img]{你们被迫撤离战场，退到足够安全的位置，眼睁睁看着%townname%沦陷。野蛮人闯进民宅，开始对男女实施强奸和屠杀。孩子们被集中起来，扔进骨皮制成的笼子。长老则温和地递给他们苹果片和樟脑水。在城镇广场，你目睹野蛮人围攻%employer%的宅邸。几名守卫挺身而出，却几乎瞬间被砍倒。有个被按在地上剥光衣服的人被踢向两只恶犬，它们从四面八方撕咬他，而他痛苦地存活了相当长的时间。\n\n最终，%employer%被拖出宅邸。野蛮人首领俯视着他，点了点头，随即单手掐住他的脖颈，另一只手捂住他的口鼻。就在这悬吊的姿势中，雇主窒息而亡。尸体被扔给战团成员剥光衣物亵渎，最后用长矛从肛门到口腔彻底穿刺，高悬在城镇广场示众。掠夺结束后，野蛮人带着战利品扬长而去。你最后看到的景象是条叼着人肋骨奔跑的野狗。%randombrother%来到你身边。%SPEECH_ON%唉。看来咱们是拿不到报酬了，长官。%SPEECH_OFF%是啊，恐怕没指望了。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "大败一场。",
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
			Title = "%townname%附近……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer%鼓掌欢迎你进门。%SPEECH_ON%我的探子追踪你们北上，见证了这场——恕我直言——注定成功的行动！屠杀那些野人的工作干得漂亮。这肯定会让他们不敢再南下半步！%SPEECH_OFF%他付清了应付的报酬。 | 你走进%employer%的房间，发现他瘫坐在椅子上，正盯着一个裸女在房间里来回踱步。他摇着头，眼睛始终没离开那场表演。%SPEECH_ON%我的斥候已经告诉我你们的所作所为了。说你们对付那些野蛮人的架势，就像他们得罪的是你们本人一样。我喜欢这样。我喜欢这种毫不克制。真希望我的手下也能有这种劲头。%SPEECH_OFF%一个先前没注意到的仆人快步穿过房间，他头顶着一根红蜡烛，手里捧着一箱克朗。你接过报酬，尽快离开了房间。 | 你找到%employer%时，他和一群武装士兵正围着一张桌子，上面放着一具野蛮人的尸体。皮肉已经灰白，但身体的肌肉线条和那股狠劲尚未腐朽。他们问你是否真的和这种人战斗过。你直奔主题要求付钱。%employer%拍着手把你展示给众人。%SPEECH_ON%先生们，这才是我想要收入麾下的人！无所畏惧，始终专注。%SPEECH_OFF%一个贵族啐了一口，低声说了句什么。你请他有意见的话大声说出来，但%employer%已经快步上前，手里捧着克朗钱箱，打发你上路了。 | 他站在一个死去的野蛮人面前，尸体像渔获一样双腿倒挂在房梁上。身体被烧灼、毁伤，不堪入目。%employer%蹲下身子在桶里洗手。%SPEECH_ON%不得不说，佣兵，你杀了这么多野人真是令人印象深刻。这个家伙撑了相当长的时间。忍受痛苦的样子像是要十倍奉还给我。但他没能做到。你呢？%SPEECH_OFF%他轻轻拍打野蛮人的脸，尸体微微转动，锁链叮当作响。%employer%点了点头。%SPEECH_ON%外面的仆人会给你报酬。干得漂亮，佣兵。%SPEECH_OFF% | 你找到%employer%时，他正和一群人督导%townname%的防务，无疑是在为下一次可能的袭击做准备。从这些人的样子判断，他们生存的意愿将遭受残酷的现实考验，承受远超他们所预估的打击。但你把这想法藏在心里。%employer%感谢你圆满完成任务，并付清了欠款。 | %townname%的一些居民看到你们归来时既惊恐又困惑，误把你们当成了他们熟知的那些野人。窗板紧闭，门扉猛关，孩子们被匆忙带走，几个胆大的拿着草叉走了出来。%employer%急忙从住所出来澄清，解释说你们是这场危机的英雄，你们北上消灭了野人，烧毁了他们的村庄，把他们驱散到了荒原。窗户大开，门吱呀作响地打开，孩子们回去玩耍了。就在你以为秩序恢复时，一个老妇人咆哮道：%SPEECH_ON%佣兵不过是另一种野蛮人！%SPEECH_OFF%你叹了口气，让%employer%付清欠款。 | %employer%正在研究几卷卷轴，一边在上面做笔记，一边划掉其他内容。他抬起头解释说，他要把你记录为‘前往荒原的英雄’和‘以最恰当、最南方的方式屠杀了野人’。他请你再告诉他一遍你的名字。你要求他付清欠款。 | %employer%被一群哭泣的妇女围着。他正在安慰她们，当你进来时，他站起来把你指给她们看。%SPEECH_ON%看啊！就是这个男人，他杀死了杀害你们丈夫的凶手！%SPEECH_OFF%女人们哀嚎着，一个接一个地扑向你，而你知道除了严肃而坚忍地点头外别无他法。%employer%是人群中最后一个找到你的，他手臂夹着一箱克朗，嘴角带着苦笑。你拿走了你的报酬，而他回到了妇女们身边。%SPEECH_ON%好了好了，夫人们，世界将迎来新的黎明。请跟我来。有人想喝点酒吗？%SPEECH_OFF% | %employer%张开双臂欢迎你。你拒绝了拥抱并要求付钱。他回到他的桌子旁。%SPEECH_ON%我并不是想拥抱你，佣兵。%SPEECH_OFF%他相当沮丧地轻敲着箱子。%SPEECH_ON%不过你屠杀那些野人确实干得不错。我的一些探子报告说你们在外面度过了‘一段美妙时光’。这是你应得的。%SPEECH_OFF%他把箱子推过桌面，你伸长手臂去接，感觉到他仍抓着箱子带来的一点阻力。你匆忙离开了房间，没有再看他一眼。 | 你费了好大劲才找到%employer%，最终发现他在井道半中央，正用石板堵一个洞。他朝你上面喊。%SPEECH_ON%啊，佣兵。把我拉上去，伙计们！%SPEECH_OFF%滑轮系统把他坐着的木板拉了上来。他荡下双腿，架在井口边缘。%SPEECH_ON%我们的石匠被驴子踢死了，所以我想着自己来搭把手。没什么比清晨干点脏活更能让一个好汉振作起来了。%SPEECH_OFF%他用他的手套拍了拍你的胸甲，留下一个粉末印子。他点点头，叫来一个仆人去取你的报酬。%SPEECH_ON%干得好，佣兵。非常，非常漂亮。嘿。%SPEECH_OFF%你没理会他的幽默。 | 发现%employer%时，他正在向一群农民发表演讲。他描述了一支无名的南方部队北上消灭了野蛮人渣滓。从头到尾都没有提及你或%companyname%的名字。当他讲完，这群乌合之众欢呼鼓掌，抛洒鲜花，一派节庆气氛。%employer%找到你，握了握你的手，同时把一箱克朗推给你。%SPEECH_ON%我希望能向这些善良百姓称你为英雄，但佣兵的风评可不太好。%SPEECH_OFF%你双手接过报酬，身体前倾。%SPEECH_ON%我只要报酬。祝你玩得开心，%employer%。%SPEECH_OFF% | 你找到%employer%时，他正在参加一个葬礼仪式。他们正在火化一个堆着三具尸体的柴堆，可能还有第四具更小的。可能是一家人。%employer%说了几句善意的话，然后点燃了木柴。一个仆人捧着一箱克朗突然出现在你面前。%SPEECH_ON%%employer%不希望被打扰。这是你的报酬，佣兵。如果不相信数目全对，请清点。%SPEECH_OFF%}",
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
