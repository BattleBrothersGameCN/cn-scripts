this.golem_grapple_skill <- this.inherit("scripts/skills/skill", {
	m = {
		IsSpent = false
	},
	function create()
	{
		this.m.ID = "actives.golem_grapple";
		this.m.Name = "抓钩";
		this.m.Description = "";
		this.m.Icon = "skills/active_232.png";
		this.m.IconDisabled = "skills/active_232.png";
		this.m.Overlay = "active_232";
		this.m.SoundOnUse = [
			"sounds/enemies/small_golem_basic_attack_01.wav",
			"sounds/enemies/small_golem_basic_attack_02.wav",
			"sounds/enemies/small_golem_basic_attack_03.wav",
			"sounds/enemies/small_golem_basic_attack_04.wav",
			"sounds/enemies/small_golem_basic_attack_05.wav"
		];
		this.m.SoundOnHit = [];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsWeaponSkill = false;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 0.0;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.m.IsSpent;
	}

	function onTurnStart()
	{
		this.m.IsSpent = false;
	}

	function onUse( _user, _targetTile )
	{
		this.m.IsSpent = true;
		local target = _targetTile.getEntity();
		local success = this.attackEntity(_user, target);

		if (success && target.isAlive())
		{
			if (!target.getCurrentProperties().IsStunned && !target.getCurrentProperties().IsImmuneToDisarm)
			{
				local disarm = this.new("scripts/skills/effects/disarmed_effect");
				target.getSkills().add(disarm);

				if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
				{
					this.Tactical.EventLog.log(disarm.getLogEntryOnAdded(this.Const.UI.getColorizedEntityName(_user), this.Const.UI.getColorizedEntityName(target)));
				}
			}
		}

		return success;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageTotalMult = 0.0;
			_properties.HitChanceMult[this.Const.BodyPart.Head] = 0.0;
		}
	}

});
