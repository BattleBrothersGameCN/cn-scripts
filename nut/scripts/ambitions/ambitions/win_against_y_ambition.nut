this.win_against_y_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		IsFulfilled = false
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.win_against_y";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "我们获得了一些名望，但现在你可以看到真正的名声即将到来。\n让我们在战斗中击败两打强大的对手！";
		this.m.UIText = "一战战胜至少24名敌人";
		this.m.TooltipText = "一战战胜至少24名敌人，无论杀死打跑，也无论是否在合同之内。";
		this.m.SuccessText = "[img]gfx/ui/events/event_22.png[/img]战斗结束后，%lowesthp_brother%呆坐在那里，盯着他的脚，看起来累坏了。其他人也不例外。%SPEECH_ON%这才是我生来要打的仗！现在，如果我死了，我就会和我见过最勇敢、最致命的人死在一起，我很自豪能叫他们兄弟！%SPEECH_OFF%这在四周引起了一片疲惫的赞同声。%SPEECH_ON%农民们老是说什么汗水、鲜血和泪水，但%companyname%的战士们穿越火海，取得了胜利！%SPEECH_OFF%人们高呼了三次战团的名字，虽然疲惫，但斗志昂扬。\n\n接下来的日子里，只要是礼教所及之地，人们总会指着你窃窃私语，不知是出于敬佩还是恐惧。不管走到哪里，人还没到，你的名声就已经来过了。";
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
