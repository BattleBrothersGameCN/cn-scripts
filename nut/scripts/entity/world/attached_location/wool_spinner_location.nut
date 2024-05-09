this.wool_spinner_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "毛纺厂";
		this.m.ID = "attached_location.wool_spinner";
		this.m.Description = "在这里放牧的羊的毛被纺成毛料，然后运到下一个定居点。像这样的精致商品有利可图。";
		this.m.Sprite = "world_wool_spinner_01";
		this.m.SpriteDestroyed = "world_wool_spinner_01_ruins";
	}

	function onUpdateProduce( _list )
	{
		_list.push("trade/cloth_rolls_item");
	}

	function onUpdateDraftList( _list )
	{
		if (!this.isActive())
		{
			return;
		}

		_list.push("apprentice_background");
		_list.push("caravan_hand_background");
		_list.push("tailor_background");
		_list.push("tailor_background");
		_list.push("shepherd_background");
	}

	function onUpdateShopList( _id, _list )
	{
		if (_id == "building.marketplace")
		{
			_list.push({
				R = 10,
				P = 1.0,
				S = "armor/linen_tunic"
			});
			_list.push({
				R = 10,
				P = 1.0,
				S = "armor/linen_tunic"
			});
			_list.push({
				R = 10,
				P = 1.0,
				S = "helmets/hood"
			});
			_list.push({
				R = 0,
				P = 1.0,
				S = "trade/cloth_rolls_item"
			});
		}
		else if (_id == "building.specialized_trader")
		{
		}
	}

});
