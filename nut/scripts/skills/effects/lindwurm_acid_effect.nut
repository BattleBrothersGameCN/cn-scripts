this.lindwurm_acid_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 3,
		LastRoundApplied = 0
	},
	function create()
	{
		this.m.ID = "effects.lindwurm_acid";
		this.m.Name = "酸液溅浸";
		this.m.Icon = "skills/status_effect_78.png";
		this.m.IconMini = "status_effect_78_mini";
		this.m.SoundOnUse = [
			"sounds/combat/poison_applied_01.wav",
			"sounds/combat/poison_applied_02.wav"
		];
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = true;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "这个角色的盔甲被喷溅了林德蠕龙的酸液，现在酸液正在慢慢地腐蚀盔甲。剩余 [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] 回合。";
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];

		if (!this.getContainer().getActor().getFlags().has("head_immune_to_acid"))
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/armor_head.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]10%[/color] 头部护甲值损失（每回合）"
			});
		}

		if (!this.getContainer().getActor().getFlags().has("body_immune_to_acid"))
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/armor_body.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]10%[/color] 身体护甲值损失（每回合）"
			});
		}

		return ret;
	}

	function resetTime()
	{
		this.m.TurnsLeft = this.Math.max(1, 3 + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);

		if (this.m.SoundOnUse.len() != 0)
		{
			this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.25, this.getContainer().getActor().getPos());
		}
	}

	function applyDamage()
	{
		if (this.m.LastRoundApplied != this.Time.getRound())
		{
			this.m.LastRoundApplied = this.Time.getRound();
			local actor = this.getContainer().getActor();
			local head_affected = !actor.getFlags().has("head_immune_to_acid");
			local body_affected = !actor.getFlags().has("body_immune_to_acid");
			local damage_applied = false;
			this.spawnIcon("status_effect_78", actor.getTile());

			if (head_affected)
			{
				local hitInfo = clone this.Const.Tactical.HitInfo;
				hitInfo.DamageRegular = 0.0;
				hitInfo.DamageArmor = actor.getArmor(this.Const.BodyPart.Head) * 0.1;
				hitInfo.DamageDirect = 0.0;
				hitInfo.BodyPart = this.Const.BodyPart.Head;
				hitInfo.BodyDamageMult = 1.0;
				hitInfo.FatalityChanceMult = 0.0;

				if (hitInfo.DamageArmor > 0)
				{
					damage_applied = true;
				}

				this.getContainer().getActor().onDamageReceived(this.getContainer().getActor(), this, hitInfo);
			}

			if (body_affected)
			{
				local hitInfo = clone this.Const.Tactical.HitInfo;
				hitInfo.DamageRegular = 0.0;
				hitInfo.DamageArmor = actor.getArmor(this.Const.BodyPart.Body) * 0.1;
				hitInfo.DamageDirect = 0.0;
				hitInfo.BodyPart = this.Const.BodyPart.Body;
				hitInfo.BodyDamageMult = 1.0;
				hitInfo.FatalityChanceMult = 0.0;

				if (hitInfo.DamageArmor > 0)
				{
					damage_applied = true;
				}

				this.getContainer().getActor().onDamageReceived(this.getContainer().getActor(), this, hitInfo);
			}

			if (damage_applied && !actor.isHiddenToPlayer())
			{
				if (this.m.SoundOnUse.len() != 0)
				{
					this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.2, actor.getPos());
				}

				for( local i = 0; i < this.Const.Tactical.AcidParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(true, this.Const.Tactical.AcidParticles[i].Brushes, this.getContainer().getActor().getTile(), this.Const.Tactical.AcidParticles[i].Delay, this.Const.Tactical.AcidParticles[i].Quantity, this.Const.Tactical.AcidParticles[i].LifeTimeQuantity, this.Const.Tactical.AcidParticles[i].SpawnRate, this.Const.Tactical.AcidParticles[i].Stages);
				}
			}

			if (--this.m.TurnsLeft <= 0)
			{
				this.removeSelf();
			}
		}
	}

	function onAdded()
	{
		if (this.getContainer().getActor().getCurrentProperties().IsResistantToAnyStatuses && this.Math.rand(1, 100) <= 50)
		{
			if (!this.getContainer().getActor().isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + "靠他的后天生理机能免受酸液影响");
			}

			this.removeSelf();
		}
		else
		{
			this.m.TurnsLeft = this.Math.max(1, 3 + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);

			if (this.m.SoundOnUse.len() != 0)
			{
				this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.25, this.getContainer().getActor().getPos());
			}

			for( local i = 0; i < this.Const.Tactical.AcidParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(true, this.Const.Tactical.AcidParticles[i].Brushes, this.getContainer().getActor().getTile(), this.Const.Tactical.AcidParticles[i].Delay, this.Const.Tactical.AcidParticles[i].Quantity, this.Const.Tactical.AcidParticles[i].LifeTimeQuantity, this.Const.Tactical.AcidParticles[i].SpawnRate, this.Const.Tactical.AcidParticles[i].Stages);
			}

			if (!this.getContainer().getActor().isHiddenToPlayer())
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + "的身体溅上了酸液");
			}
		}
	}

	function onUpdate( _properties )
	{
	}

	function onTurnEnd()
	{
		this.applyDamage();
	}

	function onWaitTurn()
	{
		this.applyDamage();
	}

});
