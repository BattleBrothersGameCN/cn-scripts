this.gatherers_hut_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "采集者小屋";
		this.m.ID = "attached_location.gatherers_hut";
		this.m.Description = "即使在植被稀少的环境中，经验丰富的采集者也能找到浆果、树根等可食用的东西。不算多美味，但却可以饱腹。";
		this.m.Sprite = "world_gatherers_hut_01";
		this.m.SpriteDestroyed = "world_gatherers_hut_01_ruins";
	}

	function onUpdateProduce( _list )
	{
		_list.push("supplies/roots_and_berries_item");
	}

	function onUpdateDraftList( _list )
	{
		if (!this.isActive())
		{
			return;
		}

		_list.push("daytaler_background");
	}

	function onUpdateShopList( _id, _list )
	{
		if (_id == "building.marketplace")
		{
			_list.push({
				R = 0,
				P = 1.0,
				S = "supplies/roots_and_berries_item"
			});
			_list.push({
				R = 20,
				P = 1.0,
				S = "weapons/bludgeon"
			});
			_list.push({
				R = 20,
				P = 1.0,
				S = "supplies/medicine_item"
			});
		}
	}

});
