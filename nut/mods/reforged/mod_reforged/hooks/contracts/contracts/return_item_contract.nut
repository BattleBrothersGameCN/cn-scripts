::Reforged.HooksMod.hook("scripts/contracts/contracts/return_item_contract", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Name = "找回被盗物品";
			}

		}.create;
	};
	q.createStates = function ( __original )
	{
		return {
			function createStates()
			{
				__original();

				foreach( state in this.m.States )
				{
					if (state.ID != "Offer")
					{
						continue;
					}

					local end = state.end;
					state.end = function ()
					{
						end();
						this.Contract.m.Target.setMovementSpeed(this.Contract.m.Target.getBaseMovementSpeed() * 0.9);
					};
					  // [016]  OP_CLOSE          0      5    0    0
					break;
					  // [018]  OP_CLOSE          0      5    0    0
				}
			}

		}.createStates;
	};
	q.createScreens = function ( __original )
	{
		return {
			function createScreens()
			{
				__original();

				foreach( screen in this.m.Screens )
				{
					if (screen.ID != "CounterOffer1")
					{
						continue;
					}

					foreach( option in screen.Options )
					{
						if (option.Text != "We\'re paid to return it, and that\'s what we\'ll do.")
						{
							continue;
						}

						option.Text = "We\'re paid %reward_completion% to return it, and that\'s what we\'ll do.";
						break;
					}

					break;
				}
			}

		}.createScreens;
	};
	q.onPrepareVariables = function ( __original )
	{
		return {
			function onPrepareVariables( _vars )
			{
				__original(_vars);

				foreach( var in _vars )
				{
					if (var[0] != "bribe")
					{
						continue;
					}

					var[1] = "[b]" + var[1] + "[/b]";
					break;
				}
			}

		}.onPrepareVariables;
	};
	q.RF_getOriginText = function ()
	{
		return {
			function RF_getOriginText()
			{
				return ::Reforged.Mod.Tooltips.parseString(this.format("Follow the thieves\' tracks around %s", ::MSU.isEqual(::World.State.getCurrentTown(), this.getHome()) ? "here" : ::Reforged.NestedTooltips.getNestedWorldEntityName(this.getHome())));
			}

		}.RF_getOriginText;
	};
});
