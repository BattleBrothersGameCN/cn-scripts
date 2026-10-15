this.perk_rf_tempo <- ::inherit("scripts/skills/skill", {
	m = {
		RequiredWeaponType = ::Const.Items.WeaponType.Sword,
		Stacks = 0,
		HasCarriedOverInitiative = false,
		SkillCount = 0,
		LastTargetID = 0,
		APBonusThisTurn = 0,
		FatBonusThisTurn = 1.0
	},
	function create()
	{
		this.m.ID = "perk.rf_tempo";
		this.m.Name = ::Const.Strings.PerkName.RF_Tempo;
		this.m.Description = "该角色靠先发制人在战斗中积累起了优势。";
		this.m.Icon = "ui/perks/perk_rf_tempo.png";
		this.m.IconMini = "perk_rf_tempo_mini";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function getName()
	{
		return this.m.Stacks == 0 ? this.m.Name : this.m.Name + " (x" + this.m.Stacks + ")";
	}

	function isHidden()
	{
		return this.m.Stacks == 0 || !this.isEnabled();
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		local initiativeBonus = this.getInitiativeModifier();

		if (initiativeBonus != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(initiativeBonus, {
					AddSign = true
				}) + "点[主动值|Concept.Initiative]")
			});
		}

		if (this.m.APBonusThisTurn != 0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.APBonusThisTurn, {
					AddSign = true
				}) + "点[行动点数|Concept.ActionPoints]")
			});
		}

		if (this.m.FatBonusThisTurn != 1.0)
		{
			local startString = this.m.RequiredWeaponType == null ? "攻击" : ::Const.Items.getWeaponTypeName(this.m.RequiredWeaponType) + "攻击";
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = ::Reforged.Mod.Tooltips.parseString(startString + "积累的[疲劳|Concept.Fatigue]" + ::MSU.Text.colorizeMultWithText(this.m.FatBonusThisTurn, {
					InvertColor = true
				}) + " [Fatigue|Concept.Fatigue]")
			});
		}

		if (this.m.HasCarriedOverInitiative)
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("从上[回合中|Concept.Turn]继承的[主动值|Concept.Initiative]会在使用技能、[等待|Concept.Wait]或是结束[回合|Concept.Turn]后失效")
			});
		}
		else
		{
			local nextTurnBonus = [];

			if (this.getAPModifier() != 0)
			{
				nextTurnBonus.push({
					id = 13,
					type = "text",
					icon = "ui/icons/action_points.png",
					text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.getAPModifier(), {
						AddSign = true
					}) + "[行动点数|Concept.ActionPoints]")
				});
			}

			if (this.getFatigueCostMultMult() != 1.0)
			{
				local startString = this.m.RequiredWeaponType == null ? "攻击" : ::Const.Items.getWeaponTypeName(this.m.RequiredWeaponType) + "攻击";
				nextTurnBonus.push({
					id = 13,
					type = "text",
					icon = "ui/icons/fatigue.png",
					text = ::Reforged.Mod.Tooltips.parseString(startString + "积累的[疲劳|Concept.Fatigue]" + ::MSU.Text.colorizeMultWithText(this.getFatigueCostMultMult(), {
						InvertColor = true
					}) + " [Fatigue|Concept.Fatigue]")
				});
			}

			if (nextTurnBonus.len() != 0)
			{
				ret.push({
					id = 13,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("下[回合|Concept.Turn]中："),
					children = nextTurnBonus
				});
			}
		}

		return ret;
	}

	function getInitiativeModifier()
	{
		return this.m.Stacks * 15;
	}

	function getAPModifier()
	{
		return ::Math.floor(this.m.Stacks * 0.5);
	}

	function getFatigueCostMultMult()
	{
		return ::Math.maxf(0.0, 1.0 - this.m.Stacks * 0.05);
	}

	function gainStackIfApplicable( _skill, _targetEntity )
	{
		if (!::Tactical.TurnSequenceBar.isActiveEntity(this.getContainer().getActor()))
		{
			return;
		}

		if (this.m.HasCarriedOverInitiative)
		{
			this.m.Stacks = 0;
			this.m.HasCarriedOverInitiative = false;
		}

		if (this.m.SkillCount == ::Const.SkillCounter && this.m.LastTargetID == _targetEntity.getID())
		{
			return;
		}

		this.m.SkillCount = ::Const.SkillCounter;
		this.m.LastTargetID = _targetEntity.getID();
		this.m.Stacks++;
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		if (this.isSkillValid(_skill))
		{
			this.gainStackIfApplicable(_skill, _targetEntity);
		}
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		if (this.isSkillValid(_skill))
		{
			this.gainStackIfApplicable(_skill, _targetEntity);
		}
	}

	function onEquip( _item )
	{
		if (this.m.RequiredWeaponType == null || !_item.isItemType(::Const.Items.ItemType.Weapon))
		{
			return;
		}

		if (!_item.isWeaponType(this.m.RequiredWeaponType))
		{
			this.m.Stacks = 0;
			this.m.HasCarriedOverInitiative = false;
		}
	}

	function onUpdate( _properties )
	{
		if (this.isEnabled())
		{
			_properties.Initiative += this.getInitiativeModifier();
			_properties.ActionPoints += this.m.APBonusThisTurn;
		}
	}

	function onAfterUpdate( _properties )
	{
		if (!this.isEnabled())
		{
			return;
		}

		foreach( s in this.m.RequiredWeaponType != null ? this.getContainer().getActor().getMainhandItem().getSkills() : this.getContainer().getAllSkillsOfType(::Const.SkillType.Active) )
		{
			if (this.isSkillValid(s))
			{
				s.m.FatigueCostMult *= this.m.FatBonusThisTurn;
			}
		}
	}

	function onTurnStart()
	{
		if (this.m.Stacks > 0)
		{
			this.m.HasCarriedOverInitiative = true;
		}

		this.m.APBonusThisTurn = this.getAPModifier();
		local actor = this.getContainer().getActor();
		actor.setActionPoints(actor.getActionPoints() + this.m.APBonusThisTurn);
		this.m.FatBonusThisTurn = this.getFatigueCostMultMult();
	}

	function onTurnEnd()
	{
		if (this.m.HasCarriedOverInitiative)
		{
			this.m.Stacks = 0;
			this.m.HasCarriedOverInitiative = false;
		}
	}

	function onWaitTurn()
	{
		if (this.m.HasCarriedOverInitiative)
		{
			this.m.Stacks = 0;
			this.m.HasCarriedOverInitiative = false;
		}
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.Stacks = 0;
		this.m.HasCarriedOverInitiative = false;
		this.m.APBonusThisTurn = 0;
		this.m.FatBonusThisTurn = 1.0;
	}

	function isSkillValid( _skill )
	{
		if (_skill.isRanged() || !_skill.isAttack())
		{
			return false;
		}

		if (this.m.RequiredWeaponType == null)
		{
			return true;
		}

		local weapon = _skill.getItem();
		return !::MSU.isNull(weapon) && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(this.m.RequiredWeaponType);
	}

	function isEnabled()
	{
		if (this.m.RequiredWeaponType == null)
		{
			return true;
		}

		if (this.getContainer().getActor().isDisarmed())
		{
			return false;
		}

		local weapon = this.getContainer().getActor().getMainhandItem();
		return weapon != null && weapon.isWeaponType(this.m.RequiredWeaponType);
	}

});
