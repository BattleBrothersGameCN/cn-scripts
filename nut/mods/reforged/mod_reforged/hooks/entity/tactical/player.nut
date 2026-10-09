::Reforged.HooksMod.hook("scripts/entity/tactical/player", function ( q )
{
	q.getTooltip = function ()
	{
		return {
			function getTooltip( _targetedWithSkill = null )
			{
				return this.actor.getTooltip(_targetedWithSkill);
			}

		}.getTooltip;
	};
	q.onInit = function ( __original )
	{
		return {
			function onInit()
			{
				__original();
				this.getSkills().add(::new("scripts/skills/actives/rf_adjust_dented_armor_ally_skill"));
				this.getSkills().add(::new("scripts/skills/effects/rf_encumbrance_effect"));
				this.getSkills().add(::new("scripts/skills/special/rf_veteran_levels"));
				this.getSkills().add(::new("scripts/skills/special/rf_naked"));
			}

		}.onInit;
	};
	q.addXP = function ( __original )
	{
		return {
			function addXP( _xp, _scale = true )
			{
				if (::Reforged.Config.XPOverride)
				{
					return;
				}

				if (("State" in ::World) && ::World.State != null && _scale && ::World.Retinue.hasFollower("follower.drill_sergeant"))
				{
					_xp = _xp * ::Math.maxf(1.0, 1.1666 - 0.0166 * (this.m.Level - 1));
				}

				return __original(_xp, _scale);
			}

		}.addXP;
	};
	q.getProjectedAttributes <- {
		function getProjectedAttributes()
		{
			local properties = this.getBaseProperties().getClone();
			local wasUpdating = this.getSkills().m.IsUpdating;
			this.getSkills().m.IsUpdating = true;

			foreach( s in this.getSkills().getSkillsByFunction(function ( _skill )
			{
				return _skill.isType(::Const.SkillType.Trait) || _skill.isType(::Const.SkillType.PermanentInjury);
			}) )
			{
				s.onUpdate(properties);
			}

			this.getSkills().m.IsUpdating = wasUpdating;
			local getProjection = function ( _attributeName, _flatChange )
			{
				local propertyName = _attributeName == "Fatigue" ? "Stamina" : _attributeName;
				local ret = 0;
				properties[propertyName] += _flatChange;

				switch(_attributeName)
				{
				case "Fatigue":
				case "Hitpoints":
					ret = this["get" + _attributeName + "Max"]();
					break;

				default:
					ret = properties["get" + _attributeName]();
				}

				properties[propertyName] -= _flatChange;
				return ret;
			};
			local levelUpsRemaining = ::Math.max(::Const.XP.MaxLevelWithPerkpoints - this.getLevel() + this.getLevelUps(), 0);
			local original_CurrentProperties = this.m.CurrentProperties;
			this.m.CurrentProperties = properties;
			local ret = {};

			foreach( attributeName, attribute in ::Const.Attributes )
			{
				if (attribute == ::Const.Attributes.COUNT)
				{
					continue;
				}

				local levelupMin = ::Const.AttributesLevelUp[attribute].Min + ::Math.min(this.m.Talents[attribute], 2);
				local levelupMax = ::Const.AttributesLevelUp[attribute].Max;

				if (this.m.Talents[attribute] == 3)
				{
					levelupMax++;
				}

				local attributeTotalMod = 0;

				if (this.m.Talents[attribute] == 2)
				{
					foreach( value in this.m.Attributes[attribute] )
					{
						if (value != levelupMax)
						{
							attributeTotalMod++;
						}
					}
				}

				ret[attribute] <- [
					getProjection(attributeName, levelupMin * levelUpsRemaining - attributeTotalMod),
					getProjection(attributeName, levelupMax * levelUpsRemaining + attributeTotalMod)
				];
			}

			this.m.CurrentProperties = original_CurrentProperties;
			return ret;
		}

	}.getProjectedAttributes;
	q.isHired <- {
		function isHired()
		{
			return this.getPlaceInFormation() != 255;
		}

	}.isHired;
	q.MV_getMaxStartingTraits = function ()
	{
		return {
			function MV_getMaxStartingTraits()
			{
				return 2;
			}

		}.MV_getMaxStartingTraits;
	};
	q.fillAttributeLevelUpValues = function ( __original )
	{
		return {
			function fillAttributeLevelUpValues( _amount, _maxOnly = false, _minOnly = false )
			{
				__original(_amount, _maxOnly, _minOnly);

				if (_amount < 2)
				{
					return;
				}

				if (_maxOnly || _minOnly)
				{
					return;
				}

				for( local i = 0; i != ::Const.Attributes.COUNT; i++ )
				{
					if (this.m.Talents[i] == 2)
					{
						local indices = this.array(_amount);

						foreach( j, _ in indices )
						{
							indices[j] = j;
						}

						for( local j = 0; j < _amount / 2; j++ )
						{
							this.m.Attributes[i][indices.remove(::Math.rand(0, indices.len() - 1))] += ::Math.rand(0, 1) == 0 ? -1 : 1;
						}
					}
				}
			}

		}.fillAttributeLevelUpValues;
	};
	q.setAttributeLevelUpValues = function ( __original )
	{
		return {
			function setAttributeLevelUpValues( _v )
			{
				__original(_v);
				local discoveredTalent = this.getSkills().getSkillByID("perk.rf_discovered_talent");

				if (discoveredTalent != null)
				{
					discoveredTalent.addStars();
				}
			}

		}.setAttributeLevelUpValues;
	};
	q.onDeserialize = function ( __original )
	{
		return {
			function onDeserialize( _in )
			{
				__original(_in);
				::Reforged.expandLevelXP(this.m.Level + 2);
			}

		}.onDeserialize;
	};
});
::Reforged.QueueBucket.Late.push(function ()
{
	::Reforged.HooksMod.hook("scripts/entity/tactical/player", function ( q )
	{
		q.getXPForNextLevel = function ( __original )
		{
			return {
				function getXPForNextLevel()
				{
					::Reforged.expandLevelXP(this.m.Level + 2);
					return __original();
				}

			}.getXPForNextLevel;
		};
		q.updateLevel = function ( __original )
		{
			return {
				function updateLevel()
				{
					while (this.m.XP >= ::Const.LevelXP.top())
					{
						::Reforged.expandLevelXP(::Const.LevelXP.len() + 1);
					}

					__original();
				}

			}.updateLevel;
		};
	});
});
