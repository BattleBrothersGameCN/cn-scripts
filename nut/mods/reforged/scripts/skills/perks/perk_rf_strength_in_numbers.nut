this.perk_rf_strength_in_numbers <- ::inherit("scripts/skills/skill", {
	m = {
		SkillBonus = 2,
		ResolveBonus = 5
	},
	function create()
	{
		this.m.ID = "perk.rf_strength_in_numbers";
		this.m.Name = "人多势众";
		this.m.Description = "与盟友并肩作战时，该角色的武技会得到提升。";
		this.m.Icon = "ui/perks/perk_rf_strength_in_numbers.png";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function isHidden()
	{
		return this.getSkillBonus() == 0 && this.getResolveBonus() == 0;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		local bonus = this.getSkillBonus();

		if (bonus > 0)
		{
			ret.extend([
				{
					id = 10,
					type = "text",
					icon = "ui/icons/melee_skill.png",
					text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+" + bonus) + "[近战技能|Concept.MeleeSkill]")
				},
				{
					id = 11,
					type = "text",
					icon = "ui/icons/ranged_skill.png",
					text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+" + bonus) + "[远程技能|Concept.RangeSkill]")
				},
				{
					id = 12,
					type = "text",
					icon = "ui/icons/melee_defense.png",
					text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+" + bonus) + "[近战防御|Concept.MeleeDefense]")
				},
				{
					id = 13,
					type = "text",
					icon = "ui/icons/ranged_defense.png",
					text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+" + bonus) + "[远程防御|Concept.RangeDefense]")
				}
			]);
		}

		local resolveBonus = this.getResolveBonus();

		if (resolveBonus > 0)
		{
			ret.push({
				id = 14,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+" + this.getResolveBonus()) + "[决心|Concept.Bravery]")
			});
		}

		return ret;
	}

	function getSkillBonus()
	{
		if (!this.getContainer().getActor().isPlacedOnMap())
		{
			return 0;
		}

		return ::Tactical.Entities.getAlliedActors(this.getContainer().getActor().getFaction(), this.getContainer().getActor().getTile(), 1, true).len() * this.m.SkillBonus;
	}

	function getResolveBonus()
	{
		if (!this.getContainer().getActor().isPlacedOnMap())
		{
			return 0;
		}

		return ::Tactical.Entities.getAlliedActors(this.getContainer().getActor().getFaction(), this.getContainer().getActor().getTile(), 1, true).len() * this.m.ResolveBonus;
	}

	function onUpdate( _properties )
	{
		local bonus = this.getSkillBonus();

		if (bonus > 0)
		{
			_properties.MeleeSkill += bonus;
			_properties.RangedSkill += bonus;
			_properties.MeleeDefense += bonus;
			_properties.RangedDefense += bonus;
		}

		_properties.Bravery += this.getResolveBonus();
	}

});
