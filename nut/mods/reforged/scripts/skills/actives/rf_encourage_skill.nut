this.rf_encourage_skill <- ::inherit("scripts/skills/skill", {
	m = {
		EncourageBonusFraction = 0.5,
		IsSpent = false
	},
	function create()
	{
		this.m.ID = "actives.rf_encourage";
		this.m.Name = "激励";
		this.m.Description = ::Reforged.Mod.Tooltips.parseString("激励队友，提升其[士气|Concept.Morale]。不能对[溃逃|Concept.Morale]或[昏迷|Skill+stunned_effect]的友军使用。");
		this.m.Icon = "ui/perks/perk_28_active.png";
		this.m.IconDisabled = "ui/perks/perk_28_active_sw.png";
		this.m.Overlay = "perk_28_active";
		this.m.SoundOnUse = [
			"sounds/combat/inspire_01.wav",
			"sounds/combat/inspire_02.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		local actualResolveBonus = "";

		if (this.getContainer().getActor().getID() != ::MSU.getDummyPlayer().getID())
		{
			actualResolveBonus = " (" + ::MSU.Text.colorizeValue(this.getEncourageBonus(), {
				AddSign = true
			}) + ")";
		}

		ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = ::Reforged.Mod.Tooltips.parseString(this.format("使目标触发一次加值为你[决心|Concept.Bravery]%s%s的正面[士气检定|Concept.Morale]", ::MSU.Text.colorizePct(this.m.EncourageBonusFraction), actualResolveBonus))
			},
			{
				id = 15,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "技能范围为" + ::MSU.Text.colorPositive(this.getMaxRange()) + "格"
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("只能对与你同一阵营，且[士气|Concept.Morale]低于你的角色使用。目标离你每远一格，士气就要低你一级")
			}
		]);

		if (this.m.IsSpent)
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("每[回合|Concept.Turn]限一次")
			});
		}

		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local target = _targetTile.getEntity();

		if (target.getCurrentProperties().IsStunned || target.getMoraleState() == ::Const.MoraleState.Fleeing || target.getMoraleState() >= ::Const.MoraleState.Confident || target.getMoraleState() >= target.m.MaxMoraleState)
		{
			return false;
		}

		local actor = this.getContainer().getActor();
		return actor.getFaction() == target.getFaction() && actor.getMoraleState() - target.getMoraleState() >= actor.getTile().getDistanceTo(target.getTile());
	}

	function isUsable()
	{
		return !this.m.IsSpent && this.skill.isUsable();
	}

	function onUse( _user, _targetTile )
	{
		_targetTile.getEntity().checkMorale(1, this.getEncourageBonus(), ::Const.MoraleCheckType.Default);
		this.m.IsSpent = true;
		return true;
	}

	function onTurnStart()
	{
		this.m.IsSpent = false;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.IsSpent = false;
	}

	function getEncourageBonus()
	{
		local encourageBonus = this.getContainer().getActor().getCurrentProperties().getBravery() * this.m.EncourageBonusFraction;
		return ::Math.max(0, encourageBonus);
	}

});
