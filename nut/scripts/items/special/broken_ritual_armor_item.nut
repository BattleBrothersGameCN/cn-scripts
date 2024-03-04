this.broken_ritual_armor_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.broken_ritual_armor";
		this.m.Name = "破碎的仪式盔甲";
		this.m.Description = "一件厚重的野蛮盔甲的残片，上面覆盖着仪式用的符文。 它不能像这样使用，但是你觉得它有一些特别的地方。 也许有什么办法可以补救？";
		this.m.Icon = "misc/inventory_champion_armor_quest.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 1000;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_halfplate_impact_01.wav", this.Const.Sound.Volume.Inventory);
	}

});
