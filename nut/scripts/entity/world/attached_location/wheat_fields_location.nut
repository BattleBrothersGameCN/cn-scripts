this.wheat_fields_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "麦田";
		this.m.ID = "attached_location.wheat_fields";
		this.m.Description = "阳光照耀下的麦田远远地就发着闪闪金光，许多来自附近定居点的雇农和短工工作在这里。";
		this.m.Sprite = "world_wheat_farm_01";
		this.m.SpriteDestroyed = "world_wheat_farm_01_ruins";
	}

	function getSounds( _all = true )
	{
		local r = [];

		if (this.World.getTime().IsDaytime)
		{
			r = [
				{
					File = "ambience/buildings/market_chicken_00.wav",
					Volume = 1.000000,
					Pitch = 1.000000
				},
				{
					File = "ambience/buildings/market_chicken_01.wav",
					Volume = 1.000000,
					Pitch = 1.000000
				},
				{
					File = "ambience/buildings/market_chicken_02.wav",
					Volume = 1.000000,
					Pitch = 1.000000
				},
				{
					File = "ambience/buildings/market_chicken_04.wav",
					Volume = 1.000000,
					Pitch = 1.000000
				},
				{
					File = "ambience/buildings/market_chicken_05.wav",
					Volume = 1.000000,
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

	function onBuild()
	{
		local myTile = this.getTile();
		local num = 0;

		for( local i = 0; i != 6; i = ++i )
		{
			if (!myTile.hasNextTile(i))
			{
			}
			else
			{
				local nextTile = myTile.getNextTile(i);

				if (nextTile.IsOccupied || nextTile.HasRoad)
				{
				}
				else if (nextTile.Type != this.Const.World.TerrainType.Plains && nextTile.Type != this.Const.World.TerrainType.Tundra && nextTile.Type != this.Const.World.TerrainType.Steppe)
				{
				}
				else
				{
					if (this.Math.rand(1, 100) <= 50)
					{
						nextTile.clear();
						nextTile.spawnDetail("world_wheat_field_0" + this.Math.rand(1, 2), this.Const.World.ZLevel.Object, this.Const.World.DetailType.NotCompatibleWithRoad);
						num = ++num;
					}

					if (num >= 2)
					{
						break;
					}
				}
			}
		}

		return true;
	}

	function onUpdateProduce( _list )
	{
		_list.push("supplies/bread_item");
	}

	function onUpdateDraftList( _list )
	{
		if (!this.isActive())
		{
			return;
		}

		_list.push("farmhand_background");
		_list.push("farmhand_background");
		_list.push("farmhand_background");
		_list.push("daytaler_background");
		_list.push("daytaler_background");
		_list.push("miller_background");
		_list.push("miller_background");
	}

	function onUpdateShopList( _id, _list )
	{
		if (_id == "building.marketplace")
		{
			_list.push({
				R = 0,
				P = 1.000000,
				S = "supplies/bread_item"
			});
			_list.push({
				R = 10,
				P = 1.000000,
				S = "helmets/straw_hat"
			});
			_list.push({
				R = 20,
				P = 1.000000,
				S = "weapons/pitchfork"
			});
			_list.push({
				R = 50,
				P = 1.000000,
				S = "weapons/hooked_blade"
			});
		}
	}

	function onInit()
	{
		this.attached_location.onInit();
		this.getSprite("body").Scale = 0.900000;
	}

});
