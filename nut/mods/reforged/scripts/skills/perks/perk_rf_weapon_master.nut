this.perk_rf_weapon_master <- ::inherit("scripts/skills/skill", {
	m = {
		OldPerks = [],
		PerksAdded = []
	},
	function create()
	{
		this.m.ID = "perk.rf_weapon_master";
		this.m.Name = ::Const.Strings.PerkName.RF_WeaponMaster;
		this.m.Description = "该角色善用各种武器。";
		this.m.Icon = "ui/perks/perk_rf_weapon_master.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Any;
	}

	function onAdded()
	{
		local weapon = this.getContainer().getActor().getMainhandItem();

		if (weapon != null)
		{
			this.onEquip(weapon);
		}
	}

	function onRemoved()
	{
		local equippedItem = this.getContainer().getActor().getMainhandItem();

		if (equippedItem != null)
		{
			this.getContainer().getActor().getItems().unequip(equippedItem);
			this.getContainer().getActor().getItems().equip(equippedItem);
		}
	}

	function onPayForItemAction( _skill, _items )
	{
		this.removeOldPerks();
	}

	function onEquip( _item )
	{
		if (!_item.isItemType(::Const.Items.ItemType.Weapon))
		{
			return;
		}

		this.m.PerksAdded.clear();
		local hasSkill = function ( _id )
		{
			if (this.getContainer().hasSkill(_id))
			{
				return true;
			}

			foreach( s in this.getContainer().m.SkillsToAdd )
			{
				if (s.getID() == _id && !s.isGarbage())
				{
					return true;
				}
			}

			return false;
		};
		local hasPerkFromGroup = function ( _group, _tierStart, _tierEnd )
		{
			local tree = _group.getTree();

			for( local i = _tierStart - 1; i < _tierEnd; i++ )
			{
				foreach( perkID in tree[i] )
				{
					if (hasSkill(perkID))
					{
						return true;
					}
				}
			}

			return false;
		};
		local addPerkFromGroup = function ( _group, _tierStart, _tierEnd )
		{
			local tree = _group.getTree();

			for( local i = _tierStart - 1; i < _tierEnd; i++ )
			{
				local row = tree[i];

				if (row.len() != 0)
				{
					local perkID = row[0];
					this.m.PerksAdded.push(perkID);
					this.getContainer().add(::Reforged.new(::Const.Perks.findById(perkID).Script, function ( o )
					{
						o.m.IsSerialized = false;
						o.m.IsRefundable = false;
					}));
					break;
				}
			}
		};
		local perkTree = this.getContainer().getActor().getPerkTree();
		local allWeaponPGs = [];
		local equippedweaponPGs = [];

		foreach( weaponTypeName, weaponType in ::Const.Items.WeaponType )
		{
			if (weaponTypeName == "Firearm")
			{
				weaponTypeName = "弩";
			}

			local pg = ::DynamicPerks.PerkGroups.findById("pg.rf_" + weaponTypeName.tolower());

			if (pg == null)
			{
				continue;
			}

			if (perkTree.hasPerkGroup(pg.getID()))
			{
				allWeaponPGs.push(pg);
			}

			if (_item.isWeaponType(weaponType) && equippedweaponPGs.find(pg) == null)
			{
				equippedweaponPGs.push(pg);
			}
		}

		local tierRanges = [
			[
				1,
				3
			],
			[
				4,
				4
			]
		];

		if (equippedweaponPGs.len() == 1)
		{
			tierRanges.push([
				5,
				7
			]);
		}

		for( local i = tierRanges.len() - 1; i >= 0; i-- )
		{
			local range = tierRanges[i];
			local isValid = false;

			foreach( pg in allWeaponPGs )
			{
				if (hasPerkFromGroup(pg, range[0], range[1]))
				{
					isValid = true;
					break;
				}
			}

			if (!isValid)
			{
				tierRanges.remove(i);
			}
		}

		equippedweaponPGs = equippedweaponPGs.filter(function ( _, _pg )
		{
			return perkTree.hasPerkGroup(_pg.getID());
		});

		foreach( range in tierRanges )
		{
			foreach( pg in equippedweaponPGs )
			{
				addPerkFromGroup(pg, range[0], range[1]);
			}
		}
	}

	function onUnequip( _item )
	{
		if (!_item.isItemType(::Const.Items.ItemType.Weapon))
		{
			return;
		}

		if (::Tactical.isActive())
		{
			this.m.OldPerks = clone this.m.PerksAdded;
		}
		else
		{
			this.removePerks();
		}
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.removeOldPerks();
	}

	function removePerks()
	{
		foreach( perkID in this.m.PerksAdded )
		{
			this.getContainer().removeByStackByID(perkID, false);
		}

		this.m.PerksAdded.clear();
		this.removeOldPerks();
	}

	function removeOldPerks()
	{
		foreach( perkID in this.m.OldPerks )
		{
			this.getContainer().removeByStackByID(perkID, false);
		}

		this.m.OldPerks.clear();
	}

});
