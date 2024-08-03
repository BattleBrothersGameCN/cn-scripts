this.legendary_sword_blade_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.legendary_sword_blade";
		this.m.Name = "剑刃";
		this.m.Description = "你从克拉肯那里取回，依然还在闪闪发光的断剑剑刃。战斗了这么多年，你还从未见到过这么精巧的剑刃。如果能找回断剑的另一部分，或许就能重铸这把剑。";
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
