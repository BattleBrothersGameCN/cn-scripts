::Reforged <- {
	Version = "0.9.2",
	ID = "mod_reforged",
	Name = "重铸模组",
	ItemTable = {},
	Spawns = {
		Units = {},
		UnitBlocks = {},
		Parties = {}
	},
	DebugFlag = {
		AI = "AI",
		onAnySkillExecutedFully = "onAnySkillExecutedFully",
		AIAgentFixes = "AIAgentFixes"
	},
	QueueBucket = {
		Late = [],
		VeryLate = [],
		AfterHooks = [],
		FirstWorldInit = []
	}
};
local requiredMods = [
	"vanilla >= 1.5.2-2",
	"mod_modular_vanilla >= 0.8.3",
	"mod_msu >= 1.9.0",
	"mod_nested_tooltips >= 0.5.3",
	"mod_modern_hooks >= 0.4.10",
	"dlc_lindwurm",
	"dlc_unhold",
	"dlc_wildmen",
	"dlc_desert",
	"dlc_paladins",
	"mod_dynamic_perks >= 0.5.0",
	"mod_dynamic_spawns >= 0.6.0",
	"mod_item_tables >= 0.1.3",
	"mod_upd",
	"mod_stack_based_skills >= 0.5.1",
	"mod_reforged_assets >= 0.1.4"
];
::Reforged.HooksMod <- ::Hooks.register(::Reforged.ID, ::Reforged.Version, ::Reforged.Name);
::Reforged.HooksMod.require(requiredMods);
::include("mod_reforged/mod_conflicts");
local queueLoadOrder = [];

foreach( requirement in requiredMods )
{
	local idx = requirement.find(" ");
	queueLoadOrder.push(">" + (idx == null ? requirement : requirement.slice(0, idx)));
}

