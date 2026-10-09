::Reforged.HooksMod.hook("scripts/skills/racial/schrat_racial", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Name = "树人";
				this.m.Icon = "ui/orientation/schrat_01_orientation.png";
				this.m.IsHidden = false;
			}

		}.create;
	};
	q.isHidden = function ( __original )
	{
		return {
			function isHidden()
			{
				return this.skill.isHidden();
			}

		}.isHidden;
	};
	q.getName = function ()
	{
		return {
			function getName()
			{
				if (this.getContainer().getActor().isArmedWithShield())
				{
					return this.skill.getName() + " (持盾)";
				}

				return this.skill.getName();
			}

		}.getName;
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
						text = ::MSU.Text.colorNegative("75%") + " less ranged piercing damage received"
					},
					{
						id = 12,
						type = "text",
						icon = "ui/icons/campfire.png",
						text = ::MSU.Text.colorPositive("100%") + " more burning damage received"
					},
					{
						id = 20,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("不受[$ $|Skill+night_effect]惩罚影响")
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
						text = ::Reforged.Mod.Tooltips.parseString("免疫[$ $|Skill+disarmed_effect]")
					},
					{
						id = 26,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("免疫[$ $|Concept.Rooted]")
					},
					{
						id = 27,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("免疫[$ $|Skill+stunned_effect]")
					}
				]);

				if (this.getContainer().getActor().isArmedWithShield())
				{
					ret.push({
						id = 30,
						type = "text",
						icon = "skills/status_effect_86.png",
						text = ::MSU.Text.colorNegative("70%") + " reduced damage received while this character is shielded"
					});
				}

				return ret;
			}

		}.getTooltip;
	};
	q.onAdded = function ()
	{
		return {
			function onAdded()
			{
				local baseProperties = this.getContainer().getActor().getBaseProperties();
				baseProperties.IsAffectedByInjuries = false;
				baseProperties.IsAffectedByNight = false;
				baseProperties.IsImmuneToBleeding = true;
				baseProperties.IsImmuneToDisarm = true;
				baseProperties.IsImmuneToKnockBackAndGrab = true;
				baseProperties.IsImmuneToPoison = true;
				baseProperties.IsImmuneToRoot = true;
				baseProperties.IsImmuneToStun = true;
				baseProperties.IsIgnoringArmorOnAttack = true;
			}

		}.onAdded;
	};
	q.onUpdate = function ( __original )
	{
		return {
			function onUpdate( _properties )
			{
				local old_DamageReceivedFireMult = _properties.DamageReceivedFireMult;
				__original(_properties);
				_properties.DamageReceivedFireMult = old_DamageReceivedFireMult;
			}

		}.onUpdate;
	};
	q.onBeforeDamageReceived = function ()
	{
		return {
			function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
			{
				switch(_hitInfo.DamageType)
				{
				case null:
					break;

				case ::Const.Damage.DamageType.Burning:
					_properties.DamageReceivedRegularMult *= 2.0;
					break;

				case ::Const.Damage.DamageType.Piercing:
					if (_skill == null)
					{
						_properties.DamageReceivedRegularMult *= 0.5;
					}
					else if (_skill.isRanged())
					{
						_properties.DamageReceivedRegularMult *= 0.25;
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
	q.onDamageReceived = function ()
	{
		return function ( _attacker, _damageHitpoints, _damageArmor )
		{
		};
	};
});
