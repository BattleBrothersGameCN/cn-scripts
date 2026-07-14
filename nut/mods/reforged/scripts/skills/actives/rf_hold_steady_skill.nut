this.rf_hold_steady_skill <- ::inherit("scripts/skills/skill", {
	m = {
		IsSpent = false,
		AllyDistanceMax = 4
	},
	function create()
	{
		this.m.ID = "actives.rf_hold_steady";
		this.m.Name = "稳住阵线";
		this.m.Description = "命令你的人坚守阵地！";
		this.m.Icon = "skills/rf_hold_steady_skill.png";
		this.m.IconDisabled = "skills/rf_hold_steady_skill_sw.png";
		this.m.Overlay = "rf_hold_steady_skill";
		this.m.SoundOnUse = [];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 7;
		this.m.FatigueCost = 30;
		this.m.AIBehaviorID = ::Const.AI.Behavior.ID.RF_HoldSteady;
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("使你和" + ::MSU.Text.colorPositive(this.m.AllyDistanceMax) + "格内的盟友获得[$ $|Skill+rf_hold_steady_effect]效果，持续2[轮|Concept.Round]")
		});
		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/warning.png",
			text = ::Reforged.Mod.Tooltips.parseString("不影响[溃逃、|Concept.Morale][$ $|Skill+stunned_effect]或[$ $|Skill+sleeping_effect]的盟友")
		});
		ret.push({
			id = 21,
			type = "text",
			icon = "ui/icons/warning.png",
			text = "每场战斗限一次（全战团）"
		});

		if (this.m.IsSpent)
		{
			ret.push({
				id = 22,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::MSU.Text.colorNegative("战团已在本场战斗中使用过")
			});
		}

		return ret;
	}

	function isUsable()
	{
		return !this.m.IsSpent && this.skill.isUsable();
	}

	function onUse( _user, _targetTile )
	{
		this.m.IsSpent = true;

		if (_user.isPlayerControlled())
		{
			local rosterBros = ::World.getPlayerRoster().getAll();

			foreach( bro in rosterBros )
			{
				local skill = bro.getSkills().getSkillByID("actives.rf_hold_steady");

				if (skill != null)
				{
					skill.m.IsSpent = true;
				}
			}
		}

		local myTile = _user.getTile();

		foreach( ally in ::Tactical.Entities.getInstancesOfFaction(_user.getFaction()) )
		{
			if (ally.isNonCombatant())
			{
				continue;
			}

			local skill = ally.getSkills().getSkillByID("actives.rf_hold_steady");

			if (skill != null)
			{
				skill.m.IsSpent = true;
			}

			if (ally.getMoraleState() == ::Const.MoraleState.Fleeing || ally.getCurrentProperties().IsStunned || ally.getTile().getDistanceTo(myTile) > this.m.AllyDistanceMax)
			{
				continue;
			}

			ally.getSkills().add(::new("scripts/skills/effects/rf_hold_steady_effect"));
		}

		return true;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.IsSpent = false;
	}

});
