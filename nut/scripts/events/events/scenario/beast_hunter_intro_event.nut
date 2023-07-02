this.beast_hunter_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.beast_hunters_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_124.png[/img]你在房间中见到了雇佣你的人。 他把手边的食物饮料还有雇佣合同递向了你。 杀死森林中的女巫，你就会得到一笔钱。 你和你的手下深入了森林做到了这个男人所说的一切你杀死了女巫，并且将其头颅带了回来。\n\n但是见到你回归的雇主只是微微的一笑并张口说道。 正是这个女巫帮他登上了权力的巅峰，也正是你们将他从这个契约债务中解放了出来，也正是他愚弄了你们所有的人。 话毕，他的跟班们从阴影中走出，刚拔出剑鞘的长剑闪着寒光。 一场埋伏，这场埋伏起于一个无赖罪犯的自大，也将终于一个无赖罪犯的枭首示众。 但是这场胜利是靠牺牲你手下大部分野兽杀手为代价换来的，战斗过后只剩下你和 %bs1%，%bs2%，和 %bs3% 活下来了。\n\n 这个世界上怪物往往将自己隐藏起来：人类将自己的残忍隐藏在自己的愚忠之下，野兽也往往将自己可憎的面目隐藏在黑暗之中。 身为一队野兽杀手的首领你越来越难以分辨这两者的区别。 如果猎杀生物可以让你赚取硬币，那为什么不将人也加进你的账单呢。",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "最邪恶的野兽也是最自私的。",
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
		this.m.Title = "野兽杀手";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		_vars.push([
			"bs1",
			brothers[0].getNameOnly()
		]);
		_vars.push([
			"bs2",
			brothers[1].getNameOnly()
		]);
		_vars.push([
			"bs3",
			brothers[2].getNameOnly()
		]);
	}

	function onClear()
	{
	}

});
