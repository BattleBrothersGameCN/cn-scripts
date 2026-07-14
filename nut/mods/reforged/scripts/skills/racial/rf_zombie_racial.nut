this.rf_zombie_racial <- ::inherit("scripts/skills/skill", {
	m = {
		FatigueEffectMult = 0.0,
		FatigueDealtPerHitMultModifier = 1.0
	},
	function create()
	{
		this.m.ID = "racial.rf_zombie";
		this.m.Name = "僵尸";
		this.m.Description = "该角色是僵尸。";
		this.m.Icon = "ui/orientation/zombie_01_orientation.png";
		this.m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Last;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (this.m.FatigueEffectMult == 0.0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = ::Reforged.Mod.Tooltips.parseString("不会积累[疲劳值|Concept.Fatigue]")
			});
		}
		else if (this.m.FatigueEffectMult != 1.0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = ::Reforged.Mod.Tooltips.parseString("少积累" + ::MSU.Text.colorizeMult(this.m.FatigueEffectMult, {
					InvertColor = true
				}) + "点[疲劳值|Concept.Fatigue]")
			});
		}

		local bonusFatiguePerHit = ::Const.Combat.FatigueReceivedPerHit * this.m.FatigueDealtPerHitMultModifier;

		if (bonusFatiguePerHit != 0.0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = ::Reforged.Mod.Tooltips.parseString("命中时额外施加" + ::MSU.Text.color(::Const.UI.Color.DamageValue, bonusFatiguePerHit) + "点[疲劳值|Concept.Fatigue]")
			});
		}

		ret.push({
			id = 12,
			type = "text",
			icon = "ui/orientation/zombie_01_orientation.png",
			text = "被其击杀的人类稍后会变成僵尸复活"
		});
		ret.extend([
			{
				id = 20,
				type = "text",
				icon = "ui/icons/special.png",
				text = "不受黑夜惩罚影响"
			},
			{
				id = 21,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("不会遭受[临时创伤|Concept.InjuryTemporary]")
			},
			{
				id = 22,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("免疫[流血|Skill+bleeding_effect]")
			},
			{
				id = 23,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("免疫毒素")
			},
			{
				id = 24,
				type = "text",
				icon = "ui/icons/morale.png",
				text = ::Reforged.Mod.Tooltips.parseString("不受[士气|Concept.Morale]影响")
			}
		]);
		return ret;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		actor.m.MoraleState = ::Const.MoraleState.Ignore;
		local baseProperties = actor.getBaseProperties();
		baseProperties.IsAffectedByNight = false;
		baseProperties.IsAffectedByInjuries = false;
		baseProperties.IsImmuneToBleeding = true;
		baseProperties.IsImmuneToPoison = true;
		baseProperties.FatigueEffectMult = this.m.FatigueEffectMult;
		baseProperties.FatigueDealtPerHitMult += this.m.FatigueDealtPerHitMultModifier;
	}

});
