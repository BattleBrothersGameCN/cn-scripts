this.named_item_set_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.named_item_set";
		this.m.Duration = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "有口皆碑的战团会因其装备而得到认可。我们应该去获\n取著名武器、盾牌、盔甲或头盔各一件，提高我们的名望。";
		this.m.UIText = "拥有著名武器、盾牌、盔甲和头盔各一件。";
		this.m.TooltipText = "至少拥有著名武器、盾牌、盔甲和头盔各一件。在酒馆里打探谣言，搜罗著名物品的消息，在大城市和城堡的专门商店购买它们，或者是自己探索，攻陷废墟和营地。距离文明越远，发现稀有物品的几率越高。";
		this.m.SuccessText = "[img]gfx/ui/events/event_82.png[/img]数周以来，你一直在打听消息，又是给年迈的老兵买酒，又是和故弄玄虚的老太太们谈判，几经周折，终于知道了那些著名武器、盾牌、盔甲和头盔现在何处。知道了这些装备的下落，打败守卫它们的怪物土匪们就是小菜一碟了。现在，这套足以让任何看到它的人心生畏惧的装备，就等着战团的兄弟们上身了。%SPEECH_ON%谁要是穿着这身上了战场，就能欣赏他最凶猛的对手也得屁滚尿流落荒而逃了！%SPEECH_OFF%%randombrother%自豪地欢呼着，得到了他战友们的欢笑和赞许。你只希望在宣布由谁来穿这身装备后，他们的喜悦和兴奋不会变成嫉妒。";
		this.m.SuccessButtonText = "它们将为我所用。";
	}

	function getNamedItems()
	{
		local ret = {
			Weapon = false,
			Shield = false,
			Armor = false,
			Helmet = false,
			Items = 0
		};
		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)) && item.getID() != "armor.head.fangshire")
			{
				++ret.Items;

				if (item.isItemType(this.Const.Items.ItemType.Weapon))
				{
					ret.Weapon = true;
				}
				else if (item.isItemType(this.Const.Items.ItemType.Shield))
				{
					ret.Shield = true;
				}
				else if (item.isItemType(this.Const.Items.ItemType.Armor))
				{
					ret.Armor = true;
				}
				else if (item.isItemType(this.Const.Items.ItemType.Helmet))
				{
					ret.Helmet = true;
				}
			}
		}

		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
			{
				++ret.Items;

				if (item.isItemType(this.Const.Items.ItemType.Weapon))
				{
					ret.Weapon = true;
				}
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

			if (item != null && item != "-1" && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
			{
				++ret.Items;

				if (item.isItemType(this.Const.Items.ItemType.Shield))
				{
					ret.Shield = true;
				}
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Head);

			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)) && item.getID() != "armor.head.fangshire")
			{
				++ret.Items;

				if (item.isItemType(this.Const.Items.ItemType.Helmet))
				{
					ret.Helmet = true;
				}
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body);

			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
			{
				++ret.Items;

				if (item.isItemType(this.Const.Items.ItemType.Armor))
				{
					ret.Armor = true;
				}
			}

			for( local i = 0; i < bro.getItems().getUnlockedBagSlots(); i = ++i )
			{
				local item = bro.getItems().getItemAtBagSlot(i);

				if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
				{
					++ret.Items;

					if (item.isItemType(this.Const.Items.ItemType.Weapon))
					{
						ret.Weapon = true;
					}
					else if (item.isItemType(this.Const.Items.ItemType.Shield))
					{
						ret.Shield = true;
					}
					else if (item.isItemType(this.Const.Items.ItemType.Armor))
					{
						ret.Armor = true;
					}
					else if (item.isItemType(this.Const.Items.ItemType.Helmet))
					{
						ret.Helmet = true;
					}
				}
			}
		}

		return ret;
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.getTime().Days <= 50)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 5)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		local named = this.getNamedItems();

		if (named.Items == 0)
		{
			return;
		}

		if (named.Weapon && named.Shield && named.Armor && named.Helmet)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local named = this.getNamedItems();

		if (named.Weapon && named.Shield && named.Armor && named.Helmet)
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
