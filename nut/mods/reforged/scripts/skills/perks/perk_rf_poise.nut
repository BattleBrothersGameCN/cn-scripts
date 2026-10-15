this.perk_rf_poise <- ::inherit("scripts/skills/skill", {
	m = {
		StaminaModifierThresholdMult = 0.3,
		WeightThresholdMin = 35
	},
	function create()
	{
		this.m.ID = "perk.rf_poise";
		this.m.Name = ::Const.Strings.PerkName.RF_Poise;
		this.m.Description = "该角色动作轻盈，能将袭来的攻击化为轻微的擦伤。";
		this.m.Icon = "ui/perks/perk_rf_poise.png";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function isHidden()
	{
		return ::Math.floor(this.getHitpointsDamage() * 100) >= 100 && ::Math.floor(this.getArmorDamage() * 100) >= 100;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		local hpBonus = ::Math.round(this.getHitpointsDamage() * 100);

		if (hpBonus < 100)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("来自攻击的[生命值伤害|Concept.Hitpoints]降低" + ::MSU.Text.colorPositive(100 - hpBonus + "%"))
			});
		}

		local armorBonus = ::Math.round(this.getArmorDamage() * 100);

		if (armorBonus < 100)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "来自攻击的护甲伤害降低" + ::MSU.Text.colorPositive(100 - armorBonus + "%")
			});
		}

		if (hpBonus >= 100 && armorBonus >= 100)
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::MSU.Text.colorNegative("This character\'s body and head armor are too heavy to gain any damage reduction from " + this.m.Name)
			});
		}

		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/rf_reach.png",
			text = ::Reforged.Mod.Tooltips.parseString("攻击[主动值|Concept.Initiative]更低的目标时，无视1点[触及劣势|Concept.ReachAdvantage]")
		});
		local actor = this.getContainer().getActor();
		local maxHPString = ::Math.floor(actor.getHitpointsMax() / (hpBonus * 0.01));
		local currHPString = ::Math.floor(actor.getHitpoints() / (hpBonus * 0.01));
		ret.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::MSU.Text.colorPositive("等效生命值：") + currHPString + " / " + maxHPString
		});
		ret.push({
			id = 13,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "The effectiveness is reduced above combined head and body armor weight of " + this.getStaminaModifierThreshold()
		});
		return ret;
	}

	function getHitpointsDamage()
	{
		local fat = this.getContainer().getActor().getItems().getStaminaModifier([
			::Const.ItemSlot.Body,
			::Const.ItemSlot.Head
		]);
		fat = ::Math.min(0, fat + this.getStaminaModifierThreshold());
		return ::Math.minf(1.0, 1.0 - 0.3 + ::Math.pow(::Math.abs(fat), 1.23) * 0.01);
	}

	function getArmorDamage()
	{
		local fat = this.getContainer().getActor().getItems().getStaminaModifier([
			::Const.ItemSlot.Body,
			::Const.ItemSlot.Head
		]);
		fat = ::Math.min(0, fat + this.getStaminaModifierThreshold());
		return ::Math.minf(1.0, 1.0 - 0.2 + ::Math.pow(::Math.abs(fat), 1.23) * 0.01);
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_attacker != null && _attacker.getID() == this.getContainer().getActor().getID() || _skill == null || !_skill.isAttack() || !_skill.isUsingHitchance())
		{
			return;
		}

		_properties.DamageReceivedRegularMult *= this.getHitpointsDamage();
		_properties.DamageReceivedArmorMult *= this.getArmorDamage();
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (!this.isHidden() && _targetEntity != null && _skill.isAttack() && !_skill.isRanged() && _targetEntity.getInitiative() < this.getContainer().getActor().getInitiative())
		{
			_properties.OffensiveReachIgnore += 1;
		}
	}

	function getStaminaModifierThreshold()
	{
		local b = this.getContainer().getActor().getBaseProperties().getClone();
		local wasUpdating = this.getContainer().m.IsUpdating;
		this.getContainer().m.IsUpdating = true;

		foreach( trait in this.getContainer().getSkillsByFunction(function ( s )
		{
			return s.isType(::Const.SkillType.Trait) || s.isType(::Const.SkillType.PermanentInjury);
		}) )
		{
			trait.onUpdate(b);
		}

		this.getContainer().m.IsUpdating = wasUpdating;
		return ::Math.max(this.m.WeightThresholdMin, this.m.StaminaModifierThresholdMult * b.Stamina * (b.StaminaMult >= 0 ? b.StaminaMult : 1.0 / b.StaminaMult));
	}

});
