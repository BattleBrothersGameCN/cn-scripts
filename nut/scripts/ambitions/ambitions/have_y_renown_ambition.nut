this.have_y_renown_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.have_y_renown";
		this.m.Duration = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "我们已经在这片土地的一些地方为人所知，但距离\n成为传奇战团还很远。我们要进一步提高我们的名望！";
		this.m.UIText = "名望达到“丰功伟绩”";
		this.m.TooltipText = "以“丰功伟绩”（2750名望）闻名于各地。你可以通过完成合同和赢得战斗来提高自己的名望。";
		this.m.SuccessText = "[img]gfx/ui/events/event_82.png[/img]穿过森林，穿过平原，这支队伍粉碎了所有被派去对付的敌人。践踏敌人，粉碎战线，打飞脑袋，%companyname%发觉他们很少单独行动。他们行军时，乌鸦在队伍上空盘旋；他们吃饭时，乌鸦放声歌唱；他们完成日常工作后，乌鸦往往会饱餐一顿。\n\n他们的脚步所到之处，都留下了焦土和离奇的传言。一传十，十传百，从挤奶女工、铁匠再到市长，似乎所有人都在谈论着你的功绩。流言在哪个角落都有价值，无论是宽阔的河流还是高耸的山峰，都不能阻挡你胜利的故事，反过来，也不能阻挡你为自己的服务开出价格。";
		this.m.SuccessButtonText = "%companyname%的名声无人不知！";
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 30)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() >= 2650)
		{
			this.m.IsDone = true;
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getBusinessReputation() >= 2750)
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
