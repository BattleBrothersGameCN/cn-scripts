this.marauding_greenskins_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Objective = null,
		Target = null,
		IsPlayerAttacking = true,
		LastRandomEventShown = 0.0
	},
	function setObjective( _h )
	{
		if (typeof _h == "instance")
		{
			this.m.Objective = _h;
		}
		else
		{
			this.m.Objective = this.WeakTableRef(_h);
		}
	}

	function setOrcs( _o )
	{
		this.m.Flags.set("IsOrcs", _o);
	}

	function create()
	{
		this.contract.create();
		this.m.Type = "contract.marauding_greenskins";
		this.m.Name = "绿皮劫掠";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		if (this.m.Home == null)
		{
			this.setHome(this.World.State.getCurrentTown());
		}

		local myTile = this.m.Origin.getTile();
		local orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(myTile);
		local goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(myTile);

		if (myTile.getDistanceTo(orcs.getTile()) + this.Math.rand(0, 8) < myTile.getDistanceTo(goblins.getTile()) + this.Math.rand(0, 8))
		{
			this.m.Flags.set("IsOrcs", true);
		}
		else
		{
			this.m.Flags.set("IsOrcs", false);
		}

		local bestDist = 9000;
		local best;
		local settlements = this.World.EntityManager.getSettlements();

		foreach( s in settlements )
		{
			if (s.isMilitary() || s.isSouthern() || !s.isDiscovered())
			{
				continue;
			}

			if (s.getID() == this.m.Origin.getID() || s.getID() == this.m.Home.getID())
			{
				continue;
			}

			local d = this.getDistanceOnRoads(s.getTile(), this.m.Origin.getTile());

			if (d < bestDist)
			{
				bestDist = d;
				best = s;
			}
		}

		if (best != null)
		{
			local distance = this.getDistanceOnRoads(best.getTile(), this.m.Origin.getTile());
			this.m.Flags.set("MerchantReward", this.Math.max(150, distance * 5.0 * this.getPaymentMult()));
			this.setObjective(best);
			this.m.Flags.set("MerchantID", best.getFactionOfType(this.Const.FactionType.Settlement).getRandomCharacter().getID());
		}

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

		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"杀死%origin%周边烧杀抢掠的绿皮"
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

				if (r <= 5 && this.World.Assets.getBusinessReputation() >= 2250)
				{
					if (this.Flags.get("IsOrcs") == true)
					{
						this.Flags.set("IsWarlord", true);
					}
					else
					{
						this.Flags.set("IsShaman", true);
					}
				}
				else if (r <= 10 && this.Contract.m.Objective != null)
				{
					this.Flags.set("IsMerchant", true);
				}

				local originTile = this.Contract.m.Origin.getTile();
				local tile = this.Contract.getTileToSpawnLocation(originTile, 5, 10);
				local party;

				if (this.Flags.get("IsOrcs"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).spawnEntity(tile, "兽人掳掠者", false, this.Const.World.Spawn.OrcRaiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("一群凶狠的兽人，绿皮肤、个头比任何人类都高。");
					party.getLoot().ArmorParts = this.Math.rand(0, 25);
					party.getLoot().Ammo = this.Math.rand(0, 10);
					party.addToInventory("supplies/strange_meat_item");
					local enemyBase = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(this.Contract.getOrigin().getTile());
					party.getSprite("banner").setBrush(enemyBase.getBanner());
				}
				else
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).spawnEntity(tile, "地精掠袭者", false, this.Const.World.Spawn.GoblinRaiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("一伙狡诈的地精，身形矮小却诡计多端，不容小觑。");
					party.getLoot().ArmorParts = this.Math.rand(0, 10);
					party.getLoot().Medicine = this.Math.rand(0, 2);
					party.getLoot().Ammo = this.Math.rand(0, 30);
					local r = this.Math.rand(1, 4);

					if (r == 1)
					{
						party.addToInventory("supplies/strange_meat_item");
					}
					else if (r == 2)
					{
						party.addToInventory("supplies/roots_and_berries_item");
					}
					else if (r == 3)
					{
						party.addToInventory("supplies/pickled_mushrooms_item");
					}

					local enemyBase = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(this.Contract.getOrigin().getTile());
					party.getSprite("banner").setBrush(enemyBase.getBanner());
				}

				this.Contract.m.UnitsSpawned.push(party.getID());
				this.Contract.m.Target = this.WeakTableRef(party);
				party.setAttackableByAI(false);
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Origin);
				roam.setMinRange(3);
				roam.setMaxRange(8);
				roam.setAllTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
				roam.setTerrain(this.Const.World.TerrainType.Shore, false);
				roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
				c.addOrder(roam);
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

				this.Contract.m.Origin.getSprite("selection").Visible = true;
			}

			function update()
			{
				local playerTile = this.World.State.getPlayer().getTile();

				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					if (this.Flags.get("IsMerchant") && this.Contract.m.Objective != null && !this.Contract.m.Objective.isNull())
					{
						this.Contract.setScreen("Merchant");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsOrcs"))
					{
						this.Contract.setScreen("BattleWonOrcs");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Return");
					}
					else
					{
						this.Contract.setScreen("BattleWonGoblins");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Return");
					}
				}
				else if (playerTile.getDistanceTo(this.Contract.m.Target.getTile()) <= 10 && this.Contract.m.Target.isHiddenToPlayer() && this.Time.getVirtualTimeF() - this.Contract.m.LastRandomEventShown >= 30.0 && this.Math.rand(1, 1000) <= 1)
				{
					this.Contract.m.LastRandomEventShown = this.Time.getVirtualTimeF();

					if (!this.Flags.get("IsBurnedFarmsteadShown") && playerTile.Type == this.Const.World.TerrainType.Plains || playerTile.Type == this.Const.World.TerrainType.Hills || playerTile.Type == this.Const.World.TerrainType.Tundra || playerTile.Type == this.Const.World.TerrainType.Steppe)
					{
						this.Flags.set("IsBurnedFarmsteadShown", true);
						this.Contract.setScreen("BurnedFarmstead");
						this.World.Contracts.showActiveContract();
					}
					else if (!this.Flags.get("IsCaravanShown") && playerTile.HasRoad)
					{
						this.Flags.set("IsCaravanShown", true);
						this.Contract.setScreen("DestroyedCaravan");
						this.World.Contracts.showActiveContract();
					}
					else if (!this.Flags.get("IsDeadBodiesOrcsShown") && this.Flags.get("IsOrcs") == true)
					{
						this.Flags.set("IsDeadBodiesOrcsShown", true);
						this.Contract.setScreen("DeadBodiesOrcs");
						this.World.Contracts.showActiveContract();
					}
					else if (!this.Flags.get("IsDeadBodiesGoblinsShown") && this.Flags.get("IsOrcs") == false)
					{
						this.Flags.set("IsDeadBodiesGoblinsShown", true);
						this.Contract.setScreen("DeadBodiesGoblins");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (this.Flags.get("IsWarlord") && !this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Const.World.Common.addTroop(this.Contract.m.Target, {
						Type = this.Const.World.Spawn.Troops.OrcWarlord
					}, false);
					this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
					this.Contract.setScreen("Warlord");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsShaman") && !this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Const.World.Common.addTroop(this.Contract.m.Target, {
						Type = this.Const.World.Spawn.Troops.GoblinShaman
					}, false);
					this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
					this.Contract.setScreen("Shaman");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
				}
			}

		});
		this.m.States.push({
			ID = "Running_Merchant",
			function start()
			{
				this.Contract.m.Origin.getSprite("selection").Visible = false;

				if (this.Contract.m.Objective != null && !this.Contract.m.Objective.isNull())
				{
					this.Contract.m.Objective.getSprite("selection").Visible = true;
				}

				this.Contract.m.BulletpointsObjectives = [
					"将商人安全地送回%objectivedirection%方向的%objective%。"
				];
				this.Contract.m.BulletpointsPayment = [];
				this.Contract.m.BulletpointsPayment.push("到达目的地即可得到%reward_merchant%克朗。");
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Objective))
				{
					this.Contract.setScreen("Success2");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
			}

			function end()
			{
				if (this.Contract.m.Objective != null && !this.Contract.m.Objective.isNull())
				{
					this.Contract.m.Objective.getSprite("selection").Visible = false;
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
				this.Contract.m.BulletpointsPayment = [];

				if (this.Contract.m.Payment.Advance != 0)
				{
					this.Contract.m.BulletpointsPayment.push("预付金为" + this.Contract.m.Payment.getInAdvance() + "克朗");
				}

				if (this.Contract.m.Payment.Completion != 0)
				{
					this.Contract.m.BulletpointsPayment.push("预付金为" + this.Contract.m.Payment.getOnCompletion() + "克朗会在事成之后付清");
				}

				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.Contract.m.Origin.getSprite("selection").Visible = false;
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer%佝偻的身姿和时不时的呻吟说明他今天过得糟透了。他揉着太阳穴，用颤抖的声音对你开口。%SPEECH_ON%一个绿皮部落正在%origin%周边地区烧杀抢掠。他们见什么毁什么。 {我手下都吓破了胆。 | 我的人手大多在外巡逻。 | 我的手下非得要天价酬劳才肯干。} 你是阻止这群畜生的最后希望。要是任由他们横行，我们就永无宁日了！%SPEECH_OFF%他缓缓闭眼叹息，继续说道。%SPEECH_ON%反正是绿皮杂种，走到哪儿都会留下痕迹。不难找对吧？把他们全宰了，为%origin%的善良百姓报仇！%SPEECH_OFF% | %employer%凝望窗外，问了个简单的问题。%SPEECH_ON%你知道绿皮杂种抓到婴儿会做什么吗？%SPEECH_OFF%你转过头。角落里的卫兵耸耸肩。你回答这个问题。%SPEECH_ON%知道。%SPEECH_OFF%贵族自顾自点头，回到书桌前沉重地坐下。%SPEECH_ON%有群绿皮正在%origin%肆虐。我要你找到他们，全部杀光。我不能再……他们不该……总之全宰了就对了，行吗？%SPEECH_OFF% | %employer%举着蜡烛贴近书本，烛光映得他眼神晦暗，正专注地盯着你看不懂的文字。%SPEECH_ON%据说绿皮在这片土地上有很悠久的历史……你信吗？%SPEECH_OFF%你耸耸肩凭认知回答。%SPEECH_ON%想在这世道活下去就得厮杀，而绿皮确实像活了很久的样子。%SPEECH_OFF%他点头，似乎很欣赏你的见解。%SPEECH_ON%现在有伙绿皮在%origin%周边流窜。见什么烧什么，见谁杀谁……这些都很明显。同样明显的是我需要你，佣兵，去找到并消灭他们。有兴趣吗？%SPEECH_OFF% | %employer%瘫在椅子里自顾自发笑——同时又把脸埋在掌心，活像藏起窃笑的小丑。这副模样实在不体面。他抬起疲惫的双眼望向你。%SPEECH_ON%绿皮又开始作乱了。我不知道他们在哪儿，只知道他们去过哪里。你认得那些痕迹对吧？%SPEECH_OFF%你点头回答。%SPEECH_ON%他们会留下很显眼的踪迹，我指的可不只是脚印。%SPEECH_OFF%他又笑了，却是带着痛苦的苦笑。%SPEECH_ON%看来我得靠你来解决了。你接这活吗？%SPEECH_OFF% | %employer%起身走到窗边，停住脚步摇摇头，又回到桌前，缓缓坐下。%SPEECH_ON%起初我听说是一帮土匪。后来又说是上岸的海寇。直到幸存者开始描述……现在你明白我的麻烦了吧？%SPEECH_OFF%你耸耸肩。%SPEECH_ON%有区别吗？%SPEECH_OFF%他挑起眉毛。%SPEECH_ON%是绿皮，佣兵。就是他们。正在%origin%周边肆虐，我需要你阻止这群畜生。现在觉得有区别了吗？%SPEECH_OFF%}}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{我们可以猎杀他们，只要价钱合适。 | 对抗绿皮可不便宜。 | 佣金是多少？}",
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
			ID = "DestroyedCaravan",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_60.png[/img]{一支商队。显然状况不佳。货车被掀翻，车夫惨遭屠杀。你赶走秃鹫仔细查看现场。即使这惨状还不能说明是绿皮干的，那些扭曲的脚印也足以证实。你找对方向了。 | 绿皮的踪迹并不难追踪。你撞见一排燃烧的商队货车。火焰还在熊熊燃烧，正吞噬着车厢木板。商队伙计和商人的尸体也刚断气不久，死前似乎都惊恐万状。继续前进，你说不定还能追上那些绿皮杂种。 | 一具尸体挂在孤树的枝杈间，仿佛从天而降穿刺在上。树干旁倒着两头死驴。再往前，一辆货车四面散架，轮子迸裂碎散。货物撒得遍地都是。残存的营火苟延残喘地舔舐着四周，为渐弱的火势寻找着最后的燃料。\n\n这绝对是绿皮干的好事，你毫不怀疑。很快就能追上他们了。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们快找到他们了",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BurnedFarmstead",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_71.png[/img]{几缕缕烟雾从农庄废墟中缭绕升起。一具尸体躺在曾经的门口，半边身子不见了。剩下的半截脸上凝固着惊恐的表情，烧焦的手臂伸向某个早已消失的人或物。泥草间散落着零星的脚印。是绿皮。你越来越近了。 | 这座小农庄毫无招架之力。你看见农工们横尸四处，手中还紧握着当作武器的草叉。其中一根齿尖沾着血迹——绝非人类的血。沿着踪迹追寻，你知道很快就能追上制造这起惨案的元凶。 | 一条死狗。又一条。看样子都是牧羊犬，虽然残忍的伤势让它们难以辨认。牧主们就在不远处——看来他们在犬群断后时试图逃跑。不幸的是，脚印表明这些农民撞上了绿皮。忠犬们奋勇抵抗，主人们拼命奔逃。\n\n很近了。继续前进，马上就能追上那群畜生。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们快找到他们了",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "DeadBodiesOrcs",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_60.png[/img]{辨认兽人的手笔很容易：现场看起来工整精准吗？如果是，那就不是兽人干的。你眼前是散落一地的尸体和残肢，主干和零件全都混作一团。把这些拼回去得花一星期都不止。继续追踪，很快就能撞上那群兽人。 | 你发现一具被腰斩的尸体。另一个被竖着劈开。还有个脑袋被砸进胸腔的。另一具遍体鳞伤，当你上前查看时，里面的每根骨头都在松动移位——完全碎透了。这绝对是兽人的杰作。看来你已经咬住他们的行踪了。 | 一具尸体被反向对折，脑袋碰到了脚后跟。另一具胸口开着大洞，还有一具似乎被参差不齐的钝器开了膛。没有一具尸体是完整的。毫无疑问，这是兽人干的好事。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "看来我们狩猎的兽人。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "DeadBodiesGoblins",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_60.png[/img]{你撞见一个人靠在路标上。当你问他是否见过绿皮时，他直接向前倾倒摔在地上。背上插着几支飞镖。看来这回答了你的问题。也说明你追踪的是地精，不是兽人。 | 兽人不会留下这种现场。你发现一连串农民和他们的狗被杀死，但现场不算太乱。这儿有刺伤，那儿有小孔。到处散落着飞镖，镖尖还涂着毒。这是……地精的手笔。他们肯定离得不远。 | 草丛里躺着个人，脖子上插着支飞镖。他脸色发紫，舌头吐在外面，双手紧紧攥着，仿佛在抓住自己。这无疑是某种致命剧毒的效果。也无疑不是兽人，而是地精干的。他们肯定就在附近……}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "看来我们狩猎的是地精。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BattleWonOrcs",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_81.png[/img]{当你的手下放倒最后一个兽人，你环顾四周。绿皮们打得很是生猛。该清点战团情况并准备返回雇主%employer%那里了。 | %employer%的手下绝对没办法复刻你刚才的事迹。只有%companyname%才能解决这些绿皮。你为战团感到骄傲，但尽量不表现出来。 | 战斗结束了，弟兄们的几个赌约也见了分晓。事实证明，把兽人脑袋砍下来它就不咬人了！雇主%employer%大概不在乎这种野蛮实验，但他会为你今天的活儿付钱。 | 兽人的抵抗连好人看了都得夸一句。但他们终究敌不过%companyname%，至少今天不行！ | 雇主%employer%要你宰了这些绿皮，你完美达成了。现在该查看队伍状况，准备回去领辛苦钱了。 | 和兽人干架从来不是轻松差事，这次也不例外。不过%employer%酬金会让%companyname%的辛苦好受些。 | 雇主%employer%最好为对付这些畜生付足酬劳——他们可不好解决！清点你的队伍，准备回去见雇主。}",
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
			ID = "BattleWonGoblins",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_83.png[/img]{地精个子不大，打起仗来却一点不能小瞧！ 你的雇主%employer%会对今天的成果满意的。 | 你常听人嘲笑地精的个头。是啊，他们确实矮小，但打起来可是拼了老命。\n\n清点你的队伍，准备回去找雇主%employer%领赏吧。 | 这些地精打起来像饿疯的野狗。饥饿、狡诈、嗜血的野狗。可惜他们的机灵没用在正道上。不过%employer%会喜欢这里的捷报。 | 不知该不该庆幸，你的雇主%employer%当初并不完全确定这里出没的是地精。要是他知道情况，会不会就不给那么高的价码了？地精看着是不起眼，但天杀的真会打架。\n\n无论如何，该整队回去见雇主了。 | 地精全躺下了。真是群烦人的东西。你的雇主%employer%该对今天的成果感到满意。 | 一堆地精尸体叠起来还够不到兽人狂战士的腰。可是……他们打起来丝毫不逊色！可惜这份能耐浪费在小身板上了。但话说回来，要是把他们的狡诈装在兽人的躯壳里……旧神在上，这念头真吓人！}",
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
			ID = "Warlord",
			Title = "在攻击前……",
			Text = "[img]gfx/ui/events/event_49.png[/img]{当你接近兽人战团的时候，一眼就认出了其中一个高大的身影是兽人军阀。看来对付这群绿皮要比预想的更加棘手。 | 兽人队伍里有个高大的军阀。但这没什么影响。好吧，是有点影响，不过最终目标不受影响：把他们全宰了。 | 真是个不幸的消息！兽人阵营里赫然立着个军阀——当然是说对那个军阀不幸。你相信他爬到这位置不容易，可惜%companyname%马上要去灭了他了。 | 绿皮群里有个军阀！那块头和吼声绝不会认错——就算有头熊在你面前大吼你也听得出来！无所谓，这家伙会和其他绿皮一样变成尸体。 | 军阀。巨型兽人。凶兽人。这些名头你都听过。此刻就有这么个庞然大物矗立在绿皮营地。他们的首领之一。他们最强的战士之一。那又怎样？根本无所谓。当然无所谓！完全无所谓。一切都会按计划进行。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Shaman",
			Title = "在攻击前……",
			Text = "[img]gfx/ui/events/event_48.png[/img]{接近时，你看到一缕怪烟袅袅升起。不是灰烬般的灰色，而是紫色，其中还有仿佛活物的绿色触须在缠绕穿梭。地精在这里，他们还带着一个萨满！ | 萨满！你到哪都能认出这种狡猾地精——骨制饰品，斜眯的眼睛，在地精的蠢脸上难得一见的狡黠神情。这些绿皮很危险，当心点！ | 喂，注意脚下。地精萨满就站在敌军队伍里！这可是最危险的敌人！别因为它个子小就掉以轻心…… | 你听过有些萨满能从人耳朵里抽出梦境的传说。你不确定是不是真的，但你很清楚他们都是狡猾的对手，而现在你就要面对其中一个！ | 地精萨满……那身骨制装束和伪装斗篷到哪都认得出来！保持冷静，继续前进——把这群绿皮全宰了！ | 萨满。一位地精萨满……你听过关于他们“妖术”的恐怖传说，但现在不是讨论这个的时候。让兄弟们准备进攻！ | 地精萨满。你听说过这些下流杂种能蛊惑人心的传闻。你现在怀疑%employer%是不是被忽悠了才把你派来这。\n\n应该……不是……吧？ | 地精萨满！你听过关于这些邪恶家伙的传闻。有人说他们把黄蜂塞进俘虏耳朵里！还有个喝得醉醺醺的家伙告诉你说，他亲眼看见蜜蜂把人的脑子改造成了蜂巢！那蜂蜜尝起来肯定够呛！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Merchant",
			Title = "战斗之后……",
			Text = "{战斗结束后，你在战场中发现一个令人意外的俘虏：一名商人。他穿着血迹斑斑的丝绸衣服，满怀感激地走近你，询问能否带他去%objective%。显然，独自赶路对他太危险。你耸耸肩看向别处。那人急忙提高价码，承诺只要护送他就能得到%reward_merchant%克朗，这倒是挺合你心意…… | 一个男人从绿皮尸体堆里钻出来。他不是你的佣兵，而是个双手反绑的商人。你问他怎么落到这步田地，他耸耸肩说从没听说绿皮会留活口。他可真是走运。\n\n环顾四周后，商人凑近说道。%SPEECH_ON%必须感谢你，佣兵，但如你所见我不敢独自赶路了。要是能平安送我到%objective%，我很乐意……呃……付%reward_merchant%克朗给你。 你觉得怎么样？%SPEECH_OFF% | 战斗结束后，你注意到有个商人狼狈地坐在死马旁。这牲口被人误伤弄死了，现在商人可倒大霉了。他望望战场又看看你，抱着马鞍前桥扬声问道%SPEECH_ON%战士先生，你能护送我到%objective%吗？如你所见我的坐骑死在乱战里……当然不是怪你！但我必须赶到镇子里。%SPEECH_OFF%他停顿片刻，在你面前拿出个小钱袋晃悠。%SPEECH_ON%这儿有%reward_merchant%克朗。你觉得如何？%SPEECH_OFF% | 你巡视战场时，有个男人上前打听情况。你边擦剑边让他自己看。他眯起眼睛，莫名踮起脚尖。%SPEECH_ON%啊，绿皮。真不幸……%SPEECH_OFF%他重新站稳。%SPEECH_ON%等会， 绿皮？它们在这儿搞什么？老天爷，这地方不能待了！士兵！护送我去%objective%，我给你%reward_merchant%克朗。我保证不远，但我可不敢一个人走过去。%SPEECH_OFF%他用拇指抹过脖子，指着死了的绿皮。%SPEECH_ON%没人敢冒这种风险，懂吗？%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "行，我们护送你到%objective%。",
					function getResult()
					{
						this.Contract.setState("Running_Merchant");
						return 0;
					}

				},
				{
					Text = "走开，别碍我们的事。",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				if (this.Flags.get("IsOrcs"))
				{
					this.Text = "[img]gfx/ui/events/event_81.png[/img]" + this.Text;
				}
				else
				{
					this.Text = "[img]gfx/ui/events/event_22.png[/img]" + this.Text;
				}

				local merchant = this.Tactical.getEntityByID(this.Flags.get("MerchantID"));
				this.Characters.push(merchant.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_04.png[/img]{你回到%employer%那里，把一个绿皮脑袋扔在他桌上。他连忙往后躲。%SPEECH_ON%你这是干嘛？%SPEECH_OFF%你对着脑袋点头示意，解释说那些脏东西已经全解决了。他迅速掏出手帕擦拭血迹。%SPEECH_ON%是，我看见了。这些脏玩意就该留在原地，不是拿到我眼前！天杀的佣兵……酬金在角落！出去时叫我仆人进来，这烂摊子总得有人收拾！%SPEECH_OFF% | 你回来时%employer%正在给个女人讲故事。你进门时她的娇笑变成了渴望的凝视。他见状赶紧把她打发出去，生怕真汉子在场让她昏倒。%SPEECH_ON%佣兵！有什么消息？%SPEECH_OFF%你从麻袋里掏出个绿皮脑袋。%employer%盯着它，抿嘴、微笑、皱眉，似乎不知该如何对待眼前这东西。%SPEECH_ON%行……行。你的酬金在这儿，说好的数。%SPEECH_OFF%他把一个木箱提到桌上。%SPEECH_ON%出去时叫那姑娘回来。%SPEECH_OFF% | 你把绿皮脑袋摆在%employer%桌上。他挺直身子展开卷轴，对比着绿皮画像和真货的差异。%SPEECH_ON%嗯，得告诉学者们他们画得……有些不对。%SPEECH_OFF%你问哪里不对。%SPEECH_ON%他们涂成灰色。这明明是绿色的。%SPEECH_OFF%你嘀咕也许是学者们没有绿色墨水。他抿嘴点头。%SPEECH_ON%呵，有道理。门外卫兵拿着你的酬金。让我好好研究这……标本。%SPEECH_OFF% | 你进门时%employer%身边站着个穿长袍的男人。那人埋头看卷轴，根本没瞥你一眼。你耸耸肩从麻袋掏出绿皮脑袋放在雇主桌上。这下陌生人注意到了，连脑袋也一把抢走！他抓起脑袋立刻冲出房间，兴奋得几乎嚎叫。你问那是什么人。%employer%大笑。%SPEECH_ON%学者们一直盼着你回来。他们早想找新东西研究了。%SPEECH_OFF%他取出钱袋递过来。你数着克朗问那些书呆子会不会另付报酬。%employer%耸肩。%SPEECH_ON%前提是你能跟他们谈上话，不是说他们人不好找，而是那些人满脑子只有自己的想法，根本就注意不到别人的存在！%SPEECH_OFF% | %employer%一手抓鸟一手握石。你问他在干嘛。%SPEECH_ON%我在琢磨哪个更值钱。一鸟在手，还是……石头……等等……%SPEECH_OFF%你没空陪他疯，把绿皮脑袋砸在桌上问这值多少。他放开鸟把石头放回书架，转身递来酬金。%SPEECH_ON%看这……玩意儿，我的麻烦应该解决了。酬金，说好的数。%SPEECH_OFF%你确实好奇他到底怎么逮住那鸟的，但决定不再深究。 | 你回来时%employer%正咳得厉害。他瞥了你一眼，拳头抵在唇边。%SPEECH_ON%你该不会也带来什么厄运吧？%SPEECH_OFF%你耸耸肩把绿皮脑袋放他桌上，说已经全解决了。%employer%瞟了一眼。%SPEECH_ON%看来我的病是别的原因……但是什么呢？ {女人？多半是女人。说实话，永远是女人惹的祸。 | 野狗。人们都说那些癞皮狗会带来疯病。 | 黑猫！对，肯定是！我要把它们全宰了！ | 小孩。那些小鬼最近吵得要命。他们在嘻嘻哈哈背后策划什么？ | 可能是我吃了没熟的肉……或者……不，我肯定是因为山上住的疯婆子。 | 我确实吃过被老鼠啃过的面包。不是这个就是女人。你知道的，那些该死的娘们整天让我们染病堕落！}%SPEECH_OFF%这个男人停了下来，然后摇了摇头。%SPEECH_OFF%他顿了顿摇头。%SPEECH_ON%啊，无所谓了。酬金由门外卫兵手里。是说好的数目，不过你尽管清点。天晓得我这状态会不会数错！%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "处理四处劫掠的绿皮");
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
		this.m.Screens.push({
			ID = "Success2",
			Title = "%objective%里……",
			Text = "[img]gfx/ui/events/event_20.png[/img]{安全抵达%objective%后，商人转身向你道谢。他如约递来一袋克朗，随即匆匆进城。 | %objective%的景象让人眼前一亮，同行的商人也喜出望外——这位被你护送的男子激动地大喊大叫，不知是因保住性命而狂喜，还是为即将赚大钱而兴奋。他冲向附近旅店又迅速折返，手里攥着个钱袋。%SPEECH_ON%按约定给你，佣兵。我欠你的远不止这些。%SPEECH_OFF%你狡黠地问他还愿意付多少。他大笑。%SPEECH_ON%我可不敢给自己脑袋标价，保不准真有人想买呢！%SPEECH_OFF%你会意点头，对当前报酬已很满意。 | 到达%objective%后，商人按约定数额支付了报酬。随即匆匆离开，嘴里念叨着要赚大把克朗，睡遍漂亮姑娘。 | 你将商人平安送达%objective%。他道谢后匆忙赶往附近酒馆，回来时拎着个塞得鼓囊囊的钱袋，像袜子里塞了个柚子。他把钱袋抛给你。%SPEECH_ON%你的报酬，佣兵。我向你献上我的谢意——还有我的克朗。现在失陪了……%SPEECH_OFF%他整理好衣裤，昂起下巴。%SPEECH_ON%……我还要去赚大钱呢。%SPEECH_OFF%说罢转身迈步离开，步伐里带着精打细算的轻快。}",
			Image = "",
			List = [],
			Characters = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "这钱好挣。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Flags.get("MerchantReward"));
						return 0;
					}

				}
			],
			function start()
			{
				local merchant = this.Tactical.getEntityByID(this.Flags.get("MerchantID"));
				this.Characters.push(merchant.getImagePath());
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("MerchantReward") + "[/color]克朗"
				});
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"objective",
			this.m.Objective != null ? this.m.Objective.getName() : ""
		]);
		_vars.push([
			"objectivedirection",
			this.m.Objective == null || this.m.Objective.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Objective.getTile())]
		]);
		_vars.push([
			"reward_merchant",
			this.m.Flags.get("MerchantReward")
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
			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			if (this.m.Objective != null && !this.m.Objective.isNull())
			{
				this.m.Objective.getSprite("selection").Visible = false;
			}

			this.m.Origin.getSprite("selection").Visible = false;
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
		if (this.m.Origin.getOwner().getID() != this.m.Faction)
		{
			return false;
		}

		return true;
	}

	function onIsTileUsed( _tile )
	{
		if (this.m.Objective != null && !this.m.Objective.isNull() && _tile.ID == this.m.Objective.getTile().ID)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		if (this.m.Target != null && !this.m.Target.isNull() && this.m.Target.isAlive())
		{
			_out.writeU32(this.m.Target.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		if (this.m.Objective != null && !this.m.Objective.isNull() && this.m.Objective.isAlive())
		{
			_out.writeU32(this.m.Objective.getID());
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

		local objective = _in.readU32();

		if (objective != 0)
		{
			this.m.Objective = this.WeakTableRef(this.World.getEntityByID(objective));
		}

		this.contract.onDeserialize(_in);
	}

});
