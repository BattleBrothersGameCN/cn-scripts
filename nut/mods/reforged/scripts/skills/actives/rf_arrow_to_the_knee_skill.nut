this.rf_arrow_to_the_knee_skill <- ::inherit("scripts/skills/actives/quick_shot", {
	m = {},
	function create()
	{
		this.quick_shot.create();
		this.m.ID = "actives.rf_arrow_to_the_knee";
		this.m.Name = "瞄准膝盖";
		this.m.Description = ::Reforged.Mod.Tooltips.parseString("瞄准膝盖的削弱射击，意在瘫痪目标的移动和自我防护能力。只能对能受到腿部[创伤|Concept.InjuryTemporary]的目标使用。");
		this.m.Icon = "skills/rf_arrow_to_the_knee_skill.png";
		this.m.IconDisabled = "skills/rf_arrow_to_the_knee_skill_sw.png";
		this.m.Overlay = "rf_arrow_to_the_knee_skill";
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 20;
		this.m.AdditionalAccuracy = -10;
		this.m.AdditionalHitChance = -4;
	}

	function getTooltip()
	{
		local ret = this.getRangedTooltip(this.getDefaultTooltip());
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("会在命中目标时施加[膝盖中箭|Skill+rf_arrow_to_the_knee_debuff_effect]效果")
		});
		local ammo = this.getAmmo();

		if (ammo > 0)
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/icons/ammo.png",
				text = "剩余" + ::MSU.Text.colorPositive(ammo) + "支箭"
			});
		}
		else
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::MSU.Text.colorNegative("需要装备非空箭袋")
			});
		}

		if (this.getContainer().getActor().isEngagedInMelee())
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("角色[陷入近战|Concept.ZoneOfControl]，无法使用"))
			});
		}

		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return this.skill.onVerifyTarget(_originTile, _targetTile) && this.RF_isTargetValid(_targetTile.getEntity());
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill == this && _targetEntity.isAlive() && this.RF_isTargetValid(_targetEntity))
		{
			_targetEntity.getSkills().add(::new("scripts/skills/effects/rf_arrow_to_the_knee_debuff_effect"));
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		this.quick_shot.onAnySkillUsed(_skill, _targetEntity, _properties);

		if (_skill == this)
		{
			_properties.HitChanceMult[::Const.BodyPart.Head] *= 0.0;
		}
	}

	function RF_isTargetValid( _targetEntity )
	{
		if (!_targetEntity.getCurrentProperties().IsAffectedByInjuries)
		{
			return false;
		}

		if (_targetEntity.getFlags().has("undead") && _targetEntity.getBaseProperties().FatigueEffectMult == 0.0)
		{
			return false;
		}

		local legInjuries = ::Const.Injury.ExcludedInjuries.get(::Const.Injury.ExcludedInjuries.Leg);
		return legInjuries.filter(function ( _, _id )
		{
			return _targetEntity.m.ExcludedInjuries.find(_id) == null;
		}).len() != 0;
	}

});
