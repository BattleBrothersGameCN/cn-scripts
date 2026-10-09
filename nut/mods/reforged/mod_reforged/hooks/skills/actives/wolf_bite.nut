::Reforged.HooksMod.hook("scripts/skills/actives/wolf_bite", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "摇晃大口，撕扯血肉。";
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				return this.getDefaultTooltip();
			}

		}.getTooltip;
	};
	q.onUpdate = function ()
	{
		return {
			function onUpdate( _properties )
			{
			}

		}.onUpdate;
	};
	q.isIgnoredAsAOO = function ( __original )
	{
		return {
			function isIgnoredAsAOO()
			{
				if (!::MSU.isNull(this.getContainer()))
				{
					foreach( s in this.getContainer().m.Skills )
					{
						if (s != this && !s.isIgnoredAsAOO() && !::MSU.isNull(s.getItem()) && !s.isHidden() && !s.isGarbage())
						{
							return true;
						}
					}
				}

				return __original();
			}

		}.isIgnoredAsAOO;
	};
	q.onAnySkillUsed = function ()
	{
		return {
			function onAnySkillUsed( _skill, _targetEntity, _properties )
			{
				if (_skill == this)
				{
					local weapon = this.getContainer().getActor().getMainhandItem();

					if (weapon != null)
					{
						_properties.DamageRegularMin -= weapon.m.RegularDamage;
						_properties.DamageRegularMax -= weapon.m.RegularDamageMax;
						_properties.DamageArmorMult /= weapon.m.ArmorDamageMult;
						_properties.DamageDirectAdd -= weapon.m.DirectDamageAdd;
						_properties.HitChance[::Const.BodyPart.Head] -= weapon.m.ChanceToHitHead;
					}

					_properties.DamageRegularMin += 20;
					_properties.DamageRegularMax += 40;
					_properties.DamageArmorMult *= 0.4;
				}
			}

		}.onAnySkillUsed;
	};
});
