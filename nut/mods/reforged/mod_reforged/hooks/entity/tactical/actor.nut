::Reforged.HooksMod.hook("scripts/entity/tactical/actor", function ( q )
{
	q.m.IsWaitingTurn <- false;
	q.m.RF_DamageReceived <- null;
	q.m.RF_CanDropLoot <- true;
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.RF_DamageReceived = {
					Total = 0.0
				};
			}

		}.create;
	};
	q.onInit = function ( __original )
	{
		return {
			function onInit()
			{
				__original();
				this.getSkills().add(::new("scripts/skills/effects/rf_inspired_by_champion_effect"));
				this.getSkills().add(::new("scripts/skills/special/rf_reach"));
				this.getSkills().add(::new("scripts/skills/special/rf_formidable_approach_manager"));
				this.getSkills().add(::new("scripts/skills/special/rf_direct_damage_limiter"));
				this.getSkills().add(::new("scripts/skills/special/rf_polearm_adjacency"));
				this.getSkills().add(::new("scripts/skills/special/rf_follow_up_proccer"));
				this.getSkills().add(::new("scripts/skills/special/rf_inspiring_presence_buff_effect"));
				this.getSkills().add(::new("scripts/skills/special/rf_free_dagger_swap"));
				local flags = this.getFlags();

				if (flags.has("亡灵") && !flags.has("ghost") && !flags.has("ghoul") && !flags.has("vampire"))
				{
					this.getSkills().add(::new("scripts/skills/special/rf_undead_injury_receiver"));

					if (flags.has("skeleton"))
					{
						this.m.ExcludedInjuries.extend(::Const.Injury.ExcludedInjuries.get(::Const.Injury.ExcludedInjuries.RF_Skeleton));
					}
					else
					{
						this.m.ExcludedInjuries.extend(::Const.Injury.ExcludedInjuries.get(::Const.Injury.ExcludedInjuries.RF_Undead));
					}
				}
			}

		}.onInit;
	};
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip( _targetedWithSkill = null )
			{
				local ret = __original(_targetedWithSkill);

				if (!this.isPlacedOnMap() || !this.isAlive() || this.isDying())
				{
					return ret;
				}

				if (this.isDiscovered() == false)
				{
					return ret;
				}

				if (this.isHiddenToPlayer())
				{
					return ret;
				}

				foreach( entry in ret )
				{
					if (entry.id == 4)
					{
						local text = entry.text;

						if (this.m.IsActingEachTurn && !this.m.IsTurnDone && this.isWaitActionSpent())
						{
							text = ::Reforged.Mod.Tooltips.parseString(::MSU.String.replace(entry.text, " ", "[再次|Concept.Wait] "));
						}

						entry.text = "<div class = rf_tacticalTooltipWaitContainer>" + "[img]gfx/ui/icons/initiative.png[/img]" + text + "</div>";
						entry.rawHTMLInText <- true;
						delete entry.icon;
						break;
					}
				}

				local isShowingValue = false;

				switch(::Reforged.Mod.ModSettings.getSetting("TacticalTooltip_Values").getValue())
				{
				case "All":
					isShowingValue = true;
					break;

				case "Player Only":
					isShowingValue = ::isKindOf(this, "player");
					break;

				case "AI Only":
					isShowingValue = !::isKindOf(this, "player");
					break;
				}

				for( local index = ret.len() - 1; index >= 0; index-- )
				{
					local entry = ret[index];

					if (isShowingValue)
					{
						if (entry.id == 5 || entry.id == 6 || entry.id == 7 || entry.id == 9)
						{
							entry.text = " " + entry.value + " / " + entry.valueMax;
						}
					}

					if (entry.id == 5)
					{
						ret.insert(index, ::Reforged.TacticalTooltip.getReach(this, 50));
					}

					if (entry.id == 8)
					{
						entry.icon = "ui/icons/action_points.png";
						entry.value = this.getActionPoints();
						entry.valueMax = this.getActionPointsMax();
						entry.text = isShowingValue ? this.getActionPoints() + " / " + this.getActionPointsMax() : ::Const.RF_ActionPointsStateName[this.RF_getActionPointsState()];
						entry.style = "action-points-slim";
					}
					else if (entry.id >= 100)
					{
						ret.remove(index);
					}
				}

				local verifySettingValue = function ( _settingID )
				{
					local value = ::Reforged.Mod.ModSettings.getSetting(_settingID).getValue();
					return value != "None" && (value == "All" || value == "Player Only" && this.isPlayerControlled() || value == "AI Only" && !this.isPlayerControlled());
				};

				if (verifySettingValue("TacticalTooltip_Attributes"))
				{
					ret.append(::Reforged.TacticalTooltip.getTooltipAttributesSmall(this, 100));
				}

				if (verifySettingValue("TacticalTooltip_Effects"))
				{
					ret.extend(::Reforged.TacticalTooltip.getTooltipEffects(this, 200));
				}

				if (verifySettingValue("TacticalTooltip_Perks"))
				{
					ret.extend(::Reforged.TacticalTooltip.getTooltipPerks(this, 300));
				}

				if (verifySettingValue("TacticalTooltip_ActiveSkills"))
				{
					ret.extend(::Reforged.TacticalTooltip.getActiveSkills(this, 400));
				}

				if (verifySettingValue("TacticalTooltip_EquippedItems"))
				{
					ret.extend(::Reforged.TacticalTooltip.getTooltipEquippedItems(this, 500));
				}

				if (verifySettingValue("TacticalTooltip_BagItems"))
				{
					ret.extend(::Reforged.TacticalTooltip.getTooltipBagItems(this, 600));
				}

				ret.extend(::Reforged.TacticalTooltip.getGroundItems(this, 700));
				return ret;
			}

		}.getTooltip;
	};
	q.checkMorale = function ( __original )
	{
		return {
			function checkMorale( _change, _difficulty, _type = ::Const.MoraleCheckType.Default, _showIconBeforeMoraleIcon = "", _noNewLine = false )
			{
				if (_change < 0)
				{
					local p = this.getCurrentProperties();
					p.MoraleCheckBravery[_type] += p.NegativeMoraleCheckBravery[_type];
					p.MoraleCheckBraveryMult[_type] *= p.NegativeMoraleCheckBraveryMult[_type];
				}
				else if (_change > 0)
				{
					local p = this.getCurrentProperties();
					p.MoraleCheckBravery[_type] += p.PositiveMoraleCheckBravery[_type];
					p.MoraleCheckBraveryMult[_type] *= p.PositiveMoraleCheckBraveryMult[_type];
				}

				local ret = __original(_change, _difficulty, _type, _showIconBeforeMoraleIcon, _noNewLine);
				this.m.Skills.update();
				return ret;
			}

		}.checkMorale;
	};
	q.onRoundStart = function ( __original )
	{
		return {
			function onRoundStart()
			{
				this.m.IsWaitingTurn = false;
				__original();
			}

		}.onRoundStart;
	};
	q.playIdleSound = function ( __original )
	{
		return {
			function playIdleSound()
			{
				if (this.isDiscovered())
				{
					__original();
				}
			}

		}.playIdleSound;
	};
	q.getSurroundedCount = function ( __original )
	{
		return {
			function getSurroundedCount()
			{
				local startSurroundCountAt = this.m.CurrentProperties.StartSurroundCountAt;
				this.m.CurrentProperties.StartSurroundCountAt = -1;
				local count = __original();
				this.m.CurrentProperties.StartSurroundCountAt = startSurroundCountAt;
				local myTile = this.getTile();

				foreach( enemy in ::Tactical.Entities.getHostileActors(this.getFaction(), myTile, 2, true) )
				{
					if (!enemy.hasZoneOfControl() || enemy.isNonCombatant() || !enemy.getTile().hasLineOfSightTo(myTile, enemy.getCurrentProperties().getVision()))
					{
						continue;
					}

					local perk = enemy.getSkills().getSkillByID("perk.rf_long_reach");

					if (perk == null || !perk.isEnabled())
					{
						continue;
					}

					foreach( skill in enemy.getSkills().getAllSkillsOfType(::Const.SkillType.Active) )
					{
						if (perk.isSkillValid(skill) && skill.verifyTargetAndRange(myTile, enemy.getTile()))
						{
							count++;
							break;
						}
					}
				}

				return ::Math.max(0, count - 1 - startSurroundCountAt);
			}

		}.getSurroundedCount;
	};
	q.isTurnDone = function ( __original )
	{
		return {
			function isTurnDone()
			{
				if (::Tactical.getNavigator().isTravelling(this))
				{
					return false;
				}

				return __original() || this.m.IsWaitingTurn;
			}

		}.isTurnDone;
	};
	q.onDiscovered = function ( __original )
	{
		return {
			function onDiscovered()
			{
				__original();

				if (!this.isPlayerControlled() && !this.isAlliedWithPlayer())
				{
					::Tactical.State.RF_playActualTrackList();
					::Tactical.State.m.TacticalScreen.m.TopbarRoundInformation.update();
				}
			}

		}.onDiscovered;
	};
	q.onOtherActorDeath = function ()
	{
		return {
			function onOtherActorDeath( _killer, _victim, _skill )
			{
				if (!this.m.IsAlive || this.m.IsDying || _victim.getXPValue() <= 1)
				{
					return;
				}

				local xpRatioMult = _victim.getXPValue() / ::Math.maxf(1, this.getXPValue());

				if (_victim.getFaction() == this.getFaction() && _victim.getCurrentProperties().TargetAttractionMult >= 0.5 && this.getCurrentProperties().IsAffectedByDyingAllies)
				{
					local difficulty = ::Const.Morale.AllyKilledBaseDifficulty - _victim.getXPValue() * ::Const.Morale.AllyKilledXPMult * xpRatioMult + ::Math.pow(_victim.getTile().getDistanceTo(this.getTile()), ::Const.Morale.AllyKilledDistancePow);
					this.checkMorale(-1, difficulty, ::Const.MoraleCheckType.Default, "", true);
				}
				else if (this.getAlliedFactions().find(_victim.getFaction()) == null && (_killer == null || this.getAlliedFactions().find(_killer.getFaction()) != null))
				{
					local difficulty = ::Const.Morale.EnemyKilledBaseDifficulty + _victim.getXPValue() * ::Const.Morale.EnemyKilledXPMult * xpRatioMult - ::Math.pow(_victim.getTile().getDistanceTo(this.getTile()), ::Const.Morale.EnemyKilledDistancePow);

					if (_killer != null && _killer.isAlive() && _killer.getID() == this.getID())
					{
						difficulty = difficulty + ::Const.Morale.EnemyKilledSelfBonus;
					}

					this.checkMorale(1, difficulty);
				}
			}

		}.onOtherActorDeath;
	};
	q.onOtherActorFleeing = function ()
	{
		return {
			function onOtherActorFleeing( _actor )
			{
				if (!this.m.IsAlive || this.m.IsDying || !this.m.CurrentProperties.IsAffectedByFleeingAllies)
				{
					return;
				}

				local xpRatioMult = _actor.getXPValue() / ::Math.maxf(1, this.getXPValue());
				local difficulty = ::Const.Morale.AllyFleeingBaseDifficulty - _actor.getXPValue() * ::Const.Morale.AllyFleeingXPMult * xpRatioMult + ::Math.pow(_actor.getTile().getDistanceTo(this.getTile()), ::Const.Morale.AllyFleeingDistancePow);

				foreach( i, faction in ::Tactical.Entities.getAllInstances() )
				{
					if (this.isAlliedWith(i))
					{
						difficulty = difficulty + faction.filter(function ( _, _a )
						{
							return _a.getMoraleState() != ::Const.MoraleState.Fleeing;
						}).len() * ::Const.Morale.RF_AllyFleeingBraveryModifierPerAlly;
					}
				}

				difficulty = difficulty - ::Const.Morale.RF_AllyFleeingBraveryModifierPerAlly;
				this.checkMorale(-1, difficulty);
			}

		}.onOtherActorFleeing;
	};
	q.MV_selectInjury = function ()
	{
		return {
			function MV_selectInjury( _skill, _hitInfo )
			{
				local headshotBonus = _hitInfo.BodyPart == ::Const.BodyPart.Head ? ::Const.Combat.MV_HeadshotInjuryThresholdMult : 1.0;
				local mult = _hitInfo.InjuryThresholdMult * ::Const.Combat.InjuryThresholdMult * this.getCurrentProperties().ThresholdToReceiveInjuryMult * headshotBonus;
				local damageInflictedThreshold = _hitInfo.DamageInflictedHitpoints.tofloat() / this.getHitpointsMax();
				local actor = this;
				local injuries = _hitInfo.Injuries.filter(function ( _, _inj )
				{
					return _inj.Threshold * mult <= damageInflictedThreshold && actor.m.ExcludedInjuries.find(_inj.ID) == null && !actor.getSkills().hasSkill(_inj.ID);
				}).map(function ( _inj )
				{
					return [
						_inj.Threshold * mult,
						::new("scripts/skills/" + _inj.Script)
					];
				}).filter(function ( _, _inj )
				{
					return _inj[1].isValid(actor);
				});

				if (injuries.len() == 0)
				{
					return null;
				}

				local potentialInjuries = ::MSU.Class.WeightedContainer();

				foreach( inj in injuries )
				{
					potentialInjuries.add(inj, ::Math.pow(inj[0] / damageInflictedThreshold, 4 * damageInflictedThreshold));
				}

				return potentialInjuries.roll()[1];
			}

		}.MV_selectInjury;
	};
	q.getSurroundedBonus <- {
		function getSurroundedBonus( _targetEntity )
		{
			local surroundedCount = _targetEntity.getSurroundedCount();
			local surroundBonus = surroundedCount * this.getCurrentProperties().SurroundedBonus * this.getCurrentProperties().SurroundedBonusMult;
			surroundBonus = surroundBonus - surroundedCount * _targetEntity.getCurrentProperties().SurroundedDefense;
			return surroundBonus;
		}

	}.getSurroundedBonus;
	q.setWaitTurn <- {
		function setWaitTurn( _bool )
		{
			this.m.IsWaitingTurn = _bool;
		}

	}.setWaitTurn;
	q.RF_getActionPointsState <- {
		function RF_getActionPointsState()
		{
			return ::Math.min(::Const.RF_ActionPointsStateName.len() - 1, ::Math.max(0, ::Math.floor(this.getActionPoints() / (this.getActionPointsMax() * 1.0) * (::Const.RF_ActionPointsStateName.len() - 1))));
		}

	}.RF_getActionPointsState;
	q.RF_canDropLootForPlayer <- {
		function RF_canDropLootForPlayer( _killer )
		{
			if (this.getFaction() == ::Const.Faction.Player || ::isKindOf(this, "player"))
			{
				return true;
			}

			if (this.isAlliedWithPlayer())
			{
				return false;
			}

			local playerRelevantDamage = 0.0;

			if (::Const.Faction.Player in this.m.RF_DamageReceived)
			{
				playerRelevantDamage = playerRelevantDamage + this.m.RF_DamageReceived[::Const.Faction.Player].Total;
			}

			if (::Const.Faction.PlayerAnimals in this.m.RF_DamageReceived)
			{
				playerRelevantDamage = playerRelevantDamage + this.m.RF_DamageReceived[::Const.Faction.PlayerAnimals].Total;
			}

			return playerRelevantDamage / this.m.RF_DamageReceived.Total >= 0.5;
		}

	}.RF_canDropLootForPlayer;
	q.RF_getZOCEvasionFatigue <- {
		function RF_getZOCEvasionFatigue()
		{
			if (this.getMoraleState() == ::Const.MoraleState.Fleeing)
			{
				return 0;
			}

			if (this.getCurrentProperties().IsImmuneToZoneOfControl || !this.getTile().hasZoneOfControlOtherThan(this.getAlliedFactions()) || this.getTile().Properties.Effect != null && this.getTile().Properties.Effect.Type == "smoke")
			{
				return 0;
			}

			return this.getTile().getZoneOfControlCountOtherThan(this.getAlliedFactions()) * ::Math.round(::Const.Combat.FatigueLossOnBeingMissed * this.getCurrentProperties().FatigueEffectMult * this.getCurrentProperties().FatigueLossOnAnyAttackMult);
		}

	}.RF_getZOCEvasionFatigue;
});
::Reforged.HooksMod.hookTree("scripts/entity/tactical/actor", function ( q )
{
	q.onActorKilled = function ( __original )
	{
		return {
			function onActorKilled( _actor, _tile, _skill )
			{
				local wasOverriding = ::Reforged.Config.XPOverride;
				::Reforged.Config.XPOverride = true;
				__original(_actor, _tile, _skill);
				::Reforged.Config.XPOverride = wasOverriding;
			}

		}.onActorKilled;
	};
	q.onDeath = function ( __original )
	{
		return {
			function onDeath( _killer, _skill, _tile, _fatalityType )
			{
				local playerRelevantDamage = 0.0;
				local bros = ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player);

				if (::Const.Faction.Player in this.m.RF_DamageReceived)
				{
					playerRelevantDamage = playerRelevantDamage + this.m.RF_DamageReceived[::Const.Faction.Player].Total;
					local XPavailable = this.getXPValue() * this.m.RF_DamageReceived[::Const.Faction.Player].Total / this.m.RF_DamageReceived.Total;
					local XPkiller = XPavailable * ::Const.XP.XPForKillerPct;
					local XPgroup = ::Math.max(1, ::Math.floor((XPavailable - XPkiller) / bros.len()));
					local brosDamage = this.m.RF_DamageReceived[::Const.Faction.Player];

					foreach( bro in bros )
					{
						if (bro.getID() in brosDamage)
						{
							bro.addXP(::Math.max(1, ::Math.round(XPkiller * brosDamage[bro.getID()] / brosDamage.Total)));
						}

						if (!bro.getCurrentProperties().IsAllyXPBlocked)
						{
							bro.addXP(XPgroup);
						}
					}
				}

				if (::Const.Faction.PlayerAnimals in this.m.RF_DamageReceived)
				{
					playerRelevantDamage = playerRelevantDamage + this.m.RF_DamageReceived[::Const.Faction.PlayerAnimals].Total;
					local XPgroup = this.getXPValue() * this.m.RF_DamageReceived[::Const.Faction.PlayerAnimals].Total / this.m.RF_DamageReceived.Total * (1.0 - ::Const.XP.XPForKillerPct);
					XPgroup = ::Math.max(1, ::Math.floor(XPgroup / bros.len()));

					foreach( bro in bros )
					{
						if (!bro.getCurrentProperties().IsAllyXPBlocked)
						{
							bro.addXP(XPgroup);
						}
					}
				}

				__original(_killer, _skill, _tile, _fatalityType);
			}

		}.onDeath;
	};
});
::Reforged.QueueBucket.Late.push(function ()
{
	::Reforged.HooksMod.hook("scripts/entity/tactical/actor", function ( q )
	{
		q.getFatigueMax = function ( __original )
		{
			return {
				function getFatigueMax()
				{
					if (this.getFlags().has("亡灵") && this.getCurrentProperties().FatigueEffectMult == 0)
					{
						local original_CurrentProperties = this.m.CurrentProperties;
						this.m.CurrentProperties = this.getBaseProperties();
						local ret = __original();
						this.m.CurrentProperties = original_CurrentProperties;
						return ret;
					}

					return __original();
				}

			}.getFatigueMax;
		};
	});
	::Reforged.HooksMod.hookTree("scripts/entity/tactical/actor", function ( q )
	{
		q.getLootForTile = function ( __original )
		{
			return {
				function getLootForTile( _killer, _loot )
				{
					if (this.RF_canDropLootForPlayer(_killer))
					{
						return __original(null, _loot);
					}

					if (_killer == null)
					{
						_killer = ::MSU.getDummyPlayer();
					}

					local killerTable = (_killer instanceof ::WeakTableRef) ? _killer.get() : _killer;
					local getFaction = killerTable.getFaction;
					killerTable.getFaction = function ()
					{
						return ::Const.Faction.None;
					};
					local ret = __original(_killer, _loot);
					killerTable.getFaction = getFaction;
					return ret;
				}

			}.getLootForTile;
		};
	});
});
