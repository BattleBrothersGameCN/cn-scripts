this.cultists_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.cultists_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_71.png[/img]%SPEECH_ON%我把女人和孩子放在谷仓里，而你们肯定已经发现谷仓已经被烧成灰烬了。 他们被打昏了，因为祂不寻求他们的痛苦。请不要想太多他们的死亡，他们现在和祂在一起了，而我也终将可以从我的义务和责任之中解放出来去完成必须完成之事。现在我将离去。我将扮演一个新的角色，换一张新的面孔，在这两者之下，我将变成另一个我。我将伪装。我将表演。但最终，都是为了一个目的。而且你知道这个目的是什么。我不能说出它的名字，但当你意识到没有人真正相信自己会死的时候，你会发现它。一个人自我毁灭的纯粹必须被分神和欢愉所掩盖。并非所有人都能看到祂，也并非所有人都应该看到祂，但他们最终都会看到祂。\n\n祝平安，已成陌生之人者，达库尔等待着我们所有人。%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "达库尔在等待。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "邪教徒们";
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});
