::Reforged.HooksMod.hook("scripts/skills/perks/perk_mastery_hammer", function ( q )
{
	q.m.DentArmorSkills <- [
		"actives.demolish_armor",
		"actives.crush_armor"
	];
	q.m.MinArmorToDent <- 210;
	q.onTargetHit = function ( __original )
	{
		return {
			function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
			{
				__original(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);

				if (!_targetEntity.isAlive() || _targetEntity.getArmorMax(_bodyPart) < this.m.MinArmorToDent || this.m.DentArmorSkills.find(_skill.getID()) == null || _targetEntity.getSkills().hasSkill("effects.rf_dented_armor"))
				{
					return;
				}

				local armorItem = _bodyPart == ::Const.BodyPart.Head ? _targetEntity.getHeadItem() : _targetEntity.getBodyItem();

				if (armorItem != null)
				{
					_targetEntity.getSkills().add(::new("scripts/skills/effects/rf_dented_armor_effect"));
				}
			}

		}.onTargetHit;
	};
	q.onQueryTooltip = function ( __original )
	{
		return {
			function onQueryTooltip( _skill, _tooltip )
			{
				__original(_skill, _tooltip);

				if (this.m.DentArmorSkills.find(_skill.getID()) != null)
				{
					_tooltip.push({
						id = 100,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("当命中最大耐久至少为[$ $|Skill+rf_dented_armor_effect]时" + this.m.MinArmorToDent + "点耐久度的护甲施加[$ $|Skill+rf_dented_armor_effect]效果")
					});
				}
			}

		}.onQueryTooltip;
	};
	q.onAdded = function ( __original )
	{
		return {
			function onAdded()
			{
				__original();
				local weapon = this.getContainer().getActor().getMainhandItem();

				if (weapon != null)
				{
					this.onEquip(weapon);
				}
			}

		}.onAdded;
	};
	q.onEquip = function ( __original )
	{
		return {
			function onEquip( _item )
			{
				__original(_item);

				if (_item.isItemType(::Const.Items.ItemType.TwoHanded) && _item.isItemType(::Const.Items.ItemType.Weapon) && _item.isWeaponType(::Const.Items.WeaponType.Hammer))
				{
					_item.addSkill(::Reforged.new("scripts/skills/actives/rf_pummel_skill", function ( o )
					{
						o.m.DirectDamageMult = _item.m.DirectDamageMult;
					}));
				}
			}

		}.onEquip;
	};
});
