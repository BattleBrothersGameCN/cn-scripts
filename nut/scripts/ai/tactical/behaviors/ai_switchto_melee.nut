this.ai_switchto_melee <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		WeaponToEquip = null,
		IsNegatingDisarm = false
	},
	function create()
	{
		this.m.ID = this.Const.AI.Behavior.ID.SwitchToMelee;
		this.m.Order = this.Const.AI.Behavior.Order.SwitchToMelee;
		this.behavior.create();
	}

	function onEvaluate( _entity )
	{
		this.m.WeaponToEquip = null;
		this.m.IsNegatingDisarm = false;
		local scoreMult = this.getProperties().BehaviorMult[this.m.ID];

		if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (_entity.getCurrentProperties().IsStunned)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (!this.getAgent().hasVisibleOpponent())
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		local skills = _entity.getSkills();
		local quickHands = skills.getSkillByID("perk.quick_hands");
		local hasQuickHands = quickHands != null && !quickHands.isSpent();

		if (!hasQuickHands && _entity.getActionPoints() < this.Const.Tactical.Settings.SwitchItemAPCost && _entity.getActionPoints() < this.Const.Tactical.Settings.SwitchTwoHanderAPCost && _entity.getActionPoints() < this.Const.Tactical.Settings.SwitchShieldAPCost)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		local bagItems = _entity.getItems().getAllItemsAtSlot(this.Const.ItemSlot.Bag);
		local item = _entity.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		local attackSkill = skills.getAttackOfOpportunity();

		if (item != null && item.isItemType(this.Const.Items.ItemType.MeleeWeapon) && !_entity.getCurrentProperties().IsAbleToUseWeaponSkills && hasQuickHands && _entity.getActionPoints() == _entity.getActionPointsMax() && attackSkill != null && attackSkill.getActionPointCost() <= 4)
		{
			if (bagItems.len() < _entity.getItems().getUnlockedBagSlots() || bagItems.filter(function ( i, v )
			{
				return !v.isItemType(this.Const.Items.ItemType.Shield);
			}).len() > 0)
			{
				this.m.IsNegatingDisarm = true;
				return this.Const.AI.Behavior.Score.SwitchToMelee * scoreMult * this.Const.AI.Behavior.SwitchToCounterDisarm;
			}
		}

		if (bagItems.len() == 0)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (item != null && item.isItemType(this.Const.Items.ItemType.RangedWeapon))
		{
			local isGoodReason = false;
			local myTile = _entity.getTile();

			if (item.getAmmoMax() > 0 && item.getAmmo() == 0)
			{
				this.logInfo("切换到近战武器 - 没有弹药！");
				isGoodReason = true;
				scoreMult = scoreMult * this.Const.AI.Behavior.SwitchToOutOfAmmoMult;
			}

			if (this.getAgent().getBehavior(this.Const.AI.Behavior.ID.EngageRanged) == null)
			{
				if (this.getStrategy().isDefending() && (this.getStrategy().getStats().EnemyRangedFiring > 0 || this.getStrategy().getStats().AllyRangedFiring > 0))
				{
				}
				else
				{
					local targets = this.queryTargetsInMeleeRange(this.Math.min(item.getRangeMin(), _entity.getCurrentProperties().Vision), this.Math.min(item.getRangeMax(), _entity.getCurrentProperties().Vision) + myTile.Level, 3);
					local bestTarget = this.queryBestRangedTarget(_entity, null, targets, this.Math.min(item.getRangeMax(), _entity.getCurrentProperties().Vision));

					if (bestTarget.Target == null || bestTarget.Score < 0)
					{
						this.logInfo("切换为近战武器——此处没有可攻击的目标！");
						isGoodReason = true;
						scoreMult = scoreMult * this.Const.AI.Behavior.SwitchToEnemyInRangeMult;
					}
				}
			}

			if (!isGoodReason && this.getAgent().getIntentions().IsChangingWeapons)
			{
				return this.Const.AI.Behavior.Score.Zero;
			}

			if (!isGoodReason)
			{
				local hasReducedRangedEffectiveness = !this.World.getTime().IsDaytime && _entity.getCurrentProperties().IsAffectedByNight;
				local targets = this.queryTargetsInMeleeRange(1, hasReducedRangedEffectiveness || !this.isRangedUnit(_entity) ? 1 : 1);

				if (targets.len() == 0)
				{
					return this.Const.AI.Behavior.Score.Zero;
				}
			}
		}

		local bestWeapon;

		if (item != null && item.isItemType(this.Const.Items.ItemType.MeleeWeapon))
		{
			bestWeapon = item;
		}

		foreach( it in bagItems )
		{
			if (!it.isItemType(this.Const.Items.ItemType.MeleeWeapon))
			{
				continue;
			}

			if (it.getBlockedSlotType() != null && _entity.getActionPoints() < this.Const.Tactical.Settings.SwitchTwoHanderAPCost || _entity.getActionPoints() < this.Const.Tactical.Settings.SwitchItemAPCost)
			{
				continue;
			}

			if (bestWeapon == null || this.getWeaponScore(it) > this.getWeaponScore(bestWeapon))
			{
				bestWeapon = it;
			}
		}

		if (bestWeapon == null || item != null && bestWeapon.getID() == item.getID())
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		this.m.WeaponToEquip = bestWeapon;

		if (hasQuickHands)
		{
			scoreMult = scoreMult * this.Const.AI.Behavior.SwitchToQuickHandsMult;
		}
		else if (quickHands != null)
		{
			scoreMult = scoreMult * this.Const.AI.Behavior.AlreadySwitchedMult;
		}

		if (item == null)
		{
			scoreMult = scoreMult * this.Const.AI.Behavior.SwitchToCurrentlyUnarmedMult;
		}

		if (!_entity.getCurrentProperties().IsAbleToUseWeaponSkills)
		{
			scoreMult = scoreMult * this.Const.AI.Behavior.SwitchWeaponBecauseDisarmedMult;
		}

		if (skills.hasSkill("special.night"))
		{
			scoreMult = scoreMult * this.Const.AI.Behavior.SwitchToMeleeAtNightMult;
		}

		return this.Const.AI.Behavior.Score.SwitchToMelee * scoreMult;
	}

	function onExecute( _entity )
	{
		local oldWeapon = _entity.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		local bagItems = _entity.getItems().getAllItemsAtSlot(this.Const.ItemSlot.Bag);
		local offhand = _entity.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		local itemsToSwap = [];

		if (oldWeapon != null)
		{
			itemsToSwap.push(oldWeapon);
		}

		if (bagItems.len() == _entity.getItems().getUnlockedBagSlots())
		{
			foreach( item in bagItems )
			{
				if (item.isItemType(this.Const.Items.ItemType.Shield))
				{
					continue;
				}

				if (item.getBlockedSlotType() != null && offhand != null)
				{
					continue;
				}

				itemsToSwap.push(item);
				break;
			}
		}

		if (this.m.IsNegatingDisarm)
		{
			_entity.getSkills().removeByID("effects.disarmed");
			_entity.getItems().payForAction(itemsToSwap);
			_entity.getItems().payForAction(itemsToSwap);
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_entity) + "再次装备了他们的武器");

			if (this.Const.AI.VerboseMode)
			{
				this.logInfo("* " + _entity.getName() + "：以武器反制缴械 \'" + oldWeapon.getID() + "\'!");
			}

			this.m.IsNegatingDisarm = false;
			this.m.WeaponToEquip = null;
			return true;
		}

		if (this.Const.AI.VerboseMode)
		{
			this.logInfo("* " + _entity.getName() + "：切换到近战武器 \'" + this.m.WeaponToEquip.getID() + "\'!");
		}

		if (oldWeapon != null)
		{
			_entity.getItems().unequip(oldWeapon);
		}

		itemsToSwap.push(this.m.WeaponToEquip);
		_entity.getItems().removeFromBag(this.m.WeaponToEquip);

		if (this.m.WeaponToEquip.getBlockedSlotType() != null && offhand != null)
		{
			local slotsRequired = 1;
			itemsToSwap.push(offhand);

			if (oldWeapon != null)
			{
				slotsRequired = ++slotsRequired;
			}

			if (_entity.getItems().getNumberOfEmptySlots(this.Const.ItemSlot.Bag) >= slotsRequired)
			{
				_entity.getItems().unequip(offhand);
				_entity.getItems().addToBag(offhand);
			}
			else
			{
				offhand.drop(_entity.getTile());
			}
		}

		_entity.getItems().equip(this.m.WeaponToEquip);

		if (oldWeapon != null)
		{
			_entity.getItems().addToBag(oldWeapon);
		}

		_entity.getItems().payForAction(itemsToSwap);
		this.m.WeaponToEquip = null;
		this.getAgent().getIntentions().IsChangingWeapons = true;
		return true;
	}

	function getWeaponScore( weapon )
	{
		if (weapon == null)
		{
			return 0.0;
		}

		if (!weapon.isItemType(this.Const.Items.ItemType.MeleeWeapon))
		{
			return 0.0;
		}

		local score = 0.0;
		score = score + weapon.getValue() / 1000;
		score = score + weapon.getDamageMax() * (weapon.isDoubleGrippable() ? this.Const.Combat.DoubleGripDamageMult : 1.0) / 100;
		return score;
	}

});
