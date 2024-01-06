this.defeat_undead_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_undead";
		this.m.Duration = 99999.000000 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "亡灵正在大地上崛起并杀死和吞噬它们看到的一切。\n我们必须结束这一切，否则很快我们所知的世界将不复存在！";
		this.m.UIText = "击败亡灵天灾";
		this.m.TooltipText = "击败亡灵天灾！ 每完成一次针对他们的合约，每摧毁一支军队或一处营地，都将使你们离拯救人类世界更近。";
		this.m.SuccessText = "[img]gfx/ui/events/event_73.png[/img]穿着破布的尸体蹒跚而行。 很快，每个村庄的墓地都开始把吐出这些东西，而这还只是开始。 古代军团觉醒了。 他们从不疲倦，从不畏惧，像一台冰冷的机器一样前进，永远向前。 他们曾经征服过已知的世界，如果不是因为一群紧密团结的雇佣军，他们很可能再次征服这个世界。%SPEECH_ON%行军的死人，穿着没见过的盔甲行走的骨头，来自这个世界之外的东西…我从没想过我会看到这样的恐怖。但是我们赢了！%SPEECH_OFF%%bravest_brother% 高举武器，好像要发出冲锋的信号。%SPEECH_ON%%companyname% 连这样的敌人都能战胜！ 现在谁还敢跟我们作对？%SPEECH_OFF%还有谁？";
		this.m.SuccessButtonText = "人类的世界得救了。暂时的。";
	}

	function getUIText()
	{
		local f = this.World.FactionManager.getGreaterEvil().Strength / this.Const.Factions.GreaterEvilStartStrength;
		local text;

		if (f >= 0.950000)
		{
			text = "困难重重";
		}
		else if (f >= 0.500000)
		{
			text = "悬而未决";
		}
		else if (f >= 0.250000)
		{
			text = "看到曙光";
		}
		else
		{
			text = "胜利在望";
		}

		return this.m.UIText + " (" + text + ")";
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isUndeadScourge())
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 1500)
		{
			return;
		}

		this.m.Score = 10;
	}

	function onCheckSuccess()
	{
		if (this.World.FactionManager.getGreaterEvil().Type == 0 && this.World.FactionManager.getGreaterEvil().LastType == 3)
		{
			return true;
		}

		this.World.Ambitions.updateUI();
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
