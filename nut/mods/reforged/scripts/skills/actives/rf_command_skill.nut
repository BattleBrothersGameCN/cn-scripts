this.rf_command_skill <- ::inherit("scripts/skills/skill", {
	m = {
		ActionPointsRecovered = 1
	},
	function create()
	{
		this.m.ID = "actives.rf_command";
		this.m.Name = "发号施令";
		this.m.Description = "命令一名盟友立即行动！\n不能用于溃逃或昏迷的盟友。";
		this.m.Icon = "skills/rf_command_skill.png";
		this.m.IconDisabled = "skills/rf_command_skill_sw.png";
		this.m.Overlay = "rf_command_skill";
		this.m.SoundOnUse = [];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
		this.m.AIBehaviorID = ::Const.AI.Behavior.ID.RF_Command;
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = ::Reforged.Mod.Tooltips.parseString("将目标移动到[回合|Concept.Turn]行动序列的下一位")
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = ::Reforged.Mod.Tooltips.parseString("目标恢复" + ::MSU.Text.colorPositive(this.m.ActionPointsRecovered) + "点[行动点数|Concept.ActionPoints]")
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "技能范围为" + ::MSU.Text.colorPositive(this.getMaxRange()) + "格"
			}
		]);
		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local target = _targetTile.getEntity();

		if (this.m.Container.getActor().getFaction() != target.getFaction())
		{
			return false;
		}

		if (target.isTurnDone())
		{
			return false;
		}

		if (target.getCurrentProperties().IsStunned)
		{
			return false;
		}

		if (target.getMoraleState() == ::Const.MoraleState.Fleeing)
		{
			return false;
		}

		if (target.getSkills().hasSkill("effects.rf_commanded"))
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		::Tactical.TurnSequenceBar.moveEntityToFront(target.getID());

		if (!_user.isHiddenToPlayer())
		{
			local logText = ::Const.UI.getColorizedEntityName(_user) + "使出了发号施令";

			if (!target.isHiddenToPlayer())
			{
				logText = logText + ("对" + ::Const.UI.getColorizedEntityName(target));
			}

			::Tactical.EventLog.log(logText);
		}

		local recoveredActionPoints = ::Math.min(target.getActionPointsMax() - target.getActionPoints(), this.m.ActionPointsRecovered);

		if (recoveredActionPoints != 0)
		{
			target.setActionPoints(target.getActionPoints() + recoveredActionPoints);

			if (!target.isHiddenToPlayer())
			{
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(target) + "恢复了" + ::MSU.Text.colorPositive(recoveredActionPoints) + "点行动点数");
			}
		}

		target.getSkills().add(::new("scripts/skills/effects/rf_commanded_effect"));
		this.spawnIcon("rf_command_effect", _targetTile);
		return true;
	}

});
