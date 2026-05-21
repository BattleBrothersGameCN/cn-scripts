this.hunting_hexen_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		Dude = null,
		IsPlayerAttacking = true
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_hexen";
		this.m.Name = "与女巫的契约";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 900 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		this.m.Flags.set("ProtecteeName", this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"呆在%townname%附近，保护%employer%的长子"
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

				if (r <= 20)
				{
					this.Flags.set("IsSpiderQueen", true);
				}
				else if (r <= 40)
				{
					this.Flags.set("IsCurse", true);
				}
				else if (r <= 50)
				{
					this.Flags.set("IsEnchantedVillager", true);
				}
				else if (r <= 55)
				{
					this.Flags.set("IsSinisterDeal", true);
				}

				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				this.Flags.set("Delay", this.Math.rand(10, 30) * 1.0);
				local envoy = this.World.getGuestRoster().create("scripts/entity/tactical/humans/firstborn");
				envoy.setName(this.Flags.get("ProtecteeName"));
				envoy.setTitle("");
				envoy.setFaction(1);
				this.Flags.set("ProtecteeID", envoy.getID());
				this.Contract.m.Home.setLastSpawnTimeToNow();
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Home != null && !this.Contract.m.Home.isNull())
				{
					this.Contract.m.Home.getSprite("selection").Visible = true;
				}

				this.World.State.setUseGuests(true);
			}

			function update()
			{
				if (!this.Contract.isPlayerNear(this.Contract.getHome(), 600))
				{
					this.Flags.set("IsFail2", true);
				}

				if (this.Flags.has("IsFail1") || this.World.getGuestRoster().getSize() == 0)
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.has("IsFail2"))
				{
					this.Contract.setScreen("Failure2");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.has("IsVictory"))
				{
					if (this.Flags.get("IsCurse"))
					{
						local bros = this.World.getPlayerRoster().getAll();
						local candidates = [];

						foreach( bro in bros )
						{
							if (bro.getSkills().hasSkill("trait.superstitious"))
							{
								candidates.push(bro);
							}
						}

						if (candidates.len() == 0)
						{
							this.Contract.setScreen("Success");
						}
						else
						{
							this.Contract.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];
							this.Contract.setScreen("Curse");
						}
					}
					else if (this.Flags.get("IsEnchantedVillager"))
					{
						this.Contract.setScreen("EnchantedVillager");
					}
					else
					{
						this.Contract.setScreen("Success");
					}

					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("StartTime") + this.Flags.get("Delay") <= this.Time.getVirtualTimeF())
				{
					if (this.Flags.get("IsSpiderQueen"))
					{
						this.Contract.setScreen("SpiderQueen");
					}
					else if (this.Flags.get("IsSinisterDeal") && this.World.Assets.getStash().hasEmptySlot())
					{
						this.Contract.setScreen("SinisterDeal");
					}
					else
					{
						this.Contract.setScreen("Encounter");
					}

					this.World.Contracts.showActiveContract();
				}
				else if (!this.Flags.get("IsBanterShown") && this.Math.rand(1, 1000) <= 1 && this.Flags.get("StartTime") + 6.0 <= this.Time.getVirtualTimeF())
				{
					this.Flags.set("IsBanterShown", true);
					this.Contract.setScreen("Banter");
					this.World.Contracts.showActiveContract();
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getID() == this.Flags.get("ProtecteeID"))
				{
					this.Flags.set("IsFail1", true);
					this.World.getGuestRoster().clear();
				}
			}

			function onActorRetreated( _actor, _combatID )
			{
				if (_actor.getID() == this.Flags.get("ProtecteeID"))
				{
					this.Flags.set("IsFail1", true);
					this.World.getGuestRoster().clear();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Hexen")
				{
					this.Flags.set("IsVictory", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Hexen")
				{
					this.Flags.set("IsFail2", true);
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
			Text = "[img]gfx/ui/events/event_79.png[/img]{你看见%employer%脖子上挂着块肩胛骨，不过上面原本该有的巫术装饰都被大蒜和洋葱取代了。他眼里含着泪水。%SPEECH_ON%天呐佣兵，见到你太好了！快请坐。%SPEECH_OFF%你低头避开那些挂满香草的飘带，走到他对面坐下。眼睛被熏得发酸，开始流泪。他继续说道。%SPEECH_ON%听着，这事说出来你肯定会觉得我是你见过最该死的蠢货——但很多年前我的长子%protectee%刚出生就重病缠身。走投无路之下，我求助了女巫……%SPEECH_OFF%你抬手打断，问他是不是订了契约，现在对方要来讨债。他点头。%SPEECH_ON%是啊。她们答应给我十八年，今晚就是他在出生的第十八个年头。这可不是简单差事，佣兵。那些女人比任何刀剑都危险，等她们发现我要赖账，肯定会更加疯狂。你确定要帮我保护孩子吗？%SPEECH_OFF%你擦着眼泪，权衡起眼前的选择…… | 你在房间角落找到%employer%。他正像只探出洞穴的土拨鼠般扭着身子望向窗外。见你的影子笼罩过来，他吓得跳起来捂住胸口。但这副窝囊相可不是笑话，他急切地凑近你。%SPEECH_ON%女巫诅咒了我全家！确切说是我的血脉。再确切点是我的长子%protectee%。好多年前我总没法......你懂的，和我老婆行房。就找女巫帮忙，她们给了剂助兴的药。现在这些女巫果然没安好心，要抓我长子抵债！%SPEECH_OFF%你对女巫的行径感到惊讶并表示同情。%employer%立刻打断。%SPEECH_ON%这可不是闹着玩的！我得保护长子，你到底愿不愿意帮忙救%protectee%？%SPEECH_OFF% | 你看见%employer%正在疯狂翻书。那架势分明是早已翻烂这些书，现在不过是在徒劳地寻找漏掉的线索。最终他暴怒地将厚书全扫下桌。见到你后，他抹着额头解释。%SPEECH_ON%我翻遍所有典籍找解决办法，现在看来只能靠刀剑了——就是你的刀剑，佣兵。实话跟你说，多年前为了救我长子%protectee%摆脱恶疾，我和女巫做了交易。孩子活下来了，但现在那些恶婆娘要来抓他抵债。%SPEECH_OFF%你点头，这简直和放贷人的手段一样下作。他把手指狠狠戳在桌面上继续道。%SPEECH_ON%我需要你在这里，佣兵。需要你的剑护着%protectee%平安度过今夜，宰了那些该死的妖婆，让我的血脉能延续下去。你肯帮忙吗？%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{要想让我们对付这种敌人，你得掏大钱才行。 | 用满满一袋克朗来说服我这事值得干。 | 对付这种敌人，我指望的酬劳可不少。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{要我说你就该照契约办。 | 这风险不值当。 | 我可不想让战团跟这种敌人掺和。}",
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
			Text = "[img]gfx/ui/events/event_79.png[/img]{%randombrother%走到你身边，正用小指掏着耳朵。%SPEECH_ON%喂队长，见到那些风骚娘们没？%SPEECH_OFF%听到这，%randombrother2%也凑了过来。%SPEECH_ON%我听说那些女巫确实漂亮，但这就是她们忽悠人的把戏。先用媚术把你迷得团团转，再把你的灵魂生吞活剥。%SPEECH_OFF%%randombrother%大笑着把耳垢抹在%randombrother2%的衣服上。%SPEECH_ON%那么她们得到%randomtown%找我灵魂了，早被别的娘们抢先啦。%SPEECH_OFF% | 你正在清点物资时%randombrother%过来了。之前派他去周边侦察，现在他来汇报情况。%SPEECH_ON%长官，目前没看到什么，不过我跟本地人聊了聊。据说女巫会跟普通人立契约，过些年连本带利讨债。他们说女巫能让你把她们看成放荡娘们，直接把你睡进坟墓！要我说这纯属胡说八道。%SPEECH_OFF%你点头同意他的说法。%SPEECH_ON%不过要是真的，看一眼也不是不行。%SPEECH_OFF% | 兄弟们正在闲扯消磨时间，争论女人和女巫到底有啥本质区别。%randombrother%伸手比划着。%SPEECH_ON%说正经的，我听过这些娘们的传说。她们会下咒让你产生幻觉，逼你签血契，要是赖账就把你膝盖骨挖出来占卜。我小时候邻居跟女巫做交易后就失踪了，后来我看见个神秘女人提着新鲜头骨当灯笼！%SPEECH_OFF%%randombrother2%认真点头。%SPEECH_ON%真邪乎，所以到底有人知道女巫会干啥不？%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "保持专注，小伙子们。",
					function getResult()
					{
						if (this.Flags.get("StartTime") + this.Flags.get("Delay") - 3.0 <= this.Time.getVirtualTimeF())
						{
							this.Flags.set("Delay", this.Flags.get("Delay") + 5.0);
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SpiderQueen",
			Title = "%townname%附近",
			Text = "[img]gfx/ui/events/event_106.png[/img]{一个孤身女子从两棵树之间的空隙走近。 她悠闲地走着，大腿在丝绸裙子间时隐时现。她的皮肤完美无瑕，翡翠般的眼睛在红发间透露出你自少年时代后就没见过的放荡神情。你知道这女人是个女巫，因为这般完美的存在不可能出现在这个世界上，尤其是在这种地方。你拔出剑，让她体面地迎接死亡。女巫的皮肤瞬间皱缩，露出真实而恐怖的原形，她发出欣喜的尖笑。%SPEECH_ON%啊，刚才差点就迷住你了，不过欲望消退，傲气又回来了。你身上的气味真让人愉悦，佣兵。我会让他们把你留给我独自享用的。%SPEECH_OFF%你还没来得及问她是什么意思，她站立处的两棵树就绽放出伸展的蜘蛛腿。巨大的黑色球体从灌木丛中冒出，迅速爬到了下方的地面上，这些蛛魔饥渴地叩击着它们的颚骨。女巫举起双手，手指像操纵天上云朵的木偶师般舞动起来。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Hexen";
						p.Entities = [];
						p.Music = this.Const.Music.CivilianTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.Entities.push({
							ID = this.Const.EntityType.Spider,
							Variant = 0,
							Row = 1,
							Script = "scripts/entity/tactical/enemies/spider_bodyguard",
							Faction = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID(),
							Callback = null
						});
						p.Entities.push({
							ID = this.Const.EntityType.Spider,
							Variant = 0,
							Row = 1,
							Script = "scripts/entity/tactical/enemies/spider_bodyguard",
							Faction = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID(),
							Callback = null
						});
						p.Entities.push({
							ID = this.Const.EntityType.Hexe,
							Variant = 0,
							Row = 2,
							Script = "scripts/entity/tactical/enemies/hexe",
							Faction = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID(),
							function Callback( _e, _t )
							{
								_e.m.Name = "蜘蛛女王";
							}

						});
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Spiders, 50 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SinisterDeal",
			Title = "%townname%附近",
			Text = "[img]gfx/ui/events/event_106.png[/img]{%randombrother%吹着口哨对突然出现在战团面前搔首弄姿的美女们脱帽致意。你拦住这个佣兵，自己迈步上前，但还没开口，其中一个女子就举起双手迎向你。%SPEECH_ON%让你看看我的真面目，佣兵。%SPEECH_OFF%她的双臂垂到身侧，变得灰暗枯萎，就像浸过水的杏仁外皮。曾经亮泽的丝滑长发大把脱落，直到露出她那丑陋的头骨，最后几根发根上沾满了蚊虫和虱子，就像濒死世界最后的残留。她欠身行礼，仰起脸对你露出蜡黄色的狞笑。%SPEECH_ON%我们拥有强大的力量，佣兵，这点你很清楚。我跟你做个交易。%SPEECH_OFF%她双手各拿出一个小瓶子，一个装着绿色液体，另一个装着蓝色液体。她微笑着，说话时手指转动着瓶子。%SPEECH_ON%一瓶强身，一瓶健魄。多少人为了得到它们不惜杀人。我任选一瓶交换那个长子的命。陌生人的孩子能值几个钱？你杀的人也不少了，对吧？让开，佣兵，把这猎物交给我们。或者选择跟我们作对，让你手下和你自己都冒生命危险，就为了个迟早会忘了你长相的小鬼。你自己选。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我绝不会把那孩子交给你们这些老妖婆。准备作战！",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Hexen";
						p.Entities = [];
						p.Music = this.Const.Music.CivilianTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.HexenAndNoSpiders, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				},
				{
					Text = "我想要能强身的那瓶药水。",
					function getResult()
					{
						return "SinisterDealBodily";
					}

				},
				{
					Text = "我想要能健魄的那瓶药水。",
					function getResult()
					{
						return "SinisterDealSpiritual";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SinisterDealBodily",
			Title = "%townname%附近",
			Text = "[img]gfx/ui/events/event_106.png[/img]{女巫露出微笑。%SPEECH_ON%男人要是没有能在这世上闯荡的强健体魄，就什么都不是。拿去吧佣兵，可别浪费了。%SPEECH_OFF%她将小瓶抛向你。药瓶在空中旋转翻腾，洒落的翠绿光影掠过大地，每一道微光触地即从荒芜泥土中绽出细小花朵。你接住玻璃瓶，它在掌心微微震颤，骨头的酸痛渐渐消散，仿佛这只拳头一直处于麻木而你从未察觉。当你抬头想要追问时，女巫们早已消失无踪。唯余一声孤零零的哀嚎从远方传来，无法判断究竟有多遥远。那无疑是%employer%长子临终的惨叫。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "这交易太划算了，没法拒绝。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 2, "背叛了" + this.Contract.getEmployer().getName() + "，并与女巫达成了协议");
						this.World.Contracts.finishActiveContract(true);
						return;
					}

				}
			],
			function start()
			{
				local item = this.new("scripts/items/special/bodily_reward_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "你获得了" + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "SinisterDealSpiritual",
			Title = "%townname%附近",
			Text = "[img]gfx/ui/events/event_106.png[/img]{女巫手腕一抖，将绿色小瓶滑入袖中，把剩下的蓝色小瓶递给你。%SPEECH_ON%你是个聪明人，佣兵。%SPEECH_OFF%她粗重地哼了一声，肥大的鼻子瞬间萎缩成蛆虫粗细又弹回原状。%SPEECH_ON%我确实嗅到你血脉里的精明，佣兵。差点就想把你的血占为己有了。%SPEECH_OFF%她盯着你的眼神活像猫盯着被扯掉腿却还在挣扎的蟋蟀。但之后笑容重新浮现，只不过这露齿一笑露出来的只有寥寥几颗黑牙。%SPEECH_ON%罢了，我们说好了的。拿去吧。%SPEECH_OFF%她凌空抛来小瓶，待你接住再抬头时女巫们已无影无踪。远处隐约传来凄厉惨叫，仿佛近在咫尺又远在天边，你确信那正是%employer%长子临终的哀嚎。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "这交易太划算了，没法拒绝。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 2, "背叛了" + this.Contract.getEmployer().getName() + "，并与女巫达成了协议");
						this.World.Contracts.finishActiveContract(true);
						return;
					}

				}
			],
			function start()
			{
				local item = this.new("scripts/items/special/spiritual_reward_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "你获得了" + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Encounter",
			Title = "%townname%附近",
			Text = "[img]gfx/ui/events/event_106.png[/img]{%randombrother%吹了了个口哨喊道。%SPEECH_ON%有人来了，好……漂亮的美人……%SPEECH_OFF%一个妖艳的女人正朝队伍走来。她步履轻盈地摇曳前行，一根手指把玩着耳垂，另一只手捏着垂在丰腴胸脯前的挂坠石。你拍了拍佣兵的肩膀。%SPEECH_ON%那可不是普通女人。%SPEECH_OFF%话音未落，那女子丰润年轻的面容瞬间皱缩成灰暗的沟壑，浓密秀发从头顶枯萎脱落，眼前只剩下满脸恶毒笑容的老巫婆。准备战斗！保护%protectee%的安全！ | 你注意到有个女人正在靠近队伍。她身着鲜红衣裙，项链在丰腴的胸脯前摇曳生姿。这景象确实迷人，但她完美得不似凡人——这世上根本不存在如此完美之物。\n\n你立即拔剑出鞘。那女子看到钢剑后对你露出狡黠狞笑。大把头发从她头顶脱落，残余的发丝枯缩成灰白鬃毛，皮肤塌陷成苍白的沟壑，指甲暴长蜷曲。她伸手指着你尖啸，宣称没人能阻止契约生效。你立即朝战团高喊，要求确保%protectee%远离危险。 | 队员们发现有个女人正在接近。佣兵们都被她的美色迷惑，但你心知有异。拔剑时的铿锵声引起了这位古怪美女的注意。她嗤笑着咧开横贯双耳的嘴角，皮肤紧绷泛起灰白褶皱，在阵阵狂笑中头发簌簌脱落。女巫伸手指向你。%SPEECH_ON%呵，我嗅到了你的血脉，佣兵，不过你的来历无关紧要。契约必须用长子的鲜血偿还，任何阻拦者都将付出同等代价！%SPEECH_OFF%战团迅速列阵，你厉声嘱咐%protectee%压低身子。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Hexen";
						p.Entities = [];
						p.Music = this.Const.Music.BeastsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.HexenAndNoSpiders, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Curse",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_124.png[/img]{就在准备带队返回%employer%，你发现%superstitious%正低头盯着一个女巫。你看见那该死的女人嘴唇还在蠕动，立即冲了过去。她正低声念着诅咒，你直接用靴跟踹上去让她闭嘴。她居然还在发笑，牙齿从破裂的牙龈中飞落。你拔剑刺入她双眉之间，终于让她彻底安息。%superstitious%吓得浑身发抖。%SPEECH_ON%她都知道！她什么都知道，队长！她全知道！她知道我什么时候死，怎么死！%SPEECH_OFF%你让他别把女巫的话放在心上。他点头归队，但脸上仍凝固着那些无法当作没听见的可怕预言。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "想都别想。",
					function getResult()
					{
						return "Success";
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
				local effect = this.new("scripts/skills/effects_world/afraid_effect");
				this.Contract.m.Dude.getSkills().add(effect);
				this.List.push({
					id = 10,
					icon = effect.getIcon(),
					text = this.Contract.m.Dude.getName() + "害怕了"
				});
				this.Contract.m.Dude.worsenMood(1.5, "被女巫诅咒了");

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
			ID = "EnchantedVillager",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_124.png[/img]{正当伙计们在战斗后重整队伍时，一个年轻农民哭喊着跑过战场。你转头看见他扑倒在女巫跟前，抱起那具狰狞干瘪的尸体紧紧搂在怀中来回摇晃。见到你，他厉声咒骂起来。%SPEECH_ON%为什么这么做？你们这些天杀的杂种！她半月前才嫁给我，现在却要我亲手埋葬！把我也带走吧！来啊你们这些野蛮人！让这世界将我们一同埋葬，我的爱人！%SPEECH_OFF%你挑起眉毛。这人准是在你们到来前就中了邪，多半成了女巫的走狗。不论真相如何，几个队员都被这悲痛欲绝的小伙子搅得心神不宁。这时有个老练的佣兵咧嘴一笑按着武器，问要不要成全这小子。你摇头否决，下令全员整队待命。} ",
			Image = "",
			List = [],
			Options = [
				{
					Text = "可怜的东西。",
					function getResult()
					{
						return "Success";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_124.png[/img]{战斗结束后，%randombrother%来到你身边。他说%protectee%在战斗中死了。眼球和舌头都不见了，整张脸就像两块湿抹布绞缠在一起。现在没必要回去见%employer%了。 | 你低头看向%protectee%的尸体。眼球被扯出眼眶，带出的神经像湿漉漉的肠子般垂在脸颊上。他的脸被扯出一个笑容，但造成这副模样的原因可一点都不好笑。%randombrother%问战团是否该回去见%employer%，你摇了摇头。 | 你发现%employer%的长子蜷缩在地上。每个关节都被掏空或割开，至于这是何时又如何发生的，你毫无头绪。%randombrother%试图移动尸体，但它像断线的木偶般扭曲作响。佣兵咧着嘴把尸体扔回地面，整个身体便蜷缩成一团，头颅像鸟巢中的蛋般搁在其中。现在没必要回去见%employer%了。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "该死，该死，该死！",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "未能保护好" + this.Contract.getEmployer().getName() + "的长子。");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Failure2",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_16.png[/img]{%employer%付钱让你保护%protectee%。可你既然离开%townname%把他丢给女巫，还谈什么保护长子。不必回去领酬劳了。 | 你的任务是在%townname%确保%protectee%的安全，难道你忘了？ 不必回去了，长子要么已经丧命，要么更惨，被女巫抓去干邪恶勾当了。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "哦，该死的。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "未能保护好" + this.Contract.getEmployer().getName() + "的长子。");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_79.png[/img]{%employer%紧紧抱住%protectee%。他看向你。%SPEECH_ON%这么说都结束了？女巫全死光了？%SPEECH_OFF%你点头。这位镇民也点头回应。%SPEECH_ON%谢谢你！太感谢了，佣兵！%SPEECH_OFF%他指向房间角落的一个箱子，里面装满了你的酬金。 | 你把%protectee%带回给%employer%。镇民和长子相拥的画面，看起来就像对同一经历的不同梦境，尽管现实诸多阻碍，它们终究缓缓相融。最后他们紧紧相拥，又停下来凝视彼此，确认这一切都是真实的。你告诉%employer%所有女巫都死了，但他最好对此事保密。他点头。%SPEECH_ON%鬼魂们以傲慢为食，这道理我懂。我会把这个秘密带进坟墓。感谢你今天所做的一切，佣兵。我的感激之情远超你的想象。我只有一种方式表达谢意。%SPEECH_OFF%他交给你一袋金子。 看着鼓胀的钱袋，你脸上露出欣慰的笑容。 | %protectee%从你身边跑向%employer%的怀抱。镇民从长子的肩头望过来。%SPEECH_ON%那么都结束了？我们摆脱诅咒了？%SPEECH_OFF%你耸耸肩回应。%SPEECH_ON%你们已经摆脱女巫了。%SPEECH_OFF%镇民抿着嘴点头。%SPEECH_ON%好吧，这就够了。说好的酬金在那边钱袋里。%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "到头来还算顺利。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "成功保护了" + this.Contract.getEmployer().getName() + "的长子。");
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
			"superstitious",
			this.m.Dude != null ? this.m.Dude.getName() : ""
		]);
		_vars.push([
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Target.getTile())]
		]);
		_vars.push([
			"protectee",
			this.m.Flags.get("ProtecteeName")
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/abducted_children_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.m.Home.getSprite("selection").Visible = false;
			this.World.State.setUseGuests(true);
			this.World.getGuestRoster().clear();
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
