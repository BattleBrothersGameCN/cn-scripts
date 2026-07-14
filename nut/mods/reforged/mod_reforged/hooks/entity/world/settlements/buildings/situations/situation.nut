::Reforged.HooksMod.hook("scripts/entity/world/settlements/situations/situation", function ( q )
{
	q.m.RF_LastVisitContracts <- [];
	q.m.RF_Settlement <- null;
	q.getName = function ( __original )
	{
		return {
			function getName()
			{
				if (::MSU.isNull(this.m.RF_Settlement))
				{
					return __original();
				}

				local myID = this.getID();
				local hasAgent = ::World.Retinue.hasFollower("follower.agent");
				local situations = hasAgent || ::MSU.isEqual(::World.State.getCurrentTown(), this.m.RF_Settlement) ? this.m.RF_Settlement.getSituations() : this.m.RF_Settlement.m.RF_LastVisitSituations;
				local num = situations.filter(function ( _, _s )
				{
					return _s.getID() == myID;
				}).len();
				return num == 1 ? __original() : this.format("%s (x%i)", __original(), num);
			}

		}.getName;
	};
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				if (::MSU.isNull(this.m.RF_Settlement))
				{
					return __original();
				}

				local ret = __original();
				local hasAgent = ::World.Retinue.hasFollower("follower.agent");
				local isPlayerAtSettlement = hasAgent || ::MSU.isEqual(::World.State.getCurrentTown(), this.m.RF_Settlement);
				local situations = isPlayerAtSettlement ? this.m.RF_Settlement.getSituations() : this.m.RF_Settlement.m.RF_LastVisitSituations;
				local myID = this.getID();
				local stackedSituations = situations.filter(function ( _, _s )
				{
					return _s.getID() == myID;
				});
				local contracts;

				if (isPlayerAtSettlement)
				{
					local stackedSituationIDs = stackedSituations.map(function ( _s )
					{
						return _s.getInstanceID();
					});
					contracts = ::World.Contracts.getOpenContracts().filter(function ( _, _c )
					{
						return stackedSituationIDs.find(_c.getSituationID()) != null;
					});

					if (!hasAgent)
					{
						contracts.filter(function ( _, _c )
						{
							return _c.isStarted();
						});
					}

					  // [070]  OP_CLOSE          0      8    0    0
				}
				else
				{
					contracts = this.m.RF_LastVisitContracts;
				}

				foreach( c in contracts )
				{
					ret.push({
						id = 20,
						type = "hint",
						icon = c.RF_getTooltipIcon(),
						text = ::Reforged.Mod.Tooltips.parseString(::Reforged.NestedTooltips.getNestedObjectName(c, "func:RF_getTooltip,contentType:settlement-status-effect"))
					});
				}

				stackedSituations.sort(function ( _s1, _s2 )
				{
					return -1 * (_s1.getValidUntil()  _s2.getValidUntil());
				});

				foreach( i, s in stackedSituations )
				{
					if (s.m.RF_LastVisitContracts.len() == 0 && s.getValidUntil() != 0)
					{
						local d = s.RF_getDaysRemaining();
						local str;

						if (d <= 0)
						{
							str = this.format("Is likely %s by now", stackedSituations.len() == 1 || contracts.len() == 0 && i == 0 ? "finished" : "partially resolved");
						}
						else
						{
							str = this.format("Is expected to %s " + ::Reforged.Text.getDaysRemainingText(d), stackedSituations.len() == 1 || contracts.len() == 0 && i == 0 ? "last" : "be partially resolved in");
						}

						ret.push({
							id = 21,
							type = "hint",
							icon = "ui/icons/action_points.png",
							text = str
						});

						if (d <= 0)
						{
							break;
						}
					}
				}

				return ret;
			}

		}.getTooltip;
	};
	q.RF_getDaysRemaining <- {
		function RF_getDaysRemaining()
		{
			return (this.getValidUntil() - ::Time.getVirtualTimeF()) / ::World.getTime().SecondsPerDay;
		}

	}.RF_getDaysRemaining;
});
