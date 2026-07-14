this.collector_wants_trophy_event <- this.inherit("scripts/events/event", {
	m = {
		Peddler = null,
		Reward = 0,
		Item = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.collector_wants_trophy";
		this.m.Title = "%townname%里";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_01.png[/img]{你正在城镇的市场上闲逛，一个穿绸子的人走了过来。他张嘴一笑，嘴里的金牙比真牙都多，十指上更是戴满了闪闪发光的戒指。 | 你正打量着本地集市上卖的东西，一个奇怪的男人靠了过来。他腰间挂着几瓶古怪的液体。一口牙大都换成了奇异的木头。 | 逛集市要是没碰上几个怪人，那这趟可真算是白来了。这回来的是个大脸盘子，嘴里的牙个个带尖，像个捕兽夹子。两边颧骨高得能摆摊卖货。抛开长相不说，他这派头还真像个有钱人。}%SPEECH_ON%{哎，佣兵，我看你身上带了些有趣的小玩意。要不你把那个%trophy%卖给我，我看，就%reward%克朗吧。 | 你那个小玩意倒挺不错的，就那个，那个%trophy%。我出%reward%克朗，倒这一把手，你可就赚大发了！ | 嗯，我一看你就是个走南闯北的料。要不然你可搞不到那个%trophy%。我又刚好有点钱。我出%reward%，你把那小玩意卖给我。}%SPEECH_OFF%你掂量着这人的出价。",
			Image = "",
			List = [],
			Options = [
				{
					Text = "成交。",
					function getResult( _event )
					{
						if (_event.m.Peddler != null)
						{
							return "Peddler";
						}
						else
						{
							this.World.Assets.addMoney(_event.m.Reward);
							local stash = this.World.Assets.getStash().getItems();

							foreach( i, item in stash )
							{
								if (item != null && item.getID() == _event.m.Item.getID())
								{
									stash[i] = null;
									break;
								}
							}

							return 0;
						}
					}

				},
				{
					Text = "这可不行。",
					function getResult( _event )
					{
						if (_event.m.Peddler != null)
						{
							return "Peddler";
						}
						else
						{
							return 0;
						}
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Peddler",
			Text = "[img]gfx/ui/events/event_01.png[/img]{[%peddler%]走上前，把你按回去，就像你是一个随机的顾客而不是战团队长。他对买家大喊大叫，扬起一只手，买家也回应着，像两只狗互相吠叫，这一切都是如此之快，有如另一种语言般含糊不清。一分钟后，小贩回来了。%SPEECH_ON%好了，他现在出价%reward%克朗。我要去看看一些锅碗瓢盆，祝你好运。%SPEECH_OFF%他拍拍你的肩膀走开了。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "成交。",
					function getResult( _event )
					{
						this.World.Assets.addMoney(_event.m.Reward);
						local stash = this.World.Assets.getStash().getItems();

						foreach( i, item in stash )
						{
							if (item != null && item.getID() == _event.m.Item.getID())
							{
								stash[i] = null;
								break;
							}
						}

						return 0;
					}

				},
				{
					Text = "这可不行。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Peddler.getImagePath());
				_event.m.Reward = this.Math.floor(_event.m.Reward * 1.33);
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
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

		local stash = this.World.Assets.getStash().getItems();
		local candidates_items = [];

		foreach( item in stash )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Crafting) && item.getValue() >= 400)
			{
				candidates_items.push(item);
			}
		}

		if (candidates_items.len() == 0)
		{
			return;
		}

		this.m.Item = candidates_items[this.Math.rand(0, candidates_items.len() - 1)];
		this.m.Reward = this.m.Item.getValue();
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates_peddler = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.peddler")
			{
				candidates_peddler.push(bro);
			}
		}

		if (candidates_peddler.len() != 0)
		{
			this.m.Peddler = candidates_peddler[this.Math.rand(0, candidates_peddler.len() - 1)];
		}

		this.m.Town = town;
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"peddler",
			this.m.Peddler != null ? this.m.Peddler.getName() : ""
		]);
		_vars.push([
			"reward",
			this.m.Reward
		]);
		_vars.push([
			"trophy",
			this.m.Item.getName()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Peddler = null;
		this.m.Reward = 0;
		this.m.Item = null;
		this.m.Town = null;
	}

});
