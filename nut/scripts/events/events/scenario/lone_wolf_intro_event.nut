this.lone_wolf_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.lone_wolf_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_137.png[/img]{你走在一座骑士比武场的看台上。霉烂的水果和蔬菜散落在地上。干枯的血迹点缀着座位。沉寂弥漫在空气中。当你坐下时，这个地方的木头似乎在异口同声地呻吟，仿佛被一个罕见访客的来访所困扰。\n\n你手中拿着一张纸条。“寻找勇敢男子，具备剑术知识优先，但欢迎所有人加入。”这是一张旧纸条，它的目的很久以前就达到了。但吸引你目光的是其所提供的报酬：五场比武赛赚的钱加起来也比不上这个数目。\n\n如果仅仅是要赚钱的话，那么去他的骑士竞技和比武。但你不是那种会听别人命令的人。凭借这些年来赚到的所有财富，你想象着你可以组建一支自己的雇佣兵团。}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "这就是我要做的。",
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
		this.m.Title = "独狼";
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});
