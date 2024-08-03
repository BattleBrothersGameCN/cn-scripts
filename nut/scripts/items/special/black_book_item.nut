this.black_book_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.black_book";
		this.m.Name = "黑书";
		this.m.Description = "一本用血肉做封皮的诡异旧书。书页间写满了难以理解的高深文字和神秘图画。看的越久，你就越是心烦意乱。要是谁懂点古代语言兴许能读出什么来。";
		this.m.Icon = "misc/inventory_necronomicon.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 1000;
	}

});
