this.win_against_x_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		IsFulfilled = false
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.win_against_x";
		this.m.Duration = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "我们先把小规模战斗放一边，去击败至少一打敌人。 \n唯有如此，我们的名号才能在这片土地上响彻四方！";
		this.m.RewardTooltip = "胜利时额外获得150名望。";
		this.m.UIText = "一战战胜至少12名敌人";
		this.m.TooltipText = "一战战胜至少12名敌人，无论杀死还是击溃，也无论是否在合同之内。";
		this.m.SuccessText = "[img]gfx/ui/events/event_22.png[/img]你的敌人死的死，逃的逃，%bravest_brother%挥舞着战团的旗帜以示庆祝。%SPEECH_ON%%companyname%的又一场战斗，%companyname%的又一场胜利！%SPEECH_OFF%四周顿时响起震耳欲聋的欢呼。不久后，你们发现这场战役已成为当地城镇乡村的热议话题。每当战团在沿途酒馆驻足，只要提起那场战役的故事，总有人慷慨赠饮——而故事越是绘声绘色，酒水便越是源源不断。";
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
			text = "胜利时会获得额外名望"
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
