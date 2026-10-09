::Reforged.HooksHelper <- {
	function dualWeapon( q )
	{
		q.m.Weapon1 <- null;
		q.m.Weapon2 <- null;
		q.create = function ( __original )
		{
			return {
				function create()
				{
					if (typeof this.m.Weapon1 == "string")
					{
						this.m.Weapon1 = ::new(this.m.Weapon1);
						this.m.Weapon2 = ::new(this.m.Weapon2);
					}

					__original();
					this.m.Value = this.m.Weapon1.m.Value + this.m.Weapon2.m.Value;
					this.m.ConditionMax = this.m.Weapon1.m.ConditionMax + this.m.Weapon2.m.ConditionMax;
					this.m.Condition = this.m.ConditionMax;
					this.m.StaminaModifier = this.m.Weapon1.m.StaminaModifier + this.m.Weapon2.m.StaminaModifier;
					this.m.RegularDamage = (this.m.Weapon1.m.RegularDamage + this.m.Weapon2.m.RegularDamage) / 2;
					this.m.RegularDamageMax = (this.m.Weapon1.m.RegularDamageMax + this.m.Weapon2.m.RegularDamageMax) / 2;
					this.m.ArmorDamageMult = (this.m.Weapon1.m.ArmorDamageMult + this.m.Weapon2.m.ArmorDamageMult) / 2;
					this.m.DirectDamageMult = (this.m.Weapon1.m.DirectDamageMult + this.m.Weapon2.m.DirectDamageMult) / 2;
					this.m.Reach = (this.m.Weapon1.m.Reach + this.m.Weapon2.m.Reach) / 2;
					this.setWeaponType(this.m.Weapon1.m.WeaponType);
					this.addWeaponType(this.m.Weapon2.m.WeaponType);
				}

			}.create;
		};
		q.addSkill = function ( __original )
		{
			return {
				function addSkill( _skill )
				{
					if (::MSU.isIn("RF_Weapon", _skill.m, true))
					{
						_skill.m.RF_Weapon = ::MSU.asWeakTableRef(this.RF_getWeaponForSkill(_skill));
					}

					__original(_skill);
				}

			}.addSkill;
		};
		q.RF_getWeaponForSkill <- {
			function RF_getWeaponForSkill( _skill )
			{
			}

		}.RF_getWeaponForSkill;
	}

	function golemWeaponSkill( q )
	{
		q.m.RF_Weapon <- null;
		local superName = q.SuperName;
		q.onAnySkillUsed = function ( __original )
		{
			return {
				function onAnySkillUsed( _skill, _targetEntity, _properties )
				{
					if (_skill != this || ::MSU.isNull(this.m.RF_Weapon) || ::MSU.isNull(this.getItem()))
					{
						__original(_skill, _targetEntity, _properties);
						return;
					}

					this[superName].onAnySkillUsed(_skill, _targetEntity, _properties);
					local weapon = this.getItem();
					_properties.DamageRegularMin += this.m.RF_Weapon.m.RegularDamage - weapon.m.RegularDamage;
					_properties.DamageRegularMax += this.m.RF_Weapon.m.RegularDamageMax - weapon.m.RegularDamageMax;
					_properties.DamageArmorMult += this.m.RF_Weapon.m.ArmorDamageMult - weapon.m.ArmorDamageMult;
				}

			}.onAnySkillUsed;
		};
	}

};
