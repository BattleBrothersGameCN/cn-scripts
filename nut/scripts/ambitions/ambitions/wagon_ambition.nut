this.wagon_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.wagon";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "有辆小板车来运我们的东西很好，但还不够好。\n让我们存够15000克朗，买一辆真正的载重货车！";
		this.m.RewardTooltip = "你将解锁27个额外的仓库栏位。";
		this.m.UIText = "拥有至少15000克朗";
		this.m.TooltipText = "收集15000以上的克朗，用于购买一辆载重货车，获得额外的仓库空间。你可以通过完成合同、掠夺废墟或营地、进行贸易等方式赚钱。";
		this.m.SuccessText = "[img]gfx/ui/events/event_158.png[/img]一位智者曾告诉你，一辆载重货车一旦到手就失去了价值。你刚为这辆载重货车交出了10000克朗，脑海里随即就浮现出了这句格言。不过，等你走上车厢座椅，把靴子顶在踏板上时，又有了一种宾至如归的感觉。 你转身看了眼车架。在那上面，造货车的工匠安装了一系列带有铁钉的侧翻门，用来悬挂战利品、毛皮和其他物品。如果需要的话，还有一个笼子，可以关一条狗或是个存心不良的人。一个安有一个沉重的门闩的木制工具箱，装着修理武器和盔甲的所有必要工具。备用轮轴和车轮则固定在底盘上面。\n\n点了点头，你回头看看那匹捖马。这挽畜身形矮壮，有着发达的腿部肌肉，举止冷漠。它漫不经心地吃着它脚下的草，直到你拉起缰绳，示意它向前。载重货车动了一下，车头旋即又耷拉下去，并没有像你想象的一样跑起来的迹象。不过无巧不成书。\n\n%randombrother%边走边举着酒瓶子往自己嘴里倒。当他问你驾乘体验如何时，你顺走了他的瓶子，顺着车侧砸过去，大喊“驾！”";
		this.m.SuccessButtonText = "总算跑起来了。";
	}

	function onUpdateScore()
	{
		if (this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 4)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.cart").isDone())
		{
			return;
		}

		this.m.Score = 2 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getMoney() >= 15000)
		{
			return true;
		}

		return false;
	}

	function onReward()
	{
		local item;
		local stash = this.World.Assets.getStash();
		this.World.Assets.addMoney(-10000);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/icons/asset_money.png",
			text = "你花了[color=" + this.Const.UI.Color.NegativeEventValue + "]10,000[/color]克朗"
		});
		this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() + 27);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/icons/special.png",
			text = "你获得了27个额外的仓库空位"
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
