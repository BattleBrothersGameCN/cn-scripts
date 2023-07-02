this.militia_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.militia_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_141.png[/img]{追捕土匪。抵御掠夺者。 诱捕攻击农场的狼群。 这些全是民兵团的工作。 而且如果你问到底要干多少活，这个答案只会越问越多。 所有的这一切只是为了保卫你的家园 %home% 的安全。\n\n 当一个贵族召见你的时候，你和你临时组成的新手战士们被带上了贵族之间的战场。 你不知道他们的贵族称号也不知道他们的目标，你只知道一个人把你和你的人集合带向了战场。 就是这样。不幸的是即使一个出身卑贱的男人即使拿上了盾牌和长矛也不过是比一个懦弱胆怯的农民好那么一点点。 你的民兵团当时被派去阻挡一支敌人的骑士队伍，你不知道的是迎来的不只是敌人的骑士还有己方弓手的漫天箭雨，这箭雨不仅击中了敌人的骑士还有你手下无辜的民兵。\n\n 在这场战斗过后你和你的人永远的逃离了这片战场。 你和你的人将自己武装的如同佣兵一样，并且彼此用血发誓你们永远不会让一个贵族与你们为伍。 一群普普通通的人组成的雇佣兵团，仅此而已。}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我们会是自己的领主。",
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
		this.m.Title = "农民民兵";
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"home",
			this.World.Flags.get("HomeVillage")
		]);
	}

	function onClear()
	{
	}

});
