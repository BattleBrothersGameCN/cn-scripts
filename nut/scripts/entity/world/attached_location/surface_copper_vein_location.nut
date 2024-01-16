this.surface_copper_vein_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "露天铜矿脉";
		this.m.ID = "attached_location.surface_copper_vein";
		this.m.Description = "一个采矿营地已经建立了起来，旨在从露出地表的铜矿脉中开采矿石，并就地将其熔炼成铜锭。";
		this.m.Sprite = "world_copper_vein_01";
		this.m.SpriteDestroyed = "world_copper_vein_01_ruins";
	}

	function getSounds( _all = true )
	{
		local r = [];

		if (this.World.getTime().IsDaytime)
		{
			r = [
				{
					File = "ambience/settlement/mines_00.wav",
					Volume = 1.250000,
					Pitch = 1.000000
				},
				{
					File = "ambience/settlement/mines_01.wav",
					Volume = 1.250000,
					Pitch = 1.000000
				},
				{
					File = "ambience/settlement/mines_shoveling_00.wav",
					Volume = 1.250000,
					Pitch = 1.000000
				},
				{
					File = "ambience/settlement/mines_shoveling_01.wav",
					Volume = 1.250000,
					Pitch = 1.000000
				},
				{
					File = "ambience/settlement/mines_shoveling_02.wav",
					Volume = 1.250000,
					Pitch = 1.000000
				},
				{
					File = "ambience/settlement/mines_shoveling_03.wav",
					Volume = 1.250000,
					Pitch = 1.000000
				}
			];

			foreach( s in r )
			{
				s.Volume *= this.Const.Sound.Volume.Ambience / this.Const.Sound.Volume.AmbienceOutsideSettlement;
			}
		}

		return r;
	}

	function onUpdateProduce( _list )
	{
		_list.push("trade/copper_ingots_item");
	}

	function onUpdateDraftList( _list )
	{
		if (!this.isActive())
		{
			return;
		}

		_list.push("miner_background");
		_list.push("miner_background");
		_list.push("miner_background");
		_list.push("caravan_hand_background");
	}

	function onUpdateShopList( _id, _list )
	{
		if (_id == "building.marketplace")
		{
			_list.push({
				R = 20,
				P = 1.000000,
				S = "weapons/pickaxe"
			});
			_list.push({
				R = 0,
				P = 1.000000,
				S = "trade/copper_ingots_item"
			});
			_list.push({
				R = 25,
				P = 1.000000,
				S = "supplies/armor_parts_item"
			});
		}
		else if (_id == "building.specialized_trader")
		{
		}
	}

});
