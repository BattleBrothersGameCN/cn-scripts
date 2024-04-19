this.witch_hair_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.witch_hair";
		this.m.Name = "女巫头发";
		this.m.Description = "女巫身上长而易碎的灰白头发。 据说能做出功效强大的灵丹妙药。 不过话说回来，也有人说女巫会把受害者的生殖器养作宠物，所以农夫说的话也不能尽信。";
		this.m.Icon = "misc/inventory_hexe_hair.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 2000;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/cloth_01.wav", this.Const.Sound.Volume.Inventory);
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
