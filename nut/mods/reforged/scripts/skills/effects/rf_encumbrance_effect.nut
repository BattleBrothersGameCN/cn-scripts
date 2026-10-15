this.rf_encumbrance_effect <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.rf_encumbrance";
		this.m.Name = "不堪重负";
		this.m.Description = "该角色的护甲重量超过了其承受能力。累赘度共分4个等级，分别在疲劳值上限降至50，40，30，20点时生效。仅在头身总护甲疲劳值惩罚超过20点时生效。";
		this.m.Icon = "skills/rf_encumbrance_effect.png";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsSerialized = false;
	}

	function isHidden()
	{
		return this.getEncumbranceLevel() == 0 || !this.getContainer().getActor().isPlayerControlled();
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		local level = this.getEncumbranceLevel();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "当前" + this.m.Name + "等级：" + ::MSU.Text.colorNegative(level)
		});
		local fatigueBuildUp = this.getFatigueOnTurnStart(level);

		if (fatigueBuildUp != 0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("+" + fatigueBuildUp) + " [Fatigue|Concept.Fatigue] at the start of every [turn|Concept.Turn]")
			});
		}

		local travelCost = this.getMovementFatigueCostModifier(level);

		if (travelCost != 0)
		{
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("+" + travelCost) + " [Fatigue|Concept.Fatigue] built per tile traveled")
			});
		}

		return ret;
	}

	function getEncumbranceLevel()
	{
		if (this.getContainer().getActor().getItems().getStaminaModifier([
			::Const.ItemSlot.Body,
			::Const.ItemSlot.Head
		]) > -20)
		{
			return 0;
		}

		local fat = this.getContainer().getActor().getFatigueMax();

		if (fat < 20)
		{
			return 4;
		}
		else if (fat < 30)
		{
			return 3;
		}
		else if (fat < 40)
		{
			return 2;
		}
		else if (fat < 50)
		{
			return 1;
		}

		return 0;
	}

	function getMovementFatigueCostModifier( _encumbranceLevel )
	{
		switch(_encumbranceLevel)
		{
		case 0:
		case 1:
			return 0;

		case 2:
			return 1;

		case 3:
			return 3;
		}

		return 3;
	}

	function getFatigueOnTurnStart( _encumbranceLevel )
	{
		switch(_encumbranceLevel)
		{
		case 0:
			return 0;

		case 1:
			return 1;

		case 2:
		case 3:
			return 2;
		}

		return 3;
	}

	function onUpdate( _properties )
	{
		_properties.MovementFatigueCostAdditional += this.getMovementFatigueCostModifier(this.getEncumbranceLevel());
	}

	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
		actor.setFatigue(::Math.min(actor.getFatigueMax(), actor.getFatigue() + this.getFatigueOnTurnStart(this.getEncumbranceLevel())));
	}

});
