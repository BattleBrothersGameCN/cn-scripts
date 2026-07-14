this.perk_rf_battle_fervor <- ::inherit("scripts/skills/skill", {
	m = {
		Stacks = 0,
		HasAttackedThisTurn = false,
		MaxStacks = 4,
		PctPerStack = 0.05
	},
	function create()
	{
		this.m.ID = "perk.rf_battle_fervor";
		this.m.Name = ::Const.Strings.PerkName.RF_BattleFervor;
		this.m.Description = "该角色会不惜一切代价去取得绝对胜利。";
		this.m.Icon = "ui/perks/perk_rf_battle_fervor.png";
		this.m.Overlay = "perk_rf_battle_fervor";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function getName()
	{
		return this.m.Stacks <= 1 ? this.m.Name : this.m.Name + " (x" + this.m.Stacks + ")";
	}

	function isHidden()
	{
		return this.m.Stacks == 0;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		local mult = this.RF_getMult();
		ret.extend([
			{
				id = 11,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(mult) + "[决心值|Concept.Bravery]")
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(mult) + "[近战技能|Concept.MeleeSkill]")
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(mult) + "[远程技能|Concept.RangeSkill]")
			},
			{
				id = 14,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(mult) + "[近战防御|Concept.MeleeDefense]")
			},
			{
				id = 15,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(mult) + "[远程防御|Concept.RangeDefense]")
			},
			{
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("效果会因失去[自信|Concept.Morale]士气而消失")
			}
		]);

		if (!this.m.HasAttackedThisTurn)
		{
			ret.push({
				id = 21,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("本[回合|Concept.Turn]结束时，若该角色没有进行过攻击，失去一层效果")
			});
		}

		return ret;
	}

	function onTurnStart()
	{
		this.m.HasAttackedThisTurn = false;

		if (this.m.Stacks == this.m.MaxStacks)
		{
			return;
		}

		local actor = this.getContainer().getActor();

		if (actor.getMoraleState() == ::Const.MoraleState.Confident && actor.checkMorale(0, ::Const.Morale.RallyBaseDifficulty))
		{
			this.m.Stacks++;
			this.spawnIcon(this.m.Overlay, actor.getTile());
		}
	}

	function onTurnEnd()
	{
		if (this.m.Stacks != 0 && !this.m.HasAttackedThisTurn)
		{
			this.m.Stacks--;
		}
	}

	function onAnySkillExecuted( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (_skill.isAttack())
		{
			this.m.HasAttackedThisTurn = true;
		}
	}

	function onUpdate( _properties )
	{
		if (this.getContainer().getActor().getMoraleState() != ::Const.MoraleState.Confident)
		{
			this.m.Stacks = 0;
			return;
		}

		local mult = this.RF_getMult();
		_properties.BraveryMult *= mult;
		_properties.MeleeSkillMult *= mult;
		_properties.RangedSkillMult *= mult;
		_properties.MeleeDefenseMult *= mult;
		_properties.RangedDefenseMult *= mult;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.Stacks = 0;
		this.m.HasAttackedThisTurn = false;
	}

	function RF_getMult()
	{
		return 1.0 + this.m.Stacks * this.m.PctPerStack;
	}

});
