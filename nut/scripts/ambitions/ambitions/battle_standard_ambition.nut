this.battle_standard_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.battle_standard";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "我们需要一柄战旗，以便从远处认出我们！\n做一柄要花不少钱，我们要为此凑齐2000克朗。";
		this.m.RewardTooltip = "你将获得一件独特物品，它能授予执旗者附近所有人额外决心。";
		this.m.UIText = "拥有至少2000克朗";
		this.m.TooltipText = "收集2000以上的克朗，以便请人为战团打造战旗。你可以通过完成合同、掠夺废墟或营地、进行贸易等方式赚钱。当然，你还需要在仓库中留出足够存放一件新物品的空间。";
		this.m.SuccessText = "[img]gfx/ui/events/event_65.png[/img]没有人喜欢吝啬鬼，尤其是对一群出于对金钱热爱凑到一起，流浪、嗜血的乌合之众而言。当你建议减少开支以积攒战团旗帜的费用时，并非所有人，更准确地说是没有人，对此感到兴奋。\n\n然而，当%companyname%的旗帜终于付清费用，并第一次被傲然举起，在清晨微风中猎猎作响时，没有人会说不值得。男人们为他们的新旗帜感到自豪，甚至在篝火旁讨论给它起什么名字，尽管最后也没定下来。\n\n现在所有人都能清楚地看到，这不是一伙受人雇佣的暴徒，而是一支货真价实的新兴佣兵团。谁能担负起执旗的荣耀呢？";
		this.m.SuccessButtonText = "兄弟们，那就是我们的旗帜！";
	}

	function onUpdateScore()
	{
		if (this.World.Ambitions.getDone() < 1)
		{
			return;
		}

		this.m.Score = 10;
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getMoney() >= 2000 && this.World.Assets.getStash().hasEmptySlot())
		{
			return true;
		}

		return false;
	}

	function onReward()
	{
		local item;
		local stash = this.World.Assets.getStash();
		this.World.Assets.addMoney(-1000);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/icons/asset_money.png",
			text = "你花了[color=" + this.Const.UI.Color.NegativeEventValue + "]1,000[/color]克朗"
		});
		item = this.new("scripts/items/tools/player_banner");
		item.setVariant(this.World.Assets.getBannerID());
		stash.add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "你获得了" + this.Const.Strings.getArticle(item.getName()) + item.getName()
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
