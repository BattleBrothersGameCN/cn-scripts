this.rangers_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.rangers_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_10.png[/img]尽管有很多故事中说猎人都是一个人孤独地在养活他的家庭，但是现实中偷猎者经常有组织的成群结队的工作，并且建立起一整套销售渠道来贩卖他们偷来的毛皮和肉。\n\n但当地贵族首领 %noble% 对偷猎者在他的森林中进行狩猎感到越来越恼火，周围大部分猎人团体被抓到不是切手就是送上绞架。 只剩下了你和 %hunter1%，%hunter2%，和 %hunter3% 幸存了下来，但是现在的问题是－如果你所会的所有技巧知识只是拉弓放箭的话怎么才能活下来？\n\n根据大家集体讨论之后一致决定接受作为雇佣兵的工作，并且你很快被选为了队长。%SPEECH_ON%在我们之中你眼最尖。%SPEECH_OFF%%hunter2% 说并且 %hunter3% 也同意他的意见并说道。%SPEECH_ON%不仅你的眼睛最尖并且你的射击技巧还是我们之中最差的。 别因为我说了这句话就惩罚我哦，“队长”，哈哈哈！%SPEECH_OFF%当然这队快乐的偷猎者队伍还会为你带来独特的天赋－你的人喜欢轻装上阵，并且他们的腿脚很快，弓箭射的很好，还是侦察方面的大师从而避免不必要的战斗。",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我们会做的很好的。",
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
				this.Characters.push(brothers[1].getImagePath());
				this.Characters.push(brothers[2].getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "偷猎者团队";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local settlements = this.World.EntityManager.getSettlements();
		local closest;
		local distance = 9999;

		foreach( s in settlements )
		{
			local d = s.getTile().getDistanceTo(this.World.State.getPlayer().getTile());

			if (d < distance)
			{
				closest = s;
				distance = d;
			}
		}

		local f = closest.getFactionOfType(this.Const.FactionType.NobleHouse);
		_vars.push([
			"hunter1",
			brothers[0].getName()
		]);
		_vars.push([
			"hunter2",
			brothers[1].getName()
		]);
		_vars.push([
			"hunter3",
			brothers[2].getName()
		]);
		_vars.push([
			"noble",
			f.getRandomCharacter().getName()
		]);
	}

	function onClear()
	{
	}

});
