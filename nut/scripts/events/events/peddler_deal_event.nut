this.peddler_deal_event <- this.inherit("scripts/events/event", {
	m = {
		Peddler = null
	},
	function create()
	{
		this.m.ID = "event.peddler_deal";
		this.m.Title = "在路上……";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%peddler%走到你面前，搓着后颈，紧张地拽着衣领。 他提议带着一批货进城兜售，就像他以往经常做的那样。\n\n唯一的问题是他现在手里没货——得先跟附近乡民采购。眼下只需要500克朗启动资金进货。当然，作为合伙人，事成之后你将获得分红。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "算我一个！",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 70 ? "B" : "C";
					}

				},
				{
					Text = "你现在是个雇佣兵，是时候把过去抛在身后了。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Peddler.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_04.png[/img]你给了%peddler%一笔克朗，他便动身离开了。\n\n几小时之后，小贩手里拿捧着小锁盒快步跑来。他脸上挂着藏不住的笑容，快步走来时不自觉地挥舞着拳头。刚要开口就被急促的喘息打断。你抬手示意他慢慢说。平静下来后，他递来沉甸甸的钱袋，说这是你应得的分红。\n\n不待你回应，他已雀跃着转身跑远，仍沉浸在成功的喜悦中。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "合作愉快。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Peddler.getImagePath());
				local money = this.Math.rand(100, 400);
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color]克朗"
					}
				];
				_event.m.Peddler.getBaseProperties().Bravery += 1;
				_event.m.Peddler.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Peddler.getName() + " 获得了 [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] 决心"
				});
				_event.m.Peddler.improveMood(2.0, "兜售商品牟利");

				if (_event.m.Peddler.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Peddler.getMoodState()],
						text = _event.m.Peddler.getName() + this.Const.MoodStateEvent[_event.m.Peddler.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]%peddler%离开了，你则继续处理其他日常事务。\n\n几个小时后你走出帐篷，远远望见一道佝偻身影正蹒跚走来，看来正是先前离开的小贩。他空着手，一脸沮丧。待他走近，你才看清他周身的淤青。 他解释说虽从货源处采购到了商品，可镇民们对他的买卖手段颇不待见。\n\n投进去的本钱全打了水漂，而%peddler%只得钻回帐篷疗伤去了。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "但是……",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Peddler.getImagePath());
				this.World.Assets.addMoney(-500);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "你失去了[color=" + this.Const.UI.Color.NegativeEventValue + "]500[/color]克朗"
					}
				];
				_event.m.Peddler.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Peddler.getName() + "受到了轻微伤"
				});
				_event.m.Peddler.worsenMood(2, "他计划失败了，损失了一大笔钱");

				if (_event.m.Peddler.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Peddler.getMoodState()],
						text = _event.m.Peddler.getName() + this.Const.MoodStateEvent[_event.m.Peddler.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() < 1000)
		{
			return;
		}

		if (!this.World.State.isCampingAllowed())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 4)
			{
				nearTown = true;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 1)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.peddler")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Peddler = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"peddler",
			this.m.Peddler.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Peddler = null;
	}

});
