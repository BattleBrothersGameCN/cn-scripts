this.rf_old_swordmaster_scenario_recruit_effect <- ::inherit("scripts/skills/effects/rf_old_swordmaster_scenario_abstract_effect", {
	m = {
		FreePerkChancePerLevel = 10,
		FreePerksGainedIDs = []
	},
	function create()
	{
		this.rf_old_swordmaster_scenario_abstract_effect.create();
		this.m.ID = "effects.rf_old_swordmaster_scenario_recruit";
		this.m.Name = "剑师训练";
		this.m.Description = "该角色正受一名大成的剑术大师训练，持剑的战斗效率得到提升。该效果会随着等级提升变强。";
		this.m.Icon = "skills/rf_old_swordmaster_scenario_recruit_effect.png";
	}

	function getTooltip()
	{
		local ret = this.rf_old_swordmaster_scenario_abstract_effect.getTooltip();

		if (!this.isEnabled())
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::MSU.Text.colorRed("需要装备剑")
			});
		}
		else
		{
			local skillBonus = this.getBonus();
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
					icon = "ui/icons/initiative.png",
					text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(skillBonus, {
						AddSign = true
					}) + "[主动值|Concept.Initiative]")
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

		if (this.getFreePerkChance() != 0)
		{
			local hasPotentialPerk = false;

			foreach( row in ::DynamicPerks.PerkGroups.findById("pg.rf_sword").getTree() )
			{
				foreach( perkID in row )
				{
					if (this.m.FreePerksGainedIDs.find(perkID) == null)
					{
						ret.push({
							id = 14,
							type = "text",
							icon = "ui/icons/special.png",
							text = ::Reforged.Mod.Tooltips.parseString(this.format("[升级|Concept.Level]时，有%s概率习得一个随机的剑特技组[特技|Concept.Perk]。如果是已经学习的[特技|Concept.Perk]，则会返还消耗的[特技|Concept.Perk]点数。", ::MSU.Text.colorizeValue(this.getFreePerkChance(), {
								AddPercent = true
							})))
						});
						hasPotentialPerk = true;
						break;
					}
				}

				if (hasPotentialPerk)
				{
					break;
				}
			}
		}

		if (this.m.FreePerksGainedIDs.len() != 0)
		{
			local freePerks = "";

			foreach( id in this.m.FreePerksGainedIDs )
			{
				freePerks = freePerks + ::Reforged.NestedTooltips.getNestedPerkImage(this.getContainer().getSkillByID(id));
			}

			if (freePerks != "")
			{
				ret.push({
					id = 15,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("免费习得特技：\n" + freePerks)
				});
			}
		}

		return ret;
	}

	function getBonus()
	{
		return this.getContainer().getActor().getLevel();
	}

	function onUpdate( _properties )
	{
		this.rf_old_swordmaster_scenario_abstract_effect.onUpdate(_properties);
		local actor = this.getContainer().getActor();

		if (this.isEnabled())
		{
			local bonus = this.getBonus();
			_properties.MeleeSkill += bonus;
			_properties.MeleeDefense += bonus;
			_properties.Initiative += bonus;
			_properties.DamageDirectAdd += bonus * 0.01;
		}
	}

	function getFreePerkChance()
	{
		return this.getContainer().getActor().getPerkTree().hasPerkGroup("pg.rf_sword") ? this.m.FreePerkChancePerLevel : 0;
	}

	function onUpdateLevel()
	{
		local actor = this.getContainer().getActor();
		::Reforged.Math.seedRandom(actor.getUID(), this.getID(), actor.getLevel());

		if (::Math.rand(1, 100) <= this.getFreePerkChance() && actor.getPerkTree().hasPerkGroup("pg.rf_sword"))
		{
			local potentialPerks = [];

			foreach( row in ::DynamicPerks.PerkGroups.findById("pg.rf_sword").getTree() )
			{
				foreach( perkID in row )
				{
					if (this.m.FreePerksGainedIDs.find(perkID) == null)
					{
						potentialPerks.push(perkID);
					}
				}
			}

			if (potentialPerks.len() != 0)
			{
				local chosenID = ::MSU.Array.rand(potentialPerks);
				local preExistingPerk = this.getContainer().getSkillByID(chosenID);

				if (preExistingPerk != null && preExistingPerk.isRefundable())
				{
					actor.m.PerkPoints++;
					actor.m.PerkPointsSpent--;
				}

				if (preExistingPerk != null && preExistingPerk.isSerialized())
				{
					preExistingPerk.m.IsRefundable = false;
				}
				else
				{
					this.getContainer().add(::Reforged.new(::Const.Perks.findById(chosenID).Script, function ( o )
					{
						o.m.IsRefundable = false;
					}));
				}

				this.m.FreePerksGainedIDs.push(chosenID);
			}
		}

		::Math.seedRandom(::Time.getRealTime() + actor.getUID() * 100);
	}

	function onSerialize( _out )
	{
		this.rf_old_swordmaster_scenario_abstract_effect.onSerialize(_out);
		::MSU.Serialization.serialize(this.m.FreePerksGainedIDs, _out);
	}

	function onDeserialize( _in )
	{
		this.rf_old_swordmaster_scenario_abstract_effect.onDeserialize(_in);
		this.m.FreePerksGainedIDs = ::MSU.Serialization.deserialize(_in);
	}

});
