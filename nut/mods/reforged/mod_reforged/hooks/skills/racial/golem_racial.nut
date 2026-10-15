::Reforged.HooksMod.hook("scripts/skills/racial/golem_racial", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Name = "魔像";
				this.m.Icon = "ui/orientation/sand_golem_orientation.png";
				this.m.IsHidden = false;
				this.addType(::Const.SkillType.StatusEffect);
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.skill.getTooltip();
				ret.extend([
					{
						id = 10,
						type = "text",
						icon = "ui/icons/melee_defense.png",
						text = ::MSU.Text.colorNegative("50%") + " less melee piercing damage received"
					},
					{
						id = 11,
						type = "text",
						icon = "ui/icons/ranged_defense.png",
						text = ::MSU.Text.colorNegative("66%") + " less ranged piercing and ranged blunt damage received"
					},
					{
						id = 12,
						type = "text",
						icon = "ui/icons/campfire.png",
						text = ::MSU.Text.colorNegative("90%") + " less fire damage received"
					},
					{
						id = 21,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("不会受到[临时创伤|Concept.InjuryTemporary]，也不会被其影响。")
					},
					{
						id = 22,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("免疫[$ $|Skill+bleeding_effect]")
					},
					{
						id = 23,
						type = "text",
						icon = "ui/icons/special.png",
						text = "免疫毒素"
					},
					{
						id = 24,
						type = "text",
						icon = "ui/icons/special.png",
						text = "免疫击退和钩拽"
					},
					{
						id = 25,
						type = "text",
						icon = "ui/icons/special.png",
						text = "免疫火焰"
					},
					{
						id = 26,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("免疫[$ $|Skill+disarmed_effect]")
					},
					{
						id = 27,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("免疫[$ $|Skill+stunned_effect]")
					},
					{
						id = 28,
						type = "text",
						icon = "ui/icons/morale.png",
						text = ::Reforged.Mod.Tooltips.parseString("不受[士气|Concept.Morale]影响")
					},
					{
						id = 29,
						type = "text",
						icon = "ui/icons/special.png",
						text = "不会被命中头部"
					}
				]);
				return ret;
			}

		}.getTooltip;
	};
	q.onAdded = function ()
	{
		return {
			function onAdded()
			{
				local actor = this.getContainer().getActor();
				actor.m.MoraleState = ::Const.MoraleState.Ignore;
				local baseProperties = actor.getBaseProperties();
				baseProperties.IsAffectedByInjuries = false;
				baseProperties.IsAffectedByNight = false;
				baseProperties.IsImmuneToBleeding = true;
				baseProperties.IsImmuneToDisarm = true;
				baseProperties.IsImmuneToFire = true;
				baseProperties.IsImmuneToHeadshots = true;
				baseProperties.IsImmuneToPoison = true;
				baseProperties.IsImmuneToStun = true;
			}

		}.onAdded;
	};
	q.onBeforeDamageReceived = function ()
	{
		return {
			function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
			{
				if (_skill != null && _skill.getID() == "actives.throw_golem")
				{
					_properties.DamageReceivedTotalMult = 0.0;
					return;
				}

				switch(_hitInfo.DamageType)
				{
				case null:
					break;

				case ::Const.Damage.DamageType.Burning:
					_properties.DamageReceivedRegularMult *= 0.1;
					break;

				case ::Const.Damage.DamageType.Blunt:
					if (_skill != null)
					{
						if (_skill.isRanged())
						{
							_properties.DamageReceivedRegularMult *= 0.33;
						}
					}

					break;

				case ::Const.Damage.DamageType.Piercing:
					if (_skill == null)
					{
						_properties.DamageReceivedRegularMult *= 0.5;
					}
					else if (_skill.isRanged())
					{
						_properties.DamageReceivedRegularMult *= 0.33;
					}
					else
					{
						_properties.DamageReceivedRegularMult *= 0.5;
					}

					break;
				}
			}

		}.onBeforeDamageReceived;
	};
});
