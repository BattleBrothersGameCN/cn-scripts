this.rf_hooked_shield_effect <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.rf_hooked_shield";
		this.m.Name = "盾牌被钩";
		this.m.Description = "该角色的盾牌被钩住拉开，难以正常使用盾牌。";
		this.m.Icon = "skills/rf_hooked_shield_effect.png";
		this.m.IconMini = "rf_hooked_shield_effect_mini";
		this.m.Overlay = "rf_hooked_shield_effect";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
	}

	function isHidden()
	{
		return !this.getContainer().getActor().isArmedWithShield();
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		local shield = this.getContainer().getActor().getOffhandItem();

		if (shield == null)
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("盾牌提供的[近战防御|Concept.MeleeDefense]和[远程防御|Concept.RangeDefense]降低" + ::MSU.Text.colorNegative("75%"))
			});
		}
		else
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(-::Math.floor(shield.getMeleeDefenseBonus() * 0.75), {
					AddSign = true
				}) + "来自盾牌的[近战防御|Concept.MeleeDefense]")
			});
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(-::Math.floor(shield.getRangedDefenseBonus() * 0.75), {
					AddSign = true
				}) + "来自所装备盾牌的[远程防御|Concept.RangeDefense]")
			});
		}

		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("移除[$ $|Skill+riposte_effect]并禁用[$ $|Perk+perk_rf_rebuke]")
		});
		ret.push({
			id = 13,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("会在使用技能或下[回合|Concept.Turn]开始时失效")
		});
		return ret;
	}

	function onAdded()
	{
		this.getContainer().removeByID("effects.riposte");
	}

	function getItemActionCost( _items )
	{
		if (this.isHidden())
		{
			return null;
		}

		local shield = this.getContainer().getActor().getOffhandItem();

		foreach( item in _items )
		{
			if (item != null && ::MSU.isEqual(item, shield))
			{
				return 99;
			}
		}
	}

	function onUpdate( _properties )
	{
		if (!this.isHidden())
		{
			local shield = this.getContainer().getActor().getOffhandItem();
			_properties.MeleeDefense -= ::Math.floor(shield.getMeleeDefenseBonus() * 0.75);
			_properties.RangedDefense -= ::Math.floor(shield.getRangedDefenseBonus() * 0.75);
			local rebuke = this.getContainer().getSkillByID("perk.rf_rebuke");

			if (rebuke != null)
			{
				rebuke.m.BaseChance -= 9999;
			}
		}
	}

	function onBeingAttacked( _attacker, _skill, _properties )
	{
		if (!_skill.m.IsShieldRelevant && !this.isHidden())
		{
			local shield = this.getContainer().getActor().getOffhandItem();
			_properties.MeleeDefense += ::Math.floor(shield.getMeleeDefenseBonus() * 0.75);
			_properties.RangedDefense += ::Math.floor(shield.getRangedDefenseBonus() * 0.75);
		}
	}

	function onAnySkillExecuted( _skill, _targetTile, _targetEntity, _forFree )
	{
		this.removeSelf();
	}

	function onTurnStart()
	{
		this.removeSelf();
	}

	function onGetHitFactorsAsTarget( _skill, _targetTile, _tooltip )
	{
		if (this.isHidden())
		{
			return;
		}

		local shield = this.getContainer().getActor().getOffhandItem();
		local bonus = _skill.isRanged() ? ::Math.floor(shield.getRangedDefenseBonus() * 0.75) : ::Math.floor(shield.getMeleeDefenseBonus() * 0.75);
		_tooltip.push({
			icon = "ui/tooltips/positive.png",
			text = ::MSU.Text.colorPositive(bonus + "% ") + this.getName()
		});
	}

	function onQueryTooltip( _skill, _tooltip )
	{
		if (_skill.getID() == "effects.rf_rebuke" && !this.isHidden())
		{
			local filename = ::IO.scriptFilenameByHash(this.ClassNameHash).split("/").top();
			_tooltip.push({
				id = 7,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("被[" + this.getName() + "|Skill+" + filename, "]"))
			});
		}
	}

});
