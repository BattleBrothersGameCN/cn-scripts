::Reforged.HooksMod.hook("scripts/ui/screens/world/world_town_screen", function ( q )
{
	q.RF_onContractRightClicked <- function ( _contractID )
	{
		if (this.isAnimating())
		{
			return;
		}

		foreach( c in ::World.Contracts.getOpenContracts() )
		{
			if (c.getID() == _contractID)
			{
				::World.Contracts.removeContract(c);
				::Sound.play("sounds/cloth_01.wav", ::MSU.Math.randf(0.9, 1.1), ::World.State.getPlayer().getPos(), ::MSU.Math.randf(0.9, 1.1));
				break;
			}
		}
	};
	q.onContractClicked = function ( __original )
	{
		return {
			function onContractClicked( _data )
			{
				if (this.isAnimating())
				{
					__original();
					return;
				}

				local n = ::Reforged.Mod.ModSettings.getSetting("AutoNegotiateAttempts").getValue();
				local skipTo = ::Reforged.Mod.ModSettings.getSetting("SkipContractsToScreen").getValue();

				if (n != 0 || skipTo != "Disabled")
				{
					foreach( c in ::World.Contracts.getOpenContracts() )
					{
						if (c.getID() != _data)
						{
							continue;
						}

						if (c.m.ActiveScreen.ID == "Overview")
						{
							break;
						}

						local hasNegotiationScreen = false;

						foreach( s in c.m.Screens )
						{
							if (s.ID == "Negotiation")
							{
								hasNegotiationScreen = true;
								break;
							}
						}

						if (!hasNegotiationScreen)
						{
							break;
						}

						if (skipTo == "Negotiation")
						{
							c.setScreen("概览");
						}

						if (n != 0)
						{
							c.RF_autoNegotiate(n);
						}

						if (skipTo == "Overview")
						{
							if (c.m.ActiveScreen.ID == "Negotiation")
							{
								c.setScreen(c.m.ActiveScreen.Options[0].getResult());
							}
							else if (c.m.ActiveScreen.ID != "Negotiation.Fail")
							{
								c.setScreen("概览");
								c.setScreen(c.m.ActiveScreen.Options[0].getResult());
							}
						}

						break;
					}
				}

				__original(_data);
			}

		}.onContractClicked;
	};
});
