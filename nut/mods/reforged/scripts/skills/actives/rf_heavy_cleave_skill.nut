this.rf_heavy_cleave_skill <- ::inherit("scripts/skills/actives/cleave", {
	m = {},
	function create()
	{
		this.cleave.create();
		this.m.ID = "actives.rf_heavy_cleave";
		this.m.Name = "重劈";
		this.m.Description = ::Reforged.Mod.Tooltips.parseString("一记过顶劈击，只要没被护甲吸收且目标有血可流，就会制造出[$ $|Skill+bleeding_effect]伤口。");
		this.m.Icon = "skills/active_182.png";
		this.m.IconDisabled = "skills/active_182_sw.png";
		this.m.Overlay = "active_182";
		this.m.SoundOnUse = [
			"sounds/combat/overhead_strike_01.wav",
			"sounds/combat/overhead_strike_02.wav",
			"sounds/combat/overhead_strike_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/overhead_strike_hit_01.wav",
			"sounds/combat/overhead_strike_hit_02.wav",
			"sounds/combat/overhead_strike_hit_03.wav"
		];
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.AIBehaviorID = ::Const.AI.Behavior.ID.AttackDefault;
		this.m.ChanceDecapitate = 99;
		this.m.ChanceDisembowel = 66;
	}

	function getTooltip()
	{
		local ret = this.cleave.getTooltip();

		foreach( entry in ret )
		{
			if (entry.id == 8)
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("施加2层[$ $|Skill+bleeding_effect]");
				break;
			}
		}

		return ret;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill == this && _targetEntity.isAlive() && !_targetEntity.getCurrentProperties().IsImmuneToBleeding && _damageInflictedHitpoints >= ::Const.Combat.MinDamageToApplyBleeding)
		{
			local effect = ::new("scripts/skills/effects/bleeding_effect");
			effect.setDamage(this.getContainer().getActor().getCurrentProperties().IsSpecializedInCleavers ? 10 : 5);
			_targetEntity.getSkills().add(effect);
		}
	}

});
