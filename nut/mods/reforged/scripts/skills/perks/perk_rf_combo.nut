this.perk_rf_combo <- ::inherit("scripts/skills/skill", {
	m = {
		ActionPointCostModifier = -1,
		ActionPointCostMin = 3,
		IsInEffect = false,
		IsUsingValidSkill = false
	},
	function create()
	{
		this.m.ID = "perk.rf_combo";
		this.m.Name = ::Const.Strings.PerkName.RF_Combo;
		this.m.Description = "还是那招，一，二！";
		this.m.Icon = "ui/perks/perk_rf_combo.png";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function isHidden()
	{
		return !this.m.IsInEffect;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		local minimumString = this.m.ActionPointCostMin == 0 ? "" : " to a minimum of " + this.m.ActionPointCostMin;
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::Reforged.Mod.Tooltips.parseString(this.format("技能消耗%s[行动点数|Concept.ActionPoints]%s", ::MSU.Text.colorizeValue(this.m.ActionPointCostModifier, {
				InvertColor = true,
				AddSign = true
			}), minimumString))
		});
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/warning.png",
			text = ::Reforged.Mod.Tooltips.parseString("会在使用技能，[等待|Concept.Wait]或结束[回合|Concept.Turn]后失效")
		});
		return ret;
	}

	function onBeforeAnySkillExecuted( _skill, _targetTile, _targetEntity, _forFree )
	{
		this.m.IsUsingValidSkill = !_forFree && _skill.getActionPointCost() != 0;
	}

	function onAnySkillExecutedFully( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (this.m.IsInEffect)
		{
			if (!_forFree)
			{
				this.m.IsInEffect = false;
			}
		}
		else if (this.m.IsUsingValidSkill)
		{
			this.m.IsInEffect = true;
		}
	}

	function onAfterUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		local applyEffect = this.m.IsInEffect;

		if (actor.isPreviewing() && actor.getPreviewSkill() != null)
		{
			applyEffect = !this.m.IsInEffect && actor.getPreviewSkill().getActionPointCost() != 0;
		}

		if (applyEffect)
		{
			foreach( skill in this.getContainer().getAllSkillsOfType(::Const.SkillType.Active) )
			{
				if (skill.m.ActionPointCost > this.m.ActionPointCostMin)
				{
					skill.m.ActionPointCost += this.m.ActionPointCostModifier;
				}
			}
		}
	}

	function onWaitTurn()
	{
		this.m.IsInEffect = false;
	}

	function onTurnEnd()
	{
		this.m.IsInEffect = false;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.IsInEffect = false;
	}

});
