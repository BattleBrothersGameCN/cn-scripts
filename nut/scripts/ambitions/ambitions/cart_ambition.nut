this.cart_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.cart";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "我们快带不下更多的装备和战利品了。\n攒够7500克朗，买辆板车来减轻负担吧！";
		this.m.RewardTooltip = "你将解锁27个额外的仓库栏位。";
		this.m.UIText = "拥有至少7500克朗";
		this.m.TooltipText = "收集7500以上的克朗，用于购买一辆板车，获得额外的仓库空间。你可以通过完成合同、掠夺废墟或营地、进行贸易等方式赚钱。";
		this.m.SuccessText = "[img]gfx/ui/events/event_158.png[/img]攒够车匠要的钱让你们伤筋动骨，搞不好是字面意义上的伤筋动骨。如今拥有这辆崭新货车后，你们既能装载更多装备，也能运送更多战利品，无论是金银器皿还是从匪徒身上剥下的半破武装衣。\n\n和新车行进数里后，你发现%randombrother%不见了踪影。在周围找了又找，最终在货车的粮袋后找到他时，这人正打着鼾酣睡。一瓢冷水浇头再加一脚狠踹，很快让这懒汉爬起来继续徒步。你决定让所有人认清规矩。%SPEECH_ON%都给我听好！%companyname%的人想坐这辆车，除非是拎着自己脑袋上去！在这片土地行进时，所有人都必须保持警戒，武器不离手。%SPEECH_OFF%在弟兄们的嘟囔声中，队伍继续前进。";
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
