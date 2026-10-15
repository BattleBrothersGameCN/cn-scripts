::Reforged.HooksMod.hook("scripts/skills/actives/recover_skill", function ( q )
{
	q.m.HasMovedOrUsedSkill <- false;
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();
				ret.push({
					id = 20,
					type = "text",
					icon = "ui/icons/warning.png",
					text = ::Reforged.Mod.Tooltips.parseString("使你的[行动点数|Concept.ActionPoints]归" + ::MSU.Text.colorNegative(0) + "，并结束你的[回合|Concept.Turn]")
				});
				local warning = "无法在移动或使用过技能后使用";
				local colorNegative = this.m.HasMovedOrUsedSkill || !::MSU.isNull(this.getContainer()) && !::MSU.isNull(this.getContainer().getActor()) && this.getContainer().getActor().isPreviewing();
				ret.push({
					id = 21,
					type = "text",
					icon = "ui/icons/warning.png",
					text = colorNegative ? ::MSU.Text.colorNegative(warning) : warning
				});
				return ret;
			}

		}.getTooltip;
	};
	q.onUse = function ( __original )
	{
		return {
			function onUse( _user, _targetTile )
			{
				local ret = __original(_user, _targetTile);
				_user.m.IsTurnDone = true;
				_user.setActionPoints(0);
				return ret;
			}

		}.onUse;
	};
	q.getFatigueRecovered <- {
		function getFatigueRecovered()
		{
			return ::Math.ceil(this.getContainer().getActor().getFatigue() * 0.5);
		}

	}.getFatigueRecovered;
	q.onCostsPreview = function ( __original )
	{
		return {
			function onCostsPreview( _costsPreview )
			{
				__original(_costsPreview);

				if (::MSU.isEqual(this.getContainer().getActor().getPreviewSkill(), this))
				{
					_costsPreview.fatiguePreview -= this.getFatigueRecovered();
				}
			}

		}.onCostsPreview;
	};
	q.onAnySkillExecuted = function ( __original )
	{
		return {
			function onAnySkillExecuted( _skill, _targetTile, _targetEntity, _forFree )
			{
				__original(_skill, _targetTile, _targetEntity, _forFree);

				if (::Tactical.TurnSequenceBar.isActiveEntity(this.getContainer().getActor()))
				{
					this.m.HasMovedOrUsedSkill = true;
				}
			}

		}.onAnySkillExecuted;
	};
	q.onMovementStarted = function ( __original )
	{
		return {
			function onMovementStarted( _tile, _numTiles )
			{
				__original(_tile, _numTiles);

				if (::Tactical.TurnSequenceBar.isActiveEntity(this.getContainer().getActor()) && this.getContainer().getActor().m.CurrentMovementType == ::Const.Tactical.MovementType.Default)
				{
					this.m.HasMovedOrUsedSkill = true;
				}
			}

		}.onMovementStarted;
	};
	q.onTurnStart = function ( __original )
	{
		return {
			function onTurnStart()
			{
				__original();
				this.m.HasMovedOrUsedSkill = false;
			}

		}.onTurnStart;
	};
	q.onCombatFinished = function ( __original )
	{
		return {
			function onCombatFinished()
			{
				__original();
				this.m.HasMovedOrUsedSkill = false;
			}

		}.onCombatFinished;
	};
	q.isUsable = function ( __original )
	{
		return {
			function isUsable()
			{
				return !this.m.HasMovedOrUsedSkill && __original();
			}

		}.isUsable;
	};
	q.isAffordablePreview = function ( __original )
	{
		return {
			function isAffordablePreview()
			{
				return !this.getContainer().getActor().isPreviewing() && __original();
			}

		}.isAffordablePreview;
	};
});
