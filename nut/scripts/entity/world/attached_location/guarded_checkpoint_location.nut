this.guarded_checkpoint_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "有守卫的检查站";
		this.m.ID = "attached_location.guarded_checkpoint";
		this.m.Description = "由职业士兵管理的道路检查站。";
		this.m.Sprite = "world_guarded_checkpoint_01";
		this.m.SpriteDestroyed = "world_guarded_checkpoint_01_ruins";
		this.m.IsMilitary = true;
	}

	function onUpdateDraftList( _list )
	{
		if (!this.isActive())
		{
			return;
		}

		_list.push("militia_background");
		_list.push("deserter_background");
		_list.push("sellsword_background");
	}

	function onUpdateShopList( _id, _list )
	{
		if (_id == "building.marketplace")
		{
			_list.push({
				R = 30,
				P = 1.000000,
				S = "armor/leather_tunic"
			});
			_list.push({
				R = 40,
				P = 1.000000,
				S = "armor/padded_surcoat"
			});
			_list.push({
				R = 40,
				P = 1.000000,
				S = "armor/padded_leather"
			});
			_list.push({
				R = 50,
				P = 1.000000,
				S = "armor/gambeson"
			});
			_list.push({
				R = 60,
				P = 1.000000,
				S = "armor/basic_mail_shirt"
			});
			_list.push({
				R = 10,
				P = 1.000000,
				S = "helmets/aketon_cap"
			});
			_list.push({
				R = 15,
				P = 1.000000,
				S = "helmets/full_aketon_cap"
			});
			_list.push({
				R = 60,
				P = 1.000000,
				S = "helmets/nasal_helmet"
			});
			_list.push({
				R = 65,
				P = 1.000000,
				S = "helmets/kettle_hat"
			});
			_list.push({
				R = 65,
				P = 1.000000,
				S = "helmets/flat_top_helmet"
			});
			_list.push({
				R = 30,
				P = 1.000000,
				S = "shields/wooden_shield"
			});
			_list.push({
				R = 70,
				P = 1.000000,
				S = "weapons/billhook"
			});
			_list.push({
				R = 60,
				P = 1.000000,
				S = "weapons/military_cleaver"
			});
			_list.push({
				R = 70,
				P = 1.000000,
				S = "weapons/boar_spear"
			});
		}
		else if (_id == "building.specialized_trader")
		{
		}
		else if (_id == "building.weaponsmith")
		{
		}
		else if (_id == "building.armorsmith")
		{
		}
	}

});
