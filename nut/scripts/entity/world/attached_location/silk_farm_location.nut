this.silk_farm_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "蚕丝作坊";
		this.m.ID = "attached_location.silk_farm";
		this.m.Description = "在这些棚屋里，珍贵的丝绸被用秘密的方法从小虫子的茧中纺出。";
		this.m.Sprite = "world_silk_01";
		this.m.SpriteDestroyed = "world_silk_01_ruins";
	}

	function onBuild()
	{
		local myTile = this.getTile();
		myTile.setBrush("world_desert_0" + this.Math.rand(6, 9));
		return true;
	}

	function onUpdateProduce( _list )
	{
		_list.push("trade/silk_item");
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
				S = "trade/silk_item"
			});
		}
	}

});
