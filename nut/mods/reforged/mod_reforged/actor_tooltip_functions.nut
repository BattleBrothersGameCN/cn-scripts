::Reforged.TacticalTooltip <- {
	function getTooltipAttributesSmall( _actor, _startID )
	{
		local currentProperties = _actor.getCurrentProperties();
		local baseProperties = _actor.getBaseProperties();
		local formatString = function ( _img, _attributeCurrent, _attributeDelta )
		{
			local attributeDeltaText = _attributeDelta == 0 ? "" : "(" + ::MSU.Text.colorizeValue(_attributeDelta, {
				AddSign = true
			}) + ")";
			return this.format("<span class=\'rf_tacticalTooltipAttributeEntry\'><img src=\'coui://%s\'/> <span class=\'rf_tacticalTooltipAttributeValue\'>%i</span><span class=\'rf_tacticalTooltipAttributeDelta\'>%s</span></span>", _img, _attributeCurrent, attributeDeltaText);
		};
		local ret = {
			id = _startID++,
			type = "text",
			text = "<div class=\'rf_tacticalTooltipAttributeList\'>",
			rawHTMLInText = true
		};
		ret.text += formatString("gfx/ui/icons/melee_skill.png", currentProperties.getMeleeSkill(), currentProperties.getMeleeSkill() - baseProperties.getMeleeSkill());
		ret.text += formatString("gfx/ui/icons/ranged_skill.png", currentProperties.getRangedSkill(), currentProperties.getRangedSkill() - baseProperties.getRangedSkill());
		ret.text += formatString("gfx/ui/icons/bravery.png", currentProperties.getBravery(), currentProperties.getBravery() - baseProperties.getBravery());
		ret.text += formatString("gfx/ui/icons/melee_defense.png", currentProperties.getMeleeDefense(), currentProperties.getMeleeDefense() - baseProperties.getMeleeDefense());
		ret.text += formatString("gfx/ui/icons/ranged_defense.png", currentProperties.getRangedDefense(), currentProperties.getRangedDefense() - baseProperties.getRangedDefense());
		ret.text += formatString("gfx/ui/icons/initiative.png", _actor.getInitiative(), _actor.getInitiative() - baseProperties.getInitiative());
		ret.text += "</div>";
		return ret;
	}

	function getReach( _actor, _startID )
	{
		local ret = {
			id = _startID++,
			type = "text",
			text = "<div class=\'rf_tacticalTooltipReachContainer\'>",
			rawHTMLInText = true
		};
		ret.text += this.getReachElement(_actor);
		ret.text += this.getVisionElement(_actor);
		ret.text += "</div>";
		return ret;
	}

	function getReachElement( _actor )
	{
		local currentProperties = _actor.getCurrentProperties();
		local reach = currentProperties.getReach();
		local reachAtk = currentProperties.OffensiveReachIgnore;
		local reachDef = currentProperties.DefensiveReachIgnore;
		local reachImg = "[img]gfx/ui/icons/rf_reach.png[/img]";
		local reachAtkImg = "[img]gfx/ui/icons/rf_reach_attack.png[/img]";
		local reachDefImg = "[img]gfx/ui/icons/rf_reach_defense.png[/img]";

		if (!_actor.getCurrentProperties().IsAffectedByReach)
		{
			return this.format("<span class=\'rf_tacticalTooltipReach\'>%s Unaffected</span>", reachImg);
		}

		return this.format("<span class=\'rf_tacticalTooltipReach\'>%s %i (%s %i, %s %i)</span>", reachImg, reach, reachAtkImg, reachAtk, reachDefImg, reachDef);
	}

	function getVisionElement( _actor )
	{
		local formatString = function ( _img, _attributeCurrent, _attributeDelta )
		{
			local attributeDeltaText = _attributeDelta == 0 ? "" : "(" + ::MSU.Text.colorizeValue(_attributeDelta, {
				AddSign = true
			}) + ")";
			return this.format("<span class=\'rf_tacticalTooltipAttributeEntry rf_tacticalTooltipVision\'><img src=\'coui://%s\'/> <span class=\'rf_tacticalTooltipAttributeValue\'>%i</span><span class=\'rf_tacticalTooltipAttributeDelta\'>%s</span></span>", _img, _attributeCurrent, attributeDeltaText);
		};
		return formatString("gfx/ui/icons/vision.png", _actor.getCurrentProperties().getVision(), _actor.getCurrentProperties().getVision() - _actor.getBaseProperties().getVision());
	}

	function getTooltipEffects( _actor, _startID )
	{
		local currentID = _startID;
		local collapseThreshold = ::Reforged.Mod.ModSettings.getSetting("TacticalTooltip_CollapseEffectsWhenX").getValue();
		local effectList = [];
		local statusEffects = _actor.getSkills().query(::Const.SkillType.StatusEffect | ::Const.SkillType.PermanentInjury, false, true);

		if (statusEffects.len() != 0 || ::Reforged.Mod.ModSettings.getSetting("TacticalTooltip_HeaderForEmptyCategories").getValue() == true)
		{
			::Reforged.TacticalTooltip.pushSectionName(effectList, "效果", currentID);
		}

		currentID++;
		statusEffects.sort(function ( _a, _b )
		{
			return _a.getName()  _b.getName();
		});
		statusEffects.sort(function ( _a, _b )
		{
			if (_a.isType(::Const.SkillType.Injury) && !_b.isType(::Const.SkillType.Injury))
			{
				return -1;
			}
			else if (_b.isType(::Const.SkillType.Injury) && !_a.isType(::Const.SkillType.Injury))
			{
				return 1;
			}

			return 0;
		});
		local extraData = "entityId:" + _actor.getID();

		if (statusEffects.len() < collapseThreshold)
		{
			foreach( statusEffect in statusEffects )
			{
				local effect = {
					id = currentID,
					type = "text",
					icon = statusEffect.getIcon(),
					text = ::Reforged.Mod.Tooltips.parseString(::Reforged.NestedTooltips.getNestedSkillName(statusEffect, extraData, true))
				};
				currentID++;
				effectList.push(effect);
			}
		}
		else
		{
			local entryText = "";

			if (::Reforged.Mod.ModSettings.getSetting("TacticalTooltip_CollapseAsText").getValue())
			{
				foreach( statusEffect in statusEffects )
				{
					entryText = entryText + (::Reforged.NestedTooltips.getNestedSkillName(statusEffect, extraData) + ", ");
				}

				if (entryText != "")
				{
					entryText = entryText.slice(0, -2);
				}
			}
			else
			{
				foreach( statusEffect in statusEffects )
				{
					entryText = entryText + ::Reforged.NestedTooltips.getNestedSkillImage(statusEffect, extraData);
				}
			}

			effectList.push({
				id = currentID,
				type = "text",
				text = ::Reforged.Mod.Tooltips.parseString(entryText)
			});
			currentID++;
		}

		return effectList;
	}

	function getTooltipTraits( _actor, _startID )
	{
		local extraData = "entityId:" + _actor.getID();
		local entryText = "";

		foreach( trait in _actor.getSkills().getAllSkillsOfType(::Const.SkillType.Trait) )
		{
			if (::MSU.isKindOf(trait, "character_background") || ::MSU.isKindOf(trait, "character_trait"))
			{
				entryText = entryText + ::Reforged.NestedTooltips.getNestedSkillImage(trait, extraData);
			}
		}

		local ret = [];
		this.pushSectionName(ret, "特性", _startID);
		_startID = ++_startID;
		ret.push({
			id = _startID,
			type = "text",
			text = ::Reforged.Mod.Tooltips.parseString(entryText)
		});
		return ret;
	}

	function getTooltipPerks( _actor, _startID )
	{
		local currentID = _startID;
		local collapseThreshold = ::Reforged.Mod.ModSettings.getSetting("TacticalTooltip_CollapsePerksWhenX").getValue();
		local perkList = [];
		local perks = _actor.getSkills().query(::Const.SkillType.Perk, true, true);

		if (!::MSU.isKindOf(_actor, "player"))
		{
			perks.extend(_actor.getSkills().query(::Const.SkillType.Trait, true, true));
		}

		if (perks.len() != 0 || ::Reforged.Mod.ModSettings.getSetting("TacticalTooltip_HeaderForEmptyCategories").getValue() == true)
		{
			::Reforged.TacticalTooltip.pushSectionName(perkList, "特技", currentID);
		}

		currentID++;
		local extraData = "entityId:" + _actor.getID();
		perks.sort(function ( a, b )
		{
			return a.m.Name  b.m.Name;
		});

		if (perks.len() < collapseThreshold)
		{
			foreach( i, perk in perks )
			{
				if (::Reforged.Mod.ModSettings.getSetting("TacticalTooltip_ShowStatusPerkAndEffect").getValue() == false)
				{
					if (!perk.isHidden() && perk.isType(::Const.SkillType.StatusEffect))
					{
						continue;
					}
				}

				local perkDef = ::Const.Perks.findById(perk.getID());
				local perkEntry = {
					id = currentID,
					type = "text",
					icon = ::Reforged.Mod.Tooltips.parseString(perkDef != null ? ::Reforged.NestedTooltips.getNestedPerkImage(perk, extraData) : ::Reforged.NestedTooltips.getNestedSkillImage(perk, extraData)),
					text = ::Reforged.Mod.Tooltips.parseString(perkDef != null ? ::Reforged.NestedTooltips.getNestedPerkName(perk, extraData) : ::Reforged.NestedTooltips.getNestedSkillName(perk, extraData))
				};
				currentID++;
				perkList.push(perkEntry);
			}
		}
		else
		{
			local entryText = "";

			if (::Reforged.Mod.ModSettings.getSetting("TacticalTooltip_CollapseAsText").getValue())
			{
				foreach( perk in perks )
				{
					if (::Reforged.Mod.ModSettings.getSetting("TacticalTooltip_ShowStatusPerkAndEffect").getValue() == false)
					{
						if (!perk.isHidden() && perk.isType(::Const.SkillType.StatusEffect))
						{
							continue;
						}
					}

					local perkDef = ::Const.Perks.findById(perk.getID());
					entryText = entryText + ((perkDef != null ? ::Reforged.NestedTooltips.getNestedPerkName(perk, extraData) : ::Reforged.NestedTooltips.getNestedSkillName(perk, extraData)) + ", ");
				}

				if (entryText != "")
				{
					entryText = entryText.slice(0, -2);
				}
			}
			else
			{
				foreach( perk in perks )
				{
					if (::Reforged.Mod.ModSettings.getSetting("TacticalTooltip_ShowStatusPerkAndEffect").getValue() == false)
					{
						if (!perk.isHidden() && perk.isType(::Const.SkillType.StatusEffect))
						{
							continue;
						}
					}

					local perkDef = ::Const.Perks.findById(perk.getID());
					entryText = entryText + (perkDef != null ? ::Reforged.NestedTooltips.getNestedPerkImage(perk, extraData) : ::Reforged.NestedTooltips.getNestedSkillImage(perk, extraData));
				}
			}

			perkList.push({
				id = currentID,
				type = "text",
				text = ::Reforged.Mod.Tooltips.parseString(entryText)
			});
			currentID++;
		}

		return perkList;
	}

	function getTooltipEquippedItems( _actor, _startID )
	{
		local currentID = _startID;
		local itemList = [];
		local mainhandItems = _actor.getItems().getAllItemsAtSlot(::Const.ItemSlot.Mainhand);
		local offhandItems = _actor.getItems().getAllItemsAtSlot(::Const.ItemSlot.Offhand);
		local accessories = _actor.getItems().getAllItemsAtSlot(::Const.ItemSlot.Accessory);

		if (mainhandItems.len() != 0 || offhandItems.len() != 0 || accessories.len() != 0 || ::Reforged.Mod.ModSettings.getSetting("TacticalTooltip_HeaderForEmptyCategories").getValue() == true)
		{
			::Reforged.TacticalTooltip.pushSectionName(itemList, "装备物品", currentID);
		}

		currentID++;
		local actorID = _actor.getID();

		foreach( mainhandItem in mainhandItems )
		{
			itemList.push({
				id = currentID,
				type = "text",
				icon = "ui/items/" + mainhandItem.getIcon(),
				text = ::Reforged.Mod.Tooltips.parseString(this.format("[%s|Item+%s,itemId:%s,itemOwner:entity,entityId:%i]", mainhandItem.getName(), mainhandItem.ClassName, mainhandItem.getInstanceID(), actorID))
			});
			currentID++;
		}

		foreach( offhandItem in offhandItems )
		{
			itemList.push({
				id = currentID,
				type = "text",
				icon = "ui/items/" + offhandItem.getIcon(),
				text = ::Reforged.Mod.Tooltips.parseString(this.format("[%s|Item+%s,itemId:%s,itemOwner:entity,entityId:%i]", offhandItem.getName(), offhandItem.ClassName, offhandItem.getInstanceID(), actorID))
			});
			currentID++;
		}

		foreach( accessory in accessories )
		{
			itemList.push({
				id = currentID,
				type = "text",
				icon = "ui/items/" + accessory.getIcon(),
				text = ::Reforged.Mod.Tooltips.parseString(this.format("[%s|Item+%s,itemId:%s,itemOwner:entity,entityId:%i]", accessory.getName(), accessory.ClassName, accessory.getInstanceID(), actorID))
			});
			currentID++;
		}

		return itemList;
	}

	function getTooltipBagItems( _actor, _startID )
	{
		local currentID = _startID;
		local itemList = [];
		local bagItems = _actor.getItems().getAllItemsAtSlot(::Const.ItemSlot.Bag);

		if (bagItems.len() != 0 || ::Reforged.Mod.ModSettings.getSetting("TacticalTooltip_HeaderForEmptyCategories").getValue() == true)
		{
			::Reforged.TacticalTooltip.pushSectionName(itemList, "背包物品", currentID);
		}

		currentID++;
		local actorID = _actor.getID();

		foreach( bagItem in bagItems )
		{
			itemList.push({
				id = currentID,
				type = "text",
				icon = "ui/items/" + bagItem.getIcon(),
				text = ::Reforged.Mod.Tooltips.parseString(this.format("[%s|Item+%s,itemId:%s,itemOwner:entity,entityId:%i]", bagItem.getName(), bagItem.ClassName, bagItem.getInstanceID(), actorID))
			});
			currentID++;
		}

		return itemList;
	}

	function getGroundItems( _actor, _startID )
	{
		local currentID = _startID;
		local itemList = [];

		if (!_actor.isPlacedOnMap())
		{
			return itemList;
		}

		local groundItems = _actor.getTile().Items;

		if (groundItems.len() != 0)
		{
			::Reforged.TacticalTooltip.pushSectionName(itemList, "地上物品", currentID);
			currentID++;

			foreach( groundItem in groundItems )
			{
				itemList.push({
					id = currentID,
					type = "text",
					icon = "ui/items/" + groundItem.getIcon(),
					text = ::Reforged.Mod.Tooltips.parseString(this.format("[%s|Item+%s,itemId:%s,itemOwner:ground]", groundItem.getName(), groundItem.ClassName, groundItem.getInstanceID()))
				});
				currentID++;
			}
		}

		return itemList;
	}

	function getActiveSkills( _actor, _startID )
	{
		local ret = [];
		local skills = _actor.getSkills().getAllSkillsOfType(::Const.SkillType.Active);

		if (!_actor.m.IsControlledByPlayer && _actor.getFaction() != ::Const.Faction.PlayerAnimals)
		{
			local behaviorSkillIDs = [];

			foreach( b in _actor.getAIAgent().m.Behaviors )
			{
				if (::MSU.isIn("PossibleSkills", b.m, true))
				{
					behaviorSkillIDs.extend(b.m.PossibleSkills);
				}
			}

			for( local i = skills.len() - 1; i >= 0; i-- )
			{
				if (behaviorSkillIDs.find(skills[i].getID()) == null)
				{
					skills.remove(i);
				}
			}
		}

		if (skills.len() != 0 || ::Reforged.Mod.ModSettings.getSetting("TacticalTooltip_HeaderForEmptyCategories").getValue() == true)
		{
			::Reforged.TacticalTooltip.pushSectionName(ret, "主动技能", _startID);
			_startID++;
		}

		local extraData = "entityId:" + _actor.getID();

		if (skills.len() < ::Reforged.Mod.ModSettings.getSetting("TacticalTooltip_CollapseActivesWhenX").getValue())
		{
			foreach( skill in skills )
			{
				ret.push({
					id = _startID++,
					type = "text",
					icon = skill.getIcon(),
					text = ::Reforged.Mod.Tooltips.parseString(this.format("%s (%s, %s)", ::Reforged.NestedTooltips.getNestedSkillName(skill, extraData), ::MSU.Text.colorNegative(skill.getActionPointCost()), ::MSU.Text.colorPositive(skill.getFatigueCost())))
				});
			}
		}
		else
		{
			local entryText = "";

			if (::Reforged.Mod.ModSettings.getSetting("TacticalTooltip_CollapseAsText").getValue())
			{
				foreach( skill in skills )
				{
					entryText = entryText + (::Reforged.NestedTooltips.getNestedSkillName(skill, extraData) + ", ");
				}

				if (entryText != "")
				{
					entryText = entryText.slice(0, -2);
				}
			}
			else
			{
				foreach( skill in skills )
				{
					entryText = entryText + ::Reforged.NestedTooltips.getNestedSkillImage(skill, extraData, true);
				}
			}

			ret.push({
				id = _startID,
				type = "text",
				text = ::Reforged.Mod.Tooltips.parseString(entryText)
			});
		}

		return ret;
	}

	function getSpacebars( _amount )
	{
		local ret = "";

		for( local i = 0; i < _amount; i++ )
		{
			ret = ret + "&nbsp;";
		}

		return ret;
	}

	function getAttributeEntry( _icon, _currentValue, _difference )
	{
		local bracketsTextSize = 10;
		local entryText = "[img]gfx/ui/icons/" + _icon + "[/img] " + _currentValue;

		if (_difference != 0)
		{
			entryText = entryText + ("[size=" + bracketsTextSize + "] (" + ::MSU.Text.colorizeValue(_difference) + ")[/size]");
		}

		return entryText;
	}

	function underlineFirstCharacter( _string )
	{
		if (_string.len() == 0)
		{
			return "";
		}

		return "[u]" + _string.slice(0, 1) + "[/u]" + _string.slice(1);
	}

	function pushSectionName( _list, _title, _startID )
	{
		_list.push({
			id = _startID,
			type = "text",
			text = "[u][size=15]" + _title + "[/size][/u]"
		});
	}

};
