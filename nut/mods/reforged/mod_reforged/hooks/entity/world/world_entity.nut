::Reforged.HooksMod.hook("scripts/entity/world/world_entity", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.getFlags().set("RF_SpawnDay", ::World.getTime().Days);
			}

		}.create;
	};
	q.onCombatStarted = function ( __original )
	{
		return {
			function onCombatStarted()
			{
				__original();
				this.getFlags().increment("RF_NumCombats");
			}

		}.onCombatStarted;
	};
	q.clearTroops = function ( __original )
	{
		return {
			function clearTroops()
			{
				__original();
				this.getFlags().remove("RF_Spawnlist");
			}

		}.clearTroops;
	};
	q.getTroopComposition = function ( __original )
	{
		return {
			function getTroopComposition()
			{
				if (!::Reforged.Mod.ModSettings.getSetting("Dev_SpawnsInfo").getValue())
				{
					return __original();
				}

				local ret = [];
				local champions = [];
				local entityTypes = this.array(::Const.EntityType.len(), 0);

				foreach( t in this.m.Troops )
				{
					if (t.Script.len() == "")
					{
						continue;
					}

					if (t.Variant != 0)
					{
						champions.push(t);
					}
					else
					{
						++entityTypes[t.ID];
					}
				}

				foreach( c in champions )
				{
					ret.push({
						id = 20,
						type = "text",
						icon = "ui/orientation/" + ::Const.EntityIcon[c.ID] + ".png",
						text = c.Name
					});
				}

				foreach( i, num in entityTypes )
				{
					if (num != 0)
					{
						ret.push({
							id = 20,
							type = "text",
							icon = "ui/orientation/" + ::Const.EntityIcon[i] + ".png",
							text = num + " " + (num == 1 ? ::Const.Strings.EntityName[i] : ::Const.Strings.EntityNamePlural[i])
						});
					}
				}

				return ret;
			}

		}.getTroopComposition;
	};
	q.RF_getKnownContractsTooltip <- {
		function RF_getKnownContractsTooltip()
		{
			local knownContractsEntries = [];

			foreach( c in ::World.Contracts.RF_getKnownContracts() )
			{
				if (::MSU.isEqual(c.getHome(), this))
				{
					continue;
				}

				foreach( d in c.RF_getDestinations() )
				{
					if (::MSU.isEqual(this, d))
					{
						knownContractsEntries.push({
							id = 200,
							type = "hint",
							icon = c.RF_getTooltipIcon(),
							text = ::Reforged.Mod.Tooltips.parseString(::Reforged.NestedTooltips.getNestedObjectName(c, "func:RF_getTooltip,contentType:settlement-status-effect"))
						});
						break;
					}
				}
			}

			if (knownContractsEntries.len() != 0)
			{
				return [
					{
						id = 200,
						type = "hint",
						icon = "ui/icons/contract_scroll.png",
						text = ::World.Retinue.hasFollower("follower.agent") ? "相关合同" : "已知的相关合同",
						children = knownContractsEntries
					}
				];
			}

			return [];
		}

	}.RF_getKnownContractsTooltip;
	q.RF_addDevSpawnInfo <- {
		function RF_addDevSpawnInfo( _tooltip )
		{
			if (!this.isHiddenToPlayer() && this.m.Troops.len() != 0)
			{
				local cost = 0;
				local strength = 0;

				foreach( t in this.m.Troops )
				{
					cost = cost + ::Const.World.Spawn.RF_ScriptToTroopMap[t.Script].Cost;
					strength = strength + t.Strength;
				}

				_tooltip.push({
					id = 100,
					type = "hint",
					icon = "ui/icons/icon_contract_swords.png",
					text = this.format("消耗 / 战力 / 战斗数：%i / %i / %i", cost.tointeger(), strength.tointeger(), this.getFlags().has("RF_NumCombats") ? this.getFlags().get("RF_NumCombats") : 0)
				});
				_tooltip.push({
					id = 101,
					type = "hint",
					icon = "ui/icons/action_points.png",
					text = this.format("生成日：%i", this.getFlags().has("RF_SpawnDay") ? this.getFlags().get("RF_SpawnDay") : 0)
				});
				local spawnListID;

				if (this.getFlags().has("RF_Spawnlist"))
				{
					spawnListID = this.getFlags().get("RF_Spawnlist");
				}
				else if (this.isLocation() && this.m.DefenderSpawnList != null)
				{
					foreach( id, s in ::Const.World.Spawn )
					{
						if (s == this.m.DefenderSpawnList)
						{
							spawnListID = id;
							break;
						}
					}
				}

				if (spawnListID != null)
				{
					_tooltip.push({
						id = 102,
						type = "hint",
						icon = "ui/icons/special.png",
						text = "生成列表：" + spawnListID
					});
				}
			}
		}

	}.RF_addDevSpawnInfo;
	q.onDeserialize = function ( __original )
	{
		return {
			function onDeserialize( _in )
			{
				__original(_in);

				if (!::Reforged.Mod.Serialization.isSavedVersionAtLeast("0.8.18", _in.getMetaData()))
				{
					local troopScriptToEntityTypeMap = {};

					foreach( t in ::Const.World.Spawn.Troops )
					{
						troopScriptToEntityTypeMap[t.Script] <- t.ID;
					}

					foreach( t in this.m.Troops )
					{
						t.ID = troopScriptToEntityTypeMap[t.Script];
					}
				}
			}

		}.onDeserialize;
	};
});
::Reforged.HooksMod.hookTree("scripts/entity/world/world_entity", function ( q )
{
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();

				if (this.getFaction() == 0)
				{
					return ret;
				}

				ret.extend(this.RF_getKnownContractsTooltip());

				if (::Reforged.Mod.ModSettings.getSetting("Dev_SpawnsInfo").getValue())
				{
					this.RF_addDevSpawnInfo(ret);
				}

				return ret;
			}

		}.getTooltip;
	};
});
