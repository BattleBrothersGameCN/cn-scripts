::Reforged.HooksMod.hook("scripts/ui/screens/tooltip/tooltip_events", function ( q )
{
	q.tactical_queryTileTooltipData = function ( __original )
	{
		return {
			function tactical_queryTileTooltipData()
			{
				local ret = __original();

				if (ret != null && ::Tactical.State.getLastTileHovered().IsEmpty && ::Tactical.State.getCurrentActionState() == ::Const.Tactical.ActionState.ComputePath)
				{
					ret.extend(this.RF_getHitchancesForMovementPreview(::Tactical.TurnSequenceBar.getActiveEntity()));
				}

				return ret;
			}

		}.tactical_queryTileTooltipData;
	};
	q.general_queryUIElementTooltipData = function ( __original )
	{
		return {
			function general_queryUIElementTooltipData( _entityId, _elementId, _elementOwner )
			{
				switch(_elementId)
				{
				case "character-screen.left-panel-header-module.Experience":
					return [
						{
							id = 1,
							type = "title",
							text = "经验值"
						},
						{
							id = 2,
							type = "description",
							text = ::Reforged.Mod.Tooltips.parseString("角色能在战斗中获得经验。如果角色积累了足够经验，他的[等级|Concept.Level]就会得到提高。\n\n敌人死亡会产生经验，无论其死因，只要你的战团对其造成过一些伤害, 战团的角色就能获得经验。每名角色从一名敌人死亡中获得的经验和对其造成的伤害占整个战团的份额成正比。这些经验中，" + ::Const.XP.XPForKillerPct * 100 + "%按伤害份额分给造成伤害的兄弟。其余的" + (100 - ::Const.XP.XPForKillerPct * 100) + "%则会平均分给战团中的所有成员。")
						}
					];

				case "character-screen.left-panel-header-module.Level":
					local veteranPerksText = ::Reforged.Config.VeteranPerksLevelStep == 0 ? "不会再获得特技点数" : this.format("每升%s", ::Reforged.Config.VeteranPerksLevelStep == 1 ? "级仍能" : ::Reforged.Config.VeteranPerksLevelStep + "级才能获得一个特技点数");
					return [
						{
							id = 1,
							type = "title",
							text = "等级"
						},
						{
							id = 2,
							type = "description",
							text = ::Reforged.Mod.Tooltips.parseString("一名角色的等级衡量了他的战斗[经验|Concept.Experience]。随着经验提升，角色的等级也会提高，并能提高[属性|Concept.CharacterAttribute]，获得[特技|Concept.Perk]，更好地从事佣兵事业。\n\n在升到" + ::Const.XP.MaxLevelWithPerkpoints + "级之后，角色将成为老兵，" + veteranPerksText + "。他们仍可获得属性提高，但提高十分有限。")
						}
					];
				}

				local ret = __original(_entityId, _elementId, _elementOwner);

				if (ret != null)
				{
					switch(_elementId)
					{
					case "character-stats.Bravery":
						foreach( entry in ret )
						{
							if (entry.id == 2 && entry.type == "description")
							{
								entry.text = ::String.replace(entry.text, "另见：士气。", ::Reforged.Mod.Tooltips.parseString("另见： [士气|Concept.Morale]。"));
								break;
							}
						}

						break;

					case "character-stats.MeleeDefense":
					case "character-stats.RangeDefense":
						if (::Const.Tactical.Settings.AttributeDefenseSoftCap != 0)
						{
							foreach( entry in ret )
							{
								if (entry.id == 2 && entry.type == "description")
								{
									entry.text += ::Reforged.Mod.Tooltips.parseString(" Each point of [current|Concept.CurrentAttribute] defense above " + ::Const.Tactical.Settings.AttributeDefenseSoftCap + " counts as half a point.");
									break;
								}
							}
						}

						break;
					}

					ret.extend(this.getBaseAttributesTooltip(_entityId, _elementId, _elementOwner));
				}

				return ret;
			}

		}.general_queryUIElementTooltipData;
	};
	q.RF_getHitchancesForMovementPreview <- {
		function RF_getHitchancesForMovementPreview( _entity )
		{
			if (_entity == null || !_entity.isPlacedOnMap())
			{
				return [];
			}

			local ret = [];

			if (!_entity.getCurrentProperties().IsImmuneToZoneOfControl && (_entity.getTile().Properties.Effect == null || _entity.getTile().Properties.Effect.Type != "smoke"))
			{
				local attacks = ::Tactical.Entities.getAdjacentActors(_entity.getTile()).filter(function ( _, _a )
				{
					return !_a.isAlliedWith(_entity) && _a.onMovementInZoneOfControl(_entity, false);
				}).map(function ( _a )
				{
					local aoo = _a.getSkills().getAttackOfOpportunity();
					return {
						id = 100,
						type = "text",
						icon = ::Reforged.Mod.Tooltips.parseString(::Reforged.NestedTooltips.getNestedEntityImage(_a)),
						text = ::MSU.Text.colorNegative(aoo.getHitchance(_entity) + "%") + "命中率，使用" + ::Reforged.Mod.Tooltips.parseString(::Reforged.NestedTooltips.getNestedSkillName(aoo, "entityId:" + _a.getID()))
					};
				});

				if (attacks.len() != 0)
				{
					ret.push({
						id = 100,
						type = "text",
						icon = "ui/icons/warning.png",
						text = ::Reforged.Mod.Tooltips.parseString("移动时会被以下角色[借机攻击|Concept.ZoneOfControl]："),
						children = attacks
					});
					local fatigueToDodgeAOO = _entity.RF_getZOCEvasionFatigue();

					if (fatigueToDodgeAOO != 0)
					{
						ret.push({
							id = 100,
							type = "text",
							icon = "ui/icons/fatigue.png",
							text = ::Reforged.Mod.Tooltips.parseString("躲过这些攻击共积累" + ::MSU.Text.colorizeValue(fatigueToDodgeAOO, {
								InvertColor = true
							}) + "点[疲劳值|Concept.Fatigue]")
						});
					}
				}
			}

			if (_entity.getPreviewMovement() != null)
			{
				ret.extend(_entity.getSkills().MV_runBetweenPreviewUpdates(this.RF_getHitchancesAtDestination, this, this.RF_applyMovementPreview(_entity), this.RF_cleanupMovementPreview));
			}

			return ret;
		}

	}.RF_getHitchancesForMovementPreview;
	q.RF_applyMovementPreview <- {
		function RF_applyMovementPreview( _entity )
		{
			local currTile = _entity.getTile();
			local destTile = ::Tactical.State.getLastTileHovered();
			local original_getTile = _entity.getTile;
			_entity.getTile = function ()
			{
				return destTile;
			};
			destTile.Properties.set("RF_PreviewEntity", _entity);

			if (_entity.hasZoneOfControl())
			{
				local f = _entity.getFaction();
				destTile.Properties.set("RF_PreviewZOCFaction", f);

				foreach( t in ::MSU.Tile.getNeighbors(destTile) )
				{
					t.Properties.set("RF_PreviewZOCFaction", f);
				}
			}

			local currTerrainEffect;
			local currTerrainEffectIdx;

			if (::Const.Tactical.TerrainEffect[currTile.Type].len() > 0)
			{
				local id = ::Const.Tactical.TerrainEffectID[currTile.Type];

				foreach( i, s in _entity.getSkills().m.Skills )
				{
					if (s.getID() == id)
					{
						currTerrainEffectIdx = i;
						currTerrainEffect = _entity.getSkills().m.Skills.remove(i);
						break;
					}
				}
			}

			local destTerrainEffect;

			if (::Const.Tactical.TerrainEffect[destTile.Type].len() > 0 && !_entity.getSkills().hasSkill(::Const.Tactical.TerrainEffectID[destTile.Type]))
			{
				destTerrainEffect = ::new(::Const.Tactical.TerrainEffect[destTile.Type]);
				destTerrainEffect.saveBaseValues();
				_entity.getSkills().m.Skills.push(destTerrainEffect);
			}

			return {
				Entity = _entity,
				original_getTile = original_getTile,
				DestTile = destTile,
				DestTerrainEffect = destTerrainEffect,
				CurrTerrainEffect = currTerrainEffect,
				CurrTerrainEffectIdx = currTerrainEffectIdx,
				ActorsToUpdate = []
			};
		}

	}.RF_applyMovementPreview;
	q.RF_cleanupMovementPreview <- {
		function RF_cleanupMovementPreview( _tag )
		{
			local entity = _tag.Entity;
			entity.getTile = _tag.original_getTile;
			local destTile = _tag.DestTile;
			destTile.Properties.remove("RF_PreviewEntity");
			destTile.Properties.remove("RF_PreviewZOCFaction");

			foreach( t in ::MSU.Tile.getNeighbors(destTile) )
			{
				t.Properties.remove("RF_PreviewZOCFaction");
			}

			local destTerrainEffect = _tag.DestTerrainEffect;

			if (destTerrainEffect != null)
			{
				local skills = entity.getSkills().m.Skills;

				for( local i = skills.len() - 1; i >= 0; i-- )
				{
					if (skills[i] == destTerrainEffect)
					{
						skills.remove(i);
						break;
					}
				}
			}

			if (_tag.CurrTerrainEffect != null)
			{
				entity.getSkills().m.Skills.insert(_tag.CurrTerrainEffectIdx, _tag.CurrTerrainEffect);
			}

			foreach( a in _tag.ActorsToUpdate )
			{
				a.getSkills().update();
			}
		}

	}.RF_cleanupMovementPreview;
	q.RF_getHitchancesAtDestination <- {
		function RF_getHitchancesAtDestination( _tag, _cleanupFunc )
		{
			local ret = [];
			local entity = _tag.Entity;
			local destTile = _tag.DestTile;

			if (!entity.getCurrentProperties().IsImmuneToZoneOfControl && (destTile.Properties.Effect == null || destTile.Properties.Effect.Type != "smoke"))
			{
				local spearwallAttacks = ::Tactical.Entities.getAdjacentActors(entity.getPreviewMovement().End).filter(function ( _, _a )
				{
					return !_a.isAlliedWith(entity) && _a.onMovementInZoneOfControl(entity, true);
				}).map(function ( _a )
				{
					local aoo = _a.getSkills().getAttackOfOpportunity();
					_a.getSkills().update();
					_tag.ActorsToUpdate.push(_a);
					return {
						id = 100,
						type = "text",
						icon = ::Reforged.Mod.Tooltips.parseString(::Reforged.NestedTooltips.getNestedEntityImage(_a)),
						text = ::MSU.Text.colorNegative(aoo.getHitchance(entity) + "%") + "命中率，使用" + ::Reforged.Mod.Tooltips.parseString(::Reforged.NestedTooltips.getNestedSkillName(aoo, "entityId:" + _a.getID()))
					};
				});

				if (spearwallAttacks.len() != 0)
				{
					ret.push({
						id = 101,
						type = "text",
						icon = "ui/icons/warning.png",
						text = ::MSU.Text.colorNegative("移动到此会被以下角色攻击："),
						children = spearwallAttacks
					});
				}
			}

			local showPlayer = true;
			local showEnemy = true;

			switch(::Reforged.Mod.ModSettings.getSetting("TacticalTooltip_MovementPreviewHitchances").getValue())
			{
			case "None":
				showPlayer = false;
				showEnemy = false;
				break;

			case "Player Only":
				showEnemy = false;
				break;

			case "AI Only":
				showPlayer = false;
				break;
			}

			if (showPlayer || showEnemy)
			{
				local myAttacks = entity.getSkills().getAllSkillsOfType(::Const.SkillType.Active).filter(function ( _, _a )
				{
					return _a.isAttack();
				});
				local myVision = entity.getCurrentProperties().getVision();
				local extraData = "entityId: " + entity.getID();
				local attacks = [];
				local collapseThreshold = ::Reforged.Mod.ModSettings.getSetting("TacticalTooltip_CollapseHitchanceThreshold").getValue();
				local attacksBelowThreshold = "";

				foreach( enemy in ::Tactical.Entities.getAllInstancesAsArray().filter(function ( _, _a )
				{
					return !_a.isAlliedWith(entity) && !_a.isHiddenToPlayer();
				}) )
				{
					local text = "";
					local score = 0;

					if (showPlayer)
					{
						foreach( a in myAttacks )
						{
							if (a.isUsable() && a.isInRange(enemy.getTile()) && (!a.isVisibleTileNeeded() || destTile.hasLineOfSightTo(enemy.getTile(), myVision)))
							{
								local hitChance = a.getHitchance(entity);
								score = 999 + hitChance;
								text = this.format("%s使用%s", ::MSU.Text.colorPositive(a.getHitchance(enemy) + "%"), ::Reforged.NestedTooltips.getNestedSkillName(a, extraData));
								break;
							}
						}
					}

					if (showEnemy)
					{
						foreach( enemyAttack in enemy.getSkills().getAllSkillsOfType(::Const.SkillType.Active).filter(function ( _, _a )
						{
							return _a.isAttack();
						}) )
						{
							if (enemyAttack.isUsable() && enemyAttack.isInRange(destTile) && (!enemyAttack.isVisibleTileNeeded() || enemy.getTile().hasLineOfSightTo(destTile, enemy.getCurrentProperties().getVision())))
							{
								if (_tag.ActorsToUpdate.find(enemy) == null)
								{
									enemy.getSkills().update();
									_tag.ActorsToUpdate.push(enemy);
								}

								local hitChance = enemyAttack.getHitchance(entity);

								if (score == 0 && hitChance <= collapseThreshold)
								{
									attacksBelowThreshold = attacksBelowThreshold + ::Reforged.NestedTooltips.getNestedEntityImage(enemy);
								}
								else
								{
									score = score + hitChance;
									text = text + (text == "" ? "" : ", ");
									text = text + this.format("%s使用%s", ::MSU.Text.colorNegative(hitChance + "%"), ::Reforged.NestedTooltips.getNestedSkillName(enemyAttack, "entityId: " + enemy.getID()));
								}

								break;
							}
						}
					}

					if (text == "")
					{
						continue;
					}

					attacks.push([
						score,
						{
							id = 100,
							type = "text",
							icon = ::Reforged.Mod.Tooltips.parseString(::Reforged.NestedTooltips.getNestedEntityImage(enemy)),
							text = ::Reforged.Mod.Tooltips.parseString(text)
						}
					]);
				}

				if (attacks.len() != 0)
				{
					ret.push({
						id = 100,
						type = "text",
						icon = "ui/icons/icon_contract_swords.png",
						text = this.format("%s和%s几率：", ::MSU.Text.colorPositive("命中"), ::MSU.Text.colorNegative("被命中"))
					});
					attacks.sort(function ( _a, _b )
					{
						return -1 * (_a[0]  _b[0]);
					});
					ret.extend(attacks.map(function ( _a )
					{
						return _a[1];
					}));
				}

				if (attacksBelowThreshold != "")
				{
					ret.push({
						id = 100,
						type = "text",
						icon = "ui/icons/icon_contract_swords.png",
						text = "命中率低于" + ::MSU.Text.colorNegative(collapseThreshold + "%"),
						children = [
							{
								id = 100,
								type = "text",
								text = ::Reforged.Mod.Tooltips.parseString(attacksBelowThreshold)
							}
						]
					});
				}
			}

			_cleanupFunc(_tag);
			return ret;
		}

	}.RF_getHitchancesAtDestination;
	q.getBaseAttributesTooltip <- {
		function getBaseAttributesTooltip( _entityId, _elementId, _elementOwner )
		{
			local entity = _entityId == null ? null : ::Tactical.getEntityByID(_entityId);

			if (entity == null || entity == ::MSU.getDummyPlayer())
			{
				return [];
			}

			local baseValue;
			local currentValue;
			local icon;
			local extra;

			switch(_elementId)
			{
			case "character-stats.MeleeSkill":
				baseValue = entity.getBaseProperties().getMeleeSkill();
				currentValue = entity.getCurrentProperties().getMeleeSkill();
				icon = "/ui/icons/melee_skill.png";
				break;

			case "character-stats.RangeSkill":
				baseValue = entity.getBaseProperties().getRangedSkill();
				currentValue = entity.getCurrentProperties().getRangedSkill();
				icon = "/ui/icons/ranged_skill.png";
				break;

			case "character-stats.MeleeDefense":
				baseValue = entity.getBaseProperties().getMeleeDefense();
				currentValue = entity.getCurrentProperties().getMeleeDefense();
				icon = "/ui/icons/melee_defense.png";
				break;

			case "character-stats.RangeDefense":
				baseValue = entity.getBaseProperties().getRangedDefense();
				currentValue = entity.getCurrentProperties().getRangedDefense();
				icon = "/ui/icons/ranged_defense.png";
				break;

			case "character-stats.Bravery":
				baseValue = entity.getBaseProperties().getBravery();
				currentValue = entity.getCurrentProperties().getBravery();
				icon = "/ui/icons/bravery.png";
				break;

			case "character-stats.Initiative":
				baseValue = entity.getBaseProperties().getInitiative();
				currentValue = entity.getInitiative();
				icon = "/ui/icons/initiative.png";
				break;

			case "character-stats.Hitpoints":
				local c = entity.getCurrentProperties();
				entity.m.CurrentProperties = entity.getBaseProperties();
				baseValue = entity.getHitpointsMax();
				entity.m.CurrentProperties = c;
				currentValue = entity.getHitpointsMax();
				icon = "ui/icons/health.png";
				break;

			case "character-stats.Fatigue":
				local c = entity.getCurrentProperties();
				entity.m.CurrentProperties = entity.getBaseProperties();
				baseValue = entity.getFatigueMax();
				entity.m.CurrentProperties = c;
				currentValue = entity.getFatigueMax();
				icon = "ui/icons/fatigue.png";
				extra = [
					{
						id = 5,
						type = "text",
						icon = icon,
						text = "疲劳值恢复：" + ::MSU.Text.colorizeValue(c.getFatigueRecoveryRate(), {
							AddSign = true
						})
					},
					{
						id = 6,
						type = "text",
						icon = "ui/icons/bag.png",
						text = "物品重量：" + ::MSU.Text.colorNegative(::Math.abs(-1 * entity.getItems().getStaminaModifier()))
					}
				];
				break;

			case "Concept.Reach":
				baseValue = entity.getBaseProperties().getReach();
				currentValue = entity.getCurrentProperties().getReach();
				icon = "ui/icons/rf_reach.png";
				extra = [
					{
						id = 5,
						type = "text",
						icon = "ui/icons/rf_reach_attack.png",
						text = ::Reforged.Mod.Tooltips.parseString("[攻击时无视|Concept.ReachIgnoreOffensive]：") + ::MSU.Text.colorizeValue(entity.getCurrentProperties().OffensiveReachIgnore)
					},
					{
						id = 6,
						type = "text",
						icon = "ui/icons/rf_reach_defense.png",
						text = ::Reforged.Mod.Tooltips.parseString("[防御时无视|Concept.ReachIgnoreDefensive]：") + ::MSU.Text.colorizeValue(entity.getCurrentProperties().DefensiveReachIgnore)
					}
				];
				break;
			}

			if (baseValue == null)
			{
				return [];
			}

			local ret = [
				{
					id = 3,
					type = "text",
					icon = icon,
					text = "基础值：" + ::MSU.Text.colorizeValue(baseValue, {
						AddSign = baseValue < 0
					})
				},
				{
					id = 4,
					type = "text",
					icon = icon,
					text = "调整值：" + ::MSU.Text.colorizeValue(currentValue - baseValue, {
						AddSign = true
					})
				}
			];

			if (extra != null)
			{
				ret.extend(extra);
			}

			return ret;
		}

	}.getBaseAttributesTooltip;
});
