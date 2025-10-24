this.hunting_serpents_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		Dude = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_serpents";
		this.m.Name = "狩猎大蛇";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 550 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"猎杀大蛇，大概在 " + this.Contract.m.Home.getName()
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					if (this.Const.DLC.Lindwurm && this.Contract.getDifficultyMult() >= 1.15 && this.World.getTime().Days >= 30)
					{
						this.Flags.set("IsLindwurm", true);
					}
				}
				else if (r <= 20)
				{
					this.Flags.set("IsCaravan", true);
				}

				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				local disallowedTerrain = [];

				for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
				{
					if (i == this.Const.World.TerrainType.Oasis)
					{
					}
					else
					{
						disallowedTerrain.push(i);
					}
				}

				local playerTile = this.World.State.getPlayer().getTile();
				local mapSize = this.World.getMapSize();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 14, disallowedTerrain);
				local party;
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "大蛇", false, this.Const.World.Spawn.Serpents, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.setDescription("四处游荡的大蛇。");
				party.setFootprintType(this.Const.World.FootprintsType.Serpents);
				party.setAttackableByAI(false);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				local wait = this.new("scripts/ai/world/orders/wait_order");
				wait.setTime(999999);
				c.addOrder(wait);
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

				this.Contract.m.BulletpointsObjectives = [
					"猎杀湿地里的大蛇在%direction%离 " + this.Contract.m.Home.getName()
				];
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					if (this.Flags.get("IsCaravan"))
					{
						this.Contract.setScreen("Caravan2");
					}
					else
					{
						this.Contract.setScreen("Victory");
					}

					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (!this.Flags.get("IsBanterShown") && this.Contract.m.Target.isHiddenToPlayer() && this.Contract.isPlayerNear(this.Contract.m.Target, 700) && this.Math.rand(1, 100) <= 1 && this.Flags.get("StartTime") + 10.0 <= this.Time.getVirtualTimeF())
				{
					this.Flags.set("IsBanterShown", true);
					this.Contract.setScreen("Banter");
					this.World.Contracts.showActiveContract();
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (this.Flags.get("IsLindwurm"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("Lindwurm");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.Music = this.Const.Music.BeastsTracks;
						properties.EnemyBanners.push(this.Contract.m.Target.getBanner());
						properties.Entities.push({
							ID = this.Const.EntityType.Lindwurm,
							Variant = 0,
							Row = -1,
							Script = "scripts/entity/tactical/enemies/lindwurm",
							Faction = this.Const.Faction.Enemy
						});
						this.World.Contracts.startScriptedCombat(properties, true, true, true);
					}
				}
				else if (this.Flags.get("IsCaravan"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("Caravan1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local f = this.Contract.m.Home.getFaction();
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "HuntingSerpentsCaravan";
						properties.Music = this.Const.Music.BeastsTracks;
						properties.EnemyBanners.push(this.Contract.m.Target.getBanner());
						properties.Entities.push({
							ID = this.Const.EntityType.CaravanDonkey,
							Variant = 0,
							Row = 3,
							Script = "scripts/entity/tactical/objective/donkey",
							Faction = f
						});

						for( local i = 0; i < 2; i = ++i )
						{
							properties.Entities.push({
								ID = this.Const.EntityType.CaravanHand,
								Variant = 0,
								Row = 3,
								Script = "scripts/entity/tactical/humans/conscript",
								Faction = f
							});
						}

						this.World.Contracts.startScriptedCombat(properties, true, true, true);
					}
				}
				else
				{
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getType() == this.Const.EntityType.CaravanDonkey && _combatID == "HuntingSerpentsCaravan")
				{
					this.Flags.set("IsCaravan", false);
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
			Text = "[img]gfx/ui/events/event_162.png[/img]{%employer%在他的房间欢迎你的到来。这里极尽奢华——充斥着大量的精美物品，从丝绸、毛皮、女人到宝石，宝石尤其多。%SPEECH_ON%%SPEECH_ON%逐币者，你总算来了。我们有一桩经济事务需要解决。大蛇正袭扰着%direction%边湿地附近的居民。但更重要的是，我们想要这些蛇皮。它们能做成顶级的……%SPEECH_OFF%这人吻了吻自己的手指。%SPEECH_ON%包和鞋子。看看这些女人，没看到她们对蛇皮的渴望吗？%SPEECH_OFF%女人们都盯着自己的手或互相交谈。维齐尔拍了拍手。%SPEECH_ON%手提包，我甜蜜、美丽的鸟儿们，用蛇皮做的手提包！对，笑一笑。这就对了。瞧见没？这有什么难的？好了，逐币者。带回蛇皮的报酬是%reward%克朗。这个价钱，你同意接下任务吗？%SPEECH_OFF% | 你看到%employer%正在抚摸一只异常高大的鸟，它长着粉色羽毛和黑色的长腿。他正喂它吃蟋蟀，但这鸟似乎不怎么感兴趣。%SPEECH_ON%啊，我把你宠坏了，小鸽子。%SPEECH_OFF%他开始喂这奇怪的生物长长的银色小鱼，鱼是他从一只金桶里捞出来的，还活着。那鸟正一条接一条地吞吃小鱼，而他看也不看你地说道。%SPEECH_ON%我们这里得知，%direction%方向的湿地里有大蛇。它们的蛇皮价值不菲，当然，不是金钱价值，而是艺术价值。我们希望你去那里，往你的行李里塞满蛇皮，然后迈着你那小短腿跑回来。%SPEECH_OFF%这人抬起一根手指，举高，然后指向他脚下的瓷砖。%SPEECH_ON%为此，我们会支付你%reward%克朗。%SPEECH_OFF%那只粉色的鸟整理着羽毛，似乎代替它的照料者凝视着你。 | %employer%正坐在桑拿浴室的边缘，但他的脚却埋在躺在某种室内水渠里的女人们的手中。她们正用着芦苇杆呼吸，据你观察，她们正在给这个男人按摩脚。这景象很荒谬，但这位维齐尔对此的关注度就和对你的关注度一样低。%SPEECH_ON%啊，逐币者来了，我们渴望，一如既往地渴望，得到大蛇的蛇皮，用来装饰我们的奢侈品。蛇皮在蛇身上，而蛇本身呢……嗯，舒服……在%direction%边的……啊……湿地那里。%SPEECH_OFF%这人向后靠去，短暂地将脚趾抬出水面。他一边盯着你，脚趾一边扭动着。%SPEECH_ON%报酬是%reward%克朗，你接受这个优厚、公平的出价吗？}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{我很感兴趣。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{听起来这活不适合我们。 | 我们不想接这类差事。}",
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
			Text = "[img]gfx/ui/events/event_161.png[/img]{你发现了一长条干燥的蛇蜕，粗得足以让你把胳膊伸进去，视觉和感觉上都很令人不安。大蛇无疑就在这些空壳附近。 | 一个嘴里嚼着绿叶的人挡住了你。人拦住了你。他腰带上别着一把匕首，柄上覆着蛇皮，柄头是一个金色的蛇头。%SPEECH_ON%猎大蛇的，是吧？我本来想自己动手的，你看得出我这迷人的派头和这把美味的匕首，但唉，我现在更喜欢看别人干活。我只能说，它们很近，这些小蛇。%SPEECH_OFF%你尽快告别了这个人。 | 有几个孩子在一个沼泽水坑里玩耍，泥巴糊满了他们的膝盖和手肘。他们看着你，问你在干什么。当你说明来意后，孩子们笑了。%SPEECH_ON%大蛇啊！那都是小意思！在我看来根本用不着操心。%SPEECH_OFF% | 你发现一堆蛇皮缠绕在湿地的一棵树干上。大蛇无疑是利用这棵树来蜕皮的。而鳞片的大小，每一片都远大于箭头，这已是你所需的足够证据，表明大蛇就在附近。}",
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
			ID = "Victory",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_169.png[/img]{最后一条大蛇也死了。你一脚踩在它的头上，然后抬起脚才发现那其实是尾巴。你沿着蛇身走到它真正的头部，干净利落地将其斩下。由于它不再扭动滑行，这活儿可就容易多了。%employer%会想看到你带着蛇头和所有蛇皮回去的。 | 你在战场上四处走动，将大蛇一条条扔进逐渐鼓胀起来的背包。即使已经死去，它们在袋子里似乎仍在彼此蠕动缠绕。收集完所有大蛇后，你准备返回%employer%那里。 | 大蛇全死了，它们一动不动就是明证。不过，为了确保万无一失，你还是走了一圈，把所有蛇头都砍了下来。在确定没有什么生物能在如此重创下存活后，你将大蛇们扔进背包，准备返回%employer%处。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "赶快完事吧，还有赏金等着我们呢。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Lindwurm",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_129.png[/img]你看见第一条大蛇正在一棵看似倒下的湿地树木旁扭动。当你靠近那蛇时，你意识到还有更多条在附近潜行。接着你意识到，它们所盘踞的东西根本就不是树：它那庞大的躯干移动并翻转过来，你看到鳞片——每片都有你手掌那么宽——在光线下闪烁，那林德蠕龙昂起头颅并转过来，它锐利的眼睛聚焦，瞳孔收缩成狭长的黑色，随后它张开大口发出咆哮，其怒吼掠过水面，引得湿地之水泛起涟漪。",
			Image = "",
			List = [],
			Options = [
				{
					Text = "一条林德蠕龙！",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Caravan1",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_149.png[/img]{商队通常不会驻扎在湿地，因此当你发现一支商队且其守卫们正四处奔跑时，不免有些惊讶。起初你以为是抵达了秘密藏身处的强盗在卸货，但当你靠近时，却看到一名护卫被一条卷曲而来的凶残大蛇缠住，倒了下去。另一名护卫转过身，大蛇的巨口便猛地咬住了他的脑袋。商队遇袭了！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "保护他们！",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Caravan2",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_169.png[/img]{战斗结束，商队首领亲自来到你面前。%SPEECH_ON%感谢你，逐币者。你或许是金钱的奴隶，但你的锁链上有着所有人都希望拥有的——善心。%SPEECH_OFF%其实，你只是为大蛇而来，商队不过是巧合，是让怪物远离你手下弟兄的、受欢迎的活饵。你正要告诉他这些，但他手中拿着一袋财宝打断了你。%SPEECH_ON%作为你出手相助的报酬，逐币者。愿你通往金钱的镀金之路愈发闪耀。%SPEECH_OFF%你点点头，与他握了握手，然后便开始剥下大蛇的蛇皮。那商人问他能否拿上一份，但你的手按在剑上，告诉他这里不是他停靠的贸易站。他明白了你的意思。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "我们出发！",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				local e = this.Math.rand(1, 2);

				for( local i = 0; i < e; i = ++i )
				{
					local item;
					local r = this.Math.rand(1, 3);

					switch(r)
					{
					case 1:
						item = this.new("scripts/items/trade/spices_item");
						break;

					case 2:
						item = this.new("scripts/items/trade/silk_item");
						break;

					case 3:
						item = this.new("scripts/items/trade/incense_item");
						break;
					}

					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "你获得了" + item.getName()
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Success",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_162.png[/img]{一群女人朝你涌来。人数实在太多了，通往%employer%房间的门时隐时现，在一阵飞舞的丝巾、飘扬的羽毛、闪亮的珠宝，以及比你见过的任何发丝都更纤细的、普遍旋动抛洒的秀发间闪烁不定。还有那相当扰人的嘈杂声。\n\n蛇皮基本上就是从你手中被抢走了，而身处维齐尔的地盘，你并没有真正抵抗这种窃取。当女人们咯咯笑着散去，一位年长得多的女人留了下来。她递出一袋克朗，作为你的报酬。%SPEECH_ON%维齐尔不想和你说话，逐币者。他认为这有失他的身份。%SPEECH_OFF%你问她来见你是否也有失身份。她点点头。%SPEECH_ON%是的，但我宁愿让自己屈就于一项任务，也不愿屈居于维齐尔本人之下。祝你有美好的一天，逐币者，愿你通往金钱的镀金之路永远闪耀。%SPEECH_OFF% | 一大群佣人从你手中接过了大蛇蛇皮。维齐尔指挥着他们，在房间后方十分严厉地盯着。当他们离开时，他抬起手拍了拍。四个佣人抬着一个口袋走过来。你以为是有额外的报酬给你个惊喜，但当他们递过来时，你发现自己一个人就能轻松拿住。你抬眼望去，看见维齐尔正腼腆地咧嘴笑着。你收下了%reward_completion%克朗，然后便离开了。 | 在维齐尔的地盘上，大蛇蛇皮在你手里没待多久。你遇到一连串的佣人匆匆赶来，从你手中接走货物。维齐尔本人就在附近，你很清楚，他可能正从某扇窗户或门廊里注视着。但你没有确切看到他。不过，你看到了他的钱，一位腼腆的佣人递给一个装着%reward_completion%克朗的钱袋。%SPEECH_ON%我主人的恩典交予你。%SPEECH_OFF%那仆人说道，随后他就那样小跑着离开，消失不见了。}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "猎杀了一些大蛇");
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
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Target.getTile())]
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0 && this.Math.rand(1, 100) <= 50)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/moving_sands_situation"));
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
