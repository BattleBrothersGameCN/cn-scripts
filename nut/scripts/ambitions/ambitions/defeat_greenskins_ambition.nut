this.defeat_greenskins_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_greenskins";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "绿皮入侵的威胁正要荡平我们的世界。\n坚强地站起来抵御他们，这就我们是传奇之路！";
		this.m.UIText = "击败绿皮入侵";
		this.m.TooltipText = "击败绿皮入侵！ 每完成一次针对他们的合约，每摧毁一支军队或一处营地，都将使你们离拯救人类世界更近。";
		this.m.SuccessText = "[img]gfx/ui/events/event_81.png[/img]这是我们战团所完成的一项前所未有的任务，抵御人类有史以来最凶猛敌人的入侵。它们无法规劝，它们格格不入，它们不懂得怜悯或同情，它们只要战争。 兽人和地精联手，产生了一股凶猛的绿色浪潮，将人类冲刷到灭绝边缘。\n\n在白天毒辣的阳光下、在夜晚炽热的城堡火光下，战团跨过边境地区发起了反对绿色威胁的战争，无论敌人在哪里抬起丑陋、疤痕累累的头，我们都要将其铲除。虽然人类经历了许多异常惨烈的战斗，做出了极大牺牲，但都是值得的。\n\n%companyname%赢了。经过多次残酷的斗争，在无数岁月里，每个人都命悬一线，绿皮浪潮终于退却了。当兽人和地精分散到野外时，你知道人类的世界获得了拯救。至少现在是。";
		this.m.SuccessButtonText = "现在吟游诗人将会歌颂我们的名字了。 如果他们没死绝的话。";
	}

	function getUIText()
	{
		local f = this.World.FactionManager.getGreaterEvil().Strength / this.Const.Factions.GreaterEvilStartStrength;
		local text;

		if (f >= 0.95)
		{
			text = "困难重重";
		}
		else if (f >= 0.5)
		{
			text = "悬而未决";
		}
		else if (f >= 0.25)
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
		if (!this.World.FactionManager.isGreenskinInvasion())
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
		if (this.World.FactionManager.getGreaterEvil().Type == 0 && this.World.FactionManager.getGreaterEvil().LastType == 2)
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
