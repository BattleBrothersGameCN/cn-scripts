this.perk_rf_decisive <- ::inherit("scripts/skills/skill", {
	m = {
		BraveryMult = 1.15,
		InitiativeMult = 1.15,
		FatigueCostMult = 0.85,
		DamageMult = 1.15,
		AttractionMult = 1.1,
		MaxStacks = 3,
		Stacks = 0,
		OriginalIconMini = "perk_rf_decisive_mini"
	},
	function create()
	{
		this.m.ID = "perk.rf_decisive";
		this.m.Name = ::Const.Strings.PerkName.RF_Decisive;
		this.m.Description = "该角色能自信而毫不犹豫地做出迅速决定。";
		this.m.Icon = "ui/perks/perk_rf_decisive.png";
		this.m.IconMini = "";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function getName()
	{
		return this.m.Stacks == 0 ? this.m.Name : this.m.Name + " (x" + this.m.Stacks + ")";
	}

	function isHidden()
	{
		return !::Tactical.isActive() || this.m.Stacks == 0 && !this.getContainer().getActor().isPlayerControlled();
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		local braveryMult = this.getBraveryMult();

		if (braveryMult != 1.0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(braveryMult) + "[决心值|Concept.Bravery]")
			});
		}

		local initiativeMult = this.getInitiativeMult();

		if (initiativeMult != 1.0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(initiativeMult) + "[主动值|Concept.Initiative]")
			});
		}

		local fatigueMult = this.getFatigueMult();

		if (fatigueMult != 1.0)
		{
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = ::Reforged.Mod.Tooltips.parseString("技能积累的[疲劳|Concept.Fatigue]减少" + ::MSU.Text.colorizeMult(fatigueMult, {
					InvertColor = true
				}) + " less [Fatigue|Concept.Fatigue]")
			});
		}

		local damageMult = this.getDamageMult();

		if (damageMult != 1.0)
		{
			ret.push({
				id = 13,
				type = "text",
				icon = "ui/icons/damage_dealt.png",
				text = "造成的伤害增加" + ::MSU.Text.colorizeMult(damageMult) + " more damage"
			});
		}

		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/warning.png",
			text = ::Reforged.Mod.Tooltips.parseString("会在[等待|Concept.Wait]时失去所有层数")
		});
		return ret;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.setStacks(0);
	}

	function onTurnEnd()
	{
		if (this.getContainer().getActor().isWaitActionSpent() == false)
		{
			this.setStacks(::Math.min(this.m.Stacks + 1, this.m.MaxStacks));
		}
	}

	function onWaitTurn()
	{
		this.setStacks(0);
	}

	function onUpdate( _properties )
	{
		_properties.BraveryMult *= this.getBraveryMult();
		_properties.InitiativeMult *= this.getInitiativeMult();
		_properties.DamageTotalMult *= this.getDamageMult();
		_properties.TargetAttractionMult *= this.getAttractionMult();
	}

	function onAfterUpdate( _properties )
	{
		local fatigueMult = this.getFatigueMult();

		if (fatigueMult != 1.0)
		{
			foreach( skill in this.getContainer().getAllSkillsOfType(::Const.SkillType.Active) )
			{
				skill.m.FatigueCostMult *= fatigueMult;
			}
		}
	}

	function setStacks( _stacks )
	{
		this.m.Stacks = _stacks;

		if (this.m.Stacks == 0)
		{
			this.m.IconMini = "";
		}
		else
		{
			this.m.IconMini = this.m.OriginalIconMini;
		}
	}

	function getBraveryMult()
	{
		return this.m.Stacks >= 1 ? this.m.BraveryMult : 1.0;
	}

	function getInitiativeMult()
	{
		return this.m.Stacks >= 1 ? this.m.InitiativeMult : 1.0;
	}

	function getFatigueMult()
	{
		return this.m.Stacks >= 2 ? this.m.FatigueCostMult : 1.0;
	}

	function getDamageMult()
	{
		return this.m.Stacks >= 3 ? this.m.DamageMult : 1.0;
	}

	function getAttractionMult()
	{
		return this.m.Stacks >= 3 ? this.m.AttractionMult : 1.0;
	}

});
