this.all_naked_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.all_naked";
		this.m.Title = "在路上……";
		this.m.Cooldown = 9999.000000 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_16.png[/img]行军途中，有一个同向而行的旅行者，他走近躲远又走近，手不知道该放哪儿，遮太阳还是蒙眼睛。他摇了摇头，吐了口唾沫。%SPEECH_ON%我听说过你们。来自邪恶国度的不穿裤子的人，会像地狱笑话一样冒出来。搞什么鬼？%SPEECH_OFF%你耸耸肩，对他说，目前为止，身上没有皮革钢铁和布匹也丝毫不妨碍你解决问题。他又摇了摇头，吐了口唾沫。%SPEECH_ON%扯蛋。打架不穿衣服比出生不穿衣服还要过分！等到我们，我是说任何人，要是发现你们死了，给你们下葬的时候，保证会让你们比现在穿得还体面，到时候就搞笑了。可能极了，反正你们也没穿过衣服。%SPEECH_OFF%你挥了挥手，感谢他的好意，继续愉快的旅程。",
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
