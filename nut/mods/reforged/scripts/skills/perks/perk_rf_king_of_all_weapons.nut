this.perk_rf_king_of_all_weapons <- ::inherit("scripts/skills/skill", {
	m = {
		RequiredDamageType = ::Const.Damage.DamageType.Piercing,
		RequiredWeaponType = ::Const.Items.WeaponType.Spear
	},
	function create()
	{
		this.m.ID = "perk.rf_king_of_all_weapons";
		this.m.Name = ::Const.Strings.PerkName.RF_KingOfAllWeapons;
		this.m.Description = "该角色极擅长使用矛 ―― 大家公认的百兵之王。";
		this.m.Icon = "ui/perks/perk_rf_king_of_all_weapons.png";
		this.m.IconMini = "perk_rf_king_of_all_weapons_mini";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Last;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_targetEntity == null || !this.isSkillValid(_skill))
		{
			return;
		}

		local headArmor = _targetEntity.getArmor(::Const.BodyPart.Head);
		local bodyArmor = _targetEntity.getArmor(::Const.BodyPart.Body);
		local isHeadLower = headArmor < bodyArmor;
		local isBodyLower = bodyArmor < headArmor;
		local chance = this.getChance();
		local actor = this.getContainer().getActor();

		if (actor.isPreviewing())
		{
			if (isHeadLower)
			{
				_properties.HitChance[::Const.BodyPart.Head] = chance + (1.0 - chance * 0.01) * _properties.getHitchance(::Const.BodyPart.Head);
				_properties.HitChanceMult[::Const.BodyPart.Head] = 1.0;
			}
			else if (isBodyLower)
			{
				_properties.HitChance[::Const.BodyPart.Head] = (1.0 - chance * 0.01) * _properties.getHitchance(::Const.BodyPart.Head);
				_properties.HitChanceMult[::Const.BodyPart.Head] = 1.0;
			}
		}
		else if (::Math.rand(1, 100) < chance)
		{
			if (isHeadLower)
			{
				_properties.HitChance[::Const.BodyPart.Head] = 100.0;
				_properties.HitChanceMult[::Const.BodyPart.Body] = 0.0;
			}
			else if (isBodyLower)
			{
				_properties.HitChance[::Const.BodyPart.Body] = 100.0;
				_properties.HitChanceMult[::Const.BodyPart.Head] = 0.0;
			}
		}
	}

	function getChance()
	{
		return ::Math.floor(this.getContainer().getActor().getCurrentProperties().getMeleeSkill() * 0.66);
	}

	function onQueryTooltip( _skill, _tooltip )
	{
		if (this.isSkillValid(_skill))
		{
			_tooltip.push({
				id = 100,
				type = "text",
				icon = ::Const.Perks.findById(this.getID()).Icon,
				text = ::Reforged.Mod.Tooltips.parseString(this.format("有%s概率命中目标护甲值较低的身体部分", ::MSU.Text.colorPositive(this.getChance() + "%")))
			});
		}
	}

	function isSkillValid( _skill )
	{
		if (_skill.isRanged() || !_skill.isAttack() || this.m.RequiredDamageType != null && !_skill.getDamageType().contains(this.m.RequiredDamageType))
		{
			return false;
		}

		if (this.m.RequiredWeaponType == null)
		{
			return true;
		}

		local weapon = _skill.getItem();
		return !::MSU.isNull(weapon) && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(this.m.RequiredWeaponType);
	}

});
