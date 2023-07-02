this.black_book_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.black_book";
		this.m.Name = "黑书";
		this.m.Description = "一本外表诡异的旧书，是血肉封皮。 它的页面充满了你无法理解的难以捉摸的文字和神秘的图画。 你看这本书看得越久，你就越感到不安。 也许对古代语言有更多了解的人能理解它。";
		this.m.Icon = "misc/inventory_necronomicon.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 1000;
	}

});
