local original_getClone = ::Const.CharacterProperties.getClone;
::MSU.Table.merge(::Const.CharacterProperties, {
	PositiveMoraleCheckBravery = this.array(::Const.MoraleCheckType.len(), 0),
	PositiveMoraleCheckBraveryMult = this.array(::Const.MoraleCheckType.len(), 1.0),
	NegativeMoraleCheckBravery = this.array(::Const.MoraleCheckType.len(), 0),
	NegativeMoraleCheckBraveryMult = this.array(::Const.MoraleCheckType.len(), 1.0),
	Reach = 0,
	ReachMult = 1.0,
	IsAffectedByReach = true,
	DefensiveReachIgnore = 0,
	OffensiveReachIgnore = 0,
	BonusPerReachAdvantage = 0,
	RF_BleedingEffectMult = 1.0,
	function getClone()
	{
		local ret = original_getClone();
		ret.PositiveMoraleCheckBravery = clone this.PositiveMoraleCheckBravery;
		ret.PositiveMoraleCheckBraveryMult = clone this.PositiveMoraleCheckBraveryMult;
		ret.NegativeMoraleCheckBravery = clone this.NegativeMoraleCheckBravery;
		ret.NegativeMoraleCheckBraveryMult = clone this.NegativeMoraleCheckBraveryMult;
		return ret;
	}

	function getReach()
	{
		return ::Math.floor(this.Reach * this.ReachMult);
	}

	function getFatigueRecoveryRate()
	{
		return ::Math.floor(this.FatigueRecoveryRate * this.FatigueRecoveryRateMult);
	}

	function __getValueWithMult( _value, _mult )
	{
		local mult = _value > 0 ? _mult : _mult > 1.0 ? 1.0 / _mult : 2.0 - _mult;
		return ::Math.floor(::MSU.Math.roundToDec(_value * mult, 1));
	}

	function getMeleeDefense()
	{
		return this.__getValueWithMult(this.MeleeDefense, this.MeleeDefenseMult);
	}

	function getRangedDefense()
	{
		return this.__getValueWithMult(this.RangedDefense, this.RangedDefenseMult);
	}

	function getMeleeSkill()
	{
		return this.__getValueWithMult(this.MeleeSkill, this.MeleeSkillMult);
	}

	function getRangedSkill()
	{
		return this.__getValueWithMult(this.RangedSkill, this.RangedSkillMult);
	}

	function getBravery()
	{
		return this.__getValueWithMult(this.Bravery, this.BraveryMult);
	}

	function getInitiative()
	{
		return this.__getValueWithMult(this.Initiative, this.InitiativeMult);
	}

});
::Const.ProjectileType.FlamingArrow <- ::Const.ProjectileType.COUNT;
::Const.ProjectileType.COUNT += 1;
::Const.ProjectileDecals.push(clone ::Const.ProjectileDecals[::Const.ProjectileType.Arrow]);
::Const.ProjectileSprite.push("rf_projectile_flaming_arrow");
::Const.Movement.AutoEndTurnBelowAP = 1;
::Const.Morale.RF_AllyFleeingBraveryModifierPerAlly <- 1;
::Const.RF_ActionPointsStateName <- [
	"告一段落",
	"敛兵收势",
	"观察试探",
	"蓄势待发"
];
