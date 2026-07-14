this.rf_barrow_chant_effect <- ::inherit("scripts/skills/skill", {
	m = {
		RestlessnessChance = 50
	},
	function create()
	{
		this.m.ID = "effects.rf_barrow_chant";
		this.m.Name = "墓穴挽歌";
		this.m.Description = "一阵低沉而骇人的吟唱，安抚亡者，却不断消磨生者的精神，扼杀自信的萌发。";
		this.m.Icon = "ui/perks/perk_32.png";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("战场上的敌人不能达到[自信士气|Concept.Morale]")
		});
		local debuff = ::new("scripts/skills/effects/rf_barrow_chant_debuff_effect");

		if (debuff.m.DamageMultPerMoraleStateAdd != 0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("受影响的敌人士气每低于[自信|Concept.Morale]一级，造成的伤害" + ::MSU.Text.colorizeMultWithText(1.0 + debuff.m.DamageMultPerMoraleStateAdd) + " damage for each morale state below [Confident|Concept.Morale]")
			});
		}

		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("当你死亡时，每个墓穴族盟友有独立的" + ::MSU.Text.colorizeValue(this.m.RestlessnessChance, {
				AddPercent = true
			}) + "概率变得[$ $|Skill+rf_draugr_restless_effect]")
		});
		return ret;
	}

	function onDeath( _fatalityType )
	{
		local actor = this.getContainer().getActor();

		foreach( a in ::Tactical.Entities.getAllInstancesAsArray() )
		{
			a.getSkills().removeByID("effects.rf_barrow_chant_debuff");

			if (a.isAlliedWith(actor) && ::MSU.isKindOf(a, "rf_draugr") && ::Math.rand(1, 100) <= this.m.RestlessnessChance)
			{
				a.getSkills().add(::new("scripts/skills/effects/rf_draugr_restless_effect"));
			}
		}
	}

	function onActorSpawned( _actor )
	{
		if (::MSU.isEqual(_actor, this.getContainer().getActor()))
		{
			foreach( a in ::Tactical.Entities.getAllInstancesAsArray() )
			{
				a.getSkills().add(::new("scripts/skills/effects/rf_barrow_chant_debuff_effect"));
			}
		}
		else
		{
			_actor.getSkills().add(::new("scripts/skills/effects/rf_barrow_chant_debuff_effect"));
		}
	}

});
