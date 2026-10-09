::Reforged.HooksMod.hook("scripts/states/world_state", function ( q )
{
	q.startNewCampaign = function ( __original )
	{
		return {
			function startNewCampaign()
			{
				__original();
				this.setAutoPause(false);
			}

		}.startNewCampaign;
	};
	q.startScriptedCombat = function ( __original )
	{
		return {
			function startScriptedCombat( _properties = null, _isPlayerInitiated = true, _isCombatantsVisible = true, _allowFormationPicking = true )
			{
				if (_properties != null)
				{
					foreach( entity in _properties.Entities )
					{
						if (("Name" in entity) && entity.Name != "")
						{
							entity.Name = ::buildTextFromTemplate(entity.Name, ::Const.World.Common.RF_getTroopNameTemplateVars(entity));
						}
					}
				}

				return __original(_properties, _isPlayerInitiated, _isCombatantsVisible, _allowFormationPicking);
			}

		}.startScriptedCombat;
	};
	q.onMouseInput = function ( __original )
	{
		return {
			function onMouseInput( _mouse )
			{
				local ret = __original(_mouse);

				if (ret == false)
				{
					if (!::MSU.isNull(this.m.EscortedEntity) && _mouse.getState() == 1 && !this.isInCameraMovementMode() && !this.m.WasInCameraMovementMode)
					{
						foreach( entity in ::World.getAllEntitiesAndOneLocationAtPos(::World.getCamera().screenToWorld(_mouse.getX(), _mouse.getY()), 1.0) )
						{
							if (!::MSU.isKindOf(entity, "settlement"))
							{
								continue;
							}

							if (!entity.isEnterable())
							{
								continue;
							}

							if (!entity.isAlliedWithPlayer())
							{
								continue;
							}

							if (this.m.Player.getDistanceTo(entity) <= 200)
							{
								this.enterLocation(entity);
								return true;
							}
						}
					}
				}

				return ret;
			}

		}.onMouseInput;
	};
});
