this.destroy_goblin_camp_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.destroy_goblin_camp";
		this.m.Name = "摧毁地精营地";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		local camp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(this.World.State.getPlayer().getTile());
		this.m.Destination = this.WeakTableRef(camp);
		this.m.Flags.set("DestinationName", this.m.Destination.getName());
		this.m.Payment.Pool = 900 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
		local r = this.Math.rand(1, 2);

		if (r == 1)
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
					"摧毁" + this.Flags.get("DestinationName") + " %origin%%direction%边的地精"
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
				this.Contract.m.Destination.clearTroops();
				this.Contract.m.Destination.setLastSpawnTimeToNow();

				if (this.Contract.getDifficultyMult() < 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.GoblinRaiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setLootScaleBasedOnResources(110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);

				if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().get("Betrayed") && this.Math.rand(1, 100) <= 75)
				{
					this.Flags.set("IsBetrayal", true);
				}
				else
				{
					local r = this.Math.rand(1, 100);

					if (r <= 20 && this.World.Assets.getBusinessReputation() > 1000)
					{
						if (this.Contract.getDifficultyMult() >= 0.95)
						{
							this.Flags.set("IsAmbush", true);
						}
					}
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
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsBetrayal"))
					{
						if (this.Flags.get("IsBetrayalDone"))
						{
							this.Contract.setScreen("Betrayal2");
							this.World.Contracts.showActiveContract();
						}
						else
						{
							this.Contract.setScreen("Betrayal1");
							this.World.Contracts.showActiveContract();
						}
					}
					else
					{
						this.Contract.setScreen("SearchingTheCamp");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Return");
					}
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (this.Flags.get("IsAmbush"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("Ambush");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.LocationTemplate = null;
						p.CombatID = "Ambush";
						p.Music = this.Const.Music.GoblinsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.GoblinRaiders, 50 * this.Contract.getScaledDifficultyMult(), this.Contract.m.Destination.getFaction());
						this.World.Contracts.startScriptedCombat(p, false, false, false);
					}
				}
				else
				{
					this.World.Contracts.showCombatDialog();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Betrayal")
				{
					this.Flags.set("IsBetrayalDone", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Betrayal")
				{
					this.Flags.set("IsBetrayalDone", true);
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
			Text = "[img]gfx/ui/events/event_61.png[/img]{你进去时%employer%正在读卷轴。他挥手示意你退下，可能以为你只是个仆人。你让剑鞘撞在墙上发出声响。他抬眼一看，急忙放下文书。%SPEECH_ON%啊，佣兵！见到你真好。我这儿有个问题，正适合你这种……有特殊癖好的人。%SPEECH_OFF%他停顿片刻，似乎在等你的回应。见你无话，他尴尬地继续。%SPEECH_ON%是了，说正事。有一群地精在%origin%的%direction%边建立了据点。我本想亲自带骑士去解决，但结果那些人都觉得‘杀地精’有失身份。要我说，全是屁话。我看他们就是不想死在那些矮矬子手里。还谈什么荣誉、勇武。%SPEECH_OFF%他咧嘴一笑，举起手。%SPEECH_ON%但你不介意干这活儿，只要报酬合适，对吧？%SPEECH_OFF% | %employer%正对离开他房间的人大吼。平静下来后，他友好地问候了你。%SPEECH_ON%他妈的，见到你真好。你知道让那些‘忠诚’的手下去杀几个地精有多难吗？%SPEECH_OFF%他吐了口唾沫，用袖子擦嘴。%SPEECH_ON%显然他们觉得这不是什么高尚的任务。说什么那些小杂种从不公平决斗。你能信吗？手下竟敢对我这个名门贵族指手画脚，评判什么是‘高尚’。总之情况就是这样，佣兵。我需要你去%origin%的%direction%边端掉一个地精营地。能替我办这事吗？%SPEECH_OFF% | %employer%正反复拔剑收剑。他似乎在刀面反光中端详自己，随即猛地拔剑出鞘。%SPEECH_ON%农民们又在烦我了。他们说有地精在%origin%%direction%边一个叫%location%的地方扎营。今天有个脖子上插着毒镖的男孩被抬到我面前，我不得不信。%SPEECH_OFF%他啪地将剑插回鞘中。%SPEECH_ON%你愿意替我解决这个问题吗？%SPEECH_OFF% | 你进房间时，醉醺醺的%employer%满脸通红，猛地把杯子砸在桌上。%SPEECH_ON%佣兵，对吧？%SPEECH_OFF%他的卫兵探进头来确认。贵族大笑。%SPEECH_ON%哦，好。又来几个送死的。%SPEECH_OFF%他停顿片刻，突然爆笑。%SPEECH_ON%开玩笑的，好笑吧？我们在%origin%%direction%遇到了地精麻烦。需要你去解决，你——嗝——接不接？不然我找别人去自掘坟……我是说……%SPEECH_OFF%他又灌了一口酒堵住自己的嘴。 | 你进去时%employer%正在比对两份卷轴。%SPEECH_ON%最近我的收税官不太得力。真遗憾，不过既然我派不动那些所谓的‘忠诚’骑士了，对你倒是桩好生意。%SPEECH_OFF%他把文件扔到一边，双手搭成塔状支在桌上。%SPEECH_ON%我的探子报告地精在%origin%%direction%边一个叫%location%的地方扎营。需要你去完成我的封臣们不肯干的活。%SPEECH_OFF% | %employer%在你进门时掰着面包，但没分给你。他把两头都蘸了葡萄酒塞进嘴里，说话时喷出的面包屑比字句还多。%SPEECH_ON%见到你真好，佣兵。在%origin%的%direction%边有一批地精需要清除。我本想派骑士去，但他们嘛，呃，更金贵些。你懂的。%SPEECH_OFF%他把剩余面包全塞进丑陋的大嘴。突然他噎住了，你甚至考虑关上门让他就此完蛋。不幸的是，他痛苦的挣扎引来了守卫，那人冲进来猛捶贵族胸口，把黏糊糊的致命堵塞物全拍了出来。 | 你见到%employer%时，他正骂骂咧咧地把几名骑士轰出门，看到你却暂时平静下来。%SPEECH_ON%佣兵！见到你真好！你比那些所谓的‘男子汉’强多了。%SPEECH_OFF%他坐下自斟一杯。抿了一口，盯着酒杯，然后一饮而尽。%SPEECH_ON%我的封臣们拒绝讨伐在%origin%%direction%边扎营的地精。说什么埋伏、毒药之类的……%SPEECH_OFF%他口齿越来越含糊。%SPEECH_ON%反正——嗝——你都懂的，对吧？也知道我想让你干什么，对吧？当——当然知道了，嗝——快再给我倒一杯！哈，开玩笑的。去宰了那些地精，行不？%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{对抗地精可不便宜。 | 想必你出价不低。 | 谈谈价钱吧。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{这事不划算。 | 我们还有其他任务。}",
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
			ID = "Ambush",
			Title = "接近营地时……",
			Text = "[img]gfx/ui/events/event_48.png[/img]{你走进地精营地发现空无一人。但你心知不妙——这分明是踏入了陷阱。就在这时，该死的绿皮从四面八方涌出。你发出最响亮的战吼，命令兄弟们准备战斗！ | 地精耍了你！他们撤离营地后又包抄回来，将你们团团围住。让兄弟们谨慎备战，这个陷阱可不好挣脱。 | 你早该察觉的：这分明是地精设下的圈套！他们的士兵已形成合围，而战团还像待宰的羔羊般站在原地！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "小心！",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Betrayal1",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_78.png[/img]{你刚解决掉最后一只地精，突然出现一队全副武装的人马。他们的指挥官拇指勾着佩剑腰带走上前来。%SPEECH_ON%啧啧，你们还真是蠢得可以。%employer%可不是健忘的人——他可没忘记你们上次的背叛。就当这是……一点小小的回礼。%SPEECH_OFF%话音刚落，他身后的士兵突然发起冲锋。抄起武器，我们中埋伏了！ | 你正擦拭剑上的地精血迹，突然发现一队人马逼近。他们打着%employer%的旗帜，正在拔出武器。当对方发起冲锋时，你才恍然大悟中了圈套。这帮杂种专门让地精先消耗你们！给他们点颜色看看！ | 有个装备精良的男人不知从哪儿冒出来打招呼。他装备精良，盔甲齐全，而且显然心情颇佳，在走近时露出狡黠的咧嘴笑。%SPEECH_ON%晚上好，雇佣兵。对付那些绿皮干得漂亮啊？%SPEECH_OFF%他停顿片刻，收起笑容。%SPEECH_ON%%employer%向你们问好。%SPEECH_OFF%就在这时，一群人从道路两侧涌出。是埋伏！那个该死的贵族背刺了你们！ | 一队身着%faction%纹章颜色的武装人员出现在你们后方，呈扇形包围了战团。他们的首领打量着你们。%SPEECH_ON%我很期待从你冰冷僵硬的手里把这把剑撬出来。%SPEECH_OFF%你耸肩问为什么设局。%SPEECH_ON%%employer%从不会忘记背叛他或家族的人。知道这点就够了。反正你们很快就是死人了。%SPEECH_OFF%准备迎战吧，我们中了埋伏！ | 队员们搜遍地精营地却空无一人。突然，身着%faction%颜色制服的士兵从背后出现，带队的指挥官神情恶劣地走上前来，胸前绣着%employer%的徽章。%SPEECH_ON%可惜那些绿皮没把你们解决掉。如果你们想知道的话，我是来替%employer%收债的。你们承诺过会完成任务。既然当时没能履约，现在就拿命抵债吧。%SPEECH_OFF%你拔剑出鞘，寒光直指对方。%SPEECH_ON%看来%employer%又要被爽约了。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationBetrayal);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().set("Betrayed", false);
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "Betrayal";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 140 * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Betrayal2",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_22.png[/img]{你在裤腿上擦拭剑刃后迅速收剑入鞘。伏击者的尸体以各种怪异姿态倒毙在地。%randombrother%上前询问下一步行动。看来%faction%往后不会与我们友好相处了。 | 你将伏击者的尸体从剑尖踢落。看来从今往后%faction%不会对我们太友善。或许下次答应为这些人办事时，最好说到做到。 | 好吧，至少这次教训告诉我们：别承诺自己做不到的事。这片土地上的人们对失信之徒可不会客气…… | 你确实背叛过%faction%，但往事不必再提。现在重要的是他们背叛了你！从今往后，最好对这群人及其麾下势力都保持警惕。 | 从脚下士兵的尸体来看，%employer%显然对你不再满意。若要说原因，无非是往日旧账——背信弃义、任务失败、出言顶撞，还是睡了贵族女儿？细想之下桩桩件件都涌入脑海。重要的是你们之间的裂痕难以弥合，最近最好提防着点%faction%的人。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "没薪水领了……",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SearchingTheCamp",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_83.png[/img]{解决掉最后一只地精后，你探查了它们的营地。这帮家伙倒是活得挺滋润——到处都是饰品和乐器，件件都能当武器使，只需往废墟中央那口毒液大锅里蘸一下就行。你一脚踹翻锅子，命令兄弟们准备返回雇主%employer%处。 | 地精们的抵抗既顽强又狡诈，但你们终究将其全数歼灭。营地燃起熊熊烈火，你下令整队返回%employer%处报捷。 | 尽管矮绿皮抵抗异常顽强，但你们的战团更胜一筹。最后一只地精倒下后，你环顾这片化为废墟的营地。看来它们并非孤军——有迹象表明战斗时其他地精逃跑了。或许是家属？幼崽？无所谓了，该回去见雇主%employer%了。 | 啊，真是场精彩的战斗。%employer%想必正在等待捷报。 | 难怪人们都不愿与地精交手，它们的凶悍战力远非其体型可限。可惜不能把这份机敏注入人体，不过这种凶残被禁锢于矮小的躯壳内，未尝不是件好事！}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{你走进%employer%的房间，把几颗地精头颅扔在地上。他瞥了一眼。%SPEECH_ON%呵，这些玩意儿可比学者说的大多了。%SPEECH_OFF%你简短汇报了摧毁绿皮营地的经过。贵族点点头，摩挲着下巴。%SPEECH_ON%干得好。按约定，这是你的报酬。%SPEECH_OFF%他递过来一袋钱，共%reward_completion%克朗。 | 你进去时%employer%正朝一只受惊的猫扔石子。他瞥了你一眼，这微小的间隙让那可怜生物得以窜出窗户逃生。贵族又追着扔了几颗石子，幸好全都落了空。%SPEECH_ON%见到你真好，佣兵。我的探子早已汇报了你的战绩。按约定，这是你的酬劳。%SPEECH_OFF%他将一个装有%reward_completion%克朗的木箱滑过桌面推来。 | 你回来时%employer%正在剥坚果。他把壳扔在地上，边嚼边说。%SPEECH_ON%嘿，又见到你可真好。我猜任务成功了吧？%SPEECH_OFF%你提起几颗串在一起的地精头颅，它们晃荡着瞪视房间和彼此。这人抬手制止。%SPEECH_ON%拜托，我们这儿是体面地方。拿远点。%SPEECH_OFF%你耸耸肩递给在门外等候的%randombrother%。%employer%绕到桌前递来一个钱袋。%SPEECH_ON%%reward_completion%克朗，之前谈好的酬金。干得漂亮，佣兵。%SPEECH_OFF% | %employer%见你提着地精头颅进来便大笑道。%SPEECH_ON%见鬼，老兄，别把这玩意儿带进来。拿去喂狗。%SPEECH_OFF%他略带醉意。你不确定他是因任务成功而兴奋，还是就是喜欢饮酒作乐。%SPEECH_ON%报酬是—嗝—%reward_completion%克朗，对吧？%SPEECH_OFF%你正想\"修正\"金额，门外卫兵探头进来摇了摇头。好吧，看来就是%reward_completion%克朗了。 | 你回到%employer%处时，他正把个女人按在膝上。实际上那女子正弯腰低头，他的手还扬在半空。两人愣愣盯着你，随即她迅速钻到桌下，他则直起身子。%SPEECH_ON%佣兵！见到你真好！看来你成功消灭那些绿皮了？%SPEECH_OFF%桌下传来那可怜女人撞到头的声响，但你强作镇定汇报任务成功。他鼓掌作势要起身，又改变主意坐定。%SPEECH_ON%劳驾，你那份%reward_completion%克朗的报酬就在我身后书架上。%SPEECH_OFF%你去取钱时，他露出尴尬的笑容。}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "摧毁了一处地精营地");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isGreenskinInvasion())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
						}

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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Origin, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"location",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.m.Destination.getName()
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.m.Origin.getTile().getDirection8To(this.m.Destination.getTile())]
		]);
	}

	function onOriginSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Origin.addSituation(this.new("scripts/entity/world/settlements/situations/greenskins_situation"));
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

		if (this.m.Origin != null && !this.m.Origin.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Origin.getSituationByInstance(this.m.SituationID);

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

			if (this.m.Origin.getOwner().getID() != this.m.Faction)
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
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		this.contract.onDeserialize(_in);
	}

});
