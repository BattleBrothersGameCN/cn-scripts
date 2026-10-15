this.rf_follow_up_effect <- ::inherit("scripts/skills/skill", {
	m = {
		DamageMalus = 30,
		DamageMalusIncreasePerProc = 10,
		ProcCount = 0,
		IsProccing = false
	},
	function create()
	{
		this.m.ID = "effects.rf_follow_up";
		this.m.Name = "紧随其后";
		this.m.Description = "在该角色的攻击范围内，每当一名敌人被一名盟友击中时，该角色就会对该敌人进行一次伤害较低的免费非致命攻击。";
		this.m.Icon = "ui/perks/perk_rf_follow_up.png";
		this.m.IconMini = "rf_follow_up_effect_mini";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Last;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/damage_dealt.png",
			text = ::MSU.Text.colorNegative(this.getCurrentMalus() + "%") + " less damage inflicted"
		});

		if (!this.isEnabled())
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("陷入[近战|Concept.ZoneOfControl]时无法跟进攻击"))
			});
		}

		return ret;
	}

	function isEnabled()
	{
		local actor = this.getContainer().getActor();

		if (!actor.getCurrentProperties().IsAbleToUseWeaponSkills || !actor.hasZoneOfControl() || actor.isEngagedInMelee())
		{
			return false;
		}

		return true;
	}

	function getCurrentMalus()
	{
		return ::Math.min(90, this.m.DamageMalus + this.m.ProcCount * this.m.DamageMalusIncreasePerProc);
	}

	function onUpdate( _properties )
	{
		if (!this.getContainer().getActor().isPlacedOnMap() || this.getContainer().getActor().getMoraleState() == ::Const.MoraleState.Fleeing)
		{
			this.removeSelf();
			return;
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (this.m.IsProccing)
		{
			_properties.DamageTotalMult *= 1.0 - this.getCurrentMalus() * 0.01;
		}
	}

	function proc( _targetEntity )
	{
		if (!this.isEnabled() || !_targetEntity.isAlive() || _targetEntity.isDying() || !_targetEntity.isPlacedOnMap())
		{
			return;
		}

		local targetTile = _targetEntity.getTile();
		local attack = this.getContainer().getAttackOfOpportunity();

		if (attack == null || !attack.verifyTargetAndRange(targetTile, this.getContainer().getActor().getTile()))
		{
			return;
		}

		local user = this.getContainer().getActor();

		if (!user.getTile().hasLineOfSightTo(targetTile, user.getCurrentProperties().getVision()))
		{
			return;
		}

		if (!user.isHiddenToPlayer() || targetTile.IsVisibleForPlayer)
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(user) + "紧随其后发起攻击");
		}

		::logDebug("[" + user.getName() + "] is Following Up with skill [" + attack.getName() + "]，目标是：[" + _targetEntity.getName() + "]");
		this.m.IsProccing = true;
		attack.useForFree(targetTile);
		this.m.ProcCount++;
		this.m.IsProccing = false;
	}

	function onTurnStart()
	{
		this.removeSelf();
	}

});
