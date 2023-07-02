this.manhunters_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.manhunters_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_172.png[/img]{游牧民族、城邦和流浪汉之间不断的冲突意味着有好生意：逃兵、罪犯、战俘和负债者逃过了这片土地，而你手持镣铐追捕他们。\n\n尽管他们统治着贫瘠的荒芜之地，但南方王国却是数目众多且不断流动的人们的家园，这使得人本身成为一种值得收获的资源。 河水般流动的人们和原料一样都是自然经济。\n\n战俘占了你很大一部分构成，战败之人必须服从并为另一股势力战斗：你自己的。 罪犯和普通的流氓到处都是，他们很容易从那些无法处理这些堕落的居民的小村落里挑选出来。 还有那些负债者…地狱之火诅咒的灵魂必须通过努力才能回到镀金者的金光沐浴中，并通过鲜血、汗水和泪水找到救赎。 尽管大部分人要成为工人，你还是喜欢把他们编入自己的战团里。 负债者不会抗议，因为即使是牧师也会说，他们一定会在镀金者的崇高愿景中，他们会找到忏悔就在 %companyname%。}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "每个人都可以通过努力干活还清镀金者的债务而获得救赎。",
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
		this.m.Title = "猎奴者";
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});
