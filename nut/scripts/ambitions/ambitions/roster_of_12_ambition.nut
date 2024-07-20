this.roster_of_12_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.roster_of_12";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "我们要把战团提升到 12 个人！这能\n壮大我们的力量，接到更赚钱的工作。";
		this.m.UIText = "花名册人数至少达到12人";
		this.m.TooltipText = "雇佣足够的人，让名册上的人数达到12名。访问各地的定居点，寻找符合要求的新兵。充足的人员能让你接到更危险、报酬更高的合同。";
		this.m.SuccessText = "[img]gfx/ui/events/event_80.png[/img]你终于攒够了钱和装备，武装了十二名好战士，拉起了一支完整的队伍。当你再次走在%currenttown%的主干道上的时候，你的部下们高声唱起了一首行军歌。一小撮镇民低声抱怨说，肮脏的佣兵占据了他们的镇子，但其他人跟着你们走了起来，和你们一起放声歌唱。%SPEECH_ON%挺胸抬头兄弟们，给大伙看看，我们是一支货真价实的佣兵团，不是什么游手好闲的流浪汉。%SPEECH_OFF%%highestexperience_brother%宣布道。%SPEECH_ON%我们凭实力赚钱，现在人数增加了，价钱也可以有所提高。%SPEECH_OFF%看来他说的没错。有位相当胖的贵族正打量着你的战团，似乎已经想好要给你的任务了。%companyname%已经成为了一股不能忽视的力量。或许等战士们喝起了庆功酒，你应该再到镇子里逛逛，看看有没有更好赚的合同。";
		this.m.SuccessButtonText = "我们做到了。";
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getOrigin().getID() == "scenario.militia")
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 1 && this.World.Assets.getOrigin().getID() != "scenario.deserters" && this.World.Assets.getOrigin().getID() != "scenario.raiders")
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= 12)
		{
			this.m.IsDone = true;
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.getPlayerRoster().getSize() >= 12)
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
