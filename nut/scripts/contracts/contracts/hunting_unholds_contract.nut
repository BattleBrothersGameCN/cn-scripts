this.hunting_unholds_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		Dude = null,
		IsPlayerAttacking = true
	},
	function setEnemyType( _t )
	{
		this.m.Flags.set("EnemyType", _t);
	}

	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_unholds";
		this.m.Name = "狩猎巨人";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 750 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"猎杀巨魔，大概在" + this.Contract.m.Home.getName()
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

				if (r <= 40)
				{
					this.Flags.set("IsDriveOff", true);
				}
				else if (r <= 50)
				{
					this.Flags.set("IsSignsOfAFight", true);
				}

				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				local playerTile = this.World.State.getPlayer().getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 6, 12, [
					this.Const.World.TerrainType.Mountains
				]);
				local nearTile = this.Contract.getTileToSpawnLocation(playerTile, 4, 8);
				local party;

				if (this.Flags.get("EnemyType") == 0)
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "巨魔", false, this.Const.World.Spawn.UnholdBog, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				}
				else if (this.Flags.get("EnemyType") == 1)
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "巨魔", false, this.Const.World.Spawn.UnholdFrost, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				}
				else
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "巨魔", false, this.Const.World.Spawn.Unhold, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				}

				party.setDescription("一个或多个笨重的巨人。");
				party.setFootprintType(this.Const.World.FootprintsType.Unholds);
				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);
				party.getFlags().set("IsUnholds", true);
				this.Const.World.Common.addFootprintsFromTo(nearTile, party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Unholds, 0.75);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
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
					if (this.Flags.get("IsSignsOfAFight"))
					{
						this.Contract.setScreen("SignsOfAFight");
					}
					else
					{
						this.Contract.setScreen("Victory");
					}

					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (!this.Flags.get("IsBanterShown") && this.Contract.m.Target.isHiddenToPlayer() && this.Math.rand(1, 1000) <= 1 && this.Flags.get("StartTime") + 10.0 <= this.Time.getVirtualTimeF())
				{
					this.Flags.set("IsBanterShown", true);
					this.Contract.setScreen("Banter");
					this.World.Contracts.showActiveContract();
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (this.Flags.get("IsDriveOff") && !this.Flags.get("IsEncounterShown"))
				{
					this.Flags.set("IsEncounterShown", true);
					local bros = this.World.getPlayerRoster().getAll();
					local candidates = [];

					foreach( bro in bros )
					{
						if (bro.getBackground().getID() == "background.beast_slayer" || bro.getBackground().getID() == "background.wildman" || bro.getBackground().getID() == "background.barbarian" || bro.getSkills().hasSkill("trait.dumb"))
						{
							candidates.push(bro);
						}
					}

					if (candidates.len() == 0)
					{
						this.World.Contracts.showCombatDialog(_isPlayerAttacking);
					}
					else
					{
						this.Contract.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];
						this.Contract.setScreen("DriveThemOff");
						this.World.Contracts.showActiveContract();
					}
				}
				else if (!this.Flags.get("IsEncounterShown"))
				{
					this.Flags.set("IsEncounterShown", true);
					this.Contract.setScreen("Encounter");
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
					if (this.Flags.get("IsDriveOffSuccess"))
					{
						this.Contract.setScreen("SuccessPeaceful");
					}
					else
					{
						this.Contract.setScreen("Success");
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
			Text = "[img]gfx/ui/events/event_79.png[/img]{你走进%employer%的房间，发现他正弓着身子站在窗边，神情紧张地向外窥视。他眯着眼睛又突然睁大，如此反复几次，最后猛地拉上窗帘转头看向你。%SPEECH_ON%你不会正好看见有个怒气冲冲的女人往这边来吧？算了不说这个。看看这个。%SPEECH_OFF%他扔给你一卷羊皮纸，你展开看到一幅粗糙的画作：像是个男人弯腰对着蚂蚁或什么虫子——实在看不出来到底是什么。%employer%拍手道。%SPEECH_ON%农户们都在报告牲畜失踪，只找到能躺进棺材的脚印。 我看像是谣言，说不定是竞争对手想掩盖自己干的坏事。不过交给你查探了，在周边搜查看看，若真碰上巨人——你知道该怎么做。%SPEECH_OFF% | 你见到%employer%时，他正和半个村的农户围在桌边。他们趴在羊皮纸上用铅条画着像长角巨人或胖子的图案。有个家伙甚至在画火柴人交媾的涂鸦。%employer%递来一张更清晰的怪物画像。%SPEECH_ON%这些先生说有巨人出没。我不想质疑乡亲们的忧虑，所以雇佣你，佣兵。钱在桌上，只需在%townname%周边找出这畜生。意下如何？%SPEECH_OFF% | 你见到%employer%正在应付一群闯进房间的农民——他们拿着干草叉和未点燃的火把，他不断警告别在木屋里点火。见到你时，%employer%像溺水者看到浮木般呼喊。%SPEECH_ON%佣兵！天啊快过来。 这些人说出现了野兽。%SPEECH_OFF%其中一个农民用他的草叉重重地往地面一跺。%SPEECH_ON%不是普通野兽，是大家伙！巨人！我亲眼瞅见的！%SPEECH_OFF%%employer%叹着气接过话。%SPEECH_ON%好吧。我出钱请你去追查这个巨人，接不接这活儿？%SPEECH_OFF% | %employer%正双手抱头坐在桌前喃喃自语。%SPEECH_ON%这个说怪物，那个说野兽。‘噢我的鸡被偷了’——哦也许你该把鸡关进笼子，你这没脑子的蠢……啊佣兵你好！%SPEECH_OFF%他从椅子上站起来，扔给你一张纸。 上面粗略地画着个大头怪物。%SPEECH_ON%乡亲们说这带有个巨人游荡。我出钱请你调查，要是真找到也一并解决掉。你接这活吗？求你说接。%SPEECH_OFF% | %employer%不情不愿地迎你进屋，装出一副不需要帮忙的样子，虽然很明显他压根就不想找你。%SPEECH_ON%佣兵啊，像%townname%这样的地方很少和你这类人搭上关系，但恐怕确实有巨魔在这片土地上掠夺，偷走了大量牲畜，镇民们已经凑齐了钱款，特地请来了你这样的人物。有兴趣猎杀这头肮脏的生物吗？%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{与巨人战斗可不便宜。 | %companyname%可以帮忙，只要价钱合适。 | 佣金是多少？}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{听起来这活不适合我们。 | 这风险不值当。}",
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
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_71.png[/img]{%randombrother%侦查完回来报告称，附近的农庄已遭摧毁，屋顶被开了个大洞，看着就像被踹了一脚的蚂蚁窝。你询问是否有幸存者，他点头。%SPEECH_ON%算有吧。有个不肯开口的男孩，还有个一直冲我喊滚开的女人。除此之外……没了。他们能活下来全凭运气，这世道容不得他们继续呆下去。%SPEECH_OFF%你让这名佣兵收起评判，转而带队继续前进。 | 你在路边发现半头牛尸，并非经宰割而是被以极暴力的方式撕扯得不成形状，内脏泼洒满地。墓穴大小的足迹延伸向远处，残骸轨迹穿过支离破碎的栅栏，谷仓的残骸在前方隐约可见。%randombrother%笑道。%SPEECH_ON%现在就缺堆巨人屎了。%SPEECH_OFF%你让他先瞧瞧自己靴底。 | 几个路上遇到的农民警示你。%SPEECH_ON%赶紧离开！ 这身铠甲顶不住它舔一口！%SPEECH_OFF%你追问巨魔踪迹，他们生动描述不久前肆虐此地的庞然巨物——看来没找错路。 | 巨魔所过之处狼藉一片：牲畜被踩成肉泥，有些则像嗦花蜜般被吸食殆尽。散养的鸡群仍在啄食地面，看守的农夫点头示意。%SPEECH_ON%好戏刚散场。%SPEECH_OFF%看来离目标不远了。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "它们不远了。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Encounter",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_104.png[/img]{这些巨魔围坐在熄灭的篝火旁揉着肚皮的模样，乍看就像群蹲在地上的劳工。当然，你们的出现立刻让它们起身，彻底打破了任何与人类的相似感，或许除了尺寸相当的第三条腿。 巨兽们低吼跺脚却未立即进攻，反而挥舞手臂试图赶走你。 但%companyname%大老远而来岂会空手而归。 你利剑出鞘，率领众人向前逼近。 | 每头巨魔都庞大得无以伦比。它们困惑地打量着这些敢来挑战的蝼蚁。其中一只挠头时随意打了个嗝，溅得战团成员满身牛血。 不过闪烁的剑光终于让它们从饱食后的慵懒中清醒。随着震天动地的跺脚，它们迈步上前，要将你们逐出这片土地——或直接踏进泥土里。 | 就算%companyname%全员叠罗汉也抵不上一头巨魔的高度。然而此刻你们竟挥舞刀剑准备与这些庞然大物交锋。它们们投来难以置信的目光，不明白这些渺小生物何来的勇气。其中一只挠了挠肚皮，掉落的皮屑竟有狗那么大。罢了，现在不是犹豫的时候。你当即下令全队进攻！ | 巨魔嗅到气息，横越原野冲向%companyname%。它们如同山峦大小的幼童，笨拙迈步却震得大地颤动，张开的巨口垂着涎液准备饱餐一顿。你冷静地拔剑出鞘，指挥队伍列阵迎敌。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "冲锋！",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "DriveThemOff",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_104.png[/img]{正当你指挥部队列阵时，%shouter%突然从你身旁跑过，径直冲向巨怪，他又是怪叫又是嘶吼，双臂乱挥得像条被钓钩拽上来的海怪。巨魔们停下动作面面相觑。你一时不知是否该放任他继续……}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "攻击它们！",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				},
				{
					Text = "%shouter%知道自己在做什么。",
					function getResult()
					{
						if (this.Math.rand(1, 100) <= 35)
						{
							return "DriveThemOffSuccess";
						}
						else
						{
							return "DriveThemOffFailure";
						}
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "DriveThemOffSuccess",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_104.png[/img]{尽管心存疑虑，你还是放手让%shouter%去做。 他如同脱缰野马般狂奔不止，活像在追逐一群正为他宽衣解带的美女。令人震惊的是，巨魔们竟然后退了。它们接二连三地后撤，最后只剩一头巨魔留在原地。\n\n%shouter%如狂吠的小狗般冲到巨兽脚边，声音如此刺耳以致你寻思是否每个埋在地里的祖先都听到了它。 那巨人抡起巨臂护住面门，竟开始步步后退，越来越远，直至消失在视野中——它们全都被吓跑了！}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "可别回来咯！",
					function getResult()
					{
						this.Contract.m.Target.die();
						this.Contract.m.Target = null;
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
				this.Contract.m.Dude.improveMood(3.0, "他设法一个人赶走了那些巨魔");

				if (this.Contract.m.Dude.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[this.Contract.m.Dude.getMoodState()],
						text = this.Contract.m.Dude.getName() + this.Const.MoodStateEvent[this.Contract.m.Dude.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "DriveThemOffFailure",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_104.png[/img]{尽管心存疑虑，你还是放手让%shouter%去做。 他如同脱缰野马般狂奔不止，活像在追逐一群正为他宽衣解带的美女。令人震惊的是，巨魔们竟然后退了。它们接二连三地后撤，最后只剩一头巨魔留在原地。\n\n%shouter%如狂吠的小狗般冲到巨兽脚边，声音如此刺耳以致你寻思是否每个埋在地里的祖先都听到了它。 那巨人抡起巨臂护住面门，随即猛地挥下，像拍苍蝇般将%shouter%扫飞出去。 他那人如同被苍鹰掳走的兔子般在空中翻滚，凄厉的惨叫随之划破长空。当他在远处砰然坠地时， 巨人发出沉闷如大地震颤的嗤笑。这笑声引得撤离的巨魔们纷纷驻足，晃晃悠悠地折返回来。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "到此为止吧。",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, false);
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
				local injury;

				if (this.Math.rand(1, 100) <= 50)
				{
					injury = this.Contract.m.Dude.addInjury(this.Const.Injury.BluntBody);
				}
				else
				{
					injury = this.Contract.m.Dude.addInjury(this.Const.Injury.BluntHead);
				}

				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = this.Contract.m.Dude.getName() + " 遭受 " + injury.getNameOnly()
				});
				this.Contract.m.Dude.worsenMood(1.0, "他没能赶走那些巨魔");

				if (this.Contract.m.Dude.getMoodState() <= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[this.Contract.m.Dude.getMoodState()],
						text = this.Contract.m.Dude.getName() + this.Const.MoodStateEvent[this.Contract.m.Dude.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_113.png[/img]{巨魔尽数伏诛，你下令让士兵们尽可能收集战利品作为成果证明——这些庞然巨物的皮毛骨骼或许还能另作他用。既然人类能用牛皮制革，这些巨兽身上定有更珍贵的材料？无论如何？%employer%还在等着。 | 随着最后一头巨人轰然倒地，%employer%此刻应当正等候你们的凯旋。他的城镇将重获安宁，不再需要你这类佣兵的服务。这个念头让你忍不住迸发出一阵大笑，在队员们困惑的注视中，你摆手命他们整队踏上归途。 | 可怖的巨怪负隅顽抗，却终究难敌%companyname%的合力——无论是力量、智谋还是胆识。你命令伙计们携带战利品作为证明，准备向%employer%折返。 | 最后一只巨魔毙命后，你开始清点队伍。发现%randombrother%正在巨怪的肚皮上蹦跳着，在你厉声喝止时露出悻悻之色。%employer%期待看到的是提着战利品的屠夫，而非一群嬉闹的稚童。}",
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
			ID = "SignsOfAFight",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_113.png[/img]{巨人们倒下后，你正准备带领队员们返回%employer%处复命，%randombrother%却声音发颤地叫住了你。你走过去，见他正站在一具巨魔尸体前，指着那些被撕裂的皮肉——伤口如同玉米秆般层层垂落，这种破坏力远非我们手中兵器所能及。这名佣兵转头望向远处，瞳孔骤然放大。%SPEECH_ON%你觉得这是什么东西干的？%SPEECH_OFF%顺着皮肤上的痕迹望去，可见凹陷的碟状疤痕，中央还带着穿透的孔洞。你爬上巨魔身躯，将长剑卡进一处凹痕奋力撬动，竟挖出半截前臂长度的獠牙。齿缘布满倒刺，仿佛在獠牙上又生出新的利齿。队员们见状窃窃私语，而你宁愿从未目睹这一切——因为眼前的现象已超出常理可解的范畴。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "荒野黑暗而危机四伏。",
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
			ID = "Success",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_79.png[/img]{你刚回来%employer%就迎了上来，开口就说自从你离开后，再没听过巨魔肆虐的消息。你点头掏出证据，——将巨怪的残骸倒到他地板上，木质地板顿时像铺了层污秽地毯般。镇长抿紧嘴唇。 镇长咬了咬嘴唇。%SPEECH_ON%搞什么鬼，佣兵？%SPEECH_OFF%你歪头挑眉。他立刻摆手躬身。%SPEECH_ON%啊，别介意！没事了！给，说好的酬金！%SPEECH_OFF% | 你去找%employer%时，发现他正在给小孩们讲故事。他张牙舞爪地模仿野兽咆哮。你的敲门声打断了他的表演。%SPEECH_ON%看啊，英勇的佣兵们斩杀了怪物！%SPEECH_OFF%孩子们为你的适时出现欢呼。镇长起身递来约定的赏金，坦言派了探子全程跟进，早已知晓战果。他问是否愿意给孩子们讲讲经历，你丢下句\"我不白打工\"便转身离去。 | 你在镇上找了半天才见到%employer%，他正和一位年轻女郎躲在被窝里，被你撞个正着的镇长毫不在意，当着你的面穿上衣服，还朝女孩抛了枚硬币，转身对你说道%SPEECH_ON%啊，佣兵，我正等着你呢！ 说好的酬金在这！%SPEECH_OFF%他递来钱袋时漏了枚硬币掉进地板缝里。只见他抿嘴思索片刻，转身抢回刚给女孩的硬币塞回钱袋。 | %employer%正为欠税与农奴争执，扬言领主总有办法收到钱。全副武装的你适时出现，吓得农奴们慌忙掏出钱袋。你让他们安静，接着向镇长索要酬劳。他从抽屉取出钱袋，顺手从农奴手里抢了枚硬币填满袋口，这才递给你。%SPEECH_ON%辛苦你了，佣兵。%SPEECH_OFF% | 你向%employer%汇报战果，他竟然没有任何怀疑。%SPEECH_ON%我派了斥候尾随，他比你们先回镇。你说的每句话都对得上他的报告。给，约定好的报酬 Your pay, as promised.%SPEECH_OFF%说着便将钱袋递了过来。}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "清除城镇附近的巨魔");
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
			ID = "SuccessPeaceful",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_79.png[/img]{%employer%用手指抵住眼角向前一划。%SPEECH_ON%让我捋捋，你手下的佣兵把巨人叫跑了？%SPEECH_OFF%你点头确认，并特意强调巨人撤退的方向确实远离了%townname%。镇长向后靠上椅背。%SPEECH_ON%行吧。反正现在不是我的麻烦了。死透还是跑路，横竖结果都一样。%SPEECH_OFF%他递来钱袋时故意抓住不放。%SPEECH_ON%要是你说谎，等它们杀回来，我保证用所有信鸽告诉别人你们的光辉事迹。%SPEECH_OFF%你猛然按剑起身，说等巨魔回来时正好可以用他的头骨当酒杯。镇长立即松手赔笑。%SPEECH_ON%别生气嘛佣兵，只是按规矩办事。%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "清除城镇附近的巨魔");
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
			"shouter",
			this.m.Dude != null ? this.m.Dude.getName() : ""
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
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/unhold_attacks_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.setAttackableByAI(true);
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
