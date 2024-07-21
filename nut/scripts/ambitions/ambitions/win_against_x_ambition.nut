this.win_against_x_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		IsFulfilled = false
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.win_against_x";
		this.m.Duration = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "让我们先把小规模战斗放一边，去击败至少一打敌人。 \n这就是我们的名字将在这片土地上广为人知的原因！";
		this.m.RewardTooltip = "胜利时额外获得150名望。";
		this.m.UIText = "一战战胜至少12名敌人";
		this.m.TooltipText = "一战战胜至少12名敌人，无论杀死打跑，也无论是否在合同之内。";
		this.m.SuccessText = "[img]gfx/ui/events/event_22.png[/img]你的敌人死的死，逃的逃，%bravest_brother%挥舞着战团的旗帜以示庆祝。%SPEECH_ON%%companyname%的又一场战斗，%companyname%的又一场胜利！%SPEECH_OFF%沙哑的欢呼声在他周围回响。不久，你发觉这场战斗成了十里八乡的谈资。每当兄弟们在酒馆里休息，他们发现，只要讲起这场战斗，就有人请他们酒喝。越是添油加醋，敬酒的人就越多。";
		this.m.SuccessButtonText = "还有谁敢阻挡我们？";
	}

	function onUpdateScore()
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 12)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.battle_standard").isDone())
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 12 || this.m.IsFulfilled)
		{
			return true;
		}

		return false;
	}

	function onLocationDestroyed( _location )
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 12)
		{
			this.m.IsFulfilled = true;
		}
	}

	function onPartyDestroyed( _party )
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 12)
		{
			this.m.IsFulfilled = true;
		}
	}

	function onReward()
	{
		this.World.Assets.addBusinessReputation(150);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/icons/special.png",
			text = "取胜时会获得额外名望"
		});
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
