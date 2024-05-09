this.webknecht_exposition_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.webknecht_exposition";
		this.m.Title = "在路上……";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{你在路边男子，他正用研钵和杵捣着树叶。一边捣着一边嚼着，他向你投来绿色的笑容。%SPEECH_ON%我一直与爬虫和飞虫打交道，但是那些蛛魔完全不同。我从来没有见过如此快的虫子，辗转腾挪，偷猫盗狗。躲他们远点，明白吗？%SPEECH_OFF%这个陌生人吐了一口痰，然后继续他的工作，仿佛你从未经过。 | 一位站在农舍门口的妇女用一系列点头看着你的战团。手中拿着一个杯子，她指着你，嘴里含糊不清。%SPEECH_ON%啊，蜘蛛食品来了啊？嗯？那么赶快走，这八腿的混蛋们不喜欢等待和观望，他们会很快找到你们，而且他们总是饥饿的，没错，总是口吐白沫带着他们的毒液，没错没错。%SPEECH_OFF%她喝了一口酒，然后重重地摔回家门口。 | 你发现一个年轻人在白杨树上。他设法构建了一个尺寸和形状与茅房相同的小屋子。他俯身看向你。%SPEECH_ON%是啊，你对我和这棵树感到难以置信，但是让我告诉你，那些蛛魔非常快。狗一样大的蜘蛛！你知道我怎么说吗？他们全他娘的得死。以后你可以在这些树上找到我，如果这些该死的野兽长出翅膀，我就自己爬到树上躲起来，非常感谢。%SPEECH_OFF%网膝蛛似乎正在折磨当地人，所以你无法责怪他们。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "看来会有人掏钱请我们对付这些东西。",
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
		if (!this.Const.DLC.Unhold)
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

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		this.m.Score = 5;
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
