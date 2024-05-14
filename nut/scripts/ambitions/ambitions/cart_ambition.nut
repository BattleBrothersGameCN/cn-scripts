this.cart_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.cart";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "我们快带不下更多的装备和战利品了。\n让我们存个7500克朗，买辆货车来减轻负担吧！";
		this.m.RewardTooltip = "你将解锁27个额外的仓库栏位。";
		this.m.UIText = "拥有至少7500克朗";
		this.m.TooltipText = "收集7500以上的克朗，用于购买一辆货车，获得额外的仓库空间。你可以通过完成合同、掠夺废墟或营地、进行贸易等方式赚钱。";
		this.m.SuccessText = "[img]gfx/ui/events/event_158.png[/img]收集足够的克朗付给制车匠人让你伤筋动骨，搞不好是字面意义上的。 现在，作为一辆新载重货车的骄傲主人，你可以携带更多的装备和战利品，银器、金冠，或是一件从某个暴徒身上扒下来，被撕破了一半，满是虱子的武装衣。\n\n带着新轮子走了几英里后，你注意到 %randombrother% 似乎不见了。 环顾四周，最后你发现他藏在载重货车上的一些粮食袋子后面，平静地呼噜着。 头上浇点冷水，屁股上踹两脚，懒汉很快就会站起来，像其他人一样走路。 和以往一样，你最好确保那些人知道他们在战团里的地位。%SPEECH_ON%别让我发现你们谁再这样！ 在%companyname% ，如果你脑袋滚下来掉地上，那我欢迎你上车！ 如果你不想上车，行军途中就给我时刻保持警惕，准备好你的武器！%SPEECH_OFF%人们小声抱怨着，继续往前走。";
		this.m.SuccessButtonText = "行动起来！";
	}

	function onUpdateScore()
	{
		if (this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 2)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		this.m.Score = 3 + this.Math.rand(0, 5);

		if (this.World.getTime().Days >= 25)
		{
			this.m.Score += 1;
		}

		if (this.World.getTime().Days >= 35)
		{
			this.m.Score += 1;
		}

		if (this.World.getTime().Days >= 45)
		{
			this.m.Score += 1;
		}
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getMoney() >= 7500)
		{
			return true;
		}

		return false;
	}

	function onReward()
	{
		local item;
		local stash = this.World.Assets.getStash();
		this.World.Assets.addMoney(-5000);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/icons/asset_money.png",
			text = "你花了[color=" + this.Const.UI.Color.NegativeEventValue + "]5,000[/color]克朗"
		});
		this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() + 27);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/icons/special.png",
			text = "你获得了27个额外的仓库栏位"
		});
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
