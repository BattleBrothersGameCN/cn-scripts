this.goat_herd_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "山羊圈";
		this.m.ID = "attached_location.goat_herd";
		this.m.Description = "这里饲养的山羊主要用来产奶，然后再把奶制成奶酪这样的耐储食品。";
		this.m.Sprite = "world_goat_herd_01";
		this.m.SpriteDestroyed = "world_goat_herd_01_ruins";
	}

	function getSounds( _all = true )
	{
		local r = [];

		if (this.World.getTime().IsDaytime)
		{
			r = [
				{
					File = "ambience/settlement/goat_pens_00.wav",
					Volume = 1.000000,
					Pitch = 1.000000
				},
				{
					File = "ambience/settlement/goat_pens_01.wav",
					Volume = 1.000000,
					Pitch = 1.000000
				},
				{
					File = "ambience/settlement/goat_pens_02.wav",
					Volume = 1.000000,
					Pitch = 1.000000
				},
				{
					File = "ambience/settlement/goat_pens_03.wav",
					Volume = 1.000000,
					Pitch = 1.000000
				},
				{
					File = "ambience/settlement/goat_pens_04.wav",
					Volume = 1.000000,
					Pitch = 1.000000
				},
				{
					File = "ambience/settlement/goat_pens_05.wav",
					Volume = 1.000000,
					Pitch = 1.000000
				},
				{
					File = "ambience/settlement/goat_pens_06.wav",
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

	function onUpdateProduce( _list )
	{
		_list.push("supplies/goat_cheese_item");
	}

	function onUpdateDraftList( _list )
	{
		if (!this.isActive())
		{
			return;
		}

		_list.push("butcher_background");
		_list.push("daytaler_background");
		_list.push("farmhand_background");
		_list.push("farmhand_background");
		_list.push("farmhand_background");
		_list.push("shepherd_background");
		_list.push("shepherd_background");
		_list.push("shepherd_background");
	}

	function onUpdateShopList( _id, _list )
	{
		if (_id == "building.marketplace")
		{
			_list.push({
				R = 0,
				P = 1.000000,
				S = "supplies/goat_cheese_item"
			});
			_list.push({
				R = 20,
				P = 1.000000,
				S = "weapons/bludgeon"
			});
			_list.push({
				R = 30,
				P = 1.000000,
				S = "armor/leather_tunic"
			});
		}
	}

});
