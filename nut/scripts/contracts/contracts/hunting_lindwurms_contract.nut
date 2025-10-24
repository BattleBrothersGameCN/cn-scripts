this.hunting_lindwurms_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		Dude = null,
		IsPlayerAttacking = true
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_lindwurms";
		this.m.Name = "狩猎林德蠕龙";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		this.m.DifficultyMult = this.Math.rand(95, 135) * 0.01;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 800 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		this.m.Flags.set("Bribe", this.Math.rand(300, 600));
		this.m.Flags.set("MerchantsDead", 0);
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"猎杀林德蠕龙，大概在 " + this.Contract.m.Home.getName()
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
					this.Flags.set("IsAnimalActivist", true);
				}
				else if (r <= 25)
				{
					this.Flags.set("IsBeastFight", true);
				}
				else if (r <= 35)
				{
					this.Flags.set("IsMerchantInDistress", true);
				}

				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				local playerTile = this.World.State.getPlayer().getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 6, 12, [
					this.Const.World.TerrainType.Mountains
				]);
				local nearTile = this.Contract.getTileToSpawnLocation(playerTile, 4, 7);
				local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Lindwurm", false, this.Const.World.Spawn.Lindwurm, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.getSprite("banner").setBrush("banner_beasts_01");
				party.setDescription("林德蠕龙，一种无翼双足龙，形似巨蛇。");
				party.setFootprintType(this.Const.World.FootprintsType.Lindwurms);
				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);
				this.Const.World.Common.addFootprintsFromTo(nearTile, party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Lindwurms, 0.75);
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
					if (this.Flags.get("IsMerchantInDistress"))
					{
						if (this.Flags.get("MerchantsDead") < 5)
						{
							this.Contract.setScreen("MerchantDistressSuccess");
						}
						else
						{
							this.Contract.setScreen("MerchantDistressFailure");
						}
					}
					else
					{
						this.Contract.setScreen("Victory");
					}

					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (!this.Flags.get("IsBanterShown") && this.Contract.m.Target.isHiddenToPlayer() && this.Math.rand(1, 1000) <= 1 && this.Flags.get("StartTime") + 15.0 <= this.Time.getVirtualTimeF())
				{
					this.Flags.set("IsBanterShown", true);
					this.Contract.setScreen("Banter");
					this.World.Contracts.showActiveContract();
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (this.Flags.get("IsBeastFight"))
				{
					this.Contract.setScreen("BeastFight");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsMerchantInDistress"))
				{
					this.Contract.setScreen("MerchantDistress");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsAnimalActivist"))
				{
					this.Contract.setScreen("AnimalActivist");
					this.World.Contracts.showActiveContract();
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

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_combatID != "Lindwurms")
				{
					return;
				}

				if (_actor.getType() == this.Const.EntityType.CaravanDonkey || _actor.getType() == this.Const.EntityType.CaravanHand)
				{
					this.Flags.increment("MerchantsDead");
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
					if (this.Flags.get("BribeAccepted") && this.Math.rand(1, 100) <= 40)
					{
						this.Contract.setScreen("Failure");
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
			Text = "[img]gfx/ui/events/event_77.png[/img]{你找到%employer%时，他正盯着一个篮子看。几个农民待在角落里抓挠着自己，看起来相当紧张。你问这是怎么回事。你这位潜在雇主带你到篮子边，你看到里面有条蛇在滑动。这是条温顺的蛇，身上的花纹也不像带毒的样子。你如实相告。他耸耸肩，盖上了篮子。%SPEECH_ON%反正都要杀了吃，皮拿来做个匕首鞘。我需要你做的是去找条比这大得多的蛇。我说的是林德蠕龙，佣兵。大家伙。在偏僻地带游荡，还会吃人。你是能处理这种情况的人吗？%SPEECH_OFF% | 你发现%employer%正在他那间蛛网比知识还多的私人藏书室里瞎忙活。他似乎察觉到你的到来，问你是否了解林德蠕龙。没等你回答，他就转过身来，手里拿着一卷卷轴。%SPEECH_ON%我需要你去偏僻地带走一趟。我们这儿有几只那种怪物。它们在杀害农夫和行商。妈的，有些人还挺招人喜欢的。我觉得你正是我们需要的人，来帮我们除掉这些野兽。你有兴趣吗？%SPEECH_OFF%你看到他的卷轴展开了一点，露出一个画工粗糙、袒胸露乳的女人画像。他慌忙把卷轴卷好藏到背后。他笑了笑。%SPEECH_ON%怎么样啊？%SPEECH_OFF% | 一群农民排在%employer%的门外。你从他们中间挤过去，有几个人表示不满，你便握住了剑柄。%employer%从门里跳出来调解。%SPEECH_ON%放松，大家都放松。这位就是我想要雇佣的佣兵。先生，请容我解释一下大家为什么火气这么大。林德蠕龙正在乡间肆虐，我们需要像你这样孔武有力的佣兵去把它们全部干掉。你有兴趣吗？%SPEECH_OFF%那些原本愤怒的乡巴佬此刻都盯着你，仿佛你是救世主一般。}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{你要我们做的可真是份大差事。 | 对付这样的敌人，我希望有个好价钱。 | 得让我赚上一大笔才行。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{听起来你需要的是英雄和蠢货。 | 这风险不值当。 | 我觉得还是免了吧。}",
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
			Text = "[img]gfx/ui/events/event_66.png[/img]{%randombrother%用武器挑着一管鳞皮。他晃来晃去，鳞片相互摩擦发出干涩的刺啦声。你让他把那东西放下，保持警惕。林德蠕龙无疑就在附近。 | %randombrother%说他曾听过一个故事，讲一条林德蠕龙杀了人却没吃掉。%SPEECH_ON%没错。他们说那玩意儿喷出绿水，那人就直接融化在了自己的靴子里。说他那小腿胫骨看起来就像汤里的搅拌棍。%SPEECH_OFF%真是个恶心的故事，但希望这能让兄弟们打起应有的精神。那些林德蠕龙肯定不远了。 | 草丛上有蛇行的痕迹，两侧还有孔洞。%randombrother%蹲在痕迹旁。%SPEECH_ON%要么是个抓不住地的犁，要么就是咱们找的玩意儿了。%SPEECH_OFF%你点点头。林德蠕龙不会太远了。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "当心！",
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
			Text = "[img]gfx/ui/events/event_129.png[/img]{你正在查看地图，%randombrother%突然大喊。抬头望去，只见林德蠕龙正从地洞中钻出，大片的尘土从它们身侧流泻而下。它们身躯低伏，贴着地面迅猛扑向%companyname%。你拔出剑，命令兄弟们列阵。 | 战团来到一个洞口堆满巨石的洞穴前。但当你靠近时，那些岩石竟舒展开来，在半空中翻转，从腹部弹出腿脚稳稳落地——分明是林德蠕龙。你后退一步，这些野兽抖落背上的尘土，巨口开合发出低沉的咯咯声。它们转向你，眼睛眨了眨，然后懒洋洋地向前逼近，仿佛你的佣兵们只是需要随手打发的小麻烦。你命令战团列阵。怪物们或许察觉到你们更具威胁，突然加速前冲，发出有力的嘶嘶声，蛇形身躯在地面蜿蜒，速度快得惊人。 | %companyname%走向一座山丘，每一步都踩得脚下骨头咯吱作响。%randombrother%示意大家安静，指向山顶。林德蠕龙盘绕在山脊上，仿佛为大地绣上了边饰。似乎感知到你们的注视，这些野兽舒展身体，懒洋洋地滑下斜坡，有些还半扭着身子，像孩子滚下山坡。它们的巨口开合，舌头舔掉眼里的灰尘，看起来全然像是梦游的小动物，而非凶残的怪物。然而，就在它们的脚掌踏上平地的一瞬间，它们骤然绷紧身体，猛冲向前，蛇形的身躯掠过埋骨地，扬起的骨粉如公鸡尾羽般在其身后掀起。你拔出剑，急切地命令兄弟们列阵。}",
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
			ID = "AnimalActivist",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_17.png[/img]{你发现林德蠕龙正在一处地窝子里滑动，但还没来得及开战，一个男人就用嘶嘶声打断了你。他看起来好多天没刮胡子，一个鼓鼓囊囊的行囊挎在双肩上，头巾把他头发束得像盆栽鼠尾草。除了憔悴的外表，他身上一件武器也没有。你问他想要什么。他急促地低声说道。%SPEECH_ON%你是来杀林德蠕龙的？%SPEECH_OFF%那些恶心的蛇形怪物正在远处扭动，像小狗小猫一样互相嬉戏。你点头告诉他它们害了不少人，而你收了钱要把它们全宰了。那人抿紧嘴唇。%SPEECH_ON%看到它们皮上的光泽了吗？那是它们独有的，而且它们是最后的种群了。这些是血统精纯的林德蠕龙，先生，让它们彻底从世上消失对这世界本身将是可怕的损失。这样如何，我给你%bribe%克朗，而且，呃，你是受雇于人的对吧？所以你也把这个拿去。%SPEECH_OFF%他从行囊里扯出一件巨大、粗糙的林德蠕龙皮套递过来。%SPEECH_ON%就跟你的雇主说你找到并杀掉了林德蠕龙，然后给他们看这个。他们分辨不出来的。要是你琢磨着在这儿跟我耍两面派，那我告诉你，我看起来是有点疯，但实际上我是彻底疯了。像我这样的疯子，要是没两把刷子，怎么可能跟踪这些巨大、奇妙又美丽的林德蠕龙还活到现在，懂了吗？%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "滚开，蠢货。我们还有野兽要杀。",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				},
				{
					Text = "好，我接受你的提议。",
					function getResult()
					{
						return "AnimalActivistAccept";
					}

				}
			],
			function start()
			{
				this.Flags.set("IsAnimalActivist", false);
			}

		});
		this.m.Screens.push({
			ID = "AnimalActivistAccept",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_17.png[/img]{在你看来，这里的林德蠕龙其实不算你的问题，你只是收了钱来处理它们。而且如果那个疯癫的林德蠕龙保护者那身皮套能骗过%employer%的话，你说不定还能拿双份报酬。\n\n你接受了这笔交易。那傻子向你道谢，还冷不防地抱了你一下。他臭不可闻，头发板结厚重得让小虫子都在里面蛀出了洞穴，此刻正盯着你看。一只小石龙子在那臭烘烘的发绺间窜过，叼走了一只虫子。你推开这家伙，祝他无论在做啥鬼事情都能走运。他伸出大拇指和小指，晃了晃手。%SPEECH_ON%你这位先生，可真有正义感。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "正义感。呵。",
					function getResult()
					{
						local bribe = this.Flags.get("Bribe");
						this.World.Assets.addMoney(bribe);

						if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
						{
							this.Contract.m.Target.getSprite("selection").Visible = false;
							this.Contract.m.Target.setOnCombatWithPlayerCallback(null);
							this.Contract.m.Target.die();
							this.Contract.m.Target = null;
						}

						this.Flags.set("BribeAccepted", true);
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				local bribe = this.Flags.get("Bribe");
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + bribe + "[/color]克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "BeastFight",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_129.png[/img]{尘土从远处的洞穴入口喷涌而出。靠近时，你能听到林德蠕龙的嘶嘶声，其间还夹杂着某种完全不同的生物发出的断续咆哮。%SPEECH_ON%看，长官！%SPEECH_OFF%%randombrother%指向洞口的边缘。有两只食尸鬼正在对付一条林德蠕龙，一只紧抓着尾巴被甩来甩去，另一只则双手撑住巨口。怪物们正在自相残杀！\n\n你摇了摇头，拔出剑，命令兄弟们列阵。看来，这注定要是一场激烈的混战了。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我不知道这是好是坏。",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "林德蠕龙";
						p.Music = this.Const.Music.BeastsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Edge;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Random;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Ghouls, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "MerchantDistress",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_41.png[/img]{你看到一个商人驾着货车沿道路缓缓前行。货车的后部突然向上掀起，车尾的随从像破布娃娃一样被抛飞出去。一道绿色身影滑过商队后方，另一道则窜到侧面。商人转身跳进货车，而林德蠕龙们已发起攻击。这无疑就是你们一直在寻找的目标。在你的指挥下，%companyname%可以在商队被摧毁前冲上前去。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "攻击！",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "林德蠕龙";
						p.Music = this.Const.Music.BeastsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Edge;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Random;
						p.Entities.push({
							ID = this.Const.EntityType.CaravanDonkey,
							Variant = 0,
							Row = -1,
							Script = "scripts/entity/tactical/objective/donkey",
							Faction = this.Const.Faction.PlayerAnimals,
							Callback = null
						});
						p.Entities.push({
							ID = this.Const.EntityType.CaravanDonkey,
							Variant = 0,
							Row = -1,
							Script = "scripts/entity/tactical/objective/donkey",
							Faction = this.Const.Faction.PlayerAnimals,
							Callback = null
						});
						p.Entities.push({
							ID = this.Const.EntityType.CaravanHand,
							Variant = 0,
							Row = -1,
							Script = "scripts/entity/tactical/humans/caravan_hand",
							Faction = this.Const.Faction.PlayerAnimals,
							Callback = null
						});
						p.Entities.push({
							ID = this.Const.EntityType.CaravanHand,
							Variant = 0,
							Row = -1,
							Script = "scripts/entity/tactical/humans/caravan_hand",
							Faction = this.Const.Faction.PlayerAnimals,
							Callback = null
						});
						p.Entities.push({
							ID = this.Const.EntityType.CaravanHand,
							Variant = 0,
							Row = -1,
							Script = "scripts/entity/tactical/humans/caravan_hand",
							Faction = this.Const.Faction.PlayerAnimals,
							Callback = null
						});
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				},
				{
					Text = "后退！",
					function getResult()
					{
						this.Flags.set("IsMerchantInDistress", false);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "MerchantDistressSuccess",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_41.png[/img]{战斗结束了。你让手下剥取几条林德蠕龙的皮，自己则去找那个商人谈话。他鞠躬致谢，亲吻了你没有戒指的手指。%SPEECH_ON%谢谢你，先生，谢谢你！哦，我的货车！我的货物啊！%SPEECH_OFF%他的目光转向商队的残骸。他瘫跪在废墟中，摇着头。%SPEECH_ON%陌生人，我真希望能有点什么来报答您，可全都没了。%SPEECH_OFF%但随即他竖起一根手指，猛地跳起来问你是否带着地图。你展示了你的地图，他掏出一支羽毛笔。%SPEECH_ON%给，我知道有个地方据说藏着重宝。不知是真是假，但万一是真的，这消息可就价值连城了！%SPEECH_OFF%是啊，万一。你还是谢过了商人的好意，祝他前路顺利。至于%companyname%，该返回%employer%那里领取报酬了。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我们哪天有空得去看一下。",
					function getResult()
					{
						this.Contract.setState("Return");
						local bases = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getSettlements();
						local candidates_location = [];

						foreach( b in bases )
						{
							if (!b.getLoot().isEmpty() && !b.isLocationType(this.Const.World.LocationType.Unique) && !b.getFlags().get("IsEventLocation"))
							{
								candidates_location.push(b);
							}
						}

						if (candidates_location.len() == 0)
						{
							return 0;
						}

						local location = candidates_location[this.Math.rand(0, candidates_location.len() - 1)];
						this.World.uncoverFogOfWar(location.getTile().Pos, 700.0);
						location.getFlags().set("IsEventLocation", true);
						location.setDiscovered(true);
						this.World.getCamera().moveTo(location);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "MerchantDistressFailure",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_60.png[/img]{战斗结束了。你让一半人手去剥取林德蠕龙的皮，以便返回时向%employer%展示。另一半人则翻找商人车队的残骸。找不到什么值得注意的东西，连金币都没有。任何值钱的物件都在战斗中被砸得粉碎。商人本人已被撕成两半，双腿落在不远处，口袋外翻空空如也，%randombrother%正蹲在残骸旁。他点了点头。%SPEECH_ON%唉，这死法可真够惨的。生前身无分文，死后没个全尸。%SPEECH_OFF%你点头回应，随即朝兄弟们喊话，让他们收拾行装。是时候返回雇主那里领取报酬了。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "至少我们了结了那些野兽。",
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
			ID = "Victory",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_130.png[/img]{与林德蠕龙的战斗，如同握着餐刀捅进一筐毒蛇。它们战斗的方式仿佛来自另一个世界，嘶嘶作响，喷吐毒液，疯狂撕咬，但它们终究不是%companyname%的决心与技艺的对手。你让手下剥取这些生物的头皮和毛皮，准备好返回%employer%那里领取应得的报酬。 | 林德蠕龙罪有应得地化为狼藉。你的战团成员们远远地戳弄着尸体，确保这些杂种死透了。有几条还在发出咯咯声并翻动身体，但这大概是它们最后的生机了。你下令将这些超大体型的蜥蜴剥皮取鳞。毕竟，%employer%会等着看证据。 | 你蹲伏在一头林德蠕龙旁，用手拂过它的表皮。依你看，这鳞片又长又利，要是手指卡进鳞片缝隙里，怕是能被切掉。接着你叉腰立于其头颅上方，凝视着它的巨口，用手比量着它的牙齿，用你的剑锋探了探它的咽喉。%randombrother%来到你身边，询问接下来该做什么。你从林德蠕龙的喉咙里抽出剑，擦干净，利落地归鞘。你命令手下剥几张兽皮，准备返回%employer%处。 | 战斗结束，你让人剥下林德蠕龙的皮，并处理所有有价值的部分。没过多久，战场上就弥漫起蜥蜴类常有的腥臭，这些过于超大蜥蜴被剥去了曾经保护它们的鳞甲。它们病态而湿滑的肌肉组织暴露无遗，一种赤裸与脆弱被强加于这些怪物身上。%randombrother%哼了一声，用袖子擦了擦鼻子。他对着自己的手艺点了点头。%SPEECH_ON%说到底也就是个普通畜生，只不过个头大了那么一点点。%SPEECH_OFF%说得太对了。你命令手下收集好战利品，准备返回%employer%那里。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们做到了。",
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
			Text = "[img]gfx/ui/events/event_77.png[/img]{你拖着一些林德蠕龙的尸块走进%employer%的房间。他从桌案上抬起头，看了眼那鳞片和长长的龙皮，瞥了你一眼，然后看向他的出纳员，沉稳地点了点头。出纳员拿起一袋克朗递了过来。%employer%重新投入工作，一边用羽毛笔书写一边对你说道。%SPEECH_ON%干得好，佣兵。关于那些杂种的报告已经完全停止了，所以我敢说我们的钱花在了刀刃上。皮留下。我认识个匠人能用它做几双不错的靴子。%SPEECH_OFF%搞半天%companyname%只是为了给这蠢货弄双新靴子？你摇摇头，转身离开。 | %employer%对你和你带来的战利品表示欢迎——那是一长条粗糙、多鳞、刮擦作响的林德蠕龙皮。你把它重重地扔在地板上，它像件硬皮外套一样滑了一段。镇长点了点头。%SPEECH_ON%非常，非常好，先生！太出色了。你的报酬，如约奉上。%SPEECH_OFF%他递给你一个沉甸甸的钱袋，里面装着你应得的克朗。 | 你发现%employer%正坐在火边取暖。他在座位上转过身，看到了你带进来的林德蠕龙尸块。镇长点了点头。%SPEECH_ON%干得不错，佣兵。我很好奇，那些蜥蜴杂种能重新长出肢体吗？我听说壁虎有这种把戏。%SPEECH_OFF%你耸耸肩，说每只怪物都是带着一把好剑所能调动的全部研究精神被干掉的。%employer%抿嘴道。%SPEECH_ON%啊。好吧。你的报酬在那边角落，按约定好的数目。%SPEECH_OFF%他回到火堆旁，舒服地裹紧毯子，小口喝着热气腾腾的杯子。 | 你发现%employer%在外面，被一群喧闹的农民围着。你压过人群的嘈杂声大喊，并展示了你带来的林德蠕龙皮。人群安静了片刻，内部窃窃私语，然后又恢复了叫嚷。你咬着嘴唇，用胳膊肘挤过人群，要求支付你应得的报酬。%employer%对着这些乡巴佬大喊，让他们散开，给他喘口气。在两个守卫的贴身护卫下，他递给你一个皮革钱袋。%SPEECH_ON%干得好，佣兵。要是数目不对，随时回来杀了我。我不会介意的，不想过这该死的日子了。%SPEECH_OFF%当你接过钱袋离开时，一个农民用手指戳着镇长。%SPEECH_ON%我跟你说，那个该死的混蛋，我那个所谓的‘好邻居’，偷了我的鸟！要是他不还回来，我他妈就把他整个农场烧成平地！%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "清除城镇附近的林德蠕龙");
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
			ID = "Failure",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_43.png[/img]{你在%employer%的房间里找到了他，里面站满了守卫。虽然不清楚发生了什么，你还是向镇长展示了林德蠕龙的皮并要求支付报酬。他的手指先是一拍，随即像向前来回摆动。%SPEECH_ON%我觉得这恐怕不行，佣兵。我不知道你从哪儿弄来这该死的皮套，相信我，我瞧得出这玩意儿旧得不行，根本不是新剥的皮，而且我现在还不断接到报告，说有蜥蜴在后方的土地上撕开新的口子。所以如果你不介意，请行个方便，在我放出另一种掠食者对付你之前，乖乖离开这个镇子。%SPEECH_OFF%你深吸一口气，扫视着守卫。人数太多，难以对付。%employer%叹了口气。%SPEECH_ON%如果你还想维护你那点荣誉，省省吧。在你进门之前，我已经劝住了这帮人，没让他们当场伏击你。我这么做是出于仅存的一点尊重。别浪费它，嗯？%SPEECH_OFF%好吧。事已至此，反正你也怪不了别人，只能怪自己。你关上门，离开了。}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "不足为奇。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail * 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 2, "试图骗取镇上的钱");
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
			"bribe",
			this.m.Flags.get("Bribe")
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
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/ambushed_trade_routes_situation"));
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
				this.m.Target.getController().getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(true);
				this.m.Target.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(true);
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
