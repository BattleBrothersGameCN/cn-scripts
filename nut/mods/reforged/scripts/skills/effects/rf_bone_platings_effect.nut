this.rf_bone_platings_effect <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.rf_bone_platings";
		this.m.Name = "骨质甲板";
		this.m.Description = "完全吸收下次不能无视护甲的命中身体的伤害。";
		this.m.Icon = "skills/rf_bone_platings_effect.png";
		this.m.IconMini = "rf_bone_platings_effect_mini";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_hitInfo.BodyPart == ::Const.BodyPart.Body && _hitInfo.DamageDirect < 1.0)
		{
			_properties.DamageReceivedTotalMult = 0.0;
			::Tactical.EventLog.logEx("吸收了所有伤害(" + this.getName() + ")");
			::Sound.play(::MSU.Array.rand(::Const.Sound.ArmorBoneImpact), ::Const.Sound.Volume.Skill, this.getContainer().getActor().getPos());
			this.removeSelf();
		}
	}

});
