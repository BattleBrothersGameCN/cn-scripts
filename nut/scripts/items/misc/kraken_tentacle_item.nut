this.kraken_tentacle_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.kraken_tentacle";
		this.m.Name = "断掉的触手";
		this.m.Description = "传说生物克拉肯干瘪的触手残骸，粘糊糊的，但炼金术士们却因它的稀有性大加追捧。";
		this.m.Icon = "misc/inventory_kraken_tentacle.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 4000;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/enemies/unhold_regenerate_01.wav", this.Const.Sound.Volume.Inventory);
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
