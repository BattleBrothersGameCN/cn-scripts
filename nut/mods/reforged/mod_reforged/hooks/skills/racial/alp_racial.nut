::Reforged.HooksMod.hook("scripts/skills/racial/alp_racial", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Name = "梦魇";
				this.m.Icon = "ui/orientation/alp_01_orientation.png";
				this.m.IsHidden = false;
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
						icon = "ui/icons/melee_defense.png",
						text = ::MSU.Text.colorNegative("66%") + " less cutting damage received from dogs and wolves"
					},
					{
						id = 13,
						type = "text",
						icon = "ui/icons/health.png",
						text = ::Reforged.Mod.Tooltips.parseString("该角色受到[生命值|Concept.Hitpoints]伤害时，将所有梦魇传送到接近敌人的随机新位置")
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
				local baseProperties = this.getContainer().getActor().getBaseProperties();
				baseProperties.IsAffectedByInjuries = false;
				baseProperties.IsAffectedByNight = false;
				baseProperties.IsImmuneToBleeding = true;
				baseProperties.IsImmuneToDisarm = true;
				baseProperties.IsImmuneToKnockBackAndGrab = true;
				baseProperties.IsImmuneToPoison = true;
			}

		}.onAdded;
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

				case ::Const.Damage.DamageType.Cutting:
					if (_skill != null && (_skill.getID() == "actives.wardog_bite" || _skill.getID() == "actives.wolf_bite" || _skill.getID() == "actives.warhound_bite"))
					{
						_properties.DamageReceivedRegularMult *= 0.33;
					}

					break;
				}
			}

		}.onBeforeDamageReceived;
	};
});
