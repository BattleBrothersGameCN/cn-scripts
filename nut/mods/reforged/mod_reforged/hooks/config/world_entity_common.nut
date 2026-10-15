::Const.World.Common.RF_getTroopNameTemplateVars <- {
	function RF_getTroopNameTemplateVars( _troop )
	{
		local ret = [];
		local faction = ::World.FactionManager.getFaction(_troop.Faction);

		if (faction != null)
		{
			ret.push([
				"factionname",
				faction.getName()
			]);
		}

		return ret;
	}

}.RF_getTroopNameTemplateVars;
local addTroop = ::Const.World.Common.addTroop;
::Const.World.Common.addTroop = {
	function addTroop( _party, _troop, _updateStrength = true, _minibossify = 0 )
	{
		local ret = addTroop(_party, _troop, _updateStrength, _minibossify);

		if (ret.Name != "")
		{
			ret.Name = ::buildTextFromTemplate(ret.Name, this.RF_getTroopNameTemplateVars(ret));
		}

		return ret;
	}

}.addTroop;
local addUnitsToCombat = ::Const.World.Common.addUnitsToCombat;
::Const.World.Common.addUnitsToCombat = {
	function addUnitsToCombat( _into, _partyList, _resources, _faction, _minibossify = 0 )
	{
		local ret = addUnitsToCombat(_into, _partyList, _resources, _faction, _minibossify);

		foreach( unit in _into )
		{
			if (("Name" in unit) && unit.Name != "")
			{
				unit.Name = ::buildTextFromTemplate(unit.Name, this.RF_getTroopNameTemplateVars(unit));
			}
		}

		return ret;
	}

}.addUnitsToCombat;
local assignTroops = ::Const.World.Common.assignTroops;
::Const.World.Common.assignTroops = {
	function assignTroops( _party, _partyList, _resources, _minibossify = 0, _weightMode = 1 )
	{
		this.RF_addSpawnlistInfo(_party, _partyList);
		return assignTroops(_party, _partyList, _resources, _minibossify, _weightMode);
	}

}.assignTroops;
::Const.World.Common.RF_addSpawnlistInfo <- {
	function RF_addSpawnlistInfo( _entity, _partyList )
	{
		foreach( id, s in ::Const.World.Spawn )
		{
			if (s == _partyList)
			{
				if (_entity.getFlags().has("RF_Spawnlist"))
				{
					_entity.getFlags().set("RF_Spawnlist", _entity.getFlags().get("RF_Spawnlist") + ",\n" + id);
				}
				else
				{
					_entity.getFlags().set("RF_Spawnlist", id);
				}

				return;
			}
		}
	}

}.RF_addSpawnlistInfo;
