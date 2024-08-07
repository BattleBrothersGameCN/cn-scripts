this.have_y_crowns_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.have_y_crowns";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "如果一两场战斗对我们不利，我们就会发现自己口袋空空，装备短缺。\n因此，战团将建立10,000克朗的储备。";
		this.m.UIText = "拥有至少10,000克朗";
		this.m.TooltipText = "储备至少10,000克朗，以防节外生枝。你可以通过完成合同、掠夺废墟或营地、进行贸易等方式赚钱。";
		this.m.SuccessText = "[img]gfx/ui/events/event_04.png[/img]增长起来的钱币储备，让你睡得更安稳了。对你手下的人也一样，因为他们知道，发工资的时候，他们不必追着你横穿整个大草原了。当涉及到合同谈判时，你将不再处于被动，如果一两场战斗对你不利，你也不会落到人手或装备短缺的地步。\n\n你的储备金也开始为%companyname%打开了新世界的大门。商人、放债人和贵族有一个共同点：他们更喜欢与自己的同类交往。如果他们怀疑你口袋空空的话，仅仅是见见他们都很麻烦。但现在你已经证明了自己是一个有财力的人，战团对富人和决策者的吸引力也越来越大。";
		this.m.SuccessButtonText = "好极了！";
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() > 9000)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 3)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.trader" && !this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getMoney() >= 10000)
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
