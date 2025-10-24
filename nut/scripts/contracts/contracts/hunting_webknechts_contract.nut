this.hunting_webknechts_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		Dude = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_webknechts";
		this.m.Name = "狩猎蛛魔";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 450 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"猎杀林中蛛魔，大概在" + this.Contract.m.Home.getName()
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
					if (this.Contract.getDifficultyMult() >= 0.9)
					{
						this.Flags.set("IsOldArmor", true);
					}
				}
				else if (r <= 20)
				{
					this.Flags.set("IsSurvivor", true);
				}

				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				local disallowedTerrain = [];

				for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
				{
					if (i == this.Const.World.TerrainType.Forest || i == this.Const.World.TerrainType.LeaveForest || i == this.Const.World.TerrainType.AutumnForest)
					{
					}
					else
					{
						disallowedTerrain.push(i);
					}
				}

				local playerTile = this.World.State.getPlayer().getTile();
				local mapSize = this.World.getMapSize();
				local x = this.Math.max(3, playerTile.SquareCoords.X - 9);
				local x_max = this.Math.min(mapSize.X - 3, playerTile.SquareCoords.X + 9);
				local y = this.Math.max(3, playerTile.SquareCoords.Y - 9);
				local y_max = this.Math.min(mapSize.Y - 3, playerTile.SquareCoords.Y + 9);
				local numWoods = 0;

				while (x <= x_max)
				{
					while (y <= y_max)
					{
						local tile = this.World.getTileSquare(x, y);

						if (tile.Type == this.Const.World.TerrainType.Forest || tile.Type == this.Const.World.TerrainType.LeaveForest || tile.Type == this.Const.World.TerrainType.AutumnForest)
						{
							numWoods = ++numWoods;
						}

						y = ++y;
					}

					x = ++x;
				}

				local tile = this.Contract.getTileToSpawnLocation(playerTile, numWoods >= 12 ? 6 : 3, 9, disallowedTerrain);
				local party;
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "蛛魔", false, this.Const.World.Spawn.Spiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.setDescription("一大群蛛魔正在四周窸窣爬动。");
				party.setFootprintType(this.Const.World.FootprintsType.Spiders);
				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);

				for( local i = 0; i < 2; i = ++i )
				{
					local nearTile = this.Contract.getTileToSpawnLocation(playerTile, 4, 5);

					if (nearTile != null)
					{
						this.Const.World.Common.addFootprintsFromTo(nearTile, party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Spiders, 0.75);
					}
				}

				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setNoTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Forest, true);
				roam.setTerrain(this.Const.World.TerrainType.LeaveForest, true);
				roam.setTerrain(this.Const.World.TerrainType.AutumnForest, true);
				roam.setMinRange(1);
				roam.setMaxRange(1);
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
					if (this.Flags.get("IsOldArmor") && this.World.Assets.getStash().hasEmptySlot())
					{
						this.Contract.setScreen("OldArmor");
					}
					else if (this.Flags.get("IsSurvivor") && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
					{
						this.Contract.setScreen("Survivor");
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
					local tileType = this.World.State.getPlayer().getTile().Type;

					if (tileType == this.Const.World.TerrainType.Forest || tileType == this.Const.World.TerrainType.LeaveForest || tileType == this.Const.World.TerrainType.AutumnForest)
					{
						this.Flags.set("IsBanterShown", true);
						this.Contract.setScreen("Banter");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (!this.Flags.get("IsEncounterShown"))
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
					this.Contract.setScreen("Success");
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
			Text = "[img]gfx/ui/events/event_43.png[/img]{%employer%招手让你进屋。你注意到有几个手持草叉的男子正神情严肃地盯着窗外保持警戒，虽然其中一个显然靠墙睡着了。你直接问这位镇长有何要事。他开门见山。%SPEECH_ON%偏远地区的村民报告说有怪物抓走小孩和狗之类的东西。我本来不想助长这种疑神疑鬼的风气，但这些描述听起来很像蜘蛛——我父亲那辈人管它们叫蛛魔，如果是真的，很可能它们在这片地方已经筑了个巢。我需要你找到并摧毁它。 有兴趣吗，佣兵？%SPEECH_OFF% | 你见到%employer%时，他正用两把叉子拉扯着蛛丝。他将其中一把扭转，把蛛丝缠成线绳。叹了口气，他终于抬头看你：%SPEECH_ON%我本来没想找佣兵来处理，可现在实在没办法。巨型蜘蛛到处活动，偷牲口和宠物。有个妇人报案说婴儿从摇篮里消失，只剩一堆蛛网。需要有人解决这些可怕生物，端掉它们的巢穴。报酬到位的话，你接不接这活儿？%SPEECH_OFF% | 你刚走近%employer%，光是你的人影就把对方吓了一跳。他在桌前坐直身子点头。%SPEECH_ON%别介意，我有点紧张。不是说你吓人，佣兵，但这带传闻有巨型蜘蛛出没。我去过某个农庄，亲眼见过巨大的蛛网和被啃光的牲口，所以相信这些传言。现在需要个擅长以暴制暴的行家——说的就是你——去找到怪物巢穴彻底清除它们。有兴趣吗？%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{你能拿出多少克朗？ | 谈谈报酬吧。 | 佣金是多少？}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{听起来这活不适合我们。}",
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
			Text = "[img]gfx/ui/events/event_25.png[/img]{你经过了一只死掉的牛，血肉被吸食干净，表皮却没有风干痕迹。%randombrother%蹲下用手指探查那些穿刺伤口，点头道。%SPEECH_ON%准是蛛魔干的。它们先毒倒这牲口，再慢慢吸食。尸体还新鲜说明它们就在附近……%SPEECH_OFF% | 你看见一具缠满蛛网的尸体靠在大树上。割开丝茧后，一具孩童的躯干滑落在地——面皮紧贴头骨，惨白的颅骨上嵌着深陷的眼球，舌头萎缩，鼻子几乎消失。%randombrother%啐了口唾沫点头说。%SPEECH_ON%没错，我们很近了。或者说是它们很近了。说句宽慰话，这孩子死透了才被吸干的——蛛魔咬人时注入的毒液没有小孩能扛得住。%SPEECH_OFF%这多多少少宽慰了你一些，是时候让这些怪物面对成年人的怒火了。 | 你发现有个男孩躲在翻倒的手推车底下，小脑袋像蛤蜊里的珍珠般从缝隙里探出窥视。问他怎么回事，他慌里慌张地解释自己在躲蜘蛛，还让你赶紧离开。%SPEECH_ON%想躲自己找推车去！这辆是是我的！%SPEECH_OFF%你拍了拍剑柄说我们就是来找蜘蛛的。男孩瞪大眼睛看着你，点了点头。%SPEECH_ON%这主意可真他妈的糟透了，先生。我压根不知道它们去哪儿了——我原本跟着商队，你现在还看得到商队吗？当然看不到！因为他们全成了蜘蛛的美餐！趁它们没发现你跟我说话，赶紧滚蛋！%SPEECH_OFF%手推车\"哐当\"一声被他拉紧闭合。你懒得再把车掀开，不过离开时还是狠狠踹了它一脚。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "睁大眼睛。",
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
			Text = "[img]gfx/ui/events/event_110.png[/img]{蛛魔的巢穴是个被白色蛛网环绕的土坑，边缘的细丝即使在最微弱的微风中也摇曳不定。当你带领战团深入时，蛛网开始呈现出某种规整的形态——仿佛从冬日的荒原步入文明领域。新近织就的蛛网紧紧包裹着猎物：鹿、狗、与人体等大的茧囊了无生机，它们被妥帖地悬挂在白色丝巢与平面上，如同散落在苍白地毯上的碎屑。一道黑影在纱幕般的巢穴后方悠然显现，它蹲伏着节肢形成天然屏障，头部低垂其间，仿佛这卑劣生物用自己的步足筑起了栅栏。一只人类手掌在它的颚齿间时隐时现，如同恐怖的安抚奶嘴。你来对地方了。 | 蜘蛛巢穴寂静无声，战团行进时的金属碰撞声显得格外突兀，如同冒犯此地的异响。\n\n你发现一个被倒吊在树上的男子，除面部外全身都被茧包裹，蛛丝拉扯着他的皮肤。他请求你割开缠住眼皮的蛛网，你照做了。他的眼睑缓缓闭合，干涩的眼球可能数日来首次得以休息——但随即猛地睁开，男子发出凄厉惨叫。他腰间的茧囊突然鼓起爆裂，涌出密密麻麻的黑色幼蛛。随着蛛群啃噬他的身躯，男子剧烈抽搐着，被蛛群填满的肺部发出汩汩惨叫，垂死痉挛中咳出无数蜘蛛。正当你惊骇后退时，成群巨型蜘蛛正从树林四周涌现！ | 巢穴的位置显而易见——这片纯白蛛网覆盖的区域不见严寒，每棵树、每处灌木、每寸土地都挂着随风飘荡的白色蛛网。 你率队持械闯入，眼前是被蛛网包裹的尸体：它们的胸腔已被撕开发黑，成群的幼蛛正在啃食内脏。\n\n抬头望去，周围树枝间突然亮起无数红色眼睛，整片蛛网笼罩的树林瞬间苏醒——那些守护者一直潜伏在枝叶间，它们蜷缩的节肢与树枝难以分辨，敌人始终就在眼前。当一棵\"树\"突然舒展全部枝干，每根\"树枝\"竟是蜘蛛步足时，你吓得几乎失禁——这场树木伪装的诡计正朝着战团倾覆而下，发出渴求撕咬的窸窣锐响！}",
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
			ID = "Victory",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_123.png[/img]{最后一只蛛魔被解决了，它的腿脚蜷缩收拢，仿佛要永远抓住那柄杀死它的武器。你点头认可战团的表现，随即下令将整个巢穴付之一炬。火焰迅速沿着蛛网蔓延，烧断了丝线桥梁，将毁灭性的火势传递到各个连接点。整个巢穴在烈火中化为灰烬，在巢床深处某处，你们听见幼蛛被烈焰吞噬的尖利惨叫。 | 你走近最后一只蛛魔，凝视它狰狞的口器。它长着一对凶恶的颚肢充当某种牙龈防护，嘴巴本身就是一道裂缝，边缘排列着逆向生长的锋利牙齿，足以撕碎任何试图逃脱的猎物。\n\n下令将整个巢穴烧毁。随着火焰升腾，巢穴深处传来了幼蛛的哀鸣。 | 你准备回去找%employer%，但事先让人将巢穴彻底焚毁。战团成员站在烈焰前，听着幼蛛的尖声惨叫，有时还会被那些像长了腿的小火球一样四处乱窜的小东西逗得发笑。 | 蜘蛛被消灭后，你下令烧掉这该死的地方并准备回程去找%employer%。随着火势蔓延，微小的幼蛛浑身着火跑出来，就像夜间的萤火虫。几个佣兵临时发起比赛，看谁能踩死最多着火的小蜘蛛，直到一只特别胆大的幼蛛差点点着某个佣兵的裤子，这场闹剧才告终。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "赶快完事吧，还有钱等着呢。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "OldArmor",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_123.png[/img]{解决掉蛛魔后，你命令战团简单搜索这些生物的巢穴，但严令佣兵不得单独行动。你和%randombrother%一起四处转悠。你们同时发现了一棵树，这棵树的蛛网明显较少。绕到树后，只见一具骑士尸体靠在树干上。他一只手搭在断剑的剑柄上，另一只手臂齐腕而断，残肢搁在腹部。尸身陷在巢穴中——那是由腐烂的大黄茎秆与腐朽甲壳堆成的厚垫，破碎的甲壳内里中空，散发着毒物的恶臭。%randombrother%点头道。%SPEECH_ON%真是可惜。不管是谁，我敢打赌他肯定能成咱们%companyname%的好手的。%SPEECH_OFF%确实，这场面看来的确像是伟大战士才会有结局。你本想安葬他，但没时间这么做。你吩%randombrother%从尸体上搜集可用之物，准备返回%employer%。}",
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
			],
			function start()
			{
				local item;
				local r = this.Math.rand(1, 2);

				if (r == 1)
				{
					item = this.new("scripts/items/armor/decayed_reinforced_mail_hauberk");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/armor/decayed_coat_of_scales");
				}

				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "你获得了一个 " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Survivor",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_123.png[/img]{战斗结束后，你发现有个男人被蛛丝缠住脚踝倒吊着。他半个身子都被蛛网包裹，腰际垂下的蛛丝像破裙子般晃荡。看来是%companyname%的到来让蜘蛛们丢下了这个猎物。见到你，他微笑道。%SPEECH_ON%嘿，那边的。是佣兵吧？瞧出来了。要不是为了钱，你们也不会来这儿吧？不过你们打起架来像赌场里的恶狗，真够带劲的。%SPEECH_OFF%你问他要是割断蛛网能拿什么好处。他仰起头，整个身子开始晃荡，时不时转得背对你。不管朝哪个方向，他继续喊着%SPEECH_ON%问得好！你看我现在这模样，其实我也是个佣兵。我那群弟兄和队长全被蜘蛛们缠起来吞吃干净了！放我下来，我横竖都得找新东家——你们战团要是收人，我就跟你们混。%SPEECH_OFF%你让人割断蛛网，在返回%employer%之前琢磨着该如何安置这个幸存者。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "欢迎加入战团！",
					function getResult()
					{
						this.World.getPlayerRoster().add(this.Contract.m.Dude);
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude.onHired();
						this.Contract.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "你得到别处去碰碰运气了。",
					function getResult()
					{
						this.World.getTemporaryRoster().clear();
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
					"retired_soldier_background"
				]);

				if (!this.Contract.m.Dude.getSkills().hasSkill("trait.fear_beasts") && !this.Contract.m.Dude.getSkills().hasSkill("trait.hate_beasts"))
				{
					this.Contract.m.Dude.getSkills().removeByID("trait.fearless");
					this.Contract.m.Dude.getSkills().add(this.new("scripts/skills/traits/fear_beasts_trait"));
				}

				this.Contract.m.Dude.getBackground().m.RawDescription = "你在树上发现了挂着的%name%，他是一名佣兵，他所在的佣兵团被派去对付蛛魔，只有他活了下来。在你救下他之后，他便加入了你的战团。";
				this.Contract.m.Dude.getBackground().buildDescription(true);
				this.Contract.m.Dude.worsenMood(0.5, "他以前的战团被蛛魔干掉了");
				this.Contract.m.Dude.worsenMood(0.5, "几乎被蛛魔活活吃掉");

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).setArmor(this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).getArmor() * 0.33);
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).setArmor(this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).getArmor() * 0.33);
				}

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Success",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_85.png[/img]{%employer%在镇口迎接你，身边围着一群镇民。他热情地欢迎你归来，说派了探子目睹整场战斗。他递过酬金后，镇民们依次上前——许多人不敢直视佣兵的眼睛，但还是送上礼物感谢你们消除了蛛魔的恐怖威胁。 | 你四处寻觅%employer%，最终在马厩发现他正和一个农家女孩在一起。他猛地从干草堆里坐起来，惊得马匹嘶鸣跺蹄。衣衫不整的他声称早已备好酬金，说着就把钱塞了过来。见你盯着那姑娘，他开始胡乱抓取手边能拿的东西——包括拴着的马匹鞍袋里的物品——一股脑塞给你。%SPEECH_ON%呃，镇民们也想要表示表示。你懂的，算是谢意。%SPEECH_OFF%为了进一步表达\"谢意\"，你问他能否把附近行囊里的东西也交出来。 | %employer%拍着手热情地迎接你归来，搓手的动作仿佛你带回的是火鸡而不是骇人的战利品。支付约定酬金后，你得知一个意外消息：这位镇长表示有位遇难镇民的遗产无法妥善分配，作为额外感谢，剩下的东西都归你处置。}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "清除城镇附近的蛛魔");
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
				local food;
				local r = this.Math.rand(1, 3);

				if (r == 1)
				{
					food = this.new("scripts/items/supplies/cured_venison_item");
				}
				else if (r == 2)
				{
					food = this.new("scripts/items/supplies/pickled_mushrooms_item");
				}
				else if (r == 3)
				{
					food = this.new("scripts/items/supplies/roots_and_berries_item");
				}

				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "你获得了" + food.getName()
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Target.getTile())]
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/disappearing_villagers_situation"));
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
