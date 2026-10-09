::Reforged.HooksMod.hook("scripts/items/ammo/legendary/quiver_of_coated_arrows", function ( q )
{
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();

				foreach( entry in ret )
				{
					if (entry.id == 7)
					{
						entry.text = ::Reforged.Mod.Tooltips.parseString("施加" + ::MSU.Text.colorDamage(this.m.BleedDamage / 5) + "层[$ $|Skill+bleeding_effect]效果");
						break;
					}
				}

				return ret;
			}

		}.getTooltip;
	};
	q.onDamageDealt = function ()
	{
		return {
			function onDamageDealt( _target, _skill, _hitInfo )
			{
				if (!this.isSkillValid(_skill))
				{
					return;
				}

				if (!_target.isAlive() || _target.isDying())
				{
					if (::isKindOf(_target, "lindwurm_tail") || !_target.getCurrentProperties().IsImmuneToBleeding)
					{
						::Sound.play(::MSU.Array.rand(this.m.BleedSounds), ::Const.Sound.Volume.Skill, this.getContainer().getActor().getPos());
					}
				}
				else if (!_target.getCurrentProperties().IsImmuneToBleeding && _hitInfo.DamageInflictedHitpoints >= ::Const.Combat.MinDamageToApplyBleeding)
				{
					for( local i = 0; i < this.m.BleedDamage / 5; i++ )
					{
						_target.getSkills().add(::new("scripts/skills/effects/bleeding_effect"));
					}

					::Sound.play(::MSU.Array.rand(this.m.BleedSounds), ::Const.Sound.Volume.Skill, this.getContainer().getActor().getPos());
				}
			}

		}.onDamageDealt;
	};
	q.isSkillValid <- {
		function isSkillValid( _skill )
		{
			if (!_skill.isRanged() || !_skill.isAttack())
			{
				return false;
			}

			local weapon = _skill.getItem();
			return !::MSU.isNull(weapon) && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(::Const.Items.WeaponType.Bow);
		}

	}.isSkillValid;
});
