this.rf_dynamic_duo_shuffle_skill <- ::inherit("scripts/skills/skill", {
	m = {
		DynamicDuoPerk = null,
		IsSpent = false
	},
	function create()
	{
		this.m.ID = "actives.rf_dynamic_duo_shuffle";
		this.m.Name = "双人舞";
		this.m.Description = ::Reforged.Mod.Tooltips.parseString("每回合一次，和搭档免费换位，任一方被[$ $|Skill+stunned_effect]或定身时无法使用。");
		this.m.Icon = "skills/rf_dynamic_duo_shuffle_skill.png";
		this.m.IconDisabled = "skills/rf_dynamic_duo_shuffle_skill_sw.png";
		this.m.Overlay = "rf_dynamic_duo_shuffle_skill";
		this.m.SoundOnUse = [
			"sounds/combat/rotation_01.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = 1;
		this.m.FatigueCost = 2;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
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

		local ret = "相比在初始地格上进行通常移动，消耗的[行动点数|Concept.ActionPoints]" + (this.m.ActionPointCost == 0 ? "+0" : ::MSU.Text.colorizeValue(this.m.ActionPointCost, {
			AddSign = true,
			InvertColor = true
		})) + "点[行动点数|Concept.ActionPoints]，并积累";
		ret = ret + ((this.m.FatigueCost == 0 ? "+0" : ::MSU.Text.colorizeValue(this.m.FatigueCost, {
			AddSign = true,
			InvertColor = true
		})) + "点[疲劳|Concept.Fatigue]，相较于起始地格的移动消耗计算");
		return ::Reforged.Mod.Tooltips.parseString(ret);
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		local actor = this.getContainer().getActor();
		local partner = ::MSU.isNull(this.m.DynamicDuoPerk) ? null : this.m.DynamicDuoPerk.getPartner();

		if (::MSU.isNull(partner))
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::MSU.Text.colorNegative("需要一名搭档")
			});
		}
		else
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "搭档：" + partner.getName()
			});
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("和你的搭档交换位置，将对方置于[回合|Concept.Turn]顺序的下一位")
			});

			if (actor.isPlacedOnMap())
			{
				if (!partner.isPlacedOnMap())
				{
					ret.push({
						id = 20,
						type = "text",
						icon = "ui/tooltips/warning.png",
						text = ::MSU.Text.colorNegative("需要搭档出现在战场上")
					});
				}
				else if (actor.getTile().getDistanceTo(partner.getTile()) != 1)
				{
					ret.push({
						id = 21,
						type = "text",
						icon = "ui/tooltips/warning.png",
						text = ::MSU.Text.colorNegative("需要搭档在你旁边")
					});
				}
			}
		}

		if (actor.getCurrentProperties().IsRooted)
		{
			ret.push({
				id = 22,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::MSU.Text.colorNegative("被定身时无法使用")
			});
		}

		if (this.m.IsSpent)
		{
			ret.push({
				id = 23,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("每[回合|Concept.Turn]限一次"))
			});
		}

		return ret;
	}

	function getCursorForTile( _tile )
	{
		return ::Const.UI.Cursor.Rotation;
	}

	function isUsable()
	{
		if (this.m.IsSpent || this.getContainer().getActor().getCurrentProperties().IsRooted || !this.skill.isUsable())
		{
			return false;
		}

		local partner = this.m.DynamicDuoPerk.getPartner();

		if (::MSU.isNull(partner) || !partner.isPlacedOnMap())
		{
			return false;
		}

		local actor = this.getContainer().getActor();
		return actor.isPlacedOnMap() && actor.getTile().getDistanceTo(partner.getTile()) == 1;
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

	function onTurnStart()
	{
		this.m.IsSpent = false;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.IsSpent = false;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!_targetTile.IsOccupiedByActor)
		{
			return false;
		}

		local target = _targetTile.getEntity();

		if (this.m.DynamicDuoPerk.getPartner().getID() != target.getID() || !target.isAlliedWith(this.getContainer().getActor()))
		{
			return false;
		}

		local tp = target.getCurrentProperties();

		if (tp.IsStunned || tp.IsRooted || !tp.IsMovable || tp.IsImmuneToRotation)
		{
			return false;
		}

		return this.skill.onVerifyTarget(_originTile, _targetTile);
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		::Tactical.getNavigator().switchEntities(_user, target, null, null, 1.0);
		::Tactical.TurnSequenceBar.moveEntityToFront(target.getID());
		this.m.IsSpent = true;
		return true;
	}

});
