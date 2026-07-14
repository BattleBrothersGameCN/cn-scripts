this.rf_move_under_cover_skill <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.rf_move_under_cover";
		this.m.Name = "掩护下移动";
		this.m.Description = ::Reforged.Mod.Tooltips.parseString("利用举盾盟友提供的掩护，无视[控制区|Concept.ZoneOfControl]，移动1格距离而不触发借机攻击。");
		this.m.Icon = "skills/rf_move_under_cover_skill.png";
		this.m.IconDisabled = "skills/rf_move_under_cover_skill_sw.png";
		this.m.Overlay = "rf_move_under_cover_skill";
		this.m.SoundOnUse = [
			"sounds/combat/footwork_01.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsDisengagement = true;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 0;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.MaxLevelDifference = 1;
	}

	function getActionPointCost()
	{
		return ::Math.max(0, this.skill.getActionPointCost());
	}

	function getCostString()
	{
		if (this.getContainer().getActor().isPlacedOnMap())
		{
			return this.skill.getCostString();
		}

		local ret = "比起常规的移动消耗，消耗" + (this.m.ActionPointCost == 0 ? "+0" : ::MSU.Text.colorizeValue(this.m.ActionPointCost, {
			AddSign = true,
			InvertColor = true
		})) + "点[行动点数|Concept.ActionPoints]，积累的[疲劳值|Concept.Fatigue]";
		ret = ret + ((this.m.FatigueCost == 0 ? "+0" : ::MSU.Text.colorizeValue(this.m.FatigueCost, {
			AddSign = true,
			InvertColor = true
		})) + "点[疲劳|Concept.Fatigue]，相较于起始地格的移动消耗计算");
		return ::Reforged.Mod.Tooltips.parseString(ret);
	}

	function getTooltip()
	{
		return this.getDefaultUtilityTooltip();
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();

		if (actor.isPlayerControlled())
		{
			return;
		}

		local weapon = actor.getMainhandItem();

		if (weapon == null)
		{
			return;
		}

		if (weapon.isItemType(::Const.Items.ItemType.RangedWeapon) || weapon.m.RangeMax == 2)
		{
			if (actor.getAIAgent().findBehavior(::Const.AI.Behavior.ID.Disengage) == null)
			{
				actor.getAIAgent().addBehavior(::new("scripts/ai/tactical/behaviors/ai_disengage"));
				actor.getAIAgent().finalizeBehaviors();
			}
		}
		else if (actor.getAIAgent().findBehavior(::Const.AI.Behavior.ID.RF_PassingStep) == null)
		{
			actor.getAIAgent().addBehavior(::new("scripts/ai/tactical/behaviors/ai_rf_passing_step"));
			actor.getAIAgent().finalizeBehaviors();
		}
	}

	function isUsable()
	{
		if (this.skill.isUsable())
		{
			local myTile = this.getContainer().getActor().getTile();

			for( local i = 0; i < 6; i++ )
			{
				if (myTile.hasNextTile(i))
				{
					local nextTile = myTile.getNextTile(i);

					if (!nextTile.IsOccupiedByActor)
					{
						return true;
					}
				}
			}
		}

		return false;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return this.skill.onVerifyTarget(_originTile, _targetTile) && _targetTile.IsEmpty;
	}

	function onAfterUpdate( _properties )
	{
		local actor = this.getContainer().getActor();

		if (!actor.isPlacedOnMap())
		{
			return;
		}

		local myTile = actor.getTile();
		this.m.ActionPointCost += actor.getActionPointCosts()[myTile.Type];
		this.m.FatigueCost += actor.getFatigueCosts()[myTile.Type];
	}

	function onUse( _user, _targetTile )
	{
		::Tactical.getNavigator().teleport(_user, _targetTile, null, null, false);
		this.removeSelf();
		return true;
	}

});
