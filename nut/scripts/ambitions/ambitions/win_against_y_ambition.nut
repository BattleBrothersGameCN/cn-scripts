this.win_against_y_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		IsFulfilled = false
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.win_against_y";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "我们获得了一些名望，但真正的名声还在后面呢。\n我们要在战斗中击败足足两打对手！";
		this.m.UIText = "一战战胜至少24名敌人";
		this.m.TooltipText = "一战战胜至少24名敌人，无论杀死还是击溃，也无论是否在合同之内。";
		this.m.SuccessText = "[img]gfx/ui/events/event_22.png[/img]战斗结束后，%lowesthp_brother%瘫坐在地上望着自己的脚，和所有人一样累得说不出话。%SPEECH_ON%这这才是我该打的仗！要是今天死在这儿，身边也都是这辈子见过最勇猛的汉子，能叫各位一声兄弟，我值了！%SPEECH_OFF%四周响起一片疲惫却坚定的赞同声。%SPEECH_ON%农民总说流血流汗，但我们%companyname%的弟兄们是从血火里杀出来的！%SPEECH_OFF%战士们嘶哑地三呼战团名号，虽然疲惫却充满胜利的豪情。\n\n此后数日，你们发现无论走到哪个城镇，总有人对你们指指点点——不知是畏惧还是钦佩。你们的事迹早已传遍这片土地，人还未到，威名已至。";
		this.m.SuccessButtonText = "还有谁敢阻挡我们？";
	}

	function onUpdateScore()
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 24)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.win_against_x").isDone())
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 24 || this.m.IsFulfilled)
		{
			return true;
		}

		return false;
	}

	function onLocationDestroyed( _location )
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 24)
		{
			this.m.IsFulfilled = true;
		}
	}

	function onPartyDestroyed( _party )
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 24)
		{
			this.m.IsFulfilled = true;
		}
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeBool(this.m.IsFulfilled);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
		this.m.IsFulfilled = _in.readBool();
	}

});
