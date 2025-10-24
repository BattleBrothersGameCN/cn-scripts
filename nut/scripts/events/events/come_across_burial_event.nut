this.come_across_burial_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.come_across_burial";
		this.m.Title = "在路上……";
		this.m.Cooldown = 130.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_28.png[/img]在旅途中，你遇见一群人围着一座土堆。走近才发现是场葬礼。其中一个参加者转头看你：%SPEECH_ON%你认识他？跟他一块打过仗吗？%SPEECH_OFF%你摇头否认，拨开人群想看清死者模样。那人看上去已经死透了，一柄锋利闪亮的长剑横陈胸前，剑柄仍被他那脏兮兮的手指紧握着。%randombrother%凑到你身旁低声说道：%SPEECH_ON%没别的意思，但那把剑看起来真不赖。%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我们把它拿走吧",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 35 ? "B" : "C";
					}

				},
				{
					Text = "不管他们。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_36.png[/img]你拔剑出鞘，战团成员也纷纷亮出武器。佣兵们向前施压，人群后退得却比预想中干脆。其中一人走上前来。%SPEECH_ON%是冲着这把剑来的吧？拿去吧。地上那位早就提过会有你们这号人，说你们比他自己更需要这柄剑。%SPEECH_OFF%你收剑入鞘，问他们是不是就为这个围在这儿。那人咧嘴一笑。%SPEECH_ON%那倒不是，他还吹嘘自己永远不会死呢，我们就是想看看这话能不能当真。%SPEECH_OFF%你谨慎地拿起长剑，心里嘀咕着该不会碰到什么\"擅动此剑者必遭不测\"的诅咒——好在，看样子这位狂妄的逝者并没留下这种话。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "他用不着那东西了。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/weapons/longsword");
				item.setCondition(27.0);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "你获得了" + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_28.png[/img]你拨开人群伸手去取死者手中的剑，一名送葬者当即惊叫起来。%randombrother%挥拳猛击，打得那人晕厥过去。战团其余成员立刻亮出兵刃，震慑任何还想抗议的人。一位老妇人步履蹒跚地穿过人群，颤巍巍地开口。%SPEECH_ON%大人，那不是你的，请放回原处。%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "现在是了",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "这位老妇人说的对，我们不该继续打扰这场葬礼了。",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_36.png[/img]你让那老妇人赶紧滚回她的老鼠洞里等死。 顺手将死者的长剑收入行囊，带着%companyname%重新上路。\n\n愤慨的农民们在身后哭喊，说你今日恶行必将如千牛齐泻的屁响般随风传遍四方。你只是大笑，倒是很欣赏他们这别致的比喻。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "世道就是如此。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-3);
				local item = this.new("scripts/items/weapons/longsword");
				item.setCondition(27.0);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "你获得了" + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_28.png[/img]你将长剑放回死者手中。老妇人颔首道。%SPEECH_ON%看来这世上还是有愿意听劝的善人哩。%SPEECH_OFF%有个农夫开始称赞你的美德，其他人也纷纷应和。看来在这群乡民眼中，光是这番取而复还的举动就值得他们夹道欢送——或许你该多演几出佯装窃取的戏码。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "反正我们也不用不着。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(5);
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days <= 15)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.Type == this.Const.World.TerrainType.Snow || currentTile.Type == this.Const.World.TerrainType.Forest || currentTile.Type == this.Const.World.TerrainType.LeaveForest || currentTile.Type == this.Const.World.TerrainType.SnowyForest)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		this.m.Score = 2;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});
