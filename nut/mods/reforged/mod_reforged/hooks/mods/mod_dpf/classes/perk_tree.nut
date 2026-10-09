::Reforged.HooksMod.hook(::DynamicPerks.Class.PerkTree, function ( q )
{
	q.m.ProjectedAttributesAvg <- null;
	q.setupProjectedAttributesAvg <- {
		function setupProjectedAttributesAvg()
		{
			this.m.ProjectedAttributesAvg = {};
			local actor = this.getActor();
			local talents = actor.getTalents();
			local properties = this.getActor().getBaseProperties().getClone();
			local wasUpdating = actor.getSkills().m.IsUpdating;
			actor.getSkills().m.IsUpdating = true;

			foreach( s in this.getActor().getSkills().getSkillsByFunction(function ( _skill )
			{
				return _skill.isType(::Const.SkillType.Trait) || _skill.isType(::Const.SkillType.PermanentInjury);
			}) )
			{
				s.onUpdate(properties);
			}

			actor.getSkills().m.IsUpdating = wasUpdating;

			foreach( attributeName, attribute in ::Const.Attributes )
			{
				if (attribute == ::Const.Attributes.COUNT)
				{
					continue;
				}

				local attributeMin = ::Const.AttributesLevelUp[attribute].Min;
				local attributeMax = ::Const.AttributesLevelUp[attribute].Max;

				if (talents.len() != 0)
				{
					attributeMin = attributeMin + ::Math.min(talents[attribute], 2);
					attributeMax = attributeMax + (talents[attribute] == 3 ? 1 : 0);
				}

				local attributeAvg = (attributeMin + attributeMax) * 0.5;
				properties[attributeName == "Fatigue" ? "Stamina" : attributeName] += ::Math.round(attributeAvg * ::Math.max(::Const.XP.MaxLevelWithPerkpoints - actor.getLevel() + actor.getLevelUps(), 0));
				local value;

				switch(attributeName)
				{
				case "Fatigue":
				case "Hitpoints":
					local originalCurrentProperties = actor.getCurrentProperties();
					actor.m.CurrentProperties = properties;
					value = actor["get" + attributeName + "Max"]();
					actor.m.CurrentProperties = originalCurrentProperties;
					break;

				default:
					value = properties["get" + attributeName]();
				}

				this.m.ProjectedAttributesAvg[attribute] <- value;
			}
		}

	}.setupProjectedAttributesAvg;
	q.buildFromDynamicMap = function ( __original )
	{
		return {
			function buildFromDynamicMap()
			{
				if (!::MSU.isNull(this.getActor()))
				{
					this.setupProjectedAttributesAvg();
				}

				__original();
				this.m.ProjectedAttributesAvg = null;
			}

		}.buildFromDynamicMap;
	};
	q.getProjectedAttributesAvg <- {
		function getProjectedAttributesAvg()
		{
			if (this.m.ProjectedAttributesAvg == null)
			{
				this.setupProjectedAttributesAvg();
			}

			return this.m.ProjectedAttributesAvg;
		}

	}.getProjectedAttributesAvg;
	q.getPerkGroupMultiplierSources_All = function ( __original )
	{
		return {
			function getPerkGroupMultiplierSources_All()
			{
				if (this.getActor().getBackground().getPerkGroupCollectionMin(::DynamicPerks.PerkGroupCategories.findById("pgc.rf_weapon")) <= 3)
				{
					return __original();
				}

				local ret = __original();
				local weapon = this.getActor().getMainhandItem();

				if (!::MSU.isNull(weapon) && weapon.isItemType(::Const.Items.ItemType.Weapon))
				{
					local ids = ::Reforged.getWeaponPerkGroups(weapon);

					if (ids.len() != 0)
					{
						local id = ::MSU.Array.rand(ids);
						ret.push({
							function getPerkGroupMultiplier( _groupID, _perkTree )
							{
								if (_groupID == id)
								{
									return -1;
								}
							}

						});
						  // [063]  OP_CLOSE          0      4    0    0
					}
				}

				return ret;
			}

		}.getPerkGroupMultiplierSources_All;
	};
});
