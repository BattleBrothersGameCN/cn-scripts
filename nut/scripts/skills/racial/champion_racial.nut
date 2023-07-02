this.champion_racial <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "racial.champion";
		this.m.Name = "冠军";
		this.m.Description = "";
		this.m.Icon = "skills/status_effect_108.png";
		this.m.IconMini = "status_effect_108_mini";
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.First;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.DamageTotalMult *= 1.150000;
		_properties.BraveryMult *= 1.500000;
		_properties.StaminaMult *= 1.500000;
		_properties.MeleeSkillMult *= 1.150000;
		_properties.RangedSkillMult *= 1.150000;
		_properties.MeleeDefenseMult *= 1.250000;
		_properties.RangedDefenseMult *= 1.250000;
		_properties.InitiativeMult *= 1.150000;
		_properties.HitpointsMult *= 1.350000;

		if (this.getContainer().getActor().getBaseProperties().MeleeDefense >= 20 || this.getContainer().getActor().getBaseProperties().RangedDefense >= 20 || this.getContainer().getActor().getBaseProperties().MeleeDefense >= 15 && this.getContainer().getActor().getBaseProperties().RangedDefense >= 15)
		{
			_properties.MeleeDefenseMult *= 1.250000;
			_properties.RangedDefenseMult *= 1.250000;
		}
		else
		{
			_properties.HitpointsMult *= 1.350000;
		}
	}

});
