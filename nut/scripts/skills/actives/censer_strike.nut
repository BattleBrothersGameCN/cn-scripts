this.censer_strike <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.censer_strike";
		this.m.Name = "香炉打击";
		this.m.Description = "用武器化的香炉击中目标，并在攻击后留下有害的瘴气。虽有些难以预测，但凭借些许运气和技巧，能够在两格距离外或绕过盾牌掩护进行攻击。";
		this.m.KilledString = "被殴打致死";
		this.m.Icon = "skills/active_228.png";
		this.m.IconDisabled = "skills/active_228_sw.png";
		this.m.Overlay = "active_228";
		this.m.SoundOnUse = [
			"sounds/combat/pound_01.wav",
			"sounds/combat/pound_02.wav",
			"sounds/combat/pound_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/pound_hit_01.wav",
			"sounds/combat/pound_hit_02.wav",
			"sounds/combat/pound_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = false;
		this.m.IsTooCloseShown = true;
		this.m.IsShieldRelevant = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 66;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "攻击范围为 [color=" + this.Const.UI.Color.PositiveValue + "]2" + "[/color] 格远"
		});

		if (!this.getContainer().getActor().getCurrentProperties().IsSpecializedInFlails)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "武器施展不便，对近身敌人有 [color=" + this.Const.UI.Color.NegativeValue + "]-15%[/color] 命中惩罚"
			});
		}
		else
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "忽略盾牌提供的近战防御加成。"
			});
		}

		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "在目标格子上留下一片瘴气云雾。"
		});
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInFlails ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectBash);
		local success = this.attackEntity(_user, _targetTile.getEntity());
		local miasma_effect = {
			Type = "miasma",
			Tooltip = "瘴气在此地徘徊，对任何生灵皆有害。",
			IsPositive = false,
			IsAppliedAtRoundStart = false,
			IsAppliedAtTurnEnd = true,
			IsAppliedOnMovement = false,
			IsAppliedOnEnter = false,
			IsByPlayer = false,
			Timeout = this.Time.getRound() + 3,
			Callback = this.Const.Tactical.Common.onApplyMiasma,
			function Applicable( _a )
			{
				return !_a.getFlags().has("undead");
			}

		};

		if (_targetTile.Properties.Effect != null && _targetTile.Properties.Effect.Type == "miasma")
		{
			_targetTile.Properties.Effect.Timeout = this.Time.getRound() + 3;
		}
		else
		{
			if (_targetTile.Properties.Effect != null)
			{
				this.Tactical.Entities.removeTileEffect(_targetTile);
			}

			_targetTile.Properties.Effect = clone miasma_effect;
			local particles = [];

			for( local i = 0; i < this.Const.Tactical.MiasmaParticles.len(); i = ++i )
			{
				particles.push(this.Tactical.spawnParticleEffect(true, this.Const.Tactical.MiasmaParticles[i].Brushes, _targetTile, this.Const.Tactical.MiasmaParticles[i].Delay, this.Const.Tactical.MiasmaParticles[i].Quantity, this.Const.Tactical.MiasmaParticles[i].LifeTimeQuantity, this.Const.Tactical.MiasmaParticles[i].SpawnRate, this.Const.Tactical.MiasmaParticles[i].Stages));
			}

			this.Tactical.Entities.addTileEffect(_targetTile, _targetTile.Properties.Effect, particles);
		}

		if (!_user.isAlive() || _user.isDying())
		{
			return success;
		}

		return success;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			if (_targetEntity != null && !this.getContainer().getActor().getCurrentProperties().IsSpecializedInFlails && this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile()) == 1)
			{
				_properties.MeleeSkill += -15;
				this.m.HitChanceBonus = -15;
			}
			else
			{
				this.m.HitChanceBonus = 0;
			}

			if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInFlails)
			{
				this.m.IsShieldRelevant = false;
			}
		}
	}

});
