::Reforged.HooksMod.hook("scripts/skills/racial/skeleton_racial", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Name = "骷髅";
				this.m.Icon = "ui/orientation/skeleton_01_orientation.png";
				this.m.IsHidden = false;

				if (this.isType(::Const.SkillType.Perk))
				{
					this.removeType(::Const.SkillType.Perk);
				}
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
						text = ::MSU.Text.colorNegative("66%") + " less ranged piercing damage received"
					},
					{
						id = 12,
						type = "text",
						icon = "ui/icons/campfire.png",
						text = ::MSU.Text.colorNegative("75%") + " less burning damage received"
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
						text = ::Reforged.Mod.Tooltips.parseString("不会受到[临时创伤|Concept.InjuryTemporary]")
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
						text = ::Reforged.Mod.Tooltips.parseString("免疫毒素")
					},
					{
						id = 24,
						type = "text",
						icon = "ui/icons/morale.png",
						text = ::Reforged.Mod.Tooltips.parseString("不受[士气|Concept.Morale]影响")
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
				baseProperties.IsImmuneToPoison = true;
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
					_properties.DamageReceivedRegularMult *= 0.25;
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
