this.early_access_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.early_access_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_80.png[/img]你沐浴在早晨凉爽的空气中。 当太阳慢慢升起的时候，你人生的新篇章也开始了。 多年来，你以微薄的报酬做着刀口舔血的工作，现在终于攒下来足够的克朗去组建一支你自己的雇佣兵战团了。 这里有你和 %bro1%，%bro2% 和 %bro3% 这些人都是当年和你在同一个盾墙下并肩战斗过的人。 你现在是他们的指挥官了，领导者 %companyname%。\n\n如果你在各地旅行，你应该在乡村和城市雇佣新人来填补你的队伍。 许多宣誓效忠的人之前从未拿起过武器。 也许他们是感到绝望了，也许是他们只是想贪婪地想要得到战斗过后的战利品。 他们绝大部分的人将会死在战场上。 但是不要气馁。 这就是雇佣兵的生活，当你来到下一个村子的时候总是会有新的人热切的想要开始一段新的生活。\n\n现在这片土地很危险。 强盗和抢劫者埋伏在路边，野兽在黑暗的森林中游荡，兽人部落在文明的边界之外躁动不安。 甚至有传言说因为黑魔法的作用，死人从坟墓里爬起来再次行走在人间。 无论你是在土地上的各个村庄和城市中签订合同，还是通过自己的探险或者掠夺，都有机会赚大钱。\n\n你的人都在指望你发号施令。 他们现在的生死都是为了 %companyname%。",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "万岁！",
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
		this.m.Title = "这个" + this.World.Assets.getName();
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		_vars.push([
			"bro1",
			brothers[0].getName()
		]);
		_vars.push([
			"bro2",
			brothers[1].getName()
		]);
		_vars.push([
			"bro3",
			brothers[2].getName()
		]);
	}

	function onClear()
	{
	}

});
