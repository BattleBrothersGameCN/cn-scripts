this.raid_caravans_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		RaidsToComplete = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.raid_caravans";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "大篷车里装满了财富，只等着我们\n去拿。就像从树上摘果子一样简单！";
		this.m.UIText = "袭击贸易或补给商队";
		this.m.TooltipText = "袭击 4 支沿路行进的贸易或补给商队。如果你和他们的派别不是敌对关系，你可以通过按住Ctrl键的同时左键单击他们来强制攻击--前提是你目前没有雇佣合同。";
		this.m.SuccessText = "[img]gfx/ui/events/event_60.png[/img]一个死去商人的声音在你的脑海中回响。%SPEECH_ON%你为什么这么做？我都准备把所有东西给你了。%SPEECH_OFF%但这段记忆和他这个人没什么关系。而是有关他的货车，和那些他宁愿丢掉性命也不会透露的东西。从开始以来，袭击商队已经成了你和%companyname%的一种娱乐活动。沐浴在袭击得来的财富当中，你的人高兴极了，你也因为这些卑鄙行径而名声大噪。";
		this.m.SuccessButtonText = "就像从孩子手里抢糖果一样。";
	}

	function getUIText()
	{
		local d = 4 - (this.m.RaidsToComplete - this.World.Statistics.getFlags().getAsInt("CaravansRaided"));
		return this.m.UIText + " (" + this.Math.min(4, d) + "/4)";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Statistics.getFlags().getAsInt("CaravansRaided") <= 0 && this.World.Assets.getOrigin().getID() != "scenario.raiders")
		{
			return;
		}

		this.m.RaidsToComplete = this.World.Statistics.getFlags().getAsInt("CaravansRaided") + 4;
		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Statistics.getFlags().getAsInt("CaravansRaided") >= this.m.RaidsToComplete)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeU16(this.m.RaidsToComplete);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
		this.m.RaidsToComplete = _in.readU16();
	}

});
