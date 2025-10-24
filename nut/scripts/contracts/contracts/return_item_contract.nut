this.return_item_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		IsPlayerAttacking = true
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.return_item";
		this.m.Name = "带回物品";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 400 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		local items = [
			"稀有钱币收藏",
			"仪式手杖",
			"丰产神像",
			"黄金护身符",
			"秘法宝典",
			"保险箱",
			"恶魔雕像",
			"水晶颅骨"
		];
		local r = this.Math.rand(0, items.len() - 1);
		this.m.Flags.set("Item", items[r]);
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"追查%townname%附近的踪迹",
					"将%item%带回%townname%。"
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

				if (r <= 15)
				{
					if (this.Contract.getDifficultyMult() >= 0.95)
					{
						this.Flags.set("IsNecromancer", true);
					}
				}
				else if (r <= 30)
				{
					this.Flags.set("IsCounterOffer", true);
					this.Flags.set("Bribe", this.Contract.beautifyNumber(this.Contract.m.Payment.getOnCompletion() * this.Math.rand(100, 300) * 0.01));
				}
				else
				{
					this.Flags.set("IsBandits", true);
				}

				this.Flags.set("StartDay", this.World.getTime().Days);
				local playerTile = this.World.State.getPlayer().getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 10, [
					this.Const.World.TerrainType.Mountains
				]);
				local party;
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).spawnEntity(tile, "盗贼", false, this.Const.World.Spawn.BanditRaiders, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.setDescription("一群盗贼和土匪。");
				party.setFootprintType(this.Const.World.FootprintsType.Brigands);
				party.setAttackableByAI(false);
				party.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				party.setFootprintSizeOverride(0.75);
				this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.GenericFootprints, this.Const.World.FootprintsType.Brigands, 0.75);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_bandits_0" + this.Math.rand(1, 6));
				local c = party.getController();
				local wait = this.new("scripts/ai/world/orders/wait_order");
				wait.setTime(9000.0);
				c.addOrder(wait);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"追查%townname%%direction%附近的踪迹",
					"将%item%带回%townname%。"
				];

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onTargetAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull())
				{
					if (this.Flags.get("IsCounterOffer"))
					{
						this.Contract.setScreen("CounterOffer1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("BattleDone");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Return");
					}
				}
				else if (this.World.getTime().Days - this.Flags.get("StartDay") >= 3 && this.Contract.m.Target.isHiddenToPlayer())
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (!this.Flags.get("IsAttackDialogTriggered"))
				{
					if (this.Flags.get("IsNecromancer"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
						this.Contract.setScreen("Necromancer");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
						this.Contract.setScreen("Bandits");
						this.World.Contracts.showActiveContract();
					}
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
					"将%item%带回%townname%。"
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer%一边焦躁踱步一边说明事由。%SPEECH_ON%发生了一起猖狂的盗窃！无耻匪徒偷走了我的%itemLower%，那对我而言是无价之宝。我恳请你追捕那些窃贼，将物品归还于我%SPEECH_OFF%他压低嗓音强调。%SPEECH_ON%不仅报酬丰厚，你也能让%townname%许多善良民众悬着的心安定下来！%SPEECH_OFF% | %employer%正在阅读卷轴，怒气冲冲地将它扔向堆积如山的文书。%SPEECH_ON%%townname%的民众完全有理由愤怒。你可知道有土匪——可能还勾结了其他流浪汉——偷走了我的%itemLower%？那件宝物对我来说是无价之宝！当然……对民众也很重要。%SPEECH_OFF%你耸耸肩。%SPEECH_ON%所以想让我帮你追回来？%SPEECH_OFF%对方手指一点。%SPEECH_ON%正是，聪明的佣兵！去追踪窃贼的足迹，把本属于我……咳，本属于镇子的东西带回来！%SPEECH_OFF% | %employer%神情烦躁地转动着手中的苹果，仿佛希望这是更珍贵的物件或更可口的水果。%SPEECH_ON%你可曾失去过心爱之物？%SPEECH_OFF%你耸肩答道。%SPEECH_ON%以前有个姑娘……%SPEECH_OFF%对方摇头。%SPEECH_ON%不，不是女人。更重要的东西！我的%itemLower%被贼偷了。他们如何绕过守卫我不知道，但派你出马一定能物归原主。我说得对吗？还是说我高估了你们的本事？%SPEECH_OFF% | 一条狗在%employer%的脚边打着鼾。他俯身轻抚猎犬耳后。%SPEECH_ON%听说你擅长追踪，佣兵。擅长……解决问题。%SPEECH_OFF%你点头承认。他继续道。%SPEECH_ON%好……很好……我有个简单任务。对我极珍贵的%itemLower%被偷了。需要你追查窃贼下落，解决他们，再把东西带回来。%SPEECH_OFF% | 有只鸟立在窗台上。坐着的%employer%指向它。%SPEECH_ON%我在想小偷是不是这么进来的。他们准是从窗户溜进来偷走%itemLower%，又从窗户逃了。%SPEECH_OFF%他缓缓起身弯腰靠近，正要扑向鸟儿时，那生灵已振翅飞走。%SPEECH_ON%该死。%SPEECH_OFF%他回到座位擦拭双手，仿佛这次捕鸟行动已让他汗流浃背。%SPEECH_ON%任务很简单，佣兵。把我的财产带回来。顺便解决那些土匪——如果你不介意的话。%SPEECH_OFF% | %employer%的桌面积满灰尘，却有块区域异常干净。他指向那里。%SPEECH_ON%我的%itemLower%原本放在那儿。如你所见，现在不见了。%SPEECH_OFF%你点头同意。%SPEECH_ON%那些窃贼应该不难追踪。他们夜间行动敏捷，白天却破绽百出——脚印、胡乱挥霍的克朗……追踪他们应该不难。%SPEECH_OFF%他严肃注视着你。%SPEECH_ON%明白吗，佣兵？我要你夺回我的财产，让它回到之前的地方。还有……让那些窃贼烂在泥里。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{对你来说值多少？ | 谈谈报酬吧。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{听起来这活不适合我们。 | 我觉得还是免了吧。}",
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
			ID = "Bandits",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_80.png[/img]{强盗！正如雇主所料。他们面露惧色，想必很清楚%employer%重金买来的怒火即将降临。 | 呵，这群盗贼再寻常不过 ——不过是伙流浪汉和土匪组成的乌合之众。他们刚抄起武器，你已下令进攻。 | 你撞见一伙强盗正搬运雇主的财物。对方没料到会在此暴露。对方没有白费口舌——他们摆出迎战姿态，而你也命%companyname%发起冲锋。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Necromancer",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_76.png[/img]{果然有盗匪在这里，但他们正把%itemLower%交给一个穿着破旧黑衣的人。你们的出现自然打断了交易，匪徒和那个阴森的家伙同时抄起了武器。 | 你撞见盗匪正在把%employer%的财产卖给一个死灵法师！也许他想用这东西对领主施什么恶毒法术。这么一想这主意倒不坏……不过，雇主付钱自有道理。冲锋！ | 盗匪们正把%employer%的财物卖给一个穿黑衣的苍白男子！他第一时间就瞪向你们，那双细小的黑眼睛瞬间锁定了战团。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						this.Const.World.Common.addTroop(this.Contract.m.Target, {
							Type = this.Const.World.Spawn.Troops.Necromancer
						});
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CounterOffer1",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_76.png[/img]{你擦净剑上的血迹，俯身去取失窃的宝物。弯腰时瞥见远处有个观望的身影。那人走上前来，长袖遮掩的双手交叠在身前。%SPEECH_ON%看来你杀了我雇主的手下。%SPEECH_OFF%你还剑入鞘，对他点了点头。他继续说道。%SPEECH_ON%我雇主为那物什付了重金。既然收钱的人已不在，或许我们可以直接谈谈。我愿意出%bribe%克朗买下它。%SPEECH_OFF%这……数目确实客观。但若接受，%employer%恐怕不会高兴…… | 战斗结束后，一人从树林鼓着掌走出。%SPEECH_ON%我付了那些人大笔克朗，现在看来该付给你才对。既然这些卑劣匪徒都死了，正好可以这么做！%SPEECH_OFF%你让他有话直说，否则刀剑无眼。他指向那物什。%SPEECH_ON%我出%bribe%克朗。这原本是付给盗贼的酬劳，现在再加些给你。意下如何？%SPEECH_OFF%%employer%绝不会轻饶背叛，但这报酬确实诱人…… | 战斗结束，你拾起%itemLower%仔细端详。这东西真值得这么多条人命吗？%SPEECH_ON%我知道你在想什么，佣兵。%SPEECH_OFF%突如其来的声音让你拔剑指向凭空出现的陌生人。%SPEECH_ON%你在想，会不会有人花重金请人偷这物什，会不会有人花重金找我买下它？ 或许……比原雇主给的报酬丰厚得多。%SPEECH_OFF%你放下武器点头。%SPEECH_ON%有意思。%SPEECH_OFF%那人微笑。%SPEECH_ON%%bribe%克朗。这是我开的价，包含原定给盗贼的价码和额外加价，相当公道的交易。当然，你的雇主会非常不满，不过……选择权在你手里。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我一看就知道是好买卖。把克朗拿来。",
					function getResult()
					{
						this.updateAchievement("NeverTrustAMercenary", 1, 1);
						return "CounterOffer2";
					}

				},
				{
					Text = "人家花钱雇我们来了，我们当然得信守承诺。",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CounterOffer2",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_76.png[/img]你交出%itemLower%，陌生人递来一个沉甸甸的钱袋。交易达成。可以预料你的雇主%employer%不会对此感到满意。",
			Image = "",
			List = [],
			Options = [
				{
					Text = "好酬劳。",
					function getResult()
					{
						this.World.Assets.addMoney(this.Flags.get("Bribe"));
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "没能带回被盗的" + this.Flags.get("Item"));
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("Bribe") + "[/color]克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "BattleDone",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_22.png[/img]{战斗结束后，你从敌人手中取回%itemLower%，准备返回%employer%处。他一定会为你的成功欣喜不已！ | 偷走%itemLower%的匪徒都死了，幸好物品也顺利找回。%employer%肯定会非常满意这次行动的结果。 | 很好，你们找到并了结了偷窃%itemLower%的匪徒。现在只需把%itemLower%交回%employer%就能领取报仇！ | 战斗结束，你在敌人尸体中轻松找到了%itemLower%。该把它带回%employer%那里领取应得的报酬了！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "是时候领工钱了。",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer%从你手里接过%itemLower%，，像找回失散的孩子般紧紧抱住。端详着这件宝物。他眼眶微微湿润。%SPEECH_ON%谢谢你，佣兵。这对我意义重大……我是说，呃，对全镇都很重要。我们十分感谢！%SPEECH_OFF%在你注视下他顿了顿，视线飘向房间角落。%SPEECH_ON%我们的……谢意，佣兵……%SPEECH_OFF%卫兵打开一个大木箱。你清点完克朗便离开了。 | 当你回去找%employer%时，他正在逗弄笼中鸟。%SPEECH_ON%啊，佣兵回来了……东西呢？%SPEECH_OFF%你举起宝物放在他桌上。他接过端详，点头收好。%SPEECH_ON%很好。这是你的辛苦费……%SPEECH_OFF%他向一个装满克朗的箱子摆了摆手手。 | %employer%正把脚搭在两条狗身上，它们相互叠在一起睡觉。%SPEECH_ON%这些猛兽能咬断我喉咙，可……看看他们。怎么回事？我都没训练过，是别人训的。对它们来说我只是陌生人，但是他们就这么让我压着。%SPEECH_OFF%你把宝物滑过桌面推过去。他俯身收进桌下，再抬手时拎着个钱袋抛来。%SPEECH_ON%之前谈话的报酬。干得漂亮，佣兵。%SPEECH_OFF% | 你走进%employer%的房间时，一群守卫正围着他。你乍以为碰上政变，结果他们散开后露出桌上的骰子和纸牌。%employer%招手道。%SPEECH_ON%来，来。我刚输了不少。你该不是带着能安慰我的东西来了吧？……？%SPEECH_OFF%你掏出%itemLower%。他小心翼翼地接过。%SPEECH_ON%好……很好……报酬在这。%SPEECH_OFF%递来钱袋后他便转身沉迷于宝物，再无他言。 | %employer%见你进门咧嘴一笑。%SPEECH_ON%佣兵啊佣兵，可否卖给我捷报一则？%SPEECH_OFF%你将宝物放在桌上。%SPEECH_ON%行啊。%SPEECH_OFF%他猛地从椅上弹起抓过物品，又强作镇定转回身。%SPEECH_ON%好。你干得很好。%reward_completion%克朗，之前说好的数目。%SPEECH_OFF%说着递来一袋钱币。}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "取回了被盗的" + this.Flags.get("Item"));
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
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_75.png[/img]{你俯身抓了一把泥土，任其从指缝流下——但这只是普通泥土，上面没有任何足迹。事实上你们已有好一阵没发现踪迹了。%randombrother%蹲在你身旁耸肩道。%SPEECH_ON%长官，咱们跟丢了。%SPEECH_OFF%你点点头。%employer%肯定不会高兴，但事已至此。 | 你们追踪失窃的%itemLower%已有段时间，但线索彻底断了。路遇的平民一无所知，地面也找不到任何脚印。无论如何，%itemLower%是找不回来了。%employer%对此不会满意的。 | 脚印存留太久，就会被一层又一层的其他足迹覆盖。你们花了太长时间追捕窃取%itemLower%的盗匪，繁忙的世事变幻早已抹去他们的行踪。现在已无望寻回失物，%employer%必将极为不悦。 | 偷走%itemLower%的盗贼已经无迹可寻了。最后发现的脚印将你们引到一处农庄，但那家人不像作案者，也对盗匪一无所知。%employer%对财物损失不会甘心，但你们已无能为力。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "去他的合同！",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "没能带回被盗的" + this.Flags.get("Item"));
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Target.getTile())]
		]);
		_vars.push([
			"item",
			this.m.Flags.get("Item")
		]);
		_vars.push([
			"itemLower",
			this.m.Flags.get("Item").tolower()
		]);
		_vars.push([
			"bribe",
			this.m.Flags.get("Bribe")
		]);
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
