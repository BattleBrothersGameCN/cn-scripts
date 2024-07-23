this.incense_dryer_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "熏香晒场";
		this.m.ID = "attached_location.incense_dryer";
		this.m.Description = "周围的树上的树汁被收集起来，放到阳光下晒干，制成值钱的熏香。";
		this.m.Sprite = "world_incense_01";
		this.m.SpriteDestroyed = "world_incense_01_ruins";
	}

	function onBuild()
	{
		local myTile = this.getTile();
		myTile.setBrush("world_desert_0" + this.Math.rand(6, 9));
		return true;
	}

	function onUpdateProduce( _list )
	{
		_list.push("trade/incense_item");
	}

	function onUpdateDraftList( _list )
	{
		if (!this.isActive())
		{
			return;
		}

		_list.push("daytaler_southern_background");
		_list.push("daytaler_southern_background");
	}

	function onUpdateShopList( _id, _list )
	{
		if (_id == "building.marketplace")
		{
			_list.push({
				R = 0,
				P = 1.0,
				S = "trade/incense_item"
			});
		}
	}

});
