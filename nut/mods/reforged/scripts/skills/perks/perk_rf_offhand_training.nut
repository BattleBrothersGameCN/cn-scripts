this.perk_rf_offhand_training <- ::inherit("scripts/skills/skill", {
	m = {
		StaminaModifierThreshold = -10,
		IsSpent = true,
		IsConsumingFreeUse = false
	},
	function create()
	{
		this.m.ID = "perk.rf_offhand_training";
		this.m.Name = ::Const.Strings.PerkName.RF_OffhandTraining;
		this.m.Description = "该角色善于使用工具和小盾等副手物品。";
		this.m.Icon = "ui/perks/perk_rf_offhand_training.png";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Last;
		this.m.ItemActionOrder = ::Const.ItemActionOrder.BeforeLast;
	}

	function isHidden()
	{
		return this.m.IsSpent;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("本[回合|Concept.Turn]中，首次使用重量小于" + ::MSU.Text.colorNegative(-this.m.StaminaModifierThreshold) + "的副手物品在本[回合|Concept.Turn]内首次使用时不消耗[行动点数|Concept.ActionPoints]")
		});
		return ret;
	}

	function onAdded()
	{
		this.getContainer().add(::new("scripts/skills/effects/rf_trip_artist_effect"));
	}

	function onRemoved()
	{
		this.getContainer().removeByID("effects.rf_trip_artist");
	}

	function onBeforeAnySkillExecuted( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (this.m.IsSpent || _forFree || !::Tactical.TurnSequenceBar.isActiveEntity(this.getContainer().getActor()))
		{
			return;
		}

		if (!::MSU.isNull(_skill.getItem()) && ::MSU.isEqual(_skill.getItem(), this.getContainer().getActor().getOffhandItem()))
		{
			this.m.IsConsumingFreeUse = true;
		}
	}

	function onAnySkillExecuted( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (this.m.IsConsumingFreeUse)
		{
			this.m.IsSpent = true;
		}
	}

	function onAfterUpdate( _properties )
	{
		if (this.m.IsSpent)
		{
			return;
		}

		local offhand = this.getContainer().getActor().getOffhandItem();

		if (offhand != null && offhand.getStaminaModifier() > this.m.StaminaModifierThreshold)
		{
			foreach( skill in offhand.getSkills() )
			{
				skill.m.ActionPointCost = 0;
			}
		}
	}

	function onTurnStart()
	{
		this.m.IsConsumingFreeUse = false;
		this.m.IsSpent = false;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.IsConsumingFreeUse = false;
		this.m.IsSpent = true;
	}

});
