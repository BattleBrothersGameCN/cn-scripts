::Reforged.HooksMod.hook("scripts/skills/perks/perk_mastery_cleaver", function ( q )
{
	q.onAdded = function ( __original )
	{
		return {
			function onAdded()
			{
				__original();
				this.getContainer().add(::Reforged.new("scripts/skills/perks/perk_rf_bloodlust", function ( o )
				{
					o.m.IsRefundable = false;
					o.m.IsSerialized = false;
				}));
			}

		}.onAdded;
	};
	q.onRemoved = function ( __original )
	{
		return {
			function onRemoved()
			{
				__original();
				this.getContainer().removeByStackByID("perk.rf_bloodlust");
			}

		}.onRemoved;
	};
	q.onTargetHit = function ( __original )
	{
		return {
			function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
			{
				__original(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);

				if (!_targetEntity.isAlive() || _damageInflictedHitpoints < ::Const.Combat.MinDamageToApplyBleeding || _targetEntity.getCurrentProperties().IsImmuneToBleeding || !this.isSkillValid(_skill))
				{
					return;
				}

				if (!this.RF_isNewSkillUseOrEntity(_targetEntity))
				{
					return;
				}

				_targetEntity.getSkills().add(::new("scripts/skills/effects/bleeding_effect"));
			}

		}.onTargetHit;
	};
	q.onQueryTooltip = function ( __original )
	{
		return {
			function onQueryTooltip( _skill, _tooltip )
			{
				__original(_skill, _tooltip);

				if (this.isSkillValid(_skill))
				{
					_tooltip.push({
						id = 100,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("会额外施加[$ $|Skill+bleeding_effect]效果，这归功于" + ::Reforged.NestedTooltips.getNestedPerkName(this) + "特技，造成的[生命值|Concept.Hitpoints]伤害超过" + ::MSU.Text.color(::Const.UI.Color.DamageValue, ::Const.Combat.MinDamageToApplyBleeding) + "点[生命值|Concept.Hitpoints]伤害时，额外施加[$ $|Skill+bleeding_effect]效果")
					});
				}
			}

		}.onQueryTooltip;
	};
	q.isSkillValid <- {
		function isSkillValid( _skill )
		{
			if (!_skill.isAttack())
			{
				return false;
			}

			local weapon = _skill.getItem();
			return !::MSU.isNull(weapon) && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(::Const.Items.WeaponType.Cleaver);
		}

	}.isSkillValid;
});
