this.bounty_hunter_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.bounty_hunter";
		this.m.Name = "赏金猎人";
		this.m.Description = "这位穿着花哨的赏金猎人有个专装合同的口袋，合同上尽是那些最危险的人。他知道如何找到他们的藏身处，还会为所有完成的悬赏付上一大笔钱。";
		this.m.Image = "ui/campfire/bounty_hunter_01";
		this.m.Cost = 4000;
		this.m.Effects = [
			"显著增加遇到冠军的机会",
			"为每一个被杀的冠军支付300到750克朗"
		];
		this.m.Requirements = [
			{
				IsSatisfied = false,
				Text = ""
			}
		];
	}

	function isValid()
	{
		return this.Const.DLC.Wildmen;
	}

	function onUpdate()
	{
		this.World.Assets.m.ChampionChanceAdditional = 3;
	}

	function onEvaluate()
	{
		local namedItems = this.getNumberOfNamedItems();
		this.m.Requirements[0].Text = "拥有" + this.Math.min(3, namedItems) + "/3件著名或传说物品";

		if (namedItems >= 3)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

	function onChampionKilled( _champion )
	{
		if (this.Tactical.State.getStrategicProperties() == null || !this.Tactical.State.getStrategicProperties().IsArenaMode)
		{
			this.World.Assets.addMoney(this.Math.floor(_champion.getXPValue()));
		}
	}

	function getNumberOfNamedItems()
	{
		local n = 0;
		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)) && item.getID() != "armor.head.fangshire")
			{
				n = ++n;
			}
		}

		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
			{
				n = ++n;
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

			if (item != null && item != "-1" && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
			{
				n = ++n;
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Head);

			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)) && item.getID() != "armor.head.fangshire")
			{
				n = ++n;
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body);

			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
			{
				n = ++n;
			}

			for( local i = 0; i < bro.getItems().getUnlockedBagSlots(); i = ++i )
			{
				local item = bro.getItems().getItemAtBagSlot(i);

				if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
				{
					n = ++n;
				}
			}
		}

		return n;
	}

});
