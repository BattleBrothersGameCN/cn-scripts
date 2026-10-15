this.rf_old_swordmaster_scenario_avatar_effect <- ::inherit("scripts/skills/effects/rf_old_swordmaster_scenario_abstract_effect", {
	m = {
		OldAgeStartDays = 30,
		NumRecruitsRequired = 5,
		DaysWithoutRecruits = 0,
		DaysWithoutRecruitsMax = 15,
		MaxMalus = 30
	},
	function create()
	{
		this.rf_old_swordmaster_scenario_abstract_effect.create();
		this.m.ID = "effects.rf_old_swordmaster_scenario_avatar";
		this.m.Name = "剑师技艺";
		this.m.Description = "这家伙是一位远近闻名的剑术大师 - 所谓的传奇人物。该效果会随着角色升级而变强。然而，随着时间流逝，衰老会夺走一部分属性值。";
		this.m.Icon = "skills/rf_old_swordmaster_scenario_avatar_effect.png";
	}

	function getTooltip()
	{
		local ret = this.rf_old_swordmaster_scenario_abstract_effect.getTooltip();

		if (!this.isEnabled())
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::MSU.Text.colorRed("需要装备剑")
			});
		}
		else
		{
			local skillBonus = this.getSkillBonus();
			ret.extend([
				{
					id = 10,
					type = "text",
					icon = "ui/icons/melee_skill.png",
					text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(skillBonus, {
						AddSign = true
					}) + "[近战技能|Concept.MeleeSkill]")
				},
				{
					id = 11,
					type = "text",
					icon = "ui/icons/melee_defense.png",
					text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(skillBonus, {
						AddSign = true
					}) + "[近战防御|Concept.MeleeDefense]")
				},
				{
					id = 12,
					type = "text",
					icon = "ui/icons/bravery.png",
					text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(skillBonus, {
						AddSign = true
					}) + "[决心值|Concept.Bravery]")
				},
				{
					id = 13,
					type = "text",
					icon = "ui/icons/direct_damage.png",
					text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(skillBonus, {
						AddSign = true,
						AddPercent = true
					}) + "伤害穿甲率")
				}
			]);
		}

		local skillMalus = this.getSkillMalus();

		if (skillMalus > 0)
		{
			ret.extend([
				{
					id = 14,
					type = "text",
					icon = "ui/icons/health.png",
					text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(-skillMalus, {
						AddSign = true
					}) + "[生命值|Concept.Hitpoints]")
				},
				{
					id = 15,
					type = "text",
					icon = "ui/icons/fatigue.png",
					text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(-skillMalus, {
						AddSign = true
					}) + "[疲劳值上限|Concept.Fatigue]")
				},
				{
					id = 16,
					type = "text",
					icon = "ui/icons/initiative.png",
					text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(::Math.floor(-skillMalus * 1.5), {
						AddSign = true
					}) + "[主动值|Concept.Initiative]")
				},
				{
					id = 17,
					type = "text",
					icon = "ui/icons/fatigue.png",
					text = ::Reforged.Mod.Tooltips.parseString("[疲劳值|Concept.Fatigue]积累" + ::MSU.Text.colorizeMultWithText(1.0 + 2 * skillMalus * 0.01, {
						InvertColor = true
					}) + " [Fatigue|Concept.Fatigue]")
				}
			]);
		}

		if (this.m.DaysWithoutRecruits > 0)
		{
			ret.push({
				id = 21,
				type = "text",
				icon = "ui/icons/warning.png",
				text = "若队伍中的新兵不足" + ::MSU.Text.colorNegative(this.m.DaysWithoutRecruitsMax) + "人，总计" + ::MSU.Text.colorNegative(this.m.NumRecruitsRequired) + "天后战役就会自动结束。已经过了" + ::MSU.Text.colorNegative(this.m.DaysWithoutRecruits) + "天。"
			});
		}

		return ret;
	}

	function getSkillBonus()
	{
		return this.getContainer().getActor().getLevel();
	}

	function getSkillMalus()
	{
		if (::World.Flags.get("RF_OldSwordmasterScenario_OldAgeEvent_1"))
		{
			return ::Math.min(this.m.MaxMalus, ::Math.max(1, (::World.getTime().Days - this.m.OldAgeStartDays) / 10));
		}

		return 0;
	}

	function getPlayerPartyStrengthMult()
	{
		if (::World.Flags.has("RF_OldSwordmasterScenario_OldAgeEvent_4"))
		{
			return 1.0;
		}

		if (::World.Flags.has("RF_OldSwordmasterScenario_OldAgeEvent_3"))
		{
			return 1.5;
		}

		if (::World.Flags.has("RF_OldSwordmasterScenario_OldAgeEvent_2"))
		{
			return 2.0;
		}

		if (::World.Flags.has("RF_OldSwordmasterScenario_OldAgeEvent_1"))
		{
			return 2.5;
		}

		return 3.0;
	}

	function onUpdate( _properties )
	{
		this.rf_old_swordmaster_scenario_abstract_effect.onUpdate(_properties);
		_properties.MV_StrengthMult *= this.getPlayerPartyStrengthMult();
		local actor = this.getContainer().getActor();

		if (this.isEnabled())
		{
			local skillBonus = this.getSkillBonus();
			_properties.MeleeSkill += skillBonus;
			_properties.MeleeDefense += skillBonus;
			_properties.Bravery += skillBonus;
			_properties.DamageDirectAdd += skillBonus * 0.01;
		}

		local skillMalus = this.getSkillMalus();
		_properties.Stamina -= skillMalus;
		_properties.Initiative -= ::Math.floor(skillMalus * 1.5);
		_properties.Hitpoints -= skillMalus;
		_properties.FatigueEffectMult *= 1.0 + 2 * skillMalus * 0.01;
	}

	function onNewDay()
	{
		local bros = ::World.getPlayerRoster().getAll();

		if (bros.len() < this.m.NumRecruitsRequired)
		{
			this.m.DaysWithoutRecruits++;

			if (this.m.DaysWithoutRecruits > this.m.DaysWithoutRecruitsMax)
			{
				::World.Events.fire("event.rf_old_swordmaster_scenario_no_recruits_force_end");
				return;
			}
		}

		local hasMet = ::World.Flags.get("RF_OldSwordmasterScenario_OldAgeEvent_1");

		if (!hasMet && bros.len() >= 3 && ::World.getTime().Days >= this.m.OldAgeStartDays)
		{
			if (::World.Events.fire("event.rf_old_swordmaster_scenario_old_age_1"))
			{
				::World.Flags.set("RF_OldSwordmasterScenario_OldAgeEvent_1", true);
			}
		}

		hasMet = ::World.Flags.get("RF_OldSwordmasterScenario_OldAgeEvent_2");

		if (!hasMet && bros.len() >= 3 && ::World.getTime().Days >= this.m.OldAgeStartDays * 2)
		{
			if (::World.Events.fire("event.rf_old_swordmaster_scenario_old_age_2"))
			{
				::World.Flags.set("RF_OldSwordmasterScenario_OldAgeEvent_2", true);
			}
		}

		hasMet = ::World.Flags.get("RF_OldSwordmasterScenario_OldAgeEvent_3");

		if (!hasMet && bros.len() >= 3 && ::World.getTime().Days >= this.m.OldAgeStartDays * 3)
		{
			if (::World.Events.fire("event.rf_old_swordmaster_scenario_old_age_3"))
			{
				::World.Flags.set("RF_OldSwordmasterScenario_OldAgeEvent_3", true);
			}
		}

		hasMet = ::World.Flags.get("RF_OldSwordmasterScenario_OldAgeEvent_4");

		if (!hasMet && bros.len() >= 3 && ::World.getTime().Days >= this.m.OldAgeStartDays * 4)
		{
			if (::World.Events.fire("event.rf_old_swordmaster_scenario_old_age_4"))
			{
				::World.Flags.set("RF_OldSwordmasterScenario_OldAgeEvent_4", true);
			}
		}
	}

	function onSerialize( _out )
	{
		this.rf_old_swordmaster_scenario_abstract_effect.onSerialize(_out);
		_out.writeU16(this.m.DaysWithoutRecruits);
	}

	function onDeserialize( _in )
	{
		this.rf_old_swordmaster_scenario_abstract_effect.onDeserialize(_in);
		this.m.DaysWithoutRecruits = _in.readU16();
	}

});
