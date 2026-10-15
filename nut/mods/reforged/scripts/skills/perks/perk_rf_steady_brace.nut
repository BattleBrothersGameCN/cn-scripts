this.perk_rf_steady_brace <- ::inherit("scripts/skills/skill", {
	m = {
		IsInEffect = false,
		DamageDirectAddModifier = 0.1,
		RangedSkillModifier = 10
	},
	function create()
	{
		this.m.ID = "perk.rf_steady_brace";
		this.m.Name = ::Const.Strings.PerkName.RF_SteadyBrace;
		this.m.Description = "站定不动，瞄出更精确的一击。";
		this.m.Icon = "ui/perks/perk_rf_steady_brace.png";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function isHidden()
	{
		return !this.m.IsInEffect || !this.isEnabled();
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		local weapon = this.getContainer().getActor().getMainhandItem();

		if (weapon.isWeaponType(::Const.Items.WeaponType.Crossbow))
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = ::Reforged.Mod.Tooltips.parseString("弩的伤害穿甲率" + ::MSU.Text.colorizeMult(1.0 + this.m.DamageDirectAddModifier, {
					AddSign = true
				}) + " armor penetration")
			});
		}
		else if (weapon.isWeaponType(::Const.Items.WeaponType.Firearm))
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = ::Reforged.Mod.Tooltips.parseString("火器的命中率" + ::MSU.Text.colorizeValue(this.m.RangedSkillModifier, {
					AddSign = true,
					AddPercent = true
				}) + " chance to hit")
			});
		}

		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/warning.png",
			text = ::Reforged.Mod.Tooltips.parseString("会在移动或切换物品时失效")
		});
		return ret;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (this.getContainer().getActor().getPreviewMovement() != null)
		{
			return;
		}

		if (!this.m.IsInEffect || !this.isSkillValid(_skill))
		{
			return;
		}

		local weapon = _skill.getItem();

		if (weapon.isWeaponType(::Const.Items.WeaponType.Crossbow))
		{
			_properties.DamageDirectAdd += this.m.DamageDirectAddModifier;
		}
		else if (weapon.isWeaponType(::Const.Items.WeaponType.Firearm))
		{
			_properties.RangedSkill += this.m.RangedSkillModifier;
		}
	}

	function onPayForItemAction( _skill, _items )
	{
		this.m.IsInEffect = false;
	}

	function onMovementFinished()
	{
		this.m.IsInEffect = false;
	}

	function onTurnStart()
	{
		this.m.IsInEffect = true;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.IsInEffect = false;
	}

	function isSkillValid( _skill )
	{
		if (!_skill.isAttack() || !_skill.isRanged())
		{
			return false;
		}

		local weapon = _skill.getItem();
		return !::MSU.isNull(weapon) && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(::Const.Items.WeaponType.Crossbow | ::Const.Items.WeaponType.Firearm);
	}

	function isEnabled()
	{
		local weapon = this.getContainer().getActor().getMainhandItem();

		if (weapon == null)
		{
			return false;
		}

		foreach( s in weapon.getSkills() )
		{
			if (this.isSkillValid(s))
			{
				return true;
			}
		}

		return false;
	}

});
