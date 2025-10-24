this.lend_men_to_build_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null
	},
	function create()
	{
		this.m.ID = "event.lend_men_to_build";
		this.m.Title = "%townname%里";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_79.png[/img]快到%townname%时，一个当地人朝你们挥手。 他站在一座磨坊的骨架旁。气急败坏地解释说今天的工人全都没来，而且必须在当地男爵抵达前建好磨坊。要是没法按时完工，男爵可能再也不会给他任何承包合同了。战团里正好有几个弟兄以前当过工人，或许能帮上忙？",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我们只会杀人。找别人帮你吧。",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "行，我有人能帮上忙。",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_79.png[/img]你同意派%companyname%中几个建筑好手去帮忙。这些人重操旧业简直轻车熟路，转眼间就分头收集材料，敲敲打打、砌砖抹灰——至于装门？不管这活儿该怎么干，他们都迅速搞定了。待到工程完工，当地人乐得合不拢嘴。他递过一个钱袋。%SPEECH_ON%这是你应得的，好心的先生！ 更重要的是，我欠你个人情，以后我见人就说你们的好话！%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "别太习惯这种工作了，伙计们。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.FactionManager.getFaction(_event.m.Town.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationFavor, "你借出一些人帮忙建了一座磨坊");
				this.World.Assets.addMoney(150);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "你获得了 [color=" + this.Const.UI.Color.PositiveEventValue + "]150[/color]克朗"
					}
				];
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					local id = bro.getBackground().getID();

					if (id == "background.daytaler" || id == "background.mason" || id == "background.lumberjack" || id == "background.miller" || id == "background.farmhand" || id == "background.gravedigger")
					{
						if (this.Math.rand(1, 100) <= 33)
						{
							local effect = this.new("scripts/skills/effects_world/exhausted_effect");
							bro.getSkills().add(effect);
							this.List.push({
								id = 10,
								icon = effect.getIcon(),
								text = bro.getName() + "筋疲力尽了"
							});
						}

						if (this.Math.rand(1, 100) <= 50)
						{
							bro.improveMood(0.5, "帮忙建了一座磨坊");

							if (bro.getMoodState() >= this.Const.MoodState.Neutral)
							{
								this.List.push({
									id = 10,
									icon = this.Const.MoodStateIcon[bro.getMoodState()],
									text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
								});
							}
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_79.png[/img]你答应帮忙修缮房屋。 可惜这人显然没安排妥当。 你的“工人”刚踩上去，屋顶就塌了个窟窿，那人直接从破洞栽进了瓦片堆里。另一个弟兄抡锤钉钉子，支撑木竟应声断裂，木屑溅了满脸。 松动的砖块不断滚落，湿滑的泥地让人摔得四仰八叉——层出不穷的意外最终让整个工程成了一团乱麻。\n\n 当地人一一边啃着指甲喃喃说着该怎么向男爵交代，一边不住地向你赔罪。突然他打了个响指，说自己大不了直接赔钱给男爵就是了。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "那些钱是我们的！",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "那就祝你顺利度过男爵那关吧。",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_79.png[/img]正当这人沉浸在自己想出的完美方案时，你打了个响指将他拉回残酷的现实。%SPEECH_ON%那袋钱是我们的，农民。说好的价钱。%SPEECH_OFF%对方连连摇头，脸颊的肉随着动作直晃。%SPEECH_ON%可磨坊……根本还没完工啊！%SPEECH_OFF%你耸耸肩。%SPEECH_ON%不是我们的问题。马上把钱交出来，不然你就是我们的问题了。%SPEECH_OFF%村民神情凝重地点点头，顺从地将那袋克朗交到你手中。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "希望你下次运气好点。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.FactionManager.getFaction(_event.m.Town.getFactions()[0]).addPlayerRelation(-this.Const.World.Assets.RelationFavor, "在帮助一名有影响力的居民建造一座磨坊后，你强硬要求他支付报酬");
				this.World.Assets.addMoney(200);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "你获得了 [color=" + this.Const.UI.Color.PositiveEventValue + "]200[/color]克朗"
					}
				];
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					local id = bro.getBackground().getID();

					if (id == "background.daytaler" || id == "background.mason" || id == "background.lumberjack" || id == "background.miller" || id == "background.farmhand" || id == "background.gravedigger")
					{
						if (this.Math.rand(1, 100) <= 33)
						{
							local effect = this.new("scripts/skills/effects_world/exhausted_effect");
							bro.getSkills().add(effect);
							this.List.push({
								id = 10,
								icon = effect.getIcon(),
								text = bro.getName() + "筋疲力尽了"
							});
						}

						if (this.Math.rand(1, 100) <= 50)
						{
							bro.improveMood(0.5, "帮忙建了一座磨坊");

							if (bro.getMoodState() >= this.Const.MoodState.Neutral)
							{
								this.List.push({
									id = 10,
									icon = this.Const.MoodStateIcon[bro.getMoodState()],
									text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
								});
							}
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_79.png[/img]刹那间，你脑海中闪过一个画面：自己用长剑刺穿了那个眯缝眼男人的身躯。这无疑能让他彻底认清现实，但你最终还是决定放他一马。那些参与了这场灾难性工程的劳工们对此颇为不满。只能说这破事至少让他们锻炼了一下身体。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "祝一路平安。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.FactionManager.getFaction(_event.m.Town.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationFavor, "你借出一些人帮忙建了一座磨坊");
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					local id = bro.getBackground().getID();

					if (id == "background.daytaler" || id == "background.mason" || id == "background.lumberjack" || id == "background.miller" || id == "background.farmhand" || id == "background.gravedigger")
					{
						if (this.Math.rand(1, 100) <= 33)
						{
							local effect = this.new("scripts/skills/effects_world/exhausted_effect");
							bro.getSkills().add(effect);
							this.List.push({
								id = 10,
								icon = effect.getIcon(),
								text = bro.getName() + "筋疲力尽了"
							});
						}

						if (this.Math.rand(1, 100) <= 33)
						{
							bro.worsenMood(1.0, "帮忙建了一座磨坊却没有得到报酬");

							if (bro.getMoodState() < this.Const.MoodState.Neutral)
							{
								this.List.push({
									id = 10,
									icon = this.Const.MoodStateIcon[bro.getMoodState()],
									text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
								});
							}
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.Assets.getMoney() > 3000)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern() || t.getSize() > 2)
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			local id = bro.getBackground().getID();

			if (id == "background.daytaler" || id == "background.mason" || id == "background.lumberjack" || id == "background.miller" || id == "background.farmhand" || id == "background.gravedigger")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		this.m.Town = town;
		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
	}

});
