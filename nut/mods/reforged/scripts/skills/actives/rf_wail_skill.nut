this.rf_wail_skill <- ::inherit("scripts/skills/skill", {
	m = {
		MoraleCheckDifficultyPerTile = -5
	},
	function create()
	{
		this.m.ID = "actives.rf_wail";
		this.m.Name = "尖嚎";
		this.m.Description = "将内心的煎熬化作一声凄厉的尖嚎。";
		this.m.Icon = "skills/rf_wail_skill.png";
		this.m.IconDisabled = "skills/rf_wail_skill_sw.png";
		this.m.Overlay = "rf_wail_skill";
		this.m.SoundOnUse = [
			"sounds/enemies/rf_wail_skill_01.wav",
			"sounds/enemies/rf_wail_skill_02.wav",
			"sounds/enemies/rf_wail_skill_03.wav",
			"sounds/enemies/rf_wail_skill_04.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsAttack = true;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 0;
		this.m.MinRange = 1;
		this.m.MaxRange = 6;
		this.m.MaxLevelDifference = 4;
		this.m.AIBehaviorID = ::Const.AI.Behavior.ID.Terror;
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString(this.format("对%i格内的所有敌人触发一次负面[士气检定|Concept.Morale]，目标每靠近你一格，检定便受到%s点[决心值|Concept.Bravery]的累加惩罚。", this.getMaxRange(), ::MSU.Text.colorizeValue(this.m.MoraleCheckDifficultyPerTile, {
				AddSign = true
			})))
		});
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString(this.format("因此技能降低[士气|Concept.Morale]等级的目标会被施加[悲痛萎靡|Skill+rf_grieving_malaise_effect]效果"))
		});
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		if (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + "使出了" + this.getName());
		}

		local myTile = _user.getTile();
		local difficulty = this.m.MoraleCheckDifficultyPerTile * this.getMaxRange();

		foreach( actor in ::Tactical.Entities.getHostileActors(_user.getFaction(), myTile, this.getMaxRange()) )
		{
			local dist = myTile.getDistanceTo(actor.getTile()) - 1;

			if (actor.checkMorale(-1, difficulty - this.m.MoraleCheckDifficultyPerTile * dist, ::Const.MoraleCheckType.MentalAttack))
			{
				actor.getSkills().add(::new("scripts/skills/effects/rf_grieving_malaise_effect"));
			}
		}
	}

});
