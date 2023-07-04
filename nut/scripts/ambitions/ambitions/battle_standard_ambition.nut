this.battle_standard_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.battle_standard";
		this.m.Duration = 99999.000000 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "我们需要一柄战旗，这样从远处就能认出我们来！\n做一柄很费钱，所以我们要为此收集2000克朗。";
		this.m.RewardTooltip = "你将获得一个独特的物品，授予佩戴者附近的任何人额外的决心。";
		this.m.UIText = "拥有至少2000克朗";
		this.m.TooltipText = "收集2000或更多的克朗，这样就能为战团打造一柄战旗。你可以通过完成合同、掠夺营地和废墟或贸易来赚钱。当然，你还需要在仓库中留出足够的空间来存放一个新物品。";
		this.m.SuccessText = "[img]gfx/ui/events/event_65.png[/img]没有人喜欢吝啬鬼，尤其是对一群主要出于对金钱的爱而行动的流浪、嗜血乌合之众而言。当你建议减少开支以积攒战团旗帜的费用时，不是每个人，更准确地说是没有人，对此感到兴奋。\n\n然而，一旦%companyname%的旗帜终于付清费用，并第一次被傲然举起，在清晨微风中猎猎作响，没有人会说不值得。男人们为他们的新旗帜感到自豪，甚至在篝火旁讨论起它的命名，尽管没有一个名字真正确定下来。\n\n现在所有人都能清楚地看到，这不再是一伙雇佣的暴徒，这是一支成长中的真正佣兵战团。谁应该有荣幸举着这面旗帜？";
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
			text = "你花费了 [color=" + this.Const.UI.Color.NegativeEventValue + "]1,000[/color] 克朗"
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
