this.plantation_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "种植园";
		this.m.ID = "attached_location.plantation";
		this.m.Description = "这片种植园培育着各种奇异的香料和药草。贫瘠沙漠中少有的一小块丰饶之地。";
		this.m.Sprite = "world_spice_01";
		this.m.SpriteDestroyed = "world_spice_01_ruins";
	}

	function onBuild()
	{
		local myTile = this.getTile();
		myTile.setBrush("world_desert_0" + this.Math.rand(6, 9));
		return true;
	}

	function onUpdateProduce( _list )
	{
		_list.push("trade/spices_item");
	}

	function onUpdateDraftList( _list )
	{
		if (!this.isActive())
		{
			return;
		}

		_list.push("slave_southern_background");
		_list.push("slave_southern_background");
	}

	function onUpdateShopList( _id, _list )
	{
		if (_id == "building.marketplace")
		{
			_list.push({
				R = 0,
				P = 1.0,
				S = "trade/spices_item"
			});
			_list.push({
				R = 0,
				P = 1.0,
				S = "supplies/dates_item"
			});
		}
	}

});