::Reforged.HooksMod.queue(queueLoadOrder, function ()
{
	::Reforged.HooksMod.hook("scripts/entity/world/combat_manager", function ( q )
	{
		q.tickCombat = function ()
		{
			return {
				function tickCombat( _combat )
				{
					local attackOccured = false;

					for( local i = 0; i < _combat.Combatants.len(); i++ )
					{
						local combatant = _combat.Combatants[i];

						if (::MSU.isNull(combatant.Party))
						{
						}
						else
						{
							local potentialOpponentFactions = _combat.Factions.filter(function ( _f, _parties )
							{
								return _parties.len() != 0 && combatant.Party.getFaction() != _f && !::World.FactionManager.isAllied(combatant.Party.getFaction(), _f);
							});

							if (potentialOpponentFactions.len() == 0)
							{
								  // [024]  OP_CLOSE          0      4    0    0
							}
							else
							{
								for( local damage = ::Math.maxf(1.0, ::MSU.Math.randf(1.0, combatant.Strength.tofloat()) * ::Const.World.CombatSettings.CombatStrengthMult); damage > 0;  )
								{
									local opponentParties = [];

									foreach( parties in potentialOpponentFactions )
									{
										if (parties.len() != 0)
										{
											opponentParties.extend(parties.filter(function ( _, _p )
											{
												return !::MSU.isNull(_p) && _p.getTroops().len() != 0;
											}));
										}
									}

									if (opponentParties.len() == 0)
									{
										break;
									}

									local opponentParty = ::MSU.Array.rand(opponentParties);
									local opponentIndex = ::Math.rand(0, opponentParty.getTroops().len() - 1);
									local opponent = opponentParty.getTroops()[opponentIndex];
									attackOccured = true;
									local damageDealt = ::Math.minf(damage, opponent.Strength);
									damage = damage - damageDealt;
									opponent.Strength -= damageDealt;

									if (opponent.Strength <= 0)
									{
										++_combat.Stats.Dead;
										opponentParty.getTroops().remove(opponentIndex);
										opponentIndex = _combat.Combatants.find(opponent);
										_combat.Combatants.remove(opponentIndex);

										if (opponentIndex < i)
										{
											i--;
										}

										if (opponentParty.getTroops().len() == 0)
										{
											_combat.Stats.Loot.extend(opponentParty.getInventory());
											local partyIndex = _combat.Factions[opponentParty.getFaction()].find(opponentParty);
											opponentParty.setCombatID(0);
											_combat.Factions[opponentParty.getFaction()].remove(partyIndex);
											opponentParty.onCombatLost();
										}
									}
								}

								  // [154]  OP_CLOSE          0      4    0    0
							}
						}
					}

					if (!attackOccured)
					{
						_combat.IsResolved = true;
					}
				}

			}.tickCombat;
		};
	});
	::Reforged.HooksMod.hook("scripts/items/shields/shield", function ( q )
	{
		q.applyShieldDamage = function ( __original )
		{
			return {
				function applyShieldDamage( _damage, _playHitSound = true )
				{
					if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInShields)
					{
						_damage = _damage * 2;
					}

					__original(_damage, _playHitSound);
				}

			}.applyShieldDamage;
		};
	});
}, ::Hooks.QueueBucket.Early);
::Reforged.HooksMod.queue(queueLoadOrder, function ()
{
	::Reforged.Mod <- ::MSU.Class.Mod(::Reforged.ID, ::Reforged.Version, ::Reforged.Name);
	::Reforged.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.GitHub, "https://github.com/Battle-Modders/mod-reforged");
	::Reforged.Mod.Registry.setUpdateSource(::MSU.System.Registry.ModSourceDomain.GitHub);
	::Reforged.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.NexusMods, "https://www.nexusmods.com/battlebrothers/mods/765");
	::Reforged.checkConflictWithFilename();
	delete ::Reforged.checkConflictWithFilename;
	::Reforged.Mod.Debug.setFlag(::Reforged.DebugFlag.AI, false);
	::Reforged.Mod.Debug.setFlag(::Reforged.DebugFlag.onAnySkillExecutedFully, true);
	::Reforged.Mod.Debug.setFlag(::Reforged.DebugFlag.AIAgentFixes, false);
	::include("mod_reforged/hooks/misc.nut");
	::include("mod_reforged/ui/load.nut");
	local requireSettingValue = function ( _setting, _value )
	{
		if (_setting.set(true))
		{
			_setting.lock(this.format("%s(%s)的运行前提", ::Reforged.Name, ::Reforged.ID));
		}
		else
		{
			::MSU.QueueErrors.add(this.format("%s(%s)需要将MSU选项\'%s\'设置为\'%s\'", ::Reforged.Name, ::Reforged.ID, _setting.getID(), _value + ""));
		}
	};
	requireSettingValue(::getModSetting("mod_msu", "ExpandedSkillTooltips"), true);
	requireSettingValue(::getModSetting("mod_msu", "ExpandedItemTooltips"), true);

	foreach( file in ::IO.enumerateFiles("mod_reforged/msu_systems") )
	{
		::include(file);
	}

	::include("mod_reforged/hooks/config/strings.nut");

	foreach( file in ::IO.enumerateFiles("mod_reforged/hooks/config") )
	{
		::include(file);
	}

	foreach( file in ::IO.enumerateFiles("mod_reforged") )
	{
		::include(file);
	}
});
::Reforged.HooksMod.queue(queueLoadOrder, function ()
{
	foreach( func in ::Reforged.QueueBucket.Late )
	{
		func();
	}
}, ::Hooks.QueueBucket.Late);
::Reforged.HooksMod.queue(queueLoadOrder, function ()
{
	foreach( func in ::Reforged.QueueBucket.VeryLate )
	{
		func();
	}
}, ::Hooks.QueueBucket.VeryLate);
::Reforged.HooksMod.queue(queueLoadOrder, function ()
{
	foreach( file in ::IO.enumerateFiles("mod_reforged_AfterHooks") )
	{
		::include(file);
	}

	foreach( func in ::Reforged.QueueBucket.AfterHooks )
	{
		func();
	}

	if (::Hooks.hasMod("mod_dev_console"))
	{
		::Const.AI.ParallelizationMode = true;
	}
}, ::Hooks.QueueBucket.AfterHooks);
::Reforged.HooksMod.queue(queueLoadOrder, function ()
{
	foreach( func in ::Reforged.QueueBucket.FirstWorldInit )
	{
		func();
	}

	delete ::Reforged.QueueBucket;
	delete ::Reforged.InheritHelper;
}, ::Hooks.QueueBucket.FirstWorldInit);
