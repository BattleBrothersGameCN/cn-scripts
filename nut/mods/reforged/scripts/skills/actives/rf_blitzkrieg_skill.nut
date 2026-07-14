this.rf_blitzkrieg_skill <- ::inherit("scripts/skills/skill", {
	m = {
		IsSpent = false
	},
	function create()
	{
		this.m.ID = "actives.rf_blitzkrieg";
		this.m.Name = "闪电战";
		this.m.Description = "命令你的部下尽快进攻！";
		this.m.Icon = "skills/rf_blitzkrieg_skill.png";
		this.m.IconDisabled = "skills/rf_blitzkrieg_skill_sw.png";
		this.m.Overlay = "rf_blitzkrieg_skill";
		this.m.SoundOnUse = [
			"sounds/combat/rf_blitzkrieg_skill_1.wav",
			"sounds/combat/rf_blitzkrieg_skill_2.wav",
			"sounds/combat/rf_blitzkrieg_skill_3.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 7;
		this.m.FatigueCost = 30;
		this.m.AIBehaviorID = ::Const.AI.Behavior.ID.RF_Blitzkrieg;
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("使你和" + ::MSU.Text.colorPositive("4") + "格内至少还有" + ::MSU.Text.colorNegative("10") + "点 [疲劳|Concept.Fatigue]的盟友获得[肾上腺素|Skill+adrenaline_effect]效果并积累" + ::MSU.Text.colorNegative("10") + "点[疲劳|Concept.Fatigue]")
		});
		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/warning.png",
			text = ::Reforged.Mod.Tooltips.parseString("不影响[溃逃、|Concept.Morale][昏迷|Skill+stunned_effect]或[沉睡|Skill+sleeping_effect]的盟友")
		});
		ret.push({
			id = 21,
			type = "text",
			icon = "ui/icons/warning.png",
			text = "每天限一次（全战团）"
		});

		if (this.m.IsSpent)
		{
			ret.push({
				id = 22,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::MSU.Text.colorNegative("战团今天已经使用过")
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
				local skill = bro.getSkills().getSkillByID("actives.rf_blitzkrieg");

				if (skill != null)
				{
					skill.m.IsSpent = true;
				}
			}
		}

		local myTile = _user.getTile();

		foreach( ally in ::Tactical.Entities.getInstancesOfFaction(_user.getFaction()) )
		{
			if (ally.getMoraleState() == ::Const.MoraleState.Fleeing || ally.getCurrentProperties().IsStunned || ally.isNonCombatant())
			{
				continue;
			}

			if (ally.getID() == _user.getID())
			{
				this.getContainer().add(::new("scripts/skills/effects/adrenaline_effect"));
			}
			else if (ally.getTile().getDistanceTo(myTile) <= 4 && ally.getFatigueMax() - ally.getFatigue() >= 10)
			{
				ally.setFatigue(ally.getFatigue() + 10);
				local effect = ::new("scripts/skills/effects/adrenaline_effect");

				if (!ally.isTurnStarted() && !ally.isTurnDone())
				{
					effect.m.TurnsLeft++;
				}

				ally.getSkills().add(effect);
			}
		}

		return true;
	}

	function onNewMorning()
	{
		this.m.IsSpent = false;
	}

});
