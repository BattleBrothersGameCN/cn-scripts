::Reforged.HooksMod.hook("scripts/ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar", function ( q )
{
	q.m.IsWaitingRound <- false;
	q.initNextTurn = function ( __original )
	{
		return {
			function initNextTurn( _force = false )
			{
				local activeEntity = this.getActiveEntity();

				if (activeEntity != null && activeEntity.m.IsWaitingTurn)
				{
					activeEntity.m.IsWaitingTurn = false;
					this.entityWaitTurn(activeEntity);
					return;
				}

				__original(_force);
			}

		}.initNextTurn;
	};
	q.initNextRound = function ( __original )
	{
		return {
			function initNextRound()
			{
				this.m.JSHandle.call("RF_setWaitTurnAllButtonVisible", true);
				this.m.IsWaitingRound = false;
				__original();
			}

		}.initNextRound;
	};
	q.canEntityWait = function ()
	{
		return {
			function canEntityWait( _entity )
			{
				return !_entity.isWaitActionSpent();
			}

		}.canEntityWait;
	};
	q.entityWaitTurn = function ()
	{
		return {
			function entityWaitTurn( _entity )
			{
				if (::Time.hasEventScheduled(::TimeUnit.Virtual) || ::Tactical.State.isPaused())
				{
					return;
				}

				local entity = this.findEntityByID(this.m.CurrentEntities, _entity.getID());

				if (entity != null)
				{
					if (!entity.entity.isWaitActionSpent())
					{
						if (_entity.getID() == this.m.CurrentEntities.top().getID())
						{
							_entity.wait();
							this.updateEntity(_entity.getID());
							return true;
						}

						this.initNextTurnBecauseOfWait();
						return true;
					}
				}

				return false;
			}

		}.entityWaitTurn;
	};
	q.convertEntityToUIData = function ( __original )
	{
		return {
			function convertEntityToUIData( _entity, isLastEntity = false )
			{
				local ret = __original(_entity, isLastEntity);
				local currentProperties = _entity.getCurrentProperties();
				local reach = currentProperties.getReach();
				local reachAtk = currentProperties.OffensiveReachIgnore;
				local reachDef = currentProperties.DefensiveReachIgnore;
				ret.morale = reach;
				ret.moraleMax = 15;
				ret.moraleLabel = reach + " (" + reachAtk + ", " + reachDef + ")";
				local isShowingValue = false;

				switch(::Reforged.Mod.ModSettings.getSetting("TacticalTooltip_Values").getValue())
				{
				case "All":
					isShowingValue = true;
					break;

				case "Player Only":
					isShowingValue = ::MSU.isKindOf(_entity, "player");
					break;

				case "AI Only":
					isShowingValue = !::MSU.isKindOf(_entity, "player");
					break;
				}

				if (!isShowingValue)
				{
					ret.armorHeadLabel <- ::Const.ArmorStateName[_entity.getArmorState(::Const.BodyPart.Head)];
					ret.armorBodyLabel <- ::Const.ArmorStateName[_entity.getArmorState(::Const.BodyPart.Body)];
					ret.fatigueLabel <- ::Const.FatigueStateName[_entity.getFatigueState()];
					ret.hitpointsLabel <- ::Const.HitpointsStateName[_entity.getHitpointsState()];
					ret.actionPointsLabel <- ::Const.RF_ActionPointsStateName[_entity.RF_getActionPointsState()];
				}

				return ret;
			}

		}.convertEntityToUIData;
	};
	q.convertEntityStatusEffectsToUIData = function ()
	{
		return {
			function convertEntityStatusEffectsToUIData( _entity )
			{
				if (!_entity.isPlayerControlled())
				{
					return null;
				}

				local result = [];

				foreach( statusEffect in _entity.getSkills().query(::Const.SkillType.StatusEffect | ::Const.SkillType.PermanentInjury, false, true) )
				{
					result.push({
						id = statusEffect.getID(),
						imagePath = statusEffect.getIcon()
					});
				}

				return result;
			}

		}.convertEntityStatusEffectsToUIData;
	};
	q.RF_onWaitTurnAllButtonPressed <- {
		function RF_onWaitTurnAllButtonPressed()
		{
			if (this.m.IsWaitingRound || this.getActiveEntity() == null || !this.getActiveEntity().isPlayerControlled())
			{
				return;
			}

			::Tactical.State.showDialogPopup("等待回合", "确定要让所有角色“等待”回合？", function ()
			{
				this.m.IsWaitingRound = true;
				this.m.JSHandle.call("RF_setWaitTurnAllButtonVisible", false);

				foreach( e in this.m.CurrentEntities )
				{
					if (e.isPlayerControlled())
					{
						e.setWaitTurn(true);
					}
				}

				local activeEntity = this.getActiveEntity();

				if (activeEntity != null && activeEntity.m.IsWaitingTurn)
				{
					activeEntity.m.IsWaitingTurn = false;
					this.entityWaitTurn(activeEntity);
					return;
				}
			}.bindenv(this), null);
		}

	}.RF_onWaitTurnAllButtonPressed;
});
