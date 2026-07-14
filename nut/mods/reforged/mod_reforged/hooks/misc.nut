::Reforged.Const <- {};
::MSU.Table.merge(::Reforged, {
	function new( _script, _function = null )
	{
		local obj = ::new(_script);

		if (_function != null)
		{
			_function(obj);
		}

		return obj;
	}

	function getWeaponPerkGroups( _weapon )
	{
		local ret = [];

		foreach( weaponTypeName, weaponType in ::Const.Items.WeaponType )
		{
			if (!_weapon.isWeaponType(weaponType))
			{
				continue;
			}

			if (weaponTypeName == "Firearm")
			{
				weaponTypeName = "弩";
			}

			local pgID = "pg.rf_" + weaponTypeName.tolower();

			if (::DynamicPerks.PerkGroups.findById(pgID) != null)
			{
				ret.push(pgID);
			}
		}

		return ret;
	}

	function expandLevelXP( _len )
	{
		while (::Const.LevelXP.len() < _len)
		{
			::Const.LevelXP.push(::Const.LevelXP.top() + 4000 + 1000 * (::Const.LevelXP.len() - 11));
		}
	}

});
