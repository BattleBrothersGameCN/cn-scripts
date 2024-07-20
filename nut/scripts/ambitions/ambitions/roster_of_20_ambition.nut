this.roster_of_20_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.roster_of_20";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "我们要把战团提升到 20 人，\n好让伤员在战斗间得到休息。";
		this.m.UIText = "花名册人数达到 20 人";
		this.m.TooltipText = "雇佣足够的人，让名册上的人数达到20名。访问各地的定居点，寻找符合要求的新兵。";
		this.m.SuccessText = "[img]gfx/ui/events/event_80.png[/img]许多天来，你一直在和各行各业，三教九流的新兵攀谈。没能力的就筛掉，要太多的就砍价。似乎在这个动荡的时期，但凡是个流浪汉、临时工、贵族的小儿子都想当个雇佣兵。\n\n看着战团一天天壮大，大伙都非常高兴，而那些淘汰掉的人则成了接下来几周里的笑柄。%highestexperience_brother%拍了拍你的肩膀。%SPEECH_ON%你记得那个说他杀了好几个兽人的人吗，它实际上是%randomtown%的面包师傅！要我说刚开始那几天，捏捏松弛的二头肌，用树枝抽抽农民的儿子什么的还挺好玩的。但最后反而比追强盗还累活呢。%SPEECH_OFF%现在你手下有了20个人，他们并非全员老兵，经受考验，但能轮换伤员还是意味着战场上能有更多的生力军。";
		this.m.SuccessButtonText = "总算是齐装满员了。";
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 15)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 2)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= 20)
		{
			this.m.IsDone = true;
			return;
		}

		if (this.World.Assets.getBrothersMax() < 20)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= 15)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.roster_of_12").isDone())
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.getPlayerRoster().getSize() >= 20)
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
