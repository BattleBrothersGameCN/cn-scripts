this.holywar_occupied_north_event <- this.inherit("scripts/events/event", {
	m = {
		News = null
	},
	function create()
	{
		this.m.ID = "event.crisis.holywar_occupied_north";
		this.m.Title = "在路上……";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_%image%.png[/img]{在宗教势力的推波助澜下消息传得飞快：%holysite%已被北方十字军攻占！ | 来自北方的十字军已夺取%holysite%。你不确定这是否意味着战争即将结束。若真如此未免可惜——毕竟乱世才最有机可乘。 | %holysite%已沦陷于北方十字军的旗帜之下！旧神自然为此倍感欣慰，但镀金者的追随者势必试图夺回此地。这对%companyname%而言或许是个良机。}",
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

		if (this.World.Statistics.hasNews("crisis_holywar_holysite_north"))
		{
			this.m.Score = 2000;
		}
	}

	function onPrepare()
	{
		this.m.News = this.World.Statistics.popNews("crisis_holywar_holysite_north");
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
