this.hire_follower_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.hire_follower";
		this.m.Duration = 40.000000 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "这里有厨师，侦察兵还有很多人可以在战场外支援我们。\n我们会雇一个最适合我们需要的！";
		this.m.UIText = "为你的随行队伍雇佣一位非战斗的追随者";
		this.m.TooltipText = "获得至少为“初露锋芒”（250）的名望，解锁第一个非战斗随从位置。你可以通过完成合同和赢得战斗来提高自己的名望。然后，在随从界面中雇佣一个非战斗随从。 一些随从要求你满足特定的先决条件来解锁他们的服务。";
		this.m.SuccessText = "[img]gfx/ui/events/event_82.png[/img]%SPEECH_ON%所以他们不是战士？%SPEECH_OFF%一个佣兵问道。 你摇摇头，他挠了挠头。%SPEECH_ON%但你还是雇了他们？%SPEECH_OFF%你点头。他撅了撅嘴，担心自己没说清楚。%SPEECH_ON%不参与战斗？%SPEECH_OFF%不战斗。%SPEECH_ON%完全不战斗？那他们是来放什么屁的？%SPEECH_OFF%你解释说，佣兵团里，重要的不止战斗。 你把那些人能干的事都列了出来，他想了一会儿。%SPEECH_ON%那他们能清点库存吗？我早就干够了。%SPEECH_OFF%不，那当然不算。你可不打算把你的秘密惩罚用在别人身上。";
		this.m.SuccessButtonText = "这将在今后的日子里对我们大有裨益。";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 1)
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < this.Const.BusinessReputation[this.Const.FollowerSlotRequirements[0]] - 100)
		{
			return;
		}

		if (this.World.Retinue.getNumberOfCurrentFollowers() >= 1)
		{
			this.m.IsDone = true;
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Retinue.getNumberOfCurrentFollowers() >= 1)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});
