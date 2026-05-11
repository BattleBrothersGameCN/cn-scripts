this.all_naked_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.all_naked";
		this.m.Title = "在路上……";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_16.png[/img]行军路上遇见个同路人，他身子前倾后仰折腾半天，手也不知道该遮太阳还是放任自己瞎眼。他摇摇头吐了口唾沫。%SPEECH_ON%早就听说你们这伙人了。在这鬼地方连条裤子都不穿，简直像魔鬼搞出来的烂笑话。你们到底在搞什么名堂？%SPEECH_OFF%你耸耸肩说，反正到现在光着膀子光着腚打打杀杀也没啥问题。赶路的又摇头吐唾沫。%SPEECH_ON%操蛋。打仗时候浑身光溜比刚生下来那会儿还光溜！要我说最讽刺的是，要是我们——随便哪个路人——发现你们死在野地里，给你们下葬时穿得肯定比现在体面。反正也不费事，毕竟你们现在压根啥也没穿。%SPEECH_OFF%你挥挥手，谢过他这番好话，继续快活地往前赶路。",
			Image = "",
			List = [],
			Options = [
				{
					Text = "真是美好的一天！",
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
		if (this.World.getTime().Days < 14)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			if (bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body) != null)
			{
				return;
			}
		}

		this.m.Score = 25;
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
