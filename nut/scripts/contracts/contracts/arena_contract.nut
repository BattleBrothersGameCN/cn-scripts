this.arena_contract <- this.inherit("scripts/contracts/contract", {
	m = {},
	function create()
	{
		this.contract.create();
		this.m.DifficultyMult = 1.0;
		this.m.Type = "contract.arena";
		this.m.Name = "竞技场";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 1.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.setup();
		this.contract.start();
	}

	function setup()
	{
		this.m.Flags.set("Number", 0);
		local pay = 550;

		if (this.m.Home.hasSituation("situation.bread_and_games"))
		{
			pay = pay + 100;
		}

		local twists = [];

		if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 5)
		{
			twists.push({
				R = 5,
				F = "IsSwordmaster",
				P = 50
			});
		}

		if (this.Const.DLC.Wildmen && this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 15)
		{
			twists.push({
				R = 2,
				F = "IsSwordmasterChampion",
				P = 150
			});
		}

		if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 5)
		{
			twists.push({
				R = 5,
				F = "IsHedgeKnight",
				P = 50
			});
		}

		if (this.Const.DLC.Wildmen && this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 15)
		{
			twists.push({
				R = 2,
				F = "IsExecutionerChampion",
				P = 150
			});
		}

		if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 5)
		{
			twists.push({
				R = 5,
				F = "IsDesertDevil",
				P = 50
			});
		}

		if (this.Const.DLC.Wildmen && this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 15)
		{
			twists.push({
				R = 2,
				F = "IsDesertDevilChampion",
				P = 150
			});
		}

		if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 5)
		{
			twists.push({
				R = 5,
				F = "IsMercenaries",
				P = 0
			});
		}

		if (this.Const.DLC.Unhold && this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 6)
		{
			twists.push({
				R = 5,
				F = "IsUnholds",
				P = 100
			});
		}

		if (this.Const.DLC.Lindwurm && this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 10)
		{
			twists.push({
				R = 5,
				F = "IsLindwurm",
				P = 200
			});
		}

		if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 3)
		{
			twists.push({
				R = 5,
				F = "IsSandGolems",
				P = 50
			});
		}

		if (this.Const.DLC.Wildmen && this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 3)
		{
			twists.push({
				R = 15,
				F = "IsGladiators",
				P = 0
			});
		}

		if (this.Const.DLC.Wildmen && this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 15)
		{
			twists.push({
				R = 5,
				F = "IsGladiatorChampion",
				P = 150
			});
		}

		if (this.Const.DLC.Unhold && this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") <= 5)
		{
			twists.push({
				R = 10,
				F = "IsSpiders",
				P = -75
			});
		}

		if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") <= 3)
		{
			twists.push({
				R = 10,
				F = "IsHyenas",
				P = 0
			});
		}
		else
		{
			twists.push({
				R = 10,
				F = "IsFrenziedHyenas",
				P = 0
			});
		}

		twists.push({
			R = 10,
			F = "IsGhouls",
			P = 0
		});
		twists.push({
			R = 15,
			F = "IsDesertRaiders",
			P = 0
		});
		twists.push({
			R = 10,
			F = "IsSerpents",
			P = 0
		});
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
				this.m.Flags.set(t.F, true);
				pay = pay + t.P;
				  // [460]  OP_JMP            0      5    0    0
			}
			else
			{
				r = r - t.R;
			}
		}

		this.m.Payment.Pool = pay * this.getPaymentMult() * this.getReputationToPaymentMult();
		this.m.Payment.Completion = 1.0;
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"给至多三人装备竞技场项圈",
					"再次进入竞技场，开始战斗",
					"这场战斗将一决生死，你将无法撤退或获得战利品"
				];
				this.Contract.m.BulletpointsPayment = [
					"奖金为" + this.Contract.m.Payment.getOnCompletion() + "克朗"
				];

				if (this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") > 0 && this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") % 5 == 0)
				{
					this.Contract.m.BulletpointsPayment.push("赢得一件角斗士装备。");
				}

				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.Flags.set("Day", this.World.getTime().Days);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Flags.get("IsVictory"))
				{
					this.Contract.setScreen("Success");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsFailure"))
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.World.getTime().Days > this.Flags.get("Day"))
				{
					this.Contract.setScreen("Failure2");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Arena")
				{
					this.Flags.set("IsVictory", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Arena")
				{
					this.Flags.set("IsFailure", true);
				}
			}

		});
	}

	function createScreens()
	{
		this.m.Screens.push({
			ID = "Task",
			Title = "在竞技场",
			Text = "",
			Image = "",
			List = [],
			ShowDifficulty = true,
			Options = [
				{
					Text = "{用鲜血染红这片沙漠! | 让人群高呼我们的名字! | 杀他们就像屠猪宰羊!}",
					function getResult()
					{
						return "Overview";
					}

				},
				{
					Text = "{这和我想得不一样。 | 我会退出这场比赛。 | 我等下场战斗再来。}",
					function getResult()
					{
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.State.getTownScreen().getMainDialogModule().reload();
						return 0;
					}

				}
			],
			function start()
			{
				this.Text = "[img]gfx/ui/events/event_155.png[/img]数十名男子聚集在竞技场的入口。有些人沉默不语，不愿透露自己的能力。然而，另一些人则趾高气昂，夸夸其谈，他们要么是发自内心地信任自己的武艺，要么是希望通过虚张声势掩盖技艺上的漏洞。\n\n";
				this.Text += "一位头发花白的男子，竞技场的主人，举起了一卷卷轴，并用替下了手掌的钩子轻轻敲了敲它。";
				local baseDifficulty = 30;

				if (this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") > 0 && this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") % 5 == 0)
				{
					baseDifficulty = baseDifficulty + 10;
				}

				baseDifficulty = baseDifficulty * this.Contract.getScaledDifficultyMult();

				if (this.Flags.get("IsSwordmaster"))
				{
					if (baseDifficulty < this.Const.World.Spawn.Troops.Swordmaster.Cost + this.Const.World.Spawn.Troops.BanditRaider.Cost)
					{
						this.Flags.set("Number", 0);
						this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战一名剑术大师";
					}
					else
					{
						this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.BanditRaider, baseDifficulty - this.Const.World.Spawn.Troops.Swordmaster.Cost, 2));
						this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战一名剑术大师和%amount%名掠袭者";
					}

					this.Text += "%SPEECH_ON%他的名字旁边标上了一颗星，那是镀金者的标志。这意味着他的道路是金光铺就的。你知道他是一位剑术大师就行了。你可能觉得他年纪大了没什么威胁，但你不是第一个，明白吗？愿你走在金光大道上，因为这位剑术大师肯定如此。%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsHedgeKnight"))
				{
					if (baseDifficulty < this.Const.World.Spawn.Troops.HedgeKnight.Cost + this.Const.World.Spawn.Troops.BanditRaider.Cost)
					{
						this.Flags.set("Number", 0);
						this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战一名雇佣骑士";
					}
					else
					{
						this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.BanditRaider, baseDifficulty - this.Const.World.Spawn.Troops.HedgeKnight.Cost, 2));
						this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战一位雇佣骑士和%amount%名掠袭者";
					}

					this.Text += "%SPEECH_ON%我认为北方人称他为“雇凶骑士”。也可能我说的不对。不要告诉其他角斗场主我在说北方垃圾的话，但这个骑士的确是我在这里见过的最危险的人之一，如果你希望你的道路继续被镀金，那么我建议你做足准备，在战斗前好好休息一下。%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsDesertDevil"))
				{
					if (baseDifficulty < this.Const.World.Spawn.Troops.DesertDevil.Cost + this.Const.World.Spawn.Troops.NomadOutlaw.Cost)
					{
						this.Flags.set("Number", 0);
						this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战一名剑舞者";
					}
					else
					{
						this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, baseDifficulty - this.Const.World.Spawn.Troops.DesertDevil.Cost, 2));
						this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战一名剑舞者和%amount%名游牧民";
					}

					this.Text += "竞技场主管举起一张卷轴，用钩手叩了叩。%SPEECH_ON%这一轮登场的将是来自游牧部族的刀锋舞者。你也许觉得他这副模样是言过其实，但只有挥舞起刀剑来都像鸟儿乘风一样自然的人，才能获得“刀锋舞者”的头衔。当然，舞蹈技巧只是额外加分，可他们在这方面都毫不逊色。%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsSandGolems"))
				{
					this.Flags.set("Number", this.Math.max(3, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.SandGolem, baseDifficulty, 3)));
					this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战%amount%只伊弗利特";
					this.Text += "%SPEECH_ON%这页上什么都没画，我怕展示它凶猛的一面会招来沙漠的愤怒。你要打%number%个伊弗利特。我不知道他们怎么弄来的这玩意，只知道是炼金术士干的好事。要是你问我，我宁愿你去打炼金术士，而不是伊弗利特。%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsGhouls"))
				{
					local num = 0;

					if (baseDifficulty >= this.Const.World.Spawn.Troops.GhoulHIGH.Cost * 2)
					{
						num = num + 1;
						num = num + this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Ghoul, baseDifficulty - this.Const.World.Spawn.Troops.GhoulHIGH.Cost);
					}
					else
					{
						num = num + this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.GhoulLOW, baseDifficulty * 0.5);
						num = num + this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Ghoul, baseDifficulty * 0.5);
					}

					this.Flags.set("Number", num);
					this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战%amount%只食尸鬼";
					this.Text += "%SPEECH_ON%炼金术士们称之为，好吧，我念不出来。我的舌头一碰它就打结，这恐怕需要专门的北方词典。我可没时间精简北方的废话，那没有一点好处。难道我像个音韵学家吗？干脆就叫它们“磨牙劈斩者”好了。这些吃尸体的呆子，足足有%number%只之多，我甚至看过它们活生生把人吞掉，所以你最好祈求镀金者注视着你 —— 等你掉到那玩意肚子里就来不及了！%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsUnholds"))
				{
					this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Unhold, baseDifficulty));

					if (this.Flags.get("Number") == 1)
					{
						this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战一头巨魔";
					}
					else
					{
						this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战%amount%只巨魔";
					}

					this.Text += "%SPEECH_ON%你们要对抗%number%只北佬嘴里的”巨魔“。维齐尔为了把它们带来这里花了大把金子，群众们也十分喜欢这些巨型怪物。它们很擅长粉碎战士，有时甚至会把战士抛到人群中去。真是太妙了。我觉得有些待的时间长的巨魔甚至上了这种表演，越来越喜欢，好像它们学会了如何赢得观众的尖叫和欢呼。那种残忍程度非比寻常。不管怎样，愿镀金者注视着你。%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsDesertRaiders"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战%amount%名游牧民";
					this.Text += "%SPEECH_ON%你的对手将会是%number%名最近退役的沙漠土匪。当然了，我指的是被维齐尔的治安官抓走的“退役”。土匪可不会自愿来这儿，哈哈哈！%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsGladiators"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战%amount%名角斗士";
					this.Text += "%SPEECH_ON%哦，呵呵，镀金者肯定有幽默感。你将面对%number%名角斗士。愿你走在金光大道上，但坦白说，我对他们也是这么说的。而且我每天都这么说。明白了吗？你应该尽你所能做好准备。%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsSpiders"))
				{
					this.Flags.set("Number", this.Math.max(3, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Spider, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战%amount%只蛛魔";
					this.Text += "%SPEECH_ON%那不是无花果树，那是只蜘蛛。在炼金术士的认知里，这玩意叫结网蛛，愚蠢的北方名称，这明明就是蜘蛛。不过对你而言，一只鞋子不够拍死它们的，它们足足有%number%只之多。%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsSerpents"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Serpent, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战%amount%条巨蛇";
					this.Text += "%SPEECH_ON%你说你不明白？啊，只画了条波浪线？不。你看，这是尾巴，这是头。这是条蛇。你将对抗%number%条蛇。炼金术士喜欢称之为\'毒蛇\'，但如果我想画条毒蛇，我画个炼金术士不就行了哈哈哈！%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsHyenas"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Hyena, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战%amount%只鬣狗";
					this.Text += "%SPEECH_ON%鬣狗。嘿嘿嘿。鬣狗。确切地说，是%numberC%只尖叫的狗，祝你好运，希望镀金者注视着你。%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsFrenziedHyenas"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.HyenaHIGH, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战%amount%只狂暴的鬣狗";
					this.Text += "%SPEECH_ON%鬣狗。嘿嘿嘿。鬣狗。确切地说，是%numberC%只尖叫的狗，祝你好运，希望镀金者注视着你。%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsLindwurm"))
				{
					this.Flags.set("Number", this.Math.min(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Lindwurm, baseDifficulty - 30)));

					if (this.Flags.get("Number") == 1)
					{
						this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战一条林德蠕龙";
					}
					else
					{
						this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战两条林德蠕龙";
					}

					this.Text += "%SPEECH_ON%你的对手是一只……一只……这是什么？一条蠕虫？绿的。从来没见过这么彩的蠕虫——哦！一条飞龙！不对，“虫需龙”。蠕龙? 一条林德蠕龙！老实说，我不知道这是什么，但我想安排赛程的人不会让你打一只普通的蠕虫。说不定真的是，它们为了取乐让你吃了它。或者他们不是安排赛程，而是安排菜程！嘿嗨嘻嘻吼。哈。%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsMercenaries"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战%amount%名佣兵";
					this.Text += "%SPEECH_ON%是像你一样，从北方冒险来的逐币者。在那里，他们被称为“雇佣剑士”。呦！这是为了强行押韵吗？难道他们不知道并非所有人都用剑吗？那儿的人可不太聪明。这就是为什么我喜欢南方。阳光明净，人也精明。%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsGladiatorChampion"))
				{
					this.Flags.set("Champion1", this.Const.World.Common.generateName(this.Const.World.Spawn.Troops.Gladiator.NameList) + (this.Const.World.Spawn.Troops.Gladiator.TitleList != null ? " " + this.Const.World.Spawn.Troops.Gladiator.TitleList[this.Math.rand(0, this.Const.World.Spawn.Troops.Gladiator.TitleList.len() - 1)] : ""));
					this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, baseDifficulty - this.Const.World.Spawn.Troops.Gladiator.Cost * 2, 2));
					this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战%champion1%和%amount%名角斗士";
					this.Text += "%SPEECH_ON%认识这张脸吗？艺术家们可不会白白花那么多时间又是画册子又发给你们看的。这是%champion1%，是这片土地上最伟大的斗士之一。也许有一天他们会把你的脸蛋也整的这么漂亮，前提是维齐尔能找到那么本事的人，来挽救你，呃，耳朵中间夹着的那些东西，嘿嘿呵。%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsSwordmasterChampion"))
				{
					this.Flags.set("Champion1", this.Const.World.Common.generateName(this.Const.World.Spawn.Troops.Swordmaster.NameList) + (this.Const.World.Spawn.Troops.Swordmaster.TitleList != null ? " " + this.Const.World.Spawn.Troops.Swordmaster.TitleList[this.Math.rand(0, this.Const.World.Spawn.Troops.Swordmaster.TitleList.len() - 1)] : ""));
					this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, baseDifficulty - this.Const.World.Spawn.Troops.Gladiator.Cost * 2, 2));
					this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战%champion1%和%amount%名佣兵";
					this.Text += "%SPEECH_ON%认识这张脸吗？艺术家们可不会白白花那么多时间又是画册子又发给你们看的。这是%champion1%，是这片土地上最伟大的斗士之一。也许有一天他们会把你的脸蛋也整的这么漂亮，前提是维齐尔能找到那么本事的人，来挽救你，呃，耳朵中间夹着的那些东西，嘿嘿呵。%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsExecutionerChampion"))
				{
					this.Flags.set("Champion1", this.Const.World.Common.generateName(this.Const.World.Spawn.Troops.Executioner.NameList) + (this.Const.World.Spawn.Troops.Executioner.TitleList != null ? " " + this.Const.World.Spawn.Troops.Executioner.TitleList[this.Math.rand(0, this.Const.World.Spawn.Troops.Executioner.TitleList.len() - 1)] : ""));
					this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, baseDifficulty - this.Const.World.Spawn.Troops.Gladiator.Cost * 2, 2));
					this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战%champion1%和%amount%名角斗士";
					this.Text += "%SPEECH_ON%认识这张脸吗？艺术家们可不会白白花那么多时间又是画册子又发给你们看的。这是%champion1%，是这片土地上最伟大的斗士之一。也许有一天他们会把你的脸蛋也整的这么漂亮，前提是维齐尔能找到那么本事的人，来挽救你，呃，耳朵中间夹着的那些东西，嘿嘿呵。%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsDesertDevilChampion"))
				{
					this.Flags.set("Champion1", this.Const.World.Common.generateName(this.Const.World.Spawn.Troops.DesertDevil.NameList) + (this.Const.World.Spawn.Troops.DesertDevil.TitleList != null ? " " + this.Const.World.Spawn.Troops.DesertDevil.TitleList[this.Math.rand(0, this.Const.World.Spawn.Troops.DesertDevil.TitleList.len() - 1)] : ""));
					this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, baseDifficulty - this.Const.World.Spawn.Troops.Gladiator.Cost * 2, 2));
					this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战%champion1%和%amount%名游牧民";
					this.Text += "%SPEECH_ON%认识这张脸吗？艺术家们可不会白白花那么多时间又是画册子又发给你们看的。这是%champion1%，是这片土地上最伟大的斗士之一。也许有一天他们会把你的脸蛋也整的这么漂亮，前提是维齐尔能找到那么本事的人，来挽救你，呃，耳朵中间夹着的那些东西，嘿嘿呵。%SPEECH_OFF%";
				}

				if (this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") > 0 && this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") % 5 == 0)
				{
					this.Text += "他停了一下。%SPEECH_ON%这次比赛会有重要来宾观看，所以一切都准备好了，你们要死得惨烈一点，明白吗？如果做不到，那就让你的人在比赛里使出最狠的手段，好好取悦观众。如果能做到，我会额外奖励你一件真正的角斗士装备。%SPEECH_OFF%";
				}

				this.Text += "他指着几个古怪的项圈继续说道。%SPEECH_ON%准备好以后，给参赛的那三个人带上这些项圈，我们好知道谁要进入角斗场。不戴项圈的人都不准进来，别说是你了，维齐尔也不行，我敢说镀金者来了也未必。%SPEECH_OFF%";
			}

		});
		this.m.Screens.push({
			ID = "Overview",
			Title = "Overview",
			Text = "竞技场战斗是这样进行的。你同意这些条款吗？",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我接受。",
					function getResult()
					{
						this.World.Assets.getStash().add(this.new("scripts/items/accessory/special/arena_collar_item"));
						this.World.Assets.getStash().add(this.new("scripts/items/accessory/special/arena_collar_item"));
						this.World.Assets.getStash().add(this.new("scripts/items/accessory/special/arena_collar_item"));
						this.Contract.setState("Running");
						return 0;
					}

				},
				{
					Text = "我得考虑一下。",
					function getResult()
					{
						return 0;
					}

				}
			],
			ShowObjectives = true,
			ShowPayment = true,
			function start()
			{
				this.Contract.m.IsNegotiated = true;
			}

		});
		this.m.Screens.push({
			ID = "Start",
			Title = "在竞技场",
			Text = "[img]gfx/ui/events/event_155.png[/img]{在你候场的时候，人群的嗜血欲望穿过了黑暗，灰尘成片从头顶落下，脚步声轰如雷鸣。他们期待中低语，在杀戮中咆哮。战斗之间的宁静只有片刻，直到刺耳的铁链声拉起了生锈的大门，人群再次沸腾起来。你走到了亮光中，雷鸣般的声音撞击着你的心脏，哪怕是一具僵尸也会心潮澎湃。 | 竞技场的观众摩肩接踵，大部分都喝的酩酊大醉。他们尖叫呐喊，各地的语言混在一起，疯狂的面孔和挥舞的拳头已经足够，他们的血腥欲望无需多言。现在，%companyname%的人将满足这些疯狂的傻瓜。 | 清洁工人在竞技场中匆忙前行。他们拖走尸体，摸走值钱的东西，偶尔还会把战利品扔到人群里，引发一场暴动，一场看台上的竞技场战斗。现在，%companyname%也是这场盛事的一部分。 | 竞技场在等待，人群在沸腾，%companyname%的荣耀一刻已经到来！ | 当%companyname%的士兵迈步走进这个血腥的斗坑时，人群爆发了。尽管这欢呼来自于观众无意识的嗜血，你还是无法控制自己内心的自豪，因为你知道，你的战团将是这场表演的主角。 | 大门升起时，除了锁链的响声、滑轮的吱嘎声和奴隶劳作的哼声外，什么声音也没有。连%companyname%一路走出竞技场，走向沙坑中央，脚踩沙子的声音都十分清晰。一个陌生的声音从竞技场的顶部传来，你无法理解这种语言，但只等这声音回响了一次，观众们就爆发出欢呼和咆哮声。现在，你的人将在凡夫俗子的注视下证明自己。 | %companyname%很少在那些远离暴力的外行人面前完成工作。但在角斗场，平民们渴望死亡和痛苦，他们咆哮着看你的人进入沙坑，怒吼着见证他们准备好战斗。 | 竞技场的形状就像是一个疮疤，天花板被神撕开，揭示了人类的虚荣、嗜血和野蛮。在那里，人们尖叫着，如果鲜血溅到他们身上，他们只会用那污物洗脸并相视一笑。人们为了战利品互相搏斗，为他人的疼痛而狂欢。%companyname%将在这些人的面前战斗，他们将为他们提供娱乐，无上的娱乐。 | 竞技场的观众阶级混杂，贫富部分，只有维齐尔们有自己的独立看台。在%townname%的人民暂时团结起来，慷慨地聚在一起，观看人和怪物互相厮杀。%companyname%很高兴能尽自己的一份力。 | 男孩们坐在父亲的肩膀上，女孩们向角斗士投去鲜花，女人们扇着扇子，男人们想着自己是否也能做到。这就是竞技场上的人们——其他人都喝得酩酊大醉，大喊大叫。希望%companyname%能够为这个疯狂的群体贡献至少一两个小时的娱乐。 | 当%companyname%的人走上沙坑时，观众群发出震耳欲聋的欢呼声。傻瓜才会把兴奋和崇拜混淆在一起，一旦掌声停下来，飞过来的就会是空啤酒杯和臭烂的番茄，那些看热闹的人则会咯咯大笑。你在想%companyname%的人是否真的要把时间花在这里，但考虑到可以获得的金钱和荣耀，以及等到一天结束时，看台上的那些杂碎们还是会过着他们的狗屁生活，而你也会回到你的狗屁生活，比起他们，至少你口袋里的钱是货真价实的。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "让观众为我们喝彩！",
					function getResult()
					{
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.CombatID = "Arena";
						p.TerrainTemplate = "tactical.arena";
						p.LocationTemplate.Template[0] = "tactical.arena_floor";
						p.Music = this.Const.Music.ArenaTracks;
						p.Ambience[0] = this.Const.SoundAmbience.ArenaBack;
						p.Ambience[1] = this.Const.SoundAmbience.ArenaFront;
						p.AmbienceMinDelay[0] = 0;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						p.IsUsingSetPlayers = true;
						p.IsFleeingProhibited = true;
						p.IsLootingProhibited = true;
						p.IsWithoutAmbience = true;
						p.IsFogOfWarVisible = false;
						p.IsArenaMode = true;
						p.IsAutoAssigningBases = false;
						local bros = this.Contract.getBros();

						for( local i = 0; i < bros.len() && i < 3; i = ++i )
						{
							p.Players.push(bros[i]);
						}

						p.Entities = [];
						local baseDifficulty = 30;

						if (this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") > 0 && this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") % 5 == 0)
						{
							baseDifficulty = baseDifficulty + 10;
						}

						baseDifficulty = baseDifficulty * this.Contract.getScaledDifficultyMult();

						if (this.Flags.get("IsSwordmaster"))
						{
							this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Swordmaster);

							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.BanditRaider);
							}
						}
						else if (this.Flags.get("IsHedgeKnight"))
						{
							this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.HedgeKnight);

							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.BanditRaider);
							}
						}
						else if (this.Flags.get("IsDesertDevil"))
						{
							this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.DesertDevil);

							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.NomadOutlaw);
							}
						}
						else if (this.Flags.get("IsSandGolems"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.SandGolem);
							}
						}
						else if (this.Flags.get("IsGhouls"))
						{
							if (baseDifficulty >= this.Const.World.Spawn.Troops.GhoulHIGH.Cost * 2)
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.GhoulHIGH);

								for( local i = 0; i < this.Flags.get("Number") - 1; i = ++i )
								{
									this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Ghoul);
								}
							}
							else
							{
								for( local i = 0; i < this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.GhoulLOW, baseDifficulty * 0.5); i = ++i )
								{
									this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.GhoulLOW);
								}

								for( local i = 0; i < this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Ghoul, baseDifficulty * 0.5); i = ++i )
								{
									this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Ghoul);
								}
							}
						}
						else if (this.Flags.get("IsUnholds"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Unhold);
							}
						}
						else if (this.Flags.get("IsDesertRaiders"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.NomadOutlaw);
							}
						}
						else if (this.Flags.get("IsGladiators"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Gladiator);
							}
						}
						else if (this.Flags.get("IsSpiders"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Spider);
							}
						}
						else if (this.Flags.get("IsSerpents"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Serpent);
							}
						}
						else if (this.Flags.get("IsHyenas"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Hyena);
							}
						}
						else if (this.Flags.get("IsFrenziedHyenas"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.HyenaHIGH);
							}
						}
						else if (this.Flags.get("IsLindwurm"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Lindwurm);
							}
						}
						else if (this.Flags.get("IsMercenaries"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Mercenary);
							}
						}
						else if (this.Flags.get("IsGladiatorChampion"))
						{
							this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Gladiator, true, this.Flags.get("Champion1"));

							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Gladiator);
							}
						}
						else if (this.Flags.get("IsSwordmasterChampion"))
						{
							this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Swordmaster, true, this.Flags.get("Champion1"));

							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Mercenary);
							}
						}
						else if (this.Flags.get("IsExecutionerChampion"))
						{
							this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Executioner, true, this.Flags.get("Champion1"));

							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Gladiator);
							}
						}
						else if (this.Flags.get("IsDesertDevilChampion"))
						{
							this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.DesertDevil, true, this.Flags.get("Champion1"));

							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.NomadOutlaw);
							}
						}

						for( local i = 0; i < p.Entities.len(); i = ++i )
						{
							p.Entities[i].Faction <- this.Contract.getFaction();
						}

						this.World.Contracts.startScriptedCombat(p, false, false, false);
						return 0;
					}

				},
				{
					Text = "我不去了，我不想死！",
					function getResult()
					{
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.State.getTownScreen().getMainDialogModule().reload();
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnArenaCancel);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success",
			Title = "在竞技场",
			Text = "[img]gfx/ui/events/event_147.png[/img]{从竞技场主说的话看来，他似乎并没记住你的样子，说不定他是真不记得。%SPEECH_ON%这是你的报酬，请再来。%SPEECH_OFF%竞技场即将关门谢客，你最早可以明天再来。 | 竞技场主埋头在破烂的莎草纸里，头都不抬地扔给你一袋钱币。%SPEECH_ON%我听到了人群的声音，所以这些钱归你们来，希望你们再来。%SPEECH_OFF%竞技场即将关门谢客，你最早可以明天再来。 | 竞技场主正等着你。%SPEECH_ON%非常精彩的表演，逐币者。你下次再来我也毫不介意。%SPEECH_OFF%竞技场即将关门谢客，你最早可以明天再来。}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "{胜利！ | 难道没尽兴吗？！ | 杀掉它了！ | 真是血腥十足。}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());

						if (this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") > 0 && this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") % 5 == 0)
						{
							return "Gladiators";
						}
						else
						{
							this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
							this.World.Statistics.getFlags().increment("ArenaFightsWon", 1);
							this.World.Statistics.getFlags().increment("ArenaRegularFightsWon", 1);
							this.World.Contracts.finishActiveContract();

							if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 10)
							{
								this.updateAchievement("Gladiator", 1, 1);
							}

							return 0;
						}
					}

				}
			],
			function start()
			{
				local roster = this.World.getPlayerRoster().getAll();
				local n = 0;

				foreach( bro in roster )
				{
					local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

					if (item != null && item.getID() == "accessory.arena_collar")
					{
						local skill;
						bro.getFlags().increment("ArenaFightsWon", 1);
						bro.getFlags().increment("ArenaFights", 1);

						if (bro.getFlags().getAsInt("ArenaFightsWon") == 1)
						{
							skill = this.new("scripts/skills/traits/arena_pit_fighter_trait");
							bro.getSkills().add(skill);
							this.List.push({
								id = 10,
								icon = skill.getIcon(),
								text = bro.getName() + "成为了" + this.Const.Strings.getArticle(skill.getName()) + skill.getName()
							});
						}
						else if (bro.getFlags().getAsInt("ArenaFightsWon") == 5)
						{
							bro.getSkills().removeByID("trait.pit_fighter");
							skill = this.new("scripts/skills/traits/arena_fighter_trait");
							bro.getSkills().add(skill);
							this.List.push({
								id = 10,
								icon = skill.getIcon(),
								text = bro.getName() + "成为了" + this.Const.Strings.getArticle(skill.getName()) + skill.getName()
							});
						}
						else if (bro.getFlags().getAsInt("ArenaFightsWon") == 12)
						{
							bro.getSkills().removeByID("trait.arena_fighter");
							skill = this.new("scripts/skills/traits/arena_veteran_trait");
							bro.getSkills().add(skill);
							this.List.push({
								id = 10,
								icon = skill.getIcon(),
								text = bro.getName() + "成为了" + this.Const.Strings.getArticle(skill.getName()) + skill.getName()
							});
						}

						n = ++n;
					}

					if (n >= 3)
					{
						break;
					}
				}

				if (this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") > 0 && this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") % 5 == 0)
				{
					local r;
					local a;
					local u;

					if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") == 5)
					{
						r = 1;
					}
					else if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") == 10)
					{
						r = 3;
					}
					else if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") == 15)
					{
						r = 2;
					}
					else
					{
						r = this.Math.rand(1, 3);
					}

					switch(r)
					{
					case 1:
						a = this.new("scripts/items/armor/oriental/gladiator_harness");
						u = this.new("scripts/items/armor_upgrades/light_gladiator_upgrade");
						a.setUpgrade(u);
						this.List.push({
							id = 12,
							icon = "ui/items/armor_upgrades/upgrade_24.png",
							text = "你获得了一件" + a.getName()
						});
						break;

					case 2:
						a = this.new("scripts/items/armor/oriental/gladiator_harness");
						u = this.new("scripts/items/armor_upgrades/heavy_gladiator_upgrade");
						a.setUpgrade(u);
						this.List.push({
							id = 12,
							icon = "ui/items/armor_upgrades/upgrade_25.png",
							text = "你获得了一件" + a.getName()
						});
						break;

					case 3:
						a = this.new("scripts/items/helmets/oriental/gladiator_helmet");
						this.List.push({
							id = 12,
							icon = "ui/items/" + a.getIcon(),
							text = "你获得了一件" + a.getName()
						});
						break;
					}

					this.World.Assets.getStash().makeEmptySlots(1);
					this.World.Assets.getStash().add(a);
				}
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "在竞技场",
			Text = "[img]gfx/ui/events/event_147.png[/img]{%companyname%的人被打败了，他们要么痛快死了, 要么成了表演的道具。但至少观众们很高兴。在竞技场里，任何的表现，即便是死了，都是好的表现。}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "完了！",
					function getResult()
					{
						local roster = this.World.getPlayerRoster().getAll();
						local n = 0;

						foreach( bro in roster )
						{
							local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

							if (item != null && item.getID() == "accessory.arena_collar")
							{
								bro.getFlags().increment("ArenaFights", 1);
								n = ++n;
							}

							if (n >= 3)
							{
								break;
							}
						}

						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Failure2",
			Title = "在竞技场",
			Text = "{[img]gfx/ui/events/event_155.png[/img]竞技场比赛的时间到了，你们却没有出现。也许是碰到了更重要的事情，也许是你像懦夫一样躲了起来。不管怎样，你的声誉都会因此受损。",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "可是……",
					function getResult()
					{
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Collars",
			Title = "在竞技场",
			Text = "{[img]gfx/ui/events/event_155.png[/img]竞技场比赛的时间到了，但你的人都没有佩戴竞技场项圈，被禁止进入。\n\n你应该决定派谁去参加比赛，并给他们佩戴竞技场项圈，比赛会在你再次进入竞技场时开始。",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "哦，对哦！",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Gladiators",
			Title = "在竞技场",
			Text = "{[img]gfx/ui/events/event_85.png[/img]战斗结束后，有几名女子在你和角斗士周围晃荡。她们快要晕倒，脸颊泛红，男人们则给了她们特别关注。你自己也有点累了，让一名粉丝帮你清点库存。 | [img]gfx/ui/events/event_147.png[/img]战斗结束，但是一道阴影忽然在地面上略过。你一晃就拔出剑来，向天空挥去。花瓣飘洒在你闪闪发光的身体上，你用牙齿咬住剩下的部分。一名女子站在那里扇着扇子。%SPEECH_ON%我本来就在想你为什么不战斗。%SPEECH_OFF%她说。你收起剑，将花束系在腰带上。你告诉她，要是你上场的话，也就谈不上什么“战斗”了。那名粉丝膝盖一软，倒在地上。临走前，你告诉她多喝热水，早起多做伸展运动。 | [img]gfx/ui/events/event_97.png[/img]%SPEECH_START%我能学着像你的人一样战斗吗？%SPEECH_OFF%这声音吓了你一跳，你不知不觉地将剑架在了小男孩的脸前一寸的地方。他闭上了眼睛，慢慢地睁开了一只。你收起剑，笑了起来。%SPEECH_ON%不，我是你学不来的。%SPEECH_OFF%你用战场上的灰烬和血液给男孩的衬衫签了名，离开了。 | [img]gfx/ui/events/event_97.png[/img]%SPEECH_START%你们是……你们是角斗士吗？%SPEECH_OFF%你看到一个男孩惊奇地站在那里。他兴奋得快哭了。%SPEECH_ON%你真了不起！%SPEECH_OFF%你揉了揉男孩的头发，向他道谢，然后离开了。 | [img]gfx/ui/events/event_97.png[/img]%SPEECH_START%你，你怎么这么厉害？%SPEECH_OFF%你转过身，看到一个男孩紧张地盯着你。你笑着，跟他说了实话。%SPEECH_ON%我像你那么大的时候，就在杀像我这么大的人。%SPEECH_OFF%他笑了笑，问你，如果他努力，能成为像你一样的人吗？你点点头回答道。%SPEECH_ON%孩子，你不试试怎么知道呢。回家吧。%SPEECH_OFF%男孩挥舞着一把黄油刀，狂奔着跑开了。真是个好孩子。}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "{干，我们真强。 | 我们是最棒的。}",
					function getResult()
					{
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.Statistics.getFlags().increment("ArenaFightsWon", 1);
						this.World.Statistics.getFlags().increment("ArenaRegularFightsWon", 1);
						this.World.Contracts.finishActiveContract();

						if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 10)
						{
							this.updateAchievement("Gladiator", 1, 1);
						}

						return 0;
					}

				}
			]
		});
	}

	function getBros()
	{
		local ret = [];
		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && item.getID() == "accessory.arena_collar")
			{
				ret.push(bro);
			}
		}

		return ret;
	}

	function getAmountToSpawn( _type, _resources, _min = 1, _max = 24 )
	{
		return this.Math.min(_max, this.Math.max(_min, _resources / _type.Cost));
	}

	function addToCombat( _list, _entityType, _champion = false, _name = "" )
	{
		local c = clone _entityType;

		if (c.Variant != 0 && _champion)
		{
			c.Variant = 1;
			c.Name <- _name;
		}
		else
		{
			c.Variant = 0;
		}

		_list.push(c);
	}

	function getScaledDifficultyMult()
	{
		local p = this.World.State.getPlayer().getStrength();
		p = p / this.World.getPlayerRoster().getSize();
		p = p * 12;
		local s = this.Math.maxf(0.75, 1.0 * this.Math.pow(0.01 * p, 0.95) + this.Math.minf(0.5, (this.World.getTime().Days + this.World.Statistics.getFlags().getAsInt("ArenaFightsWon")) * 0.01));
		local d = this.Math.minf(5.0, s);
		return d * this.Const.Difficulty.EnemyMult[this.World.Assets.getCombatDifficulty()];
	}

	function getReputationToPaymentMult()
	{
		local r = this.Math.minf(4.0, this.Math.maxf(0.9, this.Math.pow(this.Math.maxf(0, 0.003 * this.World.Assets.getBusinessReputation() * 0.5 + this.getScaledDifficultyMult()), 0.35)));
		return r * this.Const.Difficulty.PaymentMult[this.World.Assets.getEconomicDifficulty()];
	}

	function setScreenForArena()
	{
		if (!this.m.IsActive)
		{
			return;
		}

		if (this.getBros().len() == 0)
		{
			this.setScreen("Collars");
		}
		else if (this.World.getTime().Days > this.m.Flags.get("Day"))
		{
			this.setScreen("Failure2");
		}
		else
		{
			this.setScreen("Start");
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"numberC",
			this.m.Flags.get("Number") < this.Const.Strings.AmountC.len() ? this.Const.Strings.AmountC[this.m.Flags.get("Number")] : this.Const.Strings.AmountC[this.m.Flags.get("Number")]
		]);
		_vars.push([
			"number",
			this.m.Flags.get("Number") < this.Const.Strings.Amount.len() ? this.Const.Strings.Amount[this.m.Flags.get("Number")] : this.Const.Strings.Amount[this.m.Flags.get("Number")]
		]);
		_vars.push([
			"amount",
			this.m.Flags.get("Number")
		]);
		_vars.push([
			"champion1",
			this.m.Flags.get("Champion1")
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.m.Home.getSprite("selection").Visible = false;
			this.m.Home.getBuilding("building.arena").refreshCooldown();
			local roster = this.World.getPlayerRoster().getAll();

			foreach( bro in roster )
			{
				local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

				if (item != null && item.getID() == "accessory.arena_collar")
				{
					bro.getItems().unequip(item);
				}
			}

			local items = this.World.Assets.getStash().getItems();

			foreach( i, item in items )
			{
				if (item != null && item.getID() == "accessory.arena_collar")
				{
					items[i] = null;
				}
			}
		}
	}

	function isValid()
	{
		return this.Const.DLC.Desert;
	}

	function onSerialize( _out )
	{
		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.contract.onDeserialize(_in);
	}

});
