this.holywar_occupied_south_event <- this.inherit("scripts/events/event", {
	m = {
		News = null
	},
	function create()
	{
		this.m.ID = "event.crisis.holywar_occupied_south";
		this.m.Title = "在路上……";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_%image%.png[/img]{消息传来，镀金者们征服了 %holysite%。至于他们打算对它做什么，谁知道呢。 或许会竖起一圈镀金栅栏把北方人挡在外面？ 你最担心的是这场战斗可能接近尾声，那%companyname%一直享用的宗教纷争甜头可就没了。 | 镀金者的光辉想必空前闪亮： %holysite%已落入南方人的掌控。 或许镀金者的信徒会希望%companyname%协助防守，也可能旧神需要借助外力夺回圣地。无论如何，%companyname%稳坐钓鱼台，不愁赚不到丰厚报酬。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "宗教冲突之火熊熊燃烧。",
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
	}

	function onUpdateScore()
	{
		if (!this.World.State.getPlayer().getTile().HasRoad)
		{
			return;
		}

		if (this.World.Statistics.hasNews("crisis_holywar_holysite_south"))
		{
			this.m.Score = 2000;
		}
	}

	function onPrepare()
	{
		this.m.News = this.World.Statistics.popNews("crisis_holywar_holysite_south");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"holysite",
			this.m.News.get("圣地")
		]);
		_vars.push([
			"image",
			this.m.News.get("Image")
		]);
	}

	function onClear()
	{
		this.m.News = null;
	}

});
