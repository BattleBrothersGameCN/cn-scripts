this.trader_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.trader_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_95.png[/img]尸体堆上的苍蝇嗡嗡作响 %ch1% 站在尸体堆上就像他建造了这个死亡图腾并使得他们显现一样。他转向你。%SPEECH_ON%是绿皮干的。 没有人类能把一个人的头像这样劈成两半，并且任何有点理智的人都不会像这样子把尸体堆起来。 并且在箭头上还发现了地精毒药。%SPEECH_OFF% %ch2% 点了点头。%SPEECH_ON%昨天我们还发现了一队商队的人被强盗吊死在了路边树上，现在又是这些兽人。 现在这些道路对于载着财宝的载重货车来说过于危险了。 现在我不是在说这堆盐不值得我这双握剑的手而是整个商队就我们两个护卫，就像是在和命运玩骰子游戏一样。 先生，我认为你应该雇佣更多的人手。%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "唉，我们会没事的。",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "我们会雇佣更多守卫，更多守卫！",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
				local brothers = this.World.getPlayerRoster().getAll();
				this.Characters.push(brothers[0].getImagePath());
				this.Characters.push(brothers[1].getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_95.png[/img]你摇了摇头。%SPEECH_ON%不。我们现在要做的是反击。 我决定要雇佣一些佣兵去组建一个战团，如果你们两人想要拥有一个稳定工资的工作的话，你们两位可以当我的第一批佣兵。%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "前进，我们还有货物要卖！",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
				local brothers = this.World.getPlayerRoster().getAll();
				this.Characters.push(brothers[0].getImagePath());
				this.Characters.push(brothers[1].getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_95.png[/img]你摇了摇头。%SPEECH_ON%我们现在几乎没有盈利。 我再也不能用更多的硬币雇守卫了。 除非我们找到一条新的有利可图的贸易路线，对就这么干。我们现在就去寻找吧！%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "前进，我们还有货物要卖！",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
				local brothers = this.World.getPlayerRoster().getAll();
				this.Characters.push(brothers[0].getImagePath());
				this.Characters.push(brothers[1].getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "贸易商队";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		_vars.push([
			"ch1",
			brothers[0].getName()
		]);
		_vars.push([
			"ch2",
			brothers[1].getName()
		]);
	}

	function onClear()
	{
	}

});
