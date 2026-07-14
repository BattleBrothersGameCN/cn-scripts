::Reforged.HooksMod.hook("scripts/skills/special/double_grip", function ( q )
{
	q.m.CurrWeaponType <- null;
	q.m.MeleeDamageMult_Dagger <- 1.25;
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "副手空空，这个角色可以更灵活地战斗，或是两手紧握他的武器，造成额外伤害。";
				this.m.Order = ::Const.SkillOrder.First;
			}

		}.create;
	};
	q.canDoubleGrip = function ()
	{
		return {
			function canDoubleGrip()
			{
				local actor = this.getContainer().getActor();

				if (actor.isDisarmed())
				{
					return false;
				}

				local weapon = actor.getMainhandItem();

				if (weapon == null || !weapon.isDoubleGrippable())
				{
					return false;
				}

				local offhand = actor.getOffhandItem();

				if (offhand == null)
				{
					return true;
				}

				local engarde = this.getContainer().getSkillByID("perk.rf_en_garde");

				if (engarde != null)
				{
					return engarde.isWeaponValid(weapon) && engarde.isOffhandItemValid(offhand);
				}

				return false;
			}

		}.canDoubleGrip;
	};
	q.applyBonusOnUpdate <- {
		function applyBonusOnUpdate( _properties )
		{
			switch(this.m.CurrWeaponType)
			{
			case ::Const.Items.WeaponType.Axe:
				_properties.MeleeDamageMult *= 1.15;
				_properties.DamageDirectAdd += 0.15;
				_properties.HitChance[::Const.BodyPart.Head] += 20;
				break;

			case ::Const.Items.WeaponType.Cleaver:
				_properties.MeleeDamageMult *= 1.3;
				break;

			case ::Const.Items.WeaponType.Dagger:
				_properties.MeleeDamageMult *= this.m.MeleeDamageMult_Dagger;
				break;

			case ::Const.Items.WeaponType.Flail:
				_properties.Reach += 1;
				_properties.MeleeDamageMult *= 1.1;
				_properties.HitChance[::Const.BodyPart.Head] += 10;
				_properties.DamageDirectAdd += 0.2;
				break;

			case ::Const.Items.WeaponType.Hammer:
				_properties.MeleeDamageMult *= 1.25;
				break;

			case ::Const.Items.WeaponType.Mace:
				_properties.MeleeDamageMult *= 1.2;
				break;

			case ::Const.Items.WeaponType.Spear:
				_properties.Reach += 1;
				_properties.MeleeDamageMult *= 1.1;
				_properties.DamageDirectAdd += 0.1;
				break;

			case ::Const.Items.WeaponType.Sword:
				_properties.MeleeDamageMult *= 1.1;
				_properties.DamageDirectAdd += 0.2;
				break;

			case "SouthernSword":
				_properties.MeleeDamageMult *= 1.25;
				break;

			case "FencingSword":
				_properties.DamageDirectAdd += 0.25;
				break;
			}
		}

	}.applyBonusOnUpdate;
	q.getBonusTooltip <- {
		function getBonusTooltip()
		{
			local ret = [];

			switch(this.m.CurrWeaponType)
			{
			case ::Const.Items.WeaponType.Axe:
				ret.push({
					id = 7,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = ::MSU.Text.colorPositive("15%") + " more damage"
				});
				ret.push({
					id = 7,
					type = "text",
					icon = "ui/icons/direct_damage.png",
					text = ::MSU.Text.colorPositive("+15%") + " damage ignores armor"
				});
				ret.push({
					id = 7,
					type = "text",
					icon = "ui/icons/chance_to_hit_head.png",
					text = ::MSU.Text.colorPositive("+20%") + " chance to hit the head"
				});
				break;

			case ::Const.Items.WeaponType.Cleaver:
				ret.push({
					id = 7,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = ::MSU.Text.colorPositive("30%") + " more damage"
				});
				ret.push({
					id = 7,
					type = "text",
					icon = "ui/icons/fatigue.png",
					text = ::Reforged.Mod.Tooltips.parseString("技能积累[疲劳|Concept.Fatigue]减少" + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue]")
				});
				break;

			case ::Const.Items.WeaponType.Dagger:
				ret.push({
					id = 7,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = ::MSU.Text.colorizeMult(this.m.MeleeDamageMult_Dagger) + " more damage"
				});
				ret.push({
					id = 7,
					type = "text",
					icon = "ui/icons/melee_defense.png",
					text = ::Reforged.Mod.Tooltips.parseString("面对当前[轮|Concept.Round]中，行动顺序在你之后的对手时，获得等于[主动值|Concept.Initiative]" + ::MSU.Text.colorPositive("+10%") + "的[主动值|Concept.Initiative]作为额外的[近战防御|Concept.MeleeDefense]和[远程防御|Concept.RangeDefense]，用于对抗在本[回合|Concept.Round]中后于你行动的对手")
				});
				break;

			case ::Const.Items.WeaponType.Flail:
				ret.push({
					id = 7,
					type = "text",
					icon = "ui/icons/rf_reach.png",
					text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+1") + "[触及距离|Concept.Reach]")
				});
				ret.push({
					id = 7,
					type = "text",
					icon = "ui/icons/chance_to_hit_head.png",
					text = ::MSU.Text.colorPositive("10%") + " more damage"
				});
				ret.push({
					id = 7,
					type = "text",
					icon = "ui/icons/chance_to_hit_head.png",
					text = ::MSU.Text.colorPositive("+10%") + " chance to hit the head"
				});
				ret.push({
					id = 7,
					type = "text",
					icon = "ui/icons/direct_damage.png",
					text = ::MSU.Text.colorPositive("+20%") + " damage ignores armor"
				});
				break;

			case ::Const.Items.WeaponType.Hammer:
				ret.push({
					id = 7,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = ::MSU.Text.colorPositive("25%") + " more damage"
				});
				ret.push({
					id = 7,
					type = "text",
					icon = "ui/icons/fatigue.png",
					text = ::Reforged.Mod.Tooltips.parseString("技能积累[疲劳|Concept.Fatigue]减少" + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue]")
				});
				break;

			case ::Const.Items.WeaponType.Mace:
				ret.push({
					id = 7,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = ::MSU.Text.colorPositive("20%") + " more damage"
				});
				ret.push({
					id = 7,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("造成的[生命值|Concept.Hitpoints]伤害不少于" + ::MSU.Text.colorDamage(::Const.Combat.MinDamageToApplyBleeding) + "点[生命值|Concept.Hitpoints]伤害时，施加[$ $|Skill+dazed_effect]效果")
				});
				break;

			case ::Const.Items.WeaponType.Spear:
				ret.push({
					id = 7,
					type = "text",
					icon = "ui/icons/rf_reach.png",
					text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+1") + "[触及距离|Concept.Reach]")
				});
				ret.push({
					id = 7,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = ::MSU.Text.colorPositive("10%") + " more damage"
				});
				ret.push({
					id = 7,
					type = "text",
					icon = "ui/icons/direct_damage.png",
					text = ::MSU.Text.colorPositive("+10%") + " damage ignores armor"
				});
				break;

			case ::Const.Items.WeaponType.Sword:
				ret.push({
					id = 7,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = ::MSU.Text.colorPositive("10%") + " more damage"
				});
				ret.push({
					id = 7,
					type = "text",
					icon = "ui/icons/direct_damage.png",
					text = ::MSU.Text.colorPositive("+20%") + " damage ignores armor"
				});
				ret.push({
					id = 7,
					type = "text",
					icon = "ui/icons/fatigue.png",
					text = ::Reforged.Mod.Tooltips.parseString("技能积累[疲劳|Concept.Fatigue]减少" + ::MSU.Text.colorPositive("33%") + " less [Fatigue|Concept.Fatigue]")
				});
				break;

			case "SouthernSword":
				ret.push({
					id = 7,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = ::MSU.Text.colorPositive("25%") + " more damage"
				});
				break;

			case "FencingSword":
				ret.push({
					id = 7,
					type = "text",
					icon = "ui/icons/direct_damage.png",
					text = ::MSU.Text.colorPositive("+25%") + " damage ignores armor"
				});
				break;
			}

			return ret;
		}

	}.getBonusTooltip;
	q.getName = function ()
	{
		return {
			function getName()
			{
				switch(this.m.CurrWeaponType)
				{
				case null:
					return this.m.Name;

				case "SouthernSword":
					return this.format("%s (%s)", this.m.Name, "Southern Sword");

				case "FencingSword":
					return this.format("%s (%s)", this.m.Name, "Fencing Sword");
				}

				return this.format("%s (%s)", this.m.Name, ::Const.Items.getWeaponTypeName(this.m.CurrWeaponType));
			}

		}.getName;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.skill.getTooltip();
				ret.extend(this.getBonusTooltip());
				return ret;
			}

		}.getTooltip;
	};
	q.onUpdate = function ()
	{
		return {
			function onUpdate( _properties )
			{
				this.m.CurrWeaponType = null;

				if (!this.canDoubleGrip())
				{
					return;
				}

				local weapon = this.getContainer().getActor().getMainhandItem();

				if (weapon.isWeaponType(::Const.Items.WeaponType.Axe))
				{
					this.m.CurrWeaponType = ::Const.Items.WeaponType.Axe;
				}
				else if (weapon.isWeaponType(::Const.Items.WeaponType.Dagger))
				{
					this.m.CurrWeaponType = ::Const.Items.WeaponType.Dagger;
				}
				else if (weapon.isWeaponType(::Const.Items.WeaponType.Flail))
				{
					this.m.CurrWeaponType = ::Const.Items.WeaponType.Flail;
				}
				else if (weapon.isWeaponType(::Const.Items.WeaponType.Hammer))
				{
					this.m.CurrWeaponType = ::Const.Items.WeaponType.Hammer;
				}
				else if (weapon.isWeaponType(::Const.Items.WeaponType.Mace))
				{
					this.m.CurrWeaponType = ::Const.Items.WeaponType.Mace;
				}
				else if (weapon.isWeaponType(::Const.Items.WeaponType.Spear))
				{
					this.m.CurrWeaponType = ::Const.Items.WeaponType.Spear;
				}
				else if (weapon.isWeaponType(::Const.Items.WeaponType.Sword))
				{
					if (weapon.isItemType(::Const.Items.ItemType.RF_Southern))
					{
						this.m.CurrWeaponType = "SouthernSword";
					}
					else if (weapon.isItemType(::Const.Items.ItemType.RF_Fencing))
					{
						this.m.CurrWeaponType = "FencingSword";
					}
					else
					{
						this.m.CurrWeaponType = ::Const.Items.WeaponType.Sword;
					}
				}
				else if (weapon.isWeaponType(::Const.Items.WeaponType.Cleaver))
				{
					this.m.CurrWeaponType = ::Const.Items.WeaponType.Cleaver;
				}

				this.applyBonusOnUpdate(_properties);
			}

		}.onUpdate;
	};
	q.onAfterUpdate = function ( __original )
	{
		return {
			function onAfterUpdate( _properties )
			{
				__original(_properties);

				if (this.m.CurrWeaponType == ::Const.Items.WeaponType.Hammer || this.m.CurrWeaponType == ::Const.Items.WeaponType.Cleaver)
				{
					foreach( skill in this.getContainer().getActor().getMainhandItem().getSkills() )
					{
						skill.m.FatigueCostMult *= 0.75;
					}
				}
				else if (this.m.CurrWeaponType == ::Const.Items.WeaponType.Sword)
				{
					foreach( skill in this.getContainer().getActor().getMainhandItem().getSkills() )
					{
						skill.m.FatigueCostMult *= 0.66;
					}
				}
			}

		}.onAfterUpdate;
	};
	q.onAnySkillUsed = function ( __original )
	{
		return {
			function onAnySkillUsed( _skill, _targetEntity, _properties )
			{
				__original(_skill, _targetEntity, _properties);

				if (_skill.getID() == "actives.puncture" && this.m.CurrWeaponType == ::Const.Items.WeaponType.Dagger)
				{
					_properties.MeleeDamageMult /= this.m.MeleeDamageMult_Dagger;
				}
			}

		}.onAnySkillUsed;
	};
	q.onBeingAttacked = function ( __original )
	{
		return {
			function onBeingAttacked( _attacker, _skill, _properties )
			{
				__original(_attacker, _skill, _properties);

				if (this.m.CurrWeaponType == ::Const.Items.WeaponType.Dagger)
				{
					local actor = this.getContainer().getActor();

					if (actor.m.IsTurnDone || actor.isTurnStarted())
					{
						local bonus = ::Math.floor(actor.getCurrentProperties().getInitiative() * 0.1);

						if (bonus > 0)
						{
							_properties.MeleeDefense += bonus;
							_properties.RangedDefense += bonus;
						}
					}
				}
			}

		}.onBeingAttacked;
	};
	q.onTargetHit = function ( __original )
	{
		return {
			function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
			{
				__original(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);

				if (this.m.CurrWeaponType == ::Const.Items.WeaponType.Mace)
				{
					if (!_targetEntity.isAlive() || _targetEntity.getCurrentProperties().IsImmuneToDaze || _damageInflictedHitpoints < ::Const.Combat.MinDamageToApplyBleeding)
					{
						return;
					}

					if (!this.RF_isNewSkillUseOrEntity(_targetEntity))
					{
						return;
					}

					_targetEntity.getSkills().add(::new("scripts/skills/effects/dazed_effect"));
					local actor = this.getContainer().getActor();

					if (!actor.isHiddenToPlayer() && _targetEntity.getTile().IsVisibleForPlayer)
					{
						::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + "挥出一击，使" + ::Const.UI.getColorizedEntityName(_targetEntity) + "陷入了茫然");
					}
				}
				else
				{
				}
			}

		}.onTargetHit;
	};
	q.onGetHitFactorsAsTarget = function ( __original )
	{
		return {
			function onGetHitFactorsAsTarget( _skill, _targetTile, _tooltip )
			{
				__original(_skill, _targetTile, _tooltip);

				if (this.m.CurrWeaponType == ::Const.Items.WeaponType.Dagger)
				{
					local actor = this.getContainer().getActor();

					if (actor.m.IsTurnDone || actor.isTurnStarted())
					{
						local bonus = ::Math.floor(actor.getCurrentProperties().getInitiative() * 0.1);

						if (bonus != 0)
						{
							_tooltip.push({
								icon = "ui/tooltips/negative.png",
								text = ::MSU.Text.colorNegative(bonus + "%") + " " + this.getName()
							});
						}
					}
				}
			}

		}.onGetHitFactorsAsTarget;
	};
});
