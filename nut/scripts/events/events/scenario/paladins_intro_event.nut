this.paladins_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.paladins_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_180.png[/img]{你对这种游戏很熟悉，就像任何让你被规则和规则制定者搞的灰头土脸焦头烂额的游戏一样。 这里一个誓言，那里一个誓言。 你只知道你绝对不会去持有小安瑟姆的头骨，最后你看到一些誓言使者把那个孩子的颌骨给偷跑了。 离开宣誓者真是你这辈子最正确的决定，你总算还能保持那么一丁点儿理智。\n\n不幸的是，那些忠实信徒仿佛总是能闻到叛教者的味道。 当你今天早上打开大门时你仿佛看到一个恶作剧的孩子拉的两坨屎：%oathtaker1% 和 %oathtaker2%，虽然他们是肉做的。 前者是一位从来就没有动摇过信仰的老人，后者是一个像你自己一样潜质很好的扈从。 一通无病呻吟的屁话，那个年轻人恳求道：宣誓者需要一位熟悉地形的人来帮助他们，完成任务和兑现誓言。 你正准备摔门而去却发现那个老人把脚卡在门上不让你关门。 他拿着一大堆金币，你的鼻子一定在因为钱的味道扭曲着因为两个人都面露喜色。\n\n现在，你之所以这么做，只是因为时局艰难，也因为雇佣兵工作－就算披上宗教责任的外衣－还是能为你挣到一些硬币的。 既然有人愿意出资让你接这个大有赚头的任务，那也没啥不可以的。 只有一个条件：你将宣誓成为队长，这意味着所有的战斗和艰难的道路将由他人完成。 丝毫没有迟疑，宣誓者同意了，然后他们拿出了小安瑟姆的颅骨展示给你。 你与组织失去联系已经很久了，但看着这个孩子无法合口的穹顶你还是感到心底一阵悸动。%oathtaker2% 点点头。%SPEECH_ON%让我们搜寻这片土地寻找荣耀，勤于我们的责任，并且愿我们能让小安瑟姆从那些毁了他的卑鄙杂种誓言使者的手中合整回来！%SPEECH_OFF%}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "为了金钱、荣誉、和小安瑟姆！",
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
		this.m.Title = "宣誓者";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		_vars.push([
			"oathtaker1",
			brothers[0].getName()
		]);
		_vars.push([
			"oathtaker2",
			brothers[1].getName()
		]);
	}

	function onClear()
	{
	}

});
