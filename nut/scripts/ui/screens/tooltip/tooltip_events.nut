this.tooltip_events <- {
	m = {},
	function create()
	{
	}

	function destroy()
	{
	}

	function onQueryTileTooltipData()
	{
		if (this.Tactical.isActive())
		{
			return this.TooltipEvents.tactical_queryTileTooltipData();
		}
		else
		{
			return this.TooltipEvents.strategic_queryTileTooltipData();
		}
	}

	function onQueryEntityTooltipData( _entityId, _isTileEntity )
	{
		if (this.Tactical.isActive())
		{
			return this.TooltipEvents.tactical_queryEntityTooltipData(_entityId, _isTileEntity);
		}
		else
		{
			return this.TooltipEvents.strategic_queryEntityTooltipData(_entityId, _isTileEntity);
		}
	}

	function onQueryRosterEntityTooltipData( _entityId )
	{
		local entity = this.Tactical.getEntityByID(_entityId);

		if (entity != null)
		{
			return entity.getRosterTooltip();
		}

		return null;
	}

	function onQuerySkillTooltipData( _entityId, _skillId )
	{
		return this.TooltipEvents.general_querySkillTooltipData(_entityId, _skillId);
	}

	function onQueryStatusEffectTooltipData( _entityId, _statusEffectId )
	{
		return this.TooltipEvents.general_queryStatusEffectTooltipData(_entityId, _statusEffectId);
	}

	function onQuerySettlementStatusEffectTooltipData( _statusEffectId )
	{
		return this.TooltipEvents.general_querySettlementStatusEffectTooltipData(_statusEffectId);
	}

	function onQueryUIItemTooltipData( _entityId, _itemId, _itemOwner )
	{
		if (this.Tactical.isActive())
		{
			return this.TooltipEvents.tactical_queryUIItemTooltipData(_entityId, _itemId, _itemOwner);
		}
		else
		{
			return this.TooltipEvents.strategic_queryUIItemTooltipData(_entityId, _itemId, _itemOwner);
		}
	}

	function onQueryUIPerkTooltipData( _entityId, _perkId )
	{
		return this.TooltipEvents.general_queryUIPerkTooltipData(_entityId, _perkId);
	}

	function onQueryUIElementTooltipData( _entityId, _elementId, _elementOwner )
	{
		return this.TooltipEvents.general_queryUIElementTooltipData(_entityId, _elementId, _elementOwner);
	}

	function onQueryFollowerTooltipData( _followerID )
	{
		if (typeof _followerID == "integer")
		{
			local renown = "\'" + this.Const.Strings.BusinessReputation[this.Const.FollowerSlotRequirements[_followerID]] + "\' (" + this.Const.BusinessReputation[this.Const.FollowerSlotRequirements[_followerID]] + ")";
			local ret = [
				{
					id = 1,
					type = "title",
					text = "锁定的席位"
				},
				{
					id = 4,
					type = "description",
					text = "你战团的名望不够，无法雇佣更多的非战斗随从。解锁该席位至少还需要" + renown + "点名望。名望可以通过达成野心、完成合同以及赢得战斗获得。"
				}
			];
			return ret;
		}
		else if (_followerID == "free")
		{
			local ret = [
				{
					id = 1,
					type = "title",
					text = "空闲席位"
				},
				{
					id = 4,
					type = "description",
					text = "一个空闲席位，用于招募其他非战斗追随者。"
				},
				{
					id = 1,
					type = "hint",
					icon = "ui/icons/mouse_left_button.png",
					text = "打开雇佣界面"
				}
			];
			return ret;
		}
		else
		{
			local p = this.World.Retinue.getFollower(_followerID);
			return p.getTooltip();
		}
	}

	function tactical_queryTileTooltipData()
	{
		local lastTileHovered = this.Tactical.State.getLastTileHovered();

		if (lastTileHovered == null)
		{
			return null;
		}

		if (!lastTileHovered.IsDiscovered)
		{
			return null;
		}

		if (lastTileHovered.IsDiscovered && !lastTileHovered.IsEmpty && (!lastTileHovered.IsOccupiedByActor || lastTileHovered.IsVisibleForPlayer))
		{
			local entity = lastTileHovered.getEntity();
			return this.tactical_helper_getEntityTooltip(entity, this.Tactical.TurnSequenceBar.getActiveEntity(), true);
		}
		else
		{
			local tooltipContent = [
				{
					id = 1,
					type = "title",
					text = this.Const.Strings.Tactical.TerrainName[lastTileHovered.Subtype],
					icon = "ui/tooltips/height_" + lastTileHovered.Level + ".png"
				}
			];
			tooltipContent.push({
				id = 2,
				type = "description",
				text = this.Const.Strings.Tactical.TerrainDescription[lastTileHovered.Subtype]
			});

			if (lastTileHovered.IsCorpseSpawned)
			{
				tooltipContent.push({
					id = 3,
					type = "description",
					text = lastTileHovered.Properties.get("Corpse").CorpseName + "在这里被杀。"
				});
			}

			if (this.Tactical.TurnSequenceBar.getActiveEntity() != null)
			{
				local actor = this.Tactical.TurnSequenceBar.getActiveEntity();

				if (actor.isPlacedOnMap() && actor.isPlayerControlled())
				{
					if (this.Math.abs(lastTileHovered.Level - actor.getTile().Level) == 1)
					{
						tooltipContent.push({
							id = 90,
							type = "text",
							text = "移动消耗 [b][color=" + this.Const.UI.Color.PositiveValue + "]" + actor.getActionPointCosts()[lastTileHovered.Type] + "+" + actor.getLevelActionPointCost() + "[/color][/b] 行动点数，积累 [b][color=" + this.Const.UI.Color.PositiveValue + "]" + actor.getFatigueCosts()[lastTileHovered.Type] + "+" + actor.getLevelFatigueCost() + "[/color][/b] 点疲劳（高度落差）"
						});
					}
					else
					{
						tooltipContent.push({
							id = 90,
							type = "text",
							text = "移动消耗 [b][color=" + this.Const.UI.Color.PositiveValue + "]" + actor.getActionPointCosts()[lastTileHovered.Type] + "[/color][/b] 行动点数，积累 [b][color=" + this.Const.UI.Color.PositiveValue + "]" + actor.getFatigueCosts()[lastTileHovered.Type] + "[/color][/b] 点疲劳"
						});
					}
				}
			}

			foreach( i, line in this.Const.Tactical.TerrainEffectTooltip[lastTileHovered.Type] )
			{
				tooltipContent.push(line);
			}

			if (lastTileHovered.IsHidingEntity)
			{
				tooltipContent.push({
					id = 98,
					type = "text",
					icon = "ui/icons/vision.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]能把人藏在里面，免得被从远处看到。[/color]"
				});
			}

			local allies;

			if (this.Tactical.State.isScenarioMode())
			{
				allies = this.Const.FactionAlliance[this.Const.Faction.Player];
			}
			else
			{
				allies = this.World.FactionManager.getAlliedFactions(this.Const.Faction.Player);
			}

			if (lastTileHovered.IsVisibleForPlayer && lastTileHovered.hasZoneOfControlOtherThan(allies))
			{
				tooltipContent.push({
					id = 99,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]位于敌方控制区内。[/color]"
				});
			}

			if (lastTileHovered.IsVisibleForPlayer && (lastTileHovered.SquareCoords.X == 0 || lastTileHovered.SquareCoords.Y == 0 || lastTileHovered.SquareCoords.X == 31 || lastTileHovered.SquareCoords.Y == 31))
			{
				tooltipContent.push({
					id = 99,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]此地格上的任何角色都可以安全地即时撤退。[/color]"
				});
			}

			if (lastTileHovered.IsVisibleForPlayer && lastTileHovered.Properties.Effect != null)
			{
				tooltipContent.push({
					id = 100,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + lastTileHovered.Properties.Effect.Tooltip + "[/color]"
				});
			}

			if (lastTileHovered.Items != null)
			{
				local result = [];

				foreach( item in lastTileHovered.Items )
				{
					result.push(item.getIcon());
				}

				if (result.len() > 0)
				{
					tooltipContent.push({
						id = 100,
						type = "icons",
						useItemPath = true,
						icons = result
					});
				}
			}

			return tooltipContent;
		}
	}

	function tactical_queryEntityTooltipData( _entityId, _isTileEntity )
	{
		local entity = this.Tactical.getEntityByID(_entityId);

		if (entity != null)
		{
			return this.tactical_helper_getEntityTooltip(entity, this.Tactical.TurnSequenceBar.getActiveEntity(), _isTileEntity);
		}

		return null;
	}

	function tactical_queryUIItemTooltipData( _entityId, _itemId, _itemOwner )
	{
		local entity = this.Tactical.getEntityByID(_entityId);
		local activeEntity = this.Tactical.TurnSequenceBar.getActiveEntity();

		switch(_itemOwner)
		{
		case "entity":
			if (entity != null)
			{
				local item = entity.getItems().getItemByInstanceID(_itemId);

				if (item != null)
				{
					return this.tactical_helper_addHintsToTooltip(activeEntity, entity, item, _itemOwner);
				}
			}

			return null;

		case "ground":
		case "character-screen-inventory-list-module.ground":
			if (entity != null)
			{
				local item = this.tactical_helper_findGroundItem(entity, _itemId);

				if (item != null)
				{
					return this.tactical_helper_addHintsToTooltip(activeEntity, entity, item, _itemOwner);
				}
			}

			return null;

		case "stash":
		case "character-screen-inventory-list-module.stash":
			local result = this.Stash.getItemByInstanceID(_itemId);

			if (result != null)
			{
				return this.tactical_helper_addHintsToTooltip(activeEntity, entity, result.item, _itemOwner);
			}

			return null;

		case "tactical-combat-result-screen.stash":
			local result = this.Stash.getItemByInstanceID(_itemId);

			if (result != null)
			{
				return this.tactical_helper_addHintsToTooltip(activeEntity, entity, result.item, _itemOwner, true);
			}

			return null;

		case "tactical-combat-result-screen.found-loot":
			local result = this.Tactical.CombatResultLoot.getItemByInstanceID(_itemId);

			if (result != null)
			{
				return this.tactical_helper_addHintsToTooltip(activeEntity, entity, result.item, _itemOwner, true);
			}

			return null;
		}

		return null;
	}

	function tactical_helper_findGroundItem( _entity, _itemId )
	{
		local items = _entity.getTile() != null ? _entity.getTile().Items : null;

		if (items != null && items.len() > 0)
		{
			foreach( item in items )
			{
				if (item.getInstanceID() == _itemId)
				{
					return item;
				}
			}
		}

		return null;
	}

	function tactical_helper_getEntityTooltip( _targetedEntity, _activeEntity, _isTileEntity )
	{
		if (this.Tactical.State != null && this.Tactical.State.getCurrentActionState() == this.Const.Tactical.ActionState.SkillSelected)
		{
			if (_activeEntity != null && this.isKindOf(_targetedEntity, "actor") && _activeEntity.isPlayerControlled() && _targetedEntity != null && !_targetedEntity.isPlayerControlled())
			{
				local skill = _activeEntity.getSkills().getSkillByID(this.Tactical.State.getSelectedSkillID());

				if (skill != null)
				{
					return this.tactical_helper_addContentTypeToTooltip(_targetedEntity, _targetedEntity.getTooltip(skill), _isTileEntity);
				}
			}

			return null;
		}

		if (this.isKindOf(_targetedEntity, "entity"))
		{
			return this.tactical_helper_addContentTypeToTooltip(_targetedEntity, _targetedEntity.getTooltip(), _isTileEntity);
		}

		return null;
	}

	function tactical_helper_addContentTypeToTooltip( _entity, _tooltip, _isTileEntity )
	{
		if (_isTileEntity == false && !_entity.isHiddenToPlayer())
		{
			_tooltip.push({
				id = 1,
				type = "hint",
				icon = "ui/icons/mouse_left_button.png",
				text = this.Const.Strings.Tooltip.Tactical.Hint_FocusCharacter
			});
		}

		if (_isTileEntity == true)
		{
			_tooltip.push({
				contentType = "tile-entity",
				entityId = _entity.getID()
			});
		}
		else
		{
			_tooltip.push({
				contentType = "entity",
				entityId = _entity.getID()
			});
		}

		return _tooltip;
	}

	function tactical_helper_addHintsToTooltip( _activeEntity, _entity, _item, _itemOwner, _ignoreStashLocked = false )
	{
		local stashLocked = true;

		if (this.Stash != null)
		{
			stashLocked = this.Stash.isLocked();
		}

		local tooltip = _item.getTooltip();

		if (stashLocked == true && _ignoreStashLocked == false)
		{
			if (_item.isChangeableInBattle() == false)
			{
				tooltip.push({
					id = 1,
					type = "hint",
					icon = "ui/icons/icon_locked.png",
					text = this.Const.Strings.Tooltip.Tactical.Hint_CannotChangeItemInCombat
				});
				return tooltip;
			}

			if (_activeEntity == null || _entity != null && _activeEntity != null && _entity.getID() != _activeEntity.getID())
			{
				tooltip.push({
					id = 1,
					type = "hint",
					icon = "ui/icons/icon_locked.png",
					text = this.Const.Strings.Tooltip.Tactical.Hint_OnlyActiveCharacterCanChangeItemsInCombat
				});
				return tooltip;
			}

			if (_activeEntity != null && _activeEntity.getItems().isActionAffordable([
				_item
			]) == false)
			{
				tooltip.push({
					id = 1,
					type = "hint",
					icon = "ui/tooltips/warning.png",
					text = "没有足够的行动点来更换物品（需要至少 [b][color=" + this.Const.UI.Color.NegativeValue + "]" + _activeEntity.getItems().getActionCost([
						_item
					]) + "[/color][/b] 点)"
				});
				return tooltip;
			}
		}

		switch(_itemOwner)
		{
		case "entity":
			if (_item.getCurrentSlotType() == this.Const.ItemSlot.Bag && _item.getSlotType() != this.Const.ItemSlot.None)
			{
				if (stashLocked == true)
				{
					if (_item.getSlotType() != this.Const.ItemSlot.Bag && (_entity.getItems().getItemAtSlot(_item.getSlotType()) == null || _entity.getItems().getItemAtSlot(_item.getSlotType()) == "-1" || _entity.getItems().getItemAtSlot(_item.getSlotType()).isAllowedInBag()))
					{
						tooltip.push({
							id = 1,
							type = "hint",
							icon = "ui/icons/mouse_right_button.png",
							text = "装备物品 ([b][color=" + this.Const.UI.Color.PositiveValue + "]" + _activeEntity.getItems().getActionCost([
								_item,
								_entity.getItems().getItemAtSlot(_item.getSlotType()),
								_entity.getItems().getItemAtSlot(_item.getBlockedSlotType())
							]) + "[/color][/b] 点行动力)"
						});
					}

					tooltip.push({
						id = 2,
						type = "hint",
						icon = "ui/icons/mouse_right_button_ctrl.png",
						text = "将物品放在地上 ([b][color=" + this.Const.UI.Color.PositiveValue + "]" + _activeEntity.getItems().getActionCost([
							_item
						]) + "[/color][/b] 点行动力)"
					});
				}
				else
				{
					if (_item.getSlotType() != this.Const.ItemSlot.Bag && (_entity.getItems().getItemAtSlot(_item.getSlotType()) == null || _entity.getItems().getItemAtSlot(_item.getSlotType()) == "-1" || _entity.getItems().getItemAtSlot(_item.getSlotType()).isAllowedInBag()))
					{
						tooltip.push({
							id = 1,
							type = "hint",
							icon = "ui/icons/mouse_right_button.png",
							text = "装备物品"
						});
					}

					tooltip.push({
						id = 2,
						type = "hint",
						icon = "ui/icons/mouse_right_button_ctrl.png",
						text = "将物品放入仓库"
					});
				}
			}
			else if (stashLocked == true)
			{
				if (_item.isChangeableInBattle() && _item.isAllowedInBag() && _entity.getItems().hasEmptySlot(this.Const.ItemSlot.Bag))
				{
					tooltip.push({
						id = 1,
						type = "hint",
						icon = "ui/icons/mouse_right_button.png",
						text = "将物品放入背包 ([b][color=" + this.Const.UI.Color.PositiveValue + "]" + _activeEntity.getItems().getActionCost([
							_item
						]) + "[/color][/b] 点行动力)"
					});
				}

				tooltip.push({
					id = 2,
					type = "hint",
					icon = "ui/icons/mouse_right_button_ctrl.png",
					text = "将物品放在地上 ([b][color=" + this.Const.UI.Color.PositiveValue + "]" + _activeEntity.getItems().getActionCost([
						_item
					]) + "[/color][/b] 点行动力)"
				});
			}
			else
			{
				if (_item.isChangeableInBattle() && _item.isAllowedInBag())
				{
					tooltip.push({
						id = 1,
						type = "hint",
						icon = "ui/icons/mouse_right_button.png",
						text = "将物品放入背包"
					});
				}

				tooltip.push({
					id = 2,
					type = "hint",
					icon = "ui/icons/mouse_right_button_ctrl.png",
					text = "将物品放入仓库"
				});
			}

			break;

		case "ground":
		case "character-screen-inventory-list-module.ground":
			if (_item.isChangeableInBattle())
			{
				if (_item.getSlotType() != this.Const.ItemSlot.None)
				{
					tooltip.push({
						id = 1,
						type = "hint",
						icon = "ui/icons/mouse_right_button.png",
						text = "装备物品 ([b][color=" + this.Const.UI.Color.PositiveValue + "]" + _activeEntity.getItems().getActionCost([
							_item,
							_entity.getItems().getItemAtSlot(_item.getSlotType()),
							_entity.getItems().getItemAtSlot(_item.getBlockedSlotType())
						]) + "[/color][/b] 点行动力)"
					});
				}

				if (_item.isAllowedInBag())
				{
					tooltip.push({
						id = 2,
						type = "hint",
						icon = "ui/icons/mouse_right_button_ctrl.png",
						text = "将物品放入背包 ([b][color=" + this.Const.UI.Color.PositiveValue + "]" + _activeEntity.getItems().getActionCost([
							_item
						]) + "[/color][/b] 点行动力)"
					});
				}
			}

			break;

		case "stash":
		case "character-screen-inventory-list-module.stash":
			if (_item.isUsable())
			{
				tooltip.push({
					id = 1,
					type = "hint",
					icon = "ui/icons/mouse_right_button.png",
					text = "使用物品"
				});
			}
			else if (_item.getSlotType() != this.Const.ItemSlot.None && _item.getSlotType() != this.Const.ItemSlot.Bag)
			{
				tooltip.push({
					id = 1,
					type = "hint",
					icon = "ui/icons/mouse_right_button.png",
					text = "装备物品"
				});
			}

			if (_item.isChangeableInBattle() == true && _item.isAllowedInBag())
			{
				tooltip.push({
					id = 2,
					type = "hint",
					icon = "ui/icons/mouse_right_button_ctrl.png",
					text = "将物品放入背包"
				});
			}

			if (_item.getCondition() < _item.getConditionMax())
			{
				tooltip.push({
					id = 3,
					type = "hint",
					icon = "ui/icons/mouse_right_button_alt.png",
					text = _item.isToBeRepaired() ? "设置物品为不修理状态" : "设置物品为修理状态"
				});
			}

			break;

		case "tactical-combat-result-screen.stash":
			tooltip.push({
				id = 1,
				type = "hint",
				icon = "ui/icons/mouse_right_button.png",
				text = "将物品放在地上"
			});
			break;

		case "tactical-combat-result-screen.found-loot":
			if (this.Stash.hasEmptySlot())
			{
				tooltip.push({
					id = 1,
					type = "hint",
					icon = "ui/icons/mouse_right_button.png",
					text = "将物品放入仓库"
				});
			}
			else
			{
				tooltip.push({
					id = 1,
					type = "hint",
					icon = "ui/tooltips/warning.png",
					text = "仓库满了"
				});
			}

			break;

		case "world-town-screen-shop-dialog-module.stash":
			tooltip.push({
				id = 1,
				type = "hint",
				icon = "ui/icons/mouse_right_button.png",
				text = "售出物品获得 [img]gfx/ui/tooltips/money.png[/img]" + _item.getSellPrice()
			});

			if (this.World.State.getCurrentTown() != null && this.World.State.getCurrentTown().getCurrentBuilding() != null && this.World.State.getCurrentTown().getCurrentBuilding().isRepairOffered() && _item.getConditionMax() > 1 && _item.getCondition() < _item.getConditionMax())
			{
				local price = (_item.getConditionMax() - _item.getCondition()) * this.Const.World.Assets.CostToRepairPerPoint;
				local value = _item.m.Value * (1.0 - _item.getCondition() / _item.getConditionMax()) * 0.2 * this.World.State.getCurrentTown().getPriceMult() * this.Const.Difficulty.SellPriceMult[this.World.Assets.getEconomicDifficulty()];
				price = this.Math.max(price, value);

				if (this.World.Assets.getMoney() >= price)
				{
					tooltip.push({
						id = 3,
						type = "hint",
						icon = "ui/icons/mouse_right_button_alt.png",
						text = "支付[img]gfx/ui/tooltips/money.png[/img]" + price + "进行修理"
					});
				}
				else
				{
					tooltip.push({
						id = 3,
						type = "hint",
						icon = "ui/tooltips/warning.png",
						text = "没有足够的克朗来支付修理费用！"
					});
				}
			}

			break;

		case "world-town-screen-shop-dialog-module.shop":
			if (this.Stash.hasEmptySlot())
			{
				tooltip.push({
					id = 1,
					type = "hint",
					icon = "ui/icons/mouse_right_button.png",
					text = "购买物品花费 [img]gfx/ui/tooltips/money.png[/img]" + _item.getBuyPrice()
				});
			}
			else
			{
				tooltip.push({
					id = 1,
					type = "hint",
					icon = "ui/tooltips/warning.png",
					text = "仓库满了"
				});
			}

			break;
		}

		return tooltip;
	}

	function strategic_queryTileTooltipData()
	{
		local lastTileHovered = this.World.State.getLastTileHovered();

		if (lastTileHovered != null)
		{
			if (this.World.Assets.m.IsShowingExtendedFootprints)
			{
				local footprints = this.World.getAllFootprintsAtPos(this.World.getCamera().screenToWorld(this.Cursor.getX(), this.Cursor.getY()), this.Const.World.FootprintsType.COUNT);
				local ret = [
					{
						id = 1,
						type = "title",
						text = "您的前哨报告。"
					}
				];

				for( local i = 1; i < footprints.len(); i = ++i )
				{
					if (footprints[i])
					{
						ret.push({
							id = 1,
							type = "hint",
							text = this.Const.Strings.FootprintsType[i] + "最近从这里经过"
						});
					}
				}

				if (ret.len() > 1)
				{
					return ret;
				}
			}
		}

		return null;
	}

	function strategic_queryEntityTooltipData( _entityId, _isTileEntity )
	{
		if (_isTileEntity)
		{
			local lastEntityHovered = this.World.State.getLastEntityHovered();
			local entity = this.World.getEntityByID(_entityId);

			if (lastEntityHovered != null && entity != null && lastEntityHovered.getID() == entity.getID())
			{
				return this.strategic_helper_addContentTypeToTooltip(entity, entity.getTooltip());
			}
		}
		else
		{
			local entity = this.Tactical.getEntityByID(_entityId);

			if (entity != null)
			{
				return this.strategic_helper_addContentTypeToTooltip(entity, entity.getRosterTooltip());
			}
		}

		return null;
	}

	function strategic_queryUIItemTooltipData( _entityId, _itemId, _itemOwner )
	{
		local entity = _entityId != null ? this.Tactical.getEntityByID(_entityId) : null;

		switch(_itemOwner)
		{
		case "entity":
			if (entity != null)
			{
				local item = entity.getItems().getItemByInstanceID(_itemId);

				if (item != null)
				{
					return this.tactical_helper_addHintsToTooltip(null, entity, item, _itemOwner);
				}
			}

			return null;

		case "ground":
		case "character-screen-inventory-list-module.ground":
			if (entity != null)
			{
				local item = this.tactical_helper_findGroundItem(entity, _itemId);

				if (item != null)
				{
					return this.tactical_helper_addHintsToTooltip(null, entity, item, _itemOwner);
				}
			}

			return null;

		case "stash":
		case "character-screen-inventory-list-module.stash":
			local result = this.Stash.getItemByInstanceID(_itemId);

			if (result != null)
			{
				return this.tactical_helper_addHintsToTooltip(null, entity, result.item, _itemOwner);
			}

			return null;

		case "craft":
			return this.World.Crafting.getBlueprint(_itemId).getTooltip();

		case "blueprint":
			return this.World.Crafting.getBlueprint(_entityId).getTooltipForComponent(_itemId);

		case "world-town-screen-shop-dialog-module.stash":
			local result = this.Stash.getItemByInstanceID(_itemId);

			if (result != null)
			{
				return this.tactical_helper_addHintsToTooltip(null, entity, result.item, _itemOwner, true);
			}

			return null;

		case "world-town-screen-shop-dialog-module.shop":
			local stash = this.World.State.getTownScreen().getShopDialogModule().getShop().getStash();

			if (stash != null)
			{
				local result = stash.getItemByInstanceID(_itemId);

				if (result != null)
				{
					return this.tactical_helper_addHintsToTooltip(null, entity, result.item, _itemOwner, true);
				}
			}

			return null;
		}

		return null;
	}

	function strategic_helper_addContentTypeToTooltip( _entity, _tooltip )
	{
		_tooltip.push({
			contentType = "tile-entity",
			entityId = _entity.getID()
		});
		return _tooltip;
	}

	function general_querySkillTooltipData( _entityId, _skillId )
	{
		local entity = this.Tactical.getEntityByID(_entityId);

		if (entity != null)
		{
			local skill = entity.getSkills().getSkillByID(_skillId);

			if (skill != null)
			{
				return skill.getTooltip();
			}
		}

		return null;
	}

	function general_queryStatusEffectTooltipData( _entityId, _statusEffectId )
	{
		local entity = this.Tactical.getEntityByID(_entityId);

		if (entity != null)
		{
			local statusEffect = entity.getSkills().getSkillByID(_statusEffectId);

			if (statusEffect != null)
			{
				local ret = statusEffect.getTooltip();

				if (statusEffect.isType(this.Const.SkillType.Background) && ("State" in this.World) && this.World.State != null)
				{
					this.World.Assets.getOrigin().onGetBackgroundTooltip(statusEffect, ret);
				}

				return ret;
			}
		}

		return null;
	}

	function general_querySettlementStatusEffectTooltipData( _statusEffectId )
	{
		local currentTown = this.World.State.getCurrentTown();

		if (currentTown != null)
		{
			local statusEffect = currentTown.getSituationByID(_statusEffectId);

			if (statusEffect != null)
			{
				return statusEffect.getTooltip();
			}
		}

		return null;
	}

	function general_queryUIPerkTooltipData( _entityId, _perkId )
	{
		local perk = this.Const.Perks.findById(_perkId);

		if (perk != null)
		{
			local ret = [
				{
					id = 1,
					type = "title",
					text = perk.Name
				},
				{
					id = 2,
					type = "description",
					text = perk.Tooltip
				}
			];
			local player = this.Tactical.getEntityByID(_entityId);

			if (!player.hasPerk(_perkId))
			{
				if (player.getPerkPointsSpent() >= perk.Unlocks)
				{
					if (player.getPerkPoints() == 0)
					{
						ret.push({
							id = 3,
							type = "hint",
							icon = "ui/icons/icon_locked.png",
							text = "可以获得，但这个角色没有多余的特技点了"
						});
					}
				}
				else if (perk.Unlocks - player.getPerkPointsSpent() > 1)
				{
					ret.push({
						id = 3,
						type = "hint",
						icon = "ui/icons/icon_locked.png",
						text = "特技被锁定，花费" + (perk.Unlocks - player.getPerkPointsSpent()) + "个特技点后解锁"
					});
				}
				else
				{
					ret.push({
						id = 3,
						type = "hint",
						icon = "ui/icons/icon_locked.png",
						text = "特技被锁定，花费" + (perk.Unlocks - player.getPerkPointsSpent()) + "个特技点后解锁"
					});
				}
			}

			return ret;
		}

		return null;
	}

	function general_queryUIElementTooltipData( _entityId, _elementId, _elementOwner )
	{
		local prefix = function ( context )
		{
			if (context.params._elementId == "Battle-Brothers-CN")
			{
				local ret = [
					{
						id = 1,
						type = "title",
						text = "[color=" + this.Const.UI.Color.PositiveValue + "]Battle Brothers(战场兄弟)原版游戏汉化[/color]"
					},
					{
						id = 2,
						type = "description",
						text = "默认发布仅支持原版游戏, 如需使用 Mod 请使用汉化工具 - bb-translator。\n\n汉化参与成员: shabbywu、Rayforward、DarkSjm、白马、0v0、hyscottc。\n\n注意事项:\n0. 喜欢游戏请购买正版\n1. 本补丁为免费汉化, 禁止以任何形式售卖\n2. 汉化问题请到 Github Issue 进行反馈: https://github.com/shabbywu/Battle-Brothers-CN/issues\n3. 汉化文本持续更新中, 欢迎参与共建 https://paratranz.cn/projects/7032"
					},
					{
						id = 1,
						type = "hint",
						icon = "ui/icons/mouse_left_button.png",
						text = "在浏览器中打开项目主页"
					}
				];
				context.result = ret;
				return false;
			}

			return true;
		};
		local origin = function ( _entityId, _elementId, _elementOwner )
		{
			local entity;

			if (_entityId != null)
			{
				entity = this.Tactical.getEntityByID(_entityId);
			}

			switch(_elementId)
			{
			case "CharacterName":
				local ret = [
					{
						id = 1,
						type = "title",
						text = entity.getName()
					}
				];
				return ret;

			case "CharacterNameAndTitles":
				local ret = [
					{
						id = 1,
						type = "title",
						text = entity.getName()
					}
				];

				if ("getProperties" in entity)
				{
					foreach( p in entity.getProperties() )
					{
						local s = this.World.getEntityByID(p);
						ret.push({
							id = 2,
							type = "text",
							text = "领主" + s.getName()
						});
					}
				}

				if ("getTitles" in entity)
				{
					foreach( s in entity.getTitles() )
					{
						ret.push({
							id = 3,
							type = "text",
							text = s
						});
					}
				}

				return ret;

			case "assets.Money":
				local money = this.World.Assets.getMoney();
				local dailyMoney = this.World.Assets.getDailyMoneyCost();
				local time = this.Math.floor(money / this.Math.max(1, dailyMoney));

				if (dailyMoney == 0)
				{
					return [
						{
							id = 1,
							type = "title",
							text = "克朗"
						},
						{
							id = 2,
							type = "description",
							text = "你的佣兵战团拥有的钱币数量。用于每天中午时支付日薪，或是雇佣新人、购买装备。\n\n你现在不给任何人付工资。"
						}
					];
				}
				else if (time >= 1.0 && money > 0)
				{
					return [
						{
							id = 1,
							type = "title",
							text = "克朗"
						},
						{
							id = 2,
							type = "description",
							text = "你的佣兵战团拥有的钱币数量。用于每天中午时支付日薪，或是雇佣新人、购买装备。\n\n日薪支出为 [color=" + this.Const.UI.Color.PositiveValue + "]" + dailyMoney + "[/color] 克朗。你的 [color=" + this.Const.UI.Color.PositiveValue + "]" + money + "[/color] 克朗还能撑上 [color=" + this.Const.UI.Color.PositiveValue + "]" + time + "[/color] 天。"
						}
					];
				}
				else
				{
					return [
						{
							id = 1,
							type = "title",
							text = "克朗"
						},
						{
							id = 2,
							type = "description",
							text = "你的佣兵战团拥有的钱币数量。用于支付日薪，或是雇佣新人、购买装备。\n\n日薪支出为 [color=" + this.Const.UI.Color.PositiveValue + "]" + dailyMoney + "[/color] 克朗。\n\n[color=" + this.Const.UI.Color.NegativeValue + "]你没有足够的克朗付给你的人了！ 要么赶快赚钱，要么在他们陆续抛弃你之前开掉一些。[/color]"
						}
					];
				}

			case "assets.InitialMoney":
				return [
					{
						id = 1,
						type = "title",
						text = "雇佣费"
					},
					{
						id = 2,
						type = "description",
						text = "说服某人签字，证明自己有能力兑现承诺所需的雇佣费用，雇佣费将立即支付。"
					}
				];

			case "assets.Fee":
				return [
					{
						id = 1,
						type = "title",
						text = "先期付款"
					},
					{
						id = 2,
						type = "description",
						text = "该费用必须在享受服务前付清。"
					}
				];

			case "assets.TryoutMoney":
				return [
					{
						id = 1,
						type = "title",
						text = "测验费"
					},
					{
						id = 2,
						type = "description",
						text = "这项费用将立即支出，用于对这个新兵进行适当的检查，以揭示他的特性，如果有的话。"
					}
				];

			case "assets.DailyMoney":
				return [
					{
						id = 1,
						type = "title",
						text = "日薪"
					},
					{
						id = 2,
						type = "description",
						text = "日薪是在你的指挥下服役的报酬，按天支付。工资在升级时自动增加，11级前每级累加10%，之后累加3%。"
					}
				];

			case "assets.Food":
				local food = this.World.Assets.getFood();
				local dailyFood = this.Math.ceil(this.World.Assets.getDailyFoodCost() * this.Const.World.TerrainFoodConsumption[this.World.State.getPlayer().getTile().Type]);
				local time = this.Math.floor(food / dailyFood);

				if (food > 0 && time > 1)
				{
					return [
						{
							id = 1,
							type = "title",
							text = "食物"
						},
						{
							id = 2,
							type = "description",
							text = "你携带的食物总量。一般人每天需要2份食物，复杂地形上的需求量更大。你的人会先食用最接近过期的食物。食物短缺会降低士气，最终导致你的人在饿死之前抛弃你。\n\n你每天消耗[color=" + this.Const.UI.Color.PositiveValue + "]" + dailyFood + "[/color]点食物。你的[color=" + this.Const.UI.Color.PositiveValue + "]" + food + "[/color]点食物能够供您食用至多[color=" + this.Const.UI.Color.PositiveValue + "]" + time + "[/color]天。记住，一批食物早晚会变质！"
						}
					];
				}
				else if (food > 0 && time == 1)
				{
					return [
						{
							id = 1,
							type = "title",
							text = "食物"
						},
						{
							id = 2,
							type = "description",
							text = "你携带的食物总量。一般人每天需要2份食物，复杂地形上的需求量更大。你的人会先食用最接近过期的食物。食物短缺会降低士气，最终导致你的人在饿死之前抛弃你。\n\n你每天消耗[color=" + this.Const.UI.Color.PositiveValue + "]" + dailyFood + "[/color]点食物。\n\n[color=" + this.Const.UI.Color.NegativeValue + "]你快要没有足够的食物养活你的人了！ 尽快购买新的食物，否则你的人会在饿死之前一个接一个地抛弃你！[/color]"
						}
					];
				}
				else
				{
					return [
						{
							id = 1,
							type = "title",
							text = "食物"
						},
						{
							id = 2,
							type = "description",
							text = "你携带的食物总量。一般人每天需要2份食物，复杂地形上的需求量更大。你的人会先食用最接近过期的食物。食物短缺会降低士气，最终导致你的人在饿死之前抛弃你。\n\n你每天消耗[color=" + this.Const.UI.Color.PositiveValue + "]" + dailyFood + "[/color]点食物。\n\n[color=" + this.Const.UI.Color.NegativeValue + "]你没有足够的食物来养活你的人！尽快购买新的食物，否则你的人会在饿死之前陆续抛弃你！[/color]"
						}
					];
				}

			case "assets.DailyFood":
				return [
					{
						id = 1,
						type = "title",
						text = "每日食物"
					},
					{
						id = 2,
						type = "description",
						text = "一个人每天需要的食物供给量。食物短缺会降低士气，最终导致你的人在饿死之前抛弃你。"
					}
				];

			case "assets.Ammo":
				return [
					{
						id = 1,
						type = "title",
						text = "弹药"
					},
					{
						id = 2,
						type = "description",
						text = "整理好的各种箭矢、弩矢、投掷武器，用于在战后自动补充弹药。补充一支箭矢或弩矢消耗一点弹药，补充一发火铳弹消耗两点弹药，补充一支/把投掷武器或是替换火矛上的药包消耗三点弹药。弹药耗尽会使你的人箭袋空空，无法射击。你最多能携带" + (this.Const.Difficulty.MaxResources[this.World.Assets.getEconomicDifficulty()].Ammo + this.World.Assets.m.AmmoMaxAdditional) + "个单位。"
					}
				];

			case "assets.Supplies":
				local repair = this.World.Assets.getRepairRequired();
				local desc = "各种工具和补给，用来维护你的武器，盔甲，头盔和盾牌。 每修理15点耐久需要一点工具补给。补给不足可能导致武器在战斗中断裂，使你的盔甲因无法修复而失去保护能力。";

				if (repair.ArmorParts > 0)
				{
					desc = desc + ("\n\n修理你所有装备需要[color=" + this.Const.UI.Color.PositiveValue + "]" + repair.Hours + "[/color]小时并消耗");

					if (repair.ArmorParts <= this.World.Assets.getArmorParts())
					{
						desc = desc + ("[color=" + this.Const.UI.Color.PositiveValue + "]");
					}
					else
					{
						desc = desc + ("[color=" + this.Const.UI.Color.NegativeValue + "]");
					}

					desc = desc + (repair.ArmorParts + "[/color]工具和补给。");
				}

				desc = desc + ("你至多能携带" + (this.Const.Difficulty.MaxResources[this.World.Assets.getEconomicDifficulty()].ArmorParts + this.World.Assets.m.ArmorPartsMaxAdditional) + "单位。");
				return [
					{
						id = 1,
						type = "title",
						text = "工具和补给"
					},
					{
						id = 2,
						type = "description",
						text = desc
					}
				];

			case "assets.Medicine":
				local heal = this.World.Assets.getHealingRequired();
				local desc = "医疗用品由绷带、草药、药膏等组成，用于治疗你的人在战斗中遭受的较严重的伤害。 每个损伤每天需要1点医疗用品来改善和治愈。失去的生命值会自行恢复。\n\n医疗用品用完会使你的人无法从重伤中恢复。";

				if (heal.MedicineMin > 0)
				{
					desc = desc + ("\n\n治愈所有士兵需要花上[color=" + this.Const.UI.Color.PositiveValue + "]" + heal.DaysMin + "[/color]到[color=" + this.Const.UI.Color.PositiveValue + "]" + heal.DaysMax + "[/color]天并需要大约");

					if (heal.MedicineMin <= this.World.Assets.getMedicine())
					{
						desc = desc + ("[color=" + this.Const.UI.Color.PositiveValue + "]");
					}
					else
					{
						desc = desc + ("[color=" + this.Const.UI.Color.NegativeValue + "]");
					}

					desc = desc + (heal.MedicineMin + "[/color]到");

					if (heal.MedicineMax <= this.World.Assets.getMedicine())
					{
						desc = desc + ("[color=" + this.Const.UI.Color.PositiveValue + "]");
					}
					else
					{
						desc = desc + ("[color=" + this.Const.UI.Color.NegativeValue + "]");
					}

					desc = desc + (heal.MedicineMax + "[/color]医疗用品。");
				}

				desc = desc + ("你至多能携带" + (this.Const.Difficulty.MaxResources[this.World.Assets.getEconomicDifficulty()].Medicine + this.World.Assets.m.MedicineMaxAdditional) + "单位。");
				return [
					{
						id = 1,
						type = "title",
						text = "医疗用品"
					},
					{
						id = 2,
						type = "description",
						text = desc
					}
				];

			case "assets.Brothers":
				return [
					{
						id = 1,
						type = "title",
						text = "名册 (I, C)"
					},
					{
						id = 2,
						type = "description",
						text = "显示了你佣兵战团中战斗人员的花名册。"
					}
				];

			case "assets.BusinessReputation":
				return [
					{
						id = 1,
						type = "title",
						text = "名望：" + this.World.Assets.getBusinessReputationAsText() + " (" + this.World.Assets.getBusinessReputation() + ")"
					},
					{
						id = 2,
						type = "description",
						text = "你的名望是你作为一个专业的雇佣兵战团的名气，反映了人们对你的可靠性和能力的评价。你的名望越高，报酬越高，人们委托你的合同就越困难。在野心、合同以及战斗中取得成功时，名望会增加，反之则会减少。"
					}
				];

			case "assets.MoralReputation":
				return [
					{
						id = 1,
						type = "title",
						text = "声誉：" + this.World.Assets.getMoralReputationAsText()
					},
					{
						id = 2,
						type = "description",
						text = "你的声誉反映了世界上的人们如何根据过去的行为评判你的雇佣兵战团。你对敌人是否仁慈？你是否烧毁农舍、屠杀农民？根据你的声誉，人们可能会向你提供不同种类的合同，合同和事件的发展也可能会有所不同。"
					}
				];

			case "assets.Ambition":
				if (this.World.Ambitions.hasActiveAmbition())
				{
					local ret = this.World.Ambitions.getActiveAmbition().getButtonTooltip();

					if (this.World.Ambitions.getActiveAmbition().isCancelable())
					{
						ret.push({
							id = 10,
							type = "hint",
							icon = "ui/icons/mouse_right_button.png",
							text = "取消野心"
						});
					}

					return ret;
				}
				else
				{
					return [
						{
							id = 1,
							type = "title",
							text = "野心"
						},
						{
							id = 2,
							type = "description",
							text = "你还没有宣布战团追求的野心。随着游戏的进行，你将被要求这样做。"
						}
					];
				}

			case "stash.FreeSlots":
				return [
					{
						id = 1,
						type = "title",
						text = "容量"
					},
					{
						id = 2,
						type = "description",
						text = "显示仓库（全局物品）的当前运载量和运载量上限。"
					}
				];

			case "stash.ActiveRoster":
				return [
					{
						id = 1,
						type = "title",
						text = "战斗序列中的角色"
					},
					{
						id = 2,
						type = "description",
						text = "显示了战斗序列中的当前人数和人数上限，他们会在接下来的战斗里参战。\n\n你可以任意拖拽、放置人物；最上面一排是面对敌人的前排，第二排是后排，最下面一排是不参加战斗，用于保存角色的预备队。"
					}
				];

			case "ground.Slots":
				return [
					{
						id = 1,
						type = "title",
						text = "地面"
					},
					{
						id = 2,
						type = "description",
						text = "显示当前放置在地面上的物品。"
					}
				];

			case "character-stats.ActionPoints":
				return [
					{
						id = 1,
						type = "title",
						text = "行动点"
					},
					{
						id = 2,
						type = "description",
						text = "用于每个动作，如移动或使用技能，都要用到行动点（AP）。所有点数用完后，当前角色的回合将自动结束。每个回合开始时，行动点（AP）都会完全恢复。"
					}
				];

			case "character-stats.Hitpoints":
				return [
					{
						id = 1,
						type = "title",
						text = "生命值"
					},
					{
						id = 2,
						type = "description",
						text = "生命值代表一个角色在死亡前所能承受的伤害。一旦达到零，角色就被认定为死亡。生命值上限越高，角色受到攻击时受到创伤削弱的可能性越小。"
					}
				];

			case "character-stats.Morale":
				return [
					{
						id = 1,
						type = "title",
						text = "士气"
					},
					{
						id = 2,
						type = "description",
						text = "士气会处于五个代表着战斗人员的心理状态和战斗力的状态等级之一。士气的最低等级是溃逃，在该等级下，角色将会脱离玩家控制，不过他们仍有可能被集结起来。随着战斗展开，士气会发生变化，具有高决心的角色更不容易陷入士气低落状态。你的许多对手也受到士气的影响。\n\n士气检定在这些情况下触发：\n- 杀敌\n- 看到敌人被杀\n- 看到队友被杀\n- 看到队友逃跑\n- 受到15点或以上的生命值伤害\n- 面对一个以上的对手\n- 使用某些技能，例如“集结”"
					}
				];

			case "character-stats.Fatigue":
				return [
					{
						id = 1,
						type = "title",
						text = "疲劳值"
					},
					{
						id = 2,
						type = "description",
						text = "角色每做出一个动作，如移动或使用技能，就会累积疲劳值。此外，被击中或躲避近战攻击时也会累积。回合开始时，疲劳值会固定减少15，最多减少到0。 如果一个角色积累了太多的疲劳值，他可能需要休息一段时间（即什么都不做），然后才能再次使用专业技能。"
					}
				];

			case "character-stats.MaximumFatigue":
				return [
					{
						id = 1,
						type = "title",
						text = "疲劳值上限"
					},
					{
						id = 2,
						type = "description",
						text = "疲劳值上限是一名角色在无法采取任何行动、被迫休息之前允许积累的疲劳值量。 穿戴重型装备，尤其是盔甲，会使其减少。"
					}
				];

			case "character-stats.ArmorHead":
				return [
					{
						id = 1,
						type = "title",
						text = "头部护甲"
					},
					{
						id = 2,
						type = "description",
						text = "多新鲜啊，头部护甲保护的居然是头，它比身体更难命中，但也更加脆弱。头部护甲越高，头部受到攻击时的生命值伤害就越小。"
					}
				];

			case "character-stats.ArmorBody":
				return [
					{
						id = 1,
						type = "title",
						text = "身体护甲"
					},
					{
						id = 2,
						type = "description",
						text = "身体护甲越高，被命中时受到的生命值伤害就越小。"
					}
				];

			case "character-stats.MeleeSkill":
				return [
					{
						id = 1,
						type = "title",
						text = "近战技能"
					},
					{
						id = 2,
						type = "description",
						text = "决定着使用近战攻击，比如剑、矛击中目标的基本概率。可以随着角色获得经验而提高。"
					}
				];

			case "character-stats.RangeSkill":
				return [
					{
						id = 1,
						type = "title",
						text = "远程技能"
					},
					{
						id = 2,
						type = "description",
						text = "决定着使用远程攻击，比如弓弩击中目标的基础概率。可以随着角色获得经验而提高。"
					}
				];

			case "character-stats.MeleeDefense":
				return [
					{
						id = 1,
						type = "title",
						text = "近战防御"
					},
					{
						id = 2,
						type = "description",
						text = "更高的近战防御能降低被近战攻击，如矛的刺击击中的概率。此数值可以通过获得经验或装备盾牌提升。"
					}
				];

			case "character-stats.RangeDefense":
				return [
					{
						id = 1,
						type = "title",
						text = "远程防御"
					},
					{
						id = 2,
						type = "description",
						text = "更高的远程防御能降低被远程攻击，如飞来的箭矢击中的概率。此数值可以通过获得经验或装备盾牌提升。"
					}
				];

			case "character-stats.SightDistance":
				return [
					{
						id = 1,
						type = "title",
						text = "视野"
					},
					{
						id = 2,
						type = "description",
						text = "视野，或视距，决定角色能看多远，用于揭开战争迷雾，发现威胁和发起远程攻击。重型头盔和夜幕会降低视野。"
					}
				];

			case "character-stats.RegularDamage":
				return [
					{
						id = 1,
						type = "title",
						text = "伤害"
					},
					{
						id = 2,
						type = "description",
						text = "当前装备武器能造成的基本伤害。如果目标没有盔甲保护，该值将完全作用于生命值。 如果目标受到盔甲保护，则根据武器的破甲效率，对盔甲施加伤害。实际造成的伤害会因使用的技能和击中的目标而改变。"
					}
				];

			case "character-stats.CrushingDamage":
				return [
					{
						id = 1,
						type = "title",
						text = "破甲效果"
					},
					{
						id = 2,
						type = "description",
						text = "命中有盔甲保护的目标时造成伤害的基础倍率。一旦盔甲被摧毁，武器伤害将100%的作用于生命值。实际造成的伤害会因使用的技能和击中的目标而改变。"
					}
				];

			case "character-stats.ChanceToHitHead":
				return [
					{
						id = 1,
						type = "title",
						text = "爆头率"
					},
					{
						id = 2,
						type = "description",
						text = "击中目标头部，造成额外伤害的基础概率。实际概率受使用的技能影响。"
					}
				];

			case "character-stats.Initiative":
				return [
					{
						id = 1,
						type = "title",
						text = "主动值"
					},
					{
						id = 2,
						type = "description",
						text = "该值越高，回合顺序中的位置越靠前。主动值会因当前的疲劳值以及疲劳值上限惩罚（如重型盔甲）而降低。一般来说，穿轻甲的人会在穿重甲的人之前行动，精力充沛的人会在疲惫的人之前行动。"
					}
				];

			case "character-stats.Bravery":
				return [
					{
						id = 1,
						type = "title",
						text = "决心"
					},
					{
						id = 2,
						type = "description",
						text = "决心代表着角色的意志力和勇气。该值越高，角色越不容易因消极事件降低士气，越容易从积极事件中获得信心。决心也可以用于防御会造成恐慌，恐惧或精神控制的精神攻击。另见：士气。"
					}
				];

			case "character-stats.Talent":
				return [
					{
						id = 1,
						type = "title",
						text = "天赋"
					},
					{
						id = 2,
						type = "description",
						text = "TODO"
					}
				];

			case "character-stats.Undefined":
				return [
					{
						id = 1,
						type = "title",
						text = "UNDEFINED"
					},
					{
						id = 2,
						type = "description",
						text = "TODO"
					}
				];

			case "character-backgrounds.generic":
				if (entity != null)
				{
					local tooltip = entity.getBackground().getGenericTooltip();
					return tooltip;
				}

				return null;

			case "character-levels.generic":
				return [
					{
						id = 1,
						type = "title",
						text = "高等级"
					},
					{
						id = 2,
						type = "description",
						text = "该角色有过战斗经验，初始等级更高。"
					}
				];

			case "menu-screen.load-campaign.LoadButton":
				return [
					{
						id = 1,
						type = "title",
						text = "载入战役"
					},
					{
						id = 2,
						type = "description",
						text = "加载所选的战役。"
					}
				];

			case "menu-screen.load-campaign.CancelButton":
				return [
					{
						id = 1,
						type = "title",
						text = "取消"
					},
					{
						id = 2,
						type = "description",
						text = "返回主菜单。"
					}
				];

			case "menu-screen.load-campaign.DeleteButton":
				return [
					{
						id = 1,
						type = "title",
						text = "删除战役"
					},
					{
						id = 2,
						type = "description",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]警告：[/color]这是删除所选战役的最后一道警告。"
					}
				];

			case "menu-screen.save-campaign.LoadButton":
				return [
					{
						id = 1,
						type = "title",
						text = "保存战役"
					},
					{
						id = 2,
						type = "description",
						text = "在所选栏位保存战役。"
					}
				];

			case "menu-screen.save-campaign.CancelButton":
				return [
					{
						id = 1,
						type = "title",
						text = "取消"
					},
					{
						id = 2,
						type = "description",
						text = "返回主菜单。"
					}
				];

			case "menu-screen.save-campaign.DeleteButton":
				return [
					{
						id = 1,
						type = "title",
						text = "删除战役"
					},
					{
						id = 2,
						type = "description",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]警告：[/color]这是删除所选战役的最后一道警告。"
					}
				];

			case "menu-screen.new-campaign.CompanyName":
				return [
					{
						id = 1,
						type = "title",
						text = "战团名称"
					},
					{
						id = 2,
						type = "description",
						text = "你的佣兵团将以这个名字闻名天下。"
					}
				];

			case "menu-screen.new-campaign.Seed":
				return [
					{
						id = 1,
						type = "title",
						text = "地图种子"
					},
					{
						id = 2,
						type = "description",
						text = "地图种子是决定了世界样貌的特殊字符串。按下Escape（Esc）键，就能看到当前战役的地图种子。把种子分享给朋友，可以让他们在同一世界中进行游玩。"
					}
				];

			case "menu-screen.new-campaign.EasyDifficulty":
				return [
					{
						id = 1,
						type = "title",
						text = "初学者难度"
					},
					{
						id = 2,
						type = "description",
						text = "你将面对较少较弱的对手，你的人获得经验更快，更容易从战斗中撤退。\n\n你的人会有小额命中率加成，敌人则会有小额命中率惩罚，让你更轻松地代入游戏。\n\n推荐给本游戏的新玩家。"
					}
				];

			case "menu-screen.new-campaign.NormalDifficulty":
				return [
					{
						id = 1,
						type = "title",
						text = "老兵难度"
					},
					{
						id = 2,
						type = "description",
						text = "提供具有挑战性的平衡游戏体验。\n\n推荐给本游戏或这类游戏的资深玩家。"
					}
				];

			case "menu-screen.new-campaign.HardDifficulty":
				return [
					{
						id = 1,
						type = "title",
						text = "专家难度"
					},
					{
						id = 2,
						type = "description",
						text = "你将面对更多更强的对手。\n\n推荐给喜欢险中求胜的专家级玩家。"
					}
				];

			case "menu-screen.new-campaign.EasyDifficultyEconomic":
				return [
					{
						id = 1,
						type = "title",
						text = "初学者难度"
					},
					{
						id = 2,
						type = "description",
						text = "合同付钱更多，携带资源上限提高。\n\n推荐给本游戏的新玩家。"
					}
				];

			case "menu-screen.new-campaign.NormalDifficultyEconomic":
				return [
					{
						id = 1,
						type = "title",
						text = "老兵难度"
					},
					{
						id = 2,
						type = "description",
						text = "提供具有挑战性的平衡游戏体验。\n\n推荐给本游戏或这类游戏的资深玩家。"
					}
				];

			case "menu-screen.new-campaign.HardDifficultyEconomic":
				return [
					{
						id = 1,
						type = "title",
						text = "专家难度"
					},
					{
						id = 2,
						type = "description",
						text = "合同付钱更少，逃兵会带走装备。\n\n推荐给那些希望在管理战团资金和补给方面遇到更多挑战的专家级玩家。"
					}
				];

			case "menu-screen.new-campaign.EasyDifficultyBudget":
				return [
					{
						id = 1,
						type = "title",
						text = "高启动资金"
					},
					{
						id = 2,
						type = "description",
						text = "起始时拥有更多克朗和资源。\n\n推荐给新玩家。"
					}
				];

			case "menu-screen.new-campaign.NormalDifficultyBudget":
				return [
					{
						id = 1,
						type = "title",
						text = "中启动资金"
					},
					{
						id = 2,
						type = "description",
						text = "推荐给追求平衡体验的玩家。"
					}
				];

			case "menu-screen.new-campaign.HardDifficultyBudget":
				return [
					{
						id = 1,
						type = "title",
						text = "低启动资金"
					},
					{
						id = 2,
						type = "description",
						text = "起始时拥有的克朗和资源更少。\n\n推荐给专家级玩家。"
					}
				];

			case "menu-screen.new-campaign.StartingScenario":
				return [
					{
						id = 1,
						type = "title",
						text = "起始场景预设"
					},
					{
						id = 2,
						type = "description",
						text = "选择战团如何开始闯荡世界。根据选择不同，会有不同的初始人员、装备、资源和特殊规则。"
					}
				];

			case "menu-screen.new-campaign.Ironman":
				return [
					{
						id = 1,
						type = "title",
						text = "铁人模式"
					},
					{
						id = 2,
						type = "description",
						text = "铁人模式将禁用手动保存。该战团将只有一个存档，游戏在游戏期间和退出时自动保存。失去战团意味着失去存档。推荐给所有了解了游戏机制的人，打开此选项会带给你最好的体验。\n\n请注意，在性能较弱的计算机上，自动保存可能会导致游戏暂停几秒钟。"
					}
				];

			case "menu-screen.new-campaign.Exploration":
				return [
					{
						id = 1,
						type = "title",
						text = "未探索地图"
					},
					{
						id = 2,
						type = "description",
						text = "一种可选的游玩方式，游戏开始时，整个地图都会处于未探索、不可见的状态。所有东西都要自己探索，提高了游戏难度，也让游戏更加刺激。\n\n只推荐给了解游戏，知己知彼的老练玩家。"
					}
				];

			case "menu-screen.new-campaign.EvilRandom":
				return [
					{
						id = 1,
						type = "title",
						text = "随机游戏后期危机"
					},
					{
						id = 2,
						type = "description",
						text = "每次危机都会在下列选项中随机选出。"
					}
				];

			case "menu-screen.new-campaign.EvilNone":
				return [
					{
						id = 1,
						type = "title",
						text = "没有危机"
					},
					{
						id = 2,
						type = "description",
						text = "不会有后期游戏危机，你可以永远继续玩沙盒体验。请注意，选择此选项后，将无法体验相当一部分游戏内容和后期游戏挑战。 如果你想获得游玩最佳体验，不推荐选择此选项。"
					}
				];

			case "menu-screen.new-campaign.EvilPermanentDestruction":
				return [
					{
						id = 1,
						type = "title",
						text = "永久摧毁"
					},
					{
						id = 2,
						type = "description",
						text = "在游戏后期的危机中，城市、城镇和城堡都可能被永久摧毁，整个世界陷入火海会成为你输掉游戏（战役）的原因之一。"
					}
				];

			case "menu-screen.new-campaign.EvilWar":
				return [
					{
						id = 1,
						type = "title",
						text = "贵族战争"
					},
					{
						id = 2,
						type = "description",
						text = "游戏后期的第一场危机将是贵族家族之间的一场残酷的权力战争。如果你活得够久，接下来的危机将会随机选择。"
					}
				];

			case "menu-screen.new-campaign.EvilGreenskins":
				return [
					{
						id = 1,
						type = "title",
						text = "绿皮入侵"
					},
					{
						id = 2,
						type = "description",
						text = "游戏后期的第一场危机将是绿皮部落入侵，他们威胁要荡平人类世界。如果你活得够久，接下来的危机将会随机选择。"
					}
				];

			case "menu-screen.new-campaign.EvilUndead":
				return [
					{
						id = 1,
						type = "title",
						text = "亡灵天灾"
					},
					{
						id = 2,
						type = "description",
						text = "游戏后期的第一场危机将是古代亡灵再次现身，夺回曾经属于他们的东西。如果你活得够久，接下来的危机将会随机选择。"
					}
				];

			case "menu-screen.new-campaign.EvilCrusade":
				return [
					{
						id = 1,
						type = "title",
						text = "圣战"
					},
					{
						id = 2,
						type = "description",
						text = "游戏后期的第一场危机将是南北文化之间的圣战。如果你活得够久，接下来的危机将会随机选择。"
					}
				];

			case "menu-screen.options.DepthOfField":
				return [
					{
						id = 1,
						type = "title",
						text = "景深"
					},
					{
						id = 2,
						type = "description",
						text = "启用景深效果后，在战术战斗中，低于摄像机的高度会略微失焦（即模糊），产生更多的微缩感，使区分高度更加容易，但可能会牺牲一些细节。"
					}
				];

			case "menu-screen.options.UIScale":
				return [
					{
						id = 1,
						type = "title",
						text = "用户界面规模"
					},
					{
						id = 2,
						type = "description",
						text = "更改用户界面的比例，即菜单和文本等。"
					}
				];

			case "menu-screen.options.SceneScale":
				return [
					{
						id = 1,
						type = "title",
						text = "场景比例"
					},
					{
						id = 2,
						type = "description",
						text = "更改场景的比例，即所有非用户界面的内容，如战场上显示的角色。"
					}
				];

			case "menu-screen.options.EdgeOfScreen":
				return [
					{
						id = 1,
						type = "title",
						text = "屏幕边缘"
					},
					{
						id = 2,
						type = "description",
						text = "通过将鼠标光标移到屏幕边缘来滚动屏幕。"
					}
				];

			case "menu-screen.options.DragWithMouse":
				return [
					{
						id = 1,
						type = "title",
						text = "鼠标拖动"
					},
					{
						id = 2,
						type = "description",
						text = "通过按住鼠标左键拖动来滚动屏幕（默认）。"
					}
				];

			case "menu-screen.options.HardwareMouse":
				return [
					{
						id = 1,
						type = "title",
						text = "使用硬件光标"
					},
					{
						id = 2,
						type = "description",
						text = "在游戏中移动鼠标时，使用硬件光标可以最大限度地减少输入延迟。如果鼠标光标出现问题，请禁用此选项。"
					}
				];

			case "menu-screen.options.HardwareSound":
				return [
					{
						id = 1,
						type = "title",
						text = "使用硬件声音"
					},
					{
						id = 2,
						type = "description",
						text = "使用硬件加速声音播放以改善性能表现。如遇到任何与声音相关的问题，请禁用此选项。"
					}
				];

			case "menu-screen.options.CameraFollow":
				return [
					{
						id = 1,
						type = "title",
						text = "始终关注AI移动"
					},
					{
						id = 2,
						type = "description",
						text = "始终让摄像机对准所有视野内的AI移动。"
					}
				];

			case "menu-screen.options.CameraAdjust":
				return [
					{
						id = 1,
						type = "title",
						text = "自动调整高度级别"
					},
					{
						id = 2,
						type = "description",
						text = "自动调整摄像机的高度，以查看战斗中当前活动的角色。禁用此选项能防止摄像机在不必要时更改高度级别，但当角色恰好被地形阻挡时，还需要手动调整高度级别。"
					}
				];

			case "menu-screen.options.StatsOverlays":
				return [
					{
						id = 1,
						type = "title",
						text = "始终显示生命条"
					},
					{
						id = 2,
						type = "description",
						text = "始终在战斗中显示在角色上方浮动的生命和护甲条，反选此选项则只会在角色被击中时显示。"
					}
				];

			case "menu-screen.options.OrientationOverlays":
				return [
					{
						id = 1,
						type = "title",
						text = "显示方向图标"
					},
					{
						id = 2,
						type = "description",
						text = "在屏幕边缘显示图标，指示当前屏幕外的所有角色在地图上的方向。"
					}
				];

			case "menu-screen.options.MovementPlayer":
				return [
					{
						id = 1,
						type = "title",
						text = "更快的玩家移动"
					},
					{
						id = 2,
						type = "description",
						text = "在战斗中加快所有你控制的角色的移动速度。 不会影响移动相关的技能。"
					}
				];

			case "menu-screen.options.MovementAI":
				return [
					{
						id = 1,
						type = "title",
						text = "更快的AI移动"
					},
					{
						id = 2,
						type = "description",
						text = "在战斗中显著加速由AI控制的任何角色的移动。不影响带有移动效果的技能。"
					}
				];

			case "menu-screen.options.AutoLoot":
				return [
					{
						id = 1,
						type = "title",
						text = "自动拾取战利品"
					},
					{
						id = 2,
						type = "description",
						text = "在你关闭战利品页面后自动拾取所有战利品，前提是你有足够的仓库空间。"
					}
				];

			case "menu-screen.options.RestoreEquipment":
				return [
					{
						id = 1,
						type = "title",
						text = "战斗后重置装备"
					},
					{
						id = 2,
						type = "description",
						text = "在条件允许的情况下，自动将装备放回战斗前的物品栏位中。例如，在战斗开始时，某个角色持有弩，在战斗中切换为矛，则在战斗结束时，他将自动重新拿起弩。"
					}
				];

			case "menu-screen.options.AutoPauseAfterCity":
				return [
					{
						id = 1,
						type = "title",
						text = "离开城市后自动暂停"
					},
					{
						id = 2,
						type = "description",
						text = "离开城市后自动暂停游戏，避免时间浪费，代价是每次都要手动取消暂停。"
					}
				];

			case "menu-screen.options.AlwaysHideTrees":
				return [
					{
						id = 1,
						type = "title",
						text = "总是隐藏树木"
					},
					{
						id = 2,
						type = "description",
						text = "始终以半透明显示树木和其他大型地图对象的顶部，反选此选项将仅在它们遮挡对象时启用此效果。"
					}
				];

			case "menu-screen.options.AutoEndTurns":
				return [
					{
						id = 1,
						type = "title",
						text = "自动结束回合"
					},
					{
						id = 2,
						type = "description",
						text = "由你控制的角色没有任何行动点可执行任何动作时，将自动结束他的回合。"
					}
				];

			case "tactical-screen.topbar.event-log-module.ExpandButton":
				return [
					{
						id = 1,
						type = "title",
						text = "展开/收回事件日志"
					},
					{
						id = 2,
						type = "description",
						text = "展开或收回战斗事件日志。"
					}
				];

			case "tactical-screen.topbar.round-information-module.BrothersCounter":
				return [
					{
						id = 1,
						type = "title",
						text = "盟友"
					},
					{
						id = 2,
						type = "description",
						text = "战场上由你控制的战友和AI控制的盟友的数量。"
					}
				];

			case "tactical-screen.topbar.round-information-module.EnemiesCounter":
				return [
					{
						id = 1,
						type = "title",
						text = "对手"
					},
					{
						id = 2,
						type = "description",
						text = "当前战场上的对手数量。"
					}
				];

			case "tactical-screen.topbar.round-information-module.RoundCounter":
				return [
					{
						id = 1,
						type = "title",
						text = "回合"
					},
					{
						id = 2,
						type = "description",
						text = "战斗开始后所进行的轮数。"
					}
				];

			case "tactical-screen.topbar.options-bar-module.CenterButton":
				return [
					{
						id = 1,
						type = "title",
						text = "居中相机 (Shift)"
					},
					{
						id = 2,
						type = "description",
						text = "以当前角色为中心重置相机。"
					}
				];

			case "tactical-screen.topbar.options-bar-module.ToggleHighlightBlockedTilesButton":
				return [
					{
						id = 1,
						type = "title",
						text = "显示/隐藏阻挡格子的高光 （B）"
					},
					{
						id = 2,
						type = "description",
						text = "切换显示或隐藏标记角色无法通行环境物体（如：树）的红色遮罩层。"
					}
				];

			case "tactical-screen.topbar.options-bar-module.SwitchMapLevelUpButton":
				return [
					{
						id = 1,
						type = "title",
						text = "提高相机高度 (+)"
					},
					{
						id = 2,
						type = "description",
						text = "提高相机的高度，以查看地图上更高的部分。"
					}
				];

			case "tactical-screen.topbar.options-bar-module.SwitchMapLevelDownButton":
				return [
					{
						id = 1,
						type = "title",
						text = "降低相机高度 (-)"
					},
					{
						id = 2,
						type = "description",
						text = "降低相机的高度并隐藏地图上更高的部分。"
					}
				];

			case "tactical-screen.topbar.options-bar-module.ToggleStatsOverlaysButton":
				return [
					{
						id = 1,
						type = "title",
						text = "显示/隐藏生命条 (Alt)"
					},
					{
						id = 2,
						type = "description",
						text = "切换显示或隐藏每个角色头顶的护甲条，生命条以及状态效果图标。"
					}
				];

			case "tactical-screen.topbar.options-bar-module.ToggleTreesButton":
				return [
					{
						id = 1,
						type = "title",
						text = "显示/隐藏树 (T)"
					},
					{
						id = 2,
						type = "description",
						text = "切换显示或隐藏地图上的树以及其他大型对象。"
					}
				];

			case "tactical-screen.topbar.options-bar-module.FleeButton":
				local ret = [
					{
						id = 1,
						type = "title",
						text = "从战斗中撤退"
					},
					{
						id = 2,
						type = "description",
						text = "撤退吧，逃命吧。与其在这里毫无意义地死去，不如改日再战。"
					}
				];

				if (!this.Tactical.State.isScenarioMode() && this.Tactical.State.getStrategicProperties() != null && this.Tactical.State.getStrategicProperties().IsFleeingProhibited)
				{
					ret.push({
						id = 3,
						type = "hint",
						icon = "ui/tooltips/warning.png",
						text = "你不能从这场特定的战斗中撤退。"
					});
				}

				return ret;

			case "tactical-screen.topbar.options-bar-module.QuitButton":
				return [
					{
						id = 1,
						type = "title",
						text = "打开菜单 (Esc)"
					},
					{
						id = 2,
						type = "description",
						text = "打开菜单调整游戏选项。"
					}
				];

			case "tactical-screen.turn-sequence-bar-module.EndTurnButton":
				return [
					{
						id = 1,
						type = "title",
						text = "结束回合 (回车键，F)"
					},
					{
						id = 2,
						type = "description",
						text = "结束当前角色的回合，并让下一个顺位的角色行动。"
					}
				];

			case "tactical-screen.turn-sequence-bar-module.WaitTurnButton":
				return [
					{
						id = 1,
						type = "title",
						text = "等待回合 (空格键，End)"
					},
					{
						id = 2,
						type = "description",
						text = "暂停当前角色的回合并将其移动到队列的末尾。在当前回合中选择等待，也会让你在下一轮晚一些再行动。"
					}
				];

			case "tactical-screen.turn-sequence-bar-module.EndTurnAllButton":
				return [
					{
						id = 1,
						type = "title",
						text = "结束回合 (R)"
					},
					{
						id = 2,
						type = "description",
						text = "结束当前轮，让所有人跳过他们的回合，直到下一轮开始。"
					}
				];

			case "tactical-screen.turn-sequence-bar-module.OpenInventoryButton":
				return [
					{
						id = 1,
						type = "title",
						text = "打开仓库 (I, C)"
					},
					{
						id = 2,
						type = "description",
						text = "查看当前角色的状态和物品。"
					}
				];

			case "tactical-combat-result-screen.LeaveButton":
				return [
					{
						id = 1,
						type = "title",
						text = "离开"
					},
					{
						id = 2,
						type = "description",
						text = "离开战斗，返回世界地图。"
					}
				];

			case "tactical-combat-result-screen.statistics-panel.LeveledUp":
				local result = [
					{
						id = 1,
						type = "title",
						text = "升级"
					},
					{
						id = 2,
						type = "description",
						text = "这个角色刚刚升级！在世界地图上时，你可以在花名册中找到他，提高他的属性并选择一个特技。"
					}
				];
				return result;

			case "tactical-combat-result-screen.statistics-panel.DaysWounded":
				local result = [
					{
						id = 1,
						type = "title",
						text = "轻微伤"
					},
					{
						id = 2,
						type = "description",
						text = "轻微的瘀伤、皮肉伤、失血等使这个角色损失了生命值，尚不影响战斗能力。"
					}
				];

				if (entity != null)
				{
					if (entity.getDaysWounded() <= 1)
					{
						result.push({
							id = 1,
							type = "text",
							icon = "ui/icons/days_wounded.png",
							text = "明天就会痊愈"
						});
					}
					else
					{
						result.push({
							id = 1,
							type = "text",
							icon = "ui/icons/days_wounded.png",
							text = "将在[color=" + this.Const.UI.Color.NegativeValue + "]" + entity.getDaysWounded() + "[/color]天内治愈"
						});
					}
				}

				return result;

			case "tactical-combat-result-screen.statistics-panel.KillsValue":
				return [
					{
						id = 1,
						type = "title",
						text = "击杀"
					},
					{
						id = 2,
						type = "description",
						text = "该角色在战斗中取得的击杀数。"
					}
				];

			case "tactical-combat-result-screen.statistics-panel.XPReceivedValue":
				return [
					{
						id = 1,
						type = "title",
						text = "获得的经验"
					},
					{
						id = 2,
						type = "description",
						text = "战斗期间通过搏斗和击杀对手获得的经验点数。获得足够的经验点数将使这个人升级，提升属性，获得新的特技。"
					}
				];

			case "tactical-combat-result-screen.statistics-panel.DamageDealtValue":
				local result = [
					{
						id = 1,
						type = "title",
						text = "造成的伤害"
					},
					{
						id = 2,
						type = "description",
						text = "这个角色在战斗中对生命值和盔甲造成的伤害。"
					}
				];

				if (entity != null)
				{
					local combatStats = entity.getCombatStats();
					result.push({
						id = 1,
						type = "text",
						icon = "ui/icons/regular_damage.png",
						text = "造成 [color=" + this.Const.UI.Color.PositiveValue + "]" + combatStats.DamageDealtHitpoints + "[/color] 生命值伤害"
					});
					result.push({
						id = 2,
						type = "text",
						icon = "ui/icons/shield_damage.png",
						text = "造成 [color=" + this.Const.UI.Color.PositiveValue + "]" + combatStats.DamageDealtArmor + "[/color] 护甲伤害"
					});
				}

				return result;

			case "tactical-combat-result-screen.statistics-panel.DamageReceivedValue":
				local result = [
					{
						id = 1,
						type = "title",
						text = "受到的伤害"
					},
					{
						id = 2,
						type = "description",
						text = "这个角色受到的伤害，分为生命值伤害和盔甲伤害。该值是在计算了所有减伤之后的值。"
					}
				];

				if (entity != null)
				{
					local combatStats = entity.getCombatStats();
					result.push({
						id = 1,
						type = "text",
						icon = "ui/icons/regular_damage.png",
						text = "受到了 [color=" + this.Const.UI.Color.NegativeValue + "]" + combatStats.DamageReceivedHitpoints + "[/color] 生命值伤害"
					});
					result.push({
						id = 2,
						type = "text",
						icon = "ui/icons/shield_damage.png",
						text = "受到了 [color=" + this.Const.UI.Color.NegativeValue + "]" + combatStats.DamageReceivedArmor + "[/color] 护甲伤害"
					});
				}

				return result;

			case "tactical-combat-result-screen.loot-panel.LootAllItemsButton":
				return [
					{
						id = 1,
						type = "title",
						text = "掠夺所有物品"
					},
					{
						id = 2,
						type = "description",
						text = "掠夺所有找到的物品，直到仓库满为止。"
					}
				];

			case "character-screen.left-panel-header-module.ChangeNameAndTitle":
				return [
					{
						id = 1,
						type = "title",
						text = "更改名称和头衔"
					},
					{
						id = 2,
						type = "description",
						text = "单击此处更改角色的名称和头衔。"
					}
				];

			case "character-screen.left-panel-header-module.Experience":
				return [
					{
						id = 1,
						type = "title",
						text = "经验"
					},
					{
						id = 2,
						type = "description",
						text = "角色能在自己或队友杀敌时获得经验。如果角色积累了足够经验，他的等级会得到提高，能够提高自己的属性，选择一项能带来独特加成的特技。\n\n在角色11级之后，角色将成为老兵，不再获得特技点，但仍可有所提高。"
					}
				];

			case "character-screen.left-panel-header-module.Level":
				return [
					{
						id = 1,
						type = "title",
						text = "等级"
					},
					{
						id = 2,
						type = "description",
						text = "角色的等级衡量了他的战斗经验。随着经验提升，其等级也会提高，并能提高属性、获得特技，更好的从事佣兵事业。\n\n在角色11级之后，角色将成为老兵，不再获得特技点，但仍可有所提高。"
					}
				];

			case "character-screen.brothers-list.LevelUp":
				local result = [
					{
						id = 1,
						type = "title",
						text = "升级"
					},
					{
						id = 2,
						type = "description",
						text = "这个角色升级了。提高他的属性，选择一项特技！"
					}
				];
				return result;

			case "character-screen.left-panel-header-module.Dismiss":
				return [
					{
						id = 1,
						type = "title",
						text = "解雇"
					},
					{
						id = 2,
						type = "description",
						text = "将此角色从名册中解雇，以省下一笔日薪，为他人腾出位置。负债者角色将摆脱奴隶身份，离开你的战团。"
					}
				];

			case "character-screen.right-panel-header-module.InventoryButton":
				return [
					{
						id = 1,
						type = "title",
						text = "仓库/地面"
					},
					{
						id = 2,
						type = "description",
						text = "切换到佣兵团仓库一览，或是战斗中选定角色下方的地面。"
					}
				];

			case "character-screen.right-panel-header-module.PerksButton":
				return [
					{
						id = 1,
						type = "title",
						text = "特技"
					},
					{
						id = 2,
						type = "description",
						text = "切换到当前角色的特技一览。\n\n括号中的数字（如有）是可用的特技点数。"
					}
				];

			case "character-screen.right-panel-header-module.CloseButton":
				return [
					{
						id = 1,
						type = "title",
						text = "关闭 (ESC)"
					},
					{
						id = 2,
						type = "description",
						text = "关闭此界面。"
					}
				];

			case "character-screen.right-panel-header-module.SortButton":
				return [
					{
						id = 1,
						type = "title",
						text = "物品排序"
					},
					{
						id = 2,
						type = "description",
						text = "按类型对物品排序。"
					}
				];

			case "character-screen.right-panel-header-module.FilterAllButton":
				return [
					{
						id = 1,
						type = "title",
						text = "按类型筛选物品"
					},
					{
						id = 2,
						type = "description",
						text = "显示所有物品。"
					}
				];

			case "character-screen.right-panel-header-module.FilterWeaponsButton":
				return [
					{
						id = 1,
						type = "title",
						text = "按类型筛选物品"
					},
					{
						id = 2,
						type = "description",
						text = "只显示武器、攻击性的工具和配件。"
					}
				];

			case "character-screen.right-panel-header-module.FilterArmorButton":
				return [
					{
						id = 1,
						type = "title",
						text = "按类型筛选物品"
					},
					{
						id = 2,
						type = "description",
						text = "只显示盔甲、头盔和盾牌。"
					}
				];

			case "character-screen.right-panel-header-module.FilterMiscButton":
				return [
					{
						id = 1,
						type = "title",
						text = "按类型筛选物品"
					},
					{
						id = 2,
						type = "description",
						text = "只显示补给、食物、贵重物品和其他物品。"
					}
				];

			case "character-screen.right-panel-header-module.FilterUsableButton":
				return [
					{
						id = 1,
						type = "title",
						text = "按类型筛选物品"
					},
					{
						id = 2,
						type = "description",
						text = "只显示在仓库模式下可用的物品，如涂料或盔甲升级。"
					}
				];

			case "character-screen.right-panel-header-module.FilterMoodButton":
				return [
					{
						id = 1,
						type = "title",
						text = "显示/隐藏情绪"
					},
					{
						id = 2,
						type = "description",
						text = "切换显示或隐藏你的人的情绪。"
					}
				];

			case "character-screen.battle-start-footer-module.StartBattleButton":
				return [
					{
						id = 1,
						type = "title",
						text = "开始战斗"
					},
					{
						id = 2,
						type = "description",
						text = "使用选定的装备开始战斗。"
					}
				];

			case "character-screen.levelup-popup-dialog.StatIncreasePoints":
				return [
					{
						id = 1,
						type = "title",
						text = "属性点"
					},
					{
						id = 2,
						type = "description",
						text = "花费该点数，能让你在随机出的8项属性成长中，任意选择3项升级。每项属性在单次升级中只能被提高一次。升级时可以获得该点数。\n\n星标意味角色在特定属性上天赋异禀，总能骰出更好的成长值。"
					}
				];

			case "character-screen.dismiss-popup-dialog.Compensation":
				return [
					{
						id = 1,
						type = "title",
						text = "补偿"
					},
					{
						id = 2,
						type = "description",
						text = "给被解雇者支付一笔赔偿金、酬金或是养老金，帮助他们更有尊严的离开战团，开启新生活，也能避免其他战团成员因解雇可能出现的愤怒情绪。\n为负债奴隶支付赔偿金，弥补他们在公司工作的时间。其他负债奴隶会感激你支付赔偿金，但如果你不支付，也不会有谁因此而生气。"
					}
				];

			case "world-screen.topbar.TimePauseButton":
				return [
					{
						id = 1,
						type = "title",
						text = "暂停 (空格键)"
					},
					{
						id = 2,
						type = "description",
						text = "暂停游戏。"
					}
				];

			case "world-screen.topbar.TimeNormalButton":
				return [
					{
						id = 1,
						type = "title",
						text = "正常速度 (1)"
					},
					{
						id = 2,
						type = "description",
						text = "将时间流动速度设为正常。"
					}
				];

			case "world-screen.topbar.TimeFastButton":
				return [
					{
						id = 1,
						type = "title",
						text = "快速 (2)"
					},
					{
						id = 2,
						type = "description",
						text = "使时间流动速度比平常更快。"
					}
				];

			case "world-screen.topbar.options-module.ActiveContractButton":
				return [
					{
						id = 1,
						type = "title",
						text = "当前合同"
					},
					{
						id = 2,
						type = "description",
						text = "显示当前合同的详细信息。"
					}
				];

			case "world-screen.topbar.options-module.RelationsButton":
				return [
					{
						id = 1,
						type = "title",
						text = "显示派系和关系 (R)"
					},
					{
						id = 2,
						type = "description",
						text = "查看所有已知派系以及你与他们的关系。"
					}
				];

			case "world-screen.topbar.options-module.CenterButton":
				return [
					{
						id = 1,
						type = "title",
						text = "相机居中 (回车键, Shift)"
					},
					{
						id = 2,
						type = "description",
						text = "把相机移到中间，以佣兵团为中心放大画面。"
					}
				];

			case "world-screen.topbar.options-module.CameraLockButton":
				return [
					{
						id = 1,
						type = "title",
						text = "切换锁定相机 (X)"
					},
					{
						id = 2,
						type = "description",
						text = "锁定或解锁相机，将你的佣兵团固定在画面中央。"
					}
				];

			case "world-screen.topbar.options-module.TrackingButton":
				return [
					{
						id = 1,
						type = "title",
						text = "切换跟踪足迹 (F)"
					},
					{
						id = 2,
						type = "description",
						text = "显示或隐藏其他队伍在世界上留下的足迹，以便你追踪或躲避他们。"
					}
				];

			case "world-screen.topbar.options-module.CampButton":
				local ret = [
					{
						id = 1,
						type = "title",
						text = "扎营 (T)"
					},
					{
						id = 2,
						type = "description",
						text = "搭拆帐篷。扎营的时候，时间流逝加快，你的人会更快治愈、修好装备。然而，你也更容易受到突然袭击。"
					}
				];

				if (!this.World.State.isCampingAllowed())
				{
					ret.push({
						id = 9,
						type = "text",
						icon = "ui/tooltips/warning.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]与其他队伍一同旅行时无法扎营[/color]"
					});
				}

				return ret;

			case "world-screen.topbar.options-module.PerksButton":
				return [
					{
						id = 1,
						type = "title",
						text = "随从 (P)"
					},
					{
						id = 2,
						type = "description",
						text = "在这里你能查看能在战斗之外带来各种好处的非战斗追随者，也可以升级你的货车以获得更多的库存空间。"
					}
				];

			case "world-screen.topbar.options-module.ObituaryButton":
				return [
					{
						id = 1,
						type = "title",
						text = "讣告 (O)"
					},
					{
						id = 2,
						type = "description",
						text = "查看讣告，上面列出了自你上任以来为战团献身的人。"
					}
				];

			case "world-screen.topbar.options-module.QuitButton":
				return [
					{
						id = 1,
						type = "title",
						text = "打开菜单 (Esc)"
					},
					{
						id = 2,
						type = "description",
						text = "打开菜单后，你可以保存或加载游戏，调整游戏选项或退出战役并返回主菜单。"
					}
				];

			case "world-screen.active-contract-panel-module.ToggleVisibilityButton":
				return [
					{
						id = 1,
						type = "title",
						text = "取消合同"
					},
					{
						id = 2,
						type = "description",
						text = "取消当前合同。"
					}
				];

			case "world-screen.obituary.ColumnName":
				return [
					{
						id = 1,
						type = "title",
						text = "Name"
					},
					{
						id = 2,
						type = "description",
						text = "角色的名称。"
					}
				];

			case "world-screen.obituary.ColumnTime":
				return [
					{
						id = 1,
						type = "title",
						text = "天"
					},
					{
						id = 2,
						type = "description",
						text = "角色在战团任职到其死亡的天数。"
					}
				];

			case "world-screen.obituary.ColumnBattles":
				return [
					{
						id = 1,
						type = "title",
						text = "战斗"
					},
					{
						id = 2,
						type = "description",
						text = "角色在死亡前所经历的战斗次数。"
					}
				];

			case "world-screen.obituary.ColumnKills":
				return [
					{
						id = 1,
						type = "title",
						text = "击杀"
					},
					{
						id = 2,
						type = "description",
						text = "该角色死前在战斗中取得的击杀数。"
					}
				];

			case "world-screen.obituary.ColumnKilledBy":
				return [
					{
						id = 1,
						type = "title",
						text = "死因"
					},
					{
						id = 2,
						type = "description",
						text = "角色的死因。"
					}
				];

			case "world-town-screen.main-dialog-module.LeaveButton":
				return [
					{
						id = 1,
						type = "title",
						text = "离开"
					},
					{
						id = 2,
						type = "description",
						text = "离开并返回世界地图。"
					}
				];

			case "world-town-screen.main-dialog-module.Contract":
				local ret = [
					{
						id = 1,
						type = "title",
						text = "能接到的合同"
					},
					{
						id = 2,
						type = "description",
						text = "有人想雇佣雇佣兵。"
					}
				];
				return ret;

			case "world-town-screen.main-dialog-module.ContractNegotiated":
				local ret = [
					{
						id = 1,
						type = "title",
						text = "能接到的合同"
					},
					{
						id = 2,
						type = "description",
						text = "合同已经谈妥，就等你签字了。"
					}
				];
				return ret;

			case "world-town-screen.main-dialog-module.ContractDisabled":
				local ret = [
					{
						id = 1,
						type = "title",
						text = "你已经签下一个合同了！"
					},
					{
						id = 2,
						type = "description",
						text = "你一次只能激活一个合同。在你履行当前合同期间，只要问题没有在此期间消失，合同要约将保持不变。"
					}
				];
				return ret;

			case "world-town-screen.main-dialog-module.ContractLocked":
				local ret = [
					{
						id = 1,
						type = "title",
						text = "合同已锁定"
					},
					{
						id = 2,
						type = "description",
						text = "这里只有拥有这座防御工事的贵族家族的合同，但他们不认为你值得他们关注。提高你的名望，完成让贵族家族注意到你的战团的野心，解锁新合同！"
					}
				];
				return ret;

			case "world-town-screen.main-dialog-module.Crowd":
				return [
					{
						id = 1,
						type = "title",
						text = "雇佣"
					},
					{
						id = 2,
						type = "description",
						text = "为你的雇佣兵战团雇佣新人。志愿者的质量和数量取决于这个定居点的规模和类型，以及你在这里的声誉。每隔几天，就会有新人到来，而其他人则会继续旅行。"
					}
				];

			case "world-town-screen.main-dialog-module.Tavern":
				return [
					{
						id = 1,
						type = "title",
						text = "酒馆"
					},
					{
						id = 2,
						type = "description",
						text = "一家充满了酒客的大酒馆，提供了饮料，食物以及新闻和流言编织成的活跃氛围。"
					}
				];

			case "world-town-screen.main-dialog-module.Temple":
				return [
					{
						id = 1,
						type = "title",
						text = "神殿"
					},
					{
						id = 2,
						type = "description",
						text = "外面严酷世界的避风港。你可以在这里为你的伤员寻求治疗，并为你永恒的灵魂祈求救赎。"
					}
				];

			case "world-town-screen.main-dialog-module.VeteransHall":
				return [
					{
						id = 1,
						type = "title",
						text = "训练厅"
					},
					{
						id = 2,
						type = "description",
						text = "专业战斗人士汇集的地方。在这里，你的人能接受老练战士的教授和训练，更快被塑造成坚强的雇佣兵。"
					}
				];

			case "world-town-screen.main-dialog-module.Taxidermist":
				return [
					{
						id = 1,
						type = "title",
						text = "剥制屋"
					},
					{
						id = 2,
						type = "description",
						text = "只要肯花钱，剥制师能把你带给他的战利品制成各种实用物品。"
					}
				];

			case "world-town-screen.main-dialog-module.Kennel":
				return [
					{
						id = 1,
						type = "title",
						text = "驯犬屋"
					},
					{
						id = 2,
						type = "description",
						text = "一间驯犬屋，为战争繁育训练强壮而敏捷的战犬。"
					}
				];

			case "world-town-screen.main-dialog-module.Barber":
				return [
					{
						id = 1,
						type = "title",
						text = "理发店"
					},
					{
						id = 2,
						type = "description",
						text = "在理发店定制你的人的外表。 剪掉头发，修剪胡须，或者买些不可靠的药剂来减肥。"
					}
				];

			case "world-town-screen.main-dialog-module.Fletcher":
				return [
					{
						id = 1,
						type = "title",
						text = "弓弩店"
					},
					{
						id = 2,
						type = "description",
						text = "弓弩店提供各种精心制作的远程武器。"
					}
				];

			case "world-town-screen.main-dialog-module.Alchemist":
				return [
					{
						id = 1,
						type = "title",
						text = "炼金术士"
					},
					{
						id = 2,
						type = "description",
						text = "炼金术士能以一笔可观的费用，为你提供各种奇异而危险的合剂。"
					}
				];

			case "world-town-screen.main-dialog-module.Arena":
				local ret = [
					{
						id = 1,
						type = "title",
						text = "竞技场"
					},
					{
						id = 2,
						type = "description",
						text = "竞技场提供了一个在那些热爱凶残杀戮的观众面前，通过殊死搏斗赢得金钱和名声的机会。"
					}
				];

				if (this.World.State.getCurrentTown() != null && this.World.State.getCurrentTown().getBuilding("building.arena").isClosed())
				{
					ret.push({
						id = 3,
						type = "hint",
						icon = "ui/tooltips/warning.png",
						text = "今天这里没有比赛了。明天再来！"
					});
				}

				if (this.World.Contracts.getActiveContract() != null && this.World.Contracts.getActiveContract().getType() != "contract.arena" && this.World.Contracts.getActiveContract().getType() != "contract.arena_tournament")
				{
					ret.push({
						id = 3,
						type = "hint",
						icon = "ui/tooltips/warning.png",
						text = "你已经签订了其他合同，不能在竞技场上战斗"
					});
				}
				else if (this.World.Contracts.getActiveContract() == null && this.World.State.getCurrentTown() != null && this.World.State.getCurrentTown().hasSituation("situation.arena_tournament") && this.World.Assets.getStash().getNumberOfEmptySlots() < 5)
				{
					ret.push({
						id = 3,
						type = "hint",
						icon = "ui/tooltips/warning.png",
						text = "你需要至少5个空的仓库栏位才能参与这场竞技大赛"
					});
				}
				else if (this.World.Contracts.getActiveContract() == null && this.World.Assets.getStash().getNumberOfEmptySlots() < 3)
				{
					ret.push({
						id = 3,
						type = "hint",
						icon = "ui/tooltips/warning.png",
						text = "你需要至少3个空的仓库栏位在才能在竞技场战斗"
					});
				}

				return ret;

			case "world-town-screen.main-dialog-module.Port":
				local ret = [
					{
						id = 1,
						type = "title",
						text = "港口"
					},
					{
						id = 2,
						type = "description",
						text = "一个为外来商船和当地渔民服务的港口。在这里你能买到前往大陆其他地区的船票。"
					}
				];

				if (this.World.Contracts.getActiveContract() != null && this.World.Contracts.getActiveContract().getType() == "contract.escort_caravan")
				{
					ret.push({
						id = 3,
						type = "hint",
						icon = "ui/tooltips/warning.png",
						text = "合同规定护送商队时不能使用港口"
					});
				}

				return ret;

			case "world-town-screen.main-dialog-module.Marketplace":
				return [
					{
						id = 1,
						type = "title",
						text = "集市"
					},
					{
						id = 2,
						type = "description",
						text = "一个热闹的市场，提供该地区常见的各种商品。每隔几天或当商队到达这个定居点时就会有新的商品出售。"
					}
				];

			case "world-town-screen.main-dialog-module.Weaponsmith":
				return [
					{
						id = 1,
						type = "title",
						text = "武器匠"
					},
					{
						id = 2,
						type = "description",
						text = "这间铁匠工坊陈列着各种精心制作的武器。损坏的装备也可以在这里以一定的价格修理。"
					}
				];

			case "world-town-screen.main-dialog-module.Armorsmith":
				return [
					{
						id = 1,
						type = "title",
						text = "盔甲店"
					},
					{
						id = 2,
						type = "description",
						text = "这间盔甲店是寻找制作精良、经久耐用的防护用品的理想场所。损坏的装备也可以在这里修好，给钱就行。"
					}
				];

			case "world-town-screen.hire-dialog-module.LeaveButton":
				return [
					{
						id = 1,
						type = "title",
						text = "离开"
					},
					{
						id = 2,
						type = "description",
						text = "离开当前界面返回上级界面。"
					}
				];

			case "world-town-screen.hire-dialog-module.HireButton":
				return [
					{
						id = 1,
						type = "title",
						text = "雇佣新兵"
					},
					{
						id = 2,
						type = "description",
						text = "雇佣选定的新兵，让他加入你的花名册。"
					}
				];

			case "world-town-screen.hire-dialog-module.TryoutButton":
				return [
					{
						id = 1,
						type = "title",
						text = "测验新兵"
					},
					{
						id = 2,
						type = "description",
						text = "测试这名战团潜在的新成员，以揭示他隐藏的特性，如果有的话。"
					}
				];

			case "world-town-screen.hire-dialog-module.UnknownTraits":
				return [
					{
						id = 1,
						type = "title",
						text = "未知角色特性"
					},
					{
						id = 2,
						type = "description",
						text = "这个角色可能有未知的特性。 你可以支付费用测试以发现这些特性。"
					}
				];

			case "world-town-screen.taxidermist-dialog-module.CraftButton":
				return [
					{
						id = 1,
						type = "title",
						text = "制作"
					},
					{
						id = 2,
						type = "description",
						text = "花一笔钱，提供一些原料，得到相应的成品。"
					}
				];

			case "world-town-screen.travel-dialog-module.LeaveButton":
				return [
					{
						id = 1,
						type = "title",
						text = "离开"
					},
					{
						id = 2,
						type = "description",
						text = "离开当前界面返回上级界面。"
					}
				];

			case "world-town-screen.travel-dialog-module.TravelButton":
				return [
					{
						id = 1,
						type = "title",
						text = "旅行"
					},
					{
						id = 2,
						type = "description",
						text = "为你的战团预订船票，快速前往选定目的地。"
					}
				];

			case "world-town-screen.shop-dialog-module.LeaveButton":
				return [
					{
						id = 1,
						type = "title",
						text = "离开商店"
					},
					{
						id = 2,
						type = "description",
						text = "离开当前界面返回上级界面。"
					}
				];

			case "world-town-screen.training-dialog-module.Train1":
				return [
					{
						id = 1,
						type = "title",
						text = "搏斗练习"
					},
					{
						id = 2,
						type = "description",
						text = "让你的队员与有经验的对手进行练习战斗，并学习多样的战斗方式。所获得的挫伤和经验教训将会给下一场战斗带来[color=" + this.Const.UI.Color.PositiveValue + "]+50%[/color]经验加成。"
					}
				];

			case "world-town-screen.training-dialog-module.Train2":
				return [
					{
						id = 1,
						type = "title",
						text = "老兵的课程"
					},
					{
						id = 2,
						type = "description",
						text = "让你的人从一位真正的行家里手那里学习有价值的课程和经验。所传授的知识将会给接下来的三场战斗带来[color=" + this.Const.UI.Color.PositiveValue + "]+35%[/color]经验加成。"
					}
				];

			case "world-town-screen.training-dialog-module.Train3":
				return [
					{
						id = 1,
						type = "title",
						text = "严格的训练"
					},
					{
						id = 2,
						type = "description",
						text = "让你的人接受严格的训练计划，将他打造成一个熟练的战士。今天所付出的血汗将会使他日后受益匪浅。给接下来的五场战斗[color=" + this.Const.UI.Color.PositiveValue + "]+20%[/color]经验加成。"
					}
				];

			case "world-game-finish-screen.dialog-module.QuitButton":
				return [
					{
						id = 1,
						type = "title",
						text = "退出游戏"
					},
					{
						id = 2,
						type = "description",
						text = "退出游戏并返回主菜单。 你在这里的进度将不会被保存。"
					}
				];

			case "world-relations-screen.Relations":
				local ret = [
					{
						id = 1,
						type = "title",
						text = "关系"
					},
					{
						id = 2,
						type = "description",
						text = "你与某个派系的关系的好坏，决定了他们和你是战是和，是否愿意雇佣你来签订合同，以及他们给你的价格和在他们的定居点为你提供的新兵数量。\n\n如果你成功的完成了派系安排的工作，则会增进你们之间的关系。相反，如果没能完成工作，甚至背叛或主动发起攻击，则会损害你们的关系。随着时间流逝，关系会逐渐趋于中立。"
					}
				];
				local changes = this.World.FactionManager.getFaction(_entityId).getPlayerRelationChanges();

				foreach( change in changes )
				{
					if (change.Positive)
					{
						ret.push({
							id = 11,
							type = "hint",
							icon = "ui/tooltips/positive.png",
							text = "" + change.Text + ""
						});
					}
					else
					{
						ret.push({
							id = 11,
							type = "hint",
							icon = "ui/tooltips/negative.png",
							text = "" + change.Text + ""
						});
					}
				}

				return ret;

			case "world-campfire-screen.Cart":
				local ret = [
					{
						id = 1,
						type = "title",
						text = this.Const.Strings.InventoryHeader[this.World.Retinue.getInventoryUpgrades()]
					},
					{
						id = 2,
						type = "description",
						text = "佣兵团免不了携带大量装备物资。通过货车和载重货车，你可以扩大你的可用库存空间，进一步加大携带量。"
					}
				];

				if (this.World.Retinue.getInventoryUpgrades() < this.Const.Strings.InventoryUpgradeHeader.len())
				{
					ret.push({
						id = 1,
						type = "hint",
						icon = "ui/icons/mouse_left_button.png",
						text = this.Const.Strings.InventoryUpgradeHeader[this.World.Retinue.getInventoryUpgrades()] + "对于[img]gfx/ui/tooltips/money.png[/img]" + this.Const.Strings.InventoryUpgradeCosts[this.World.Retinue.getInventoryUpgrades()]
					});
				}

				return ret;

			case "dlc_1":
				local ret = [
					{
						id = 1,
						type = "title",
						text = "林德蠕龙"
					},
					{
						id = 2,
						type = "description",
						text = "免费的林德蠕龙（林德虫）DLC增加了一只具有挑战性的新野兽，一些新的玩家旗帜，以及一组新的著名盔甲、头盔和盾牌。"
					}
				];

				if (this.Const.DLC.Lindwurm == true)
				{
					ret[1].text += "\n\n[color=" + this.Const.UI.Color.PositiveValue + "]此DLC已安装。[/color]";
				}
				else
				{
					ret[1].text += "\n\n[color=" + this.Const.UI.Color.NegativeValue + "]此DLC缺失。 在Steam和GOG上免费提供！[/color]";
				}

				ret.push({
					id = 1,
					type = "hint",
					icon = "ui/icons/mouse_left_button.png",
					text = "在浏览器里打开商店页面"
				});
				return ret;

			case "dlc_2":
				local ret = [
					{
						id = 1,
						type = "title",
						text = "野兽与探险"
					},
					{
						id = 2,
						type = "description",
						text = "野兽与探索DLC添加了游荡在野外的多种野兽，一个用战利品制作物品的制造系统，多个具有独特奖励发现的传奇地点，许多新的合同和事件，一个新的盔甲附件系统，多种新的武器，盔甲和可用物品，等等。"
					}
				];

				if (this.Const.DLC.Unhold == true)
				{
					ret[1].text += "\n\n[color=" + this.Const.UI.Color.PositiveValue + "]此DLC已安装。[/color]";
				}
				else
				{
					ret[1].text += "\n\n[color=" + this.Const.UI.Color.NegativeValue + "]此DLC缺失。 可以在Steam和GOG上购买！[/color]";
				}

				ret.push({
					id = 1,
					type = "hint",
					icon = "ui/icons/mouse_left_button.png",
					text = "在浏览器里打开商店页面"
				});
				return ret;

			case "dlc_4":
				local ret = [
					{
						id = 1,
						type = "title",
						text = "北方勇士"
					},
					{
						id = 2,
						type = "description",
						text = "北方勇士DLC添加了一个新的，有着自己的战斗风格和装备的人类派系——北方野蛮人，新的战团起源系统，基于北欧和罗斯风格设计的新装备，以及新的合同和事件。"
					}
				];

				if (this.Const.DLC.Wildmen == true)
				{
					ret[1].text += "\n\n[color=" + this.Const.UI.Color.PositiveValue + "]此DLC已安装。[/color]";
				}
				else
				{
					ret[1].text += "\n\n[color=" + this.Const.UI.Color.NegativeValue + "]此DLC缺失。 可以在Steam和GOG上购买！[/color]";
				}

				ret.push({
					id = 1,
					type = "hint",
					icon = "ui/icons/mouse_left_button.png",
					text = "在浏览器里打开商店页面"
				});
				return ret;

			case "dlc_6":
				local ret = [
					{
						id = 1,
						type = "title",
						text = "炽热沙漠"
					},
					{
						id = 2,
						type = "description",
						text = "炽热沙漠DLC在地图南方增添了一个以中世纪的阿拉伯和波斯文化为原型的沙漠地区，一场新的涉及圣战的游戏后期危机，用于定制战团的非战斗追随者，炼金术装置和原始火器，新的人类和野兽对手，新的合同和事件，等等。"
					}
				];

				if (this.Const.DLC.Desert == true)
				{
					ret[1].text += "\n\n[color=" + this.Const.UI.Color.PositiveValue + "]此DLC已安装。[/color]";
				}
				else
				{
					ret[1].text += "\n\n[color=" + this.Const.UI.Color.NegativeValue + "]此DLC缺失。 可以在Steam和GOG上购买！[/color]";
				}

				ret.push({
					id = 1,
					type = "hint",
					icon = "ui/icons/mouse_left_button.png",
					text = "在浏览器里打开商店页面"
				});
				return ret;

			case "dlc_8":
				local ret = [
					{
						id = 1,
						type = "title",
						text = "血肉与信仰"
					},
					{
						id = 2,
						type = "description",
						text = "免费的血肉与信仰DLC为你添加了两个新的、非常独特的起源：解剖学家和宣誓者。 此外，还有两个新的旗帜、新装备、新的雇佣背景和许多新事件。"
					}
				];

				if (this.Const.DLC.Paladins == true)
				{
					ret[1].text += "\n\n[color=" + this.Const.UI.Color.PositiveValue + "]此DLC已安装。[/color]";
				}
				else
				{
					ret[1].text += "\n\n[color=" + this.Const.UI.Color.NegativeValue + "]此DLC缺失。 在Steam和GOG上免费提供！[/color]";
				}

				ret.push({
					id = 1,
					type = "hint",
					icon = "ui/icons/mouse_left_button.png",
					text = "在浏览器里打开商店页面"
				});
				return ret;
			}

			return null;
		};
		local suffix = function ( context )
		{
		};
		local params = {
			_entityId = _entityId,
			_elementId = _elementId,
			_elementOwner = _elementOwner
		};
		local context = {
			result = null,
			params = params,
			origin = origin
		};

		if (!prefix.call(this, context))
		{
			return context.result;
		}

		context.result = context.origin.acall([
			this,
			params._entityId,
			params._elementId,
			params._elementOwner
		]);
		suffix.call(this, context);
		return context.result;
	}

};
