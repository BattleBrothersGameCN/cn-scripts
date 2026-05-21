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
					"这场战斗将一决生死，你将无法撤退或搜刮战利品"
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
					Text = "{用鲜血染红这片沙漠! | 让人群高呼我们的名字! | 杀他们就像宰鸡杀羊!}",
					function getResult()
					{
						return "Overview";
					}

				},
				{
					Text = "{这和我想的不一样。 | 这场我就不参加了。 | 我等下场战斗再来。}",
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
				this.Text = "[img]gfx/ui/events/event_155.png[/img]数十名男子在竞技场入口处往来徘徊。有人沉默伫立，不愿显露半分实力；另一些人却在大肆吹嘘，要么对自身武艺充满信心，要么想靠虚张声势来掩饰不足。\n\n";
				this.Text += "竞技场主人是个饱经风霜的男人，此刻他举起一卷羊皮纸，用钩状义肢轻轻敲了敲。";
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

					this.Text += "%SPEECH_ON%他的名字旁标了星号，镀金者的印记。这意味着他走的是金光大道。你只要知道他是一位剑术大师就行了。或许能让你稍感安慰的是他年纪不小了，但听过这话的角斗士可不止你一个，懂了吗？愿你同样走在镀金之路上，毕竟这位剑术大师在这条路上可走了相当远。%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsHedgeKnight"))
				{
					if (baseDifficulty < this.Const.World.Spawn.Troops.HedgeKnight.Cost + this.Const.World.Spawn.Troops.BanditRaider.Cost)
					{
						this.Flags.set("Number", 0);
						this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战一名流浪骑士";
					}
					else
					{
						this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.BanditRaider, baseDifficulty - this.Const.World.Spawn.Troops.HedgeKnight.Cost, 2));
						this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战一位流浪骑士和%amount%名掠袭者";
					}

					this.Text += "%SPEECH_ON%我听说北方人管他叫‘牛郎骑士’。可能我听错了。别告诉其他竞技场主我这么说北方佬——但这骑士可不是什么花架子，是实打实的危险。要是你不想你的镀金之路就此了结，我劝你趁早磨利家伙，开打前好好养精蓄锐。%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsDesertDevil"))
				{
					if (baseDifficulty < this.Const.World.Spawn.Troops.DesertDevil.Cost + this.Const.World.Spawn.Troops.NomadOutlaw.Cost)
					{
						this.Flags.set("Number", 0);
						this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战一名刀锋舞者";
					}
					else
					{
						this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, baseDifficulty - this.Const.World.Spawn.Troops.DesertDevil.Cost, 2));
						this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战一名刀锋舞者和%amount%名游牧民";
					}

					this.Text += "竞技场主用钩状义肢敲了敲手中的卷轴。%SPEECH_ON%这一轮登场的是来自游牧部族的刀锋舞者。虽说看着有些花哨，但只有挥舞起刀剑来都像鸟儿乘风一样自然的人，才能获得“刀锋舞者”的头衔。当然，舞艺精湛不是必要条件，不过他们这方面也都不赖。%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsSandGolems"))
				{
					this.Flags.set("Number", this.Math.max(3, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.SandGolem, baseDifficulty, 3)));
					this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战%amount%只伊夫利特";
					this.Text += "%SPEECH_ON%这页上什么都没画，因为我怕展示沙漠最凶悍的存在招来它的愤怒。你要对战%number%只伊夫利特。我不知道他们怎么弄来的这玩意，只知道是炼金术士干的好事。要我选，我宁愿你去打炼金术士，而不是伊夫利特。%SPEECH_OFF%";
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
					this.Text += "%SPEECH_ON%炼金术士们管它们叫——唉，我念不出来。这词需要专门的北方语言学知识，我的舌头根本绕不过来。也没空纠结这种细枝末节。我看上去像语音学家吗？干脆就叫它们“碎骨魔”好了。这些吃尸体的小怪物足足有%number%只，我亲眼见过它们活活吞下一整个人——你最好祈祷镀金者庇护，恕我直言，要是被那玩意儿吞进肚子，祂的圣光可照不进去！%SPEECH_OFF%";
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

					this.Text += "%SPEECH_ON%你们要对战%number%只北佬所谓的”巨魔“。维齐尔为了把它们带来这里花了大把金子，观众就爱看这种大块头怪物。它们擅长把角斗士砸成肉泥，偶尔还能把战士直接扔进观众席——那可真是妙极了。我觉得这些巨魔待久了甚至学会了享受，比如懂得如何煽动观众欢呼和喝倒彩。那凶残劲儿真是独一份。总之，愿镀金者庇佑你。%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsDesertRaiders"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战%amount%名游牧民";
					this.Text += "%SPEECH_ON%你们的对手将是%number%名刚退休的沙漠强盗。当然了，退休指的是被维齐尔的治安官抓进来。土匪可不会自愿来这儿，哈哈哈！%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsGladiators"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战%amount%名角斗士";
					this.Text += "%SPEECH_ON%呵，镀金者肯定很爱开玩笑。你们要面对%number%名角斗士。愿你走在镀金之路上，但坦白说，我对他们也是这么说的。而且我每天都这么说。明白了吗？你应该尽你所能做好准备。%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsSpiders"))
				{
					this.Flags.set("Number", this.Math.max(3, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Spider, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战%amount%只蛛魔";
					this.Text += "%SPEECH_ON%那可不是无花果树，是蜘蛛。炼金术士们——愿知识保佑他们——管它们叫结网蛛。这北方名字真够蠢的，实际上就是蜘蛛。可惜这次靴子可没办法踩死它们，它们足足有%number%只之多。%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsSerpents"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Serpent, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战%amount%条巨蛇";
					this.Text += "%SPEECH_ON%你说看不懂是什么意思？哈，只是条弯弯曲曲的线？不对！你看，这是它的尾巴，那是头。这是条蛇。你们要对付%number%条蛇。炼金术士爱叫它们“毒蛇”，但如果我想画条毒蛇，我画个炼金术士不就行了哈哈哈！%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsHyenas"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Hyena, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战%amount%只鬣狗";
					this.Text += "%SPEECH_ON%鬣狗。嘿嘿嘿。鬣狗。确切地说，是%numberC%只嗷嗷叫的野狗，祝你好运，愿镀金者庇佑你。%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsFrenziedHyenas"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.HyenaHIGH, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战%amount%只狂暴鬣狗";
					this.Text += "%SPEECH_ON%鬣狗。嘿嘿嘿。鬣狗。确切地说，是%numberC%只嗷嗷叫的野狗，祝你好运，愿镀金者庇佑你。%SPEECH_OFF%";
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

					this.Text += "%SPEECH_ON%你们的对手是……是……是个啥？蠕虫？还是绿色的。从来没见过这种颜色的蠕——哦！一条地龙！不对，“虫需龙”。蠕龙? 一条林德蠕龙！老实说，我压根不知道这是啥玩意，但我想安排赛程的人不会让你和普通蠕虫对打。当然也可能真就这么离谱。说不定他们打算让您生吞这玩意儿给大伙助兴。也许他们不是安排赛程，而是安排菜程！嘿嗨嘻嘻吼……哈。%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsMercenaries"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战%amount%名佣兵";
					this.Text += "%SPEECH_ON%对面也是从北边跑来的逐币者。在北边，他们叫做‘佣兵’。呦！这又是什么破名字？是佣人的意思吗？北方佬的脑子可真不灵光。所以我才喜欢待在南边。这儿阳光明媚，所以我们脑子也灵光。%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsGladiatorChampion"))
				{
					this.Flags.set("Champion1", this.Const.World.Common.generateName(this.Const.World.Spawn.Troops.Gladiator.NameList) + (this.Const.World.Spawn.Troops.Gladiator.TitleList != null ? " " + this.Const.World.Spawn.Troops.Gladiator.TitleList[this.Math.rand(0, this.Const.World.Spawn.Troops.Gladiator.TitleList.len() - 1)] : ""));
					this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, baseDifficulty - this.Const.World.Spawn.Troops.Gladiator.Cost * 2, 2));
					this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战%champion1%和%amount%名角斗士";
					this.Text += "%SPEECH_ON%认得这张脸吗？画师们特意在宣传册上精心描绘这张脸，还给楼上每位观众都发了一份。这可是%champion1%，是这片土地上最伟大的斗士之一。说不定哪天你的脸也能印得这么俊，当然前提是维齐尔能找到哪位高手能把你这副尊容补救回来，呵呵呵。%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsSwordmasterChampion"))
				{
					this.Flags.set("Champion1", this.Const.World.Common.generateName(this.Const.World.Spawn.Troops.Swordmaster.NameList) + (this.Const.World.Spawn.Troops.Swordmaster.TitleList != null ? " " + this.Const.World.Spawn.Troops.Swordmaster.TitleList[this.Math.rand(0, this.Const.World.Spawn.Troops.Swordmaster.TitleList.len() - 1)] : ""));
					this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, baseDifficulty - this.Const.World.Spawn.Troops.Gladiator.Cost * 2, 2));
					this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战%champion1%和%amount%名佣兵";
					this.Text += "%SPEECH_ON%认得这张脸吗？画师们特意在宣传册上精心描绘这张脸，还给楼上每位观众都发了一份。这可是%champion1%，是这片土地上最伟大的斗士之一。说不定哪天你的脸也能印得这么俊，当然前提是维齐尔能找到哪位高手能把你这副尊容补救回来，呵呵呵。%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsExecutionerChampion"))
				{
					this.Flags.set("Champion1", this.Const.World.Common.generateName(this.Const.World.Spawn.Troops.Executioner.NameList) + (this.Const.World.Spawn.Troops.Executioner.TitleList != null ? " " + this.Const.World.Spawn.Troops.Executioner.TitleList[this.Math.rand(0, this.Const.World.Spawn.Troops.Executioner.TitleList.len() - 1)] : ""));
					this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, baseDifficulty - this.Const.World.Spawn.Troops.Gladiator.Cost * 2, 2));
					this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战%champion1%和%amount%名角斗士";
					this.Text += "%SPEECH_ON%认得这张脸吗？画师们特意在宣传册上精心描绘这张脸，还给楼上每位观众都发了一份。这可是%champion1%，是这片土地上最伟大的斗士之一。说不定哪天你的脸也能印得这么俊，当然前提是维齐尔能找到哪位高手能把你这副尊容补救回来，呵呵呵。%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsDesertDevilChampion"))
				{
					this.Flags.set("Champion1", this.Const.World.Common.generateName(this.Const.World.Spawn.Troops.DesertDevil.NameList) + (this.Const.World.Spawn.Troops.DesertDevil.TitleList != null ? " " + this.Const.World.Spawn.Troops.DesertDevil.TitleList[this.Math.rand(0, this.Const.World.Spawn.Troops.DesertDevil.TitleList.len() - 1)] : ""));
					this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, baseDifficulty - this.Const.World.Spawn.Troops.Gladiator.Cost * 2, 2));
					this.Contract.m.BulletpointsObjectives[1] = "再次进入竞技场，对战%champion1%和%amount%名游牧民";
					this.Text += "%SPEECH_ON%认得这张脸吗？画师们特意在宣传册上精心描绘这张脸，还给楼上每位观众都发了一份。这可是%champion1%，是这片土地上最伟大的斗士之一。说不定哪天你的脸也能印得这么俊，当然前提是维齐尔能找到哪位高手能把你这副尊容补救回来，呵呵呵。%SPEECH_OFF%";
				}

				if (this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") > 0 && this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") % 5 == 0)
				{
					this.Text += "他顿了顿。%SPEECH_ON%这场比试有贵客莅临，所以我都给安排好了——你们得死惨烈点，明白吗？要是死不成，就让你们的人用最精彩的方式解决对手，取悦观众。办到了，除了赏钱之外再赏你们一件像样的角斗士装备。%SPEECH_OFF%";
				}

				this.Text += "他指了指几个造型奇特的项圈继续说道。%SPEECH_ON%准备好以后，给参赛的那三个人带上这些项圈，我们好知道谁要进入角斗场。没戴项圈的一概不准进入，别说是你了，维齐尔也不行，我敢说镀金者来了也会被拦在外面。%SPEECH_OFF%";
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
			Text = "[img]gfx/ui/events/event_155.png[/img]{当你们候场时，观众的嗜血穿过了黑暗，顶棚震落的尘埃如幕布垂下，跺脚声震耳欲聋。他们期待中低语，在杀戮中咆哮。战斗间歇的宁静转瞬即逝，随着生锈栅门在锁链刺耳声中升起，人群再度沸腾。你踏入光线的刹那，雷鸣般的喧嚣直击心脏，足以唤醒死尸。 | 竞技场看台摩肩接踵，多数人醉语连篇。他们嘶吼着当地方言与异邦话语，但癫狂的面容与挥动的拳头已足够传递嗜血的渴望。现在，%companyname%的人将满足这群疯子的渴求。 | 清洁工在场地里匆忙穿梭。他们拖走尸体，收集有价值之物，偶尔将战利品抛向观众，看台上立刻重演群氓式的争斗。如今，%companyname%也是这场盛事的一部分。 | 竞技场在等待，人群在沸腾，%companyname%夺取荣耀的时刻到了！ | 当%companyname%的战士踏入血染的角斗场时，人群爆发出轰鸣。尽管知道这只是观众的无脑嗜血狂欢，你胸腔仍不禁涌起自豪——你的战团正是这场表演的主角。 | 栅门升起。唯有锁链碰撞、滑轮吱嘎与奴隶劳作的喘息刺破寂静。当%companyname%的战士们从场地深处走出，沙砾在脚下咯吱作响，直至他们在场地中央站定。看台顶端传来陌生语言的呐喊，尾音在空气中尚未消散，人群便已爆发出欢呼与咆哮。现在正是你的部下在平民注视下证明自身的时刻。 | %companyname%的厮杀很少展现在那些惯于远离暴力的人眼前。但在这角斗场，平民贪婪期盼着死亡与痛苦，当你的战士踏入沙地时他们发出嗜血的低吼，当佣兵们亮出兵器准备厮杀时他们纵情咆哮。 | 这座竞技场犹如溃烂的疮口，顶盖被神灵撕开，揭露出人类的虚荣、嗜血与野蛮。看台上的人们嘶吼叫嚣，当鲜血飞溅到脸上，他们竟用血水洗脸，相视而笑如同闹剧。他们为战利品互相争斗，以他人痛苦为乐。而%companyname%即将在这群人面前搏杀，为他们献上娱乐，绝佳的娱乐。 | 竞技场的观众阶级混杂，贫富不分，唯有维齐尔们高坐专属看台。在%townname%的民众难得团结一致，共赏人与怪物互相屠戮的盛宴。%companyname%很乐意为此尽一份力。 | 男孩骑在父亲肩头，少女向角斗士投掷鲜花，妇人轻摇团扇，男子暗自衡量自身能耐。这就是竞技场观众的常态——剩下的还有些醉醺醺胡言乱语的酒鬼。你希望%companyname%至少能为这群疯子贡献一两小时的消遣。 | 当%companyname%的人走进沙坑时，观众爆发出震耳欲聋的欢呼声。千万别错把这欢呼当作善意——掌声未落便有空啤酒杯与烂番茄砸下，夹杂着看客们幸灾乐祸的嬉笑。你不禁怀疑%companyname%的人是否真的要在这耗费时光，但转念想到即将到手的金钱与荣耀，想到这些看台上的杂碎终将回到惨淡生活，而你虽同样回归惨淡生活，至少钱袋会鼓胀几分。}",
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
			Text = "[img]gfx/ui/events/event_147.png[/img]{竞技场主说话时连正眼都没瞧你——不过想来他也压根记不住你的长相。%SPEECH_ON%这是你的报酬，欢迎下次再来。%SPEECH_OFF%竞技场即将关门谢客，你可以明天再来。 | 竞技场主人头也不抬地抛来一袋钱币，目光始终没离开那卷莎草纸。%SPEECH_ON%我听到了观众的欢呼，所以这些钱归你们了，希望你们再来。%SPEECH_OFF%竞技场即将关门谢客，你可以明天再来。 | 竞技场主正等着你。%SPEECH_ON%非常精彩的表演，逐币者。随时欢迎你们再来。%SPEECH_OFF%竞技场即将关门谢客，你可以明天再来。}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "{胜利！ | 各位还不尽兴吗？！ | 轻松解决！ | 真是场血腥盛事。}",
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
			Text = "[img]gfx/ui/events/event_147.png[/img]{%companyname%的人战败了，有人当场战死, 有人重伤，后者可能是更加不幸的结局。至少观众们倒是心满意足。在这竞技场中，只要演出精彩，即便结局是死亡也值得称道。}",
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
			Text = "{[img]gfx/ui/events/event_155.png[/img]竞技场比赛的时间到了，你们却没有到场。或许是被更重要的事耽搁，又或许只是像懦夫般躲了起来。不管怎样，你的声誉都会因此受损。",
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
			Text = "{[img]gfx/ui/events/event_155.png[/img]竞技场比赛即将开始，但你的人均未佩戴竞技场项圈，故无法入场。\n\n请为你指定的队员装备获得的竞技场项圈以确定参赛人选，再次进入竞技场后比赛将正式开始。",
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
			Text = "{[img]gfx/ui/events/event_85.png[/img]战斗结束后，几个女人朝你和角斗士们走来。她们脸上泛着红晕，眼神热切，伙计们自然对她们格外关照。你自己也有点累了，就让其中一位仰慕者帮忙清点装备。 | [img]gfx/ui/events/event_147.png[/img]战斗刚结束，地上突然闪过一道黑影。你瞬间拔剑劈向空中，斩落的花瓣纷纷扬扬撒在汗湿的身上，你用牙齿咬住剩下的部分。一名女子站在那里扇着扇子。%SPEECH_ON%我刚才还在想你怎么不上场。%SPEECH_OFF%你还剑入鞘，把花束系在腰带上，告诉她要是你上场的话，就只是一边倒的屠杀了。那仰慕者腿一软坐倒在地。离开时你嘱咐她记得多喝水，早上别忘了活动筋骨。 | [img]gfx/ui/events/event_97.png[/img]%SPEECH_START%我能学会像你们那样战斗吗？%SPEECH_OFF%话音响起时你毫无防备，等你反应过来，你已将剑尖指到小男孩面前。他紧闭着眼睛，慢慢睁开一条缝。你还剑入鞘大笑。%SPEECH_ON%不行。我这样的本事是学不来的。%SPEECH_OFF%你蘸着战场上的血灰在孩子衣襟上签了个名，随即离开。 | [img]gfx/ui/events/event_97.png[/img]%SPEECH_START%你们是……你们是角斗士吗？%SPEECH_OFF%只见一个男孩满脸崇拜地站在那里，激动得快要哭出来。%SPEECH_ON%你们真的很了不起！%SPEECH_OFF%你揉了揉男孩的头发说了声谢谢，接着便离开了。 | [img]gfx/ui/events/event_97.png[/img]%SPEECH_START%你……你是怎么变得这么厉害的？%SPEECH_OFF%你转过身，看到一个男孩正紧张地盯着你。你笑着实话实说。%SPEECH_ON%我像你那么大的时候，就在杀像我这么大的人。%SPEECH_OFF%他咧嘴笑着问，如果他也这么做，能不能变得像你一样。你点头回答道。%SPEECH_ON%不试试怎么知道呢，小子。快回家吧。%SPEECH_OFF%男孩挥舞着一把黄油刀，兴高采烈地跑远了。真是个好苗子。}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "{干得漂亮！ | 我们是最棒的。}",
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
