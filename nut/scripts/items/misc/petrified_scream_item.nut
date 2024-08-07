this.petrified_scream_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.petrified_scream";
		this.m.Name = "石化尖声";
		this.m.Description = "梦魇遗骸中发现的怪异物件。带在身上可能会带来噩梦，影响休息。";
		this.m.Icon = "misc/inventory_alp_scream.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 750;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

	function getSellPriceMult()
	{
		return this.World.State.getCurrentTown().getBeastPartsPriceMult();
	}

	function getBuyPriceMult()
	{
		return this.World.State.getCurrentTown().getBeastPartsPriceMult();
	}

});
