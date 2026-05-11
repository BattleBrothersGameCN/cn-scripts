this.roaming_beasts_desert_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		IsPlayerAttacking = true
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.roaming_beasts_desert";
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
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 40 || this.World.getTime().Days <= 15 && r <= 80)
				{
					this.Flags.set("IsHyenas", true);
				}
				else if (r <= 80)
				{
					this.Flags.set("IsSerpents", true);
				}
				else
				{
					this.Flags.set("IsGhouls", true);
				}

				local playerTile = this.World.State.getPlayer().getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 10);
				local party;

				if (this.Flags.get("IsHyenas"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "鬣狗", false, this.Const.World.Spawn.Hyenas, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("一群寻找猎物的饥饿鬣狗。");
					party.setFootprintType(this.Const.World.FootprintsType.Hyenas);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Hyenas, 0.75);
				}
				else if (this.Flags.get("IsGhouls"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "食尸鬼", false, this.Const.World.Spawn.Ghouls, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("一群正在觅食的食尸鬼");
					party.setFootprintType(this.Const.World.FootprintsType.Ghouls);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Ghouls, 0.75);
				}
				else
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "大蛇", false, this.Const.World.Spawn.Serpents, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("四处游荡的大蛇。");
					party.setFootprintType(this.Const.World.FootprintsType.Serpents);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Serpents, 0.75);
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
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					if (this.Flags.get("IsHyenas"))
					{
						this.Contract.setScreen("CollectingHyenas");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsGhouls"))
					{
						this.Contract.setScreen("CollectingGhouls");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsSerpents"))
					{
						this.Contract.setScreen("CollectingSerpents");
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
					if (this.Flags.get("IsHyenas"))
					{
						this.Contract.setScreen("Success1");
					}
					else if (this.Flags.get("IsGhouls"))
					{
						this.Contract.setScreen("Success2");
					}
					else if (this.Flags.get("IsSerpents"))
					{
						this.Contract.setScreen("Success3");
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
			Text = "[img]gfx/ui/events/event_162.png[/img]{你走进%employer%的住所，发现他正站在一张精美地毯旁，地上散落着人体残肢。他抬头看向你。%SPEECH_ON%这些人之前说自己是野兽杀手，现在他们成了这个样子，刚从他们之前的任务中回收回来。%SPEECH_OFF%维齐尔点了点头，几个助手过来卷起地毯。血肉和内脏啪嗒作响地挤压在一起，从两侧涌出。仆人们抬起地毯，甩到肩上扛了出去，一只断手从一端无力地耷拉下来。%employer%拍了拍手。%SPEECH_ON%沙漠里逗留着一些麻烦，一群残忍的野兽正在收割当地人的生命。我曾凝视永恒之火，并得到指引去寻找一位逐币者来解决这个怪物问题。而你，逐币者，觉得%reward%克朗足以购买你一时的效力吗？%SPEECH_OFF% | 你走进%employer%的宅邸，但一堵名副其实的守卫人墙阻止你进一步靠近。他站在一个王座的基座旁，短楼梯从王座延伸而下。维齐尔缓缓地走下楼梯，其中一名卫兵回头望了一眼，他点了点头。卫兵转回身递给你一卷卷轴。上面写道，不明种类的生物正在%townname%的保护领地内肆虐。如果你找到并消灭了所述怪物，你将获得与此任务相称的报酬：%reward%克朗。 | 你发现%employer%被一群半裸的侍妾簇拥着。他正举着一只断手，令人惊讶的是，女人们似乎更多的是好奇而非厌恶。看到你时，维齐尔扔掉断手，在其中一个女人的肩膀上擦了擦手，这次引来了相当程度的鄙夷，但她尽量压抑住了。\n\n%employer%对一个仆人打了个响指，那人赶紧拿着一罐酒跑过来。维齐尔叹了口气，挥手赶走那个仆人，又打了一次响指。第二个仆人意识到在叫自己，赶忙上前，匆匆递给你一卷卷轴并高声念出上面的内容：在%townname%附近发现了怪物，必须立即将其消灭。\n\n关于报酬的部分则没有念得那么大声。相反，仆人用手指点了点纸上写着的一个数字：%reward%克朗。 | %employer%正站在一张地图前，这地图如此巨大，任何桌子都放不下，只能被分成几部分铺在大理石地板上。这似乎多此一举，因为一张地图完全可以以合适的比例尺容纳，但你把这个想法留在心里。维齐尔走过图纸，指着一个地点。%SPEECH_ON%野兽已经侵袭了这一块地方，并以一种我未曾准许的方式摧毁了它。 我在那里有更重要的事务需要处理。%SPEECH_OFF%他指向地图上另一片看起来只是空旷沙漠的区域。他继续说道。%SPEECH_ON%所以我需要一个像你这样的人，逐币者，去解决这些游荡的怪物。 事成，你就会获得%reward%克朗的报酬，这应该绰绰有余了。%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{我们再谈一谈报酬。 | 这种差事正是我们想找的。}",
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
			ID = "WorkOfBeasts",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_161.png[/img]{沙漠中鲜血横流，浓稠得仿佛要在沙地上凝固。你循着斑斑点点的痕迹来到一座大沙丘前，登上丘顶。另一侧的斜坡上散落着一连串残肢、一具躯干、还有具面目全非的尸体。沙地上深深的凹痕从这片区域延伸出去。你没能及时救下这些人，但已经很接近了。 | 你来到一口水井旁，旁边有间小屋。屋门洞开，从损坏的铰链上歪斜垂下。你拔剑出鞘，缓缓推开门，发现了曾经是个人的一滩烂泥。血珠正从天花板滴落，小屋另一侧有个破洞，那摧毁一切的怪物从此处离去，其动作如闯入时般暴烈。野兽肯定不远了。 | 尸体散落在一处沙漠水井周围。 当你靠近时，一双手猛地拍上井沿，一老人随之爬出。他翻过井壁坐定，喘着气。他指向四周的景象，耸了耸肩。看来野兽刚才还在这里，但你刚好错过了。你取出水壶递给老人，他却挥手示意你走开。他眼中深藏着巨大的痛苦，却竭力不让你看出分毫。}",
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
			ID = "CollectingHyenas",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_159.png[/img]{你不是很确定——因为你对这种生物并不特别了解——但你觉得自己对这些鬣狗有几分蔑视。它们常年偷吃其他生物的残羹剩饭。这些渣滓明明有力量和数量去争夺食物，却专挑弱者下手。只有在遇到你，看到自己的末日临头时，它们才会激发自己的野兽本性。你砍下它们的头，准备返回%employer%处。 | 鬣狗是种可鄙的生物，但它们很顽强。即便死了，你发现也不得不对着脖子又劈又砍才能找到着力点，要把头锯下来则需要更多时间。但很快事情就办完了，你准备将头颅和毛皮带回去给%employer%。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "赶快完事吧，还有赏金等着我们呢。 ",
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
			Text = "[img]gfx/ui/events/event_131.png[/img]{战斗结束后，你走到一具食尸鬼的尸体前单膝跪下。若不是那口参差不齐的獠牙碍事，你大可以把整个脑袋塞进它那张血盆大口。你无暇欣赏这口烂牙，掏出匕首锯断它的脖颈。你高举首级，下令%companyname%的弟兄们如法炮制。毕竟，%employer%需要不止一个脑袋作为证据。 | 死去的食尸鬼瘫在地上一动不动，看上去更像顽石而非野兽。蝇群已在它口中交配，在死亡泛起的白沫间播种生命。 你命令%randombrother%砍下它的头颅，毕竟%employer%肯定要看到证明才会付钱。 | 四处散落着食尸鬼的尸骸。你在其中一具旁蹲下，注视着它仍在微微开合的嘴——肺腔里的浊气随着嘶哑的嗝逆声不断溢出。你用布捂住口鼻，操起利刃剁向它的脖颈，随即拎起首级示意弟兄们照做。%employer%肯定想见到些凭证。 | 死去的食尸鬼堪称值得玩味的标本。你不禁思索它在自然界究竟处于何种位置：形如粗陋人形，肌肉虬结似猛兽，扭曲的头颅仿佛源自野人噩梦中的造物。将好奇心搁置一边，你下令让%companyname%收集这些秽物的首级带回%employer%作为凭证。}",
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
			ID = "CollectingSerpents",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_169.png[/img]{你蹲在一条沙漠大蛇面前。 就算好几个你头尾相连，也比不上它的全长。这确实是种令人着迷的蛇。你开始剥取它们的皮，准备将这些战利品带回给%employer%作为证明。 | 这些巨蛇已被砍成数段，你将有价值的部分——主要是它们扁平的头颅和奇特的尾巴——收集起来，以便向%employer%提供任务完成的证明。}",
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
			Text = "[img]gfx/ui/events/event_162.png[/img]{你返回时，%employer%已经站在他的宫殿外。他身旁站着几个身着丝绸服装的人。当你放下鬣狗的尸体时，这些人急忙将尸体运走。维齐尔留在原地，身边有几名护卫。他打了个响指，一个仆人递给你一箱克朗。维齐尔点了点头。%SPEECH_ON%干得好，逐币者。你将这批货物及时送达，我们自会善加利用。%SPEECH_OFF%货物？你以为你是来帮忙解决怪物威胁的。当护卫催促你离开广场时，你瞥见一位智者正用角尺开始测量，而另一个男人则架起画架开始作画。 | %employer%站在门口，尽管你被在相当远的距离外。他的仆人们前来迎接你，并取走鬣狗的头皮，将其抛入银光闪闪的手推车中。仆人们推着货物快步穿过庭院，如来时一般迅速消失。维齐尔吹了声口哨，如同鹰隼扑向猎物。你下意识地紧张了一瞬，但来的只是另一对捧着大量克朗的仆人。其中一个仰着头吟诵了起来。%SPEECH_ON%逐金客啊逐金客，这活干得真不错。箱箱财宝赏给你，包你钱袋都撑破！%SPEECH_OFF%念罢，他边咂舌边看向你，脸上还挂着灿烂的笑容。}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "清除该地区的鬣狗");
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
			ID = "Success2",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_162.png[/img]{%employer%欢迎你进入他的王座室。里面挤满了看起来非常重要的人物，但你依然被带了进去。你短暂停顿了一下，不确定这群人能否承受接下来的场面，随即耸耸肩，倾倒出食尸鬼的残骸。血沫、内脏和头颅在地板上漫延成一滩，但围观者中没有发出一点声响。\n\n你只能听到维齐尔走过来的轻柔脚步声。他凝视着残骸，双手像学者一样在身前交握，然后他打了个响指，一群仆人过来清理了这堆污秽。一个拿着羽毛笔和文件的男人做着记录。一切结束后，维齐尔回到他的王座，沉默地坐下。你听到的唯一其他声音是一个宝箱被拖过来时发出的叮当声。全部%reward%克朗如约交给了你，然后你被轻声催促离开房间。\n\n回头望去，你看到人群将注意力转回到维齐尔身上，而他则开始祈祷。 | 一个人在%employer%的房间外拦住了你。他带着几个拿着羽毛笔和账簿的瘦弱男人。他们扑向你收集的食尸鬼残骸，对照着他们的文件进行归类记录。每个人完成后都撕下那页纸，交给第一个男人核对笔记。满意之后，他递给你一袋%reward%克朗。%SPEECH_ON%愿你永远行在镀金之路上，逐币者。%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "清除该地区的食尸鬼");
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
			ID = "Success3",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_162.png[/img]{你在%employer%的花园里见到了他。后者手里拿着一把修剪剪刀盯着你。%SPEECH_ON%我想任务已经完成了？%SPEECH_OFF%你点点头，掏出一个蛇头扔在地上。它沉闷地噗通一声，滚到维齐尔的脚边，那只脚缓缓移开了。%employer%严厉地看着你。%SPEECH_ON%没必要这样作秀，逐币者，完成任务本身就足以令我满意。我的守卫会按照约定，为你的钱袋装满%reward%克朗。%SPEECH_OFF% | 你拖着蛇皮走向%employer%，但一个戴着头巾的男人拦住了你。他说的听起来像是胡言乱语，不过偶尔能听清一两个词。他似乎是维齐尔的雇员，前来接收蛇的残骸。你看向%employer%，他点头确认情况属实。 他似乎也注意到了你因担心报酬而流露出的紧张神色。他响亮而自豪地说道。%SPEECH_ON%不必担心，逐币者，这里唯一的毒蛇就是你带给我们的这些。%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "清除该地区的大蛇");
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
