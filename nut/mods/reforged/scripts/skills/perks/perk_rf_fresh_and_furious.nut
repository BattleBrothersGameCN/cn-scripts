this.perk_rf_fresh_and_furious <- ::inherit("scripts/skills/skill", {
	m = {
		FatigueThreshold = 0.3,
		ActionPointsRecoveredPct = 0.5,
		UsedSkillAPCost = 0,
		IsSpent = true,
		RequiresRecover = false,
		IconMiniBackup = ""
	},
	function create()
	{
		this.m.ID = "perk.rf_fresh_and_furious";
		this.m.Name = ::Const.Strings.PerkName.RF_FreshAndFurious;
		this.m.Description = "该角色不疲劳时速度极快。";
		this.m.Icon = "ui/perks/perk_rf_fresh_and_furious.png";
		this.m.IconMini = "perk_rf_fresh_and_furious_mini";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Any;
		this.m.IconMiniBackup = this.m.IconMini;
	}

	function isHidden()
	{
		return this.m.IsSpent;
	}

	function getName()
	{
		return this.m.RequiresRecover ? this.m.Name + "（失效了）" : this.m.Name;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (this.m.RequiresRecover)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("在使用[$ $|Skill+recover_skill]技能前失效"))
			});
		}
		else
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("下个技能消耗的[行动点数|Concept.ActionPoints]会返还" + ::MSU.Text.colorizePct(this.m.ActionPointsRecoveredPct) + " of its [Action Point|Concept.ActionPoints] cost")
			});
		}

		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/warning.png",
			text = ::Reforged.Mod.Tooltips.parseString("使用不消耗[行动点数|Concept.ActionPoints]的技能不会使其失效，但在[等待|Concept.Wait]后会失效")
		});

		if (this.getContainer().getActor().getID() == ::MSU.getDummyPlayer().getID())
		{
			ret.push({
				id = 21,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("积累的[疲劳值|Concept.Fatigue]不低于" + ::MSU.Text.colorizePct(this.m.FatigueThreshold, {
					InvertColor = true
				}) + "点或更多[疲劳|Concept.Fatigue]时失效")
			});
		}
		else
		{
			ret.push({
				id = 21,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString(this.format("回合开始时，若积累的[疲劳值|Concept.Fatigue]不低于%s(%s)点，特技失效", ::MSU.Text.colorizePct(this.m.FatigueThreshold, {
					InvertColor = true
				}), ::MSU.Text.colorNegative(::Math.round(this.m.FatigueThreshold * this.getContainer().getActor().getFatigueMax()))))
			});
		}

		return ret;
	}

	function onBeforeAnySkillExecuted( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (_forFree)
		{
			return;
		}

		this.m.UsedSkillAPCost = _skill.getActionPointCost();
	}

	function onAnySkillExecuted( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (_skill.getID() == "actives.recover")
		{
			this.m.RequiresRecover = false;
			this.m.IsSpent = true;
		}
		else if (!this.m.IsSpent && !this.m.RequiresRecover && this.m.UsedSkillAPCost != 0)
		{
			this.m.IsSpent = true;
			local actor = this.getContainer().getActor();
			actor.setActionPoints(::Math.min(actor.getActionPointsMax(), actor.getActionPoints() + this.m.UsedSkillAPCost * this.m.ActionPointsRecoveredPct));
		}
	}

	function onCostsPreview( _costsPreview )
	{
		local actor = this.getContainer().getActor();

		if (!this.m.IsSpent && !this.m.RequiresRecover && actor.isPreviewing() && actor.getPreviewSkill() != null && actor.getPreviewSkill().getActionPointCost() != 0)
		{
			_costsPreview.actionPointsPreview += ::Math.floor(actor.getPreviewSkill().getActionPointCost() * this.m.ActionPointsRecoveredPct);
		}
	}

	function onTurnStart()
	{
		this.m.IsSpent = false;

		if (this.getContainer().getActor().getFatigue() < this.m.FatigueThreshold * this.getContainer().getActor().getFatigueMax())
		{
			this.m.Icon = ::Const.Perks.findById(this.getID()).Icon;
			this.m.IconMini = this.m.IconMiniBackup;
		}
		else
		{
			this.m.RequiresRecover = true;
			this.m.Icon = ::Const.Perks.findById(this.getID()).IconDisabled;
			this.m.IconMini = "";
		}
	}

	function onWaitTurn()
	{
		this.m.IsSpent = true;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.IsSpent = true;
		this.m.RequiresRecover = false;
	}

});
