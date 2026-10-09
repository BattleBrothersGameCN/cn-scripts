this.rf_direct_damage_limiter <- ::inherit("scripts/skills/skill", {
	m = {
		Max = 0.95,
		FullArmorIgnoreChance = 0
	},
	function create()
	{
		this.m.ID = "special.rf_direct_damage_limiter";
		this.m.Type = ::Const.SkillType.Special;
		this.m.Order = ::Const.SkillOrder.VeryLast + 10;
		this.m.IsHidden = true;
		this.m.IsSerialized = false;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		this.m.FullArmorIgnoreChance = 0;

		if (_skill.getDirectDamage() < 1.0)
		{
			local damageDirect = _properties.DamageDirectMult * (_skill.getDirectDamage() + _properties.DamageDirectAdd + (_skill.m.IsRanged ? _properties.DamageDirectRangedAdd : _properties.DamageDirectMeleeAdd));

			if (damageDirect >= this.m.Max)
			{
				this.m.FullArmorIgnoreChance = ::Math.floor(::Math.minf(this.m.Max, damageDirect - this.m.Max) * 100);

				if (_targetEntity == null)
				{
					_properties.DamageDirectMult = this.m.Max / (_skill.getDirectDamage() + _properties.DamageDirectAdd + (_skill.m.IsRanged ? _properties.DamageDirectRangedAdd : _properties.DamageDirectMeleeAdd));
				}
			}
		}
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		if (_skill.getDirectDamage() < 1.0)
		{
			if (::Math.rand(1, 100) <= this.m.FullArmorIgnoreChance)
			{
				_hitInfo.DamageDirect = 1.0;
			}
			else
			{
				_hitInfo.DamageDirect = ::Math.minf(this.m.Max, _hitInfo.DamageDirect);
			}
		}
	}

	function onQueryTooltip( _skill, _tooltip )
	{
		if (this.m.FullArmorIgnoreChance > 0)
		{
			foreach( entry in _tooltip )
			{
				if (entry.text.find("其中") != null && entry.text.find("可无视护甲") != null)
				{
					entry.text += "，有" + ::MSU.Text.colorPositive(this.m.FullArmorIgnoreChance + "%") + "几率完全无视护甲。";
					return;
				}
			}
		}
	}

});
