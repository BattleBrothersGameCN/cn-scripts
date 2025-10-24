this.broken_wagon_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.broken_wagon";
		this.m.Title = "在路上……";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%你们在高耸的芦苇丛中发现一辆废弃的货车。%randombrother%上前查看后回头喊道。%SPEECH_ON%这玩意儿都快散架了，不过有些零件应该还能用。%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "不错。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local amount = this.Math.rand(5, 15);
				this.World.Assets.addArmorParts(amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_supplies.png",
					text = "你获得了 [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + amount + "[/color]份工具和补给"
				});
			}

		});
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		this.m.Score = 9;
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
