this.rf_adjust_dented_armor_skill <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.rf_adjust_dented_armor";
		this.m.Name = "整修护甲";
		this.m.Description = "整修你凹损的护甲。尽管又花时间又费精力，为了重新获得机动力，这些都是值得的。";
		this.m.Icon = "skills/rf_adjust_dented_armor_skill.png";
		this.m.IconDisabled = "skills/rf_adjust_dented_armor_skill_sw.png";
		this.m.Overlay = "rf_adjust_dented_armor_skill";
		this.m.SoundOnUse = [
			"sounds/ambience/settlement/fortification_armor_weapons_00.wav",
			"sounds/ambience/settlement/fortification_armor_weapons_01.wav",
			"sounds/ambience/settlement/fortification_armor_weapons_02.wav",
			"sounds/ambience/settlement/fortification_armor_weapons_03.wav",
			"sounds/ambience/settlement/fortification_armor_weapons_04.wav",
			"sounds/ambience/settlement/fortification_armor_weapons_05.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.Last;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 7;
		this.m.FatigueCost = 30;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("移除[护甲凹损|Skill+rf_dented_armor_effect]效果")
		});

		if (this.getContainer().getActor().isEngagedInMelee())
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("角色[陷入近战|Concept.ZoneOfControl]，无法使用"))
			});
		}

		return ret;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.getContainer().getActor().isEngagedInMelee();
	}

	function onUse( _user, _targetTile )
	{
		this.spawnIcon("rf_adjust_dented_armor_ally_skill", _user.getTile());
		this.getContainer().removeByID("effects.rf_dented_armor");
		_user.setDirty(true);
		return true;
	}

});
