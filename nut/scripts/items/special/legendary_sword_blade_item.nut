this.legendary_sword_blade_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.legendary_sword_blade";
		this.m.Name = "剑刃";
		this.m.Description = "你从克拉肯那里找回的一把破碎的闪光剑刃。在你这么多年的战斗中，你从未见过这么精巧的利刃。 如果你有这把剑的两个部分，也许它可以被重新锻造。";
		this.m.Icon = "misc/inventory_sword_blade_01.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 2500;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

});
