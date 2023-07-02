this.renown_tutorial_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.renown_tutorial";
		this.m.Title = "在途中……";
		this.m.Cooldown = 999999.000000 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_82.png[/img]当战团稍作休息时，你坐下来检查一下不久前一支箭刺穿你侧面的伤口。 它一直在慢慢愈合，如果你动作太快，仍然会疼痛，但情况正在好转。%bro1% 走进你，抓住这个机会和他的队长谈话。%SPEECH_ON%在我看来，还没有人知道 %companyname%。 我们不想永远在树林里猎杀一群衣衫褴褛的土匪，但我们必须先以可靠的雇佣之剑出名，在贵族家族注意到之前，先把事情办好。 我敢肯定，他们会想利用战团来完成更高的工作。%SPEECH_OFF%他调整好武器带，继续道。%SPEECH_ON%只是我们要记住，大人们在玩一场危险的游戏，我们不想站在他们那一边。 有足够多的故事讲的是，有人越过它们，最后却只得到四分之一的猪食，他们甚至有办法压扁一整队佣兵。%SPEECH_OFF%他停了一会儿，又加了一个念头。%SPEECH_ON%管理乡镇的行会员和议员也记性很好。 我们现在依靠他们来雇用战团，但有一些有影响力的朋友也可以帮助我们与商人达成更好的交易。%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我会记住的。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local bro = this.World.getPlayerRoster().getAll()[0];
				this.Characters.push(bro.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Contracts.getContractsFinished() < 2)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.tutorial")
		{
			return;
		}

		this.m.Score = 5000;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"bro1",
			this.World.getPlayerRoster().getAll()[0].getName()
		]);
	}

	function onClear()
	{
	}

});
